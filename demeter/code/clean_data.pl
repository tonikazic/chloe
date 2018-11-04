% this is demeter/code/clean_data.pl

% a collection of predicates to clean manually assigned families
% and genotypes
%
% Kazic, 21.2.09



%declarations%



:-      module(clean_data, [
                add_mutant_argument/1,
                assign_families_n_genotypes/2,
                check_planting_index_vs_identified_rows/1,
                check_family_assignments/1,
                clean_data/4,
                confect_planting_n_stand_count_data/4,
                find_asymmetric_families/1,
                find_available_family_numbers/1,
                find_available_family_numbers/2,
                find_available_mutant_family_numbers/2,
                get_existing_families/1,
                planting_to_planted/1,
                rewrite_source_n_genotype_facts_for_founders/2
                ]).





:-      use_module(demeter_tree('code/genetic_utilities')),
        use_module(demeter_tree('code/demeter_utilities')),
        use_module(demeter_tree('code/plan_crop')),
        use_module(demeter_tree('code/analyze_crop')),
        use_module(demeter_tree('data/load_data')).




:-      ensure_loaded(library(lists)),
        ensure_loaded(library(sets)),
        ensure_loaded(library(strings)),
        ensure_loaded(library(flatten)),
        ensure_loaded(library(ordsets)),
%
% libraries not in SICStus Prolog
%
%        ensure_loaded(library(basics)),
%        ensure_loaded(library(listparts)),
        ensure_loaded(library(date)).

%end%





% call: [load_demeter,clean_data],find_available_family_numbers(L).

% call: [clean_data],assign_families_n_genotypes('../data/test_07r_warnings','../data/test_07r_families.pl').
% [clean_data]. 
% call: assign_families_n_genotypes('../data/test_07r_warnings','../data/test_07r_families.pl').
%
% (ignore klotho/moirai errors:  not everything called from there is loaded)
%
% call: [load_demeter,clean_data],check_family_assignments('../results/_family_anomalies'),find_asymmetric_families('../results/_asymmetric_families').




clean_data(Functor,Arity,InFile,OutFile) :-
        compile(InFile),
        functor(Goal,Functor,Arity),
        setof(Goal,Goal,Goals),
        clean_data_aux(Functor,Arity,Goals,CleanedGoals),
        output_data(OutFile,CleanedGoals).





clean_data_aux(_,_,[],[]).
clean_data_aux(Functor,Arity,[Goal|T],[CleanedGoal|T2]) :-
        functor(IntGoal,Functor,Arity),
        clean_data_aux_aux(Arity,Goal,IntGoal,CleanedGoal),
        clean_data_aux(Functor,Arity,T,T2).




clean_data_aux_aux(0,_,G,G).
clean_data_aux_aux(Arity,Goal,IntGoal,CleanedGoal) :-
        arg(Arity,Goal,Arg),
        ( integer(Arg) ->
                NewArg = Arg
	;
                ( atom_number(Arg,NewArg) ->
                        true
	        ;
		        NewArg = Arg
                )
	),
        arg(Arity,IntGoal,NewArg),
        NewArity is Arity - 1,
	clean_data_aux_aux(NewArity,Goal,IntGoal,CleanedGoal).













% construct_family_information --- see find_families.pl
%
% use the family facts (construct these from the line facts) to get the genotype data





assign_families_n_genotypes(WarningFile,GenotypeFile) :-
       setof((MF,MN,PF,PN),G1^G2^lingenotype(MF,MN,PF,PN,G1,G2),ListLinGens),
       setof((OF,MF1,MN1,PF1,PN1,(MMa,MPa),(PMa,PPa),K),genotype(OF,MF1,MN1,PF1,PN1,MMa,MPa,PMa,PPa,K),ListGens),
       open(WarningFile,write,WStream),
       assign_families_n_genotypes(WStream,ListLinGens,ListGens,R),
       close(WStream),
       atomic_list_concat(['uniq ',WarningFile,'> tmp; sort tmp > tmp2; mv tmp2 ',WarningFile,'; rm tmp*'],Cmd),
       unix(system(Cmd)),       
       find_available_family_numbers(StartingNums),
       open(GenotypeFile,write,GStream),
       output_potential_genotypes(GStream,StartingNums,R),
       close(GStream).







% assign_families_n_genotypes(+WarningStream,+ListLingerGenotypess,+ListGenotypes,-Result).

assign_families_n_genotypes(_,[],_,[]).
assign_families_n_genotypes(Stream,[(MF,MN,PF,PN)|T],GenotypesSoFar,[(MF,MN,PF,PN,(MMa,MPa,PMa,PPa),(PMMa,PMPa,PPMa,PPPa),K)|T2]) :-
       ( memberchk((MF,_,_,_,_,(MMa,MPa),(PMa,PPa),_),GenotypesSoFar) ->
               find_male(Stream,PF,MN,PN,GenotypesSoFar,PMMa,PMPa,PPMa,PPPa,K)
       ;
               format(Stream,'Warning!  no genotype information for female ~w of family ~w crossed to male ~w of family ~w.~n',[MN,MF,PN,PF]),
               find_male(Stream,PF,MN,PN,GenotypesSoFar,PMMa,PMPa,PPMa,PPPa,K)
       ),
       assign_families_n_genotypes(Stream,T,GenotypesSoFar,T2).







