% this is ../c/maize/demeter/code/order_packets.pl

% given a planting number, a collection of predicates to order packets by rows and insert shams
%
% Kazic, 30.5.09


% this should be ported to swipl and revised to order packets into
% inventory order, using something along the lines of
% ../c/maize/data/data_conversion/update_inventory.perl's four dimensional
% hash.
%
% Kazic, 16.62019




%declarations%



:-      module(order_packets, [
                append_to_planning_file/2,
                generate_plan/1,
                insert_later_packets_in_rows/6,
                load_crop_planning_data/1
                ]).





:-      use_module(demeter_tree('code/genetic_utilities')),
        use_module(demeter_tree('code/demeter_utilities')),
        use_module(demeter_tree('data/load_data')).




%end%




% revised from old.order_packets.pl to use packing_plan/10 facts;
% however, it''s not right!  so do this by hand until I get the algorithm
% correctly coded.  Singleton variables commented out for now.
%
% Kazic, 15.5.2011



% call:  [load_demeter, pack_corn],spy(fill_gap),insert_later_packets_in_rows('11R',98,433,date(28,04,2011),2,'../../maize/crops/11r/planning/').





% now returns the current crop
%
% modified to fit move to phasma
%
% Kazic, 15.5.2015

load_crop_planning_data(Crop) :-
        current_crop(Crop),
        convert_crop(Crop,LCrop),
        atomic_list_concat(['../../crops/',LCrop,'/planning/packing_plan.pl'],PackingPlanFile),
        ensure_loaded(pack_corn:[PackingPlanFile]).





% StartDate is the first date of packing corn for this crop
%
% Kazic, 17.5.2011

insert_later_packets_in_rows(Crop,MinRow,MaxRow,StartDate,ThisPlntg,FileStem) :-
        load_crop_planning_data(Crop),
        get_timestamp(StartDate,time(_,_,_),StartTimeStamp),
        setof(Seq-(Ma,Pa,Plntg),packing_sequence(Crop,Seq,Ma,Pa,Plntg),Seqs),
        write_list(Seqs),
        grab_packets(Seqs,StartTimeStamp,PacketedSeqs),
        write_list(PacketedSeqs),
        setof(Row-Packet,planted_so_far(Crop,MinRow,MaxRow,Row,Packet),PlantedSoFar),
        write_list(PlantedSoFar),
        invert_index(PacketedSeqs,SequencedPackets),
        assign_current_rows(PlantedSoFar,PacketedSeqs,SequencedPackets,ThisPlntg,AssignedThisPlntg),
        make_output_file(FileStem,ThisPlntg,File),
        output_data(File,plntg,AssignedThisPlntg).





packing_sequence(Crop,Seq,Ma,Pa,Plntg) :-
        pack_corn:packing_plan(Seq,_,AltParents,Plntg,_,_,_,Crop,_,_),
        convert_parental_syntax(AltParents,PackableParents),
        ( length(PackableParents,1) ->
                arg(1,PackableParents,PackablePr),
                arg(1,PackablePr,Ma),
                arg(2,PackablePr,Pa)
	;


% right now a meaningless stub

                find_crops_packet(PackableParents,Crop,Ma,Pa)
        ).








grab_packets(Seqs,StartTimeStamp,PacketedSeqs) :-
        grab_packets(Seqs,StartTimeStamp,[],[],PacketedSeqs).




% some packets are visited more than once:  the inbreds and the skips

% still having popcorn issues:  packet was planted but nominally not packed 
% because the parents differ


