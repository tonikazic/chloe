% this is demeter/code/choose_lines.pl

% a collection of predicates to choose among alternative 
% lines for planting and print out the data in a form ready for
% packaging in seed packets.
%
% Kazic, 15.5.09



%declarations%



:-      module(choose_lines, [
                choose_lines/2,
                find_max/3,
                foundational_line/3,
                fuzzy_max/3,
                max/3
                ]).





:-      use_module(demeter_tree('code/genetic_utilities')),
        use_module(demeter_tree('code/pedigrees')),
        use_module(demeter_tree('code/demeter_utilities')),    
        use_module(demeter_tree('data/load_data')).




:-      ensure_loaded(library(lists)),
        ensure_loaded(library(ordsets)),
        ensure_loaded(library(sets)),
%
% libraries not in SICStus Prolog
%
%        ensure_loaded(library(listparts)),
%        ensure_loaded(library(basics)),
        ensure_loaded(library(not)),
        ensure_loaded(library(flatten)),
        ensure_loaded(library(strings)).

%end%






% call: [load_demeter,choose_lines],choose_lines('10r','../results/10r_planning/pack.pl').
%
% fiddled, but couldn't get the advice to work properly:
%
% call: [load_demeter,choose_lines],add_advice(choose_lines_aux/2,fail,retry),check_advice(choose_lines_aux/2),choose_lines('09r','crops/09r/management/mutant_packing.pl').
%
% (ignore klotho/moirai errors:  not everything called from there is loaded)




% data in the input File are of the form
%
% pack(NumPacketsNeeded,ListAlternativeLines).
%
% each line of the form
%
% (MaNumGtype,PaNumGtype) if they're my lines, and otherwise
%
% (StockNumOrMutant)
%
% in which case they'll be in box0, here denoted 0
%
% Kazic, 5.5.2009
%
%
% revised to use most recent inventory facts!
%
% Kazic, 27.5.09
%
%
% for now, the output is dumped into a subdirectory of results that must be manually created;
% it must be moved manually to the appropriate subdirectory of crops on /athe/c/maize
%
% Kazic, 27.5.2010






choose_lines(Crop,File) :-
        [File],
        setof(NumPackets-Alternatives,pack(NumPackets,Alternatives),Choices),
        choose_lines_aux(Choices,Chosen),
        sort(Chosen,Sorted),
        generate_output(Crop,Sorted).






% changed to permit use of Ma x Pa syntax which is cut and pasted directly
% from the pedigrees
%
% Kazic, 27.5.2010


choose_lines_aux([],[]).
choose_lines_aux([NumPackets-CrossAlternatives|Choices],[Locatn-(NumPackets,MaNumGtype,PaNumGtype,Family)|Chosen]) :-
        ( convert_parental_syntax(CrossAlternatives,Alternatives) ->
                true
        ;
                format('Warning!  choose_lines:choose_lines_aux/2 calls an unconsidered case in genetic_utilities:convert_parental_syntax/2 for ~w~n',[CrossAlternatives]),
                trace
        ),
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

                        ( choose_line(Alternatives,MaNumGtype,PaNumGtype,Family,Locatn) ->
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
        ),
        choose_lines_aux(Choices,Chosen).











% here is where we would read the cl, ft data from a modified pack.pl and
% the row_sequence data from row_sequence.pl
%
% Kazic, 22.4.2011
%
% stopped here
%
% obsolete for the moment
%
% Kazic, 25.4.2011

find_location(MaNumGtype,PaNumGtype,Family,Locatn) :-
        ( inventory(MaNumGtype,PaNumGtype,num_kernels(NumCl),_,_,_,Locatn) ->
                ( check_quantity_cl(MaNumGtype,PaNumGtype,NumCl) ->
                        ( genotype(Family,_,MaNumGtype,_,PaNumGtype,_,_,_,_,_,_) ->
                                true
		        ;
                                format('Warning! family not yet assigned for ~w x ~w~n',[MaNumGtype,PaNumGtype]),
                                Family = '0000'
                        )
	        ;
                        format('Warning!  not enough seed for ~w x ~w: find an alternative line!~n',[MaNumGtype,PaNumGtype])
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





% need to modify definitions to include B73
%
% Kazic, 22.4.2011

foundational_line(MaNumGtype,Family,Locatn) :-
        ( deconstruct_plantID(MaNumGtype,_,Family,Row,Plant) ->
                ( number(Family) ->
                        FamilyNum = Family
                ;                

                        atom_chars(Family,FamChars),
                        number_chars(FamilyNum,FamChars)
                ),
                FamilyNum < 1000,
                ( nonvar(Row) -> 
                        Row == 0
                ;
                        var(Row)
                ),
                ( nonvar(Plant) ->
                        Plant == 0
                ;
                        var(Plant)
                )
         ;
                Family = '0000'
         ),
         Locatn = 0.




        





% add test for fungus in seed; reject seed if harvest fact indicates fungus
%
% harvest('09R1130:0001205','09R1130:0001205',succeeded,'fungus',toni,date(19,09,2009),time(12,31,29)).
%
% Kazic, 24.5.2010


choose_line([(MaNumGtype,PaNumGtype)|T],CMaNumGtype,CPaNumGtype,CFamily,CLocatn) :-
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
        choose_line(T,MaNumGtype,PaNumGtype,Family,Locatn,NumCl,CMaNumGtype,CPaNumGtype,CFamily,CLocatn).









choose_line([],M,P,F,L,_,M,P,F,L).
choose_line([(MaNumGtype,PaNumGtype)|T],MaxMa,MaxPa,MaxFam,MaxLoc,MaxNumCl,CMaNumGtype,CPaNumGtype,CFam,CLocatn) :-
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
                      format('unconsidered case for find_max/3 in choose_line/10 for ~w vs ~w~n',[NumCl,MaxNumCl])
                )
        ),
        choose_line(T,NewMaxMa,NewMaxPa,NewMaxFam,NewMaxLoc,NewMaxCl,CMaNumGtype,CPaNumGtype,CFam,CLocatn).