find_male(Stream,PF,MN,PN,GenotypesSoFar,PMMa,PMPa,PPMa,PPPa,K) :-
        ( memberchk((PF,_,_,_,_,(PMMa,PMPa),(PPMa,PPPa),K),GenotypesSoFar) ->
                ( cross(MN,PN,Ear,Repeat,_,_,_,_) ->
                        ( ( Ear == ear(1), Repeat == false ) ->
                                true
                        ;
                                ( Ear == ear(2) ->
                                        format(Stream,'Warning!  second ear used in ~w x ~w found.~n',[MN,PN])
                                ;
                                        true
                                ),
                                ( ( Repeat == repeat
                                  ;
                                    Repeat == misbagged )  ->
                                        format(Stream,'Warning!  suspect ear in ~w x ~w found.~n',[MN,PN])
                                ;
                                        true
                                )
                        )
                ;
                        format(Stream,'Warning!  no cross of ~w x ~w found.~n',[MN,PN])
                )
        ;
                format(Stream,'Warning!  no genotype information for male ~w of family ~w.~n',[PN,PF])
        ).






% modified to reflect obsolescence of line genotypes
% and switch to genotype/11
%
% Kazic, 18.5.09
%
% only interested in family numbers greater than 1000, since these are only for mutants!
%
% Kazic, 19.7.2010


find_available_family_numbers(StartingNums) :-
        setof([N,M,P],(MN^PN^G1^G2^G3^G4^ML^K^genotype(N,M,MN,P,PN,G1,G2,G3,G4,ML,K), N > 999),L1),
        flatten(L1,FlatL1),
%
%        setof([N,M,P],MN^PN^G1^G2^G3^G4^K^genotype(N,M,MN,P,PN,G1,G2,G3,G4,K),L1),
%        setof([LM,LP],LMN^LPN^G5^G6^lingenotype(LM,LMN,LP,LPN,G5,G6),L2),
%        flatten(L2,FlatL2),
%        union(FlatL1,FlatL2,IntFams),
%        list_to_ord_set(IntFams,AllFams),
%
        list_to_ord_set(FlatL1,AllFams),
        find_gaps(AllFams,AvailableNums),
        filter_nums(AvailableNums,StartingNums).



% shut off generation of intercalated family numbers!
%
% Kazic, 22.5.2014

find_available_family_numbers(StartingNums,LastFamilyNum) :-
        setof([N,M,P],(MN^PN^G1^G2^G3^G4^ML^K^genotype(N,M,MN,P,PN,G1,G2,G3,G4,ML,K), N > 999),L1),
        flatten(L1,FlatL1),
        list_to_ord_set(FlatL1,AllFams),
        last(LastFamilyNum,AllFams),
        find_gaps(AllFams,AvailableNums),
        filter_nums(AvailableNums,StartingNums).






% we DON'T want to re-use old family numbers any more --- too confusing!
% So shut off find_gaps/2.
%
% Kazic, 19.6.2014

find_available_mutant_family_numbers(StartingNums,LastMutantFamilyNum) :-
        setof(N,(M^P^MN^PN^G1^G2^G3^G4^ML^K^genotype(N,M,MN,P,PN,G1,G2,G3,G4,ML,K), N > 999),AllMutantFams),
        last(LastMutantFamilyNum,AllMutantFams),
        StartingNums = [].
%
%        find_gaps(AllMutantFams,StartingNums).







% reset to only look for gaps in mutant family numbers, since inbred lines, popcorn, and sweet corn are all
% maintained by hand.
%
% Kazic, 19.7.2010

find_gaps(AllFams,StartingNums) :-
        find_gaps(AllFams,999,[],Gaps),
        list_to_ord_set(Gaps,StartingNums).





find_gaps([],_,A,A).
find_gaps([H],Test,Acc,StartingNums) :-
        ( H is Test + 1 ->
                find_gaps([],Test,Acc,StartingNums)
        ;
                ( H > Test + 1 ->
                        fill_gaps(H,Test,Gaps),
                        append(Gaps,Acc,NewAcc),
                        find_gaps([],H,NewAcc,StartingNums)
                ;
                        H =:= Test,
                        find_gaps([],Test,Acc,StartingNums)
                )
        ).




find_gaps([H|T],Test,Acc,StartingNums) :-
        ( H is Test + 1 ->
                find_gaps(T,H,Acc,StartingNums)
        ;
                ( H > Test + 1 ->
                        fill_gaps(H,Test,Filled),
                        append(Filled,Acc,NewAcc),
                        find_gaps(T,H,NewAcc,StartingNums)
                ;
                        H =:= Test,
                        find_gaps(T,H,Acc,StartingNums)
                )
        ).

    







