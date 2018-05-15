% this is ../c/maize/demeter/code/crop_management.pl
%
% adapted for swipl and more portability across platforms
%
%
% Kazic, 27.3.2018




% for managing field activities
% July -- Aug, 2009
%
% Kazic, 1.8.2009



%declarations%

:-       module(crop_management,[
                 all_mutant_rows_for_selfing/2,
                 daily_status_report/2,
                 daily_status_report/3,
                 find_crossed_plants_to_photo/2,
                 find_daddies/2,
                 find_goofs/2,
                 find_in_situ_plants/2,
                 find_orphan_tassels/3,
                 find_rows_to_cross/2,
                 find_rows_to_cross/3,
                 find_rows_to_replant/2,
                 find_rows_to_score/2,
                 find_rows_to_score/3,
                 find_silking_ears/2,
                 find_unrecorded_pollinations/2,
                 find_unscored_plants/3,
                 generate_plant_tags_file/3,
                 harvest_inbred_selfs/2,
                 harvested_early/2,
                 monitor_progress/2,
                 order_harvest/2,
                 repack_packets/3,
                 seed_planted/3,
                 tassel_watch/2,
                 watch_tassels/3
                 ]).



:-      use_module(demeter_tree('code/analyze_crop')),
        use_module(demeter_tree('code/genetic_utilities')),
        use_module(demeter_tree('code/demeter_utilities')),
        use_module(demeter_tree('code/clean_data')),    
        use_module(demeter_tree('data/load_data')).




:-      use_module(demeter_tree('code/order_packets'), [
                load_crop_planning_data/1
                ]).





:-      ensure_loaded(library(lists)).

/*

:-      ensure_loaded(library(lists)),
        ensure_loaded(library(sets)),
        ensure_loaded(library(basics)),
        ensure_loaded(library(strings)),
        ensure_loaded(library(not)).

*/

%end%






    
% call: daily_status_report('09R',date(31,8,2009),'../results/').



% stopped here in predicate development
%
% must still test tassel_watch, but at least I now get the correct rows for
% selfing.  Must also make sure find_daddies still works correctly.
%
%
% correct daily_report and ff.  
%
% Kazic, 1.8.2009

% call: daily_status_report('09R',date(15,9,2009),'../results').


daily_status_report(Crop,Date,Dir) :-
        our_date(Date),
        arg(1,Date,Day),
        yesterday(Date,Yesterday),
        check_slash(Dir,SDir),
        atomic_list_concat([SDir,selfing_rows,Day],SelfFile),
        atomic_list_concat([SDir,daddies,Day],DaddiesFile),
        atomic_list_concat([SDir,orphans,Day],OrphansFile),
        atomic_list_concat([SDir,rows_to_score,Day],ScoringFile),
        atomic_list_concat([SDir,rows_to_cross,Day],ToCrossFile),
        atomic_list_concat([SDir,photo,Day],PhotoFile),
        atomic_list_concat([SDir,uncrossed_photo,Day],UnCrossedFile),
%        atomic_list_concat([SDir,silking_ears,Day],SilkingFile),

%        atomic_list_concat([SDir,tassel_watch,Day],TasselWatchFile),


        all_mutant_rows_for_selfing(Crop,SelfFile),
        find_daddies(Yesterday,DaddiesFile),
        find_orphan_tassels(Crop,Yesterday,OrphansFile),
        find_rows_to_score(Crop,Lines,ScoringFile),
        find_rows_to_cross(Crop,Lines,ToCrossFile),
        find_crossed_plants_to_photo(Date,PhotoFile),
        find_uncrossed_plants_to_photo(UnCrossedFile),

%        find_silking_ears(Crop,SilkingFile),

        true.

%        tassel_watch(Yesterday,TasselWatchFile).











% when you can''t open files, print to the screen . . . 
%
% make all of these conditional:  the work does finally get done!
%
% Kazic, 17.8.09

% call: daily_status_report('09R',date(13,8,2009)).

daily_status_report(Crop,Date) :-
        our_date(Date),
        arg(1,Date,Day),
        arg(2,Date,Mon),
        yesterday(Date,Yesterday),


        format('********** status report for ~w.~w ************~n~n~n',[Day,Mon]),

        format('================ rows to self on ~w.~w ================~n~n',[Day,Mon]),
        setof(Ma-Pa-Plan,Pltng^Notes^plan(Ma,Pa,Pltng,Plan,Notes,Crop),Plans),
        find_selfing_rows(Crop,Plans,Rows),
        write_list(Rows),
        format('~n~n~n',[]),
       
        format('================ males on ~w.~w ================~n~n',[Day,Mon]),
        ( setof(RowPlant-(PlantID,Mas,Plan,ToDo),ready_daddy(Yesterday,PlantID,RowPlant,Mas,Plan,ToDo),Daddies) ->
                write_list(Daddies)
        ;
                format('No tassels set for pollination today!~n',[])
        ),
        format('~n~n~n',[]),


        format('================ orphan tassels on ~w.~w ================~n~n',[Day,Mon]),
        crop_window(Crop,CropMonths),
        ( setof(PlantID-MostRecent,bagged_tassel(CropMonths,PlantID,MostRecent),Tassels) ->
                find_orphan_tassels_aux(Tassels,Yesterday,Orphans),
                write_list(Orphans)
        ;
                format('No orphaned tassels found today!~n',[])
        ),
        format('~n~n~n',[]),

        format('================ rows to score on ~w.~w ================~n~n',[Day,Mon]),
        identify_rows(Crop,Lines),
        mutant_rows(Crop,Lines,MutantRows),
        scored_rows(Crop,Scored),
        subtract(MutantRows,Scored,UnScored),
        write_list(UnScored),
        format('~n~n~n',[]),

        format('================ rows to cross on ~w.~w ================~n~n',[Day,Mon]),
        find_mutant_row_plans(Crop,Lines,MutantRowsPlans),
        find_rows_crossing_status(Crop,MutantRowsPlans,RowCrossings),
        write_list(RowCrossings),
        format('~n~n~n',[]).








% ummm, it should check the stand count and contaminated ears to compute
% the maximum number possible; if that is less than 5, it should count down from there
%
% a problem:  row 21 has at least 5 pollinations, but report shows 2 remain
%
% row 53 has only one plant!
%
% all other ears in row 26 are contaminated
%
% Kazic, 3.8.2009
%
% those comments may be obsolete:  09r had several overplanted rows.
%
% Kazic, 28.3.2018



% call: all_mutant_rows_for_selfing('09R','../results/selfing_rows').

% there must be an error here that forces back-tracking until we run out of files...
%
% failure comes on back-tracking through output_data; file is written and closed

all_mutant_rows_for_selfing(Crop,File) :-
        setof(Ma-Pa-Plan,Pltng^Notes^plan(Ma,Pa,Pltng,Plan,Notes,Crop),Plans),
        find_selfing_rows(Crop,Plans,Rows),
        output_data(File,self,Rows).





find_selfing_rows(Crop,Plans,Rows) :-
        find_selfing_rows(Crop,Plans,[],Unsorted),
        sort(Unsorted,Rows).


find_selfing_rows(_,[],A,A).
find_selfing_rows(Crop,[Ma-Pa-Plan|T],Acc,Rows) :-
        ( plan_includes(self,Plan,_) ->
                row_from_parents(Ma,Pa,Crop,Row),
                selfs_in_row_so_far(Crop,Row,Status),
                ( Status == done ->
                        NewAcc = Acc
                ;
                        append(Acc,[Row-Status],NewAcc)
                )
	;
                NewAcc = Acc
        ),
        find_selfing_rows(Crop,T,NewAcc,Rows).






selfs_in_row_so_far(Crop,Row,Status) :-
        row_members(Crop,Row,Members),
        selfed_plants(Members,Selfs),
        length(Selfs,NumSoFar),
        ( NumSoFar >= 3 ->
                Status = done
	;
                Status is 3 - NumSoFar
        ).







% earlier version with silking_ear_aux folded into
% setof worked until I added the check for inbreds

find_silking_ears(Crop,File) :-
        year_from_crop(Crop,Year),
        setof(Type-(Ear-Date),silking_ear(Year,Ear,Type,Date),KVEars),
        our_inbred_order(KVEars,EarTuples),
        extract_ears(EarTuples,Ears),
        output_data(File,silk,Ears).



our_inbred_ear_order(['B'-BEars,'M'-MEars,'S'-SEars,'W'-WEars],[SEars,MEars,WEars,BEars]).



extract_ears([],[]).
extract_ears([(Ear,Dates)|T],[Ear-Dates|T2]) :-
        extract_ears(T,T2).





% find all tassels that have been set up but not crossed --- orphans.  
%
%
find_orphan_tassels(Crop,Yesterday,File) :-
        crop_window(Crop,CropMonths),
        ( setof(PlantID-MostRecent,bagged_tassel(CropMonths,PlantID,MostRecent),Tassels) ->
                find_orphan_tassels_aux(Tassels,Yesterday,Orphans)
        ;
                Orphans = []
        ),
        output_data(File,orph,Orphans).









find_orphan_tassels_aux(Tassels,Yesterday,Orphans) :-
        find_orphan_tassels_aux(Tassels,Yesterday,[],Int),
        sort(Int,Orphans).






