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


    
    
% this was /athe/c/maize/demeter/code/set_demeter_directory.pl

% this was /tritogeneia/a/toni/demeter/code/set_demeter_directory.pl

% athe maps to /media/sf_Volumes/ on phasma
%
% migrated to phasma, using the path relative to the phasma mount point /media/sf_Volumes/
%
% Kazic, 4.8.2014




% set up root directories for the maize Demeter database and ensure that moirai and agora 
% root directories are also loaded
%
% Kazic, 21.2.09



% migrated to SICStus Prolog 4.2 and laieikawai.
%
% Libraries basics and listparts are not in SICStus, unlike Quintus.  Have commented these 
% out in the code.
%
% Must still retrieve Moirai -- Agora from tritogeneia, but this is how the trees will look.
%
% Kazic, 8.12.2011


% migrated to Quintus Prolog running on linux on a virtual machine (vmware) running on athe.
%
% Pitts and Kazic, 22.1.2014


% after much grief with vmware, we swtiched to VirtualBox, which actually
% works. the virtual machine is named phasma, and is a linux machine
% running on athe.
%
% On phasma, the mount point for /athe/{a,b,c,d,e} is /media/sf_Volumes/{a,b,c,d,e}.
%
% In many, but not all cases, relative paths are correctly resolved.  So I''ve just hard-wired 
% the paths. 
%
% Kazic, 25.3.2015



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