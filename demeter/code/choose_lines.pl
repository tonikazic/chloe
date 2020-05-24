% this is ../c/maize/demeter/code/choose_lines.pl

% predicates to choose among alternative lines for planting after
% inspecting the pedigrees.  The data are passed back to
% ./pack_corn:pack_corn/1 to print them out in a form ready for
% ../c/maize/label_making/make_seed_packet_labels.perl to generate the
% packet labels for packing corn.
%
% simplified and ported to swipl!
%
%
% my criteria for choosing which among sibling lines to plant are
% idiosyncratic.  Change the following predicates to correspond to your
% criteria:
%
%      pick_best/5; and
%      check_lines/3.
%
%
% Kazic, 26.7.2019









%declarations%



:-      module(choose_lines, [
                choose_lines/3
                ]).





:-      use_module(demeter_tree('code/genetic_utilities')),
        use_module(demeter_tree('code/pedigrees')),
        use_module(demeter_tree('code/demeter_utilities')),    
%        use_module(demeter_tree('data/load_data')).
        true.


%end%










%! choose_lines(+WarningStream:io_stream,+AvailableChoices:list,-ChosenLines:list) is semidet.
%
% see the heads of each list for their syntax.
%
% a family that does not yet have a genotype/11 fact because it has
% never been planted is '0000' by default; idiosyncratic


choose_lines(_,[],[]).
choose_lines(WarningStream,[p(Row,NumPackets,CrossAlternatives,Plntg,Plan,Comments,K,Crop,Cl,Ft)|T],
	     [Locatn-(Row,NumPackets,MaNumGtype,PaNumGtype,
		                                Family,Plntg,Plan,FinalComments,K,Crop,Cl,Ft)|Chosen]) :-
        ( convert_parental_syntax(CrossAlternatives,Alternatives) ->
                true
        ;
                format('Warning!  choose_lines:choose_lines/3 calls an unconsidered case in genetic_utilities:convert_parental_syntax/2 for ~w~n',[CrossAlternatives]),
	        Alternatives = CrossAlternatives
        ),

	choose_line(Crop,Alternatives,WarningStream,Locatn,MaNumGtype,PaNumGtype,Family,OldCropData),
        ( ( Family == '0000' ; skip(MaNumGtype) ; inbred(Family,_) ) ->
                FinalComments = Comments
        ;
	        merge_plans_n_comments(OldCropData,PreviousPlan,PreviousComments),
	        ( PreviousPlan == '' ->
		        PriorPlans = ''
                ;
                        atom_concat('.  PREVIOUS PLANS:  ',PreviousPlan,PriorPlans)
		),
                ( PreviousComments == '' ->
		        PriorComments = ''
                ;
                        atom_concat('   PREVIOUS COMMENTS:  ',PreviousComments,PriorComments)
                ),
	        atomic_list_concat([Comments,PriorPlans,PriorComments],FinalComments)
        ),   
        choose_lines(WarningStream,T,Chosen).











% if no line survives picking, grab the first alternative so it can be
% checked in the seed room
%
% nth1/3 is a queer way of picking off the head of the list, but swipl
% doesn't have a head/2 predicate like Quintus.  This approach is likely
% faster than =../2.
%
% Kazic, 22.7.2019



%! choose_line(+Crop:atom,+CrossAlternatives:list,-BestLocatn:atom,-BestMa:atom,
%                        -BestPa:atom,-BestFamily:atom,-PriorCropData:list) is semidet.


