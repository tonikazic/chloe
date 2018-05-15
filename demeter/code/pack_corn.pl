% this is demeter/code/pack_corn.pl

% generate the packing stickers from the new packing_plan facts; builds
% on choose_lines.pl and order_packets.pl
%
% Kazic, 24.4.2011



%declarations%



:-      module(pack_corn, [
                pack_corn/1
                ]).






:-      use_module(demeter_tree('code/choose_lines'), [
                find_max/3,
                foundational_line/3,
                fuzzy_max/3,
                max/3
                ]).





:-      use_module(demeter_tree('code/order_packets'), [
                append_to_planning_file/2,
                load_crop_planning_data/1
                ]).



:-      use_module(demeter_tree('code/genetic_utilities')),
        use_module(demeter_tree('code/demeter_utilities')),
        use_module(demeter_tree('code/pedigrees')),
        use_module(demeter_tree('data/load_data')).




:-      ensure_loaded(library(lists)),
        ensure_loaded(library(ordsets)),
        ensure_loaded(library(samsort)),
        ensure_loaded(library(sets)),
%
% libraries not in SICStus Prolog
%
        ensure_loaded(library(listparts)),
        ensure_loaded(library(basics)),
        ensure_loaded(library(listparts)),
        ensure_loaded(library(basics)),
        ensure_loaded(library(not)),
        ensure_loaded(library(flatten)),
        ensure_loaded(library(strings)).

%end%







% call: [load_demeter,pack_corn],pack_corn('15R').

% add a predicate to sort the corn first by sleeve, then by family if Ma inbred, and last by Ma Rowplant 
% for both selves and inbreds.  This simplifies packing and will help reduce packing errors.
% Trial algorithm in crop_management.pl is incorrect.
%
% Kazic, 9.6.2011

pack_corn(Crop) :-
        format('Warning! make sure maize/CROP/planning/ is present!~n',[]),
        load_crop_planning_data(Crop),
        check_row_numbering(Crop,Lines),
        organize_corn(Crop,Lines,Chosen),
        sort(Chosen,Sorted),
        generate_output(Crop,Sorted).








% false if numbers not consecutive or duplicated

check_row_numbering(Crop,Lines) :-
        bagof(RowSequenceNum-(NumPackets,SetAlternativeParents,
                             Plntg,CrossInstructns,SetInstructions,Crop,Cl,Ft),
                             NumPackets^SetAlternativeParents^
                             Plntg^CrossInstructns^SetInstructions^KNum^Crop^Cl^
                             Ft^packing_plan(RowSequenceNum,NumPackets,
			     SetAlternativeParents,Plntg,CrossInstructns,SetInstructions,
                                                   KNum,Crop,Cl,Ft),Lines),


        samsort(Lines,SortedBag),
        find_nonconsecutive_nums(SortedBag,NonconsecutiveNums),
        ( NonconsecutiveNums == [] ->
                true
	;
                format('Warning! row sequence numbers ~w are not consecutive!~n',[NonconsecutiveNums]),
                false
        ).





find_nonconsecutive_nums(Sorted,NonconsecutiveNums) :-
        find_nonconsecutive_nums(Sorted,[],NonconsecutiveNums).



% hmmm, not really the right test here, but leave for now
%
% Kazic, 26.4.2011

find_nonconsecutive_nums([],A,A).
find_nonconsecutive_nums([H-_],Acc,NonconsecutiveNums) :-
        ( Acc == [] ->
                 NewAcc = Acc
        ;
                 last(End,Acc),
                 ( H is End + 1 ->
                         NewAcc = Acc
                 ;
                         append(Acc,[H],NewAcc)
                 )
        ),
        find_nonconsecutive_nums([],NewAcc,NonconsecutiveNums).




find_nonconsecutive_nums([H1-_,H2-X|T],Acc,NonconsecutiveNums) :-
        ( H2 is H1 + 1 ->
                NewAcc = Acc
        ;
                append(Acc,[H1],NewAcc)
        ),
        find_nonconsecutive_nums([H2-X|T],NewAcc,NonconsecutiveNums).