% stopped here:  still need a termination condition to keep it from going into outer space!


fill_gaps(Num1,Num2,Filled) :-
        fill_gaps(Num1,Num2,[],Filled).




fill_gaps(N,N,A,A).
fill_gaps(Num1,Num2,Acc,Filled) :-
        Num3 is Num2 + 1,
        ( Num3 =:= Num1 ->
                fill_gaps(Num1,Num3,Acc,Filled)
        ;
                append([Num3],Acc,NewAcc),
                fill_gaps(Num1,Num3,NewAcc,Filled)
        ).








filter_nums(AvailableNums,StartingNums) :-
        filter_nums(AvailableNums,[],StartingNums).



% filter out families less than 1000; if numbers for newly accessioned mutants are needed,
% this will need to be altered to exclude the inbred numbers.

filter_nums([],A,A).
filter_nums([H|T],Acc,Nums) :-
        ( H < 1000 ->
                NewAcc = Acc
        ;
                append(Acc,[H],NewAcc)
        ),
        filter_nums(T,NewAcc,Nums).







output_potential_genotypes(_,_,[]).
output_potential_genotypes(Stream,LastFamilyNum,[(MF,MN,PF,PN,MaG,PaG,K)|T]) :-
         integer(LastFamilyNum),
         FamNum is LastFamilyNum + 1,
         format(Stream,'genotype(~d,~d,~q,~d,~q,~q,~q,~q).~n',[FamNum,MF,MN,PF,PN,MaG,PaG,K]),
         output_potential_genotypes(Stream,FamNum,T).

output_potential_genotypes(Stream,[H],[(MF,MN,PF,PN,MaG,PaG,K)|T]) :-
         format(Stream,'genotype(~d,~d,~q,~d,~q,~q,~q,~q).~n',[H,MF,MN,PF,PN,MaG,PaG,K]),
         output_potential_genotypes(Stream,H,T).


output_potential_genotypes(Stream,[H|T2],[(MF,MN,PF,PN,MaG,PaG,K)|T]) :-
         format(Stream,'genotype(~d,~d,~q,~d,~q,~q,~q,~q).~n',[H,MF,MN,PF,PN,MaG,PaG,K]),
         output_potential_genotypes(Stream,T2,T).










% convert genotype/10 to genotype/11 for more reliable search

add_mutant_argument(File) :-
        setof((F,MF,MN,PF,PN,MG1,MG2,PG1,PG2,K),genotype(F,MF,MN,PF,PN,MG1,MG2,PG1,PG2,K),L),
        get_mutant_genes(Gs),
        rewrite_facts(L,Gs,Rewritten),
        open(File,write,Stream),
        write_list(Stream,Rewritten),
        close(Stream).



rewrite_facts([],_,[]).
rewrite_facts([(F,MF,MN,PF,PN,MG1,MG2,PG1,PG2,K)|T],Genes,[genotype(F,MF,MN,PF,PN,MG1,MG2,PG1,PG2,G,K)|T2]) :-
        find_gene(Genes,MG1,MG2,PG1,PG2,G),
        rewrite_facts(T,Genes,T2).



find_gene(Genes,MG1,MG2,PG1,PG2,Gene) :-
        find_gene(Genes,MG1,MG2,PG1,PG2,'',Gene).


find_gene([],_,_,_,_,A,A).
find_gene([(G,_)|Genes],MG1,MG2,PG1,PG2,Acc,Gene) :-
        ( has_gene(MG1,MG2,PG1,PG2,G) ->
                NewAcc = G,
                find_gene([],MG1,MG2,PG1,PG2,NewAcc,Gene)
        ;
                NewAcc = Acc,
                find_gene(Genes,MG1,MG2,PG1,PG2,NewAcc,Gene)
        ).






% should modify this to use planting_index/4, crop/7, and planted/8 facts
%
% Kazic, 14.4.10

get_existing_families(File) :-
        setof(p(Crop,Row,Fam,Ma,Pa,Plntg,Cl,Ft),planting(Crop,Row,Fam,Ma,Pa,Plntg,Cl,Ft),L),
        open(File,write,Stream),
        grab_families(Stream,L),
        close(Stream).




grab_families(_,[]).
grab_families(Stream,[p(Crop,Row,Fam,Ma,Pa,Plntg,Cl,Ft)|T]) :-
        ( Fam == '' ->
                ( genotype(NewFam,_,Ma,_,Pa,_,_,_,_,_,_) ->
                        true
                ;
                        format('Warning! no genotype found family ~w new family ~w for ~w x ~w in crop ~w planting ~w.~n',[Fam,NewFam,Ma,Pa,Crop,Plntg])
                )
        ;
                NewFam = Fam
        ),
        format(Stream,'planting(~q,~q,~q,~q,~q,~d,~d,~d).~n',[Crop,Row,NewFam,Ma,Pa,Plntg,Cl,Ft]),
        grab_families(Stream,T).





