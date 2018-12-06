% this is ../c/maize/demeter/code/set_demeter_directory.pl
%
% adapted for swipl and more portability across platforms
%
% the key change is to check for the absolute path of the root, and
% then use that to manuever around the trees.  This fixes the previous
% problems with relative paths.
%
% Kazic, 26.3.2018
%
%
%    
% removed loading of agora, bnd, and moirai file search paths since those     
% predicates are now in demeter_utilities.pl (which should be shifted up
% to a /gprs/pithos/utilities directory).						  
%
% Kazic, 1.5.2018


    
    




% set up root directories for the maize Demeter database 
% (and on 24.5.2018, pedigrees);
% (and at 21.2.2009, ensure that moirai and agora 
% root directories are also loaded to get utility predicates.
% That has been replaced by demeter_utilities.pl.)
%
%
%
% Note that directories are operating system-dependent: modify for your
% local installation as needed.  You will also need to modify 
% demeter_utilities:check_slash/2, and possibly other predicates.
%
% Kazic, 24.5.2018



demeter_root_directory('c/maize/demeter/').    



:- 	multifile file_search_path/2.
:- 	dynamic file_search_path/2.






:-      absolute_file_name('.',AbsPath,[file_type(directory)]),
        sub_atom(AbsPath,BeforeLen,_,_,'c/maize/demeter/code'),
	sub_atom(AbsPath,0,BeforeLen,_,Root),

        demeter_root_directory(DemeterRoot),
	atom_concat(Root,DemeterRoot,DemeterRootDir),
        assert(user:file_search_path(demeter_tree,DemeterRootDir)),
    
        file_search_path(demeter_tree,D),
        format('~n~nDemeter search path demeter_tree loaded by Demeter is ~w~n',[D]).








    

% added the relative locations of the directories needed for
% pedigree output
%
% Kazic, 6.12.2018

pedigree_scripts_directory('../../crops/scripts/').
pedigree_root_directory('../../crops/').
pedigree_planning_directory('planning/current_pedigrees/').

    

% added a few more for easier management
%
% Kazic, 22.7.2018

planning_directory('/planning/').    
management_directory('/management/').    
tags_directory('/tags/').    
dropbox_dir('~/Dropbox/corn/').


    
    
:-      format('~nFacts for crop relative directories and local Dropbox asserted.~n~n~n',[]).    
