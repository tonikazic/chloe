% this is ../c/maize/demeter/code/pedigrees.pl

% a collection of predicates to compute pedigrees using
% only the numerical genotypes; pulled from clean_data.pl
%
% Kazic, 3.5.2009




% still to do some convenient day
%
%    construct pedigrees ignoring family numbers; compute a new index
%    based on genotype/11 to facilitate this
%
% Kazic, 7.3.2019





%declarations%



:-      module(pedigrees, [
               build_pedigrees/2,
	       check_pedigrees/2,	       
               construct_pedigrees/1,
               find_imaged_ancestors/1,
               find_plants_offspring/2,
	       grab_founders/1,
               grab_offspring/3,
               test_pedigrees/2,
%	       test_n_check_pedigrees/3,
               compute_pedigree/3,
               compute_pedigrees/1
               ]).




 
:-      use_module(demeter_tree('code/genetic_utilities')),
        use_module(demeter_tree('code/demeter_utilities')),
        use_module(demeter_tree('data/load_data')),
%        use_module(demeter_tree('code/plan_crop')).
        true.


%end%











% nb: this file contains calls to the operating system en lieu de    
% swipl predicates, so it will have to be modified for non-Unix operating
% systems.  See also set_demeter_directory.pl for OS-dependent data.
%
%
% ported to SWI Prolog, version 7.6.4    
%
% Kazic, 24.5.2018
    






    
%%%%%%%%% older comments and current update on these issues (all fixed) %%%%%%%%%%%%%%%%%

% have tested extensively with the W23/Les1 pedigree, uncovering a number
% of logical and data errors.  Warning statements have been inserted to
% prevent silent failures.  Significant data cleaning and accessions are
% still required before this code can be reworked.  In principle it should
% use only the planting, cross, and inventory data; I have used some index
% predicates to speed the computation, but this has the potential to
% introduce errors.  See results/missing_rows for warning message output.
%
% Kazic, 5.5.2009


% predicate will not succeed with harvest data until planting-related facts
% and other indices are current!  This means I must finally get around and
% revise my planting facts so that they match the current procedure.
%
% Kazic, 16.10.2009
%
% done, probably in 2010
%
% Kazic, 6.5.2011


% Warning!  multiply-planted rows in 11R are still not correctly resolved;
% Oh43 is included in the les5-GJ2_b73 pedigree!
%
% Failed ears also appearing in pedigrees, don''t think these are in inventory.
%
% Kazic, 29.4.2012
%
%
% transplants are now correctly tracked, except for the confused ones in
% 09R; the second instantiation has the correct family in the index facts.
%
% BUT I am baffled why the descendants of family 184, made in 11R, do not
% appear in any pedigree!  These are the {S,W,M}/Rp1-D21, which were
% planted in 11N.  There were successful pollinations from 11N families
% 3476 and 3477 (rows 220 and 221, respectively).
%
% I believe I have fixed the data to allow the Baker/Braun les pedigree to
% be built.
%
% Kazic, 3.5.2012





% I solved the Les5 problem by getting better Les5 plants (family 116).
% But I need to make sure this pedigree is computed.  I think there may be
% a problem with files getting over-written, because the generated file
% names are duplicates.
%
% Kazic, 17.10.2012

% test separately for families 600 -- 622, 628, 629, 631 -- 641; still
% being missed
%
% Kazic, 23.10.2012


    
% all these issues now resolved.  Missing harvest and inventory facts were found, 
% founder line numbers assigned for mutants from David Braun''s field.
%
%
% Facts for Tp1 inserted ~2012.
%
%
% The funny I/O problem quintus had was resolved by porting to swipl.
%
% The file names have shifted from the previous versions, so there is no
% guarantee the perl scripts that ablate a crop and its descendants and
% then compares one crops''s pedigrees to the prior ones will work
% correctly.
%
%
% Instead, I should still compute pedigrees by matching crop and rowplant
% as a check on the predicates computed by unification.  This is why I have
% built multiple new indices.  But this will have to keep til after getting
% 18r in!
%
%
% Another important thing to check is to ensure the mutant allele and Knum
% in the genotypes in a pedigree are unchanged from the root.  I''ve picked
% up a transition from Les4 to Les1 in one M14 branch by hand, and there
% may be more.  See ../data/update.org for this result.
%
% Kazic, 1.6.2018

















%%%%%%%%%% top-level predicates
    

% compute all desired pedigrees for a crop being planned
%
% this predicate rolls finding the founders with build_pedigrees/2
%
%
% PlanningCrop is the crop being planned; 
% output is in ../../crops/PlanningCrop/planning/current_pedigrees    
% ../../crops/scripts/make_pdf_pedigrees.perl generates the
% pdf and Dropbox versions





% added check_pedigrees/2 and shifted argument passed to output_pedigrees/4
%
% Kazic, 6.3.2019



% call is: compute_pedigrees('19r').



%! compute_pedigrees(+PlanningCrop:atom) is nondet.

compute_pedigrees(PlanningCrop) :-
        construct_pedigrees(Trees),
	check_pedigrees(Trees,Checked),	
        make_output_dir(PlanningCrop,ASCIIDir,LowerCaseCrop),
%        output_pedigrees(ASCIIDir,LowerCaseCrop,ped,Trees).
        output_pedigrees(ASCIIDir,LowerCaseCrop,ped,Checked).	






    


% given a list of family numbers, build their pedigrees
%
% Kazic, 23.10.2012
%
%
% test_pedigrees([640,641,642,643,644,645,646,647,648,649,650,651,652,653,654],'18r').


% added check_pedigrees/2 and shifted argument passed to output_pedigrees/4
%
% Kazic, 6.3.2019


%! test_pedigrees(+Families:list,+PlanningCrop:atom) is nondet.

test_pedigrees(Families,PlanningCrop) :-
        grab_founders(Families,Parents),
        build_pedigrees(Parents,Trees),
	check_pedigrees(Trees,Checked),	
        make_output_dir(PlanningCrop,ASCIIDir,LowerCaseCrop),
%        output_pedigrees(ASCIIDir,LowerCaseCrop,ped,Trees).
        output_pedigrees(ASCIIDir,LowerCaseCrop,ped,Checked).













     
    