%%%%% foo


% The original numerical gentoypes in donated lines is confusing the code, especially in crop_management!
% So I am putting that information in the source facts instead, and using my numerical genotypes in genotype.
%
% Thus the original facts:
%
%  source(1,'Mo20W/Les1','M. G. Neuffer',date(1,5,2006)).
%  genotype(1,1,'M18 112 012',1,'M18 114 512','Mo20W','Mo20W','Mo20W/+','Les1',['Les1'],'').
%
% became
%
%
%  source(1,'Mo20W/Les1','M18 112 012','M18 114 512','06R','M. G. Neuffer',date(1,5,2006)).
%  genotype(1,1,'06R0001:0000000',1,'06R0001:0000000','Mo20W','Mo20W','Mo20W/+','Les1',['Les1'],'').
%
% I converted source/4 to source/7 as the intermediate storage:
%
%  source(1,'Mo20W/Les1','','','06R','M. G. Neuffer',date(1,5,2006)).
%
% These data should have been in source all along!
%
% The predicate outputs the new facts to files, then I moved them by hand.
%
% Kazic, 1.8.09

% clean_data:rewrite_source_n_genotype_facts_for_founders(new_source,new_genotype).

rewrite_source_n_genotype_facts_for_founders(ChangedSourceFile,ChangedGTypeFile) :-
        setof(source(Line,Name,Ma,Pa,Crop,Donor,Date),source(Line,Name,Ma,Pa,Crop,Donor,Date),OldSourceFacts),
        rewrite_source_gtype_facts(OldSourceFacts,NewSourceFacts,NewGTypeFacts),
        open(ChangedSourceFile,write,Stream),
        write_list_facts(Stream,NewSourceFacts),
        close(Stream),
        open(ChangedGTypeFile,write,GStream),
        write_list_facts(GStream,NewGTypeFacts),
        close(GStream).




rewrite_source_gtype_facts(OldSourceFacts,NewSourceFacts,NewGTypeFacts) :-
        rewrite_source_gtype_facts(OldSourceFacts,[],NewSourceFacts,[],NewGTypeFacts).




rewrite_source_gtype_facts([],S,S,G,G).
rewrite_source_gtype_facts([source(Line,Name,_,_,Crop,Donor,Date)|T],SourceAcc,NewSourceFacts,
                                                               GTypeAcc,NewGTypeFacts) :-

        genotype(Line,MaF,OldMaNumGtype,PaF,OldPaNumGtype,MGma,MGpa,PGma,PGpa,Marker,K),
        ( deconstruct_plantID(OldMaNumGtype,_,_,_,_) ->
                NewSourceAcc = SourceAcc,
                NewGTypeAcc = GTypeAcc
        ;
                build_numerical_genotype(Line,Crop,NewNumGtype),
                append(SourceAcc,[source(Line,Name,OldMaNumGtype,OldPaNumGtype,Crop,Donor,Date)],NewSourceAcc),
                append(GTypeAcc,[genotype(Line,MaF,NewNumGtype,PaF,NewNumGtype,MGma,MGpa,PGma,PGpa,Marker,K)],NewGTypeAcc)
        ),
        rewrite_source_gtype_facts(T,NewSourceAcc,NewSourceFacts,NewGTypeAcc,NewGTypeFacts).








% need to convert the old planting/8 facts to the new planted/8 facts
% works!  The current planted/8 facts in planted.pl now include the old
% planting/8 data.
%
% Kazic, 19.11.09

planting_to_planted(File) :-
        bagof(planting(Crop,Row,MaFam,OldMa,OldPa,PlantingNum,Cl,Feet),planting(Crop,Row,MaFam,OldMa,OldPa,PlantingNum,Cl,Feet),L),
        convert_planting(L,Converted),
        flatten(Converted,Flat),
        sort(Flat,Sorted),
        output_data(File,foo,Sorted).





convert_planting(Facts,Converted) :-
        convert_planting(Facts,4,Converted).




convert_planting([],_,[]).
convert_planting([planting(Crop,Row,MaFam,OldMa,OldPa,PlantingNum,Cl,Feet)|Plantings],
                 NextPacket,
                 [[planted(PaddedRow,FakePacket,Feet,toni,PlntgDate,time(12,0,0),full,Crop),
                   packed_packet(FakePacket,StdMa,StdPa,Cl,toni,PackDate,time(12,0,0))]|T]) :-


