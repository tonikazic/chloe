% this is demeter/code/pedigrees.pl

% a collection of predicates to trace pedigrees using
% only the numerical genotypes; pulled from clean_data.pl
%
% Kazic, 3.5.09


% code assumes Quintus Prolog and its libraries
%
% Kazic, 25.3.2015


%declarations%



:-      module(pedigrees, [
                build_pedigrees/2,
                construct_pedigrees/1,
                find_imaged_ancestors/1,
                find_plants_offspring/2,
                grab_offspring/3,
                test_pedigrees/2,
                trace_pedigree/3,
                trace_pedigrees/1
                ]).




 
:-      use_module(demeter_tree('code/genetic_utilities')),
        use_module(demeter_tree('code/demeter_utilities')),
        use_module(demeter_tree('code/plan_crop')),
        use_module(demeter_tree('data/load_data')).



%end%





% phasma call: trace_pedigrees('/home/toni/demeter/results/15r_planning/').
%
% call: pedigrees:find_offspring(['06R0009:0000908'],X).
%
% (ignore klotho/moirai errors:  not everything called from there is loaded)






% want to trace the pedigree of each genotype and detect mis-assigned genotypes
% and families
%
% works for all of them unless data are missing!
%
% alas, CMapTools can''t draw a pedigree to save its life!
%
% Kazic, 4.5.2009
%
% have tested extensively with the W23/Les1 pedigree, uncovering a number of logical
% and data errors.  Warning statements have been inserted to prevent silent failures.
% Significant data cleaning and accessions are still required before this code can be 
% reworked.  In principle it should use only the planting, cross, and inventory data; 
% I have used some index predicates to speed the computation, but this has the potential 
% to introduce errors.  See results/missing_rows for warning message output.
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


% Warning!  multiply-planted rows in 11R are still not correctly resolved; Oh43 is included in
% the les5-GJ2_b73 pedigree!
%
% Failed ears also appearing in pedigrees, don''t think these are in inventory.
%
% Kazic, 29.4.2012
%
%
% transplants are now correctly tracked, except for the confused ones in 09R; the second
% instantiation has the correct family in the index facts.
%
% BUT I am baffled why the descendants of family 184, made in 11R, do not appear in any pedigree!
% These are the {S,W,M}/Rp1-D21, which were planted in 11N.  There were successful pollinations
% from 11N families 3476 and 3477 (rows 220 and 221, respectively).
%
% I believe I have fixed the data to allow the Baker/Braun les pedigree to be built.
%
% Kazic, 3.5.2012





% I solved the Les5 problem by getting better Les5 plants (family 116).  
% But I need to make sure this pedigree is computed.  I think there may be a problem
% with files getting over-written, because the generated file names are duplicates.
%
% Kazic, 17.10.2012

% test separately for families 600 -- 622, 628, 629, 631 -- 641; still being missed
%
% Kazic, 23.10.2012


    
% all these issues now resolved.  Missing harvest and inventory facts were found, 
% founder line numbers assigned for mutants from David Braun's field.
%
% There is still a funny I/O problem:  most of the way through, there is an error saying a
% stream does not exist:
% ! Existence error in argument 1 of format/3
% ! stream '$stream'(38207491) does not exist
% ! goal:  format('$stream'(38207491),'~50| ~w: ~w',['12R640:M0013807',[]])
%
% But the output file is correctly closed and both crosses involving that plant are in the pedigree:
%
% cross('12R640:M0013807','12R641:M0013903',ear(1),false,toni,toni,date(22,07,2012),time(10,30,16)).
% cross('12R641:M0013907','12R640:M0013807',ear(1),false,toni,wade,date(24,07,2012),time(09,04,54)).
%
%
% Running the pedigrees in test_pedigrees/2 succeeds:
%
% test_pedigrees([640,641,642,643,644,645,646,647,648,649,650,651,652,653,654],'../results/12n_planning/').
%
% and the two M14 files are the same size.  But the batch job doesn''t get to the mutants from David''s field.
% This is running both jobs from home over the wireless.
%
% Same result running over the wire.  Trace that one from home!  
%
% It would be good to work out the directory test so that prior results wouldn''t have to be tarred up and 
% out of the way.
%
% Kazic, 28.10.2012


