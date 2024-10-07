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
                 make_field_book/2,
		 make_image_table/2,
                 mutant_outcomes/1,
                 mutant_outcomes/2
                 ]).



    

:-      use_module(demeter_tree('code/genetic_utilities')),
        use_module(demeter_tree('code/demeter_utilities')),
        use_module(demeter_tree('code/plan_crop')).
%        use_module(demeter_tree('data/load_data')).


%end%



:- format('~n~nFIND CORN IN PREVIOUSLY SKIPPED ROWS IN find_mutant_row_plans2/4~n~n~nwarned bugs are in obsolete code, ignore until discovered otherwise~n~nif make_field_book/2 fails, look at second, fragile clause of check_parents_plans_perm2/4~n~nget mutant_outcomes/{1,2} working!~n~n',[]).




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
        ( identify_mutant_rows(Crop,_Rows) ->
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

% in early stages of field book computation, this will not output rows that don't have
% genotype/11 facts.  Consider confecting something for those rows.
%
% Kazic, 14.7.2020

grab_full_genotypes([],A,A).
grab_full_genotypes([Row-(Ma,Pa)|RowParents],Acc,MutantLines) :-
        ( genotype(F,_,Ma,_,Pa,MGma,MGpa,PGma,PGpa,Marker,K) ->
                build_row(Row,PRow),		  
                append(Acc,[Row-(PRow,F,Ma,Pa,MGma,MGpa,PGma,PGpa,Marker,K)],NewAcc)
        ;
                format('Warning! analyze_crop:grab_full_genotypes/3 finds no genotype/11 for ~w x ~w. Its rows will be missing from the field book.~n',[Ma,Pa]),
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















% make the field book:  can update this as often as needed, but must
% first make a new save state to incorporate the modified plans.
%
% call is: make_field_book('24R',field_book).

%! make_field_book(+Crop:atom,+File:atom) is semidet.

% Flag is set in find_mutant_row_plans/4 and reflects whether or not plan
% facts for this crop are in plan.pl

make_field_book(Crop,File) :-
        pedigree_root_directory(CropsDir),
        downcase_atom(Crop,LowerCrop),
        atom_concat(CropsDir,LowerCrop,CropDir),
	find_mutant_row_plans2(Crop,CropDir,ChkedPlans,Flag),

        management_directory(MgmtDir),
	atomic_list_concat([CropDir,MgmtDir,File],FieldBookFile),
        sort(ChkedPlans,Sorted),
        output_data(FieldBookFile,mutls,Sorted),
	generate_pdf(LowerCrop,FieldBookFile),

	( Flag == do  ->
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
%
% the first version is really wordy
%
% Kazic, 6.6.2023

%! output_plans_aux(+Stream:atom,+Crop:atom,+Plans:list) is det.

output_plans_aux(_,_,[]).
output_plans_aux(Stream,Crop,[_Row-_Marker-(_,Ma,Pa,_,_,_,_,_K,Plan,Notes,Plntg)|Plans]) :-
%        format(Stream,'% ~w  ~w   ~w~nplan(~q,~q,~q,~q,~q,~q).~n~n',[Row,Marker,K,Ma,Pa,Plntg,Plan,Notes,Crop]),
        format(Stream,'plan(~q,~q,~q,~q,~q,~q).~n~n',[Ma,Pa,Plntg,Plan,Notes,Crop]),
	output_plans_aux(Stream,Crop,Plans).








	

		  

% find the plans for all rows that were planted with mutants in a crop
% set a flag to output the checked plans as plan/6 facts.


% switched from setof/3 to bagof/3 to accommodate the same line planted in multiple rows.
%
% Kazic, 29.7.2019

% fixed to iterate over plans, not mutant genotypes, since each row is represented in the plans,
% including its multiple plantings.
%
%
% 5.6.2023


% more fixes to get the right p99999 Mas and Pas
%
% 6.6.2023


%! find_mutant_row_plans(+Crop:atom,+CropDir:atom,-ChkedPlans:list,-Flag:atom) is semidet.


% Warning: /Users/toni/me/c/maize/demeter/code/analyze_crop.pl:422:
%        Singleton variable in branch: MutantRows
%        Singleton variable in branch: Row


find_mutant_row_plans(Crop,CropDir,ChkedPlans,Flag) :-
        identify_mutant_rows_lines(Crop,MutantLines),	
%        ( setof(Ma-(Pa,Plntg,Plan,Notes),plan(Ma,Pa,Plntg,Plan,Notes,Crop),Plans) ->

        ( bagof(Ma-(Pa,Plntg,Plan,Notes),plan(Ma,Pa,Plntg,Plan,Notes,Crop),Plans) ->
                format('Hello!  Using the plan/6 facts for crop ~w~n',[Crop]),
%		findall(Row-Date,(planted(PaddedR,Packet,_,_,Date,_,_,Crop),
%			            \+ ignorable_by_packetID(Packet),
%			            remove_row_prefix(PaddedR,Row) ),Rs),
%		sort(Rs,MutantRows),
		Flag = done  
        ;
	        planning_directory(PlngDir),
		atomic_list_concat([CropDir,PlngDir,'sequenced.packing_plan.pl'],PkingPlanFile),
		ensure_loaded(PkingPlanFile),
                setof(Ma-(Pa,Plntg,Plan,Notes),Row^NumPkts^K^Cl^Ft^packing_plan(Row,NumPkts,[Ma,Pa],Plntg,Plan,Notes,K,Crop,Cl,Ft),Plans),
                format('~n~nWarning!  Using the preliminary packing_plan facts for crop ~w.~n Check plan.pl for reiterated facts.~n~n',[Crop]),
		Flag = do
        ),
%	write_list_facts(Plans),
	check_parents_plans(MutantLines,Plans,ChkedPlans).
%	check_parents_plans_perm2(Crop,MutantRows,Plans,MutantLines,ChkedPlans).	




% nb: this assumes the corn is packed in the same year it's planted!!!!!
%
% your organization may be different
%
% Kazic, 6.6.2023


% need to find corn planted in previously skipped rows
%
% Kazic, 18.10.2023


% added conditionals to better trap missing data
%
% Kazic, 3.6.2024


find_mutant_row_plans2(Crop,CropDir,ChkedPlans,Flag) :-
        crop(Crop,_,_,_,date(_,_,Year),_,_),
        ( findall(Row-(Packet,Plntg),
		              ( planted(PaddedR,Packet,_,_,Date,_,_,Crop),
			        \+ ignorable_by_packetID(Packet),
				crop(Crop,_,_,Plntg,Date,_,_),
			        remove_row_prefix(PaddedR,Row) ),Rs) ->
                format('Hello!  Using the plan/6 facts for crop ~w~n',[Crop]),
		sort(Rs,MutantRows),
%		write_list(MutantRows),
		( check_parents_plans_perm3(Crop,Year,MutantRows,ChkedPlans) ->
		        format('~n~n check_parents_plans_perm3/4 succeeded~n~n',[])
		;
		        format('~n~n oops, check_parents_plans_perm3/4 failed~n~n',[])
		),
		Flag = done
        ;
                format('~n~nWarning!  Using the preliminary packing_plan facts for crop ~w.~n Check plan.pl for reiterated facts.~n~n',[Crop]),
	        planning_directory(PlngDir),
		atomic_list_concat([CropDir,PlngDir,'packing_plan.pl'],PkingPlanFile),
		ensure_loaded(PkingPlanFile),
                setof(Ma-(Pa,Plntg,Plan,Notes),Row^NumPkts^K^Cl^Ft^packing_plan(Row,NumPkts,[Ma,Pa],Plntg,Plan,Notes,K,Crop,Cl,Ft),Plans),
		identify_mutant_rows_lines(Crop,MutantLines),	
		check_parents_plans(MutantLines,Plans,ChkedPlans),
		Flag = do
        ).
%	write_list_facts(Plans),
%	
	











% it can happen that other corn was packed than planned; or there were
% scanner errors during packing; or family numbers have changed between the
% time the crop was planned and the time it was planted and the genotype facts
% issued.  check_parents_plans_perm/3 makes it easier to pin down discrepancies and
% correct them before generating plant tags or the field book.



% iterate over the rows
%
% second clause is fragile, since if the first memberchk fails, only the
% Row will be instantiated and the format/2 will fail.  Also, only Row in
% the output list will be instantiated.  So watch for failure here ---
% which is informative, because it means data are missing, but this is a
% messy way to do it.
%
% Kazic, 6.6.2023


%! check_parents_plans_perm2(+MutantRows:list,+Plans:list,+MutantLines:list,-ChkedPlans:list) is semidet.

check_parents_plans_perm2(_,[],_,_,[]).
check_parents_plans_perm2(Crop,[Row-Date|MutantRows],Plans,MutantLines,
	   [Row-Marker-(Family,Ma,Pa,MGma,MGpa,PGma,PGpa,K,Plan,Notes,Plntg)|ChkedPlans]) :-
        ( memberchk(Row-(_,Family,Ma,Pa,MGma,MGpa,PGma,PGpa,Marker,K),MutantLines) ->
		crop(Crop,_,_,Plntg,Date,_,_),
                member(Ma-(Pa,Plntg,Plan,Notes),Plans)
        ;
		format('Warning! no plan data found for row ~w, ~w x ~w~n',[Row,Ma,Pa])
		
        ),
	check_parents_plans_perm2(Crop,MutantRows,Plans,MutantLines,ChkedPlans).


% welll, still lotsa back-tracking thru ccp/6
%
% so, since we only pack corn in the year it's planted anymore .....
%
% yes, kinda kludgey, but this is what we do now
%
% Kazic, 6.6.2023
%
% added accumulator
%
% Kazic, 30.5.2024
%
% added conditionals to better trap missing data
%
% Kazic, 3.6.2024

check_parents_plans_perm3(Crop,Year,MutantRows,ChkedPlans) :-
        check_parents_plans_perm3(Crop,Year,MutantRows,[],ChkedPlans).


check_parents_plans_perm3(_,_,[],A,A).
check_parents_plans_perm3(Crop,Year,[Row-(Packet,Plntg)|MutantRows],Acc,ChkedPlans) :-
        ( packed_packet(Packet,Ma,Pa,_,_,date(_,_,Year),_) ->
                ( plan(Ma,Pa,Plntg,Plan,Notes,Crop) ->
		        true
		;
		        format('cannot find plan for ~w x ~w, planting ~w~n',[Ma,Pa,Plntg]),
			Plan = [foo],
		        Notes = 'bar'
		),
		( genotype(Family,_,Ma,_,Pa,MGma,MGpa,PGma,PGpa,[Marker],K) ->
		        true
		;
		        format('cannot find genotype for ~w x ~w, planting ~w~n',[Ma,Pa,Plntg]),
			Marker = foo,
			Family = foo,
			MGma = foo,
			MGpa = foo,
			PGma = foo,
			PGpa = foo,
			K = foo
		),
		append(Acc,[Row-Marker-(Family,Ma,Pa,MGma,MGpa,PGma,PGpa,K,Plan,Notes,Plntg)],NewAcc)
        ;
	        NewAcc = Acc,
		format('Warning! unconsidered case for row ~w, packet ~w~n',[Row,Packet])
        ),
	check_parents_plans_perm3(Crop,Year,MutantRows,NewAcc,ChkedPlans).





%%%%%%% obsolete! %%%%%%%%%%%%%%


% iterate over the plans to ensure that each row is in the field book, even
% if it's in multiple plantings.  Iterating over the mutants, as in the
% original version of check_parents_plans/3, will ignore multiple
% plantings.
%
% this version throws a 'Singleton variable in branch: Row' error, but is
% inconsequential so far as I can see.
%
% Kazic, 5.6.2023

%! check_parents_plans_perm(+Plans:list,+MutantLines:list,-ChkedPlans:list) is semidet.

check_parents_plans_perm(Plans,MutantLines,ChkedPlans) :-
	check_parents_plans_perm(Plans,MutantLines,[],ChkedPlans).






% Warning: /Users/toni/me/c/maize/demeter/code/analyze_crop.pl:567:
%	Singleton variable in branch: Row


check_parents_plans_perm([],_,A,A).
check_parents_plans_perm([Ma-(Pa,Plntg,Plan,Notes)|Plans],MutantLines,Acc,ChkedPlans) :-
        ( memberchk(Row-(_,Family,Ma,Pa,MGma,MGpa,PGma,PGpa,Marker,K),MutantLines) ->
                append(Acc,[Row-Marker-(Family,Ma,Pa,MGma,MGpa,PGma,PGpa,K,Plan,Notes,Plntg)],NewAcc)
        ;
                skip(Ma),
                NewAcc = Acc
        ;
                get_family(Ma,F),
	        ( elite(F,_)
		;
		  fun_corn(F,_)
		),
	        NewAcc = Acc
        ;
		format('Warning! no plan data found for row ~w, ~w x ~w~n',[Row,Ma,Pa]),
		NewAcc = Acc
        ),
	check_parents_plans_perm(Plans,MutantLines,NewAcc,ChkedPlans).




% no, iterate over the plans, not the mutant information, to ensure that
% each row is in the field book, even if it's in multiple plantings.
% Iterating over the mutants, as is done here, will ignore multiple
% plantings.
%
% See check_parents_plans_perm/3 above for the revised code.
%
% Kazic, 5.6.2023

%! check_parents_plans(+MutantLines:list,+Plans:list,-ChkedPlans:list) is semidet.

check_parents_plans(MutantLines,Plans,ChkedPlans) :-
	check_parents_plans(MutantLines,Plans,[],ChkedPlans).


check_parents_plans([],_,A,A).
check_parents_plans([Row-(_,Family,Ma,Pa,MGma,MGpa,PGma,PGpa,Marker,K)|MutantLines],Plans,Acc,ChkedPlans) :-
        ( memberchk(Ma-(Pa,Plntg,Plan,Notes),Plans) ->
                append(Acc,[Row-Marker-(Family,Ma,Pa,MGma,MGpa,PGma,PGpa,K,Plan,Notes,Plntg)],NewAcc)
        ;
                skip(Ma),
                NewAcc = Acc
        ;
                get_family(Ma,F),
	        ( elite(F,_)
		;
		  fun_corn(F,_)
		),
	        NewAcc = Acc
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

%		
%                ( Row == PRow ->
%                        remove_padding(Row,UnPadded)
%                ;
%                        UnPadded = Row
%                )
%
% no need for conditional here, as remove_padding/2 handles either type of input
%
% and I'm not sure this is even needed, but leave it in for now
%
% Kazic, 16.7.2020

                remove_padding(PRow,Row)
	).
                











%! make_image_table(+File:atom) is semidet.

% make a table of all images, their plants with the rough genotype, leaf,
% etc, with fields to characterize the images.
%
% Output to an org file --- can always export csv from there.
%
% A lot of ugly list manipulation to keep the right things together and
% make it easy to process.
%
% Kazic, 1.9.2022


% call is make_image_table('images.org','erroneous_image_files').


% L = ['07R2284:0035104'-'07r'-(34, 13, tip, bet, date(10, 8, 2007)), ...]
% Images = [(34, 13, tip, bet, date(10, 8, 2007)), ...]
% Plants = ['07R2284:0035104', ...]
% LowCrops = ['07r', ...]
% Linked = ['07r'-(34, 13, tip, bet, date(10, 8, 2007)), ...]
% ImageRefs = ['07r/bet/10.8/DSC_0034.NEF', ...]
% Crazy = ['07R2284:0035104'-'07r'-(34, 13, tip, bet, date(10, 8, 2007))-'07r/bet/10.8/DSC_0034.NEF', ...]

make_image_table(TableStem,ErrorStem) :-
	findall(Plant-LowCrop-(Bkrd,Mutant,K,ImageNum,Leaf,Sec,Camera,Date),
		      (image(Plant,ImageNum,Leaf,Sec,Camera,_,_,Date,_),
		       get_crop(Plant,Crop),
		       downcase_atom(Crop,LowCrop),
		       grab_genotype(Plant,Bkrd,Mutant,K)),L),
	pairs_keys_values(L,DoubleKeys,Images),
	pairs_keys_values(DoubleKeys,_Plants,LowCrops),
	pairs_keys_values(Linked,LowCrops,Images),

        utc_timestamp_n_date(UTCTimeStamp,Date),
	atom_concat('../../image_processing/image_tables/',TableStem,TableFile),
	atom_concat('../../image_processing/image_tables/',ErrorStem,ErrorFile),

	decode_list_image_refs(Linked,ErrorFile,ImageRefs),
        pairs_keys_values(Crazy,L,ImageRefs),
	
	open(TableFile,write,Stream),
	format(Stream,'# this is ../c/maize/image_processing/image_tables/~w~n',[TableStem]),
        format(Stream,'# generated on ~w (= ~w) by~n',[Date,UTCTimeStamp]),
        format(Stream,'# analyze_crop:make_image_table/2.~n',[Date,UTCTimeStamp]),
	format(Stream,'# The corresponding error file is  ../c/maize/image_processing/image_tables/~w~n~n',[ErrorStem]),
	format(Stream,'| plant | bkrd | mut | K | leaf | sectn | image | bb | scc | tape | ok | rmk |~n|-~n',[]),
	output_image_table(Stream,Crazy),
	close(Stream).








grab_genotype(Plant,Bkrd,Mutant,K) :-
        get_crop(Plant,Crop),
	get_row(Plant,PaddedRow),
        atom_number(PaddedRow,Row),
	planting_index(Ma,Pa,Crop,Row),
	genotype(_,_,Ma,_,Pa,Bkrd,_,_,_,[Mutant],K).

	


output_image_table(_,[]).
output_image_table(Stream,[Plant-_-(Bkrd,Mutant,K,_,Leaf,Sectn,_,_)-Image|Crazies]) :-
	atomic_list_concat(['[[file:../../images/',Image,'][',Image,']]'],OrgImage),
        format(Stream,'|~w | ~w | ~w | ~w | ~w | ~w | ~w |  |  |  |  | | ~n',[Plant,Bkrd,Mutant,K,Leaf,Sectn,OrgImage]),
        output_image_table(Stream,Crazies).
 

















% what are the results of planting each mutant line?
%
% find the phenotypes of all offspring of a line, no matter when the line is planted
%
% doesn't work .... this is slow and burns up memory (too much back-tracking!),
% so this isn't ready for prime time.  But at least this version expresses the underlying
% ideas.
%
% Might be faster to hand it the pedigree branch beginning at the Pa and then traverse that,
% rather than essentially reconstructing it the hard way as is done here.  However, this would
% omit plants that don't have genotype/11 facts.
%
% An earlier version built the list of all mutant Pas first (the first three lines of mutant_outcome/6)
% and then traversed that list.
%
% Kazic, 16.7.2020



% revise to input marker and K and retrieve data for each line planted with that marker
%
% actually just need K --- input should be a list of Ks
%
% test case is lls
%
% Kazic, 13.8.2023



% for all families with right marker and K,
% get all plantings (crop, row, stand count) for those families and unplanted sibs
% for all mutant plants in those plantings, get inventory, mutant, and image data
% for unplanted sibs, get inventory data
%
% Kazic, 14.8.2023






%! mutant_outcomes(-Outcomes:list) is semidet.

mutant_outcomes(Outcomes) :-
        setof(Pa-(Crop,Row,Mar,K,Phes),mutant_outcome(Pa,Crop,Row,Mar,K,Phes),Outcomes).



%! mutant_outcomes(+Pa:atom,-Outcomes:list) is semidet.

mutant_outcomes(Pa,Outcomes) :-
        mutant_outcome(Pa,_Crop,_Row,_Mar,_K,Outcomes).



%! mutant_outcome(+Pa:atom,-Crop:atom,-Row:atom,-Mar:atom,-K:atom,-Phes:list) is nondet.

mutant_outcome(Pa,Crop,Row,Mar,K,Phes) :-
	genotype(F,_MaFam,Ma,_PaFam,Pa,_MaGma,_MaGPa,_PaGma,_PaGPa,Mar,K),
	mutant(Pa),
	F \== 9999,
        planting_index(Ma,Pa,Crop,Row),
	row_members_index(Crop,Row,Plants),	
        get_phes(Plants,Phes).



%! get_phes(+Plants:list,-Phes:list) is semidet.

get_phes(Plants,Phes) :-
	get_phes(Plants,[],Phes).


get_phes([],A,A).
get_phes([Plant|Plants],Acc,Phes) :-
	mutant(Plant,Phe,_,_,_,_,_,_),
	( memberchk(phenotype(les),Phe) ->
	        append(Phe,Acc,NewAcc)
	;
	        NewAcc = Acc
	),
	get_phes(Plants,NewAcc,Phes).
      






%%%%% obsolete? yes!  see code block in pollinatns.org

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
