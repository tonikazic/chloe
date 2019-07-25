% this is ../c/maize/demeter/code/demeter_utilities.pl
%
% a collection of utility predicates swiped from Moirai, The Agora, and BND
% for use in Demeter, simplifying the need for cross-compilation of those
% other systems.
%
% When predicates of the same syntax and semantics are present in swipl, I
% have migrated to those.
%
% This code is adapted for swipl and more portability across platforms.
%
%
% Kazic, 27.3.2018



% all tested locally
%
% Kazic, 28.3.2018


%declarations%

:-       module(demeter_utilities,[
                append_to_planning_file/2,
		check_slash/2,
		construct_date/2,
		construct_dates/2,
                construct_time/2,
		convert_date/3,
		convert_dates/2,
		get_date_from_timestamp/2,
		get_timestamp/3,
                later/2,
                latest/2,
		letter/2,
		load_crop_planning_data/1,
		local_timestamp_n_date/2,
		lower_case_letters/1,
		lp_subseq/3,
		next_day/2,
		nice_date/2,    
		our_date/1,
		our_to_swi_date/2,
                remove_singletons/3,
		row_length/2,
		split_at_key/4,
		split_at_key_op/5,
		swi_date/1,
		swi_to_our_date/2,
		upper_case_letters/1,
		utc_rounded_timestamp/1,
		utc_timestamp/1,
		utc_timestamp_n_date/2,
		write_fact/1,
		write_fact/2,		
		write_list/1,
		write_list/2,
                write_list_facts/1,
		write_list_facts/2,
		yesterday/2

                ]).




    


% this is the swipl module, not the quintus module; but now reverse/2 seems to be a built-in
%    
% :- use_module(library(lists)).
    

%end%







%%%% from code_tree('code/utility/nutil'):


write_list([]).
write_list([H|T]) :-
	format('~w ~n',[H]),
	write_list(T).



% to write to a specific stream Kazic 2.5.1995.

write_list(_,[]).
write_list(Stream,[H|T]) :-
	format(Stream,'~w~n',[H]),
	write_list(Stream,T).




% in case the formulated facts don't have periods!
%
% Kazic, 21.2.2009

write_list_facts(_,[]).
write_list_facts(Stream,[H|T]) :-
        format(Stream,'~q.~n',[H]),
	write_list_facts(Stream,T).



write_list_facts([]).
write_list_facts([H|T]) :-
        format('~q.~n',[H]),
	write_list_facts(T).





write_fact([]).
write_fact([H|T]) :-
	(ground(H) ->
	    format('~q. ~n',[H])
	;
	    true
	),
	write_fact(T).





% to write to a specific stream Kazic 2.5.1995.

write_fact(_,[]).
write_fact(Stream,[H|T]) :-
	(ground(H) ->
	    format(Stream,'~q.~n',[H])
	;
	    true
	),
	write_fact(Stream,T).








%%%% from agora_tree('code/utilities/agora_utilities'):

% check for trailing slash and add it if needed
%
% rewritten to use SWI sub_atom/5, and tested
%
% Kazic, 27.3.2018


check_slash(Dir,FullDir) :-
        ( sub_atom(Dir,_,1,0,'/') ->
	        FullDir = Dir
	;	
                atom_concat(Dir,'/',FullDir)
	).	