% fixed Tp1 issue, data missing, recompute.


% stream issue recurred:  pedigrees for NAM founders not computed, but the rest appear to be.
%
% Kazic, 20.4.2013



trace_pedigrees(FileStem) :-
        construct_pedigrees(Trees),
        output_pedigrees(FileStem,ped,Trees).





% given a list of family numbers, generate the pedigrees
%
% checking for hiccups here; exclude Jason''s corn as it is officially not founders
%
% Kazic, 23.10.2012

% test_pedigrees([192,193,194,195,196,197,198,199,600,601,602,603,604,605,606,607,608,609,610,611,612,613,614,615,616,617,618,619,620,621,622,628,629,631,632,633,634,635,636,637,638,639,640,641],'../results/12n_planning/').

% test_pedigrees([640,641,642,643,644,645,646,647,648,649,650,651,652,653,654],'../results/12n_planning/').

test_pedigrees(ListFounderFamilies,FileStem) :-
        grab_parents(ListFounderFamilies,Parents),
        build_pedigrees(Parents,UnorderedTrees),
        list_to_ord_set(UnorderedTrees,Trees),
        output_pedigrees(FileStem,ped,Trees).






grab_parents([],[]).
grab_parents([Family|ListFounderFamilies],[(Ma,Pa)|Parents]) :-
        founder(Family,Ma,Pa,_MG1,_MG2,_PG1,_PG2,_Gs,_K),
        grab_parents(ListFounderFamilies,Parents).



% for those times when you only need one, for example because the genotypes of
% two lines are identical and the second file over-writes the first.  This happens
% with Jimmy''s Idf lines!
%
% Kazic, 3.5.2012


trace_pedigree(Ma,Pa,FileStem) :-
        build_pedigrees([(Ma,Pa)],UnorderedTrees),
        list_to_ord_set(UnorderedTrees,Trees),
        output_pedigrees(FileStem,ped,Trees).



% trace_pedigree('11R0192:0000000','11R0192:0000000','../results/12n_planning').
% trace_pedigree('11R0193:0000000','11R0193:0000000','../results/12n_planning').
% trace_pedigree('11R0622:0000000','11R0622:0000000','../results/12n_planning').
% trace_pedigree('11R0621:0000000','11R0621:0000000','../results/12n_planning').
% trace_pedigree('11R0628:0000000','11R0628:0000000','../results/12n_planning').
% trace_pedigree('11R0199:0000000','11R0199:0000000','../results/12n_planning').



% double-check: refactoring may have produced errors
%
% Kazic, 15.12.09
%
% done



construct_pedigrees(Trees) :-
        setof((MN,PN),F^MG1^MG2^PG1^PG2^Gs^K^founder(F,MN,PN,MG1,MG2,PG1,PG2,Gs,K),Founders),
        build_pedigrees(Founders,UnorderedTrees),
%
% W23/Les1
%
%        build_pedigrees([('M18 112 512','M18 114 509')],UnorderedTrees),
%
% Mo20W/Les11
%
%        build_pedigrees([('06R0009:0000000','06R0009:0000000')],UnorderedTrees),
        list_to_ord_set(UnorderedTrees,Trees).













% for a list of tuples --- crosses between founders --- return their trees

build_pedigrees(Founders,Trees) :-
        build_pedigrees(Founders,[],Trees).


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
% bug here or in the indices!!!
%
% Kazic, 1.5.2012

find_planted(MN,PN,PlantList) :-
         ( setof((Crop,Row),planting_index(MN,PN,Crop,Row),CropRows) ->
                 get_row_members(CropRows,PlantList)
	 ;
                 false
         ).



get_row_members(CropRows,PlantList) :-
        get_row_members(CropRows,[],PlantList).



