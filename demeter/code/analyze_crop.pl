% this is ../c/maize/demeter/code/analyze_crop.pl


% miscellaneous data and predicates


% ported to SWI prolog, but some errors still remain.
% These will likely become apparent as the season progresses.
%
% Kazic, 29.7.2019



%declarations%

:-       module(analyze_crop,[
                 compute_histogram/2,
                 find_mutant_row_plans/4,
%                 find_mutant_row_plans/3,
                 find_mutant_row_plan/7,
                 identify_crops/1,
                 identify_crops/2,
                 identify_planting/3,
                 identify_mutant_lines_in_crops/2,
                 identify_mutant_row_plans/2,
% 	          identify_mutant_rows/2,
		 identify_mutant_rows_lines/2,
%                 identify_mutants_in_crops/1,
%                 identify_mutants_in_crops/2
                 make_field_book/2						    
% 	          mutants_outcomes
                 ]).



    

:-      use_module(demeter_tree('code/genetic_utilities')),
        use_module(demeter_tree('code/demeter_utilities')),
        use_module(demeter_tree('code/plan_crop')),
        use_module(demeter_tree('data/load_data')).





%end%


:- format('~n~nWarning!  multiple errors of singleton variables and in branches still to fix, 27.7.2019.~n~n~n',[]).





%! identify_crops(+FileStem:atom) is semidet.
    

identify_crops(FileStem) :-
        setof(Crop,Lctn^File^Plntg^Date^DHar^DHarS^crop(Crop,Lctn,File,Plntg,Date,DHar,DHarS),Crops),
        check_slash(FileStem,FileStemS),
        identify_crops(Crops,FileStemS).





    



    
%! identify_crops(+Crops:list,+FileStem:atom) is semidet.
    

identify_crops([],_).
identify_crops([Crop|Crops],FileStemS) :-
        ( identify_rows(Crop,Lines) ->
                build_file_name(FileStemS,Crop,File),
                output_data(File,mutls,Lines)
	;
                format('Warning! identify_rows/2 fails for crop ~w in analyze_crop:identify_crops/2.~n',[Crop])
        ),
        identify_crops(Crops,FileStemS).










    
% exploits new genetic_utilities:convert_crop/2    
%
% Kazic, 30.3.2018


%! build_file_name(+FileStemS:atom,+Crop:atom,-File:atom) is det.   
    
build_file_name(FileStemS,Crop,File) :-
        convert_crop(Crop,LowerCrop),
        atomic_list_concat([FileStemS,LowerCrop,'/management/','all_',LowerCrop,'_rows'],File).








    


%! identify_mutants_in_crops(+FileStem:atom) is det.    


identify_mutants_in_crops(FileStem) :-
        setof(Crop,Lctn^File^Plntg^Date^DHar^DHarS^crop(Crop,Lctn,File,Plntg,Date,DHar,DHarS),Crops),
        check_slash(FileStem,FileStemS),
        identify_mutants_in_crops(Crops,FileStemS).












% this returns a list of row numbers as integers, not the line data for
% those rows.
%
% identify_mutants_in_crops(['15R','16R','17R','18R'],'../../crops/').

%! identify_mutants_in_crops(+Crops:list,+FileStem:atom) is semidet.
    

identify_mutants_in_crops([],_).
identify_mutants_in_crops([Crop|Crops],FileStemS) :-
        ( identify_mutant_rows(Crop,Rows) ->
                 true

%                build_file_name(FileStemS,Crop,File)
%                output_data(File,mutls,Rows)
	;
                format('Warning! identify_mutant_rows/2 fails for crop ~w in identify_mutants_in_crops/2.~n',[Crop])
        ),
        identify_mutants_in_crops(Crops,FileStemS).













    




% rewritten to avoid inbreds, elites, and fun corn directly; and
% to get the closest contemporaneous packet.
%
% Kazic, 31.7.2018


%! identify_mutant_lines_in_crops(+Crops:list,-Lines:keylist) is det.

identify_mutant_lines_in_crops([],[]).
identify_mutant_lines_in_crops([Crop|Crops],[Crop-MutantLines|Lines]) :-
        identify_mutant_rows_lines(Crop,MutantLines),
        identify_mutant_lines_in_crops(Crops,Lines).







% if the planting_index/4 is up to date, use that to identify each row; otherwise
% go via the planted/8 facts and use identify_row/3 to ensure we have the most
% contemporaneous packet for that row.


%! identify_mutant_rows_lines(+Crop:atom,-MutantLines:list) is det.

