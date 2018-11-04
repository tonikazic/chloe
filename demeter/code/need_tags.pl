% this is demeter/code/need_tags.pl

% given the harvest records, compute the list of all needed male and female tags for 09r
% (or any subsequent crop)
%
% 09R only: if female is from rows 328 -- 402 and is not selfed, then a mommy tag is needed
%
% if harvest record says "need tag" then both mommy and daddy tags needed
%
% Kazic, 5.11.09


%declarations%

:-       module(need_tags,[
                 need_tags/2
                 ]).



:-      use_module(demeter_tree('code/genetic_utilities')),
        use_module(demeter_tree('code/demeter_utilities')),    
        use_module(demeter_tree('data/load_data')).





:-      ensure_loaded(library(lists)),
        ensure_loaded(library(sets)),
%
% library not in SICStus Prolog
%
%        ensure_loaded(library(basics)),
        ensure_loaded(library(strings)),
        ensure_loaded(library(flatten)),
        ensure_loaded(library(date)).



%end%




need_tags(Crop,File) :-
        setof(PlantIDs,tag_needed(Crop,PlantIDs),TagLists),
        flatten(TagLists,Unsorted),
        sort(Unsorted,Sorted),
        keys_and_values(Sorted,_,Tags),
        output_data(File,tags,Tags).






tag_needed(Crop,PlantIDs) :-
        harvest(Ma,Pa,succeeded,Note,_,_,_),
        get_crop(Ma,Crop),
        get_row(Ma,RowAtom),
        atom_number(RowAtom,Row),
        ( ( Crop == '09R',
            Row >= 328,
            Row =< 402,
            Ma \== Pa ) ->
                get_family(Ma,MaFam),
                PlantIDs = [MaFam-Ma]
	;
                nonvar(Note),
                midstring(Note,'needs tag',_,_),
	        get_row(Pa,PRowAtom),
	        atom_number(PRowAtom,PRow),
                get_family(Ma,MaFam),
                PlantIDs = [MaFam-Ma,PRow-Pa]
        ).