% if perchance a pollination is not recorded, then of course the tassel will show up as an orphan if
% one asks on the next day.  This gives a chance to double-check the pollination records.
%
% In 09R, I have five such pollinations:
%
% 1303, set up on 21.7
% 1513, set up on 25.7
% 1803, set up on 25.7
% 2510, set up on 25.7
% 2512, set up on 25.7
%
% but it turns out I still don''t have all the early cross records in!
% That''s why the self counts have been off (then, desired number of selfs
% was 5, not 3 as now).
%
% So likely the logic is fine.
%
% Kazic, 10.8.2009

find_orphan_tassels_aux([],_,A,A).
find_orphan_tassels_aux([PlantID-(Mon-Day,Time)|Tassels],date(Yesterday,YesterMon,_),Acc,Orphans) :-
        ( ( cross(_,PlantID,ear(1),false,_,_,date(CrossDay,CrossMon,_),time(CrossHr,CrossMin,_)),
            construct_time(CrossHr,CrossMin,CrossTime),
            (CrossMon,CrossDay,CrossTime) @>= (Mon,Day,Time) ) ->
                NewAcc = Acc
	;
                ( ( tassel(PlantID,TasselStatus,_,date(StatusDay,StatusMon,_),time(StatusHr,StatusMin,_)),
                    memberchk(exhausted,TasselStatus),
                    construct_time(StatusHr,StatusMin,StatusTime),
                    (StatusMon,StatusDay,StatusTime) @>= (Mon,Day,Time) ) ->
                        NewAcc = Acc
		;


% one can''t repeat a self, but I mark those (and non-selfs)
% with which I am dissastified as "repeat" to indicate they should be
% discarded in the seed room.  But the tassel itself is not an orphan.

                        ( cross(PlantID,PlantID,ear(1),repeat,_,_,_,_) ->
                                NewAcc = Acc
			;

                                get_rowplant(PlantID,RowPlant),


% what is really an orphan?  The following gives all uncrossed tassels, but
% if there has been a mistake in recording the pollinations, so that the
% male tag was not on the bag or was not scanned, then this will find
% those too, as well as the true orphans --- plants that are still set up.
% Such a mistake occurred on the pollinations of 30.7.2009 --- so it can
% happen!
%
%
% I''m going to eventually refactor this predicate so that I can use the
% original logic to find those screwups; they are also candidates for
% exhausted tassels.  Meanwhile, I''ll add a date constraint to make sure I
% pick up the orphans in time to do something with them.
%
% Kazic, 10.8.2009

                                ( a_days_difference(Yesterday,YesterMon,Day,Mon) ->
                                        append(Acc,[RowPlant-(PlantID,Day,Mon,Time)],NewAcc)
                                ;
                                        NewAcc = Acc
                                )
                        )
                )
        ),
        find_orphan_tassels_aux(Tassels,date(Yesterday,YesterMon,_),NewAcc,Orphans).

















% tassel watch list
%
% call: tassel_watch(date(28,7,2009),'../../crops/09r/management/tassel_watch28').

tassel_watch(Date,File) :-
        crop_from_date(Date,Crop),
        setof(RowPlant-(Status,Plan,ToDo),watched_tassel(Date,Crop,RowPlant,Status,Plan,ToDo),Tassels),
        watch_tassels(Crop,Date,Tassels),
        output_data(File,taslw,Tassels).






watch_tassels(Crop,_Date,Tassels) :-
        setof(RowPlant-(Status,StatusDay,Plan,ToDo),plant_to_cross(Crop,RowPlant,Status,StatusDay,Plan,ToDo),Tassels).





% need to amend this so I get the most recent fact, checking both date and time.  Make
% a utility metapredicate for this.  For now, I have just commented out the old mutant facts.
%
% Kazic, 31.7.2009

plant_to_cross(Crop,RowPlant,Status,StatusDay,Plan,ToDo) :-
        crop_rowplant(PlantID,Crop,Row,_Plant),

        ( mutant(PlantID,_,cross,_,_,_,_,_)
	;
          mutant(PlantID,_,maybe,_,_,_,_,_)
	;
          cross(Ma,PlantID,ear(1),false,toni,_,_,_),
          Ma \== PlantID
	;
          once(selfing_candidate(PlantID,Crop))
        ),

        ( ( all_preps_except_shootbagging(PlantID,Preps),
            tassel_bagged(Preps,StatusDay) ) ->
                    Status = bagged
	 ;
                    ( cross_prep(PlantID,[bag(shoot)],_,_,_) ->
                            false
		    ;
                            ( tassel(PlantID,Status,_,StatusDate,_) ->
                                    arg(1,StatusDate,StatusDay)
	                    ;
                                    Status = unk,
                                    StatusDay  = unk
                            )
                    )
        ),

        rowplant_from_plantid(PlantID,RowPlant),
        ( once(make_todo_list(PlantID,Crop,Plan,ToDo)) ->
                true
        ;
                format('Warning!  no plan found for row ~w!~n',[Row])
        ).
















% trace,crop_management:test('09R','09R0150:0000000',S,D,P,T).

test(Crop,PlantID,Status,StatusDay,Plan,ToDo) :-
        ( mutant(PlantID,_,cross,_,_,_,_,_)
	;
          mutant(PlantID,_,maybe,_,_,_,_,_)
	;
          cross(Ma,PlantID,ear(1),false,toni,_,_,_),
          Ma \== PlantID
	;
          once(selfing_candidate(PlantID,Crop))
        ),

        ( ( all_preps_except_shootbagging(PlantID,Preps),
            tassel_bagged(Preps,StatusDay) ) ->
                    Status = bagged
	 ;
                    ( cross_prep(PlantID,[bag(shoot)],_,_,_) ->
                            false
		    ;
                            ( tassel(PlantID,Status,_,StatusDate,_) ->
                                    arg(1,StatusDate,StatusDay)
	                    ;
                                    Status = unk,
                                    StatusDay  = unk
                            )
                    )
        ),

%        get_family(PlantID,Family),
%        plan_for_row(Crop,Family,Plan).
%        rowplant_from_plantid(PlantID,_RowPlant),        
        ( once(make_todo_list(PlantID,Crop,Plan,ToDo)) ->
                true
        ;
                get_row(PlantID,Row),
                format('Warning!  no plan found for row ~w!~n',[Row])
        ).












% oops, takes forever and runs out of space!  Use the indexed plants instead.
%
% does not work due to make_rowplant/4!  use watch_tassels/3 instead
%
% Kazic, 30.7.2009


watched_tassel(Date,Crop,_RowPlant,StatusDay-Status,Plan,ToDo) :-
        crop_rowplant(PlantID,Crop,Row,_Plant),
        \+ ( tassel(PlantID,Status,_,_,_),
             memberchk(exhausted,Status) ),
        ( mutant(PlantID,_,cross,_,_,_,_,_)
	;
          mutant(PlantID,_,maybe,_,_,_,_,_)
        ),

%        make_rowplant(Row,Plant,RowPlant),
        ( ( cross_prep(PlantID,Prep,_,Date,_),
            memberchk(bag(tassel),Prep) ) ->
                Status = bagged,
                arg(1,Date,StatusDay)
	;

                ( ( tassel(PlantID,Status,_,StatusDate,_),
                    arg(1,StatusDate,StatusDay) ) ->
                         true
		;
                         Status = unk,
                         StatusDay  = unk
                )
        ),
        ( once(make_todo_list(PlantID,Crop,Plan,ToDo)) ->
                true
        ;
                format('Warning!  no plan found for row ~w!~n',[Row])
        ).






make_todo_list(PlantID,Crop,Plan,ToDo) :-
        get_family(PlantID,Family),
%        dummy(Family),
        ( plan_for_row(Crop,Family,Plan) ->
                ( setof(Ma,Pil^Da^Time^cross(Ma,PlantID,ear(1),false,toni,Pil,Da,Time),Mas) ->
                        make_todo_list_aux(Mas,Plan,ToDo)
		;
                        Mas = [],
                        ToDo = all
                )
        ;
                format('Warning! make_todo_list/4 fails for ~w in ~w.~n',[PlantID,Crop])
        ).




% obviously for debugging

dummy(Family) :-
        ( ( Family == 150
           ;
            Family == '0150' ) ->
                trace
        ;
                true
        ).








% See opening comments in ../data/row_status.pl for list of current
% phenotypes.
%
% "emerged" is also allowed for stand counts.
%
% Kazic, 29.3.2018


count_plants_phenotypes(Crop,Phenotype,Date,Total) :-
        setof(Count,count_rows(Crop,Phenotype,Date,Count),Counts),
        sum_list(Counts,Total).





% test

count_rows(Crop,Phenotype,Date,Count) :-
        get_timestamp(Date,time(12,0,0),TimeStamp),
	gather_subsequent_observatns(Crop,TimeStamp,Phenotype,Phenotypes),
	sum_list(Phenotypes,Count).



gather_subsequent_observations(Crop,TimeStamp,Phenotype,Phenotypes) :-
        ( Phenotype == emerged ->
                findall(DateObs-TimeObs-(Num,Row),row_status(Row,num_emerged(Num),_PList,_Obsvr,DateObs,TimeObs,Crop),L)

        ;
	        findall(DateObs-TimeObs-(Num,Row),(row_status(Row,_NumEmerged,PList,_Obsvr,DateObs,TimeObs,Crop),
		                                      member(phenotype(Phenotype,Num),PList)),L)
        ),

        gather_subsequent_observations(L,TimeStamp,Phenotypes).





