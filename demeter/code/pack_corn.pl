% this is ../c/maize/demeter/code/pack_corn.pl




% given a crop's packing plan file (in ../c/maize/crops/CROP/planning/packing_plan.pl,
% generated as described in ../c/maize/crops/notes/procedure.org):
%
%         choose among alternative lines for each row;
%         issue a warning if a line has been planted more than 3 times already;
%         assemble the previous plans and comments for that line and append to the current ones;
%         append the current plan/6 facts to ../data/plan.pl; and
%         generate the file for packet labels that will be input to
%                 ../../label_making/make_seed_packet_labels.perl.
%
%
%
%
% Note that after the 19R plan facts are generated, it would be good to modify
% choose_lines:merge_plans_n_comments/3 to prevent indefinite, repetitive
% expansion.
%
% Also, someday modify genetic_utilities:find_all_plantings_of_line/5 to compute the
% outcomes of prior plantings and spit those out, rather than tell the user to go look them
% up.
%
%
%
%
% ported to swipl!  cleaned up choose_lines.pl and added to genetic_utilities.pl
% as part of this
%
% order_packets.pl moved to ../archival/obsolete_code for now, not sure it's needed here.
% the guts of the algorithm to sort packets into inventory order for printing are in
% ../c/maize/data/data_conversion/update_inventory.perl and uses a four-dimensional hash.
%
% Kazic, 26.7.2019



% call is: pack_corn('19R').








%declarations%



:-      module(pack_corn, [
                pack_corn/1
                ]).






:-      use_module(demeter_tree('code/choose_lines'), [
                choose_lines/3
                ]).




:-      use_module(demeter_tree('code/genetic_utilities')),
        use_module(demeter_tree('code/demeter_utilities')),
        use_module(demeter_tree('data/load_data')).



%end%










% note the elements of the output list of choose_lines/2 are keyed by sleeve,
% but are in the same order as the rows in the planning file.


%! pack_corn(+Crop:atom) is semidet.

pack_corn(Crop) :-
        load_crop_planning_data(Crop),

        setof(p(Row,NumPackets,Alternatives,Plntg,Plan,Comments,K,Crop,Cl,Ft),
	      packing_plan(Row,NumPackets,Alternatives,Plntg,Plan,Comments,K,Crop,Cl,Ft),Choices),

	open_planning_warning_file(Crop,LCrop,TimeStamp,UTCDate,WarningStream),
	choose_lines(WarningStream,Choices,Chosen),
	close(WarningStream),
        place_in_inventory_order(Chosen,InventoryOrder),

	generate_output(LCrop,TimeStamp,UTCDate,Chosen,InventoryOrder).














% this is for my idiosyncratic corn filing scheme, adjust the keys for yours
%
%
%
% a simple sort on multiple keys does the job
%
%% [debug] 13 ?- sort([v00010-2017-4-205-(a,b),v00010-2018-4-205-(a,b),v00011-2018-11-305-(a,b),v00009-2017-4-305-(a,b),v00010-2018-11-205-(a,b),v00010-2018-11-305-(a,b)],X),demeter_utilities:write_list(X).
%% v00009-2017-4-305-(a,b) 
%% v00010-2017-4-205-(a,b) 
%% v00010-2018-4-205-(a,b) 
%% v00010-2018-11-205-(a,b) 
%% v00010-2018-11-305-(a,b) 
%% v00011-2018-11-305-(a,b) 
%% X = [v00009-2017-4-305-(a, b), v00010-2017-4-205-(a, b), v00010-2018-4-205-(a, b), v00010-2018-11-205-(a, b), v00010-2018-11-305-(a, b), ... - ... - 11-305-(a, b)].
%
%
% construction of the keys reflects my idiosyncratic filing of my corn; adapt
% to your own
%
% Kazic, 25.7.2019


%! place_in_inventory_order(+Sorted:list,-InventoryOrder:list) is semidet.

place_in_inventory_order(Sorted,InventoryOrder) :-
        construct_keys(Sorted,Keyed),
	sort(Keyed,InventoryOrder).












%! construct_keys(+Sorted:list,-Keyed:list) is semidet.

construct_keys([],[]).
construct_keys([Locatn-(Row,NumPackets,MaNumGtype,PaNumGtype,Family,Plntg,Plan,Comments,K,Crop,Cl,Ft)|Sorted],
	       [Locatn-MaYr-MaFirstMon-SortFamily-MaRow-MaPlant-(Row,NumPackets,MaNumGtype,PaNumGtype,Family,Plntg,Plan,Comments,K,Crop,Cl,Ft)|Keyed]) :-
        disassemble_plantID(MaNumGtype,_,MaYr,_,MaFirstMon,MaFamily,MaRow,MaPlant),
	( mutant_by_family(MaFamily) ->
	        SortFamily = '0000'
        ;
                SortFamily = MaFamily
        ),
        construct_keys(Sorted,Keyed).