%%%% recreation of predicates from (agora_tree('code/manage/track/utc'):
%
% SWI prolog has a number of datetime utilities built in, but renders
% the timestamp as a floating point number.  This is not quite the Quintus
% date library behavior.  But the Unix 32 bit timestamp will run out of
% range on 19 January, 2038 03:14:08 UTC (see
% https://en.wikipedia.org/wiki/Unix_time), which is only 20 years from now!
%
% So what to do?  Following the instructions at
% https://stackoverflow.com/questions/1204669/how-can-i-generate-unix-timestamps,
%
% $ date +%s
% 1522189945
%
% and swipl gives
% ?- get_time(X).
% X = 1522189949.63075.
%
% ?- get_time(X), Y is X*1000000, A is rational(Y).
% X = 1522190056.932839,
% Y = 1.522190056932839e+15,
% A = 1522190056932839.
%
%
% Since the timestamp is used to either label or is just output, the two
% functions are separated, and the format strings are changed from ~d or ~w
% (will handle both integers and decimals).
%
% Kazic, 27.3.2018





% these are really UTC timestamps, as they''re computed from the epoch (which is
% relative to UTC). 16 digits long.


utc_rounded_timestamp(TimeStamp) :-
        get_time(FloatingPtTimeStamp),
        Rounded is FloatingPtTimeStamp*1000000,
	TimeStamp is rational(Rounded).



utc_timestamp(FloatingPtTimeStamp) :-
        get_time(FloatingPtTimeStamp).


utc_timestamp_n_date(TimeStamp,EquivalentUTCDateTime) :-
        get_time(TimeStamp),
	stamp_date_time(TimeStamp,DateStruc,'UTC'),
        format_time(atom(EquivalentUTCDateTime),'%A, %B %d, %Y at %H:%M:%S UTC',DateStruc).


local_timestamp_n_date(TimeStamp,LocalDateTime) :-
        get_time(TimeStamp),
        format_time(atom(LocalDateTime),'%A, %B %d, %Y at %H:%M:%S %Z',TimeStamp).







%%%% more date/time stuff, simplifying from quintus to swi

% https://quintus.sics.se/isl/quintus/html/quintus/lib-mis-date.html#lib-mis-date
%
% quintus has date(Day,Month,Year) and SWI has date(Year,Month,Day).
%
% quintus has funny ranges, counting months from 0 and
% years from this_year - 1900.  We and SWI agree, however.
% So most of our old compatibility stuff won''t be needed!
%
% now modified for swipl and includes checks for argument order
%
% Kazic, 27.3.2018


get_timestamp(date(Day,Mon,Yr),time(Hr,Min,Sec),TimeStamp) :-
        ( our_date(date(Day,Mon,Yr)) ->
	        date_time_stamp(date(Yr,Mon,Day,Hr,Min,Sec,_,local,_),TimeStamp)
	;
                swi_date(date(Day,Mon,Yr)),
	        date_time_stamp(date(Day,Mon,Yr,Hr,Min,Sec,_,local,_),TimeStamp)
	).


        	        



% kinda the inverse of get_timestamp/3, but no time

get_date_from_timestamp(TimeStamp,date(Day,Mon,Yr)) :-
        stamp_date_time(TimeStamp,date(Yr,Mon,Day,_,_,_,_,_,_),local).










% supersedes convert_datetime/2.
%
% may be faster to further unroll the functor testing and assignment into a separate
% predicate, but prefer this declaratively. Note that if the input list mixes
% key types, then so will the output list.
%
% Kazic, 8.4.2018

convert_dates([],[]).
convert_dates([Date-Key-Datum|Data],[TimeStamp-NewDatum|Converted]) :-
        ( functor(Key,time,3) ->
                convert_date(Date,Key,TimeStamp),
                NewDatum = Datum
        ;
                get_timestamp(Date,time(12,0,0),TimeStamp),
                NewDatum = Key-Datum
        ),
        convert_dates(Data,Converted).






convert_dates([Date-Datum|Data],[TimeStamp-Datum|Converted]) :-
        convert_date(Date,time(12,0,0),TimeStamp),
        convert_dates(Data,Converted).






% assume the time is local noon unless otherwise specified

convert_date(Date,Time,TimeStamp) :-
        ( nonvar(Time) ->
                functor(Time,time,3),
	        get_timestamp(Date,Time,TimeStamp)
	;
                get_timestamp(Date,time(12,0,0),TimeStamp)
	).















% make the date the way I like to see it, but make sure date/3
% isn''t in swipl syntax date(Yr,Mon,Day)

construct_dates([],[]).
construct_dates([Date|Dates],[EasyDate|EasyDates]) :-
        construct_date(Date,EasyDate),
        construct_dates(Dates,EasyDates).




construct_date(date(Day,Mon,_),EasyDate) :-
        Day < 32,
        atomic_list_concat([Day,'.',Mon],EasyDate).







construct_time(time(Hour,Min,_),EasyTime) :-
        atomic_list_concat([Hour,':',Min],EasyTime).




swi_date(date(Yr,_,Day)) :-
        Day < 32,
	Yr > 1900.



our_date(date(Day,_,Yr)) :-
        Day < 32,
	Yr > 1900.


swi_to_our_date(date(Yr,Mon,Day),date(Day,Mon,Yr)) :-
        Day < 32,
	Yr > 1900.

our_to_swi_date(date(Day,Mon,Yr),date(Yr,Mon,Day)) :-
        Day < 32,
	Yr > 1900.











%%%% moved from genetic_utilities.pl


% converted to swipl, including check for argument order in date/2
%
% Kazic, 28.3.2018

yesterday(date(Today,TodayMon,ThisYr),date(Day,Mon,Yr)) :-
        our_date(date(Today,TodayMon,ThisYr)),
        get_timestamp(date(Today,TodayMon,ThisYr),time(0,0,0),MidnightTimestamp),
        YesterdaysTimestamp is MidnightTimestamp - 86400,
        stamp_date_time(YesterdaysTimestamp,date(Yr,Mon,Day,_,_,_,_,_,_),local).        






next_day(date(Today,TodayMon,ThisYr),date(Day,Mon,Yr)) :-
        our_date(date(Today,TodayMon,ThisYr)),
        get_timestamp(date(Today,TodayMon,ThisYr),time(0,0,0),MidnightTimestamp),
        NextDaysTimestamp is MidnightTimestamp + 86400,
        stamp_date_time(NextDaysTimestamp,date(Yr,Mon,Day,_,_,_,_,_,_),local).        








% moved from genetic_utilities.pl and changed to exploit timestamps
% makes timestamps relative to midnight
%
% dates are of the form date/3
%
% Kazic, 8.4.2018

% later(-EarlierDate,-LaterDate).

later(EarlierDate,LaterDate) :-
        get_timestamp(EarlierDate,time(0,0,0),EarlierTimestamp),
        get_timestamp(LaterDate,time(0,0,0),LaterTimestamp),
        LaterTimestamp > EarlierTimestamp.







%! latest(-TimeStampedDatesKeyList,+LatestKey-Value).

latest(TimeStampedDates,Latest) :-
        keysort(TimeStampedDates,Sorted),
        reverse(Sorted,[Latest|_]).






%! nice_date(+DateTime:term,-NiceDate:atom).

nice_date(DateTime,NiceDate) :-
        format_time(atom(NiceDate),'%a, %b %d, %Y %T %Z',DateTime).




% Doesn''t feel like index-finding will be any faster in Prolog.
%
%
% Kazic, 30.3.2018

split_at_key(UnSortedKeyList,SplittingValue,BeforeValueList,EqualsOrAfterValueList) :-
        split_at_key_aux(UnSortedKeyList,SplittingValue,[],BeforeValueList,[],EqualsOrAfterValueList).
	

split_at_key_aux([],_,BAcc,BAcc,EAcc,EAcc).
split_at_key_aux([Key-Value|Data],SplittingValue,BAcc,BeforeValue,EAcc,EqualsOrAfterValueList) :-
        ( Key < SplittingValue ->
	        append(BAcc,[Key-Value],NewBAcc),
                NewEAcc = EAcc
	;
                append(EAcc,[Key-Value],NewEAcc),
                NewBAcc = BAcc
	),
	split_at_key_aux(Data,SplittingValue,NewBAcc,BeforeValue,NewEAcc,EqualsOrAfterValueList).








% First argument is the bare numeric comparison operator, no quotes.
%
% with help from
% https://stackoverflow.com/questions/26453574/how-can-i-pass-a-predicate-as-parameter-for-another-predicate-in-prolog
%
% beware! subtract is defined for sets, not lists.
% It recurses over the first list, memberchking each term against the second list.
% So if there are duplicates in the first list, they should all appear in the second list
% if they satisfy the original condition; and otherwise, go into the third list.
%
% And so it is:
%
% L = [1-a,5-n,3-x,2-b,5-n,3-x], split_at_key_op(>,L,4,S,R).
% L = [1-a, 5-n, 3-x, 2-b, 5-n, 3-x],
% S = [5-n, 5-n],
% R = [1-a, 3-x, 2-b, 3-x].
% 
% Kazic, 30.3.2018

split_at_key_op(Op,UnSortedKeyList,SplittingValue,SatisfiesList,Rest) :-
        findall(K-V,(member(K-V,UnSortedKeyList),call(Op,K,SplittingValue)),SatisfiesList),
        subtract(UnSortedKeyList,SatisfiesList,Rest).












% my seasons first, and the rest of
% the alphabet second.

letter(r,'R').
letter(n,'N').
letter(g,'G').

letter(a,'A').
letter(b,'B').
letter(c,'C').
letter(d,'D').
letter(e,'E').
letter(f,'F').
letter(h,'H').
letter(i,'I').
letter(j,'J').
letter(k,'K').
letter(l,'L').
letter(m,'M').
letter(o,'O').
letter(p,'P').
letter(q,'Q').
letter(s,'S').
letter(t,'T').
letter(u,'U').
letter(v,'V').
letter(w,'W').
letter(x,'X').
letter(y,'Y').
letter(z,'Z').


lower_case_letters([r,n,g,a,b,c,d,e,f,h,i,j,k,l,m,o,p,q,s,t,u,v,w,x,y,z]).
upper_case_letters(['R','N','G','A','B','C','D','E','F','H','I','J','K','L','M','O','P','Q','S','T','U','V','W','X','Y','Z']).




row_length(full,20).
row_length(half,10).






% this is a low-powered replacement for Quintus Prolog''s subseq/3, as given
% in the sicstus manual:
% 
% https://sicstus.sics.se/sicstus/docs/4.3.0/html/sicstus/lib_002dlists.html    
%
% it requires that both Sequence and SubSequence be instantiated, so can''t be
% used to interleave two lists.
%
% It implements a strict definition of subsequence in terms of order, but permits
% the two sequences to be of equal length (since they might have different elements).
% see
% https://en.wikipedia.org/wiki/Subsequence
%
% but I''m guessing about what the Complement is if SubSeqLen >= SeqLen.
%
% Kazic, 12.4.2018


%! lp_subseq(+Sequence:list,+Subsequence:list,-Complement:term) is nondet.


lp_subseq(Sequence,SubSequence,Complement) :-
        length(Sequence,SeqLen),
        length(SubSequence,SubSeqLen),
        ( SeqLen >= SubSeqLen ->
                lp_subseq(Sequence,SubSequence,[],Complement)
        ;
                Complement = undef
        ).



lp_subseq(Remainder,[],Acc,Complement) :-
        append(Acc,Remainder,Complement).


lp_subseq(Sequence,[H|T],Acc,Complement) :-
        ( selectchk(H,Sequence,Remainder) ->
	        NewSeq = Remainder,
                NewAcc = Acc
	;
                append(Acc,[H],NewAcc),
	        NewSeq = Sequence
	),
	lp_subseq(NewSeq,T,NewAcc,Complement).










% remove singletons from the Bag corresponding to those in the Set.
% A simple subtract will not do.
%
% Kazic, 15.4.2018

%! remove_singletons(+Bag:list,+Set:set,-Remainder:list) is nondet.

remove_singletons(Acc,[],Acc).
remove_singletons(Bag,[H|T],Remainder) :-
        ( selectchk(H,Bag,Rem) ->
                NewAcc = Rem
        ;
                NewAcc = Bag
        ),
        remove_singletons(NewAcc,T,Remainder).       















%%%%%%%%% utilities for pack_corn:pack_corn/1

% transplanted from old order_packets.pl
%
% assumes default directory organization; change if yours differs
%
% Kazic, 25.7.2019

load_crop_planning_data(Crop) :-
        current_crop(Crop),
        convert_crop(Crop,LCrop),
        atomic_list_concat(['../../crops/',LCrop,'/planning/packing_plan.pl'],PackingPlanFile),
        ensure_loaded(pack_corn:[PackingPlanFile]).




append_to_planning_file(Crop,Plans) :-
	open(demeter_tree('data/plan.pl'),append,Stream),
        convert_crop(Crop,LCrop),	
        format(Stream,'~n~n~n~n% ~w~n~n',[LCrop]),
        output_header(plano,demeter_tree('data/plan.pl'),Stream),
        write_list_facts(Stream,Plans),
        close(Stream).




