% this is /athe/c/maize/demeter/code/demeter_root_directory.pl

% this was /tritogeneia/a/toni/demeter/code/demeter_root_directory.pl

% athe maps to /media/sf_Volumes/ on phasma
%
% migrated to phasma, using the path relative to the phasma mount point /media/sf_Volumes/
%
% Kazic, 4.8.2014





% hard-wired root directory for maize db; change as needed
%
% Kazic, 21.2.09

% changed for laieikawai
%
% Kazic, 8.12.2011

% demeter_root_directory('/tritogeneia/a/toni/demeter').

% demeter_root_directory('/athe/c/maize/demeter').

% make the directories absolute for phasma to prevent confusion.  Most of the
% time the relative directories are correctly resolved, but not always.
%
% Kazic, 25.3.2015

demeter_root_directory('/media/sf_Volumes/c/maize/demeter').