% for 06r and lines from others

        ( ( source(MaFam,_,OldMa,OldPa,_,_,_),
            genotype(MaFam,MaFam,StdMa,MaFam,StdPa,_,_,_,_,_,_) ) ->
                NewMaFam = MaFam
        ;
                ( ( genotype(NewMaFam,_,OldMa,_,OldPa,_,_,_,_,_,_),
                    string_length(OldMa,15),
                    midstring(OldMa,':',_),
                    string_length(OldPa,15),
                    midstring(OldPa,':',_) ) ->
                        StdMa = OldMa,
                        StdPa = OldPa
                ;
                        ( integer(MaFam) ->
                                genotype(MaFam,_,StdMa,_,StdPa,_,_,_,_,_,_),
                                NewMaFam = MaFam
                        ;
                                format('Warning! unconsidered case for planting ~q in convert_planting/1~n',[planting(Crop,Row,MaFam,OldMa,OldPa,PlantingNum,Cl,Feet)]),
                                abort
                        )
                )
        ),
        build_row(Row,PaddedRow),
        crop(Crop,_,_,PlantingNum,PlntgDate,_,_),
        fake_packet(NewMaFam,NextPacket,NewPacket,FakePacket),
        assume_one_month(PlntgDate,PackDate),
        convert_planting(Plantings,NewPacket,T).




fake_packet(MaFam,NextPacket,NewPacket,FakePacket) :-
        nonvar(MaFam),
        ( memberchk(MaFam,[200,201,204]) ->
                FakePacket = p00001,
                NewPacket = NextPacket
        ;
                ( memberchk(MaFam,[300,301,304]) ->
                        FakePacket = p00002,
                        NewPacket = NextPacket
                ;
                        ( memberchk(MaFam,[400,401,403,404]) ->
                                FakePacket = p00003,
                                NewPacket = NextPacket
                        ;
                                build_packet(NextPacket,FakePacket),
                                NewPacket is NextPacket + 1
                        )
                )
        ).







% assume seed packed a month before planting

assume_one_month(PlntgDate,date(Day,Mon,Yr)) :-
        get_timestamp(PlntgDate,time(12,0,0),PlntgTS),
        num_secs(30,NumSecs),
        EarlierTS is PlntgTS - NumSecs,
        datime(EarlierTS,date(CYr,CMon,Day,_,_,_)),
        convert_qp_date_to_ours(CMon,CYr,Mon,Yr).








% why are pedigrees wierd?  identify_crops/2 worked fine when checked against spreadsheets,
% except for occasional manual errors in families.  But pedigrees are now very different. So
% compare the output of identify_row/3, which depends on planted facts, with the planting_index/4
% facts.  
%
% Kazic, 29.12.09
%
% think at least part of the problem is anomalies in families between genotype and inventory and planting_index
% facts.
%
% Kazic, 14.4.10


check_planting_index_vs_identified_rows(Crop) :-
        identify_rows(Crop,Lines),
        compare_to_index(Crop,Lines).




compare_to_index(_,[]).
compare_to_index(Crop,[PaddedRow-(_,F,M,P,_,_,_,_,R,K)|T]) :-
        ( memberchk(F,[200,201,205,300,301,305,400,401,403,405]) ->
                true
        ;
                ( integer(PaddedRow) ->
                        Row = PaddedRow
                ;
                        remove_row_prefix(PaddedRow,Row)
                ),
                ( planting_index(M,P,Crop,Row) ->
                        true
                ;
                        format('Warning! planting_index/4 not found for ~w x ~w planted in row ~w of crop ~w~n',[M,P,Row,Crop])
                ),
                ( genotype(F,_,M,_,P,_,_,_,_,R,K) ->
                        true
                ;
                        format('Warning! genotype/11 does not match for family ~w, ~w x ~w, ~w ~w planted in row ~w of crop ~w~n',[F,M,P,R,K,Row,Crop])
                )
        ),
        compare_to_index(Crop,T).










% ok, look for anomalies in family numbers in inventory and genotype facts
%
% Kazic, 14.4.10

check_family_assignments(File) :-
        bagof(MaNumGtype-(NewFam,MaFam,MaNumGtype,PaFam,PaNumGtype)-_,A^B^C^D^M^K^genotype(NewFam,MaFam,MaNumGtype,PaFam,PaNumGtype,A,B,C,D,M,K),Gtypes),
        bagof(IMaNumGtype-IPaNumGtype-T,N^Y^I^V^inventory(IMaNumGtype,IPaNumGtype,N,Y,T,I,V),InvTypes),

        screen_duplicate_mas(Gtypes,DupeGtypeMas,UndupedGtypes),
        screen_duplicate_mas(InvTypes,DupeInvTypeMas,UndupedInvTypes),
        screen_discrepant_numgtypes(UndupedInvTypes,UndupedGtypes,DiscrepantGtypes),
        screen_discrepant_genotype_families(UndupedGtypes,DiscrepantFamilies),
        output_results(File,DupeGtypeMas,DupeInvTypeMas,DiscrepantGtypes,DiscrepantFamilies).











% look for duplicated maternal numerical genotypes within a list; for now, exclude
% the duplicates from the list to be screened for family discrepancies.
%
% Kazic, 15.4.10