% changed to permit use of Ma x Pa syntax which is cut and pasted directly
% from the pedigrees
%
% Kazic, 27.5.2010
%
%
% modified to include all of the instructions from the new packing_plan/10
% facts.
%
% Kazic, 24.4.2011
%
%
% handle the skipped rows explicitly:  the CrossInstructns test
%
% Kazic, 2.5.2011


organize_corn(_,[],[]).
organize_corn(Crop,[RowSequenceNum-(NumPackets,SetAlternativeParents,
                                  Plntg,CrossInstructns,SetInstructions,Crop,Cl,Ft)|Choices],
                 [Locatn-(RowSequenceNum,NumPackets,InbredPacketNum,MaNumGtype,PaNumGtype,Family,Plntg,
                                       CrossInstructns,SetInstructions,Crop,Cl,Ft)|Chosen]) :-
        ( convert_parental_syntax(SetAlternativeParents,Alternatives) ->
                true
        ;
                format('Warning!  pack_corn:organize_corn/3 calls an unconsidered case in genetic_utilities:convert_parental_syntax/2 for ~w~n',[SetAlternativeParents])
        ),

        ( CrossInstructns == [] ->
                Cl == 0,
                arg(1,Alternatives,(MaNumGtype,PaNumGtype)),
                MaNumGtype == PaNumGtype,
                get_family(MaNumGtype,Family),
                Family == 0000,
                Locatn = 0
        ;
                ( is_list(Alternatives) ->
                        length(Alternatives,Num),
                        ( Num =:= 1 ->
                                ( arg(1,Alternatives,(MaNumGtype,PaNumGtype)) ->
                                        find_location(MaNumGtype,PaNumGtype,Family,Locatn)
				;
                                        arg(1,Alternatives,StockOrMutant),
                                        MaNumGtype = StockOrMutant,
                                        Locatn = 0
                                )
			;


% if this fails because of fungus, call again with first ear in list, just grab location
%
% Kazic, 24.5.2010

                                ( mod_choose_line(Alternatives,MaNumGtype,PaNumGtype,Family,Locatn) ->
                                        true
                	        ;
                                        arg(1,Alternatives,Default),
                                        arg(1,Default,(MaNumGtype,PaNumGtype)),
                                        find_location(MaNumGtype,PaNumGtype,Family,Locatn),
                                        format('Warning! all ears in ~w have fungus, first one taken.~n',[Alternatives])
                	        )
                        )
                ;	        
                        compound(Alternatives),
                        arg(1,Alternatives,MaNumGtype),
                        arg(2,Alternatives,PaNumGtype),
                        find_location(MaNumGtype,PaNumGtype,Family,Locatn)
                )
        ),


% assign packet number if seed is an inbred; otherwise, leave it uninstantiated
%
% Kazic, 9.6.2014

        get_rowplant(MaNumGtype,MaRowPlant),
        ( MaRowPlant == xxxxxx ->
                current_inbred(Crop,Family,Family,_,InbredPacketNum)
        ;
                true
        ),
        organize_corn(Crop,Choices,Chosen).











% incorporates most_recent_datum/2
%
% Kazic, 24.4.2011
%
% shifted logic so that a warning for a missing family number is issued, even 
% if the kernel count is deemed too low.
%
% Kazic, 5.6.2014

find_location(MaNumGtype,PaNumGtype,Family,Locatn) :-
        ( setof(InvDate-InvTime-(MaNumGtype,PaNumGtype,Cl,Loc),
              inventory(MaNumGtype,PaNumGtype,num_kernels(Cl),_,InvDate,InvTime,Loc),InventoryFacts) ->
                most_recent_datum(InventoryFacts,_-(MaNumGtype,PaNumGtype,NumCl,Locatn)),
                ( check_quantity_cl(MaNumGtype,PaNumGtype,NumCl) ->
                        true
	        ;
                        format('Warning!  not enough seed for ~w x ~w: find an alternative line!~n',[MaNumGtype,PaNumGtype])
                ),

                ( genotype(Family,_,MaNumGtype,_,PaNumGtype,_,_,_,_,_,_) ->
                        true
		;
                        format('Warning! family not yet assigned for ~w x ~w~n',[MaNumGtype,PaNumGtype]),
                        Family = '0000'
                )

	;
                ( foundational_line(MaNumGtype,Family,Locatn) ->
                        ( var(PaNumGtype) ->
                                PaNumGtype = MaNumGtype
                        ;
                                true
                        )
                ;
                        format('Warning! inventory fact for ~w x ~w not found, choose again!~n',[MaNumGtype,PaNumGtype]),       
                        Family = '0000',
                        Locatn = -1
                )
        ).