gather_subsequent_observations(DataList,TimeStamp,Pruned) :-
        convert_dates(DataList,TimeStampedData),
	split_at_key_op(>=,TimeStampedData,TimeStamp,Pruned,_).










% which rows need to be replanted, for example because of
% cold or innudation?
%
% Kazic, 31.5.2011

% call: [load_demeter],find_rows_to_replant('11R','../../maize/crops/11r/planning/rows_to_replant').

find_rows_to_replant(Crop,File) :-
        load_crop_planning_data(Crop),
        setof(Row-(Packet,Cl,Ma,Pa,Seq,CrossInstructns),planting_datum(Crop,Row,Packet,Cl,Ma,Pa,Seq,CrossInstructns),Planted),
        replant_these(Planted,Crop,Replant),
        sort_into_packing_order(Replant,Sorted),
        length(Sorted,N),
        format('~d rows to replant!~n',[N]),
        output_data(File,replant,Sorted).



% assumes the 11r situation, which is that only one set of parents were given
% in the packing_plan.
%
% Kazic, 2.6.2011

planting_datum(Crop,Row,Packet,Cl,Ma,Pa,Seq,CrossInstructns) :-
        planted(Row,Packet,_,_,Date,Time,_,Crop),
        closest_contemporaneous_packet_w_cl(Crop,Packet,Date,Time,Cl,Ma,Pa),
        atomic_list_concat([Ma,' x ',Pa],Parents),
        ( ( plan(Ma,Pa,_,CrossInstructns,_,Crop),
            pack_corn:packing_plan(Seq,_,[Parents],_,CrossInstructns,_,_,Crop,_,_) ) ->
                true
        ;
                ( memberchk(Packet,[p00001,p00002,p00003,p00004]) ->
                        Seq = bc,
                        CrossInstructns = []
                ;
                        format('Warning! unconsidered case in planting_datum/8 for row ~w, packet ~w, ~w x ~w.~n',[Row,Packet,Ma,Pa]),
                        Seq = pop,
                        CrossInstructns = []
                )
        ).





replant_these(Planted,Crop,Replant) :-
        replant_these(Planted,Crop,[],Replant).




% most reasonable approach for sorting
%
% Kazic, 2.6.2011

replant_these([],_,A,A).
replant_these([Row-(Packet,Cl,Ma,Pa,Seq,CrossInstructns)|T],Crop,Acc,Replant) :-
        emergence_ok(Row,Crop,Packet,Cl,CrossInstructns,ExtraCl),
        ( ExtraCl == 0 ->
                NewAcc = Acc
        ;
                get_rowplant(Ma,MaRowPlant),
                ( setof(Date-Time-(ISleeve),load_data:N^P^inventory(Ma,Pa,N,P,Date,Time,ISleeve),Sleeves) ->
                        most_recent_datum(Sleeves,_-(Index))
                ;
                        get_family(Ma,Index)
                ),
                append(Acc,[MaRowPlant-Index-(Packet,Ma,Pa,ExtraCl,Row,Seq)],NewAcc)
        ),
        replant_these(T,Crop,NewAcc,Replant).







% if plan is for selfing, 50% germ ok; if cross to inbred, need ~ 80%; if
% inbred, ~90%

emergence_ok(Row,Crop,Packet,Cl,CrossInstructns,ExtraCl) :-
        ( setof(Date-Time-(Row,SValue),F^O^row_status(Row,num_emerged(SValue),F,O,Date,Time,Crop),StandCounts) ->
                most_recent_datum(StandCounts,_-(Row,Value)),
                ( number(Value) ->
                        stand_count_threshold(Packet,CrossInstructns,Fraction),
                        Threshold is Cl * Fraction,
                        ( Value >= Threshold  ->
                                ExtraCl = 0
                        ;
                                ExtraCl is Cl - Value
                        )
                ;
                        ( ( Value == 'few_spiking'
                          ;
                            Value == 'pegging' ) ->
                                ExtraCl = 0
                        ;
                                ExtraCl is Cl - Value
                        )
                )
        ;
 

% don't have any emergence data on skipped rows!

                ExtraCl = 0
        ).








% different thresholds depending on the aim for that line

stand_count_threshold(Packet,CrossInstructns,Fraction) :-
        ( ( CrossInstructns == [self]
          ; CrossInstructns == [observe]
          ; ( selectchk(self,CrossInstructns,Rem),
              Rem \== [],
              \+ memberchk('S',Rem), 
              \+ memberchk('W',Rem), 
              \+ memberchk('M',Rem), 
              \+ memberchk('B',Rem) ) ) ->
                Fraction = 0.5
        ;
                ( ( CrossInstructns \== [observe],
                    \+ memberchk(Packet,[p00001,p00002,p00003,p00004]) ) ->
                        Fraction = 0.73
                ;
                        ( memberchk(Packet,[p00001,p00002,p00003,p00004]) ->
                                Fraction = 0.9

                        ;
                                format('Warning! unconsidered case in stand_count_threshold/3 for packet ~w with instructions ~w.~n',[Packet,CrossInstructns]),
                                Fraction = 1
                        )
                )
        ).










sort_into_packing_order(Replant,Sorted) :-
        sort(Replant,Int),
        reindex(Int,Sorted).



reindex([],[]).
reindex([_-_-(Packet,Ma,Pa,ExtraCl,Row,Seq)|T],[Row-(Packet,Seq,Ma,Pa,ExtraCl)|T2]) :-
        reindex(T,T2).













% which mutant rows still need to be scored?

% idea:  form set of all rows of mutants (not inbred or fun corn) in crop;
% from the mutant facts, pull the row numbers of the scored plants for that crop,
% forming the set of these; make sure all rows are integers and ord_sets; 
% and subtract the sets to get the unscored mutant rows.
%
% must use track_transplants in some form as some mutants were transplanted (Gerry, Marty).


find_rows_to_score(Crop,File) :-
        find_rows_to_score(Crop,_,File).







% the second half finds plants in scored rows that were missed during scoring, and appends
% these to the scoring file

find_rows_to_score(Crop,Lines,File) :-
        identify_rows(Crop,Lines),
        mutant_rows(Crop,Lines,MutantRows),
        scored_rows(Crop,Scored),
        subtract(MutantRows,Scored,UnScoredRows),
        output_data(File,scor,UnScoredRows),

        find_unscored_plants(Crop,Scored,UnScoredPlants),
        open(File,append,Stream),
        format(Stream,'~n~n~n************* unscored plants *************~n~n',[]),
        length(UnScoredPlants,Num),
        format(Stream,'% there are ~d unscored plants in the following list.~n~n~n% PlantToScore~n~n~n',[Num]),
        write_list_facts_w_skips(Stream,UnScoredPlants),
        close(Stream).













% each of these rows has at least one plant scored.  But are all
% the plants of the row scored or otherwise accounted for?  Returns a 
% List of KeyLists where the Keys and their Lists are sorted.


%! find_unscored_plants(-Crop:atom,-ScoredRows:list,+KeyListUnScoredPlants:list) is det.

find_unscored_plants(Crop,ScoredRows,UnScoredPlants) :-
        find_unscored_plants(Crop,ScoredRows,[],Int),
        insert_row_keys(Int,KeyValuePlants),
        sort(1,@>=,KeyValuePlants,Sorted),
        group_pairs_by_key(Sorted,SortedKeyLists),
        sort(SortedKeyLists,UnScoredPlants).
 






% row_members are constructed from the stand count, which may be inaccurate.
% So form the set of all plants scored from the row, subtract those that are dead by
% fate or intention, subtract those that were in the stand count, then subtract those
% scored that were not in the stand count, and then the remainder are known plants that
% have not been scored.
%
% Kazic, 27.8.2009

% revised for efficiency
%
% Kazic, 12.4.2018

find_unscored_plants(_,[],A,A).
find_unscored_plants(Crop,[Row|Rows],Acc,UnScoredPlants) :-
        row_members(Crop,Row,RowMembers),


% occasionally I score an inbred, especially if it has a mutant phenotype
% that has appeared in the back-crossed lines.  But I don''t want to score that
% entire row; so remove the scored inbred''s row members from the list of plants to score
%
% Kazic, 31.8.2009
        
        arg(1,RowMembers,H),
        get_family(H,Family),
        ( inbred(Family,_) ->
                NewAcc = Acc
        ;
                dead_plants(RowMembers,DeadPlants),
                scored_plants(RowMembers,ScoredPlants),
                union(DeadPlants,ScoredPlants,Done),
                subtract(RowMembers,Done,PlantsToScore),
                append(Acc,PlantsToScore,NewAcc)
        ),
        find_unscored_plants(Crop,Rows,NewAcc,UnScoredPlants).











insert_row_keys([],[]).
insert_row_keys([PlantID|T],[RowNum-PlantID|T2]) :-
        get_row(PlantID,Row),
        atom_number(Row,RowNum),
        insert_row_keys(T,T2).















find_rows_to_cross(Crop,File) :-
        identify_rows(Crop,Lines),
        find_rows_to_cross(Crop,Lines,File).



find_rows_to_cross(Crop,Lines,File) :-
        find_mutant_row_plans(Crop,Lines,MutantRowsPlans),
        find_rows_crossing_status(Crop,MutantRowsPlans,RowCrossings),
        output_data(File,tocr,RowCrossings).







