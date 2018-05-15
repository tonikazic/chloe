% this is demeter/code/analyze_crop.pl


% miscellaneous data



%declarations%

:-       module(analyze_crop,[
                 compute_histogram/2,
                 find_mutant_row_plans/3,
                 find_mutant_row_plan/6,
                 identify_crops/1,
                 identify_planting/3,
                 identify_mutant_row_plans/2,
                 identify_mutant_rows/2,
                 identify_mutants_in_crops/1
                 ]).



:-      use_module(demeter_tree('code/genetic_utilities')),
        use_module(demeter_tree('code/demeter_utilities')),
        use_module(demeter_tree('code/plan_crop')),
        use_module(demeter_tree('data/load_data')).






/*
:-      ensure_loaded(library(lists)),
        ensure_loaded(library(sets)),
        ensure_loaded(library(basics)),
        ensure_loaded(library(strings)).

*/


%end%







identify_crops(FileStem) :-
        setof(Crop,Lctn^File^Plntg^Date^DHar^DHarS^crop(Crop,Lctn,File,Plntg,Date,DHar,DHarS),Crops),
        check_slash(FileStem,FileStemS),
        identify_crops(Crops,FileStemS).






identify_crops([],_).
identify_crops([Crop|Crops],FileStemS) :-
        ( identify_rows(Crop,Lines) ->
                build_file_name(FileStemS,Crop,File),
                output_data(File,mutls,Lines)
	;
                format('Warning! identify_rows/2 fails for crop ~w in identify_crops/2.~n',[Crop])
        ),
        identify_crops(Crops,FileStemS).






% exploit new genetic_utilities:convert_crop/2    
%
% Kazic, 30.3.2018
    
build_file_name(FileStemS,Crop,File) :-
        convert_crop(Crop,LowerCrop),
        atomic_list_concat([FileStemS,'all_',LowerCrop,'_rows'],File).






identify_mutants_in_crops(FileStem) :-
        setof(Crop,Lctn^File^Plntg^Date^DHar^DHarS^crop(Crop,Lctn,File,Plntg,Date,DHar,DHarS),Crops),
        check_slash(FileStem,FileStemS),
        identify_mutants_in_crops(Crops,FileStemS).





identify_mutants_in_crops([],_).
identify_mutants_in_crops([Crop|Crops],FileStemS) :-
        ( identify_mutant_rows(Crop,Lines) ->
                build_file_name(FileStemS,Crop,File),
                output_data(File,mutls,Lines)
	;
                format('Warning! identify_mutant_rows/2 fails for crop ~w in identify_mutants_in_crops/2.~n',[Crop])
        ),
        identify_mutants_in_crops(Crops,FileStemS).









% ok, clean up row identification by omitting fun rows and inbreds and grab the plans as well
% want only rows planted in field

% oops, fails if stand count in row is 0; fix
%
% Kazic, 48.2015



% call is: identify_mutant_row_plans('15R','/home/toni/demeter/results/15r_planning/all_15r_mutant_rows').

identify_mutant_row_plans(Crop,File) :-
        identify_rows(Crop,AllLines),
        find_mutant_row_plans(Crop,AllLines,Lines),
        output_data(File,mutls,Lines).





% oops!  prior version returned the packets, not the families
%
% Kazic, 30.12.2012

find_mutant_row_plans(Crop,AllLines,Lines) :-
%        crop_inbred_packets(Crop,InbredLines),
        crop_inbred_families(Crop,InbredLines),
        fun_corn(FunCorn),
        find_mutant_row_plans(Crop,InbredLines,FunCorn,AllLines,[],Lines).




% refactored for crop_management.pl
%
% Kazic, 25.7.09


% modified to include the planting number, but not yet tested for crop_management''s purposes, 
% just field book construction.
%
% Kazic, 30.12.2012


find_mutant_row_plans(_,_,_,[],A,A).
find_mutant_row_plans(Crop,InbredLines,FunCorn,[PRow-(PRow,F,Ma,Pa,MGma,MGpa,PGma,PGpa,Marker,K)|Rows],Acc,Lines) :-
        ( find_mutant_row_plan(Crop,InbredLines,FunCorn,PRow-(PRow,F,Ma,Pa,MGma,MGpa,PGma,PGpa,Marker,K),Plan,Notes,Plntg) ->
                remove_row_prefix(PRow,Row),
                append(Acc,[Row-Marker-(F,Ma,Pa,MGma,MGpa,PGma,PGpa,K,Plan,Notes,Plntg)],NewAcc)
        ;
                format('Warning! no plan found for row ~w, family ~w, ~w x ~w, gene ~w, Knum ~w .~n',[PRow,F,Ma,Pa,Marker,K]),
                NewAcc = Acc
        ),
        find_mutant_row_plans(Crop,InbredLines,FunCorn,Rows,NewAcc,Lines).





% find_mutant_row_plan(Crop,InbredLines,FunCorn,Row-(PRow,F,Ma,Pa,_MGma,_MGpa,_PGma,_PGpa,_Marker,_K),Plan,Notes) :-

find_mutant_row_plan(Crop,InbredLines,FunCorn,Row-(PRow,F,Ma,Pa,_MGma,_MGpa,_PGma,_PGpa,_Marker,_K),Plan,Notes,Plntg) :-
        ( ( memberchk(F,InbredLines)
          ; memberchk(F,FunCorn) ) ->
                false
        ;
                plan(Ma,Pa,Plntg,Plan,Notes,Crop),
%                track_transplants_from_parents(Ma,Pa,Crop,PRow),

                ( Row == PRow ->
                        remove_padding(Row,UnPadded)
                ;
                        UnPadded = Row
                )
        ).
                














identify_mutant_rows(Crop,MutantRows) :-
        setof(Row,Pkt^Ft^Plntr^Date^Time^Soil^planted(Row,Pkt,Ft,Plntr,Date,Time,Soil,Crop),Rows),
        identify_rows(Crop,Rows,Lines),
        mutant_rows(Crop,Lines,MutantRows).






dummy(PRow) :-
        ( PRow == r00545 ->
                spy(crop_management:get_tag_data/7)
        ;
                true
        ).










compute_histogram(Type,Histogram) :-
        ( Type == pollination ->
	        bagof(Date,Ma^Pa^Ear^Rep^Bee^Pilot^Time^cross(Ma,Pa,Ear,Rep,Bee,Pilot,Date,Time),L)
	;
                true
        ),
        compute_histogram_aux(L,Histogram).



compute_histogram_aux(List,Histogram) :-
        compute_histogram_aux(List,[],Int),
        sort(Int,Histogram).




compute_histogram_aux([],A,A).
compute_histogram_aux([H|T],Acc,Histogram) :-
        ( selectchk(H-Cum,Acc,R) ->
	        NewCum is Cum + 1,
                append([H-NewCum],R,NewAcc)
	;
                append([H-1],Acc,NewAcc)
        ),
        compute_histogram_aux(T,NewAcc,Histogram).




identify_planting(Crop,Planting,Rows) :-
        setof(Row,row_planting(Crop,Planting,Row),RowList),
        identify_rows(Crop,RowList,Rows).




row_planting(Crop,Planting,Row) :-
        crop(Crop,_,_,Planting,Date,_,_),
        planted(Row,_,_,_,Date,_,_,Crop).