% add test for fungus in seed; reject seed if harvest fact indicates fungus
%
% harvest('09R1130:0001205','09R1130:0001205',succeeded,'fungus',toni,date(19,09,2009),time(12,31,29)).
%
% Kazic, 24.5.2010

%%%% stopped here for now as no line choices in 11r
%
% plan is to incorporate most_recent_datum/2 and exploit more passed data
%
% Kazic, 24.4.2011


mod_choose_line([(MaNumGtype,PaNumGtype)|T],CMaNumGtype,CPaNumGtype,CFamily,CLocatn) :-
        ( inventory(MaNumGtype,PaNumGtype,num_kernels(NumCl),_,_,_,Locatn) ->
%
% insert fungus test here
% 

                ( genotype(Family,_,MaNumGtype,_,PaNumGtype,_,_,_,_,_,_) ->
                        true
	        ;
                        format('Warning! family not yet assigned for ~w x ~w~n',[MaNumGtype,PaNumGtype]),
                        Family = '0000'
                )
        ;
                ( foundational_line(MaNumGtype,Family,Locatn) ->
                        NumCl = 25
                ;
 
                        format('Warning! inventory fact for ~w x ~w not found, choose again!~n',[MaNumGtype,PaNumGtype]),       
                        NumCl = 0000,
                        Locatn = -1
                )
        ),
        mod_choose_line(T,MaNumGtype,PaNumGtype,Family,Locatn,NumCl,CMaNumGtype,CPaNumGtype,CFamily,CLocatn).









mod_choose_line([],M,P,F,L,_,M,P,F,L).
mod_choose_line([(MaNumGtype,PaNumGtype)|T],MaxMa,MaxPa,MaxFam,MaxLoc,MaxNumCl,CMaNumGtype,CPaNumGtype,CFam,CLocatn) :-
        ( inventory(MaNumGtype,PaNumGtype,num_kernels(NumCl),_,_,_,Locatn) ->
                ( genotype(Family,_,MaNumGtype,_,PaNumGtype,_,_,_,_,_,_) ->
                        true
	        ;
                        format('Warning! family not yet assigned for ~w x ~w~n',[MaNumGtype,PaNumGtype]),
                        Family = '0000'
                )
        ;
                ( foundational_line(MaNumGtype,Family,Locatn) ->
                        NumCl = 25
                ;

                        format('Warning! inventory fact for ~w x ~w not found, choose again!~n',[MaNumGtype,PaNumGtype]),       
                        Family = '0000',
                        NumCl = 0
                )
        ),
        ( NumCl == whole ->
               NewMaxMa = MaNumGtype,
               NewMaxPa = PaNumGtype,
               NewMaxFam = Family,
               NewMaxLoc = Locatn,
               NewMaxCl = NumCl
             
        ;
               ( find_max(NumCl,MaxNumCl,Max) ->
                      ( Max == NumCl ->
                              NewMaxMa = MaNumGtype,
                              NewMaxPa = PaNumGtype,
                              NewMaxFam = Family,
                              NewMaxLoc = Locatn,
                              NewMaxCl = NumCl
                      ;
                              NewMaxMa = MaxMa,
                              NewMaxPa = MaxPa,
                              NewMaxFam = MaxFam,
                              NewMaxLoc = MaxLoc,
                              NewMaxCl = MaxNumCl
                      )
                ;
                      format('unconsidered case for find_max/3 in mod_choose_line/10 for ~w vs ~w~n',[NumCl,MaxNumCl])
                )
        ),
        mod_choose_line(T,NewMaxMa,NewMaxPa,NewMaxFam,NewMaxLoc,NewMaxCl,CMaNumGtype,CPaNumGtype,CFam,CLocatn).








        