grab_packets([],_,_,A,A).
grab_packets([Seq-(Ma,Pa,Plntg)|T],StartTimeStamp,VisitedPackets,Acc,PacketedSeqs) :-
        ( ( packed_packet(Packet,Ma,Pa,_,_,Date,Time),
            get_timestamp(Date,Time,PackingTimeStamp),
            PackingTimeStamp >= StartTimeStamp,
            \+ memberchk(Packet,VisitedPackets) ) ->
                ( memberchk(Packet,[p00000,p00001,p00002,p00003,p00004,p99999]) ->
                        NewVisitedPackets = VisitedPackets
		;
                        append(VisitedPackets,[Packet],NewVisitedPackets)
                ),
                append(Acc,[Packet-(Ma,Pa,Seq,Plntg)],NewAcc)
        ;
                format('Warning!  ~w x ~w not packed in planned sequence, but if this message is not duplicated then it was packed later for planting.~n',[Ma,Pa]),
                NewVisitedPackets = VisitedPackets,
                NewAcc = Acc
        ),
        grab_packets(T,StartTimeStamp,NewVisitedPackets,NewAcc,PacketedSeqs).







planted_so_far(Crop,MinRow,MaxRow,Row,PltdPacket) :-
        planted(FullRow,PltdPacket,_,_,_,_,_,Crop),
        once(remove_row_prefix(FullRow,Row)),
        Row >= MinRow,
        Row =< MaxRow.







invert_index([],[]).
invert_index([Packet-(_,_,Seq,Plntg)|PacketedSeqs],[Seq-(Packet,Plntg)|SequencedPackets]) :-
        invert_index(PacketedSeqs,SequencedPackets).




% ok, worked out revised algorithm yesterday in the shed.  Implement.
%
% First find the gaps in the sequence of planted rows in the region of interest,
% recording the planted rows on either side of the gap.  Then for each gap, find
% the sequence numbers for the planted packets, grab the sequence numbers that fall in
% between the planted packets, and insert these and their packets into the unplanted rows. 
% Last, filter out just the rows for this planting; do the filtration last in case I want to 
% look at the whole remaining plantings.
%
% Kazic, 19.5.2011

assign_current_rows(PlantedSoFar,PacketedSeqs,SequencedPackets,ThisPlntg,AssignedThisPlntg) :-
        find_gaps_in_rows(PlantedSoFar,PacketedSeqs,RowGaps),
        insert_packets(RowGaps,SequencedPackets,Inserted),
        make_this_plantings_plan(Inserted,ThisPlntg,AssignedThisPlntg).



find_gaps_in_rows([Row-Packet|T],PacketedSeqs,RowGaps) :-
        find_gaps_in_rows(T,Row-Packet,PacketedSeqs,[],RowGaps).


find_gaps_in_rows([],_,_,A,A).
find_gaps_in_rows([Row-Packet|T],PriorRow-PriorPacket,PacketedSeqs,Acc,RowGaps) :-
        ( Row is PriorRow + 1 ->
                NewAcc = Acc
        ;
                ( ( memberchk(PriorPacket-(_,_,PriorSeq,_),PacketedSeqs),
                    memberchk(Packet-(_,_,Seq,_),PacketedSeqs) ) ->
                        append(Acc,[(PriorRow,PriorPacket,PriorSeq)-(Row,Packet,Seq)],NewAcc)
                ;
                        format('Warning! sequence not found for packets ~w (row ~w) or ~w (row ~w), or both~n',[PriorPacket,PriorRow,Packet,Row]),
                        append(Acc,[(PriorRow,PriorPacket,PriorSeq)-(Row,Packet,Seq)],NewAcc)
                )
        ),
        NextRow = Row,
        NextPacket = Packet,
        find_gaps_in_rows(T,NextRow-NextPacket,PacketedSeqs,NewAcc,RowGaps).






insert_packets(RowGaps,SequencedPackets,Inserted) :-
        insert_packets(RowGaps,SequencedPackets,[],Inserted).




insert_packets([],_,A,A).
insert_packets([(MinRow,_MinPacket,MinSeq)-(MaxRow,_MaxPacket,MaxSeq)|T],SequencedPackets,Acc,Inserted) :-
        RowsToFill is MaxRow - MinRow - 1,
        ( fill_gap(RowsToFill,MinRow,MaxRow,MinSeq,MaxSeq,SequencedPackets,Filled) ->
                append(Acc,Filled,NewAcc)
        ;
                format('Warning! unconsidered case in insert_packets/5 between rows ~w and ~w~n',[MinRow,MaxRow]),
                NewAcc = Acc
        ),
        insert_packets(T,SequencedPackets,NewAcc,Inserted).






