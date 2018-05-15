% this is demeter/code/plan_crop.pl

% predicates to help in crop planning
%
% Kazic, 19.5.08




%declarations%



:-      module(plan_crop, [
                find_successful_pollinations/3,
                get_genotypes/1,
                get_mutant_genes/1,
                get_lines_by_gene/1


%		construct_family_information/?
                ]).





:-      use_module(demeter_tree('code/genetic_utilities')),
        use_module(demeter_tree('data/load_data')).









:-      ensure_loaded(library(lists)),
        ensure_loaded(library(flatten)),
        ensure_loaded(library(sets)),
%
% library not in SICStus Prolog
%
%       ensure_loaded(library(basics)),
        ensure_loaded(library(ordsets)),
        ensure_loaded(library(strings)),
        ensure_loaded(library(date)).





%end%







% call: [plan_crop], get_genotypes('../results/proposed_08r_planting').
% call: [plan_crop], spy(get_lines_by_gene/4), get_lines_by_gene('../results/all_mutant_lines').



get_lines_by_gene(File) :-
        setof((G,T),mutant_gene_type(G,T),Gs),
        get_lines_by_gene(Gs,Lines),
        output(lines,Lines,File).








get_lines_by_gene(Gs,Lines) :-
        setof(Crop,Place^Field^Planting^PDate^HarvestStartDate^HarvestEndDate^crop(Crop,Place,Field,Planting,PDate,HarvestStartDate,HarvestEndDate),Crops),
        get_lines_by_gene(Gs,Crops,[],Lines).




get_lines_by_gene([],_,A,A).
get_lines_by_gene([(G,T)|Gs],Crops,Acc,Lines) :-
        setof(T-G-GL,all_lines_of_gene(G,Crops,GL),L),
        issue_warning(G,L),
        append(Acc,L,NewAcc),
        get_lines_by_gene(Gs,Crops,NewAcc,Lines).








all_lines_of_gene(_,[],[]).
all_lines_of_gene(G,[Crop|Crops],[Crop-Sorted|Sorteds]) :-
         ( setof((Fam,MF,MN,PF,PN,MG1,MG2,PG1,PG2,K),get_line(G,Crop,Fam,MF,MN,PF,PN,MG1,MG2,PG1,PG2,K),CropGL) ->
                sort_by_male_rows(CropGL,Sorted)
	;
                Sorted = []
        ),
        all_lines_of_gene(G,Crops,Sorteds).





get_genotypes(File) :-
        proposed_next(L),
        get_mutant_genes(Gs),
        get_genotypes(L,Gs,Genotypes),
        output(genotypes,Genotypes,File).





get_mutant_genes(Gs) :-
        setof((G,T),mutant_gene_type(G,T),Gs).


mutant_gene_type(G,T) :-
        gene_type(G,_,_,T),
        T \== wild_type.





get_genotypes([],_,[]).
get_genotypes([Fam|T],Genes,[Type-Gene-(Fam,MF,MN,PF,PN,MG1,MG2,PG1,PG2,K)|T2]) :-
        ( genotype(Fam,MF,MN,PF,PN,MG1,MG2,PG1,PG2,Gs,K) ->
%                find_gene(MG1,MG2,PG1,PG2,Genes,[Type-Gene])
                 member(Gene,Gs),
                 memberchk((Gene,Type),Genes)
        ;
                format('~nWarning! no genotype found for family ~w!~n',[Fam])

        ),
        get_genotypes(T,Genes,T2).




find_gene(MG1,MG2,PG1,PG2,Genes,GeneNType) :-
        find_gene(MG1,MG2,PG1,PG2,Genes,[],GeneNType).



find_gene(_,_,_,_,[],A,A) :-
        A \== [].

find_gene(MG1,MG2,PG1,PG2,[],[],_) :-
        format('~nWarning! no gene_type/4 fact found for ~w,~w,~w,~w.~n',[MG1,MG2,PG1,PG2]).

find_gene(MG1,MG2,PG1,PG2,[(Gene,Type)|Genes],Acc,GeneNType) :-
        ( test_gene(PG2,Gene) ->
                append(Acc,[Type-Gene],NewAcc),
                Rest = []
        ;
                ( test_gene(PG1,Gene) ->
                        append(Acc,[Type-Gene],NewAcc),
                        Rest = []
                ;
                        ( test_gene(MG2,Gene) ->
                                append(Acc,[Type-Gene],NewAcc),
                                Rest = []
                        ;
                                ( test_gene(MG1,Gene) ->
                                        append(Acc,[Type-Gene],NewAcc),
                                        Rest = []
                                ;
                                        NewAcc = Acc,
                                        Rest = Genes
                                )
                        )
                )
        ),
        find_gene(MG1,MG2,PG1,PG2,Rest,NewAcc,GeneNType).











% this works well, but DOES NOT cover all possible ways in which a mutant can appear in a
% genotype.  Notable failures are mutant/?, mutant/+, mutant/(...).  Results can be quickly
% checked by eye.
%
% Kazic, 20.5.08

test_gene(Parent,Gene) :-
        ( midstring(Parent,Gene,AC,_,_,Offset) ->
                ( Offset =:= 0 ->
                        true
                ;
                        ( ( Offset =:= 1,
                            midstring(AC,_,'}') ) ->
                                true
                        ;
                                false
                        )
                )
        ;
                false
        ).