screen_duplicate_mas(NumGtypes,DupedNumGtypes,UndupedNumGtypes) :-
        screen_duplicate_mas(NumGtypes,[],DupedNumGtypes,[],UndupedNumGtypes).



screen_duplicate_mas([],A,A,B,B).
screen_duplicate_mas([MaNumGtype-X-D|Mas],DupeAcc,DupedNumGtypes,UndupedAcc,UndupedNumGtypes) :-
       ( selectchk(MaNumGtype-Y-YD,Mas,Rem) ->
               ( midstring(MaNumGtype,'xx',_,_) ->
                       NewUndupedAcc = UndupedAcc,
                       NewDupeAcc = DupeAcc
               ;
                       ( nonvar(D) ->
                               ( D == YD ->
                                       append(DupeAcc,[MaNumGtype-X,MaNumGtype-Y],NewDupeAcc),
                                       NewUndupedAcc = UndupedAcc
                               ;
		       		       NewDupeAcc = DupeAcc,
                                       append(UndupedAcc,[MaNumGtype-X],NewUndupedAcc)
                                       
                               )

                       ;
                               var(D),
                               append(DupeAcc,[MaNumGtype-X,MaNumGtype-Y],NewDupeAcc),
                               NewUndupedAcc = UndupedAcc
                       )
               )
       ;
               append(UndupedAcc,[MaNumGtype-X],NewUndupedAcc),
               NewDupeAcc = DupeAcc,
               Rem = Mas
       ),
       screen_duplicate_mas(Rem,NewDupeAcc,DupedNumGtypes,NewUndupedAcc,UndupedNumGtypes).












% check that inventory numerical genotypes match those in genotype facts; 
% otherwise if mas don't match, print separately; 
% if mas match but pas don't, print seperately

screen_discrepant_numgtypes(UndupedInvTypes,UndupedGtypes,DiscrepantGtypes) :-
        screen_discrepant_numgtypes(UndupedInvTypes,UndupedGtypes,[],DiscrepantGtypes).




screen_discrepant_numgtypes([],_,A,A).
screen_discrepant_numgtypes([InvMa-InvPa|UndupedInvTypes],UndupedGtypes,DiscrepanciesAcc,DiscrepantGtypes) :-
        ( memberchk(InvMa-(NewFam,MaFam,MaNumGtype,PaFam,InvPa),UndupedGtypes) ->
                NewDiscrepanciesAcc = DiscrepanciesAcc
        ;
                ( memberchk(InvMa-(NewFam,MaFam,MaNumGtype,PaFam,SomePa)-_,UndupedGtypes) ->
                        SomePa \== InvPa,
                        append(DiscrepanciesAcc,[InvMa-(NewFam,MaFam,MaNumGtype,PaFam,SomePa)],NewDiscrepanciesAcc)
                ;
                        append(DiscrepanciesAcc,[InvMa-InvPa],NewDiscrepanciesAcc)
                )
        ),
        screen_discrepant_numgtypes(UndupedInvTypes,UndupedGtypes,NewDiscrepanciesAcc,DiscrepantGtypes).









% check for inconsistent family nums in genotypes, print out

screen_discrepant_genotype_families(UndupedGtypes,DiscrepantFamilies) :-
        screen_discrepant_genotype_families(UndupedGtypes,[],DiscrepantFamilies).




screen_discrepant_genotype_families([],A,A).
screen_discrepant_genotype_families([MaNumGtype-(NewFam,MaFam,MaNumGtype,PaFam,PaNumGtype)|T],Acc,DiscrepantFamilies) :-
        get_family(MaNumGtype,PutMa),
        get_family(PaNumGtype,PutPa),
        ( PutMa == MaFam ->
                ( PutPa == PaFam ->
                        NewAcc = Acc
                ;
                        append(Acc,[NewFam-(PutPa,PaFam,PaNumGtype)],NewAcc)
                )
        ;
                        append(Acc,[NewFam-(PutMa,MaFam,MaNumGtype)],IntAcc),
                        ( PutPa == PaFam ->
                                NewAcc = IntAcc
                        ;
                                append(IntAcc,[NewFam-(PutPa,PaFam,PaNumGtype)],NewAcc)
                        )
        ),
        screen_discrepant_genotype_families(T,NewAcc,DiscrepantFamilies).










