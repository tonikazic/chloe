


%%%%%%%%%%%%%%%% obsolete



%% stopped here porting
% test: screwy
%
% only difference from identify_row/3 is we guess the genotype at the end and
% don't check for conflicts --- why have this?

guess_parental_data(Crop,Row,Row-(PRow,Family,Ma,Pa,MGma,MGpa,PGma,PGpa,Marker,K)) :-
       planted(Row,Packet,_,_,PDate,PTime,_,Crop),
       build_row(Row,PRow),

       ( closest_contemporaneous_packet(Crop,Packet,_PDate,_PTime,_Ma,_Pa) ->
               ( track_transplants(Crop,Packet,ActualPacket) ->
                       closest_contemporaneous_packet(Crop,ActualPacket,_PDate,_PTime,Ma,Pa),
                       Family = 0000,
                       genotype(_,_,Ma,_,_,MGma,MGpa,_,_,_,_),
                       genotype(_,_,_,_,Pa,_,_,PGma,PGpa,Marker,K)

               ;
                       format('Warning! track_transplants/3 in get_parental_data/3 fails for row ~w in crop ~w.~n',[Row,Crop])
               )

       ;
               format('Warning! closest_contemporaneous_packet/6 in get_parental_data/3 fails for row ~w in crop ~w.~n',[Row,Crop])
       ),
       Line = Row-(PRow,Family,Ma,Pa,MGma,MGpa,PGma,PGpa,Marker,K),
       format('Warning!  guessed genotype~n~t~w~nfor row ~w in crop ~w.~n',[Line,Row,Crop]).













    
% these are very confusing!
%
% Kazic, 3.5.09


mommy(Male,(MN,Male)) :-
        inventory(MN,Male,num_kernels(Count),_,_,_,_),
        ( ( atom(Count)
          ;
            Count >= 24 ) ->
                genotype(MN,_),
                ( cross(MN,Male,1,false,_,_,_,_) ->
                        true
                ;
                        true
                )
        ).




% it could be our founder is really a founding mommy, rather than a daddy, if
% I had to sib.
%
% Here, "Male" is really a mutant used as a female . . .


daddy(Male,(Male,PN)) :-
        inventory(Male,PN,num_kernels(Count),_,_,_,_),
        ( ( atom(Count)
          ;
            Count >= 24 ) ->
                genotype(PN,_),
                ( cross(Male,PN,1,false,_,_,_,_) ->
                        true
                ;
                        true
                )
        ).






% nb:  this presumes a crop will never have more than 9999 rows!
%
% duh, it also presumes that the suffix after the colon is a padded rowplant, not 
% a fun corn suffix!  But those acquired proper rowplant suffixes anyway.
%
% Kazic, 1.8.09
%
% obsolete
%
% Kazic, 3.12.09

find_row_member(Crop,Row,RowMember) :-
        crop_rowplant(RowMember,Crop,_,_),
        midstring(RowMember,PaddedRow,_,8,5),
        remove_padding(PaddedRow,RowString),
        atom_chars(RowString,RowChars),
        number_chars(Row,RowChars).








% from the pedigrees, I concat multiple parents together separated only by a comma, and
% then stick these between quotes to form an atom.  So the atom must be split apart at the comma
% and the parental atoms generated.
%
% Kazic, 27.5.2010
%
% huh? see revised convert_parental_syntax/2 above.  This is most likely obsolete.
%
% Kazic, 1.4.2018


/*

divide_parents(Parents,DividedParents) :-
        divide_parents(Parents,[],DividedParents).


% divide_parents('',A,A).
divide_parents(Parents,Acc,DividedParents) :-
        divide_parents_aux(Parents,ParentalPair,Rest),
        append(Acc,[ParentalPair],NewAcc),
        ( Rest == '' ->
                DividedParents = NewAcc
	;
                divide_parents(Rest,NewAcc,DividedParents)
        ).






divide_parents_aux(Parents,ParentalPair,Rest) :-
        ( midstring(Parents,',',NextParents,0,1) ->
                true
	;
                NextParents = Parents
        ),
        midstring(NextParents,ParentalPair,Rest,0,33).




% no line/16 facts anywhere and grab_k_number/1 not called, so obsolete
%
% Kazic, 3.4.2018

grab_k_number(KNumber) :-
        line(_,_,_,_,_,_,_,_,_,_,KNumber1,_,_,_,_,KNumber2),
        ( ( KNumber1 == '', KNumber2 == '' ) ->
	        KNumber = KNumber1
	;
	        ( ( KNumber1 == '', KNumber2 \== '' ) ->
                        KNumber = KNumber2
		;
			( ( KNumber1 \== '', KNumber2 == '' ) ->
			        KNumber = KNumber1
			;
				( ( KNumber1 == KNumber2, KNumber1 \== '' ) ->
				        KNumber = KNumber1
                                ;
					format('~n~nWarning! unconsidered case in grab_k_number/1!~n~n',[])
                                )
			)
		)
	).
				   





% also not called, so obsolete
%
% Kazic, 3.4.2018

grab_mutant_locus(Locus) :-
        line(_,_,_,_,_,_,_,_,_,Locus1,_,_,_,_,Locus2,_),
        ( ( wild_type(Locus1), wild_type(Locus2) ) ->
	        false
	;
	        ( ( wild_type(Locus1), \+ wild_type(Locus2) ) ->
                        Locus = Locus2
		;
			( ( \+ wild_type(Locus1), wild_type(Locus2) ) ->
			        Locus = Locus1
			;
				( ( Locus1 == Locus2, \+ wild_type(Locus1) ) ->
				        Locus = Locus1
                                ;
					format('~n~nWarning! unconsidered case in grab_locus/1!~nLocus1 = ~w Locus2 = ~w~n~n',[Locus1,Locus2])
                                )
			)
		)
	).
				   





guess_crop(Year,PaddedF,Crop) :-
        ( guess_crop_aux(Year,Crop)
        ;
          guess_future(Year,PaddedF,Crop)
        ).




guess_crop_aux(Year,Crop) :-
        sub_atom(Year,2,2,_,AbbYr),
        ( atomic_list_concat([AbbYr,'R'],Crop)
        ;
          atomic_list_concat([AbbYr,'N'],Crop)
        ;
          atomic_list_concat([AbbYr,'G'],Crop)
        ).





guess_future(ThisYear,Year,_,_) :-
        Year is ThisYear + 1.


guess_future(ThisYear,Year,PaddedF,Crop) :-
        GuessYr is Year + 1,
        GuessYr =< ThisYear,
        guess_crop_aux(GuessYr,Crop),
        atomic_list_concat([Crop,PaddedF,':0000000'],DummyNumGtype),
        ( genotype(_,DummyNumGtype,_,_,_,_,_,_,_,_,_) ->
                true
        ;
                NextYear is Year + 1,
                guess_future(ThisYear,NextYear,PaddedF,Crop)
        ).






*/