fill_gap(RowsToFill,MinRow,MaxRow,MinSeq,MaxSeq,SequencedPackets,Filled) :-
        fill_gap(RowsToFill,MinRow,MaxRow,MinSeq,MaxSeq,SequencedPackets,[],Filled).







% Conditions not right:  sequence numbers can change wildly across block boundaries, e.g./
% popcorn -> NAMs in 11r; kludge for now by setting MinRow and MaxRow, and call by block.  This is more
% flexible; the only alternative I see is to include a datum identifying blocks in the packing_plan
% fact.  I could do this --- right now that information is buried in the comments in that file ---
% but for this year I think I will hold off, and try the current system at least once more next year.
%
% Kazic, 26.5.2011
%
% More seriously, what to do with uninstantiated sequence numbers? 
%
% For now, fix the packing_plan data so that no sequence numbers are uninstantiated.  If there
% is a packing error, include it in the plan, but mark the instructions to skip/hoe out the row.
%
% Kazic, 26.5.2011
%
% definitely not right:  low-density planting has the same packet repeated four times!
%
% Kazic, 26.5.2011



fill_gap(0,_,_,_,_,_,A,A).
fill_gap(RowsToFill,MinRow,MaxRow,MinSeq,MaxSeq,SequencedPackets,Acc,Filled) :-
        ( RowsToFill > 0 ->
                SeqNeeded is MinSeq + 1,
                memberchk(SeqNeeded-(PacketNeeded,PlntgNeeded),SequencedPackets),
                NextRow is MinRow + 1,
                NextRow < MaxRow,
                append(Acc,[NextRow-(SeqNeeded,PacketNeeded,PlntgNeeded)],NewAcc)
        ;
                NewAcc = Acc
        ),
        NewRowsToFill is RowsToFill - 1,
        fill_gap(NewRowsToFill,NextRow,MaxRow,SeqNeeded,MaxSeq,SequencedPackets,NewAcc,Filled).
        



make_this_plantings_plan(Inserted,ThisPlntg,AssignedThisPlntg) :-
        make_this_plantings_plan(Inserted,ThisPlntg,[],AssignedThisPlntg).

make_this_plantings_plan([],_,A,A).
make_this_plantings_plan([Row-(SeqNeeded,PacketNeeded,PlntgNeeded)|T],ThisPlntg,Acc,AssignedThisPlntg) :-
        ( PlntgNeeded == ThisPlntg ->
                append(Acc,[Row-(SeqNeeded,PacketNeeded,PlntgNeeded)],NewAcc)
        ;
                NewAcc = Acc
        ),
        make_this_plantings_plan(T,ThisPlntg,NewAcc,AssignedThisPlntg).




        













make_output_file(FileStem,Plntg,File) :-
        check_slash(FileStem,FileStemS),
        atomic_list_concat([FileStemS,planting,Plntg],File).








%%%%%% obsolete? incorrect, anyway