output_results(File,DupeGtypeMas,DupeInvTypeMas,DiscrepantGtypes,DiscrepantFamilies) :-
        open(File,write,Stream),
        format(Stream,'% this is ~w~n~n',[File]),
        utc_timestamp_n_date(UTCTimeStamp,Date),
        format(Stream,'% generated on ~w (= ~w) by clean_data:check_family_assignments/1.~n~n~n',[Date,UTCTimeStamp]),

        format(Stream,'~n~n% ============== list of maternal numerical genotypes duplicated in genotype/11 facts ========== ~n',[]),
        format(Stream,'% MaNumGtype-(NewFam,MaFam,MaNumGtype,PaFam,PaNumGtype) ~n~n',[]),
        write_list(Stream,DupeGtypeMas),

        format(Stream,'~n~n% ============== list of maternal numerical genotypes duplicated in inventory/7 facts ========== ~n',[]),
        format(Stream,'% this is ok if dates differ!~n',[]),
        format(Stream,'% MaNumGtype-PaNumGtype ~n~n',[]),
        write_list(Stream,DupeInvTypeMas),

        format(Stream,'~n~n% ============== list of maternal and paternal numerical genotype pairs in genotype/11 that do not match those in inventory/7 facts ========== ~n',[]),
        format(Stream,'% either InvMa-(NewFam,MaFam,MaNumGtype,PaFam,SomePa) if paternal gtype in genotype/11 doesn''t match that in inventory/7~n',[]),
        format(Stream,'%  or InvMa-InvPa if no pair can be found in genotype/11 that matches a pair in inventory/7~n~n',[]),
        write_list(Stream,DiscrepantGtypes),

        format(Stream,'~n~n% ============== list of maternal and paternal families differing within genotype/11 acts ========== ~n',[]),
        format(Stream,'% AssignedNewFam-(FamFromNumGtype,FamFromFact,PaNumGtype) where NewFam is the first argument of genotype/11~n~n',[]),
        write_list(Stream,DiscrepantFamilies),


        close(Stream).







% for each noninbred crop-row in packed_packet, look up the
% offspring family number; then in the genotype, check families of paternal
% crop-rows (any plant) for mismatch to designated family in genotype.
%
% Row-(Date,Packet,Crop) N^P^T^S^planted(Row,Packet,N,P,Date,T,S,Crop)
%
% Packet-(Date,Ma,Pa) C^P^T^packed_packet(Packet,Ma,Pa,C,P,Date,T)
%
% where Packet is not in {p00001,p00002,p00003}
%
% form Ma-(Pa,Crop,Row,MaFam,PaFam)
%
% Ma-(OffFam,MaFam,PaFam,Pa,MaCrop,MaRow,PaCrop,PaRow) from A^B^C^D^L^K^genotype(OffFam,MaFam,Ma,PaFam,Pa,A,B,C,D,L,K)
%
% identify_row(Crop,Row,Row-(PRow,OffF,Ma,Pa,MGma,MGpa,PGma,PGpa,Marker,K))
%
% 
%
%
% Ask a simpler question:  for all families found in paternal numerical genotypes in genotype/11,
% which ones are not found in the first argument of genotype/11?  And conversely.


find_asymmetric_families(File) :-
        setof(OffFam-(Ma,Pa),MF^PF^A^B^C^D^L^K^genotype(OffFam,MF,Ma,PF,Pa,A,B,C,D,L,K),OffspringFamilies),
        get_paternal_families_from_genotype(OffspringFamilies,PaternalFamilies),
        compare_families(OffspringFamilies,PaternalFamilies,OnlyOffspring,OnlyPaternal),
        output_results(File,OnlyOffspring,OnlyPaternal).





get_paternal_families_from_genotype([],[]).
get_paternal_families_from_genotype([_-(Ma,Pa)|OffspringFamilies],[PaFam-(Ma,Pa)|PaternalFamilies]) :-
       get_family(Pa,PaFam),
       get_paternal_families_from_genotype(OffspringFamilies,PaternalFamilies).







compare_families(OffspringFamilies,PaternalFamilies,OnlyOffspring,OnlyPaternal) :-
        compare_families_aux(OffspringFamilies,PaternalFamilies,Offspring),
        keysort(Offspring,OnlyOffspring),
        compare_families_aux(PaternalFamilies,OffspringFamilies,Paternal),
        keysort(Paternal,OnlyPaternal).






compare_families_aux(FirstBag,SecondBag,Result) :-
        compare_families_aux(FirstBag,SecondBag,[],Result).



compare_families_aux([],_,A,A).
compare_families_aux([Fam-(Ma,Pa)|Families],SecondBag,Acc,Result) :-
        ( memberchk(Fam-_,SecondBag) ->
                NewAcc = Acc
        ;

                ( selectchk(Fam-_,Acc,NewAcc) ->
                        true
                ;
                        append(Acc,[Fam-(Ma,Pa)],NewAcc)
                )

        ),
        compare_families_aux(Families,SecondBag,NewAcc,Result).






                        




grab_genotype_facts(_,[],[]).
grab_genotype_facts(Type,[Family|Families],[Family-Parents|Facts]) :-
        ( Type == off ->
                bagof((Ma,Pa),MF^PF^A^B^C^D^L^K^genotype(Family,MF,Ma,PR,Pa,A,B,C,D,L,K),Parents)
        ;
                Type == pas,
                bagof((Ma,Pa),F^MF^PF^A^B^C^D^L^K^genotype(F,MF,Ma,PR,Pa,A,B,C,D,L,K),Parents),
                get_family(Pa,Family)
        ),
        grab_genotype_facts(Type,Families,Facts).