% for those times when you only need one, for example because the genotypes of
% two lines are identical and the second file over-writes the first.  This happens
% with Jimmy''s Idf lines!
%
% Kazic, 3.5.2012


% added check_pedigrees/2 and shifted argument passed to output_pedigrees/4
%
% Kazic, 6.3.2019



% compute_pedigree('11R0192:0000000','11R0192:0000000','19r').
% compute_pedigree('11R0199:0000000','11R0199:0000000','19r').


compute_pedigree(Ma,Pa,PlanningCrop) :-
        build_pedigrees([(Ma,Pa)],Trees),
	check_pedigrees(Trees,Checked),
        make_output_dir(PlanningCrop,ASCIIDir,LowerCaseCrop),
%        output_pedigrees(ASCIIDir,LowerCaseCrop,ped,Trees).
        output_pedigrees(ASCIIDir,LowerCaseCrop,ped,Checked).	












    
%%%%%%%%%%%%%%%%%%%%% pedigree construction %%%%%%%%%%%%%%%%%%%%%%


    
%! construct_pedigrees(-Trees:list) is semidet.

construct_pedigrees(Trees) :-
        setof((MN,PN),F^MG1^MG2^PG1^PG2^Gs^K^founder(F,MN,PN,MG1,MG2,PG1,PG2,Gs,K),Founders),
        build_pedigrees(Founders,Trees).
















% for a list of (Ma,Pa) tuples that are crosses between founders, return
% their pedigrees
%    
%
% sample calls:
%
% W23/Les1
%
%        build_pedigrees([('M18 112 512','M18 114 509')],Trees).
%
% Mo20W/Les11
%
% build_pedigrees([('06R0009:0000000','06R0009:0000000')],Trees),write_list(Trees).
% build_pedigrees([('06R0035:0000000','06R0035:0000000')],Trees),write_list(Trees).
    

%! build_pedigrees(+Founders:list,-Trees:list) is semidet.    
    
    
build_pedigrees(Founders,Trees) :-
        build_pedigrees(Founders,[],UnorderedTrees),
        list_to_ord_set(UnorderedTrees,Trees).


    

build_pedigrees([],A,A).
build_pedigrees([(MN,PN)|Founders],Acc,Trees) :-
        ( grab_offspring(MN,PN,Descendants) ->
                append(Acc,[(MN,PN)-Descendants],NewAcc)
        ;
                NewAcc = Acc
        ),
        build_pedigrees(Founders,NewAcc,Trees).








% for Ma and Pa, find their offspring; need to flatten the returned list to
% eliminate extraneous nesting of lists; convert to an ordset to remove
% duplicates and speed execution


grab_offspring(MN,PN,Descendants) :-
         ( find_planted(MN,PN,PlantList) ->
                ( find_offspring(PlantList,ListDescendants) ->
                        flatten(ListDescendants,Flattened),
                        list_to_ord_set(Flattened,Descendants)
                        
		;
                        Descendants = []
                )
        ;
                Descendants = []
        ).        








    

% kernels from an ear may be planted in more than one crop, or in
% more than one row in a crop, or both
%
% failures here are due to incomplete indices, which should now be fine
%
% Kazic, 23.5.2018 


   
find_planted(Ma,Pa,PlantList) :-
         ( setof((Crop,Row),planting_index(Ma,Pa,Crop,Row),CropRows) ->
                 get_row_members(CropRows,PlantList)
	 ;
                 false
         ).



    






    
get_row_members(CropRows,PlantList) :-
        get_row_members(CropRows,[],PlantList).



get_row_members([],A,A).
get_row_members([(Crop,Row)|CropRows],Acc,PlantList) :-
        ( row_members_index(Crop,Row,RowMembers) ->
                append(Acc,RowMembers,NewAcc)
        ;
                format('Warning! row_members data missing for ~q; row not planted or stand count 0~n',[(Crop,Row)]),
                NewAcc = Acc
        ),
        get_row_members(CropRows,NewAcc,PlantList).












% make it easy to look for a plant''s offspring
%
% Kazic, 21.5.2014

find_plants_offspring(Plant,Tree) :-
        find_offspring([Plant],Tree).






% takes a list of planted plants that have been crossed and returns their offspring as trees
% need an accumulator because descendant/3 can fail
%
% Kazic, 5.5.2009


% call is: pedigrees:find_offspring(['06R0009:0000908'],X).

find_offspring(Plants,Trees) :-
        find_offspring(Plants,[],Trees).


find_offspring([],A,A).
find_offspring([Plant|Plants],Acc,Trees) :-
        ( setof((DescMN,DescPN),descendant(Plant,DescMN,DescPN),NextGen) ->
                find_offspring_aux(NextGen,Tree),
                append(Acc,Tree,NewAcc)
        ;
                NewAcc = Acc
        ),
        find_offspring(Plants,NewAcc,Trees).







% for each cross, find its tree

find_offspring_aux([],[]).
find_offspring_aux([(DescMN,DescPN)|NextGens],[(DescMN,DescPN)-Tree|Trees]) :-
        grab_offspring(DescMN,DescPN,Tree),
        find_offspring_aux(NextGens,Trees).












% since family numbers are issued only when a family has been 
% planted for the first time, we must look in the harvest facts 
% for all descendants of a family.
% 
% But we don''t have harvest facts for all crops, so also check the inventory facts, 
% which are usually generated from the harvest facts for each crop with 
% occasional re-inventorying.  Since the inventory''s kernel count diminishes over time, 
% ignore the kernel count for tracing the pedigrees.
%
%
% if this fails the setof in find_offspring/3 will fail



% THERE IS A MUCH MORE IMPORTANT PROBLEM THAT COULD AFFECT THE PEDIGREES.
%
% This predicate assumes the family numbers are correct in the early years.  But 
% some were incorrect: family 1011 is both Mo20W/Les1 and
% Mo20W/Les4 in the data.  This is why suddenly the former''s pedigree suddenly
% became much shorter and the latter longer.  Checking the planning spreadsheets
% confirms this.
%
% So the most reliable way to trace is through crop and rowplant.
% This must be substituted for the simple unification used here.
%
% Additionally, a warning should be issued when the family numbers do not behave correctly.
%
% Kazic, 16.12.2009