% data:row_members/3 is incomplete!  See genetic_utilities:make_row_members/1
% for explanation.  Fixed that predicate to include numerical genotypes from 
% planting.
%
% Kazic, 5.5.09
%
% complete as of 4.12.09
%
% Kazic, 5.4.10




get_row_members([],A,A).
get_row_members([(Crop,Row)|CropRows],Acc,PlantList) :-
        ( row_members(Crop,Row,RowMembers) ->
                append(Acc,RowMembers,NewAcc)
        ;
                format('Warning! row_members data missing for ~q; row not planted or stand count 0~n',[(Crop,Row)]),
                NewAcc = Acc
        ),
        get_row_members(CropRows,NewAcc,PlantList).





% ooops!  in the setof version (DescMN,DescPN) in the output variable
% are uninstantiated.
%
% The tuple needs to be there, and no information is lost, but it 
% sure looks ugly on the printout.
%
% Kazic, 3.5.09


%
% original, non-setof version:
%
% find_offspring([],[]).
% find_offspring([Plant|Plants],[(DescMN,DescPN)-Tree|Trees]) :-
%        once(descendant(Plant,DescMN,DescPN)),
%        grab_offspring(DescMN,DescPN,Tree),
%
%
% first setof version
%
%        setof((DescMN,DescPN),descendant(Plant,DescMN,DescPN),NextGen),
%        build_pedigrees(NextGen,Tree),
%        find_offspring(Plants,Trees).
%
%
% second setof version; notice output tuple concealed in find_offspring_aux/2
%
%
%



% make it easy to look for a plant's offspring
%
% Kazic, 21.5.2014

find_plants_offspring(Plant,Tree) :-
        find_offspring([Plant],Tree).






% takes a list of planted plants that have been crossed and returns their offspring as trees
%
% oops! needed an accumulator because descendant/3 can fail!
%
% Kazic, 5.5.09

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





% if this fails the setof in find_offspring/3 will fail
%
% modified to include harvest data
%
% Kazic, 16.10.09
%
%
% the problem with checking the kernel count is that it changes over the years!
% A line with few kernels now may have had many in the past and produced offspring.
%
% So test for kernel count removed:  but it really should check the most recent kernel count.
%
%
% HOWEVER, THERE IS A MUCH MORE IMPORTANT PROBLEM THAT AFFECTS THE PEDIGREES.
%
% This assumes the family numbers are correct in the early years.  But it
% looks like some are incorrect: family 1011 is both Mo20W/Les1 and
% Mo20W/Les4 in the data.  This is why suddenly the former''s pedigree is
% much shorter and the latter longer.  Checking the planning spreadsheets
% confirms this.
%
% By the time we get to harvest facts the family numbers are ok, but the
% earlier years are affected.
%
% So the only reliable way to trace is through crop and rowplant.
% This must be substituted for the simple unification used here.
%
% Additionally, a warning should be issued when the family numbers do not behave correctly.
%
% Kazic, 16.12.09


% this has not been done! yikes!
%
% need to use crop_rowplant facts for all but the founding lines (since these are initially 0000000)
%
% but I am not sure this is really a problem, since I''ve been meticulous about changing data . . .
%
%
% Kazic, 13.12.2010


% Extensive manual checking of output pedigrees indicates all data changes completed.
%
% Believe pedigrees now correct as of 10R; unification ok.
%
% Consider restoring quantity test as discarded and not found ears are appearing in 
% pedigrees.  Not sure if I want to take the most recent inventory fact in pedigree
% construction, however.
%
% Kazic, 7.5.2011


descendant(Plant,DescMN,DescPN) :-
        ( ( inventory(Plant,DescPN,num_kernels(Num),_,_,_,_),
%            once(check_quantity_cl(Plant,DescPN,Num)),
            DescMN = Plant
          )
	;
          ( inventory(DescMN,Plant,num_kernels(Num),_,_,_,_),
%            once(check_quantity_cl(DescMN,Plant,Num)),
            DescPN = Plant
          )
        ;
          ( harvest(Plant,DescPN,Status,_,_,_,_),
            memberchk(Status,[succeeded,unknown]),
            DescMN = Plant
          )
	;
          ( harvest(DescMN,Plant,Status,_,_,_,_),
            memberchk(Status,[succeeded,unknown]),
            DescPN = Plant
          )
        ).
        