output_results(File,OnlyOffspring,OnlyPaternal) :-
        open(File,write,Stream),
        format(Stream,'% this is ~w~n~n',[File]),
        utc_timestamp_n_date(UTCTimeStamp,Date),
        format(Stream,'% generated on ~w (= ~w) by clean_data:find_asymetric_families/1.~n~n~n',[Date,UTCTimeStamp]),

        format(Stream,'~n~n% ============== list of genotype/11 families only found in first argument ========== ~n',[]),
        format(Stream,'% Many lines are planted that are never crossed, or which crosses fail. ~n~n',[]),
        format(Stream,'% FirstArgFamily-(MaNumGtype,PaNumGtype) ~n~n',[]),
        write_list(Stream,OnlyOffspring),

        format(Stream,'~n~n% ============== list of genotype/11 families only found in paternal numerical genotype ========== ~n',[]),
        format(Stream,'% Lines in this category indicate a book-keeping error in the families. ~n~n',[]),
        format(Stream,'% PaFamily-(MaNumGtype,PaNumGtype) ~n~n',[]),
        write_list(Stream,OnlyPaternal),

        close(Stream).







% confect planted/8 for plantings not yet done, but need to generate 
% preliminary plant tags and field book.
%
% test genetic_utilities:next_day/2

% oops, also need to confect stand count data for the already planted!


% call is: confect_planting_n_stand_count_data('14R',date(16,06,2014),time(16,53,53),'../results/14r_planning/confection').

confect_planting_n_stand_count_data(Crop,PltngDate,PltngTime,File) :-
        ensure_loaded(other:'../data/later_plantings.pl'),
        setof(PaddedRow-p(Cl,Ft,Packet),grab_parents(Crop,PltngDate,PltngTime,PaddedRow,Cl,Ft,Packet),UnPlanted),
        next_day(PltngDate,StdCntDate),
        open(File,write,Stream),
        output_header(fake,File,Stream),
        write_fake_data(UnPlanted,PltngDate,PltngTime,StdCntDate,Crop,Stream),

        write_fake_stand_counts(Crop,StdCntDate,PltngDate,PltngTime,Stream),

        close(Stream).


%        write_list(UnPlanted).






grab_parents(Crop,PltngDate,PltngTime,PaddedRow,Cl,Ft,Packet) :-
        other:packing_plan(NumRow,_NumPkts,XParents,_Plntg,_Plan,_Comment,_K,Crop,Cl,Ft),
        convert_parental_syntax(XParents,TupleParents),
        arg(1,TupleParents,Tuple),
        arg(1,Tuple,Ma),
        arg(2,Tuple,Pa),
        build_row(NumRow,PaddedRow),
        closest_contemporaneous_packet(Crop,Packet,PltngDate,PltngTime,Ma,Pa).





write_fake_stand_counts(Crop,StdCntDate,PltngDate,PltngTime,Stream) :-
        setof(Row-Cl,grab_packed_kernels(Crop,PltngDate,PltngTime,Row,Cl),Plntd),
        write_fake_stand_counts_aux(Plntd,StdCntDate,PltngTime,Crop,Stream).


grab_packed_kernels(Crop,PltngDate,PltngTime,Row,Cl) :-
        planted(Row,Packet,_,_,_,_,_,Crop),
        closest_contemporaneous_packet_w_cl(Crop,Packet,PltngDate,PltngTime,Cl,_,_).






% use the PltngTime as the StdCntTime

write_fake_data([],_,_,_,_,_).
write_fake_data([PaddedRow-p(Cl,Ft,Packet)|UnPlanted],PltngDate,PltngTime,StdCntDate,Crop,Stream) :-
        format(Stream,'planted(~w,~w,~d,fake,~w,~w,full,~q).~n',
                                                 [PaddedRow,Packet,Ft,PltngDate,PltngTime,Crop]),
        format(Stream,'row_status(~w,num_emerged(~d),[phenotype(fake,~d)],fake,~w,~w,~q).~n',
                                                    [PaddedRow,Cl,Cl,StdCntDate,PltngTime,Crop]),
        write_fake_data(UnPlanted,PltngDate,PltngTime,StdCntDate,Crop,Stream).




write_fake_stand_counts_aux([],_,_,_,_).
write_fake_stand_counts_aux([Row-Cl|Plntd],StdCntDate,PltngTime,Crop,Stream) :-
        format(Stream,'row_status(~w,num_emerged(~d),[phenotype(fake,~d)],fake,~w,~w,~q).~n',
                                                    [Row,Cl,Cl,StdCntDate,PltngTime,Crop]),
        write_fake_stand_counts_aux(Plntd,StdCntDate,PltngTime,Crop,Stream).