% Extensive manual checking of output pedigrees indicates all data changes completed.
%
% Believe pedigrees now correct as of 10R; unification ok.
%
% Kazic, 7.5.2011



% added test to match by plantIDs without families, and 
% issue a warning if this is done.  Untested.
%
% Kazic, 23.5.2018



descendant(Plant,DescMN,DescPN) :-
        ( inventory(Plant,DescPN,_,_,_,_,_),
          DescMN = Plant )
        ;

        ( inventory(DescMN,Plant,_,_,_,_,_),
          DescPN = Plant )

        ;

        ( harvest(Plant,DescPN,Status,_,_,_,_),
          memberchk(Status,[succeeded,unknown]),
          DescMN = Plant )
        ;

        ( harvest(DescMN,Plant,Status,_,_,_,_),
          memberchk(Status,[succeeded,unknown]),
          DescPN = Plant ).

        % ;
        %                 ( ( harvest(Plant,DescPN,Status,_,_,_,_),
        %                     match_excluding_family_num(Plant,DescPN) ) ->
        %                         memberchk(Status,[succeeded,unknown]),
        %                         DescMN = Plant,
        %                         format('Warning! numerical genotypes ~w and ~w matched without families, check pedigree!~n',[Plant,DescPN])

        %                 ;
        %                         ( ( harvest(DescMN,Plant,Status,_,_,_,_),
        %                             match_excluding_family_num(Plant,DescMN) ) ->
        %                                 memberchk(Status,[succeeded,unknown]),
        %                                 DescPN = Plant,
        %                                 format('Warning! numerical genotypes ~w and ~w matched without families, check pedigree!~n',[Plant,DescMN])

        %                         ;    
        %                                 false
        %                         )
        %                 )
        %         )
        % ).






% test!

match_excluding_family_nums(Plant1ID,Plant2ID) :-
        remove_family(Plant1ID,Plant1SansFam),
        remove_family(Plant2ID,Plant2SansFam),
        Plant1SansFam == Plant2SansFam.









%%%%%%%%%%%%%%%%%%%% definition of founding lines for pedigree construction %%%%%%%%%

% I'm only interested in building pedigrees for mutant and crop improvement
% lines:  all pedigree construction begins with these founders.


% a top-level interface that returns all the founding mutant or crop
% improvement lines; for checking genotype.pl and clauses in
% genetic_utilities that group families by type:
%
%        inbred/2,
%        nam_founder/1,
%        other_peoples_corn/1,
%        crop_improvement/2,
%        crop_improvement_founder/2,
%        crop_improvement_second_gen/1,
%        fun_corn/2,
%        elite/2,
%        sweet_corn/2,
%        popcorn/2,
%        gerry_families/1.
%
% note that most numerical bounds for families that reflect my
% idiosyncratic numbering appear in those clauses (but not all! --- see
% grab_founders/1 and grab_founders_aux/2 in this module).  You'll need to
% modify both numbering and family groups for your experiment.
%
% Kazic, 1.12.2018







%! grab_founders(-Founders:list) is det.

grab_founders(Founders) :-
	findall(Family,(genotype(Family,_,_,_,_,_,_,_,_,_,_),
			            Family < 890,Family > 0),IntFamilies),
	sort(IntFamilies,Families),
	grab_founders(Families,Founders).







    

% first test if the family is a founder; if not, get the founding family
% wrt the paternal line, since that''s how I do my back-crosses.  For other
% genetic schemes, this and maybe some other predicates will need to
% change.
%
% Since the predicate can be called with non-founding lines, this backward
% recursion to the founder is needed.
%
% Kazic, 1.12.2018





    
%! grab_founders(+Families:list,-Parents:list) is nondet.
    
grab_founders(Families,Parents) :-
        grab_founders(Families,[],Parents).
    

grab_founders([],A,A).
grab_founders([Family|Families],Acc,Parents) :-
        ( founder(Family,Ma,Pa,_,_,_,_,_,_) ->
                append(Acc,[(Ma,Pa)],NewAcc)
	;
	        ( grab_founders_aux(Family,FounderParents) ->
	                 append(Acc,[FounderParents],NewAcc)
	        ;
	                 NewAcc = Acc
	        )
	),
        grab_founders(Families,NewAcc,Parents).









% climb backwards through the pedigree to the founder, if the input family
% is not a founder
%
% nb: all of my back-crosses are inbred x mutant, so the founding family
% is defined by the paternal line; and the second clause relies on my
% ordering of family numbers for founding mutant lines.
%
% Kazic, 1.12.2018


% revised to make termination condition more explicit
%
% Kazic, 7.3.2019


grab_founders_aux(Family,(Ma,Pa)) :-
	founder(Family,Ma,Pa,_,_,_,_,_,_).

grab_founders_aux(Family,(Ma,Pa)) :-   
        genotype(Family,_,_,PaFam,_,_,_,_,_,_,_),
	PaFam \== Family,
        genotype(PaFam,_,ParMa,PaternalPaFam,ParPa,_,_,_,_,_,_),
        ( founder(PaFam,ParMa,ParPa,_,_,_,_,_,_) ->
                Ma = ParMa,
                Pa = ParPa
	;
                grab_founders_aux(PaternalPaFam,(Ma,Pa))
        ).









    


%%%%%%%%%%%%%%%%%%%%%%%% pedigree integrity checks %%%%%%%%%%%%%%%%%%%%%%

% want to identify potential problems for manual checking
%
% so, a set of predicates to check constructed pedigrees and flag problems
%
% separate checking a built pedigree from building it without using
% family numbers.  For checking, get the checking info after construction,
% rather than carrying it along during construction.
%
% Kazic, 3.3.2019





%! check_pedigrees(+Trees:list,-Tree-Checked:keylist) is nondet.


check_pedigrees([],[]).
check_pedigrees([Tree|Trees],[Tree-Checked|RestChecked]) :-
	check_pedigree(Tree,Checked),
	check_pedigrees(Trees,RestChecked).