output_pedigrees(FileStem,Switch,Trees) :-
        check_slash(FileStem,FileStemS),
        build_subdirectories(FileStemS),
        pretty_pedigrees(FileStemS,0,5,Switch,Trees).




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
pretty_pedigrees(FileStem,Increment,Indentn,Switch,[Tree|Trees]) :-
        pretty_pedigrees_aux(FileStem,Increment,Indentn,Switch,Tree),
        pretty_pedigrees(FileStem,Increment,Indentn,Switch,Trees).






build_subdirectories(FileStem) :-
        setof(SubDir-Files,pedigree_tree(SubDir,Files),SubDirs),
        make_subdirs(FileStem,SubDirs),
        make_pedigree_index(SubDirs).





% don''t worry if we already have the subdirectories!
%
% Kazic, 16.10.2012
%
% phooey, getting trapped in illogic of directory properties; just
% delete 'em before running for now.
%
% Kazic, 19.10.2012

make_subdirs(_,[]).
make_subdirs(FileStem,[SubDir-_|T]) :-
        atomic_list_concat([FileStem,SubDir],Dir),
%        ( on_exception(existence_error(directory_property(Dir,writable)),
%                                       directory_property(Dir,writable),true) ->
                atomic_list_concat(['mkdir ',Dir],Cmd),
                unix(system(Cmd)),
%        ;
%                true
%        ),
        make_subdirs(FileStem,T).



% ! Existence error in argument 1 of format/3
% ! stream '$stream'(42008579) does not exist
% ! goal:  format('$stream'(42008579),'~50| ~w: ~w',['12R640:M0013807',[]])
%
% ah, and they all end up in classify . . . ok for now.


make_pedigree_index([]).
make_pedigree_index([SubDir-Files|T]) :-
        make_pedigree_index(SubDir,Files),
        make_pedigree_index(T).


make_pedigree_index(_,[]).
make_pedigree_index(SubDir,[H|T]) :-
        assert(pedigree_index(H,SubDir)),
        make_pedigree_index(SubDir,T).









% also output a pdf --- alas, must do with Perl as enscript on tritogeneia lame
%
% Kazic, 25.9.2012



% hey, get the file name from the gene of interest!  And, concatenate it with the K number
% if needed to distinguish different accessions of the same mutant!
%
% untested
%
% Kazic, 16.10.2012

pretty_pedigrees_aux(FileStem,Increment,Indentn,Switch,(FounderMa,FounderPa)-Tree) :-
        ( ( atom(FounderMa),
            atom(FounderPa) ) ->
%                genotype(_,_,FounderMa,_,FounderPa,MG,_,_,Mut,_,_)
                genotype(_,_,FounderMa,_,FounderPa,MG,_,_,_,[Mut],K)
        ;
                arg(1,FounderMa,FounderMaID),
                arg(1,FounderPa,FounderPaID),
%                genotype(_,_,FounderMaID,_,FounderPaID,MG,_,_,Mut,_,_)
                genotype(_,_,FounderMaID,_,FounderPaID,MG,_,_,_,[Mut],K)
        ),
        atomic_list_concat([Mut,'-',K],SpecificMut),
        build_pedigree_file_name(FileStem,MG,SpecificMut,Switch,File),
        open(File,write,Stream),
        pedigree_header(Stream,File,Switch,MG,SpecificMut),
        ( Switch == ped ->
                pretty_pedigree(Stream,Increment,Indentn,[(FounderMa,FounderPa)-Tree])
        ;
                imaged_pedigree(Stream,Increment,Indentn,[(FounderMa,FounderPa)-Tree])
        ),
        close(Stream).


% works on the Prolog side, but enscript has issues:  upshot is not all files printed fully
%
% Kazic, 25.9.2012
%
%        atomic_list_concat(['enscript -r ',File,' -o f.ps ; ps2pdf f.ps ',File,'.pdf ; rm f.ps'],Cmd),
%        unix(system(Cmd)).