identify_mutant_rows_lines(Crop,MutantLines) :-
        ( setof(Row-(Ma,Pa),(planting_index(Ma,Pa,Crop,Row),mutant(Pa)),RowParents) ->
                grab_full_genotypes(RowParents,MutantLines)
        ;
	        setof(Row,Pkt^Ft^Plntr^Date^Time^Soil^planted(Row,Pkt,Ft,Plntr,Date,Time,Soil,Crop),Rows),
                identify_mutant_rows_lines(Crop,Rows,MutantLines)
        ).					  









%! grab_full_genotypes(+RowParents:list,-MutantLines:list) is semidet.

grab_full_genotypes(RowParents,MutantLines) :-
        grab_full_genotypes(RowParents,[],MutantLines).








% we should already have a genotype/11 fact for that line, but just in case
% we don't, use an accumulator

grab_full_genotypes([],A,A).
grab_full_genotypes([Row-(Ma,Pa)|RowParents],Acc,MutantLines) :-
        ( genotype(F,_,Ma,_,Pa,MGma,MGpa,PGma,PGpa,Marker,K) ->
                build_row(Row,PRow),		  
                append(Acc,[Row-(PRow,F,Ma,Pa,MGma,MGpa,PGma,PGpa,Marker,K)],NewAcc)
        ;
                format('Warning! no genotype/11 fact found by analyze_crop:grab_full_genotypes/3 for ~w x ~w~n',[Ma,Pa]),
	        NewAcc = Acc
        ),
	grab_full_genotypes(RowParents,NewAcc,MutantLines).
















      
%! identify_mutant_rows_lines(+Crop:atom,+Rows:list,-MutantLines:list) is semidet.

identify_mutant_rows_lines(Crop,Rows,MutantLines) :-
        identify_mutant_rows_lines(Crop,Rows,[],MutantLines).






%! identify_mutant_rows_lines(+Crop:atom,+Rows:list,+Acc:list,-MutantLines:list) is semidet.

identify_mutant_rows_lines(_,[],A,A).
identify_mutant_rows_lines(Crop,[Row|Rows],Acc,MutantLines) :-
        identify_row(Crop,Row,Row-(PRow,F,Ma,Pa,MGma,MGpa,PGma,PGpa,Marker,K)),
        ( mutant(Pa) ->
                append(Acc,[Row-(PRow,F,Ma,Pa,MGma,MGpa,PGma,PGpa,Marker,K)],NewAcc)
        ;
                NewAcc = Acc
        ),
        identify_mutant_rows_lines(Crop,Rows,NewAcc,MutantLines).















% make the field book:  can update this as often as needed
%
% call is: make_field_book('19R',field_book).

%! make_field_book(+Crop:atom,+File:atom) is semidet.

make_field_book(Crop,File) :-
        pedigree_root_directory(CropsDir),
        downcase_atom(Crop,LowerCrop),
        atom_concat(CropsDir,LowerCrop,CropDir),
	find_mutant_row_plans(Crop,CropDir,ChkedPlans,Flag),

        management_directory(MgmtDir),
	atomic_list_concat([CropDir,MgmtDir,File],FieldBookFile),
        output_data(FieldBookFile,mutls,ChkedPlans),
	generate_pdf(LowerCrop,FieldBookFile),

	( Flag == do ->
                output_plans(Crop,LowerCrop,ChkedPlans)
        ;
                true
	).








% nb: this is NOT organization or operating system-independent!


generate_pdf(LowerCrop,File) :-
        atom_concat(File,'.pdf',PdfFile),
	dropbox_dir(Dropbox),
	atom_concat(Dropbox,LowerCrop,DropboxDir),
        atomic_list_concat(['enscript -f CourierBold12 ',File,' -o f.ps; ps2pdf f.ps ',PdfFile,'; rm f.ps; cp -p ',PdfFile,' ',DropboxDir,'/.'],Cmd),
	shell(Cmd).










% append current version of plan/6 facts to ../data/plan.pl.  This is the
% version that should be revised as the season proceeds to incorporate changes
% in the plan and new observations.  After revision, a new field book is then
% generated.

%! output_plans(+Crop:atom,+LowerCrop:atom,+ChkedPlans:list) is det.

output_plans(Crop,LowerCrop,ChkedPlans) :-
	open('../data/plan.pl',append,Stream),
	format(Stream,'~n~n~n~n% ~w~n~n~n~n',[LowerCrop]),
        output_plans_aux(Stream,Crop,ChkedPlans),
	close(Stream).










% row and marker in comment preceeding each plan fact

%! output_plans_aux(+Stream:atom,+Crop:atom,+Plans:list) is det.