% generate two output files:  the flat file for the Perl script (which must be modified)
% and append to the plan.pl file
%
% Kazic, 24.4.2011


generate_output(Crop,Chosen) :-
        utc_timestamp_n_date(TimeStamp,UTCDate),
        convert_crop(Crop,LCrop),
        output_packet_label_file(LCrop,TimeStamp,UTCDate,Chosen),
        output_plan_file(LCrop,Chosen).










% all mutant packet labels start at 10 to preserve packet numbers
% 1 -- 9 for inbred lines!
%
% p00001 = Mo20W
% p00002 = W23
% p00003 = M14
% p00004 = B73
%
% Kazic, 24.4.2011


% adapted to accommodate move to phasma: phasma can''t write to athe''s partitions, so 
% stick it in phasma''s /home/toni/demeter/results/CROP_planning/packet_label_list.csv.
%
% Kazic, 15.5.2015

output_packet_label_file(LCrop,TimeStamp,UTCDate,Chosen) :-
%        atomic_list_concat(['../../maize/crops/',LCrop,'/planning/packet_label_list.csv'],File),
        atomic_list_concat(['/home/toni/demeter/results/',LCrop,'_planning/packet_label_list.csv'],File),
        open(File,write,Stream),
        format(Stream,'% this is ~w~n',[File]),
        format(Stream,'% generated ~w (=~w) by pack_corn/2.~n%~n',[UTCDate,TimeStamp]),
        format(Stream,'% This file is ready for processing by ../../label_making/make_seed_packet_labels.perl.~n%~n',[]),
        format(Stream,'% Data are of the form $packet,$family,$ma_num_gtype,$pa_num_gtype,$cl,$ft,$sleeve,$num_packets_needed,$row_sequence_num,$plntg.~n%~n%~n',[]),
        output_chosen(Stream,10,Chosen),
        close(Stream).







% order of arguments a bit unusual after adding RowSequenceNum and Plntg
%
% Kazic, 24.4.2011
%
% added an argument for the fixed inbred packet numbers; otherwise,
% increment the running packet number count.
%
% Kazic, 9.6.2014

output_chosen(_,_,[]).
output_chosen(Stream,PacketNum,[Locatn-(RowSequenceNum,NumPackets,InbredPacketNum,MaNumGtype,PaNumGtype,Family,Plntg,
                                               _,_,_,Cl,Ft)|Chosen]) :-
        ( var(InbredPacketNum) ->
                format(Stream,'~w,~w,~w,~w,~w,~w,~w,~w,~w,~w~n',[PacketNum,Family,MaNumGtype,PaNumGtype,Cl,Ft,Locatn,NumPackets,RowSequenceNum,Plntg]),
                NewPacketNum is PacketNum + 1
        ;
                format(Stream,'~w,~w,~w,~w,~w,~w,~w,~w,~w,~w~n',[InbredPacketNum,Family,MaNumGtype,PaNumGtype,Cl,Ft,Locatn,NumPackets,RowSequenceNum,Plntg]),
                NewPacketNum = PacketNum
        ),
        output_chosen(Stream,NewPacketNum,Chosen).







% rewrite facts to fit existing predicate in order_packets
%
% Kazic, 24.4.2011

output_plan_file(LCrop,Chosen) :-
        morph_into_plans(Chosen,Plans),
        append_to_planning_file(LCrop,Plans).







morph_into_plans([],[]).
morph_into_plans(
      [_-(_,_,_,MaNumGtype,PaNumGtype,_,Plntg,CrossInstructns,SetInstructions,Crop,_,_)|T1],
                     [plan(MaNumGtype,PaNumGtype,Plntg,CrossInstructns,SetInstructions,Crop)|T2]) :-
        morph_into_plans(T1,T2).
      