% there is some kludgey list manipulation here and in the next predicate
% (flatten, sort).  At some point, go back and see if there is a better way
% to build the check list.
%
% Kazic, 5.3.2019



%! check_pedigree(+Pedigree:list,-Checked:list) is semidet?

check_pedigree((_,_)-[],[]).
check_pedigree((FounderMa,FounderPa)-Descendants,Checked) :-
	genotype(_,_,FounderMa,_,FounderPa,_,_,_,_,[Mutant],FounderK),
%	toggle(State),
%	( State == test ->
%	        format('~n~n~n~ntop: ~w~n~n',[(FounderMa,FounderPa)-Descendants])
%	;
%	        true
%	),
	check_pedigree(Descendants,Mutant,FounderK,[],Int),
	flatten(Int,Checked).











% Mutant should be unchanged throughout, except in the case of constructed
% double mutants.
%
% Knum check against the founder neglects the last two digits, but checks
% against subsequent Knums constructs specific ones (with the different
% last two digits) and check those.
%
% Checked is a list of observed changes from founder or intermediate.
%
% Kazic, 3.3.2019




%! check_pedigree(+Branches:list,+Mutant:atom,+FounderK:atom,+Acc:list,-Checked:list) is nondet.

check_pedigree([],_,_,A,A).
check_pedigree([Branch|OtherBranches],Mutant,FounderK,Acc,Checked) :-

%	toggle(State),
%	( State == test ->
%	        format('~w~n~n',[[Branch]])
%	;
%	        true
%       ),

	check_pedigree_branch([Branch],Mutant,FounderK,Acc,PedAcc),
        append(PedAcc,Acc,NewAcc),
	sort(NewAcc,Sorted),
	check_pedigree(OtherBranches,Mutant,FounderK,Sorted,Checked).

















% Knum changes at the start of each major pedigree branch,
% but should be constant thereafter.

% Offspring without genotype facts should have no descendants, but can be
% visited multiple times.  Don't bother including warning messages for
% these.  This reduces the stack needed in subsequent appends.

%! check_pedigree_branch(+Offspring:list,+Mutant:atom,+FounderK:atom,+Acc:list,-PedAcc:list) is nondet.

check_pedigree_branch([],_,_,A,A).
check_pedigree_branch([(_,_)-[]],_,_,A,A).
check_pedigree_branch([(OffMa,OffPa)-OffDesc|T],Mutant,FounderK,Acc,PedAcc) :-
        ( genotype(_,_,OffMa,_,OffPa,_,_,_,_,[OffMutant],OffK) ->
	        check_marker(Mutant,OffMutant,OffMa,OffPa,MarkerWarning),
	        check_knums(FounderK,OffK,OffMa,OffPa,KNumWarning),
                append(Acc,[MarkerWarning,KNumWarning],CheckAcc),
		check_pedigree_branch(OffDesc,OffMutant,OffK,CheckAcc,IntAcc),
		check_pedigree(T,Mutant,OffK,IntAcc,PedAcc)
        ;
                ( OffDesc \== [] ->
	
	                term_to_atom(OffDesc,OffDescTerm),
	                atomic_list_concat(['no genotype for ',OffMa,' x ',OffPa,', descendants are ',OffDescTerm],Warning),
	                append(Acc,[Warning],IntAcc)
                ;
		        IntAcc = Acc
		),
		check_pedigree(T,Mutant,FounderK,IntAcc,PedAcc)
	).


	  
	






%! check_marker(+Mutant:atom,+OffMutant:atom,+OffMa:atom,+OffPa:atom,-MarkerWarning:atom)	         is semidet.

check_marker(M,M,_,_,[]).
check_marker(Mutant,OffMutant,OffMa,OffPa,MarkerWarning) :-
        Mutant \== OffMutant,
        atomic_list_concat(['marker shifts for ',OffMa,' x ',OffPa,' from ',Mutant,' to ',OffMutant],MarkerWarning).










%! check_knums(+FounderK:atom,+OffK:atom,+OffMa:atom,+OffPa:atom,-KNumWarning:atom) is semidet.

check_knums(K,K,_,_,[]).
check_knums(FounderK,OffK,OffMa,OffPa,KNumWarning) :-
	OffK \== FounderK,
	sub_atom(FounderK,0,_,2,FounderPrefix),
	( ( sub_atom(OffK,0,_,2,OffPrefix),
            FounderPrefix == OffPrefix ) ->
                KNumWarning = []
	;
                atomic_list_concat(['KNum shifts for ',OffMa,' x ',OffPa,' from ',FounderK,' to ',OffK],KNumWarning)
        ).












%%%%%%%%%%%%%%%%%%%%%%% directory management:  OS-dependent! %%%%%%%%%%%%%%%%%%%%%%%



% generation of the parallel pdf and Dropbox directories occurs in the corresponding
% perl script,
% ../../crops/scripts/make_pdf_pedigrees.perl


%! make_output_dir(+PlanningCrop:atom,-ASCIIDir:atom,-LowerCaseCrop:atom) is det.


make_output_dir(PlanningCrop,ASCIIDir,LowerCaseCrop) :-
        convert_crop(PlanningCrop,LowerCaseCrop),
        check_slash(LowerCaseCrop,LowerCaseCropS),
        pedigree_root_directory(RootDir),
        pedigree_planning_directory(Plnng),
        atomic_list_concat([RootDir,LowerCaseCropS,Plnng],ASCIIDir),

        ( exists_directory(ASCIIDir) ->
                true
        ;
                make_directory(ASCIIDir)
        ),

        build_subdirectories(ASCIIDir),
        atomic_list_concat(['chmod -R u+rwx ',ASCIIDir,'; chmod -R o-rwx ',ASCIIDir],ChmodCmd),
%        format('double chmod cmd: ~w~n',[ChmodCmd]),
        shell(ChmodCmd).



    









%! build_subdirectories(+ASCIIDir:atom) is det.

build_subdirectories(ASCIIDir) :-
        setof(SubDir-Files,pedigree_tree(SubDir,Files),SubDirs),
        make_subdirs_n_indices(ASCIIDir,SubDirs).












