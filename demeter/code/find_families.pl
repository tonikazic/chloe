% this is demeter/code/find_families.pl

% a collection of predicates to find families from various source data
%
% Kazic, 21.2.09


%declarations%

:-      module(find_families,[
                find_families/2
                ]).




:-      use_module(demeter_tree('code/genetic_utilities')),
        use_module(demeter_tree('code/plan_crop')),
        use_module(demeter_tree('data/load_data')).




    

% for find_families/2
%
% :-      use_module(genetic_utilities).
% :-      ensure_loaded('../data/planting_07r'),
%        ensure_loaded('../data/line').


:-      ensure_loaded(library(sets)),
%
% library not in SICStus Prolog
%
%        ensure_loaded(library(basics)),
        ensure_loaded(library(strings)).

%end%




% call: [find_families], find_open_family_numbers(open_numbers).





% predicate to grab family data from family_reconciliation2.csv and apply it to 
% plantings
%
% Kazic, 16.4.08

find_families(Crop,File) :-
        setof((Row,A,B,C,D,E),F^G^H^I^K^L^M^N^O^P^planting(Crop,Row,A,B,C,D,E,F,G,H,I,K,L,M,N,O,P),Rows),
        grab_fams_n_gtypes(Crop,Rows,Planted),
        output_families(File,Planted).




grab_fams_n_gtypes(_,[],[]).
grab_fams_n_gtypes(Crop,[(Row,OffFam,MaFam,Ma,PaFam,Pa)
%                     PmaMaGma,PmaMaGpa,PmaPaGpa,PmaPaGpa,MaQuasi,
%                     PpaMaGma,PpaMaGpa,PpaPaGma,PpaPaGpa,PaQuasi)
		   |T],
                   [(Row,NewOffFam,NewMaFam,Ma,NewPaFam,Pa,
                     PmaMaGma,PmaMaGpa,PmaPaGpa,PmaPaGpa,MaQuasi,
                     PpaMaGma,PpaMaGpa,PpaPaGma,PpaPaGpa,PaQuasi)|T2]) :-
        ( ( OffFam \== '',
            MaFam \== '',
            PaFam \== '' ) -> 
                NewOffFam = OffFam,
	        NewMaFam = MaFam,
		NewPaFam = PaFam

	;
	        ( ( OffFam \== '',
		    ( MaFam == '' ; PaFam == '' ) ) ->
		        format('~nWarning!  Offspring family ~w assigned but either maternal ~w or paternal ~w family missing.~n',[OffFam,MaFam,PaFam])
		;
			( MaFam == '' ->
			        deconstruct_plantID(Ma,MaCrop,NewMaFam,MaRow,_)
			;
				deconstruct_plantID(Ma,MaCrop,_,MaRow,_)
                        ),
			( PaFam == '' ->
			        deconstruct_plantID(Pa,PaCrop,NewPaFam,PaRow,_)
			;
				deconstruct_plantID(Pa,PaCrop,_,PaRow,_)
                        ),
                        find_offspring_family(Crop,Ma,MaCrop,NewMaFam,MaRow,Pa,NewPaFam,PaRow,Crop,OffFam,MaGtype,PaGtype),
			compute_offspring_genotype(MaGtype,PaGtype,
                                                   (OffMaGma,OffMaGpa,OffPaGma,OffPaGpa,OffQuasi))
                )
        ),
        grab_fams_n_gtypes(Crop,T,T2).






















% use the numerical genotypes to find the family number of the offspring of the earlier
% crops that were planted in the current crop. --- DONE BY IGNORING FAMILIES:  see pedigrees.pl
%
% use the family facts (construct these from the line facts) to get the genotype data
%
% use the genotypes and the numerical genotypes to construct the genotypes of the new families
%
% use the row numbers of the current crop to fill in its planting data
%
%
% warning!  this is a fragment
%
% Kazic, 4.2.09



% find_offspring_family(Crop,Ma,MaCrop,MaFam,MaRow,Pa,PaCrop,PaFam,PaRow,OffFam) :-
%        line(MaCrop,OffFam,MaFam,Ma,PaFam,Pa,
%                    PmaMaGma,PmaMaGpa,PmaPaGpa,PmaPaGpa,MaQuasi,
%                     PpaMaGma,PpaMaGpa,PpaPaGma,PpaPaGpa,PaQuasi),
%        planting(Crop,