% generate two output files:  the flat file for the Perl packet labels script
% and append to the plan.pl file
%
% Kazic, 26.7.2019


%! generate_output(+LCrop:atom,+TimeStamp:atom,+UTCDate:atom,+Chosen:list,+InventoryOrder:list) is semidet.

generate_output(LCrop,TimeStamp,UTCDate,Chosen,InventoryOrder) :-
        output_plan_file(LCrop,Chosen),
        output_packet_label_file(LCrop,TimeStamp,UTCDate,InventoryOrder).








%! output_plan_file(+LCrop:atom,+Chosen:list) is semidet.

output_plan_file(LCrop,Chosen) :-
        morph_into_plans(Chosen,Plans),
        append_to_planning_file(LCrop,Plans).






% since the same mutant line can be planted in multiple rows in the same planting,
% eliminate those duplicates.


morph_into_plans(Chosen,Plans) :-
	morph_into_plans(Chosen,[],Plans).

morph_into_plans([],A,A).
morph_into_plans([_-(_,_,MaNumGtype,PaNumGtype,Family,Plntg,MergedPlan,MergedComments,_,Crop,_,_)|T],
		                                                                             Acc,Plans) :-
	( current_inbred(Crop,_,_,Family,_) ->
                NewAcc = Acc
        ;
                ( memberchk(plan(MaNumGtype,PaNumGtype,Plntg,MergedPlan,MergedComments,Crop),Acc) ->
                        NewAcc = Acc
                ;
	  
		        append(Acc,[plan(MaNumGtype,PaNumGtype,Plntg,MergedPlan,MergedComments,Crop)],NewAcc)
                )
	),
	morph_into_plans(T,NewAcc,Plans).
      














%! output_packet_label_file(+LCrop:atom,+TimeStamp:atom,+UTCDate:atom,+InventoryOrder:list) is semidet.

output_packet_label_file(LCrop,TimeStamp,UTCDate,InventoryOrder) :-
        atomic_list_concat(['../../crops/',LCrop,'/management/seed_packet_labels.csv'],File),
        open(File,write,Stream),
        format(Stream,'# this is ~w~n~n',[File]),
        format(Stream,'# generated ~w (=~w) by pack_corn:pack_corn/1.~n#~n',[UTCDate,TimeStamp]),
        format(Stream,'# This file is ready for processing by ../../label_making/make_seed_packet_labels.perl.~n#~n',[]),
        format(Stream,'# Data are of the form~n%~n#       $packet,$family,$ma_num_gtype,$pa_num_gtype,$cl,$ft,$sleeve,$num_packets_needed,$row_sequence_num,$planting~n#~n# and are in inventory order.~n#~n#~n',[]),

        output_packets(Stream,10,InventoryOrder),
        close(Stream).








% my idiosyncratic packet organization:  change to fit your needs
%
% all mutant packet labels start at 10 to preserve packet numbers
% 0 -- 9 for inbred, elite, and skipped lines!
%
% p00000 = no corn planted for skipped rows
% p00001 = Mo20W
% p00002 = W23
% p00003 = M14
% p00004 = B73
% p00005 = any elite line, this can vary by crop
%
% Kazic, 16.6.2019


output_packets(_,_,[]).
output_packets(Stream,PacketNum,[Locatn-_-_-_-_-_-(RowSequenceNum,NumPackets,MaNumGtype,PaNumGtype,
						                Family,Plntg,_,_,_,Crop,Cl,Ft)|Chosen]) :-

% not a skipped or bulk-planted elite row

	( Locatn \== z00000 ->


% an inbred row with the standard packet number

	        ( Locatn == a00001 ->
                        current_inbred(Crop,_,_,Family,Packet),
                        NewPacketNum = PacketNum
                ;
                        pad(PacketNum,5,PaddedPacket),
                        atom_concat(p,PaddedPacket,Packet),
                        NewPacketNum is PacketNum + 1
                ),

		format(Stream,'~w,~w,~w,~w,~w,~w,~w,~w,~w,~w~n',[Packet,Family,MaNumGtype,PaNumGtype,Cl,Ft,Locatn,NumPackets,RowSequenceNum,Plntg])

	;
                NewPacketNum = PacketNum
        ),
        output_packets(Stream,NewPacketNum,Chosen).