% swipl''s make_directory/1 doesn''t make intermediate directories, so
% if the parent directory hasn''t already been created, an exception will be
% thrown.  But using make_directory/1 is preferable to mkdir -p because it
% makes the code more operating system-independent.
%
% Kazic, 24.5.2018


%! make_subdirs_n_indices(+ASCIIDir:atom,+SubDirs:list) is det.


make_subdirs_n_indices(_,[]).
make_subdirs_n_indices(ASCIIDir,[SubDir-Files|T]) :-
        make_pedigree_index(SubDir,Files),
        atom_concat(ASCIIDir,SubDir,TargetDir),
        ( exists_directory(TargetDir) ->
                true
        ;
                make_directory(TargetDir)
        ),
        make_subdirs_n_indices(ASCIIDir,T).













%! make_pedigree_index(+SubDir:atom,+Files:list) is det.


make_pedigree_index(_,[]).
make_pedigree_index(SubDir,[H|T]) :-
        assert(pedigree_index(H,SubDir)),
        make_pedigree_index(SubDir,T).















%%%%%%%%%%%%%%%%%%%%%%% pedigree output %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% call ../../crops/scripts/make_pdf_pedigrees.perl to generate
% pdf and Dropbox versions
%
% Kazic, 24.5.2018


% added flag, set to go
%
% Kazic, 2.12.2018


% cd to the scripts directory to simplify things on the Perl side,
% then return to this directory, which is set by file_search_path/2 in
% ./set_demeter_directory.pl
%
% there are probably better ways of managing the environment of the forked
% process, but this will do for now.
%
% Kazic, 6.12.2018




%! output_pedigrees(+ASCIIDir:atom,+LowerCaseCrop:atom,+Switch:atom,+Trees:list) is det.

output_pedigrees(ASCIIDir,LowerCaseCrop,Switch,Trees) :-
	working_directory(ThisDir,ThisDir),
	pedigree_scripts_directory(ScriptDir),
        pretty_pedigrees(ASCIIDir,0,5,Switch,Trees),
	cd(ScriptDir),
        atomic_list_concat(['./make_pdf_pedigrees.perl ',LowerCaseCrop,' go'],Cmd),       
        format('shell cmd is: ~w~nnow entering make_pdf_pedigrees.perl!~n~n',[Cmd]),
        shell(Cmd),
        cd(ThisDir).










% this is now legible:  checked the W23/Les1 against the manually formatted whole list
% to make sure nothing lost in the uninstantiated variables.  Spot-checked others.
%
% Output one pedigree per file, using the scheme in the cmap_pedigrees.
%
% Kazic, 4.5.09
%
% added clauses for imaged pedigrees
%
% Kazic, 8.12.09
%
% build subdirectories and a dynamic index of which pedigrees go in which subdirectories
%
% Kazic, 25.9.2012






pretty_pedigrees(_,_,_,_,[]).
pretty_pedigrees(ASCIIDir,Increment,Indentn,Switch,[Tree|Trees]) :-
        pretty_pedigrees_aux(ASCIIDir,Increment,Indentn,Switch,Tree),
        pretty_pedigrees(ASCIIDir,Increment,Indentn,Switch,Trees).












% hey, get the file name from the gene of interest!  And, concatenate it
% with the K number if needed to distinguish different accessions of the
% same mutant!
%
% Kazic, 9.12.2018


% added output of pedigree checks
%
% Kazic, 5.3.2019



pretty_pedigrees_aux(PlanningCrop,Increment,Indentn,Switch,(FounderMa,FounderPa)-Tree-Checks) :-
        ( ( atom(FounderMa),
            atom(FounderPa) ) ->
                genotype(_,_,FounderMa,_,FounderPa,MG,_,_,_,[Mut],K)
        ;
                arg(1,FounderMa,FounderMaID),
                arg(1,FounderPa,FounderPaID),
                genotype(_,_,FounderMaID,_,FounderPaID,MG,_,_,_,[Mut],K)
        ),
        atomic_list_concat([Mut,'-',K],SpecificMut),
        build_pedigree_file_name(PlanningCrop,MG,SpecificMut,Switch,File),
        open(File,write,Stream),
        pedigree_header(Stream,File,Switch,MG,SpecificMut),
        ( Switch == ped ->
                pretty_pedigree(Stream,Increment,Indentn,[(FounderMa,FounderPa)-Tree])
        ;
                imaged_pedigree(Stream,Increment,Indentn,[(FounderMa,FounderPa)-Tree])
        ),

	output_checks(Stream,Checks),
        close(Stream).















% exploits new demeter_utilities:letter/2
%
% Kazic, 30.3.2018


build_file_name(PlanningCrop,MG,SpecificMut,Switch,File) :-
        remove_silly_characters([MG,SpecificMut],[NiceMG,NiceSpecificMut]),
        letter(LowSpecificMut,NiceSpecificMut),
        ( NiceMG \== '?' ->
                letter(LowMG,NiceMG)
        ;
                LowMG = NiceMG
        ),
        atomic_list_concat([PlanningCrop,LowSpecificMut,'_',LowMG],Tmp),
        ( Switch == ped ->
                File = Tmp
        ;
                atomic_list_concat([Tmp,'_',imaged],File)
        ).












% note swipl''s string_lower/2 works with atoms.  It returns a string, 
% but atomic_list_concat will accept that string for concatenation.
% Very convenient!


build_pedigree_file_name(PlanningCrop,MG,SpecificMut,Switch,File) :-
        remove_silly_characters([MG,SpecificMut],[NiceMG,NiceSpecificMut]),
        string_lower(NiceSpecificMut,LowSpecificMut),
        ( NiceMG \== '?' ->
                 string_lower(NiceMG,LowMG)
        ;
%                LowMG = NiceMG
                 LowMG = qm
        ),
        atomic_list_concat([LowSpecificMut,'_',LowMG],MutantFile),
        ( pedigree_index(MutantFile,SubDir) ->
                true
        ;
                SubDir = classify
        ),
        atomic_list_concat([PlanningCrop,SubDir,'/',MutantFile],Tmp),
        ( Switch == ped ->
                File = Tmp
        ;
                atomic_list_concat([Tmp,'_',imaged],File)
        ).