% exploits new demeter_utilities:letter/2
%
% Kazic, 30.3.2018


build_file_name(FileStem,MG,SpecificMut,Switch,File) :-
        remove_silly_characters([MG,SpecificMut],[NiceMG,NiceSpecificMut]),
        letter(LowSpecificMut,NiceSpecificMut),
        ( NiceMG \== '?' ->
                letter(LowMG,NiceMG)
        ;
                LowMG = NiceMG
        ),
        atomic_list_concat([FileStem,LowSpecificMut,'_',LowMG],Tmp),
        ( Switch == ped ->
                File = Tmp
        ;
                atomic_list_concat([Tmp,'_',imaged],File)
        ).







% stick the not-yet classified pedigrees into their own directories!
%
% untested
%
% Kazic, 17.10.2012


build_pedigree_file_name(FileStem,MG,SpecificMut,Switch,File) :-
        remove_silly_characters([MG,SpecificMut],[NiceMG,NiceSpecificMut]),
        letter(LowSpecificMut,NiceSpecificMut),
        ( NiceMG \== '?' ->
                letter(LowMG,NiceMG)
        ;
                LowMG = NiceMG
        ),
        atomic_list_concat([LowSpecificMut,'_',LowMG],MutantFile),
        ( pedigree_index(MutantFile,SubDir) ->
                true
        ;
                SubDir = classify
        ),
        atomic_list_concat([FileStem,SubDir,'/',MutantFile],Tmp),
        ( Switch == ped ->
                File = Tmp
        ;
                atomic_list_concat([Tmp,'_',imaged],File)
        ).






remove_silly_characters([],[]).
remove_silly_characters([String|Strings],[Unsilly|Unsillies]) :-
        remove_silly_characters(String,'',Unsilly),
        remove_silly_characters(Strings,Unsillies).



remove_silly_characters('',A,A).
remove_silly_characters(String,Acc,Unsilly) :-
        midstring(String,First,Rest,0,1),
        ( memberchk(First,['?',' ','/']) ->
                NewAcc = Acc
        ;
                atomic_list_concat([Acc,First],NewAcc)
        ),
        remove_silly_characters(Rest,NewAcc,Unsilly).