find_rows_crossing_status(Crop,MutantRowsPlans,RowCrossings) :-
        find_rows_crossing_status(Crop,MutantRowsPlans,[],RowCrossings).



find_rows_crossing_status(_,[],A,A).
find_rows_crossing_status(Crop,[Row-_-(_,_,_,_,_,_,_,Plan,_)|T],Acc,RowCrossings) :-
        ( plan_includes(observe,Plan,ObserveElt) ->
                selectchk(ObserveElt,Plan,CrossPlan)
        ;
                CrossPlan = Plan
        ),

        ( CrossPlan == [] ->
                NewAcc = Acc
        ;
                ( integer(Row) ->
                        RowNum = Row
                ;
                        remove_row_prefix(Row,RowNum) 
                ),
                ( plan_includes(self,Plan,SelfElt) ->
                        selfs_in_row_so_far(Crop,RowNum,SelfingStatus),
                        selectchk(SelfElt,CrossPlan,RestPlan)
                ;
                        RestPlan = CrossPlan
                ),
                ( RestPlan == [] ->
                        true
                ;     
                        ( row_members(Crop,RowNum,RowMembers) ->
                                count_inbred_crosses_to_do(Crop,RestPlan,RowMembers,InbredCrossStatus)
%                                count_inbred_crosses_to_do_by_male(Crop,RestPlan,RowMembers,InbredCrossStatus)
                        ;
                                InbredCrossStatus = []
                        )
                ),
                condensed_row_status(InbredCrossStatus,CondensedStatus),
                total_status(CondensedStatus,SelfingStatus,TotalStatus),
                ( TotalStatus == [done] ->
                        NewAcc = Acc
                ;
                        append(Acc,[RowNum-TotalStatus],NewAcc)
                )
        ),

        find_rows_crossing_status(Crop,T,NewAcc,RowCrossings).






% count by female, which is not quite what we want; see below

count_inbred_crosses_to_do(_,[],_,[]).
count_inbred_crosses_to_do(Crop,[Inbred|T],RowMembers,[Inbred-Status|T2]) :-
        ( string_length(Inbred,1) ->
                count_inbred_crosses_so_far_by_female(Inbred,RowMembers,Num),
                ToDo is 3 - Num,
                ( ToDo =< 0 ->
                        Status = 0
                ;
                        Status = ToDo
                )
        ;


% a bit rough-and-ready:  come back and handle the "if available" case more accurately
%
% Kazic, 8.8.09

                Status = 0
        ),
        count_inbred_crosses_to_do(Crop,T,RowMembers,T2).





count_inbred_crosses_so_far_by_female(Inbred,RowsMembers,Num) :-
        count_inbred_crosses_so_far_by_female(Inbred,RowsMembers,0,Num).



% this counts by totals by inbred; but really what I want is
% the different inbreds per male.  So if the plan is S, W, M, and
% three males are chosen, then each male should be crossed to S, W, and
% M.
%
% Kazic, 10.8.09

count_inbred_crosses_so_far_by_female(_,[],N,N).
count_inbred_crosses_so_far_by_female(Inbred,[PlantID|T],Acc,Num) :-
        ( ( cross(Ma,PlantID,ear(1),false,_,_,_,_),
            midstring(Ma,Inbred,_,7) ) ->
                NewAcc is Acc + 1
        ;
                NewAcc = Acc
        ),
        count_inbred_crosses_so_far_by_female(Inbred,T,NewAcc,Num).








% count by male instead

% stopped here . . . more to do

count_inbred_crosses_to_do_by_male(RestPlan,RowMembers,InbredCrossStatus) :-
        length(_Inbreds,NumInbredsNeeded),
        count_inbred_crosses_to_do_by_male(NumInbredsNeeded,RestPlan,RowMembers,[],MalesCrossed),
        count_totals_by_male(MalesCrossed,InbredCrossStatus).




count_inbred_crosses_to_do_by_male(_,_,[],A,A).
count_inbred_crosses_to_do_by_male(NumInbredsNeeded,Inbreds,[PlantID|T],Acc,InbredCrossStatus) :-
        ( find_inbred_crosses_for_male(PlantID,Inbreds,Crosses) ->
                count_inbreds_done_for_male(Crosses,NumInbredsNeeded,MaleToDo),
                append(Acc,[PlantID-MaleToDo],NewAcc)
        ;
                NewAcc = Acc
        ),
        count_inbred_crosses_to_do_by_male(NumInbredsNeeded,Inbreds,T,NewAcc,InbredCrossStatus).



        



find_inbred_crosses_for_male(_,[],[]).
find_inbred_crosses_for_male(PlantID,[Inbred|T],[Inbred-Num|T2]) :-
        ( string_length(Inbred,1) ->
                Prefix = Inbred
        ;
                midstring(Inbred,Prefix,_0,1)
        ),
        ( setof(Ma,(B^P^D^T^cross(Ma,PlantID,ear(1),false,B,P,D,T),F^midstring(Ma,Inbred,F,7)),Mas) ->
                length(Mas,Num)
        ;
                Num = 0
        ),
        find_inbred_crosses_for_male(PlantID,T,T2).









% count_inbred_crosses_so_far_by_male(_,[],A,A).
% count_inbred_crosses_so_far_by_male([Inbred|T],RowMembers,Acc,Num) :-



        
              
condensed_row_status(InbredCrossStatus,CondensedStatus) :-
        remaining(InbredCrossStatus,Remainder),
        ( Remainder == [] ->
                CondensedStatus = done
        ;
                CondensedStatus = Remainder
        ).






remaining(InbredCrossStatus,CondensedStatus) :-
        remaining(InbredCrossStatus,[],CondensedStatus).


remaining([],A,A).
remaining([Inbred-Num|T],Acc,CondensedStatus) :-
        ( ( var(Num)
          ;
            Num =:= 0 ) ->
                NewAcc = Acc
        ;
                append(Acc,[Inbred-Num],NewAcc)
        ),
        remaining(T,NewAcc,CondensedStatus).






total_status(CondensedStatus,SelfingStatus,TotalStatus) :-
        ( ( CondensedStatus == done,
            ( SelfingStatus == done 
            ;
              var(SelfingStatus) ) ) ->
                TotalStatus = [done]
        ;
                ( ( CondensedStatus \== done,
                    ( SelfingStatus == done 
                    ;
                      var(SelfingStatus) ) ) ->
                        TotalStatus = [crosses-CondensedStatus]
                ;
                        ( ( CondensedStatus == done,
                            ( SelfingStatus \== done 
                            ; 
                              nonvar(SelfingStatus) ) ) ->
                                TotalStatus = [selfs-SelfingStatus]
                        ;
                                TotalStatus = [selfs-SelfingStatus,crosses-CondensedStatus]
                        )
                )
        ).
 







% find all mutant plants that participated in a pollination other than selfing, that are marked
% for photography, and that have not yet been photographed.
%
% These plants are the first priority for photography; as we get further along I will compute the list
% of plants marked for photography that were not crossed but have not yet been photographed.
%
% Kazic, 18.8.09

find_crossed_plants_to_photo(Date,File) :-
        setof(Row-Plant,photo_plant(Date,Plant,Row),Plants),
        not_yet_photographed(Plants,UnSorted),
        sort(UnSorted,UnPhotoed),
        output_data(File,phto,UnPhotoed).




photo_plant(Date,Plant,Row) :-
        cross(Ma,Plant,_,_,_,_,CrossDate,_),
        Ma \== Plant,
        Date @>= CrossDate,
        ( mutant(Plant,_,_,photo,_,_,ScoringDate,_) ->
                true
        ;
                construct_date(ScoringDate,EasyDate),
                format('Warning!  ~w was crossed but not scheduled for photography on ~w!  check plant and record~n',[Plant,EasyDate])
        ),
        get_row(Plant,PaddedRow),
        atom_number(PaddedRow,Row).






find_uncrossed_plants_to_photo(File) :-
        setof(Row-Plant,uncrossed_photo_plant(Plant,Row),Plants),
        sort(Plants,UnPhotoed),
        output_data(File,phto,UnPhotoed).




uncrossed_photo_plant(Plant,Row) :-
        mutant(Plant,_,_,photo,_,_,_,_),
        \+ image(Plant,_,_,_,_,_,_,_,_),
        \+ cross(_,Plant,_,_,_,_,_,_),
        get_row(Plant,PaddedRow),
        atom_number(PaddedRow,Row).







not_yet_photographed(Plants,UnPhotoed) :-
        not_yet_photographed(Plants,[],UnPhotoed).



not_yet_photographed([],A,A).
not_yet_photographed([Row-Plant|Plants],Acc,UnPhotoed) :-
        ( image(Plant,_,_,_,_,_,_,_,_) ->
                NewAcc = Acc
        ;
                append(Acc,[Row-Plant],NewAcc)
        ),
        not_yet_photographed(Plants,NewAcc,UnPhotoed).
        











% quick, find the mutant daddies that were bagged for tomorrow!

find_daddies(Date,File) :-
        ( setof(RowPlant-(PlantID,Mas,Plan,ToDo),ready_daddy(Date,PlantID,RowPlant,Mas,Plan,ToDo),Daddies) ->
                true
        ;
                Daddies = []
        ),
        output_data(File,dads,Daddies).




