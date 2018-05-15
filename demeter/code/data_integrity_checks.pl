% this is demeter/code/data_integrity_checks.pl

% predicates to check stuff
%
% Kazic, 19.4.08


%declarations%

:-      module(data_integrity_checks,[
                find_missing/1,
		find_missing/2
                ]).




:-      use_module(genetic_utilities).
      




:-      ensure_loaded(library(sets)),
        ensure_loaded(library(lists)),
%
% library not in SICStus Prolog
%
%        ensure_loaded(library(basics)),
        ensure_loaded(library(strings)).





%end%










find_missing(File) :-
        setof((Ma,Pa,Sleeve),W^H^Q^C^P^D^T^inventory(Ma,Pa,W,H,Q,C,P,D,T,Sleeve),Have),
        setof((DMa,DPa,DSleeve),DW^DH^DQ^DC^DP^DD^DT^dup_inv(DMa,DPa,DW,DH,DQ,DC,DP,DD,DT,DSleeve),Extras),
    	find_missing(ma,Have,Extras,MissingMas),
	find_missing(pa,Have,Extras,MissingPas),
	find_missing(blank,Have,Extras,Blanks),
	find_missing(sleeve,Have,Extras,MissingSleeves),
        skipped_sleeves(Have,Skipped),
	output_missing(File,MissingMas,MissingPas,Blanks,MissingSleeves,Skipped).












find_missing(Type,Have,Extras,MissingMas) :-
        find_missing(Type,Have,Extras,[],MissingMas).



find_missing(_,[],_,A,A).
find_missing(Type,[(Ma,Pa,Sleeve)|T],Extras,Acc,Missing) :-
        ( Type == ma ->
                ( ( Ma == '', Pa \== '' ) ->
		        append(Acc,[(Ma,Pa,Sleeve)],NewAcc)
                ;
                        ( memberchk((Ma,_,_),Extras) ->
		                NewAcc = Acc
		        ;
			        append(Acc,[(Ma,Pa,Sleeve)],NewAcc)
		        )
                )
	;
	        ( Type == pa ->
                        ( ( Pa == '', Ma \== '' ) ->
			        append(Acc,[(Ma,Pa,Sleeve)],NewAcc)
                        ;

				( memberchk((_,Pa,_),Extras) ->
			                NewAcc = Acc
			        ;
				        append(Acc,[(Ma,Pa,Sleeve)],NewAcc)
                                )
			)
		;
			( Type == blank ->
			        ( ( Ma == '', Pa == '' ) ->
			                append(Acc,[(Ma,Pa,Sleeve)],NewAcc)
			        ;
				        NewAcc = Acc
			        )
			;
				Type == sleeve,
			        ( memberchk((_,_,Sleeve),Extras) ->
			                NewAcc = Acc
			        ;
				        append(Acc,[Sleeve],NewAcc)
			        )
			)
		)
	),
	find_missing(Type,T,Extras,NewAcc,Missing).




skipped_sleeves(Have,Skipped) :-
        grab_sleeves(Have,Sleeves),
	list_to_set(Sleeves,SleeveSet),
	count_sleeves(SleeveSet,Skipped).




grab_sleeves([],[]).
grab_sleeves([(_,_,S)|T],[S|T2]) :-
        grab_sleeves(T,T2).



count_sleeves(SleeveSet,Skipped) :-
        strip_headers(SleeveSet,Stripped),
        find_missing(Stripped,Skipped).





strip_headers([],[]).
strip_headers([H|T],[S|T2]) :-
        midstring(H,'v',R),
        remove_padding(R,A),
        convert_to_num(A,S),
	strip_headers(T,T2).



find_missing(L,L1) :-
        sort(L,Int),
	find_missing(Int,[],L1).





find_missing([],A,A).
find_missing([_],A,A).
find_missing([H1,H2|T],Acc,Missing) :-
        ( H2 is H1 + 1 ->
	        find_missing([H2|T],Acc,Missing)
	;
	        M is H1 + 1,
		append(Acc,[M],NewAcc),
		find_missing([M,H2|T],NewAcc,Missing)
	).










output_missing(File,MissingMas,MissingPas,Blanks,MissingSleeves,Skipped) :-
	open(File,write,Stream),
	format(Stream,'% mas present in originals not in the consolidated inventory~n~n',[]),
	write_list(Stream,MissingMas),
	format(Stream,'~n~n~n% pas present in originals not in the consolidated inventory~n~n',[]),
	write_list(Stream,MissingPas),
	format(Stream,'~n~n~n% missing parents in the consolidated inventory~n~n',[]),
	write_list(Stream,Blanks),
	format(Stream,'~n~n~n% missing sleeves in the consolidated inventory~n~n',[]),
	write_list(Stream,MissingSleeves),
	format(Stream,'~n~n~n% skipped sleeves in the consolidated inventory~n~n',[]),
	write_list(Stream,Skipped),
	close(Stream).















% every ma should be present once in line, family, and inventory facts
% every pa should be present at least once in those facts
%
% Kazic, 8.5.08