remove_silly_characters([],[]).
remove_silly_characters([Atom|Atoms],[Unsilly|Unsillies]) :-
        remove_silly_characters(Atom,'',Unsilly),
        remove_silly_characters(Atoms,Unsillies).







% huh! in swipl, midstring/5 calls quintus:midstring/5!
%
%         midstring(String,First,Rest,0,1),
%
% well, shift to sub_atom/5 for the sake of purity, maybe speed, too
%
% Kazic, 31.5.2018


remove_silly_characters('',A,A).
remove_silly_characters(Atom,Acc,Unsilly) :-
        sub_atom(Atom,0,1,_,First),
        ( memberchk(First,['?',' ','/','*','#','@','^',':',';']) ->
                NewAcc = Acc
        ;
                atom_concat(Acc,First,NewAcc)
        ),
        sub_atom(Atom,1,_,0,Rest),
        remove_silly_characters(Rest,NewAcc,Unsilly).













pedigree_header(Stream,File,Switch,MG,Mut) :-
        format(Stream,'% this is ~w~n',[File]),
        utc_timestamp_n_date(TimeStamp,UTCDate),
        ( Switch == ped ->
                format(Stream,'% generated ~w (=~w) by compute_pedigrees/1.~n~n',[UTCDate,TimeStamp]),
                format(Stream,'% Horizontal pedigrees, generations at same indentation.  S: Mo20W; W: W23; M: M14; B: B73.~n',[]),
                format(Stream,'% !!! => cross was not by Toni; references to image locations on right.~n',[])
        ;
                format(Stream,'% generated ~w (=~w) by find_imaged_ancestors/1.~n~n',[UTCDate,TimeStamp]),
                format(Stream,'% Horizontal pedigrees ONLY of those branches that have at least one image.~n',[]),
                format(Stream,'% Image pointers are next to each PlantID.~n',[]),
                format(Stream,'% Generations are at same indentation.  S: Mo20W; W: W23; M: M14; B: B73.~n',[])
        ),
        format(Stream,'~n% ~w/~w~n~n',[MG,Mut]).














pretty_pedigree(_,_,_,[]).
pretty_pedigree(Stream,Increment,Indentn,[(Ma,Pa)-H|T]) :-
        make_cmd(Increment,Cmd),
        ( ( nonvar(Ma),
            nonvar(Pa) ) ->
                associated_data(Ma,Pa,Bee,MaImages,PaImages),
                ( ( Bee == toni
                  ;
                    Bee == '?' ) ->
                        format(Stream,Cmd,[Ma,Pa])
                ;
                        make_bee_warning_cmd(Increment,BeeCmd),
                        format(Stream,BeeCmd,[Ma,Pa])
                )
        ;
                format('~n~nWarning! uninstantiated Ma and Pa for ~q x ~q!~n~n',[Ma,Pa])
        ),

        ( H == [] ->
                output_images(Stream,Ma,Pa,MaImages,PaImages,Increment),
                format(Stream,'~n',[])
        ;
                output_images(Stream,Ma,Pa,MaImages,PaImages,Increment),
                format(Stream,'~n',[]),
                TreeInc is Increment + Indentn,
                pretty_pedigree(Stream,TreeInc,Indentn,H)
        ),
        pretty_pedigree(Stream,Increment,Indentn,T).









make_cmd(Increment,Cmd) :-
        atomic_list_concat(['~',Increment,'| ~w x ~w'],Cmd).	


make_imaged_cmd(Increment,Cmd) :-
         atomic_list_concat(['~',Increment,'| ~w  ~w   x   ~w  ~w'],Cmd).

make_bee_warning_cmd(Increment,Cmd) :-
        atomic_list_concat(['~',Increment,'| ~w x ~w     !!!'],Cmd).	





% hmmm, maybe stick gene and Knum here?
%
% Kazic, 27.11.2018

associated_data(Ma,Pa,Bee,MaImages,PaImages) :-
        ( ( nonvar(Ma),
            nonvar(Pa) ) ->
                ( cross(Ma,Pa,ear(1),false,Bee,_,_,_) ->
                        ( Bee == toni ->
                                true
	                ;


% tired of all the warnings; these show up in the pedigrees
%
% Kazic, 28.4.2012
                                ( nonvar(Bee) ->
%                                        format('Warning! ~q x ~q pollinated by ~q!~n',[Ma,Pa,Bee])
                                        true
                                ;
                                        Bee = '?'
                                )
                        )
                ;

%
% shut off warning for now since pedigree will have !!! for non-toni, non-? pollinations
%
% Kazic, 5.5.09
%
%                        format('Warning! cross data for ~q x ~q not found!~n',[Ma,Pa]),
                        Bee = '?'
                ),

                ( ( inbred(Ma,_,_)
                  ; founder(_,Ma,_,_,_,_,_,_,_) ) ->
                        MaImages = []
                ;
                        ( setof((Image,Leaf,Sectn,Cam,Date),Light^Shooter^Time^image(Ma,Image,Leaf,Sectn,Cam,Light,Shooter,Date,Time),MaImages) ->
                                 true
                        ;
                                 MaImages = []
                        )
                ),
                ( ( inbred(Pa,_,_)
                  ; founder(_,_,Pa,_,_,_,_,_,_) ) ->
                        PaImages = []
                ;
                        ( setof((PImage,PLeaf,PSectn,PCam,PDate),PLight^PShooter^PTime^image(Pa,PImage,PLeaf,PSectn,PCam,PLight,PShooter,PDate,PTime),PaImages) ->
                                 true
                        ;
                                 PaImages = []
                        )
                )
         ;
                MaImages = [],
                PaImages = []
         ).                
                                


            



