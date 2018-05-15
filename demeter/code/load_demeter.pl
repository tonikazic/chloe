% this is ../c/maize/demeter/code/load_demeter.pl
%
% adapted for swipl and more portability across platforms
%
%
% Kazic, 27.3.2018



% this was demeter/code/load_demeter.pl
%
% loads all of Demeter and ensures that all other search paths are loaded
%
% Kazic, 21.2.2009



load_demeter :-

        ( file_search_path(demeter_tree,_X) ->
                true
	;
                format('~n~n~n=== loading the starting points of Demeter''s and other trees ===~n~n',[]),
                ensure_loaded(set_demeter_directory)
	),


% now load in the data

	format('~n~n~n=== loading Demeter data ===~n~n',[]),
        ensure_loaded(demeter_tree('data/load_data')),


% and now the code

	format('~n~n~n=== loading Demeter code ===~n~n',[]),
        ensure_loaded(demeter_tree('code/load_code')),
 
        true.




:-	load_demeter.