pedigree_header(Stream,File,Switch,MG,Mut) :-
        format(Stream,'% this is ~w~n',[File]),
        utc_timestamp_n_date(TimeStamp,UTCDate),
        ( Switch == ped ->
                format(Stream,'% generated ~w (=~w) by trace_pedigrees/1.~n~n',[UTCDate,TimeStamp]),
                format(Stream,'% Horizontal pedigrees, generations at same indentation.  S: Mo20W; W: W23; M: M14.~n',[]),
                format(Stream,'% !!! => cross was not by Toni; references to image locations on right.~n',[])
        ;
                format(Stream,'% generated ~w (=~w) by find_imaged_ancestors/1.~n~n',[UTCDate,TimeStamp]),
                format(Stream,'% Horizontal pedigrees ONLY of those branches that have at least one image.~n',[]),
                format(Stream,'% Image pointers are next to each PlantID.~n',[]),
                format(Stream,'% Generations are at same indentation.  S: Mo20W; W: W23; M: M14.~n',[])
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
        number_chars(Increment,IncChars),
        atom_chars(IncAtom,IncChars),
        atomic_list_concat(['~',IncAtom,'| ~w x ~w'],Cmd).


make_imaged_cmd(Increment,Cmd) :-
        number_chars(Increment,IncChars),
        atom_chars(IncAtom,IncChars),
        atomic_list_concat(['~',IncAtom,'| ~w  ~w   x   ~w  ~w'],Cmd).





make_bee_warning_cmd(Increment,Cmd) :-
        number_chars(Increment,IncChars),
        atom_chars(IncAtom,IncChars),
%        atomic_list_concat(['~',IncAtom,'| ~w x ~w by ~w'],Cmd).
        atomic_list_concat(['~',IncAtom,'| ~w x ~w     !!!'],Cmd).







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
        decode_image_refs(Year,LowLoctn,Images,StemmedImages),
        group_images(StemmedImages,Grouped),
        sort(Grouped,Decoded).






decode_image_refs(_,_,[],[]).
decode_image_refs(Year,LowLoctn,[(Num,_Leaf,_Sectn,Camera,date(Day,Month,_))|Images],[Stem-Num|StemmedImages]) :-
        atomic_list_concat([Year,LowLoctn,'/',Camera,'/',Day,'.',Month],Stem),
        decode_image_refs(Year,LowLoctn,Images,StemmedImages).





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
                format('~n~nWarning! uninstantiated Ma or Pa tuple(s) for ~q x ~q!~n~n',[Ma,Pa])
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

find_imaged_ancestors(FileStem) :-
        construct_pedigrees(Trees),
        find_imaged_branches(Trees,Branches),
        prune_branches(Branches,Pruned),
        output_pedigrees(FileStem,imped,Pruned).






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

















%%%%%%%%%%%%%%% obsolete?

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










% for visualization with CMapTools

cmap_pedigrees(_,[]).
cmap_pedigrees(FileStem,[(FounderMa,FounderPa)-Tree|Trees]) :-
        atomic_list_concat([FileStem,'/',FounderMa,'_',FounderPa,'.txt'],File),
        open(File,write,Stream),
        format(Stream,'% this is ~w~n',[File]),
        utc_timestamp_n_date(TimeStamp,UTCDate),
        format(Stream,'% generated on ~w (=~w) by clean_data:trace_pedigrees/2.~n~n',[UTCDate,TimeStamp]),
        cmap_pedigree(Stream,FounderMa,FounderPa,Tree),
        close(Stream),
        cmap_pedigrees(FileStem,Trees).





cmap_pedigree(Stream,Ma,Pa,Tree) :-
        genotype(_,_,Ma,_,Pa,MG,_,_,Mut,_,_),
        format(Stream,'~n~n% ~w/~w~n~n~n',[MG,Mut]),
        cmap_cross(Stream,Ma,Pa),
        cmap_pedigree_tree(Stream,Ma,Tree).




% need a genuine tab stop!
%
% format('~c',[9]).

cmap_cross(Stream,Ma,Pa) :-
%        associated_data(Ma,Pa,Bee,MaImages,PaImages),
        format(Stream,'~w ~cx ~c~w~n',[Ma,9,9,Pa]),
%        format(Stream,'~w ~cx ~c~w~n',[Ma,9,9,Bee]),
%        cmap_images(Stream,Ma,MaImages,Pa,PaImages).
        true.





cmap_images(Stream,Ma,MaImages,Pa,PaImages) :-
        cmap_image(Stream,Ma,MaImages),
        cmap_image(Stream,Pa,PaImages).






% must still turn into file pointers cmap can read
%
% Kazic, 3.5.09

cmap_image(Stream,Parent,ParentImages) :-
        ( ParentImages == [] ->
                true
        ;
                format(Stream,'~w ~chas ~c~w~n',[Parent,9,9,ParentImages])
        ).







cmap_pedigree_tree(_,_,[]).
cmap_pedigree_tree(Stream,Ma,[(DMa,DPa)-Tree|Rest]) :-
        ( ( nonvar(DMa),
            nonvar(DPa) ) ->
                cmap_offspring(Stream,Ma,DPa),
                cmap_cross(Stream,DMa,DPa),
                ( Tree == [] ->
                       true
                ;
                       cmap_pedigree_tree(Stream,DMa,Tree)
                )
        ;
                var(DMa),
                var(DPa),
                cmap_pedigree_tree(Stream,Ma,Tree)
        ),
        cmap_pedigree_tree(Stream,Ma,Rest).






cmap_offspring(Stream,Ma,Descendant) :-
        format(Stream,'~w ~cx ~c~w~n',[Ma,9,9,Descendant]).