% for the 07R crop, how many successful pollinations used mutants and inbreds from the same
% planting?  A question quite relevant to the ever-shrinking 08r planting.
%
% Kazic, 3.6.08


find_successful_pollinations(Crop,Planting,File) :-
        setof(p(Type,Gene,Data,Interval),successful_pollination(Crop,Planting,Type,Gene,Interval,Data),L),
        setof(p(AType,AGene,AData,AInterval),APlanting^successful_pollination(Crop,APlanting,AType,AGene,AInterval,AData),AL),
        subtract(AL,L,Rest),
        length(L,NumWithinPlntg),
        length(AL,NumAllPlntg),
        Fraction is NumWithinPlntg/NumAllPlntg,
        open(File,write,Stream),
        format(Stream,'% this is ~w~n% generated 3.6.08 to determine how many successful ~w pollinations occurred within planting ~d~n~n~n',[File,Crop,Planting]),
        format(Stream,'% Of a total of ~d pollinations, ~d were within this planting, or ~2f.~n~n~n',[NumAllPlntg,NumWithinPlntg,Fraction]),
        format(Stream,'~n%%%%%%%%%% within planting pollinations %%%%%%%%%%%%% ~n~n',[]),
        output_genotypes(pollinations,Stream,L),
        format(Stream,'~n~n~n~n%%%%%%%%%% other pollinations %%%%%%%%%%%%% ~n~n',[]),
        output_genotypes(pollinations,Stream,Rest),
        close(Stream).




successful_pollination(Crop,Planting,Type,Gene,Interval,g(Fam,MF,MN,PF,PN,MG1,MG2,PG1,PG2,K)) :-
        inventory(MN,PN,_,_,_,_,_Sleeve),
        deconstruct_plantID(MN,Crop,_,Row,_),
        planting(Crop,Row,_,_,_,Planting,_,_),
        crop(Crop,_,_,Planting,PlantingDate,_,_),
        cross(MN,PN,_,_,_,_,Date,_),
        ( genotype(Fam,MF,MN,PF,PN,MG1,MG2,PG1,PG2,GeneList,K) ->
                true
        ;
                genotype(MF,_,MN,_,_,MG1,MG2,_,_,_,_),
                genotype(PF,_,PN,_,_,_,_,PG1,PG2,GeneList,K),
                format('~nWarning! family and genotype not yet assigned for ~w x ~w in crop ~w~n',[MN,PN,Crop])
        ),
        member(Gene,GeneList),
        gene_type(Gene,_,_,Type),
        interval_days(Date,PlantingDate,Interval).






% 86400 is the number of seconds in a regular day,
% plus or minus a leap second to keep the day locked to the earth's rotation.
% For our purposes a standard day is enough.


interval_days(PollDate,PlntgDate,Interval) :-
        get_timestamp(PollDate,time(0,0,0),PollTimeStamp),
        get_timestamp(PlntgDate,time(0,0,0),PlntgTimeStamp),
        Diff is PollTimeStamp - PlntgTimeStamp,
        Interval is Diff/86400.




















%%%%%%%%% output predicates


output(Type,Genotypes,File) :-
        keysort(Genotypes,Sorted),
        open(File,write,Stream),
        output_genotypes(Type,Stream,Sorted),
        close(Stream).






output_genotypes(_,_,[]).
output_genotypes(genotypes,Stream,[_-Gene-(Fam,MF,MN,PF,PN,MG1,MG2,PG1,PG2,K)|T]) :-
        format(Stream,'~w ~12| ~d ~17| ~d ~23| ~w ~40| ~d ~46| ~w ~62| ~w,~w,~w,~w,~w~n',[Gene,Fam,MF,MN,PF,PN,MG1,MG2,PG1,PG2,K]),
        output_genotypes(genotypes,Stream,T).



output_genotypes(lines,Stream,[_-Gene-GL|T]) :-
        format(Stream,'~w~n',[Gene]),
        output_lines(Stream,GL),
        output_genotypes(lines,Stream,T).



% use -0f to coerce the floating point number to an integer

output_genotypes(pollinations,Stream,[p(_,Gene,g(Fam,MF,MN,PF,PN,MG1,MG2,PG1,PG2,K),Interval)|T]) :-
        format(Stream,'~w ~10| ~0f ~15| ~d ~23| ~d ~29| ~w ~48| ~d ~61| ~w ~79| ~w,~w,~w,~w,~w~n',[Gene,Interval,Fam,MF,MN,PF,PN,MG1,MG2,PG1,PG2,K]),
        output_genotypes(pollinations,Stream,T).






output_lines(Stream,[]) :-
        format(Stream,'~n***********~n~n',[]).


output_lines(Stream,[Crop-CropGL|T]) :-
        format(Stream,'~10|~w~n',[Crop]),
        output_lines_aux(Stream,CropGL),
        output_lines(Stream,T).



output_lines_aux(Stream,[]) :-
        format(Stream,'~n',[]).

output_lines_aux(Stream,[(Fam,MF,MN,PF,PN,MG1,MG2,PG1,PG2,K)|T]) :-
        format(Stream,'~15| ~d ~23| ~d ~29| ~w ~48| ~d ~61| ~w ~79| ~w,~w,~w,~w,~w~n',[Fam,MF,MN,PF,PN,MG1,MG2,PG1,PG2,K]),
        output_lines_aux(Stream,T).