output_plans_aux(_,_,[]).
output_plans_aux(Stream,Crop,[Row-Marker-(_,Ma,Pa,_,_,_,_,K,Plan,Notes,Plntg)|Plans]) :-
        format(Stream,'% ~w  ~w   ~w~nplan(~q,~q,~q,~q,~q,~q).~n~n',[Row,Marker,K,Ma,Pa,Plntg,Plan,Notes,Crop]),
	output_plans_aux(Stream,Crop,Plans).








	

		  

% find the plans for all rows that were planted with mutants in a crop
% set a flag to output the checked plans as plan/6 facts.


% switched from setof/3 to bagof/3 to accommodate the same line planted in multiple rows.
%
% Kazic, 29.7.2019

%! find_mutant_row_plans(+Crop:atom,+CropDir:atom,-ChkedPlans:list,-Flag:atom) is semidet.
		  
find_mutant_row_plans(Crop,CropDir,ChkedPlans,Flag) :-
        identify_mutant_rows_lines(Crop,MutantLines),	
%        ( setof(Ma-(Pa,Plntg,Plan,Notes),plan(Ma,Pa,Plntg,Plan,Notes,Crop),Plans) ->

        ( bagof(Ma-(Pa,Plntg,Plan,Notes),plan(Ma,Pa,Plntg,Plan,Notes,Crop),Plans) ->
                format('Hello!  Using the plan/6 facts for crop ~w~n',[Crop]),
		Flag = done  
        ;
	        planning_directory(PlngDir),
		atomic_list_concat([CropDir,PlngDir,'sequenced.packing_plan.pl'],PkingPlanFile),
		ensure_loaded(PkingPlanFile),
                setof(Ma-(Pa,Plntg,Plan,Notes),Row^NumPkts^K^Cl^Ft^packing_plan(Row,NumPkts,[Ma,Pa],Plntg,Plan,Notes,K,Crop,Cl,Ft),Plans),
                format('Warning!  Using the preliminary packing_plan facts for crop ~w~n',[Crop]),
		Flag = do
        ),
%	write_list_facts(Plans),
	check_parents_plans(MutantLines,Plans,ChkedPlans).










% it can happen that other corn was packed than planned; or there were
% scanner errors during packing; or family numbers have changed between the
% time the crop was planned and the time it was planted and the genotype facts
% issued.  check_parents_plans/3 makes it easier to pin down discrepancies and
% correct them before generating plant tags or the field book.


%! check_parents_plans(+MutantLines:list,+Plans:list,-ChkedPlans:list) is semidet.

check_parents_plans(MutantLines,Plans,ChkedPlans) :-
	check_parents_plans(MutantLines,Plans,[],ChkedPlans).


check_parents_plans([],_,A,A).
check_parents_plans([Row-(_,Family,Ma,Pa,MGma,MGpa,PGma,PGpa,Marker,K)|MutantLines],Plans,Acc,ChkedPlans) :-
        ( memberchk(Ma-(Pa,Plntg,Plan,Notes),Plans) ->
                append(Acc,[Row-Marker-(Family,Ma,Pa,MGma,MGpa,PGma,PGpa,K,Plan,Notes,Plntg)],NewAcc)
        ;
	        format('Warning! no plan data found for row ~w, ~w x ~w~n',[Row,Ma,Pa]),
	        NewAcc = Acc
        ),
	check_parents_plans(MutantLines,Plans,NewAcc,ChkedPlans).








%%%%%% old, needs revision %%%%%%%    
%
% stopped here

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
% Kazic, 25.7.2009


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
                












% what are the results of planting each mutant line?


% stopped here: not sure what I want
% stubbed

mutant_outcomes(Outcomes) :-
        setof(Pa,MaFam^Ma^PaFam^MaGma^MaGPa^PaGma^PaGPa^Mar^K^(genotype(F,MaFam,Ma,PaFam,Pa,MaGma,MaGPa,PaGma,PaGPa,Mar,K),mutant(Pa),F \== 9999),Pas),
        grab_outcomes(Pas,Outcomes).


grab_outcomes([],[]).
grab_outcomes([Pa|Pas],[Outcome|Outcomes]) :-
        bagof(Ma-(Pa,Crop,Row,Plants),(planting_index(Ma,Pa,Crop,Row),row_members_index(Crop,Row,Plants)),Pltngs),

	bagof(Plant-Phe,C^P^S^O^D^T^mutant(Plant,Phe,C,P,S,O,D,T),PlantPhes),
        ( select(phenotype(les),PlantPhes,_) ->	
               Outcome = mutant
	;			    
               Outcome = wild_type
	),		  
        true.






      






%%%%% obsolete?

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