find_max(Term1,Term2,Term1) :- 
        Term1 == Term2.
find_max(Term1,Term2,Max) :-
        ( ( number(Term1),
            number(Term2) ) ->
                    ( Term1 >= Term2 ->
                            Max = Term1
                    ;
                            Max = Term2
                    )
        ;
                    ( ( \+ number(Term1),
                        \+ number(Term2) ) ->
                            max(Term1,Term2,Max)
                    ;
                            ( ( number(Term1),
                                \+ number(Term2) ) ->
                                    fuzzy_max(Term1,Term2,Max)
                            ;
                                    \+ number(Term1),
                                    number(Term2),
                                    fuzzy_max(Term2,Term1,Max)
                            )
                    )
        ).
               




% need all combinations in both directions!

max(whole,_,whole).
max(_,whole,whole).
%
%
max(three_quarter,half,three_quarter).
max(three_quarter,quarter,three_quarter).
max(three_quarter,eighth,three_quarter).
%
max(half,three_quarter,three_quarter).
max(quarter,three_quarter,three_quarter).
max(eighth,three_quarter,three_quarter).
%
%
max(half,quarter,half).
max(half,eighth,half).
%
max(quarter,half,half).
max(eighth,half,half).
%
%
max(eighth,quarter,quarter).
max(quarter,eighth,quarter).

        


fuzzy_max(Num,Term,Max) :-
        ( Num >= 200 ->
                find_max(whole,Term,Max)
        ;
                ( Num >= 100 ->
                        find_max(half,Term,Max)
                ;
                        ( Num >= 24 ->
                                find_max(quarter,Term,Max)
                        ;
                                format('Warning!  low kernel count for ~w cl!~n',[Num])
                        )
                )
        ).





% really want row_sequence number here, not family, except for inbreds
%
% Kazic, 22.4.2011


generate_output(Crop,Chosen) :-
        atomic_list_concat(['../results/',Crop,'_planning/packet_label_list.csv'],File),
        open(File,write,Stream),
        format(Stream,'% this is ~w~n',[File]),
        utc_timestamp_n_date(TimeStamp,UTCDate),
        format(Stream,'% generated ~w (=~w) by choose_lines/2.~n%~n',[UTCDate,TimeStamp]),
        format(Stream,'% This file is ready for processing by ../../label_making/make_seed_packet_labels.perl.~n%~n',[]),
        format(Stream,'% Data are of the form $packet,$family,$ma_num_gtype,$pa_num_gtype,$cl,$ft,$sleeve,$num_packets_needed.~n%~n%~n',[]),
        output_chosen(Stream,1,Chosen),
        close(Stream).




% revise inbred family numbers as needed
%
% Kazic, 16.5.09
%
% done for 10r
%
% Kazic, 24.5.10
%
% for 11r, to include B73
%
% Kazic, 22.4.2011

output_chosen(_,_,[]).
output_chosen(Stream,PacketNum,[Locatn-(NumPackets,MaNumGtype,PaNumGtype,Family)|Chosen]) :-
        ( memberchk(Family,[205,305,405,500]) ->
                 Cl = 20,
                 Ft = 20
        ;
                 Cl = 15,
                 Ft = 10
        ),
        format(Stream,'~w,~w,~w,~w,~w,~w,~w,~w~n',[PacketNum,Family,MaNumGtype,PaNumGtype,Cl,Ft,Locatn,NumPackets]),
        NewPacketNum is PacketNum + 1,
        output_chosen(Stream,NewPacketNum,Chosen).