assign_current_rows([],_,_,_,_,_,A,A).
assign_current_rows([Row-Packet|T],PacketedSeqs,Seqs,PriorRow,PriorSeq,
                                         ThisPlntg,Acc,AssignedRestPlntgs) :-

        ( ( memberchk(Packet-(Ma,Pa,Seq,Plntg),PacketedSeqs),
            memberchk(Seq-(Ma,Pa,Plntg),Seqs) ) ->
                check_planting(Row,Packet,Seq,PacketedSeqs,Ma,Pa,Plntg,ThisPlntg,PriorRow,PriorSeq,NextRow,NextSeq,Acc,NewAcc)
        ;
                ( ( memberchk(Packet-(OtherMa,OtherPa,Seq,Plntg),PacketedSeqs),
                    memberchk(Seq-(OtherMa,OtherPa,Plntg),Seqs) ) ->
                        format('Warning!  ~w x ~w packed into packet ~w, instead of ~w x ~w.~n',[OtherMa,OtherPa,Packet,Ma,Pa]),
                        check_planting(Row,Packet,Seq,PacketedSeqs,OtherMa,OtherPa,Plntg,ThisPlntg,PriorRow,PriorSeq,NextRow,NextSeq,Acc,NewAcc)

                ;

                        ( ( memberchk(Packet-(OtherMa,OtherPa,Seq,Plntg),PacketedSeqs),
                            memberchk(Seq-(DiffMa,DiffPa,Plntg),Seqs),
                            OtherMa \== DiffMa,
                            OtherPa \== DiffPa ) ->
                                format('Warning!  ~w x ~w packed into packet ~w, instead of ~w x ~w.~n',[OtherMa,OtherPa,Packet,DiffMa,DiffPa]),
                                check_planting(Row,Packet,Seq,PacketedSeqs,DiffMa,DiffPa,Plntg,ThisPlntg,PriorRow,PriorSeq,NextRow,NextSeq,Acc,NewAcc)
                        ;


% so, the packet can''t be found among the packed packets, but was planted
 
                                \+ memberchk(Packet-(_,_,_,_),PacketedSeqs),
                                append([Packet-(_,_,_,_)],PacketedSeqs,SupplPacketedSeqs),
                                format('Warning! packet ~w is not in PacketedSeqs.~n',[Packet]),
                                check_planting(Row,Packet,_,SupplPacketedSeqs,_,_,0,ThisPlntg,PriorRow,PriorSeq,NextRow,NextSeq,Acc,NewAcc)
                        )
                )
        ),
        assign_current_rows(T,PacketedSeqs,Seqs,NextRow,NextSeq,ThisPlntg,NewAcc,AssignedRestPlntgs).






% do I need to pass the parents or the packet?
%
% ah, must now handle the different cases of Seqs
%%
% Kazic, 18.5.2011

check_planting(Row,_Packet,Seq,PacketedSeqs,
              _SomeMa,_SomePa,Plntg,ThisPlntg,PriorRow,PriorSeq,NextRow,NextSeq,Acc,NewAcc) :-
        ThisPlntg > Plntg,

% no gap

        ( Row is PriorRow + 1 ->
                NextRow = Row,
                NextSeq = Seq,
                NewAcc = Acc
        ;


% gap to the left

                NextSeq is PriorSeq + 1,
                memberchk(NextSeq-(NextPacket,Plntg),PacketedSeqs),
                NextRow is PriorRow + 1,
                append(Acc,[Plntg-NextRow-(NextSeq,NextPacket)],NewAcc)
        ).






















%%%%%%%%%% older, may be useful

% call: generate_plan('10R').



% Crop is the upper-case version, e.g. 10R, not 10r

generate_plan(Crop) :-
        setof(plan(Ma,Pa,Plntg,Instructns,Notes,Crop),get_plan(Crop,Ma,Pa,Plntg,Instructns,Notes),Plans),
        append_to_planning_file(Crop,Plans).





% be sure to have packing_plan/6 facts for the inbreds, popcorn, and sweet corn!
%
% need member, not memberchk, to back-track over the packing plans!
%
% Kazic, 20.7.2010
%
% now uses packing_plan/10; but actually obsolete since this is now done in pack_corn/1
%
% Kazic, 24.4.2011

get_plan(Crop,Ma,Pa,Plntg,Instructns,Notes) :-			
         planted(_,Packet,_,_,_,_,_,Crop),				
         current_packet(Packet,Ma,Pa),
         packing_plan(_,_,ParentalOptions,Plntg,Instructns,Notes,Crop,_,_,_),	
         convert_parental_syntax(ParentalOptions,ConvertedOptions),	
         member((Ma,Pa),ConvertedOptions). 










append_to_planning_file(Crop,Plans) :-
       open(demeter_tree('data/plan.pl'),append,Stream),
       format(Stream,'~n~n~n~n% ~w~n~n',[Crop]),
       output_header(plano,demeter_tree('data/plan.pl'),Stream),
       write_list_facts(Stream,Plans),
       close(Stream).