ready_daddy(Date,PlantID,RowPlant,Mas,Plan,ToDo) :-
        ( cross_prep(PlantID,Prep,_,Date,_)
	;
          arg(1,Date,Day),
          MorningBag is Day + 1,
          arg(2,Date,Mo),
          arg(3,Date,Yr),
          cross_prep(PlantID,Prep,_,date(MorningBag,Mo,Yr),_)
        ),
        memberchk(bag(tassel),Prep),
%        deconstruct_plantID(PlantID,Crop,Family,_RowNum,_PlantNum),
%        make_rowplant(RowNum,PlantNum,RowPlant),
        get_crop(PlantID,Crop),
        get_family(PlantID,Family),
        get_rowplant(PlantID,RowPlant),
        plan_for_row(Crop,Family,Plan),


% I can recognize the selfs because I have the ear tag, but they will appear in
% the crosses, so sort that out in the to-do list
        
        ( setof(Ma,Pil^Da^Time^cross(Ma,PlantID,ear(1),false,toni,Pil,Da,Time),Mas) ->
                ( make_todo_list_aux(Mas,Plan,ToDo) ->
                        true
                ;
                        Mas = [],
                        ToDo = unk
                )
	;
                Mas = [],
                ToDo = all
        ).





plan_for_row(Crop,Family,Plan) :-
        genotype(Family,_,Ma,_,Pa,_,_,_,_,_,_),
        ( plan(Ma,Pa,_,FullPlan,_,Crop) ->
                ( plan_includes(observe,FullPlan,Elt) ->
                        selectchk(Elt,FullPlan,Plan)
		;
                        Plan = FullPlan
                )
        ;


% ignore plans for the inbreds, since these are complex and unhelpful in this context
%
% Kazic, 8.8.09

                ( inbred(Family,_) ->
                        true
                ;
                        format('Warning!  plan_for_row/3 cannot find the plan for family ~w, ~w x ~w, which is probably from the stock center.~n',[Family,Ma,Pa])
                )
        ).













make_todo_list_aux(Mas,Plan,ToDo) :-
        ( plan_includes(self,Plan,Elt) ->
                  selectchk(Elt,Plan,Next)
         ;
                  Next = Plan
         ),
         ( Next == [] ->
                 ToDo = Next
          ;
                 check_mommies(Next,Mas,ToDo)
         ).






check_mommies(Next,Mas,ToDo) :-
        nonvar(Next),
        check_mommies(Next,Mas,[],ToDo).




check_mommies([],_,A,A).
check_mommies([Elt|T],Mas,Acc,ToDo) :-
        ( ( member(Ma,Mas),
            midstring(Ma,Elt,_,_) ) ->
                NewAcc = Acc
	;
                append(Acc,[Elt],NewAcc)
        ),
        check_mommies(T,Mas,NewAcc,ToDo).










% given a crop and list of rows in order or priority,
% take the most recent row_status fact for the rows in each planting, 
% and generate the input file for ../../label_making/make_plant_tags.perl.  
% The output is in order of the rows to get the plants tagged in order of need.
%
% removed argument for list of plantings since it's much better to use the
% hand-and-brain-generated priority_rows/2 fact.
%
% Kazic, 30.7.2011



% call: generate_plant_tags_file('15R','/home/toni/demeter/results/15r_planning/fgenotype.pl','/home/toni/demeter/results/15r_planning/plant_list.csv').




generate_plant_tags_file(Crop,GTypeFile,TagFile) :-
        generate_plant_tags_file_aux(Crop,GTypeFile,TagData),
        keys_and_values(TagData,Rows,_),
        check_for_missing_rows(Rows),
        output_data(TagFile,plntags,TagData).






% Now shutting off re-use of old family numbers so that genotype/11 facts can be corrected.
% We have now filled in all the previous gaps due to manual assignment, and we need to retire
% genotype facts that were created in error, as revealed by the re-inventory of the winter, 2014.
%
% shut off generation of intercalated family numbers!
%
% Kazic, 22.5.2014
%
%
% Done.  Also fixed logic error so that header is formatted in any case.
%
% Kazic, 19.6.2014




% hey, phasma can''t write to athe!  so open a temporary genotype file in results
%
% Kazic, 4.8.2015

generate_plant_tags_file_aux(Crop,GTypeFile,TagData) :-
        priority_rows(Crop,Rows),
        once(find_available_mutant_family_numbers(IntercalatedNums,LastFamilyNum)),

        open(GTypeFile,write,GStream),


% want to generate header no matter what!  So just deleted the IntercalatedNums == [] conditional.
%
% Kazic, 19.6.2014

        format(GStream,'~n~n~n~n%%%%%%%%% automatically added families for ~w crop; check calculated genotype data! %%%%%%%%%%%%%%~n~n',[Crop]),

        get_tag_data(GStream,Crop,Rows,IntercalatedNums,LastFamilyNum,TagData),
        close(GStream).








 




get_planted_rows(Crop,Dates,Rows) :-
        get_planted_rows_aux(Crop,Dates,[],ListRows),
        sort(ListRows,Rows).


get_planted_rows_aux(_,[],A,A).
get_planted_rows_aux(Crop,[Date|Dates],Acc,ListRows) :-
        setof(Row,Pkt^Ft^Pltr^Time^Soil^planted(Row,Pkt,Ft,Pltr,Date,Time,Soil,Crop),Rows),
        append(Acc,Rows,NewAcc),
        get_planted_rows_aux(Crop,Dates,NewAcc,ListRows).

        



% must assign families if these do not already exist and accession ears into the genotype.pl file
% max_plants is stand count + 1
%
% $barcode_elts are of the form:  Crop . Family . : . Prefix
%
%
% for the newly revised Perl script and modules, the input data are:
%
%  ($barcode_elts,$prow,$max_plant,$family,$ma_family,$ma_num_gtype,$pa_family,$pa_num_gtype,$ma_gma_gtype,$ma_gpa_gtype,$pa_gma_gtype,$pa_mutant,$quasi_allele) 


% oops!  this does not work for the inbreds because so many different lines are constructed from
% the same parents!  So our inbred tags had the wrong families for 09r.  Have fixed this for now by hand
% but the predicate must be revised for next year.
%
% Kazic, 13.7.09
%
% well, evidently fixed as inbred families now correct
%
% Kazic, 27.7.2011



get_tag_data(GStream,Crop,Rows,IntercalatedNums,LastFamilyNum,TagData) :-
        get_tag_data(GStream,Crop,Rows,IntercalatedNums,LastFamilyNum,[],TagData).


