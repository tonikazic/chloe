% this is demeter/code/queries.pl


find_crossed_mutant_male(Mutatn,X) :-
        ( mutant(_,X,Mutatn,_,_,_,_,_,_,_)
	;
	  mutant(_,X,_,Mutatn,_,_,_,_,_,_)
        ),
        cross(_,X,ear(1),false,_,_,_,_).