output_images(_,_,_,[],[],_).
output_images(Stream,Ma,Pa,MaImages,PaImages,Increment) :-
        ( MaImages == [] ->
                decode_image_refs(Pa,PaImages,DecodedPa),
                PaInc is Increment + 45,
                make_list_cmd(PaInc,PaCmd),
                format(Stream,PaCmd,[Pa,DecodedPa])
        ;
                MaInc is Increment + 45,
                decode_image_refs(Ma,MaImages,DecodedMa),
                make_list_cmd(MaInc,MaCmd),
                format(Stream,MaCmd,[Ma,DecodedMa]),
                ( PaImages == [] ->
                        true
                ;
                        decode_image_refs(Pa,PaImages,DecodedPa),
                        PaInc is MaInc + 45,
                        make_list_cmd(PaInc,PaCmd),
                        format(Stream,PaCmd,[Pa,DecodedPa])
                )
        ).




make_list_cmd(Increment,Cmd) :-
        number_chars(Increment,IncChars),
        atom_chars(IncAtom,IncChars),
        atomic_list_concat(['~',IncAtom,'| ~w: ~w'],Cmd).







decode_image_refs(Plant,Images,Decoded) :-
        get_crop(Plant,Crop),
	convert_crop(Crop,LowLoctn),
        decode_image_refs_aux(LowLoctn,Images,StemmedImages),
        group_images(StemmedImages,Grouped),
        sort(Grouped,Decoded).






decode_image_refs_aux(_,[],[]).
decode_image_refs_aux(LowLoctn,[(Num,_Leaf,_Sectn,Camera,date(Day,Month,_))|Images],[Stem-Num|StemmedImages]) :-
        atomic_list_concat([LowLoctn,'/',Camera,'/',Day,'.',Month],Stem),
        decode_image_refs_aux(LowLoctn,Images,StemmedImages).





group_images(StemmedImages,Decoded) :-
        group_images(StemmedImages,[],Decoded).



group_images([],A,A).
group_images([Stem-Num|Stemmed],Acc,Decoded) :-
        ( selectchk(Stem-NumList,Acc,Rest) ->
                append(NumList,[Num],NewNumList),
                append(Rest,[Stem-NewNumList],NewAcc)
        ;
                append(Acc,[Stem-[Num]],NewAcc)
        ),
        group_images(Stemmed,NewAcc,Decoded).








% for use with imaged pedigrees; images are already there and there''s no 
% need for bee warnings
%
% Kazic, 8.12.09


imaged_pedigree(_,_,_,[]).
imaged_pedigree(Stream,Increment,Indentn,[(MaTuple,PaTuple)-H|T]) :-
        make_imaged_cmd(Increment,Cmd),
        ( ( nonvar(MaTuple),
            nonvar(PaTuple) ) ->
                arg(1,MaTuple,Ma),
                arg(2,MaTuple,MaImages),
                arg(1,PaTuple,Pa),
                arg(2,PaTuple,PaImages),
                format(Stream,Cmd,[Ma,MaImages,Pa,PaImages])
        ;
                format('~n~nWarning! uninstantiated Ma or Pa tuple(s)!~n~n',[])
        ),

        ( H == [] ->
                format(Stream,'~n',[])
        ;
                format(Stream,'~n',[]),
                TreeInc is Increment + Indentn,
                imaged_pedigree(Stream,TreeInc,Indentn,H)
        ),
        imaged_pedigree(Stream,Increment,Indentn,T).


















% for each pedigree, find those that contain at least one image;
% for branches containing images, output the condensed maternal pedigree
% (e.g., [bc(s,1),bc(w,2)]), plants with image locations, gene, and K number.
%
% Kazic, 4.12.09
%
% for each set of images from a plant, where does that plant fit in its pedigree?
%
% looks like there is still a pruning problem
%
% Kazic, 15.12.09

find_imaged_ancestors(PlanningCrop) :-
        construct_pedigrees(Trees),
        find_imaged_branches(Trees,Branches),
        prune_branches(Branches,Pruned),
        output_pedigrees(PlanningCrop,imped,Pruned).






find_imaged_branches([],[]).
find_imaged_branches([(FoundingFemale,FoundingMale)-Tree|Trees],[ImagedTree|Branches]) :-
        find_images_in_tree((FoundingFemale,FoundingMale)-Tree,ImagedTree),
        find_imaged_branches(Trees,Branches).






% the Tree is a list of branches, each with a branch node and a list of twigs (see les1_w_tree).
%
% FIRST find all images for each node
%
% THEN traverse the trees, for each pruning away nodes that have no images and no descendants
%
% FINALLY, for each remaining tree: find locus and K num for the root; for each remaining terminal node, 
% find abbreviated maternal pedigree.
%
% Kazic, 7.12.09
%
% defer last step for now
%
% Kazic, 8.12.09

find_images_in_tree((Female,Male)-DescendantTree,(FemaleImageSet,MaleImageSet)-ImagedTree) :-
        test_for_image(Female,FemaleImageSet),
        test_for_image(Male,MaleImageSet),
        test_tree_for_image(DescendantTree,ImagedTree).










test_for_image(PlantID,i(PlantID,ImageSet)) :-
        ( setof((Image,Leaf,Sectn,Cam,Date),Light^Shooter^Time^image(PlantID,Image,Leaf,Sectn,Cam,Light,Shooter,Date,Time),Images) ->
                 decode_image_refs(PlantID,Images,ImageSet)
        ;
                 ImageSet = []
        ).






test_tree_for_image([],[]).
test_tree_for_image([(Female,Male)-DescendantTree|T],[(FemaleImageSet,MaleImageSet)-DescendantImagedTree|T2]) :-
        test_for_image(Female,FemaleImageSet),
        test_for_image(Male,MaleImageSet),
        test_tree_for_image(DescendantTree,DescendantImagedTree),
        test_tree_for_image(T,T2).






% add image pointers; prune node if no images AND no descendants
%


prune_branches(Branches,Pruned) :-
        prune_branches(Branches,[],Pruned).




% easy pruning first

prune_branches([],A,A).
prune_branches([(i(Female,FemaleImageSet),i(Male,MaleImageSet))-DescendantImagedTree|T],Acc,Pruned) :-
        ( ( FemaleImageSet == [],
            MaleImageSet == [],
            DescendantImagedTree == [] ) ->
                NewAcc = Acc
        ;
                prune_branches(DescendantImagedTree,PrunedDescendants),
                ( ( PrunedDescendants == [],
                    FemaleImageSet == [],
                    MaleImageSet == [] ) ->
                        NewAcc = Acc
                ;
                        append(Acc,[(i(Female,FemaleImageSet),i(Male,MaleImageSet))-PrunedDescendants],NewAcc)
                )
        ),
        prune_branches(T,NewAcc,Pruned).