get_tag_data(_,_,[],_,_,A,A).
get_tag_data(GStream,Crop,[Row|Rows],IntercalatedNums,LastFamilyNum,Acc,TagData) :-

        ( integer(Row) ->
                OutputRow = Row
        ;
                remove_row_prefix(Row,OutputRow)
        ),

        ( identify_row(Crop,Row,Row-(PRow,Family,Ma,Pa,MaGma,MaGpa,PaGma,PaMutant,Marker,Quasi)) ->


% a new line, such as the selfs, will return with an 
% instantiated Family and numerical genotypes but uninstantiated genetic markers;
% searching for the genotype fact based on just 
% THAT family will return a fact, but for the parents, not the offspring.
%
% Searching by both family and parental numerical genotypes will return no fact; so first clause is ok
% so the logic in second clause is flawed
%
% Kazic, 19.7.2010
%
% all fixed and tests out correctly, so far as I know
%
% Kazic, 19.7.2010
%
% no, still something wrong; the original genotype for family 622 fails compute_genotype/12, but I can''t figure out why.
% Everything enters that predicate instantiated, but right now I just can''t see why that should be so. 
% Just kludged the genotype fact for now.
%
% Kazic, 9.6.2012

                ( ( nonvar(Family),
                    genotype(Family,MaFam,Ma,PaFam,Pa,MaGma,MaGpa,PaGma,PaMutant,Marker,Quasi) ) ->
                        RestIntNums = IntercalatedNums,
                        NextFamilyNum = LastFamilyNum,
                        NewFamily = Family
		;
	
%
% oops! still need to assign a family here!  For example, to the selfs of the prior year!
%
	
                        \+ genotype(Family,MaFam,Ma,PaFam,Pa,MaGma,MaGpa,PaGma,PaMutant,_,Quasi),
                        deconstruct_plantID(Ma,_,MaFam,_,_),
                        genotype(MaFam,_,_,_,_,PmaMaGma,PmaMaGpa,PmaPaGma,PmaPaMutant,_,_),
                        deconstruct_plantID(Pa,_,PaFam,_,_),
                        genotype(PaFam,_,_,_,_,PpaMaGma,PpaMaGpa,PpaPaGma,PpaPaMutant,Marker,Quasi),
                        ( ( nonvar(Family),
                            Family == MaFam,
                            Family == PaFam ) ->
                                ( ( nonvar(MaGma),
                                    nonvar(MaGpa),
                                    nonvar(PaGma),
                                    nonvar(PaMutant),
                                    nonvar(Marker),
                                    nonvar(Quasi) ) ->
                                        compute_genotype(PmaMaGma,PmaMaGpa,PmaPaGma,PmaPaMutant,PpaMaGma,PpaMaGpa,PpaPaGma,PpaPaMutant,MaGma,MaGpa,PaGma,PaMutant),
                                        assign_family(IntercalatedNums,LastFamilyNum,RestIntNums,NextFamilyNum,NewFamily),
                                        format('Warning!  assigned family ~d and genotype for row ~q, ~w x ~w~n~n',[NewFamily,Row,Ma,Pa]),
                                        output_tentative_genotype(GStream,NewFamily,MaFam,Ma,PaFam,Pa,PmaMaGma,PmaMaGpa,PmaPaGma,PmaPaMutant,PpaMaGma,PpaMaGpa,PpaPaGma,PpaPaMutant,MaGma,MaGpa,PaGma,PaMutant,Marker,Quasi)
	
	
	
                                ;
                                        compute_genotype(PmaMaGma,PmaMaGpa,PmaPaGma,PmaPaMutant,PpaMaGma,PpaMaGpa,PpaPaGma,PpaPaMutant,MaGma,MaGpa,PaGma,PaMutant),
                                        assign_family(IntercalatedNums,LastFamilyNum,RestIntNums,NextFamilyNum,NewFamily),
                                        format('Warning!  assigned family ~d and genotype for row ~q, ~w x ~w~n',[NewFamily,Row,Ma,Pa]),
                                        output_tentative_genotype(GStream,NewFamily,MaFam,Ma,PaFam,Pa,PmaMaGma,PmaMaGpa,PmaPaGma,PmaPaMutant,PpaMaGma,PpaMaGpa,PpaPaGma,PpaPaMutant,MaGma,MaGpa,PaGma,PaMutant,Marker,Quasi)
	
                                )
                       ;
	
                                compute_genotype(PmaMaGma,PmaMaGpa,PmaPaGma,PmaPaMutant,PpaMaGma,PpaMaGpa,PpaPaGma,PpaPaMutant,MaGma,MaGpa,PaGma,PaMutant),
                                assign_family(IntercalatedNums,LastFamilyNum,RestIntNums,NextFamilyNum,NewFamily),
                                format('Warning!  assigned family ~d and genotype for row ~q, ~w x ~w~n',[NewFamily,Row,Ma,Pa]),
                                output_tentative_genotype(GStream,NewFamily,MaFam,Ma,PaFam,Pa,PmaMaGma,PmaMaGpa,PmaPaGma,PmaPaMutant,PpaMaGma,PpaMaGpa,PpaPaGma,PpaPaMutant,MaGma,MaGpa,PaGma,PaMutant,Marker,Quasi)
                                
                        )
                ),
	
                ( ( find_current_stand_count(Row,Crop,NumPlants),
                            NumPlants \== 0 ) ->
                        make_barcode_elts(Crop,NewFamily,BarcodeElts),
                        append(Acc,[PRow-(BarcodeElts,OutputRow,NumPlants,
                                          NewFamily,MaFam,Ma,PaFam,Pa,MaGma,Marker,Quasi)],NewAcc)
                ;
                        NewAcc = Acc
                )
        ;
%
%
% ah ha! we just hit this condition for the first time in 15r at row 98:  the planted fact wasn''t recorded
% and it couldn''t be reconstructed, since we changed the field so many times due to the weather.  So we
% created a bogus line to be planted in that row (that was fine, it just needs to come from a prior crop),
% but the last two variables had not been instantiated.  This is now fixed.
%
% Vatsa and Kazic, 4.8.2015
%
%
                format('Warning! Row ~d cannot be identified!  Check planting and row_status facts.~n',[OutputRow]),
                NewAcc = Acc,
                RestIntNums = IntercalatedNums,
                NextFamilyNum = LastFamilyNum
        ),

        get_tag_data(GStream,Crop,Rows,RestIntNums,NextFamilyNum,NewAcc,TagData).







assign_family([H|T],N,T,N,H).
assign_family([],Last,[],Next,Next) :-
        Next is Last + 1.

assign_family([],Last,Lost,Next,Next) :-
        var(Lost),
        Next is Last + 1.








output_tentative_genotype(GStream,Family,MaFam,Ma,PaFam,Pa,PmaMaGma,PmaMaGpa,PmaPaGma,PmaPaMutant,PpaMaGma,PpaMaGpa,PpaPaGma,PpaPaMutant,
                                                                                                  MaGma,MaGpa,PaGma,PaMutant,Marker,Quasi) :-
        compute_genotype(PmaMaGma,PmaMaGpa,PmaPaGma,PmaPaMutant,PpaMaGma,PpaMaGpa,PpaPaGma,PpaPaMutant,MaGma,MaGpa,PaGma,PaMutant),
        format(GStream,'fgenotype(~d,~d,~q,~d,~q,~q,~q,~q,~q,~q,~q).~n',[Family,MaFam,Ma,PaFam,Pa,MaGma,MaGpa,PaGma,PaMutant,Marker,Quasi]).




compute_genotype(PmaMaGma,PmaMaGpa,PmaPaGma,PmaPaMutant,PpaMaGma,PpaMaGpa,PpaPaGma,PpaPaMutant,MaGma,MaGpa,PaGma,PaMutant) :-
        compute_genotype(PmaMaGma,PmaMaGpa,MaGma),
        compute_genotype(PmaPaGma,PmaPaMutant,MaGpa),
        compute_genotype(PpaMaGma,PpaMaGpa,PaGma),
        compute_genotype(PpaPaGma,PpaPaMutant,PaMutant).




compute_genotype(ParentA,ParentB,Offspring) :-
        ( ParentA == ParentB ->
                Offspring = ParentA
        ;
                atomic_list_concat([ParentA,'/',ParentB],Offspring)
        ).















check_for_missing_rows(Rows) :-
        sort(Rows,[H|T]),
        ( integer(H) ->
                Num = H
        ;
                remove_row_prefix(H,Num)
        ),
        check_for_missing_rows(Num,T).



check_for_missing_rows(_,[]).
check_for_missing_rows(Prior,[H|T]) :-
        ( integer(H) ->
                Num = H
        ;
                remove_row_prefix(H,Num)
        ),


        ( Num is Prior + 1 ->
                Next = Num,
                Test = T
        ;
                Next is Prior + 1,
                format('Warning!  row ~d missing.~n',[Next]),
                Test = [H|T]
        ),
        check_for_missing_rows(Next,Test).














% how far done are we today?

monitor_progress(Crop,File) :-
        identify_rows(Crop,Lines),
        determine_progress(Crop,Lines,Progress),
        output_progress(File,Crop,Progress).



determine_progress(Crop,Lines,Progress) :-
        split_rows_by_type(Lines,Mutants,S,W,M,_FunCorn),
        determine_progress_aux(Crop,Mutants,MutantProgress),
        inbred_building(S,SProgress),
        inbred_building(W,WProgress),
        inbred_building(M,MProgress),
        ord_union([MutantProgress,SProgress,WProgress,MProgress],Progress).




split_rows_by_type(Lines,Mutants,S,W,M,FunCorn) :-
        split_rows_by_type(Lines,[],Mutants,[],S,[],W,[],M,[],FunCorn).


split_rows_by_type([],Mut,Mut,S,S,W,W,M,M,Fun,Fun).
split_rows_by_type([Row-(PRow,F,Ma,Pa,MGma,MGpa,PGma,PGpa,Marker,K)|Lines],MutAcc,Mutants,SAcc,S,WAcc,W,MAcc,M,FunAcc,FunCorn) :-
        ( inbred(F,Inbred) ->
                 ( Inbred == 'S' ->
                         NewMutAcc = MutAcc,
                         append(SAcc,[Row-(PRow,F,Ma,Pa,MGma,MGpa,PGma,PGpa,Marker,K)],NewSAcc),
                         NewWAcc = WAcc,
                         NewMAcc = MAcc,
                         NewFunAcc = FunAcc
                 ;
                         ( Inbred == 'W' ->
                                 NewMutAcc = MutAcc,
                                 NewSAcc = SAcc,
                                 append(WAcc,[Row-(PRow,F,Ma,Pa,MGma,MGpa,PGma,PGpa,Marker,K)],NewWAcc),
                                 NewMAcc = MAcc,
                                 NewFunAcc = FunAcc
                         ;
                                 Inbred == 'M',
                                 NewMutAcc = MutAcc,
                                 NewSAcc = SAcc,
                                 NewWAcc = WAcc,
                                 append(MAcc,[Row-(PRow,F,Ma,Pa,MGma,MGpa,PGma,PGpa,Marker,K)],NewMAcc),
                                 NewFunAcc = FunAcc
                         )
                 )
        ;
                 ( fun_corn(F) ->
                         NewMutAcc = MutAcc,
                         NewSAcc = SAcc,
                         NewWAcc = WAcc,
                         NewMAcc = MAcc,
                         append(FunAcc,[Row-(PRow,F,Ma,Pa,MGma,MGpa,PGma,PGpa,Marker,K)],NewFunAcc)
                 ;
                         append(MutAcc,[Row-(PRow,F,Ma,Pa,MGma,MGpa,PGma,PGpa,Marker,K)],NewMutAcc),
                         NewSAcc = SAcc,
                         NewWAcc = WAcc,
                         NewMAcc = MAcc,
                         NewMAcc = MAcc,
                         NewFunAcc = FunAcc
                 )
         ),
         split_rows_by_type(Lines,NewMutAcc,Mutants,NewSAcc,S,NewWAcc,W,NewMAcc,M,NewFunAcc,FunCorn).