choose_line(Crop,CrossAlternatives,WarningStream,BestLocatn,BestMa,BestPa,BestFamily,PriorCropData) :-
	check_lines(CrossAlternatives,[],Checked),
	( Checked == [] ->
	        nth1(1,CrossAlternatives,(BestMa,BestPa)),
	        check_inventory(BestMa,BestPa,BestLocatn,RNum),
		RNum \== 0

	;
	        nth1(1,Checked,RNum-(Ma,Pa,Locatn)),
                ( ( \+ number(RNum) ; RNum > 0 ) ->
			( length(Checked,1) ->
			        BestMa = Ma,
			        BestPa = Pa,
			        BestLocatn = Locatn
                        ;
		                pick_best(Checked,RNum-(Ma,Pa,Locatn),BestMa,BestPa,BestLocatn)
		        )
                ;
                        format('Warning! no kernels remain for ~w x ~w, choose another line from ~w.~n',[Ma,Pa,CrossAlternatives]),
		        BestMa = Ma,
		        BestPa = Pa,
		        BestLocatn = Locatn
		)

	),
        find_all_plantings_of_line(Crop,WarningStream,BestMa,BestPa,PriorCropData),
        find_family(BestMa,BestPa,BestFamily).












% I always want the ear with the most kernels that doesn't have
% fungus. Change if your criteria differ from my idiosyncratic ones.
%
% I've kludged the kernel count and bag numbers for the inbreds so they
% come out first in sort order.  Later, I'll have to filter out the similar
% kludges for the skipped rows.
%
% I have an inventory/7 fact for the skipped corn, but it's faster just to
% bung it in than to hunt up the fact.
%
% Kazic, 25.7.2019


%! check_lines(+Choices:list,+Acc:list,-Checked:list).

check_lines([],A,A).
check_lines([(Ma,Pa)|T],Acc,Checked) :-
	get_family(Pa,PaFamily),
        ( skip(Ma) ->
               append(Acc,[inf-(Ma,Pa,z00000)],NewAcc)	
        ;

		( mutant_by_family(PaFamily) ->
		        check_inventory(Ma,Pa,Sleeve,NumCl),
		        ( has_fungus(Ma,Pa) ->
                                NewAcc = Acc
		        ;
                                append(Acc,[NumCl-(Ma,Pa,Sleeve)],NewAcc)	
                        )
                ;
                        ( inbred(PaFamily,_) ->
                                append(Acc,[2000-(Ma,Pa,a00001)],NewAcc)	
                        ;
                                NewAcc = Acc
			)
		)
	),
        check_lines(T,NewAcc,Checked).






        






% my idiosyncratic selection criteria; modify as you wish

%! pick_best(+VettedChoices:list,+BestSoFar:term,-BestMa:atom,-BestPa:atom,-BestLocatn:atom).



pick_best([],_-(BestMa,BestPa,BestLocatn),BestMa,BestPa,BestLocatn).
pick_best([NumCl-(MaNumGtype,PaNumGtype,Locatn)|T],RNum-(Ma,Pa,SoFarLocatn),BestMa,BestPa,BestLocatn) :-
        ( is_greater(NumCl,RNum) ->
                is_earlier(MaNumGtype,Ma),
                pick_best(T,NumCl-(MaNumGtype,PaNumGtype,Locatn),BestMa,BestPa,BestLocatn)
        ;
                pick_best(T,RNum-(Ma,Pa,SoFarLocatn),BestMa,BestPa,BestLocatn)
	).




	
		
	







%! merge_plans_n_comments(+OldCropData:list,-PreviousPlans:atom,-PreviousComments:atom) is semidet.


merge_plans_n_comments(OldCropData,PreviousPlan,PreviousComments) :-
        merge_plans_n_comments(OldCropData,'',PreviousPlan,'',PreviousComments).


merge_plans_n_comments([],P,P,C,C).
merge_plans_n_comments([_-(_,_,Crop,Plan,Comment)|T],PlanAcc,PreviousPlan,CommentAcc,PreviousComments) :-
        annotate_string(Crop,Plan,IntPlan),
	annotate_string(Crop,Comment,IntComment),
        atom_concat(PlanAcc,IntPlan,NewPlanAcc),
        atom_concat(CommentAcc,IntComment,NewCommentAcc),
        merge_plans_n_comments(T,NewPlanAcc,PreviousPlan,NewCommentAcc,PreviousComments).



