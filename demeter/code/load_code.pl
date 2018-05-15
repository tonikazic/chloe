% this is ../c/maize/demeter/code/load_code.pl
%
% adapted for swipl and more portability across platforms
%
%
% Kazic, 27.3.2018





% this assumes we are running Quintus Prolog, which has all the libraries;
% not Sicstus, which doesn''t or has them rearranged.
%
% Kazic, 25.3.2015


% first the libraries
/*
:-      ensure_loaded(library(strings)),
        ensure_loaded(library(not)),
        ensure_loaded(library(lists)),
        ensure_loaded(library(basics)),
        ensure_loaded(library(listparts)),
        ensure_loaded(library(ordsets)),
        ensure_loaded(library(sets)),
        ensure_loaded(library(not)),
        ensure_loaded(library(flatten)),
        ensure_loaded(library(date)).       

*/



% now the code


:-
        ensure_loaded(demeter_utilities),
        ensure_loaded(genetic_utilities).


/*
        ensure_loaded(pedigrees),
        ensure_loaded(analyze_crop),
        ensure_loaded(crop_management),
        ensure_loaded(order_packets).
*/