determine_progress_aux(_,[],[]).
determine_progress_aux(Crop,[Row-(PRow,F,Ma,Pa,MGma,MGpa,PGma,PGpa,Marker,K)|Lines],[Row-Progress|ListProgress]) :-
        determine_progress_aux_aux(Crop,Row,PRow,F,Ma,Pa,MGma,MGpa,PGma,PGpa,Marker,K,Progress),
        determine_progress_aux(Crop,Lines,ListProgress).









determine_progress_aux_aux(Crop,Row,PRow,Family,Ma,Pa,MGma,MGpa,PGma,PGpa,Marker,K,
                                         status(Plan,Observations,Pollinations,Notes)) :-
        find_mutant_row_plan(Crop,Row-(PRow,Family,Ma,Pa,MGma,MGpa,PGma,PGpa,Marker,K),Plan,Notes),         
        construct_plantIDs(Crop,Row,Family,Plants),
        split_plan(Plan,ObservatnPlan,PollinatnPlan),
        status(Plants,ObservatnPlan,observatn,Observations),
        status(Plants,PollinatnPlan,pollinatn,Pollinations).









split_plan(Plan,ObservatnPlan,PollinatnPlan) :-
        ( plan_includes(observe,Plan,Elt) ->
                selectchk(Elt,Plan,PollinatnPlan),
                ObservatnPlan = [observe]
        ;
                ObservatnPlan = [],
                PollinatnPlan = Plan
        ).





status(Plants,Plan,Type,Status) :-
        target_plants(Plants,CrossTargets,PhotoTargets,FurtherTargets),
        ( Type == observatn ->
                check_status(scoring,Plants,_,Scoring),
                check_status(photography,PhotoTargets,_,Photography),
                check_status(further,FurtherTargets,_,FurtherInquiry),
                Status = o(Scoring,Photography,FurtherInquiry)
        ;
                Type == pollinatn,
                check_status(selfs,Plants,Plan,Selfs),
                check_status(cross,CrossTargets,Plan,Crosses),
                Status = p(Selfs,Crosses)
        ).





target_plants(Plants,CrossTargets,PhotoTargets,FurtherTargets) :-
        target_plants(Plants,[],CrossTargets,[],PhotoTargets,[],FurtherTargets).




target_plants([],C,C,P,P,F,F).
target_plants([PlantID|Plants],CrossAcc,CrossTargets,PhotoAcc,PhotoTargets,FurtherAcc,FurtherTargets) :-
        mutant(PlantID,_,CrossPlan,PhotoPlan,FurtherPlan,_,_,_),
        ( CrossPlan == false ->
                NewCrossAcc = CrossAcc
        ;
                ( CrossPlan == maybe ->
                        append(CrossAcc,[PlantID-maybe],NewCrossAcc)
                ;
                        append(CrossAcc,[PlantID],NewCrossAcc)
                )
        ),
        ( PhotoPlan == false ->
                NewPhotoAcc = PhotoAcc
        ;
                append(PhotoAcc,[PlantID],NewPhotoAcc)
        ),
        ( FurtherPlan == [] ->
                NewFurtherAcc = FurtherAcc
        ;
                append(FurtherAcc,[PlantID-FurtherPlan],NewFurtherAcc)
        ),
        target_plants(Plants,NewCrossAcc,CrossTargets,NewPhotoAcc,PhotoTargets,NewFurtherAcc,FurtherTargets).









check_status(Type,List,Plan,Status) :-
        ( List == [] ->
                Status = nil
        ;
                ( Type == scoring ->
                        check_status_aux(List,mutant,Status)
                ;
                        ( Type == photography ->
                                check_images(List,Status)
                        ;
                                ( Type == selfs ->
                                        check_status_aux(List,self,Plan,Status)
                                ;
                                        ( Type == cross ->
                                                check_status_aux(List,cross,Plan,Status)
                                        ;
                                                format('Warning! unconsidered case in check_status/5~n~n',[])
                                        )
                                )
                        )
                )
        ).







check_status_aux(List,mutant,Status) :-
          ( foreach(Plant,List,(mutant(Plant,Phenotype,_,_,_,_,_,_),Phenotype \== [])) ->
                    Status = done
          ;
                    Status = 'score row'
          ).





check_status_aux(List,self,Plan,Status) :-
        ( plan_includes(self,Plan,_) ->
                count_selfs(List,Status)
        ;
                Status = nil
        ).







% stopped here

% for the row to be done, each target plant must be crossed to each inbred
%
% for each elt in the plan, take the first character; for each mutant in the target list, see
% if it has been crossed to that inbred;
%
% maybe better to organize by target plants than inbreds; if so reverse order of previous stmt
%
% inbred letter will be the 7th character of the plantID, starting from 0 at left


check_status_aux(List,cross,Plan,Status) :-
        ( ( memberchk(Inbred,Plan) 
          ;
          ( member(PlanElt,Plan),
            midstring(PlanElt,Inbred,_,0) ) )  ->
                find_cross(List,Inbred,Status)
        ;
                atomic_list_concat([Inbred,'-nil'],Status)
        ).







count_selfs(List,Status) :-
        count_selfs(List,0,NumSelfs),
        ( NumSelfs >= 5 ->
                Status = done
        ;
                Needed is 5 - NumSelfs,
                atom_number(Atom,Needed),
                atomic_list_concat(['need ',Atom,' more selfs'],Status)
        ).




count_selfs([],N,N).
count_selfs([Plant|Plants],CurrNum,TotalNum) :-
        ( cross(Plant,Plant,ear(1),false,toni,_,_,_) ->
                Next is CurrNum + 1
        ;
                Next = CurrNum
        ),
        count_selfs(Plants,Next,TotalNum).














% stopped here too


% find_cross(List,Inbred,Status) :-
        

