% this is demeter/code/choose_lines.pl

% a collection of predicates to choose among alternative 
% lines for planting and print out the data in a form ready for
% packaging in seed packets.
%
% Kazic, 15.5.09



% port to swipl!
%
% Kazic, 16.6.2019


%declarations%



:-      module(choose_lines, [
                choose_lines/2
                ]).





:-      use_module(demeter_tree('code/genetic_utilities')),
        use_module(demeter_tree('code/pedigrees')),
        use_module(demeter_tree('code/demeter_utilities')),    
        use_module(demeter_tree('data/load_data')).



%end%







% ported to swipl, just pass data back to pack_corn/1
%
% Kazic, 21.7.2019

% test!  then hook back to pack_corn


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

%! choose_line(+CrossAlternatives:list,-BestLocatn:atom,-BestMa:atom,
%                        -BestPa:atom,-BestFamily:atom,-CropData:list) is semidet.


choose_line(CrossAlternatives,BestLocatn,BestMa,BestPa,BestFamily,CropData) :-
	choose_line(CrossAlternatives,[],Picked),
	( Picked == [] ->
	        arg(1,CrossAlternatives,(BestMa,BestPa)),
	        check_inventory(BestMa,BestPa,BestLocatn,RNum),
		RNum \== 0

	;
	        arg(1,Picked,(Ma,Pa)),
	        check_inventory(Ma,Pa,Locatn,RNum),
		RNum \== 0,
		( length(Picked,1) ->
		        BestMa = Ma,
		        BestPa = Pa,
		        BestLocatn = Locatn
                ;
	                pick_best(Picked,RNum-(Ma,Pa,Locatn),BestMa,BestPa,BestLocatn)
	        )
        ),
        find_all_plantings_of_line(Ma,Pa,CropData),
	find_family(BestMa,BestPa,BestFamily).










choose_line([],A,A).
choose_line([(Ma,Pa)|T],Acc,Ranked) :-
        check_inventory(Ma,Pa,Sleeve,NumCl),
	( \+ has_fungus(Ma,Pa) ->
                append(Acc,[NumCl-(Ma,Pa,Sleeve)],NewAcc)
	;
                NewAcc = Acc
	),
        choose_line(T,NewAcc,Ranked).






        









pick_best([],_-(BestMa,BestPa,BestLocatn),BestMa,BestPa,BestLocatn).
pick_best([NumCl-(MaNumGtype,PaNumGtype,Locatn)|T],RNum-(Ma,Pa,Locatn),BestMa,BestPa,BestLocatn) :-

        ( is_greater(NumCl,RNum) ->
                is_earlier(MaNumGtype,Ma),
	        find_all_plantings_of_line(MaNumGtype,PaNumGtype,CropData),
                ( CropData < 3 ->
		        true  
                ;
                        format('Warning!  ~w x ~w planted in previous crops ~w, check outcomes.~n',[MaNumGtype,PaNumGtype,CropData])
                ),
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
	annotate_string(Crop,Comments,MergedComment),
        atom_concat(PlanAcc,MergedPlan,NewPlanAcc),
        atom_concat(CommentAcc,MergedComment,NewCommentAcc),
        merge_old_plans_n_comments(T,NewPlanAcc,Plan,NewCommentAcc,Comments).









% stopped here

find_family






%
% really want row_sequence number here, not family, except for inbreds
%
% Kazic, 22.4.2011


% basic pattern of output, but not quite correct
% output should be ordered in inventory order before generating file for packet labels


generate_output(Crop,Chosen) :-
        atomic_list_concat(['../results/',Crop,'_planning/packet_label_list.csv'],File),
        open(File,write,Stream),
        format(Stream,'% this is ~w~n',[File]),
        utc_timestamp_n_date(TimeStamp,UTCDate),
        format(Stream,'% generated ~w (=~w) by choose_lines/2.~n%~n',[UTCDate,TimeStamp]),
        format(Stream,'% This file is ready for processing by ../../label_making/make_seed_packet_labels.perl.~n%~n',[]),
        format(Stream,'% Data are of the form $packet,$family,$ma_num_gtype,$pa_num_gtype,$cl,$ft,$sleeve,$num_packets_needed.~n%~n%~n',[]),
        output_chosen(Stream,1,Chosen),
        close(Stream).





% obsolete:  get cl and ft and row number from facts, use standard inbred packet numbers,
% start rest at 10

% revise inbred family numbers as needed
%
% Kazic, 16.5.09
%
% done for 10r
%
% Kazic, 24.5.10
%
% for 11r, to include B73
%
% Kazic, 22.4.2011

output_chosen(_,_,[]).
output_chosen(Stream,PacketNum,[Locatn-(NumPackets,MaNumGtype,PaNumGtype,Family)|Chosen]) :-
        ( memberchk(Family,[205,305,405,500]) ->
                 Cl = 20,
                 Ft = 20
        ;
                 Cl = 15,
                 Ft = 10
        ),
        format(Stream,'~w,~w,~w,~w,~w,~w,~w,~w~n',[PacketNum,Family,MaNumGtype,PaNumGtype,Cl,Ft,Locatn,NumPackets]),
        NewPacketNum is PacketNum + 1,
        output_chosen(Stream,NewPacketNum,Chosen).

