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
% Kazic, 22.7.2019












%declarations%



:-      module(choose_lines, [
                choose_lines/2
                ]).





:-      use_module(demeter_tree('code/genetic_utilities')),
        use_module(demeter_tree('code/pedigrees')),
        use_module(demeter_tree('code/demeter_utilities')),    
        use_module(demeter_tree('data/load_data')).



%end%










%! choose_lines(+AvailableChoices:list,-ChosenLines:list) is semidet.
%
% see the heads of each list for syntax.


choose_lines([],[]).
choose_lines([p(Row,NumPackets,CrossAlternatives,Plntg,Plan,Comments,K,Crop,Cl,Ft)|Choices],
	     [Locatn-(Row,NumPackets,MaNumGtype,PaNumGtype,Family,Plntg,Plan,Comments,K,Crop,Cl,Ft)|Chosen]) :-
        ( convert_parental_syntax(CrossAlternatives,Alternatives) ->
                true
        ;
                format('Warning!  choose_lines:choose_lines/2 calls an unconsidered case in genetic_utilities:convert_parental_syntax/2 for ~w~n',[CrossAlternatives]),
	        Alternatives = CrossAlternatives
        ),

	choose_line(Alternatives,Locatn,MaNumGtype,PaNumGtype,Family,OldCropData),
	merge_old_plans_n_comments(OldCropData,Plan,Comments),
        choose_lines(Choices,Chosen).











% if no line survives picking, grab the first alternative so it can be
% checked in the seed room
%
% nth1/3 is a queer way of picking off the head of the list, but swipl
% doesn't have a head/2 predicate like Quintus.  This approach is likely
% faster than =../2.
%
% Kazic, 22.7.2019



%! choose_line(+CrossAlternatives:list,-BestLocatn:atom,-BestMa:atom,
%                        -BestPa:atom,-BestFamily:atom,-PriorCropData:list) is semidet.


choose_line(CrossAlternatives,BestLocatn,BestMa,BestPa,BestFamily,PriorCropData) :-
	check_lines(CrossAlternatives,[],Checked),
	( Checked == [] ->
	        nth1(1,CrossAlternatives,(BestMa,BestPa)),
	        check_inventory(BestMa,BestPa,BestLocatn,RNum),
		RNum \== 0

	;
	        nth1(1,Checked,RNum-(Ma,Pa,Locatn)),
		RNum \== 0,
		( length(Checked,1) ->
		        BestMa = Ma,
		        BestPa = Pa,
		        BestLocatn = Locatn
                ;
	                pick_best(Checked,RNum-(Ma,Pa,Locatn),BestMa,BestPa,BestLocatn)
	        )
        ),
        find_all_plantings_of_line(BestMa,BestPa,PriorCropData),
        find_family(BestMa,BestPa,BestFamily).












% I always want the ear with the most kernels that doesn't have
% fungus. Change if your criteria differ.


%! check_lines(+Choices:list,+Acc:list,-Checked:list).

check_lines([],A,A).
check_lines([(Ma,Pa)|T],Acc,Checked) :-
        check_inventory(Ma,Pa,Sleeve,NumCl),
	( has_fungus(Ma,Pa) ->
                NewAcc = Acc
	;
                append(Acc,[NumCl-(Ma,Pa,Sleeve)],NewAcc)	
	),
        check_lines(T,NewAcc,Checked).






        






% idiosyncratic selection criteria; modify as you wish

%! pick_best(+VettedChoices:list,+BestSoFar:term,-BestMa:atom,-BestPa:atom,-BestLocatn:atom).


pick_best([],_-(BestMa,BestPa,BestLocatn),BestMa,BestPa,BestLocatn).
pick_best([NumCl-(MaNumGtype,PaNumGtype,Locatn)|T],RNum-(Ma,Pa,Locatn),BestMa,BestPa,BestLocatn) :-
        ( is_greater(NumCl,RNum) ->
                is_earlier(MaNumGtype,Ma),
                pick_best(T,NumCl-(MaNumGtype,PaNumGtype,Locatn),BestMa,BestPa,BestLocatn)
        ;
                pick_best(T,RNum-(Ma,Pa,Locatn),BestMa,BestPa,BestLocatn)
	).




	
		
	







%! merge_old_plans_n_comments(+OldCropData:list,-Plan:atom,-Comments:atom) is semidet.


merge_old_plans_n_comments(OldCropData,Plan,Comments) :-
        merge_old_plans_n_comments(OldCropData,[],Plan,[],Comments).



merge_old_plans_n_comments([],P,P,C,C).
merge_old_plans_n_comments([_-(_,_,Crop,Plan,Comment)|T],PlanAcc,Plan,CommentAcc,Comments) :-
        annotate_string(Crop,Plan,MergedPlan),
	annotate_string(Crop,Comment,MergedComment),
        atom_concat(PlanAcc,MergedPlan,NewPlanAcc),
        atom_concat(CommentAcc,MergedComment,NewCommentAcc),
        merge_old_plans_n_comments(T,NewPlanAcc,Plan,NewCommentAcc,Comments).