% prunable_branch((FoundingFemale,FoundingMale)-Tree) ->
%                 identify_line(FoundingMale,Locus,KNum),







% by convention, only the male is assumed to found the line in the case of sib crosses
%
% test, but should work except for silly syntactic stuff

identify_line(FoundingMale,Locus,KNum) :-
        get_family(FoundingMale,Family),
        genotype(Family,_,_,_,FoundingMale,_,_,_,_,MarkerList,KNum),
        ( length(MarkerList,1) ->
                head(MarkerList,Locus)
        ;
                member(Locus,MarkerList),
                gene_type(Locus,_,_,Type),
                ( Type \== wild_type ->
                        true
                ;
                        format('Warning!  cannot identify mutant from marker list for family ~w~n',[Family])
                )
        ),
        ( KNum == '' ->
                get_knum(FoundingMale,KNum)
        ;
                true
        ).
















% to output nontrivial pedigree checking results 
%
% Kazic, 5.3.2019

output_checks(_,[]).
output_checks(Stream,Checks) :-
        format(Stream,'~n~n~n~nCheck:~n~n~n',[]),
	output_checks_aux(Stream,Checks).








output_checks_aux(_,[]).
output_checks_aux(Stream,[Check|Checks]) :-
	format(Stream,'~w~n~n',Check),
	output_checks_aux(Stream,Checks).






%%%%%%%%%%%%%%% obsolete



% patched in to figure out pedigree checking
%
% Kazic, 10.1.2019



% succeeds with:
%
% findall(I,between(1,199,I),L),test_n_check_pedigrees(L,'19r',C).
% findall(I,between(600,703,I),L),test_n_check_pedigrees(L,'19r',C).

% call: spy(check_pedigrees/2),asserta(toggle(test)),test_n_check_pedigrees([1,2,3,4,5],'19r',C).

% findall(I,between(1,20,I),L),test_n_check_pedigrees(L,'19r',C).




test_n_check_pedigrees(Families,PlanningCrop,Checked) :-
        grab_founders(Families,Parents),
        build_pedigrees(Parents,Trees),
	check_pedigrees(Trees,Checked),
        make_output_dir(PlanningCrop,ASCIIDir,LowerCaseCrop),
        output_pedigrees(ASCIIDir,LowerCaseCrop,ped,Checked).















% the prior version of this, with just the Family < 890, produced infinite
% backtracking for family 890.  Cleaned up the logic, current predicate is
% above.
%
% Kazic, 7.3.2019



%% grab_founders_aux(Family,(Ma,Pa)) :-   
%%         ( founder(Family,Ma,Pa,_,_,_,_,_,_) ->
%% 	        true
%% 	;  


%% % if PaFam < 890 and not a founder, fail
%% % depending on clause ordering to save a little speed,
%% % not very declarative!
	
%%                 ( ( Family < 890,
%%    	            \+ founder(Family,_,_,_,_,_,_,_,_) ) ->
%% 	                false
%%                 ;
%%                         genotype(Family,_,_,PaFam,_,_,_,_,_,_,_),
%% 		        PaFam \== Family,
%%                         genotype(PaFam,_,ParMa,PaternalPaFam,ParPa,_,_,_,_,_,_),
%%                         ( founder(PaFam,ParMa,ParPa,_,_,_,_,_,_) ->
%%                                 Ma = ParMa,
%%                                 Pa = ParPa
%% 			;
%%                                 grab_founders_aux(PaternalPaFam,(Ma,Pa))
%%                         )
%% 		)
%%         ).

















%%%%%%%%%% obsolete? %%%%%%%%%%%%%%%%%%%%%%%%



% it will be easier to trace the pedigrees through the successive crops if the 
% the crops are ordered.  First split each crop into Year-Season keyvalue pair;
% sort on the key; then reverse sort on the season; then put them back together.
% desired order is R, N, G

seasonal_sort(UnsortedPlantings,Plantings) :-
        length(UnsortedPlantings,Len),
        ( Len =:= 1 ->
                keys_and_values(UnsortedPlantings,_,Plantings)
        ;
                split_crops(UnsortedPlantings,Split),
                sort(Split,FirstSort),
                divide_list(FirstSort,ListsByYear),
                seasonal_sort_aux(ListsByYear,Ordered),
                keys_and_values(Ordered,_,Plantings)
        ).








divide_list([H|T],DividedLists) :-
        divide_list(H,T,[],[],DividedLists).



divide_list(_,[],[],A,A).
divide_list(H,[],IntAcc,Acc,Plantings) :-
        append(IntAcc,[H],NewIntAcc),  
        append(Acc,[NewIntAcc],NewAcc),
        divide_list(_,[],[],NewAcc,Plantings).
               
divide_list(CurrentYr-CurrentSeason-Tuple1,[Year-Season-Tuple2|YrSeasns],IntAcc,Acc,Plantings) :-
        ( Year == CurrentYr ->
               append(IntAcc,[Season-Year-Tuple2],NewIntAcc),
               divide_list(CurrentYr-CurrentSeason-Tuple1,YrSeasns,NewIntAcc,Acc,Plantings)
        ;
               append(IntAcc,[CurrentSeason-CurrentYr-Tuple1],NewIntAcc),
               append(Acc,[NewIntAcc],NewAcc),
               divide_list(Year-Season-Tuple2,YrSeasns,[],NewAcc,Plantings)
        ).








seasonal_sort_aux(ListsByYear,Ordered) :-
        seasonal_sort_aux(ListsByYear,[],Ordered).



seasonal_sort_aux([],A,A).
seasonal_sort_aux([H|T],Acc,Ordered) :-
        sort(H,Sorted),
        reverse(Sorted,Reversed),
        append(Acc,Reversed,NewAcc),
        seasonal_sort_aux(T,NewAcc,Ordered).