% find_cross([],_,[]).
% find_cross([Plant|Plants],Inbred,











% there should be at least one for each targeted plant in the row

check_images([],[]).
check_images([Plant|Plants],[Plant-Status|StatusT]) :-
        ( image(Plant,_,_,_,_,_,_,_,_) ->
                Status = done
        ;
                Status = photograph
        ),
        check_images(Plants,StatusT).











% ok, some rows failed; here is how to find what seed to repack
%
% call: [load_demeter,crop_management],repack_packets(repack_these,'09R',[1,10,12,16,26,68,69,117]).
%
% BUT do not replant these in rows already planted as they will be shaded; instead, plant them in 'swing rows'
%
% Kazic, 24.7.09

repack_packets(File,Crop,ListRows) :-
        find_packets(Crop,ListRows,Packets),
        output_data(File,pkt,Packets).





find_packets(Crop,ListRows,Packets) :-
        identify_rows(Crop,ListRows,Lines),
%        grab_packets(Crop,Lines,Packets).
        grab_packets(Lines,Packets).



% grab_packets(Crop,Lines,Packets) :-
grab_packets(Lines,Packets) :-
%        grab_packets(Crop,Lines,[],Unsorted),
        grab_packets(Lines,[],Unsorted),
        sort(Unsorted,Packets).



% grab_packets(_,[],A,A).
grab_packets([],A,A).
% grab_packets(Crop,[Row-(_,F,Ma,Pa,_,_,_,_,_,_)|Rows],Acc,Packets) :-
grab_packets([Row-(_,F,Ma,Pa,_,_,_,_,_,_)|Rows],Acc,Packets) :-
        ( F >= 1000 ->

                inventory(Ma,Pa,num_kernels(Num),_,_,_,Sleeve),
                ( check_quantity_cl(Ma,Pa,Num) ->
                        append(Acc,[Sleeve-(Ma,Pa,Row)],NewAcc)
	        ;
                        format('Warning! not enough kernels for ~w x ~w in sleeve ~w~n',[Ma,Pa,Sleeve]),
                        NewAcc = Acc
                )
        ;
                append(Acc,[box0-(Ma,Pa,Row)],NewAcc)
        ),
%        grab_packets(Crop,Rows,NewAcc,Packets).
        grab_packets(Rows,NewAcc,Packets).










% and now that I know, how much seed was originally planted?
%
% this is kludgey for two reasons:  seed packing should be folded into row identification, as
% same facts called twice for different arguments;  and temporarily using the planting_aux/6 facts
% until the planting/8 facts generated from them.
%
% Kazic, 19.6.09

seed_planted(Crop,Rows,SeedPacked) :-
        identify_rows(Crop,Rows,RowInfo),
        find_seed_packed(Crop,RowInfo,SeedPacked).





% [crop_management:'../data/planting_aux.pl'],seed_planted('09R',[t00198,t00199,t00200,t00201,t00202,t00204,t00205,t00206,t00207,t00208,t00209,t00210,t00211],X),write_list(X).



% two problems here.
%
% need the date on the packed_packet, since packet numbers re-used among crops.  Compare to Crop dates to ensure correct packet, 
% but pick closest date packet packed, which might be two years before the crop in which it was planted (e.g. for 09r).  Need a 
% predicate for ``contemporaneous packet''.
%
% convert to use planted/8 rather than planting_aux!
%
% Kazic, 20.11.2009

find_seed_packed(_,[],[]).
find_seed_packed(Crop,[Row-(_,_,Ma,Pa,MGma,MGpa,PGma,PaMutant,Marker,K)|Rows],
                 [Row-(Ma,Pa,TotalSeed,MGma,MGpa,PGma,PaMutant,Marker,K)|Packed]) :-
        packed_packet(Packet,Ma,Pa,_,_,_,_),
        bagof(Seed,RowPot^Plntg^Spacing^planting_aux(Crop,RowPot,Packet,Plntg,Seed,Spacing),Seeds),
        sum_list(Seeds,TotalSeed),
        find_seed_packed(Crop,Rows,Packed).












% given the crop, compute the list of pollinations by date in row order and print to a file, using skips
%
% Allow all plants that were pollinated at least 40 days before today to be harvested together.
%
% The procedure followed for 10r should be implemented:  the peak of the pollinations is determined, and for 
% each pollination, its offset relative to the peak calculated (positive if pollinated before the peak, 0 if during
% the peak, negative if after the peak).  Then for each row, the mean, min, and max offsets are calculated, and
% the rows sorted first by min offset, then by row number.  The aim is to produce a file like 
% ../../crops/10r/management/harvest3.  A table of threshold dates and a table of bag color-coding is also
% included.  This made harvest very easy.
%
% Kazic, 18.9.2010

% call: order_harvest('09R','../results/harvest16').


order_harvest(Crop,File) :-
        utc_timestamp(TodaysTimeStamp),
        setof(Row-(Ma,Pa,DaysAfterPolltn,Worry),find_cross(Crop,TodaysTimeStamp,Row,Ma,Pa,DaysAfterPolltn,Worry),Ears),
        output_data(File,harv,Ears).









% 40 days after pollination is the canonical harvest date in Missouri, per
% Chris Browne.  He says there''s no need to wait until the plant is dead.
%
% Kazic, 17.9.09

% I''ve added a check to exclude selfs, since I now want to produce inbred x mutants; 
% inbred @ are in a separate list and the mutants selfs have already been harvested.
% Logic must be checked for each stage of harvest for each crop.
%
% Kazic, 26.9.09


% stopped here

% find_cross(Crop,TodaysTimeStamp,Row,Ma,Pa,EasyDate,Worry) :-

find_cross(Crop,TodaysTimeStamp,Row,Ma,Pa,DaysAfterPolltn,Worry) :-
        cross(Ma,Pa,ear(1),Status,toni,toni,Date,Time),
%        Ma \== Pa,
        \+ harvest(Ma,Pa,_,_,_,_,_),
        \+ goofed(Crop,Ma,Pa,_Inbred,Status,Date,Time),
        get_crop(Ma,Crop),
        get_crop(Pa,Crop),
%        ( check_day_lower_bound(40,TodaysTimeStamp,(Date,Time)) ->
        ( calculate_days_since_pollinatn(TodaysTimeStamp,(Date,Time),DaysAfterPolltn) ->
                get_row(Ma,PaddedRow),
                extract_row(PaddedRow,Row),
%                construct_date(Date,EasyDate),
                ( Status == false ->
                        true
                ;
                        Worry = Status
                )
        ;
                false
        ).





order_by_rows([],[]).
order_by_rows([_-_-(Row,Date,Ma,Pa,Status)|T],[Row-(Ma,Pa,Date,Status)|T2]) :-
        order_by_rows(T,T2).














% call:  harvest_inbred_selfs('09R','../results/harvest_inbred_selfs27').


harvest_inbred_selfs(Crop,File) :-
        utc_timestamp(TodaysTimeStamp),
        setof(Family-(Row,Ma,DaysAfterPolltn,EasyDate,Worry),inbred_self(Crop,TodaysTimeStamp,Family,Row,Ma,DaysAfterPolltn,EasyDate,Worry),Ears),
        output_data(File,harvi,Ears).





inbred_self(Crop,TodaysTimeStamp,Family,Row,Ma,DaysAfterPolltn,EasyDate,Worry) :-
        cross(Ma,Ma,ear(1),Status,toni,toni,Date,Time),
        \+ harvest(Ma,Ma,_,_,_,_,_),
        get_family(Ma,Family),
        inbred(Family,Inbred),
        get_crop(Ma,Crop),
        \+ goofed(Crop,Ma,Ma,Inbred,Status,Date,Time),

        ( calculate_days_since_pollinatn(TodaysTimeStamp,(Date,Time),DaysAfterPolltn) ->
                get_row(Ma,PaddedRow),
                extract_row(PaddedRow,Row),
                construct_date(Date,EasyDate),
                ( Status == false ->
                        true
                ;
                        Worry = Status
                )
        ;
                false
        ).















% because there can be some . . . 

find_goofs(Crop,File) :-
        setof(Row-(Ma,Pa),goof(Crop,Row,Ma,Pa),Ears),
        output_data(File,harvg,Ears).





goof(Crop,Row,Ma,Pa) :-
        cross(Ma,Pa,ear(1),Status,toni,toni,Date,Time),
        get_crop(Ma,Crop),
        get_family(Ma,Family),
        inbred(Family,Inbred),
        goofed(Crop,Ma,Pa,Inbred,Status,Date,Time),
        get_row(Ma,PaddedRow),
        extract_row(PaddedRow,Row).





% this condition will vary with the year (I hope) ;-)
%
% 09r:  these were the "selfs" that in fact had lost their
% daddy tags.  They were not selfs for sure because that year each inbred
% was selfed in one day (different days for each), and Mo20W was not selfed on 
% July 30.

goofed('09R',Ma,Ma,'S',_,date(30,7,2009),_).
        



% we now have selves, so the plants must be photographed in situ
%
% Crop is the capitalized form that appears in numerical genotypes, e.g., 12R
%
% Kazic, 1.8.2012

find_in_situ_plants(Crop,File) :-
        setof(RowPlant,selfed_mutant(Crop,RowPlant),Plants),
        utc_timestamp_n_date(TimeStamp,Today),

        open(File,write,Stream),
        format(Stream,'% this is ~w, generated on ~w (~w) for crop ~w.~n~n',[File,Today,TimeStamp,Crop]),
        format(Stream,'% This is a list of plants to be photographed in situ because they have been selfed.~n',[]),
        format(Stream,'% The default is to photograph leaf e_1:  in any case do not photograph e_0.~n~n',[]),
        format(Stream,'% This file should be manually edited to remove recessive mutants that have been selfed.~n~n~n',[]),


        write_list(Stream,Plants),
        close(Stream).        



selfed_mutant(Crop,RowPlant) :-
        cross(Ma,Pa,_,_,_,_,_,_),
        Ma == Pa,
        string_length(Ma,15),
        midstring(Ma,_,Crop),
        get_family(Ma,Family),
        Family >= 1000,
        get_rowplant(Ma,RowPlant).
        


unselfed_male_parent(Crop,RowPlant) :-
        cross(Ma,Pa,_,_,_,_,_,_),
        Ma \== Pa,
        string_length(Ma,15),
        midstring(Ma,_,Crop),
        get_family(Ma,Family),
        Family >= 1000,
        get_rowplant(Ma,RowPlant).
        





find_unrecorded_pollinations(Crop,File) :-
        setof(Row-(Ma,Pa),unrecorded_pollination(Crop,Row,Ma,Pa),Ears),
        output_data(File,harvu,Ears).





unrecorded_pollination(Crop,Row,Ma,Pa) :-
        harvest(Ma,Pa,_,_,_,_,_),
        get_crop(Ma,Crop),
        \+ cross(Ma,Pa,_,_,_,_,_,_),
        get_row(Ma,PaddedRow),
        extract_row(PaddedRow,Row).




% like find_unrecorded_pollinations/2, but use the timestamps to get just that crop's data
%
% Kazic, 21.9.2010

find_unharvested_crosses(Crop,File) :-
        crop_timestamp(Crop,TimeStamp),
        setof(Row-(Ma,Pa),unharvested_cross(TimeStamp,Row,Ma,Pa),Ears),
        output_data(File,harvu,Ears).







% don't bother with ears that should be discarded!

unharvested_cross(TimeStamp,Row,Ma,Pa) :-
        cross(Ma,Pa,_,false,_,_,CDate,_),
        get_timestamp(CDate,time(_,_,_),CTimeStamp),
        CTimeStamp > TimeStamp,
        \+ harvest(Ma,Pa,_,_,_,_,_),
        get_row(Ma,PaddedRow),
        extract_row(PaddedRow,Row).








harvested_early(Crop,File) :-
        setof(Row-(Ma,Pa,Delta),harvested_early(Crop,Row,Ma,Pa,Delta),Ears),
        output_data(File,harve,Ears).





harvested_early(Crop,Row,Ma,Pa,Delta) :-
        cross(Ma,Pa,ear(1),_,toni,toni,CrossDate,CrossTime),
        harvest(Ma,Pa,_,_,_,HarvestDate,HarvestTime),
        get_crop(Ma,Crop),
        ( early_harvest((CrossDate,CrossTime),(HarvestDate,HarvestTime),Delta) ->
                get_row(Ma,PaddedRow),
                extract_row(PaddedRow,Row)
        ;
                false
        ).







early_harvest((CrossDate,CrossTime),(HarvestDate,HarvestTime),Delta) :-
        get_timestamp(CrossDate,CrossTime,CrossTimeStamp),
        get_timestamp(HarvestDate,HarvestTime,HarvestTimeStamp),
        num_secs(40,ThresholdSecs), 
        Threshold is CrossTimeStamp + ThresholdSecs,
        Diff is HarvestTimeStamp - Threshold,
        ( Diff < 0 -> 
                num_secs(1,Secs),
                Delta is Diff/Secs
        ;
                false
        ).
