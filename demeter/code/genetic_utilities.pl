% this is ../c/maize/demeter/code/genetic_utilities.pl

    
%declarations%


:-      module(genetic_utilities, [
                add_padding/3,
                all_crops/1,
		all_preps_except_shootbagging/2,
		bag/1,   
                bagged_tassel/3,
		box/1,
                build_numerical_genotype/3,
                build_packet/2,
                build_row/2,
                build_row_members/3,
                calculate_days_since_pollinatn/3,
                check_day_window/3,
		check_day_lower_bound/3,
                check_doubly_assigned_rows/1,
		check_doubly_assigned_rows/2,
                check_doubly_assigned_rows_for_different_parents/2,
                check_ear_status/1,
                check_inventory/3,
                check_mutant_arg/0,
                check_parents/7,
                check_predicate_format/1,
                check_quantity_cl/3,
                closest_contemporaneous_packet/6,
                closest_contemporaneous_packet_w_cl/7,
                closest_contemporaneous_packet_by_crop/6,
                construct_plantIDs/4,
                contemporaneous_packet/6,
                convert_crop/2,
                convert_parental_syntax/2,
                crop_ancestor/3,
                crop_from_date/2,
                crop_timestamp/2,
                crop_window/2,
                crop_inbred_families/2,
                crop_inbred_packets/2,
                cross_parents/3,
                current_packet/3,
                current_packets_for_crop/4,
                date_from_crop/3,
 	        dead_plant/1,
 	        dead_plants/2,
                deconstruct_plantIDs/2,		       
                deconstruct_plantID/5,
                estimate_seed/3,
                extract_row/2,
                filter_by_date/3,
                find_all_mutants/1,
                find_closest_crop_after_packing/3,
                find_current_stand_count/3,
		find_multiply_planted_rows/2,
                find_plan/2,
                founder/9,
                fun_corn/2,
                genotype/2,
                get_crop/2,
                get_family/2,
                get_knum/2,
		get_line/12,
		get_nursery_from_particle/2,
                get_parental_families/2,
                get_year_from_particle/3,
                get_plant/2,
                get_row/2,
                get_rowplants/2,
                get_rowplant/2,
                get_source_daddy/3,
                get_year/2,
                grab_male_rows/2,
                grab_parents_from_packets/2,
                identify_row/3,
                identify_rows/2,
                identify_rows/3,
                identify_rows/4,
                inbred/3,
                inbred/2,
                index_by_ears/4,
                inferred_stand_count/6,
                issue_warning/2,
                make_barcode_elts/3,		       
                make_crop_row_plant/1,
                make_indices/3,
                make_first_index/1,
                make_rest_of_indices/2,
                make_planting_index/1,
                make_row_members/1,
                make_rowplant/3,
                most_recent_crop/1,
                most_recent_datum/2,
                mutant/1,
                mutant_rows/3,
%                nonrow/1,
		next_crop/3,
                nonzero_stand_count/2,
                mutant_by_family/1,
		output_data/3,
                output_header/3,
                packet/1,
                packets_in_row/4,
                pad/3,
                prefixed_row_to_rownum/2,
                plan_includes/3,
                pot/1,
		remove_row_prefix/2,
		remove_padding/2,
		remove_padding_aux/2,
		remove_padding_list/2,
		reverse_chronological_order/2,
                row/1,
		row_from_parents/4,
		rowplant_from_plantid/2,       
                scored_plant/1,
                scored_plants/2,
                scored_rows/2,
                selfed_plants/2,
                selfing_candidate/2,
                silking_ear/4,
		sleeve/1,
                sort_by_crop/3,
                sort_by_male_rows/2,
                split_crops/2,
                tassel_bagged/2,
                timestamped_packet/5,
                track_transplants/3,
                track_transplants_from_parents/4,
                track_transplants_to_row/3,
                unsplit_crop/3,
                unsplit_crops/2,
		wild_type/1,
                winter_nursery/2,
                write_list_facts_w_skips/2,
                write_undecorated_list/2,
                year_from_crop/2

                ]).



:-      use_module(demeter_tree('data/load_data')).

:-      use_module(demeter_tree('code/demeter_utilities')).

    


%end%




% these predicates now exploit swipl sub_atom/2, but I tend to test types to make
% sure we have what we think we have.  Many related calls have been simplified.
%
% Code calling these predicates may fail, as I haven''t yet resolved all related
% calls in all the external code.
%
% There may be some logical redundancy among predicates, though I did prune some.
%
% Kazic, 30.3.2018 -- 15.4.2018


    







%%%%%%%%%%%% index construction predicates --- not yet tested in swipl port %%%%%%%%%%
%
% Kazic, 15.4.2018



% use often to keep the indices current!  ---- go to the split call further down!
%
% Kazic, 29.7.2009
%
% call: [load_demeter],make_indices('../data/planting_index.pl','../data/crop_rowplant.pl','../data/row_members.pl'). 
%
% then edit plant_index.pl per warning message about doubly-planted rows, reload demeter, and run
%
% [load_demeter],abolish(load_data:[crop_rowplant/4,planting_index/4,row_members/3]),make_crop_row_plant('../data/crop_rowplant.pl'),load_data:['../data/planting_index.pl','../data/crop_rowplant.pl'],make_row_members('../data/row_members.pl').


% ok, some day soon I should make an incremental version, as it is starting to take too long
% to recompute everything (and the window for contemporaneous_packet/6 is getting a little silly)
%
% Kazic, 9.12.2010




% have split the original make_indices/3 into two steps until incremental update code written.  So now there
% are two calls:
%
% make_first_index('../data/planting_index.pl'). 
%
% and
%
% make_rest_of_indices('../data/crop_rowplant.pl','../data/row_members.pl').
%
% Kazic, 21.4.2013



make_indices(PltngFile,RPFile,RMFile) :-
        make_first_index(PltngFile),
        make_rest_of_indices(RPFile,RMFile).


make_first_index(PltngFile) :-
        abolish(crop_rowplant/4),
        abolish(planting_index/4),
        abolish(row_members/3),
        make_planting_index(PltngFile),
        [load_data:PltngFile],
        check_doubly_assigned_rows(Doubles),
        write_list(Doubles).
%        check_doubly_assigned_rows_for_different_parents(Doubles,MultiParents),
%        format('Warning! comment out any early plantings of multiply planted rows in planted/8 facts~n~n',[]),
%        write_list(MultiParents).

    

make_rest_of_indices(RPFile,RMFile) :-
        format('Warning!  Ensure first planting of all multiply-planted rows are commented out in planted/8 facts before proceeding!~n~n',[]),
        abolish(crop_rowplant/4),
        abolish(row_members/3),
        make_crop_row_plant(RPFile),
        [load_data:RPFile],
        make_row_members(RMFile).






make_planting_index(File) :-
%        setof(planting_index(Ma,Pa,Crop,Row),F^PNum^Cl^Ft^planting(Crop,Row,F,Ma,Pa,PNum,Cl,Ft),Data),
%
% oops, now need the contemporaneous packet!
%
% Kazic, 25.11.2009
%
        all_crops(Crops),
        gather_planting_data(Crops,Data),
        output_data(File,plin,Data).




all_crops(Crops) :-
        setof(Crop,
              Locatn^Fld^Plntg^PltgDate^HarvestStartDate^HarvestStopDate^crop(Crop,Locatn,Fld,Plntg,PltgDate,HarvestStartDate,HarvestStopDate),
              Crops).




gather_planting_data(Crops,Data) :-
        gather_planting_data(Crops,[],List),
        sort(List,Int),
        pairs_keys_values(Int,_,Data).


gather_planting_data([],A,A).
gather_planting_data([Crop|Crops],Acc,Data) :-
        crop_inbred_packets(Crop,InbredPackets),
        ( setof(Crop-Row-planting_index(Ma,Pa,Crop,Row),for_planting_index(InbredPackets,Ma,Pa,Crop,Row),List) ->
                append(Acc,List,NewAcc)
	;
                NewAcc = Acc
        ),
        gather_planting_data(Crops,NewAcc,Data).






% amended to use closest_contemporaneous_packet/6
%
% Kazic, 9.12.2010
%
% amended to use constructed list of inbred packets for that crop
%
% Kazic, 25.4.2012
%
% amended to track transplants, which for 12R are just Gerry''s babies
% or late acquisitions from Marty in 09R.
%
% Because the 09R transplants were combined so often, in so many different ways,
% and there was that failure in record-keeping when we transplanted, the
% output from the revised predicate gives two possible plantings for 09R rows:
%
% 536, {544, 545}, {546, 547}, {556, 557}, {558, 559}, {560, 561}.
%
% In each case, the second family assigned to that row is correct.  I haven''t sorted
% through all the data by hand, but this is how it looks.  Since the rest of the planting
% indices seem correct and the problem is confined to these screwy rows, I am simply going
% to comment out the first assignment for now by hand.  This makes another case for incremental
% update of the indices!
%
% Kazic, 2.5.2012

for_planting_index(InbredPackets,Ma,Pa,Crop,Row) :-
        planted(PaddedRow,Packet,_Ft,_Planter,Date,Time,_SoilLevel,Crop),
        ( ( row(PaddedRow),
            packet(Packet) ) ->
                ( memberchk(Packet,InbredPackets) ->
                        current_inbred(Crop,_,_,F,Packet),
                        genotype(F,_,Ma,_,Pa,_,_,_,_,_,_)
	        ;
                        closest_contemporaneous_packet(Crop,Packet,Date,Time,Ma,Pa)
		),
                prefixed_row_to_rownum(PaddedRow,Row)
	 ;
                ( ( pot(PaddedRow),
                    packet(Packet) ) ->
                        closest_contemporaneous_packet(Crop,Packet,Date,Time,Ma,Pa),
                        track_transplants_to_row(Crop,PaddedRow,Date,PrefixedRow),
                        prefixed_row_to_rownum(PrefixedRow,Row)
%                        format('row: ~w trans: ~w packet: ~w~n',[Row,PaddedRow,Packet])
		;
                        pot(PaddedRow),
                        pot(Packet),
                        false
                )
        ).









%%%%%%%%%%%%%%% individually tested as part of swipl port %%%%%%%%%%%%%%%%
%
% Kazic, 15.4.2018





% want the information on the packet that was packed closest to the
% planting time, however long ago that was.  So form the bag of all packets
% with the given packetID, and sort those to find the one closest to the
% given planting date.  
%
% Had thought to exclude inbreds but this is already done in the prior clause.  HUH?
%
% Kazic, 9.12. 2010



% given Ma and Pa, plus Crop, PltngDate, PltngTime, will return Packet.
%
% But this takes a long time, as it must sort through all packets . . . 
% so make another version with Ma and Pa
% instantiated.


% Added instantiation tests to this clause to restrict search space.
%
% Kazic, 19.6.2014


% revised all the predicates in this group to simplify timestamping,
% shift the sorting to find_closest_prior_datum/3, and include uniform
% tests of instantiation.
%
% Kazic, 14.4.2018


%! closest_contemporaneous_packet(+Crop:atom,+Packet:atom,+PltngDate:term,
%!              +PltngTime:term,-Ma:atom,-Pa:atom) is nondet.


closest_contemporaneous_packet(Crop,Packet,PltngDate,PltngTime,Ma,Pa) :-
        var(Ma),
        var(Pa),
        nonvar(Packet),
        bagof(PacketTimeStamp-(PMa,PPa),Cl^timestamped_packet(Packet,PMa,PPa,PacketTimeStamp,Cl),Packets),

        get_timestamp(PltngDate,PltngTime,PltngTimeStamp),
        find_closest_prior_datum(Packets,PltngTimeStamp,_-(Ma,Pa)),

        crop_ancestor(Crop,Ma,Pa).






% with Ma and Pa instantiated, to return their most recently packed packet
%
% Kazic, 19.6.2014

%! closest_contemporaneous_packet(+Crop:atom,-Packet:atom,
%!      +PltngDate:term,+PltngTime:term,+Ma:atom,+Pa:atom) is nondet.

closest_contemporaneous_packet(Crop,Packet,PltngDate,PltngTime,Ma,Pa) :-
        nonvar(Ma),
        nonvar(Pa),
        var(Packet),
        get_timestamp(PltngDate,PltngTime,PltngTimeStamp),
        bagof(PacketTimeStamp-(Packet,Ma,Pa),Cl^timestamped_packet(Packet,Ma,Pa,PacketTimeStamp,Cl),Packets),
        find_closest_prior_datum(Packets,PltngTimeStamp,_-(Packet,Ma,Pa)),
        crop_ancestor(Crop,Ma,Pa).




% if a planted/8 fact is missing, closest_contemporaneous_packet/6 will
% fail.  This variant finds the first planting date for the crop and uses that,
% setting a lower bound for the time at which planting begins.
%
% Kazic, 5.5.2018

%! closest_contemporaneous_packet_by_crop(+Crop:atom,+Ma:atom,+Pa:atom,?PltngTimeStamp:int,-Packet:atom,-PackingTimeStamp:atom) is det.

closest_contemporaneous_packet_by_crop(Crop,Ma,Pa,FirstPltngTimeStamp,Packet,PackingTimeStamp) :-
        nonvar(Ma),
        nonvar(Pa),
        var(Packet),
        bagof(PacketTimeStamp-(Packet,Ma,Pa),Cl^timestamped_packet(Packet,Ma,Pa,PacketTimeStamp,Cl),Packets),
        ( var(FirstPltngTimeStamp) ->
                crop(Crop,_,_,1,PltngDate,_,_),
                get_timestamp(PltngDate,time(5,0,0),FirstPltngTimeStamp)
        ;
                true
        ),
        find_closest_prior_datum(Packets,FirstPltngTimeStamp,PackingTimeStamp-(Packet,Ma,Pa)),
        crop_ancestor(Crop,Ma,Pa).







%! closest_contemporaneous_packet_w_cl(+Crop:atom,+Packet:atom,
%!      +PltngDate:term,+PltngTime:term,-Cl:int,-Ma:atom,-Pa:atom) is nondet.

closest_contemporaneous_packet_w_cl(Crop,Packet,PltngDate,PltngTime,Cl,Ma,Pa) :-
        var(Ma),
        var(Pa),
        nonvar(Packet),
        get_timestamp(PltngDate,PltngTime,PltngTimeStamp),
        bagof(PacketTimeStamp-(PMa,PPa,PCl),timestamped_packet(Packet,PMa,PPa,PacketTimeStamp,PCl),Packets),
        find_closest_prior_datum(Packets,PltngTimeStamp,_-(Ma,Pa,Cl)),
        crop_ancestor(Crop,Ma,Pa).







%! closest_contemporaneous_packet_w_cl(+Crop:atom,-Packet:atom,
%!    +PltngDate:term,+PltngTime:term,-Cl:int,+Ma:atom,+Pa:atom) is nondet.

closest_contemporaneous_packet_w_cl(Crop,Packet,PltngDate,PltngTime,NumCl,Ma,Pa) :-
        nonvar(Ma),
        nonvar(Pa),
        var(Packet),
        bagof(PacketTimeStamp-(PPacket,PCl),timestamped_packet(PPacket,Ma,Pa,PacketTimeStamp,PCl),Packets),

        get_timestamp(PltngDate,PltngTime,PltngTimeStamp),
        find_closest_prior_datum(Packets,PltngTimeStamp,_-(Packet,NumCl)),
        crop_ancestor(Crop,Ma,Pa).











% just timestamp the packet here and decrease the size of the
% returned data
%
% Kazic, 14.4.2018

%! timestamped_packet(?Packet:atom,?Ma:atom,?Pa:atom,
%!                     -PacketTimeStamp:float,-Cl:int) is nondet.

timestamped_packet(Packet,Ma,Pa,PacketTimeStamp,Cl) :-
        packed_packet(Packet,Ma,Pa,Cl,_,PackingDate,PackingTime),
        get_timestamp(PackingDate,PackingTime,PacketTimeStamp).









% want the datum which timestamp is that just BEFORE the TimeStamp
% 
% Kazic, 9.12.2010
%
% modified to include sorting here, rather than just before the calls
% to this predicate --- more modular.
%
% Kazic, 14.4.2018

%! find_closest_prior_datum(+TimestampedList:list,
%!                           +TimeStamp:float,-ClosestPriorTimeStamp-ClosestDatum:term)
%! is nondet.

find_closest_prior_datum(TimestampedList,
                           TimeStamp,ClosestPriorTimeStamp-ClosestDatum) :-
        sort(TimestampedList,Sorted),
        once(arg(1,Sorted,FirstDatum)),
        find_closest_prior_datum(Sorted,
            FirstDatum,TimeStamp,ClosestPriorTimeStamp-ClosestDatum).




find_closest_prior_datum([],FT-FD,_,FT-FD).
find_closest_prior_datum([TimeStamp-Datum|TimestampedData],
                          CurrentTimeStamp-CurrentDatum,BoundaryTimeStamp,
                                           ClosestPriorTimeStamp-ClosestDatum) :-
        ( ( TimeStamp >=CurrentTimeStamp,
            TimeStamp < BoundaryTimeStamp ) ->
                 find_closest_prior_datum(TimestampedData,TimeStamp-Datum,
                              BoundaryTimeStamp,ClosestPriorTimeStamp-ClosestDatum)
	;
                 TimeStamp >= BoundaryTimeStamp,
                 find_closest_prior_datum([],CurrentTimeStamp-CurrentDatum,
                              BoundaryTimeStamp,ClosestPriorTimeStamp-ClosestDatum)
        ).









index_by_ears(Ma,Crop,Family,RowPlant) :-
        get_crop(Ma,Crop),
        get_family(Ma,Family),
        get_rowplant(Ma,RowPlant).




% a sanity check to make sure the proposed Ma and Pa were crossed
% before a given crop.
%
% relies on lexigraphic order, which is ok for now.  Winter crops will need something
% more sophisticated; for now I have just hard-wired the one exception
%
% Kazic, 9.12.2010


%! crop_ancestor(+Crop:atom,+Ma:atom,+Pa:atom) is nondet.

crop_ancestor(Crop,Ma,Pa) :-
        get_crop(Ma,MaCrop),
        get_crop(Pa,PaCrop),
        MaCrop == PaCrop,
        ( MaCrop @=< Crop ->
                true
	;
                ( winter_nursery(Crop,MaCrop) ->
                        true

	        ;
                        format('Warning! genetic_utilities:crop_ancestor/3 fails for ~w, ~w x ~w~n',[Crop,Ma,Pa]),
                        false
                )
        ).









% since lexigraphic ordering fails for my winter and greenhouse nurseries,
% handle the exceptions here.

%! winter_nursery(+CurrentCrop:atom,+MaCrop:atom) is semidet.

winter_nursery(CurrentCrop,MaCrop) :-
        get_crop_components(CurrentCrop,CurrentYr,CurrentNursery),
        get_crop_components(MaCrop,MaYr,MaNursery),
        ( CurrentYr > MaYr ->
                true
        ;


% allow for winter and greenhouse nurseries; assume temporal order of cycle is R, G, N, G:
% the difference between the G/N and N/G steps is that the year changes at N/G but not the
% former
%
% Kazic, 15.12.2011

                ( CurrentYr == MaYr ->
                        ( CurrentNursery == 'N' ->
                                ( MaNursery == 'R'
                                ;
                                  MaNursery == 'G' )
                        ;
                                ( CurrentNursery == 'G' ->
                                        ( MaNursery == 'R' ->
                                                true
                                        ;
                                                format('Warning! unconsidered case in genetic_utilities:winter_nursery/2 for ~w and ~w~n',[CurrentCrop,MaCrop]),
                                                false
                                        )
                                )
                        )
                )
        ).





%! get_crop_components(+Crop:atom,-Year:int,-Nursery:atom) is semidet.

get_crop_components(Crop,Year,Nursery) :-
        sub_atom(Crop,0,2,_,YearAtom),
        atom_number(YearAtom,Year),
        sub_atom(Crop,2,1,_,Nursery).








% assume a 90 day window
%
% lengthen to 400 days because the inbreds for 09r were packed 15.5.2008;
% oops, too many problems, so switched to closest_contemporaneous_packet/6
% and made the size of the window variable
%
% Kazic, 9.12.2010



contemporaneous_packet(Window,Packet,Date,Time,Ma,Pa) :-
        packed_packet(Packet,Ma,Pa,_,_,PDate,PTime),
        contemporaneous_packet(Window,Date,Time,PDate,PTime).



contemporaneous_packet(Window,Date,Time,PDate,PTime) :-
        check_day_window(Window,(PDate,PTime),(Date,Time)).








% rewrote to add numerical genotypes from planting, cross, plant_anatomy, and
% tassel facts.   This should cover plants from nearly every planted row. This changed the file size from:
%
% 132279 Feb 21 09:24 old.crop_rowplant.pl  to
%
% 132568 May  5 18:35 crop_rowplant.pl --- so stuff was missing!
%
% Kazic, 5.5.09
%
% rewrote further to use the planted/8 facts and dispense with the setof over get_numerical_genotype/1.
% Stand count data are ``manufactured'' for the crops before 09R, which had no stand counts per se.
%
% Kazic, 1.12.09
%
% ummm, the problem is that in 06R some mutant rows had > 15 plants, such as row 77!  so re-inserted
% actual gathering of numerical genotypes and then included these in the ord_union.
%
% Kazic, 21.5.2010


% fix to remove screwballs (../data/test)
%
% Kazic, 9.12.2010

% If nothing ever happens in a row because the stand counts are 0 or uninstantiated, or
% the row was not planted (planted/8 has a row length of 0) --- 
% then there will be no row_members computed for a row.  A warning message will be issued
% by pedigrees:get_row_members/3.
%
% Kazic, 2.5.2012


make_crop_row_plant(File) :-
        setof(NumericalGenotype,get_numerical_genotype(NumericalGenotype),NGs),
        setof(Row-Crop,early_row(Crop,Row),OldRows),
        make_num_gtypes(OldRows,OldNGs),
        manufacture_num_gtypes_from_stand_counts(MoreNGs),
        ord_union([NGs,MoreNGs,OldNGs],NGsWithDupes),
        list_to_ord_set(NGsWithDupes,AllNGs),
        build_crop_rowplant_facts(AllNGs,Data),
        output_data(File,crp,Data).





% rows before we had stand counts!
%
% Kazic, 1.12.2009

early_row(Crop,Row) :-
        planted(Row,_,_,_,_,_,_,Crop),
        Crop @< '09R'.




build_crop_rowplant_facts(AllNGs,Data) :-
        build_crop_rowplant_facts(AllNGs,[],Data).

build_crop_rowplant_facts([],A,A).
build_crop_rowplant_facts([PlantID|T],Acc,Data) :-
         get_rowplant(PlantID,RowPlant),
         ( ( RowPlant \== '000000',
             get_row(PlantID,Row),
             get_crop(PlantID,Crop),
             get_plant(PlantID,Plant) ) ->
                 append(Acc,[crop_rowplant(PlantID,Crop,Row,Plant)],NewAcc)
         ;
                 ( RowPlant == '000000' ->
                         true
                 ;


% for example, when PlantIDs are incomplete because I haven''t figured out the popcorn
% families in 11R ;-), e.g.,
% 
% crop_rowplant/4 fact not built for 11R:0054414
% crop_rowplant/4 fact not built for 11R:P0001105
%
% Kazic, 28.4.2012

                         format('crop_rowplant/4 fact not built for ~w~n',[PlantID])
                 ),
                 NewAcc = Acc
         ),
         build_crop_rowplant_facts(T,NewAcc,Data).


 










% now need to know which numerical genotypes correspond to that crop and row; these
% are row_members/3.
%
% Warning!  this will be incomplete if a crop_rowplant/4 fact is not found!
%
% Kazic, 5.5.09

make_row_members(File) :-
        setof(Crop-Row,R^P^crop_rowplant(R,Crop,Row,P),CropRows),
        find_row_members(CropRows,Data),
        output_data(File,rowm,Data).



% PlantID (M), Crop, Row, and NumPlants (P) are all atoms, so they must
% be converted to numbers to count.  However, some crop_rowplant/4 facts
% (for 07R popcorn and sweet corn) have letters for rows and plants.  These should fail
% any rational enumeration.  So shifted this to an accumulator pattern.
%
% Kazic, 28.4.2012


find_row_members(CropRows,Data) :-
        find_row_members(CropRows,[],Data).




find_row_members([],A,A).
find_row_members([Crop-PRow|CropRows],Acc,Data) :- 
        setof(M,P^crop_rowplant(M,Crop,PRow,P),Members),
        ( extract_row(PRow,Row) ->
                append(Acc,[row_members(Crop,Row,Members)],NewAcc)
	;
                NewAcc = Acc
        ),
        find_row_members(CropRows,NewAcc,Data).










% be able to use the Ma x Pa data directly from the pedigrees without fixing them manually
% in emacs!
%
% Kazic, 27.5.2010
%
% rewrite to handle both 'Ma,Pa' and 'Ma x Pa' in the same predicate
%
% Kazic, 1.4.2018


convert_parental_syntax(CrossAlternatives,Alternatives) :-
        convert_parental_syntax(CrossAlternatives,[],Alternatives).



convert_parental_syntax([],A,A).
convert_parental_syntax([Parents|CrossAlternatives],Acc,Alternatives) :-
        sub_atom(Parents,0,15,_,MaNumGtype),
        ( sub_atom(Parents,_,_,_,',') ->
                sub_atom(Parents,16,15,_,PaNumGtype)

	;
                ( sub_atom(Parents,_,_,_,' x ') ->
                        sub_atom(Parents,18,15,_,PaNumGtype)
                ;
                        format('Warning! unconsidered case in convert_parental_syntax/3!~n',[])
                )
        ),
        append(Acc,[(MaNumGtype,PaNumGtype)],NewAcc),
        convert_parental_syntax(CrossAlternatives,NewAcc,Alternatives).






% the inverse of convert_parental_syntax/2

%! cross_parents(+Ma:atom,+Pa:atom,-Crossed:atom) is det.

cross_parents(Ma,Pa,Crossed) :-
        atomic_list_concat([Ma,' x ',Pa],Crossed).







% From 09R onward we have row_status facts, thanks to our barcoded row stakes, so stand
% counts are much easier.  Hence all PlantIDs are manufactured for those.
%
% Kazic, 29.7.2009

manufacture_num_gtypes_from_stand_counts(MoreNGs) :-
        setof(Row-Crop,physical_row(Row,Crop),AllRows),
        make_num_gtypes(AllRows,MoreNGs).




physical_row(Row,Crop) :-
        row_status(Row,_,_,_,_,_,Crop),
        sub_atom(Row,0,1,_,r).












make_num_gtypes(AllRows,MoreNGs) :-
        make_num_gtypes(AllRows,[],MoreNGs).








% identify_row/3 could fail here for seed that was packed outside the
% contemporaneous_packet window.  Use of closest_contemporaneous_packet/6
% has fixed that problem!
%
% Kazic, 9.12.2010
%
%
% Stand counts aren''t always provided for winter nurseries, and we didn''t
% have stand counts for the earlier crops.  So guess the stand count as
% best one can.
%
% Kazic, 25.4.2012


make_num_gtypes([],A,A).
make_num_gtypes([Row-Crop|T],Acc,NGs) :-
        ( identify_row(Crop,Row,_-(_,Family,Ma,Pa,_MaGma,_MaGpa,_PaGma,_PaMutant,_,_)) ->
                ( find_current_stand_count(Row,Crop,NumPlants) ->
                       true
                ;
                       inferred_stand_count(Row,Crop,Family,Ma,Pa,NumPlants)
                ),
 
                ( make_num_gtypes(Crop,Row,NumPlants,Family,RowNumGtypes) ->
                        true
                ;
                        format('make_num_gtypes/5 fails for row ~w of ~w plants in family ~w~n',[Row,NumPlants,Family])
                ),
                append(Acc,RowNumGtypes,NewAcc)

        ;
                crop_inbred_families(Crop,Families),
                ( memberchk(Family,Families) -> 
                        true
                ;
                        format('Warning! identify_row/3 fails for row ~w of crop ~w in family ~w when called by make_num_gtypes/3.~n',[Row,Crop,Family])
                ),

                format('Warning! crop_inbred_families/3 fails to find a family for row ~w of crop ~w in family ~w when called by make_num_gtypes/3.~n',[Row,Crop,Family]), 
                NewAcc = Acc

        ),
        make_num_gtypes(T,NewAcc,NGs).
	        





% inferred_stand_count(r00444,'07R',_,'06N201:S0004409','06N1605:0020105',X).
% inferred_stand_count(r00009,'06R',9,'06R0009:0000000','06R0009:0000000',X).
%
% correct
%
% Kazic, 27.4.2012
%
%
% closest_contemporaneous_packet_w_cl/7 instantiates missing data,
% no need to do that here
%
% Kazic, 5.4.2018





inferred_stand_count(Row,Crop,Family,Ma,Pa,NumPlants) :-
%        ( first_extra_tag(Row,FirstExtraTag,Crop,_,_,_,_),
%          NumPlants is FirstExtraTag - 1
%        ;

        ( planted(Row,Packet,_,_,Date,Time,_,Crop) ->
          closest_contemporaneous_packet_w_cl(Crop,Packet,Date,Time,NumPlants,Ma,Pa)
        ;


% just assume the summer crop canonical plantings for the early crops or missing data
%
% Kazic, 1.12.09
%
% well, 06N had 13 cl/row for all rows
%
% Kazic, 9.12.2010

          ( Crop == '06N' ->
                  NumPlants = 13
          ;
                  crop_inbred_families(Crop,Families),
                  ( memberchk(Family,Families) ->
                          NumPlants = 20
                  ;
                          NumPlants = 15
                  )
          )


% otherwise, assume no plants!  But we should never get here; previous clause will always
% succeed

        ;
          NumPlants = 0
        ).       








% modified to accomodate the atomic inbred rows of 06r
%
% Kazic, 1.12.09

% added a clause for the case where there are no plants, rather than leaving
% that condition in make_num_gtypes/3.
%
% A failure here in row extraction means the numerical genotype fact shouldn''t be made, for 
% example for sweet corn (see make_num_gtypes/3).
%
% Kazic, 27.4.2012

make_num_gtypes(_,_,0,_,[]).
make_num_gtypes(Crop,Row,NumPlants,Family,RowNumGtypes) :-
        ( extract_row(Row,RowNum) ->
                true
        ;
                format('Warning! unconsidered case in extract_row/2 for crop ~w row ~w called from make_num_types/9~n',[Crop,Row])
        ),
        construct_plant_prefix(Crop,RowNum,Family,PlantIDPrefix),
        make_num_gtypes_aux(PlantIDPrefix,NumPlants,RowNumGtypes).





make_num_gtypes_aux(Prefix,NumPlants,RowNumGtypes) :-
        Max is NumPlants + 1,
        make_num_gtypes_aux(Prefix,1,Max,RowNumGtypes).


make_num_gtypes_aux(_,N,N,[]).
make_num_gtypes_aux(Prefix,CurrentNum,Max,[GType|T]) :-
        pad(CurrentNum,2,PlantNum),
        atomic_list_concat([Prefix,PlantNum],GType),
        Next is CurrentNum + 1,
        make_num_gtypes_aux(Prefix,Next,Max,T).
        









% if nothing happens at all in that row for a given crop, then this will
% miss it!  So 07R row 937 had no action; setof passes over it; and then a warning
% is output later in pedigree construction.
%
% Need a better data integrity check:  manufacture all numerical genotypes?  But this 
% is not possible until all lingering family errors discovered.
%
% Kazic, 5.5.09

get_numerical_genotype(NumericalGenotype) :-
        ( genotype(_,_,NumericalGenotype,_,_,_,_,_,_,_,_)
	;
          genotype(_,_,_,_,NumericalGenotype,_,_,_,_,_,_)
	;
          mutant(NumericalGenotype,_,_,_,_,_,_,_)
	;
          inventory(NumericalGenotype,_,_,_,_,_,_)
	;
          inventory(_,NumericalGenotype,_,_,_,_,_)
        ;
          plant_anatomy(NumericalGenotype,_,_,_,_,_,_,_)
        ;
          cross(NumericalGenotype,_,_,_,_,_,_,_)
        ;
          cross(_,NumericalGenotype,_,_,_,_,_,_)
        ;
          tassel(NumericalGenotype,_,_,_,_)
        ;
          ear(NumericalGenotype,_,_,_,_)
	;
          cross_prep(NumericalGenotype,_,_,_,_)
        ;
          image(NumericalGenotype,_,_,_,_,_,_,_,_)
        ).








% inappropriately named; originally used for generating crop_rowplants
%
% Kazic, 30.7.2009

deconstruct_plantIDs(NGs,Data) :-
        deconstruct_plantIDs(NGs,[],Data).


deconstruct_plantIDs([],A,A).
deconstruct_plantIDs([G|Gs],Acc,Data) :-
        ( deconstruct_plantID(G,Crop,_,Row,Plant) ->
                append(Acc,[crop_rowplant(G,Crop,Row,Plant)],NewAcc)
	;
                format('Warning!  deconstruct_plantID/5 failed for ~q!~n',[G]),
                NewAcc = Acc
        ),
        deconstruct_plantIDs(Gs,NewAcc,Data).







% fail if funny numerical genotypes from others, since I have no idea
% what their numerical genotypes mean
%
% not sure the once/1 is needed, but there is a branch point, so there it is
%
% Kazic, 1.4.2018



deconstruct_plantID(PlantID,Crop,Family,Row,Plant) :-
        once(deconstruct_plantID_aux(PlantID,Crop,Family,Row,Plant)).



deconstruct_plantID_aux(PlantID,Crop,Family,Row,Plant) :-
        atom_length(PlantID,15),
        get_crop(PlantID,Crop),
        get_family(PlantID,Family),
        get_row(PlantID,PaddedRow),
        get_plant(PlantID,PaddedPlant),
        ( ( PaddedRow \== '00000',
            PaddedRow \== 'xxxxx',
            PaddedRow \== 'yyyyy', 
            \+ sub_atom(PaddedRow,_,_,_,'I') ) ->

                atom_number(PaddedRow,Row),
                atom_number(PaddedPlant,Plant)
        ;
                Row = PaddedRow,
                Plant = PaddedPlant
        ).








get_prefix(PlantID,Prefix) :-
        sub_atom(PlantID,ColPos,1,_,':'),
        Next is ColPos + 1,
        sub_atom(PlantID,Next,1,_,NextAtom),
        upper_case_letters(Letters),
        ( memberchk(NextAtom,Letters) ->
                Prefix = NextAtom
        ;
                Prefix = ''
        ).











% test for and remove the leading 'r', returning an integer

remove_row_prefix(RRow,Row) :-
        ( integer(RRow) ->
                Row = RRow
        ;
                ( sub_atom(RRow,0,1,_,'r') ->
                        sub_atom(RRow,1,5,_,RowAtom),
                        atom_number(RowAtom,Row)
                ;
                        atom_number(RRow,Row)
                )
        ).










remove_padding_list([],[]).
remove_padding_list([Padded|T],[Unpadded|T2]) :-
        remove_padding(Padded,Unpadded),
        remove_padding_list(T,T2).









% revised for swipl
%
% Kazic, 3.4.2018

% remove_padding(+AtomOrString,-UnpaddedInteger).

remove_padding(AtomOrString,UnpaddedNumber) :-
        ( string(AtomOrString) ->
                atom_string(Atom,AtomOrString),
                remove_padding_aux(Atom,UnpaddedNumber)
        ;
                atom(AtomOrString),
                remove_padding_aux(AtomOrString,UnpaddedNumber)
        ;
                integer(AtomOrString),
                UnpaddedNumber = AtomOrString
        ).






% preserve the 'I' in the 06r row numbers, as this is included
% in the numerical genotypes and removing it will produce
% ambiguity.  In this case, the Number returned is just an
% alphanumeric atom.
%
% Kazic, 2.5.2018

%! remove_padding_aux(+Atom:atom,+Number:atom) is semidet.

remove_padding_aux(Atom,Number) :-
        sub_atom(Atom,0,1,5,First),
	lower_case_letters(Letters),
        ( memberchk(First,Letters) ->
	        sub_atom(Atom,1,5,_,Rest)
	;
        	Rest = Atom
        ),
        ( atom_number(Rest,Number) ->
	        true
	;
                sub_atom(Atom,FrontLen,1,_,'I'),
		sub_atom(Atom,0,FrontLen,AfterLen,_),
                sub_atom(Atom,FrontLen,AfterLen,0,Number)
        ).











%%% get pieces from the plantID

get_crop(NumericalGenotype,Crop) :-
        ( sub_atom(NumericalGenotype,_,1,_,':') ->
                sub_atom(NumericalGenotype,0,3,_,Crop)
	;
                Crop = ''
        ).







% Year returned as atom

get_year(NumericalGenotype,Year) :-
        ( sub_atom(NumericalGenotype,_,1,_,':') ->
                sub_atom(NumericalGenotype,0,2,_,Year)
	;
                Year = ''
        ).









% this also works for just the 13-character prefix (the plantID without the plant number)!

get_family(PlantID,Family) :-
        ( nonvar(PlantID) ->
                sub_atom(PlantID,ColPos,1,_,':'),
                FamilyLen is ColPos - 3,
                ( sub_atom(PlantID,3,FamilyLen,_,FamilyAtom) ->
                        atom_number(FamilyAtom,Family)
                ;

                        format('Warning! family not extracted from ~w in get_family/2~n',[PlantID])
                )
        ;
                var(PlantID),
                format('Warning! PlantID uninstantiated in get_family/2~n',[])
        ).









get_row(PlantID,Row) :-
        sub_atom(PlantID,8,7,0,RowPlant),
        sub_atom(RowPlant,_,5,2,Row).



get_plant(PlantID,Plant) :-
       sub_atom(PlantID,13,2,_,Plant).









% get K number by unpadding rowplant of FoundingMale --- only works for a founding male!
%
get_knum(PlantID,KNum) :-
        get_rowplant(PlantID,RowPlant),
        remove_padding(RowPlant,KNum).






% deconstruct the crop particle

get_nursery_from_particle(Crop,Nursery) :-
        sub_atom(Crop,2,1,_,Nursery).

get_year_from_particle(Crop,YearSuffix,Year) :-
        sub_atom(Crop,0,2,_,YearSuffix),
        atom_concat('20',YearSuffix,Year).






% a founder is a line donated by someone:  Gerry, USDA Peoria, MGCSC, Guri, Damon, Karen, etc.  
%
% Family numbers for founders are manually assigned and are always less than 1000.  Numbers 
% between 200 and 499 are reserved for my inbred lines:  2** is Mo20W, 3** is W23, and 4** is M14;
% and 5** is B73;
% *[00-49] are selfed, *[51-99] are sibbed.  These are usually made in sufficient quantity to last
% several years, so I believe I will not run out of integers.
%
% B73 now occupies the 500s, and inbred lines with the same names as mine, but from different
% sources, are now numbered from 99 backwards.  So with the Weil B73 David Braun had in 12r, this is 
% 599.
%
% Numerical genotypes of the founders are quite irregular, since they originate in other labs,
% and so will fail genetic_utilites:deconstruct_plantID_aux/5.  If a numerical genotype was not
% supplied I construct one:  CropOfFirstPlanting * 0 * AccessionedFamilyNumber * : * 0000000.
% Notice that the family number in the numerical genotype is padded so that it is four characters,
% but in the genotype/11 fact it is not.
% 
% Kazic, 21.2.2009


% amended family number boundaries to exclude sweet corn, popcorn, Jason''s corn, and NAM founders for now
% special case for the Barkan corn
%
% Kazic, 1.5.2012

% now that the pedigrees are nicely sorted into subdirectories, there''s no need to exclude
% the NAM founders.  That now covers the Barkan/Koch corn as well.  Still want to exclude Jason 
% Green''s corn, though.  This does get the crop improvement lines of 12R (families 631 -- 641).
%
% Kazic, 16.10.2012
%
% gets all of them correctly; note there is no longer any family 630.
%
% Kazic, 23.10.2012

founder(F,MN,PN,MG1,MG2,PG1,PG2,Gs,K) :-
        genotype(F,_,MN,_,PN,MG1,MG2,PG1,PG2,Gs,K),

% exclude Gerry''s 11n lines

        not_gerrys_lines(F),


% the original mutants from Gerry and others

        ( F < 200
        ;


% later mutants, for example, NAM lines, Barkan''s, Birchler''s
% Braun''s, etc.

%          F > 627,
          F > 599,
          F < 623
        ;


% 623 -- 627 are the Johal lines planted for Jason Green
%
% crop improvement founders are 631 -- 664, except 642 -- 654 (Braun mutants).
% 
% popcorn and sweet corn run from 892 -- 999.

          F > 627,
          F < 892
        ).





        




inbred(NumGtype,Family,Inbred) :-
        ( nonvar(NumGtype) ->
                ( genotype(Family,_,NumGtype,_,_,_,_,_,_,_,_) ->
                        true
                ;
                        get_family(NumGtype,Family)
                )
        ;
                nonvar(Family)
        ),
        inbred(Family,Inbred).





inbred(Family,InbredPrefix) :-
        ( ( Family < 300,
            Family >= 200 ) ->
                InbredPrefix = 'S'
        ;
                ( ( Family < 400, 
                    Family >= 300 ) ->
                        InbredPrefix = 'W'
                ;
                        ( ( Family < 500,
                            Family >= 400 ) ->
                                InbredPrefix = 'M'
                        ;
                                ( ( Family < 600,
                                    Family >= 500 ) ->
                                        InbredPrefix = 'B'
                                ;
                                        false
                                )
                        )
                )
        ).










% popcorn P
% sweet E
% elite L

%! fun_corn(+Family:int,-FunCorn:atom) is det.

fun_corn(Family,FunCornPrefix) :-
        ( ( Family < 1000,
            Family >= 900, 
            \+ Family =:= 990,
            \+ Family =:= 901 ) ->
                FunCornPrefix = 'P'
        ;
                ( ( Family < 900, 
                    Family >= 892 
                  ;
                    Family =:= 990
                  ;
                    Family =:= 901 ) ->
                        FunCornPrefix = 'E'
                ;

                        ( ( Family =< 891,
                            Family >= 890 ) ->
                                FunCornPrefix = 'L'
                        ;
                                false
                        )
                )
        ).


















genotype(NumGType,GType) :-
        crop_rowplant(NumGType,Crop,Row,_),
        planting(Crop,Row,Family,MN,_,_,_,_),
        ( inbred(Family,GType) ->
                true
        ;
                ( genotype(_,_,NumGType,_,_,MaGMa,MaGPa,PaGMa,PaGPa,Genes,Quasi) ->
                        true
                ;
                        genotype(_,_,MN,_,_,MaGMa,MaGPa,PaGMa,PaGPa,Genes,Quasi)
                ),
                GType = (MaGMa,MaGPa,PaGMa,PaGPa,Genes,Quasi)        
        ).










% converted to swipl, exploiting sub_atom and sticking
% in a simple lookup table for the ASCII conversion.
%
% Kazic, 30.3.2018

convert_crop(UpperCaseCrop,LowerCaseCrop) :-
        ( ( nonvar(UpperCaseCrop),
            var(LowerCaseCrop) ) ->
                sub_atom(UpperCaseCrop,0,2,_,Year),
                sub_atom(UpperCaseCrop,2,1,_,Season),
                letter(LSeason,Season),
                atomic_list_concat([Year,LSeason],LowerCaseCrop)
        ;
                var(UpperCaseCrop),
                nonvar(LowerCaseCrop),
                sub_atom(LowerCaseCrop,0,2,_,Year),
                sub_atom(LowerCaseCrop,2,1,_,Season),
                letter(Season,USeason),
                atomic_list_concat([Year,USeason],UpperCaseCrop)
        ).








split_crops([],[]).
split_crops([Crop-Tuple|Crops],[Year-Season-Tuple|YrSeasns]) :-
        get_crop_components(Crop,Year,Season),
        split_crops(Crops,YrSeasns).










unsplit_crops([],[]).
unsplit_crops([Year-Season-Tuple|YrSeasns],[Crop-Tuple|Crops]) :-
        unsplit_crop(Year,Season,Crop),
        unsplit_crops(YrSeasns,Crops).




unsplit_crop(Year,Season,Crop) :-
        ( memberchk(Season,['G','N','R']) ->
                atomic_list_concat([Year,Season],Crop)
        ;
                atomic_list_concat([Season,Year],Crop)
        ).






% for clean_data.pl

sort_by_male_rows(Lines,MaleSorted) :-
        once(grab_male_rows(Lines,Rows)),
        keysort(Rows,Sorted),
        pairs_keys_values(Sorted,_,MaleSorted).





% pull out row numbers for the male parent

grab_male_rows([],[]).
grab_male_rows([(H,MF,MN,PF,PN,MG1,MG2,PG1,PG2,K)|T],[MR-(H,MF,MN,PF,PN,MG1,MG2,PG1,PG2,K)|T2]) :-
        deconstruct_plantID(PN,_,_,MR,_),
        grab_male_rows(T,T2).






get_line(G,Crop,H,MF,MN,PF,PN,MG1,MG2,PG1,PG2,K) :-
        genotype(H,MF,MN,PF,PN,MG1,MG2,PG1,PG2,Gs,K),
        memberchk(G,Gs),
        once(get_crop(MN,Crop)).



















sort_by_crop(Type,GL,Sorted) :-
        keysort(GL,Int),
        sort_by_crop(Type,Int,[],Sorted).







issue_warning(G,L) :-
        issue_warning(G,L,0).



issue_warning(G,[],0) :- 
        format('~nWarning!  no lines found for ~w in any crop!~n',[G]).

issue_warning(_,[],Count) :-
        Count > 0.
        

issue_warning(G,[_-_-L|T],Count) :-
        issue_warning_aux(G,L,Count,NewCount),
        issue_warning(G,T,NewCount).


issue_warning_aux(_,[],A,A).
issue_warning_aux(G,[_-Lines|T],Count,NewCount) :-
        ( Lines == [] ->
                NextCount = Count
        ;
                NextCount is Count + 1
        ),
        issue_warning_aux(G,T,NextCount,NewCount).

        




check_predicate_format(genotype) :-
        setof(p(F,MF,MN,PF,PN,MG1,MG2,PG1,PG2,G,K),genotype(F,MF,MN,PF,PN,MG1,MG2,PG1,PG2,G,K),L),
        check_predicate_format(genotype,L).



check_predicate_format(_,[]).
check_predicate_format(Predicate,[H|T]) :-
        H =.. [_|Args],
        check_args(Predicate,Args),
        check_predicate_format(Predicate,T).







check_args(genotype,[F,MF,MN,PF,PN,MG1,MG2,PG1,PG2,G,K]) :-
        ( ( check(family,[F,MF,PF]),
            check(numerical_genotype,[MN,PN]),
            check(genotype,[MG1,MG2,PG1,PG2]),
            check(genetic_feature,[G]),
            check(k_number,[K]) ) ->
                true
        ;
                format('~nWarning! incorrect format for genotype(~d,~d,~q,~d,~q,~q,~q,~q,~q,~q,~q).~n',[F,MF,MN,PF,PN,MG1,MG2,PG1,PG2,G,K])
        ).





check(_,[]).
check(Type,[H|T]) :-
        ( Type == family ->
                integer(H)
        ;
                ( Type == numerical_genotype ->
                        atom(H),
                        deconstruct_plantID(H,_,_,_,_)
                ;
                        ( Type == genotype ->
                                atom(H)
                        ;
                                ( Type == genetic_feature ->
                                        is_list(H),
                                        member(Fea,H),
                                        atom(Fea)
                                ;
                                        ( Type == k_number ->
                                                atom(H),
                                                atom_length(H,Len),
                                                ( Len >= 4 ->
                                                        sub_atom(H,0,1,_,'K')
                                                ;
                                                        H == ''
                                                )
                                        ;
                                                format('~nWarning! unconsidered case ~w in check/2.~n',[Type])
                                        )
                                )
                        )
                )
       ),
       check(Type,T).







check_mutant_arg :-
        setof(F,(MF^MN^PF^PN^MG1^MG2^PG1^PG2^K^genotype(F,MF,MN,PF,PN,MG1,MG2,PG1,PG2,G,K),\+ is_list(G)),L),
        write_list(L).















wild_type(Locus) :-
        gene_type(Locus,wild_type).












get_source_daddy(Fam,Ma,Pa) :-
        genotype(_,_,_,Fam,_NumGtype,_,_,Ma,Pa,_KNumber),
        Fam < 200.









output_data(File,Switch,L) :-
        open(File,write,Stream),
        output_header(Switch,File,Stream),
        ( L == [] ->
                format(Stream,'none!~n',[])
        ;
                ( ( Switch == phto
                  ;
                    Switch == uphto 
                  ;
                    Switch == harv
                  ;
                    Switch == harvg
                  ;
                    Switch == harve
                  ;
                    Switch == harvu
                  ;
                    Switch == harvi ) ->
                        length(L,N),
                        format(Stream,'% ~d plants in the following list.~n~n~n',[N]),
                        ( Switch == harv ->
                                write_harvest_list(Stream,L)
                        ;
                                ( Switch == harvi ->
                                        write_inbred_harvest_list(Stream,L)
                                ;
		                        write_list_facts_w_skips(Stream,L)
                                )
                        )
                ;
                        ( Switch == plntags ->
                                write_decorated_list(Stream,L)
                        ;
                                ( ( Switch == self
                                  ;
                                    Switch == tocr ) ->
                                        write_list_undone(Stream,L)
                                ;
                                         ( Switch == plntg ->
                                                 once(arg(1,L,H)),
                                                 once(arg(1,H,FirstRow)),
                                                 write_planting_plan(Stream,FirstRow,L)
                                         ;
                                                 ( Switch == mutls ->
                                                         write_plans_for_ipad(Stream,L)
                                                 ;
                                                         ( Switch \== foo ->
                                                                 write_list_facts(Stream,L) 
                                                         ;
                                                                 write_undecorated_list(Stream,L) 
                                                         )
                                                 )
                                         )
                                )
                        )
                )
        ),
	close(Stream).




output_header(Switch,File,Stream) :-
        format(Stream,'% this is ../c/maize/demeter/~w~n~n',[File]),
        utc_timestamp_n_date(UTCTimeStamp,Date),
        format(Stream,'% generated on ~w (= ~w) by ',[Date,UTCTimeStamp]),
        output_header_aux(Switch,Stream). 


output_header_aux(crp,Stream) :-
        format(Stream,'genetic_utilites:make_crop_row_plant/1.~n~n~n',[]),
        format(Stream,'% crop_rowplant(NumericalGenotype,Crop,Row,Plant).~n~n~n',[]).


output_header_aux(fake,Stream) :-
        format(Stream,'clean_data:confect_planting_n_stand_count_data/4.~n~n~n',[]),
        format(Stream,'% Two types of FAKE data generated for computing plant tags and field book.~n',[]),
        format(Stream,'% Plntr, Dates, Times, NumEmerged, Phenotypes, and Observer all faked.~n~n~n',[]),
        format(Stream,'% planted(Row,Packet,Plntr,Date,Time,Soil,Crop).~n~n~n',[]),
        format(Stream,'% row_status(Row,NumEmerged,Phenotypes,Obsrvr,Date,Time,Crop).~n~n~n',[]).



output_header_aux(plin,Stream) :-
        format(Stream,'genetic_utilites:make_planting_index/1.~n~n~n',[]),
        format(Stream,'% planting_index(MaNumGType,PaNumGType,Crop,Row).~n~n~n',[]).


output_header_aux(rowm,Stream) :-
        format(Stream,'genetic_utilites:make_row_members/1.~n~n~n',[]),
        format(Stream,'% row_members(Crop,Row,ListRowMembers).~n~n~n',[]).


output_header_aux(plan,Stream) :-
        format(Stream,'genetic_utilites:find_plan/2.~n~n~n',[]),
        format(Stream,'% plan(MaNumGtype,PaNumGtype,Planting,PlanList,Notes,Crop).~n~n~n',[]).

 

output_header_aux(pkt,Stream) :-
        format(Stream,'analyze_crop:repack_packets/3.~n~n~n',[]),
        format(Stream,'% Sleeve-(MaNumGtype,PaNumGtype,Row).~n~n~n',[]).


output_header_aux(mutls,Stream) :-
        format(Stream,'analyze_crop:identify_mutant_row_plans/2.~n~n~n',[]),
        format(Stream,'% Row  Planting KNum   Family             Ma  x  Pa~n%       Genotype~n%       Plan~n%       Notes~n~n~n',[]).




output_header_aux(muts,Stream) :-
        format(Stream,'genetic_utilites:find_all_mutants/1.~n~n~n',[]),
        format(Stream,'% Sorted list of all markers of interest in genotype/11~n~n~n',[]).





output_header_aux(plntags,Stream) :-
        format(Stream,'crop_management/generate_plant_tags_file/3.~n~n~n',[]),
        format(Stream,'% Data for label_making/make_plant_tags.perl, using priority_rows/2.~n~n~n',[]).



output_header_aux(self,Stream) :-
        format(Stream,'crop_management:all_mutant_rows_for_selfing/2 called in daily_status_report/3.~n~n~n',[]),
        format(Stream,'% Row-SelfingStatus.~n~n~n',[]).


output_header_aux(tslw,Stream) :-
        format(Stream,'crop_management:tassel_watch/2 called in daily_status_report/3.~n~n~n',[]),
        format(Stream,'% RowPlant-(TasselStatus,StatusDay,Plan,ToDo).~n~n~n',[]).


output_header_aux(dads,Stream) :-
        format(Stream,'crop_management:find_daddies/2 called in daily_status_report/3.~n~n~n',[]),
        format(Stream,'% RowPlant-(PlantID,PreviousFemales,Plan,ToDo).~n~n~n',[]).


output_header_aux(scor,Stream) :-
        format(Stream,'crop_management:find_rows_to_score/3 called in daily_status_report/3.~n~n~n',[]),
        format(Stream,'% RowToScore.~n~n~n',[]).





output_header_aux(silk,Stream) :-
        format(Stream,'crop_management:find_silking_ears/2 called in daily_status_report/3.~n~n~n',[]),
        format(Stream,'% Ear-OrderedListSilkingDates.~n~n~n',[]).


output_header_aux(orph,Stream) :-
        format(Stream,'crop_management:find_orphan_tassels/3 called in daily_status_report/3.~n~n~n',[]),
        format(Stream,'% double-check output against the field and against all possible selfs!~n~n~n',[]),
        format(Stream,'% RowPlant-(PlantID,Day,Mon,Time).~n~n~n',[]).


output_header_aux(tocr,Stream) :-
        format(Stream,'crop_management:find_rows_to_cross/3 called in daily_status_report/3.~n~n~n',[]),
        format(Stream,'% Row-SoFar.~n~n~n',[]).


output_header_aux(phto,Stream) :-
        format(Stream,'crop_management:find_crossed_plants_to_photo/2.~n~n% **** Be sure to check plant for ALL blue twist-ties! ****~n~n~n',[]),
        format(Stream,'% PlantToPhotograph.~n~n~n',[]).



output_header_aux(uphto,Stream) :-
        format(Stream,'crop_management:find_uncrossed_plants_to_photo/1.~n~n% **** Be sure to check plant for ALL blue twist-ties! ****~n~n~n',[]),
        format(Stream,'% PlantToPhotograph.~n~n~n',[]).



output_header_aux(harv,Stream) :-
        format(Stream,'crop_management:order_harvest/2.~n~n% **** Be sure to check row for ALL ears! ****~n~n~n',[]),
        format(Stream,'% EarToHarvest.~n~n~n',[]).




output_header_aux(harvi,Stream) :-
        format(Stream,'crop_management:harvest_inbred_selfs/2.~n~n% **** Be sure to check row for ALL ears! ****~n~n~n',[]),
        format(Stream,'% EarToHarvest.~n~n~n',[]).



output_header_aux(harvg,Stream) :-
        format(Stream,'crop_management:find_goofs/2.~n~n% **** Spoil bags --- DO NOT HARVEST! ****~n~n~n',[]),
        format(Stream,'% BagToSpoil.~n~n~n',[]).



output_header_aux(harve,Stream) :-
        format(Stream,'crop_management:harvested_early/2.~n~n~n',[]),
        format(Stream,'% (Ma,Pa,DifferenceInDays).~n~n~n',[]).




output_header_aux(harvu,Stream) :-
        format(Stream,'crop_management:find_unrecorded_pollinations/2.~n~n~n',[]),
        format(Stream,'% Ma,Pa.~n~n~n',[]).


output_header_aux(tags,Stream) :-
        format(Stream,'need_tags:need_tags/2.~n~n~n',[]),
        format(Stream,'% PlantID.~n~n~n',[]).




output_header_aux(plano,Stream) :-
        format(Stream,'order_packets:generate_plan/1.~n~n~n',[]),
        format(Stream,'% plan(Ma,Pa,Planting,Instructions,Notes,Crop).~n~n~n',[]).




output_header_aux(plntg,Stream) :-
        format(Stream,'order_packets:insert_later_packets_in_row/6.~n~n~n',[]),
        format(Stream,'% Row ~10|Packet ~23|Sequence Number~n~n~n',[]).



output_header_aux(replant,Stream) :-
        format(Stream,'crop_management:find_rows_to_replant/2.~n~n~n',[]),
        format(Stream,'% Row-(Packet,Seq,Ma,Pa,ClNeeded)   packets sorted into packing order!~n~n~n',[]).






% catch-all cases for the rest

output_header_aux(foo,Stream) :-
        format(Stream,'some predicate; file is likely to be temporary.~n~n~n',[]).

output_header_aux(bar,Stream) :-
        format(Stream,'some predicate; file is likely to be temporary.~n~n~n',[]).




% output_header_aux(_,Stream) :-
%        format('~n~nWarning!  unconsidered case in genetic_utilities:output_header/3!~n~n',[]).









% to accommodate the ipad''s smaller screen
%
% Kazic, 23.7.2011

% modified to include planting number, and fixed initial call so that the first mutant
% gets a header.  An instantiated variable will not unify to an uninstantiated variable,
% but I have put in the test explicitly in write_plans_for_ipad/3 for clarity.
%
% Kazic, 30.12.2012


% hmmm, need to revise for the iphone 5!
%
% Kazic, 3.4.2018

write_plans_for_ipad(Stream,[Row-Marker-(Family,Ma,Pa,MGma,MGpa,PGma,PGpa,K,Plan,Notes,Plntg)|Rows]) :-
        write_plans_for_ipad(Stream,_,[Row-Marker-(Family,Ma,Pa,MGma,MGpa,PGma,PGpa,K,Plan,Notes,Plntg)|Rows]).



write_plans_for_ipad(_,_,[]).
write_plans_for_ipad(Stream,PriorMarker,[Row-Marker-(Family,Ma,Pa,MGma,MGpa,PGma,PGpa,K,Plan,Notes,Plntg)|Rows]) :-
        ( ( Marker == PriorMarker
          ;
            var(Marker) ) ->
                NewMarker = PriorMarker,
                format(Stream,'~d ~8|~w  ~16|~w  ~24|~w  ~30|~w x ~w~n~8|(~w,~w,~w,~w)~n~8|~w~n~8|~w~n~n',[Row,Plntg,K,Family,Ma,Pa,MGma,MGpa,PGma,PGpa,Plan,Notes])
        ;
                NewMarker = Marker,
                format(Stream,'~n~n%%%%% ~w %%%%%~n~n~d ~8|~w  ~16|~w  ~24|~w  ~30|~w x ~w~n~8|(~w,~w,~w,~w)~n~8|~w~n~8|~w~n~n',[Marker,Row,Plntg,K,Family,Ma,Pa,MGma,MGpa,PGma,PGpa,Plan,Notes])
        ),
        write_plans_for_ipad(Stream,NewMarker,Rows).





write_list_facts_w_skips(_,[]).
write_list_facts_w_skips(Stream,[Index-SkipMarker-Fact|T]) :-
        write_list_facts_w_skips(Stream,SkipMarker,[Index-SkipMarker-Fact|T]).


write_list_facts_w_skips(Stream,[SkipMarker-Fact|T]) :-
        write_list_facts_w_skips(Stream,SkipMarker,[SkipMarker-Fact|T]).




write_list_facts_w_skips(_,_,[]).
write_list_facts_w_skips(Stream,PriorSkipMarker,[Index-SkipMarker-Fact|T]) :-
        ( SkipMarker == PriorSkipMarker ->
                format(Stream,'~w (~w)~n',[Index,Fact])
        ;
                format(Stream,'~n~w (~w)~n',[Index,Fact])
        ),
        write_list_facts_w_skips(Stream,SkipMarker,T).


write_list_facts_w_skips(Stream,PriorSkipMarker,[SkipMarker-Fact|T]) :-
        ( SkipMarker == PriorSkipMarker ->
                format(Stream,'~w~n',[Fact])
        ;
                format(Stream,'~n~w~n',[Fact])
        ),
        write_list_facts_w_skips(Stream,SkipMarker,T).




write_harvest_list(_,[]).
write_harvest_list(Stream,L) :-
        write_harvest_list(Stream,0,L).





write_harvest_list(_,_,[]).
write_harvest_list(Stream,PriorRow,[Row-(Ma,Pa,EasyDate,Worry)|T]) :-
        ( Row == PriorRow ->
                true
        ;
                format(Stream,'~n~n~w~n',[Row])
        ),
        format(Stream,'~w ~20| ~w ~40|~w',[Ma,Pa,EasyDate]),
        ( var(Worry) ->
                format(Stream,'~n',[])
        ;
                format(Stream,'~50|~w~n',[Worry])
        ),
        write_harvest_list(Stream,Row,T).






write_inbred_harvest_list(_,[]).
write_inbred_harvest_list(Stream,[Family-Fact|T]) :-
        write_inbred_harvest_list(Stream,0,0,[Family-Fact|T]).




write_inbred_harvest_list(_,_,_,[]).
write_inbred_harvest_list(Stream,PriorRow,PriorFamily,[Family-(Row,Ma,DaysAfterPolltn,EasyDate,Worry)|T]) :-
        ( Family == PriorFamily ->
                true
        ;
                inbred(Family,Inbred),
                format(Stream,'~n~n~n~n================ ~w =================~n',[Inbred])
        ),
 
        ( Row == PriorRow ->
                true
        ;
                format(Stream,'~n~n~w~n',[Row])
        ),
        format(Stream,'~w ~20| ~w ~30|~w ',[Ma,EasyDate,DaysAfterPolltn]),
        ( var(Worry) ->
                format(Stream,'~n',[])
        ;
                format(Stream,'~40|~w~n',[Worry])
        ),
        write_inbred_harvest_list(Stream,Row,Family,T).











write_decorated_list(_,[]).
write_decorated_list(Stream,[_-H|T]) :-
        write_args(Stream,H),
        write_decorated_list(Stream,T).






write_args(Stream,Tuple) :-
        ( compound(Tuple) ->
                nonvar(Tuple),
                once(arg(1,Tuple,First)),
                once(arg(2,Tuple,Rest)),
                format(Stream,'~q,',[First]),
                ( nonvar(Rest) ->
                        write_args(Stream,Rest)
                ;
                        true
                )
        ;
                atom(Tuple),
                format(Stream,'~q~n',[Tuple])
        ).




write_list_undone(_,[]).
write_list_undone(Stream,[H-Status|T]) :-
        ( ( Status == done
          ;
            Status == [done] ) ->
                true
        ;
                format(Stream,'~w-~w~n',[H,Status])
        ),
        write_list_undone(Stream,T).
          




write_planting_plan(_,_,[]).
write_planting_plan(Stream,PriorRow,[Row-(Sequence,Packet,_)|T]) :-
        ( ( Row == PriorRow
          ;
            Row is PriorRow + 1 ) ->
                true
        ;
                format(Stream,'~n',[])
        ),
        format(Stream,'~d ~10|~w ~23|~d~n',[Row,Packet,Sequence]),
        write_planting_plan(Stream,Row,T).




write_undecorated_list(_,[]).
write_undecorated_list(Stream,[H|T]) :-
        format(Stream,'~w~n',[H]),
        write_undecorated_list(Stream,T).










% given a string or atom and the number of padding characters needed,
% pad out the input

pad(StringOrAtom,TotalLengthNeeded,PaddedString) :-
        atom_length(StringOrAtom,Len),
        NumCharsNeeded is TotalLengthNeeded - Len,
        ( add_padding(NumCharsNeeded,StringOrAtom,PaddedString) ->
                true
        ;
                format('Warning! StringOrAtom ~w is too large to pad to ~w in genetic_utiliies:pad/3~n',[StringOrAtom,TotalLengthNeeded]),
                PaddedString = StringOrAtom
        ).






add_padding(NumCharsNeeded,Atom,PaddedAtom) :-
        num_pads(NumCharsNeeded,Pads),    
        atomic_list_concat([Pads,Atom],PaddedAtom).







% lookup faster than recursion, surely!    

num_pads(0,'').    
num_pads(1,'0').    
num_pads(2,'00').    
num_pads(3,'000').    
num_pads(4,'0000').    







find_plan(Crop,File) :-
        setof((Ma,Pa),Packet^Cl^Packer^Date^Time^packed_packet(Packet,Ma,Pa,Cl,Packer,Date,Time),Packets),
        get_plans(Crop,Packets,PacketsNPlans),
        output_data(File,plan,PacketsNPlans).




get_plans(Crop,Packets,PacketsNPlans) :-
         get_plans(Crop,Packets,[],PacketsNPlans).





% plan/6 no longer has a list for the first argument
%
% Kazic, 24.11.2009

get_plans(_,[],A,A).
get_plans(Crop,[(Ma,Pa)|T],Acc,PacketsNPlans) :-
%        ( plan([(Ma,Pa)],Planting,PlanList,Notes,Crop) ->
        ( plan(Ma,Pa,Planting,PlanList,Notes,Crop) ->
                append(Acc,[plan(Ma,Pa,Planting,PlanList,Notes,Crop)],NewAcc)
        ; 
%                plan(List,Planting,PlanList,Notes,Crop),
%                ( member((Ma,Pa),List)->
%                        append(Acc,[plan(Ma,Pa,Planting,PlanList,Notes,Crop)],NewAcc)
%                ;
                        NewAcc = Acc
%                )
        ),
        get_plans(Crop,T,NewAcc,PacketsNPlans).












% removed the call to the Quintus on_exception/2 predicate.  Exception handling
% in swipl is more complicated (basically, try/catch) and in this instance really
% isn''t needed.
%
% Kazic, 2.4.2018


build_row(Row,PadRow) :-
        ( pot(Row) ->
                PadRow = Row
        ;
                row(Row),
                PadRow = Row
        ;
                ( ( integer(Row)
		  ; ( sub_atom(Row,0,1,_,First),
		      lower_case_letters(LowerLetters),
		      \+ memberchk(First,LowerLetters) ) ) ->
                        atom_length(Row,RowLen),
                        NumCharsNeeded is 5 - RowLen,
                        ( NumCharsNeeded > 0 ->
                                once(add_padding(NumCharsNeeded,Row,PaddedRow))
                        ;
                                PaddedRow = Row
                        ),
                        atomic_list_concat([r,PaddedRow],PadRow)
                )
        ).







% 06r inbred rows had I, but remove_padding_aux/2 now handles that case
%
% Kazic, 3.4.2018

extract_row(PadRow,RowNum) :-
        once(remove_padding(PadRow,RowNum)).










extract_row_from_full(PrefixedPaddedRow,RowNum) :-
        remove_row_prefix(PrefixedPaddedRow,RowNum).











% removed the call to the Quintus on_exception/2 predicate.  Exception handling
% in swipl is more complicated (basically, try/catch) and in this instance really
% isn''t needed.
%
% Kazic, 3.4.2018


build_packet(Packet,PadPacket) :-
        ( packet(Packet) ->
                PadPacket = Packet
        ;
                
                atom_length(Packet,PacketLen),
                NumCharsNeeded is 5 - PacketLen,
                ( NumCharsNeeded > 0 ->
                        once(add_padding(NumCharsNeeded,Packet,PaddedPacket))
                ;
                        PaddedPacket = Packet
                ),
                atomic_list_concat([p,PaddedPacket],PadPacket)
        ).











most_recent_crop(LatestCrop) :-
        setof(Crop,Loctn^Field^Plntg^Date^DateHarSt^DateHarFin^crop(Crop,Loctn,Field,Plntg,Date,DateHarSt,DateHarFin),Crops),
        reverse(Crops,[LatestCrop|_]).









check_day_lower_bound(NumDays,TodaysTimeStamp,(EarlierDate,EarlierTime)) :-
        get_timestamp(EarlierDate,EarlierTime,EarlierTS),
        check_day_lower_bound_aux(NumDays,EarlierTS,TodaysTimeStamp).






check_day_lower_bound_aux(NumDays,EarlierTS,LaterTS) :-
        num_secs(NumDays,NumSec),
        Threshold is LaterTS - NumSec,
        EarlierTS =< Threshold.



check_day_window(NumDays,(EarlierDate,EarlierTime),TodaysTimeStamp) :-
        integer(TodaysTimeStamp),
        get_timestamp(EarlierDate,EarlierTime,EarlierTS),
        check_day_window_aux(NumDays,EarlierTS,TodaysTimeStamp).




check_day_window(NumDays,(EarlierDate,EarlierTime),(LaterDate,LaterTime)) :-
        get_timestamp(EarlierDate,EarlierTime,EarlierTS),
        get_timestamp(LaterDate,LaterTime,LaterTS),
        check_day_window_aux(NumDays,EarlierTS,LaterTS).





check_day_window_aux(NumDays,EarlierTS,LaterTS) :-
        num_secs(NumDays,NumSec),
        Threshold is LaterTS - NumSec,
        EarlierTS > Threshold,
        EarlierTS < LaterTS.







check_inventory(Ma,Pa,Sleeve) :-
        setof(TS-(Ma,Pa,Num,FSleeve),timestamp_inventory(Ma,Pa,Num,FSleeve,TS),List),
        reverse(List,[_-(Ma,Pa,num_kernels(RNum),Sleeve)|_]),
        check_quantity_cl(Ma,Pa,RNum).






timestamp_inventory(Ma,Pa,Num,Sleeve,TS) :-
        inventory(Ma,Pa,Num,_,Date,Time,Sleeve),
        get_timestamp(Date,Time,TS).









% include a check for discarded ears in harvest facts for
% ears in 2009 and later
%
% Kazic, 7.5.2011

check_quantity_cl(DescMN,DescPN,Num) :-
        ( number(Num),
          Num >= 24
	;
          \+ number(Num),
          memberchk(Num,[whole,three_quarter,half,quarter,eighth,sixteenth])
        ;
          format('Warning! number kernels of ~w x ~w failing the quantity test~n',[DescMN,DescPN])
        ),
        get_year(DescMN,Year),
        ( Year >= 09 ->
                check_ear_status(DescMN)
        ;
                true
        ).








% only for ears that have harvest facts!
%
% Kazic, 7.5.2011
%
% Convention is that an empty comment signifies a perfectly fine ear.
%
% Kazic, 26.5.2011

check_ear_status(MaNumericalGenotype) :-
        harvest(MaNumericalGenotype,_,succeeded,Comment,_,_,_),
        ( nonvar(Comment) ->
                \+ sub_atom(Comment,_,_,_,discarded)
        ;
                true
        ).







find_all_mutants(File) :-
        setof(Mutants,F^MF^MN^PF^PN^MGM^MGP^PGM^PGP^K^genotype(F,MF,MN,PF,PN,MGM,MGP,PGM,PGP,Mutants,K),L),
        flatten(L,Flat),
        sort(Flat,ListMuts),
        output_data(File,muts,ListMuts).







% for converting old genotype and source facts to the new ones
%
% Kazic, 1.8.09

build_numerical_genotype(F,Crop,DummyNumGType) :-
        F < 1000,
        pad(F,4,PaddedF),
        atomic_list_concat([Crop,PaddedF,':0000000'],DummyNumGType).
















construct_plantIDs(Crop,Row,Family,Plants) :-
        construct_plant_prefix(Crop,Row,Family,PlantIDPrefix),
        find_current_stand_count(Row,Crop,NumPlants),
        build_row_members(PlantIDPrefix,NumPlants,Plants).
       





construct_plant_prefix(Crop,Row,Family,PlantIDPrefix) :-
        make_barcode_elts(Crop,Family,BarcodeElts),
        pad(Row,5,PaddedRow),
        atomic_list_concat([BarcodeElts,PaddedRow],PlantIDPrefix).









find_current_stand_count(Row,Crop,NumPlants) :-
        ( integer(Row) ->
                build_row(Row,PRow)
        ;
                PRow = Row
        ),

        ( setof(Mon-Day-Num,PList^Obsvr^Yr^Time^row_status(PRow,num_emerged(Num),PList,Obsvr,date(Day,Mon,Yr),Time,Crop),Data) ->
                reverse(Data,Status),
                most_recent_num(Status,NumPlants)
        ;

                format('Warning!  no stand count data for row ~w of crop ~w, trying inferred_stand_count/6 instead!~n',[Row,Crop]),
		inferred_stand_count(Row,Crop,_,_,_,NumPlants)

        ).









% since the list is ordered by date in reverse, the head is the
% most recent stand count for that row.

most_recent_num([],0).
most_recent_num([_-_-Num|T],NumPlants) :-
        ( nonvar(Num) ->
                NumPlants = Num
        ;
                most_recent_num(T,NumPlants)
        ).









build_row_members(PlantIDPrefix,NumPlants,Plants) :-
        build_row_members(PlantIDPrefix,1,NumPlants,[],Plants).


build_row_members(_,End,NumPlants,P,P) :-
        End is NumPlants + 1.

build_row_members(PlantIDPrefix,CurrNum,NumPlants,Acc,Plants) :-
        atom_number(Atom,CurrNum),
        atomic_list_concat([PlantIDPrefix,Atom],Plant),
        ( still_alive(Plant) ->
                append(Acc,[Plant],NewAcc)
        ;
                NewAcc = Acc
        ),
        Next is CurrNum + 1,
        build_row_members(PlantIDPrefix,Next,NumPlants,NewAcc,Plants).








still_alive(Plant) :-
        \+ plant_fate(Plant,_,_,_,_),
        \+ contaminant(Plant,_,_,_,_).




% returns RowPlant as an atom

make_rowplant(Row,Plant,RowPlant) :-
        pad(Row,5,PRow),
        pad(Plant,2,PPlant),
        atomic_list_concat([PRow,PPlant],RowPlant).







get_rowplants([],[]).
get_rowplants([PlantID|PlantIDs],[crop_rowplant(PlantID,Crop,Row,Plant)|RowPlants]) :-
        get_crop(PlantID,Crop),
        get_row(PlantID,Row),
        get_plant(PlantID,Plant),
        get_rowplants(PlantIDs,RowPlants).





get_rowplant(PlantID,RowPlant) :-
        sub_atom(PlantID,8,7,0,RowPlant).





% given a date, return either the crop for that date (the current_crop/1),
% or construct a crop designator (Crop) and issue a warning to update the 
% current_crop/1 (and maybe crop/7) facts.
%
% fixed to distinguish winter nursery from greenhouse crop; have never planted in
% April in Missouri, and don''t have a greenhouse crop in the summer.
%
% tested and correct
%
% Kazic, 29.3.2018



% crop_from_date(++Date,--Crop).

crop_from_date(date(Day,Mo,Yr),Crop) :-

        current_crop(CurCrop),


% check if this date has a contemporaneous current_crop/1 fact

        our_date(date(Day,Mo,Yr)),
        sub_atom(Yr,2,2,_,TruncatedYr),

        ( ( Mo > 4,
            Mo =< 10 ) ->
               Particles = ['R']
        ; 
               Particles = ['N','G']
        ),

        findall(C,(member(P,Particles),atom_concat(TruncatedYr,P,C)),PossibleCrops),
        ( memberchk(CurCrop,PossibleCrops) ->
                Crop = CurCrop

        ;


% otherwise, build the crop descriptor and issue a warning to update current_crop/1

                crop(Crop,Locatn,_,_,PlantingDate,_,_),
                ( once(arg(3,PlantingDate,Yr)) ->

                        ( ( Locatn == molokaii,
                          ( Mo >= 11 ; Mo =< 4 ) ) ->
                                Particle = 'N'
                        ;              
                                Locatn == missouri,
                                ( ( Mo > 4,
                                    Mo =< 10) ->
       	                               Particle = 'R'
                                ;
                                       Particle = 'G'
                                )
                        ),
                        atom_concat(TruncatedYr,Particle,Crop),
                        format('~nWarning! need a current ../data/current_crop/1 fact for ~w.~n~n',[Crop])
                 ;

                        format('~nWarning! need current ../data/current_crop/1 and ~n~t../data/crop/7 facts for ~w.~n~n',[Crop])
                 )
        ).






% begin the crop with the first planting

crop_timestamp(Crop,TimeStamp) :-
        crop(Crop,_,_,1,Date,_,_),
        get_timestamp(Date,time(_,_,_),TimeStamp).








% date_from_crop(+Crop,+Mo,-Yr).

date_from_crop(Crop,Mo,Yr) :-
        nonvar(Crop),
        get_year_from_particle(Crop,_,Yr),
        crop_window(Crop,CropMonths),
        memberchk(Mo,CropMonths).        








crop_window(Crop,CropMonths) :-
        get_nursery_from_particle(Crop,Nursery),
        crop_months(Nursery,CropMonths).





% nondisjoint!

crop_months('R',[4,5,6,7,8,9,10]).
crop_months('N',[11,12,1,2,3,4]).
crop_months('G',[1,2,3,4,5,6,7,8,9,10,11,12]).




% should never need the second clause, but I might need to
% hunt for a piece of a plan element
%
% Kazic, 8.4.2018

plan_includes(Operation,Plan,Elt) :-
        ( memberchk(Operation,Plan) ->
                  Elt = Operation
	;
                  member(Elt,Plan),
                  sub_atom(Elt,_,_,_,Operation)
        ).
           







row_from_parents(Ma,Pa,Crop,Row) :-
        packed_packet(Packet,Ma,Pa,_,_,Date,_),
        ( var(Crop) ->
                crop_from_date(Date,Crop)
        ;
                true
        ),


%
% eek! transplants will just have a pot fact; when the prefix is removed, it
% will look just like a row!!!
%
% Kazic, 1.8.2009
%
%        planted(PrefixedRow,Packet,_,_,_,_,_,Crop),

        track_transplants_to_row(Crop,Packet,PrefixedRow),
        remove_row_prefix(PrefixedRow,Row).













selfed_plants(RowMembers,Selfed) :-
        selfed_plants(RowMembers,[],Selfed).



selfed_plants([],A,A).
selfed_plants([Parent|Parents],Acc,Selfed) :-
        ( cross(Parent,Parent,ear(1),false,toni,_,_,_) ->
                append(Acc,[Parent],NewAcc)
        ;
                NewAcc = Acc
        ),
        selfed_plants(Parents,NewAcc,Selfed).









% exclude the inbreds used to produce the next population of seed
%
% should also exclude the fun corn

selfing_candidate(PlantID,Crop) :-
        \+ inbred(PlantID,_,_),
        crop_rowplant(PlantID,Crop,RowNum,_),
        identify_row(Crop,RowNum,_-(_,_,Ma,Pa,_,_,_,_,_,_)),
        plan(Ma,Pa,_,Plan,_,Crop),
        plan_includes(self,Plan,_).








all_preps_except_shootbagging(PlantID,Preps) :-
        setof(Date-Prep,prep_except_shootbagging(PlantID,Prep,Date),Preps).


prep_except_shootbagging(PlantID,Prep,Date) :-
        cross_prep(PlantID,Prep,_,Date,_),
        Prep \== [bag(shoot)].









tassel_bagged(Preps,Day) :-
        tassel_bagged(Preps,[],BaggingPreps),
        ( BaggingPreps == [] ->
                false
        ;
                sort(BaggingPreps,Sorted),
                reverse(Sorted,[date(Day,_,_)-_|_])
        ).



tassel_bagged([],A,A).
tassel_bagged([Date-Prep|Preps],Acc,BaggingPreps) :-
        ( memberchk(bag(tassel),Prep) ->
                append(Acc,[Date-Prep],NewAcc)
        ;
                true
        ),
        tassel_bagged(Preps,NewAcc,BaggingPreps).








% accommodate B73 and switch to setof instead of explicit enumeration of facts.
%
% Kazic, 25.4.2012

crop_inbred_packets(Crop,InbredPackets) :-
        setof(Packet,MaF^PaF^F^current_inbred(Crop,MaF,PaF,F,Packet),InbredPackets).



crop_inbred_families(Crop,InbredLines) :-
        setof(Family,MaF^PaF^Packet^current_inbred(Crop,MaF,PaF,Family,Packet),InbredLines).











% works if either Packet or Ma and Pa uninstantiated
%
% Kazic, 18.7.2010
%
% test:  first clause ok


current_packet(Packet,Ma,Pa) :-
        ( ( nonvar(Packet),
            var(Ma),
            var(Pa) ) ->
                setof(Date-Time-(Packet,AMa,APa),load_data:Cl^Pkr^packed_packet(Packet,AMa,APa,Cl,Pkr,Date,Time),Packets),
                most_recent_datum(Packets,_-(_,Ma,Pa))
        ;
                var(Packet),
                nonvar(Ma),
                nonvar(Pa),
                setof(Date-Time-(APacket,Ma,Pa),load_data:Cl^Pkr^packed_packet(APacket,Ma,Pa,Cl,Pkr,Date,Time),Packets),
                ( most_recent_datum(Packets,_-(Packet,Ma,Pa)) ->
                        true
                ;
                        memberchk((Packet,Ma,Pa),Packets),
                        format('Warning!  the packet, ~w, with ~w x ~w, is not that most recently packed for those parents!~n~n',[Packet,Ma,Pa])
                )
        ).

        









current_packets_for_crop(PackingStartTimeStamp,Ma,Pa,FilteredPackets) :-
        ( ( nonvar(Ma),
            nonvar(Pa) ) ->
                setof(TimeStamp-(Packet,Ma,Pa),timestamped_packet(Ma,Pa,TimeStamp,Packet),Packets),
                filter_by_date(PackingStartTimeStamp,Packets,FilteredPackets)
        ;
                format('Warning! unconsidered case in genetic_utilities:current_packets_for_crop/4 for ~w x ~w packed starting ~q.~n',[Ma,Pa,PackingStartTimeStamp])
        ).


        


filter_by_date(MinTimeStamp,Data,Filtered) :-
        filter_by_date(MinTimeStamp,Data,[],Filtered).



filter_by_date(_,[],A,A).
filter_by_date(MinTimeStamp,[TimeStamp-Fact|T],Acc,Filtered) :-
        ( TimeStamp >= MinTimeStamp ->
                append(Acc,[Fact],NewAcc)
        ;
                NewAcc = Acc
        ),
        filter_by_date(MinTimeStamp,T,NewAcc,Filtered).










% KeyList is of the form date(D,M,Y)-Fact; the date must be converted into
% a timestamp for most error-free sorting.

most_recent_datum(KeyList,MostRecent) :-
        convert_dates(KeyList,Converted),
        sort(Converted,Sorted),
        last(MostRecent,Sorted).




reverse_chronological_order(KeyList,RevOrder) :-
        convert_dates(KeyList,Converted),
        sort(Converted,Sorted),
        reverse(Sorted,RevOrder).








%%%%%%%%% transplant tracking %%%%%%%%%%%
%
% In any particular crop, there will be only one line/packetID (over many crops, many different
% lines can have the same packetID).  So as long as no new packed_packet/6 facts are used, and
% navigation is within the same crop, one shouldn''t need to use current_packet/3.
%
% Kazic, 17.7.2010



% since transplants have another "row" --- e.g. pot or flat or minipot --- in the
% second argument, a simple search for the packet will fail.  This predicate goes
% from the given "row" to the actual packet that was packed with seed.

track_transplants(Crop,Packet,ActualPacket) :-
        ( packet(Packet) ->
                ActualPacket = Packet
        ;
                pot(Packet),
                planted(Packet,EarlierPot,_,_,_,_,_,Crop),
                track_transplants(Crop,EarlierPot,ActualPacket)
        ).








% also need to go in the opposite direction:  from the actual packet to its eventual row in the
% field, no matter how many intermediate transplantations the plants have endured.
%
% Kazic, 1.8.09

track_transplants_to_row(Crop,PutativeRow,PrefixedRow) :-
        track_transplants_to_row(Crop,PutativeRow,_,PrefixedRow).


track_transplants_to_row(Crop,PutativeRow,Date,PrefixedRow) :-
        ( ( row(PutativeRow),
            nonvar(Date) ) ->
                PrefixedRow = PutativeRow
        ;
                ( ( pot(PutativeRow)
                  ;
                    packet(PutativeRow) ) ->
                            planted(NextRow,PutativeRow,_,_,NextDate,_,_,Crop),
                            ( nonvar(Date) ->
                                     later(Date,NextDate)
                            ;
                                     true
                            ),


% have to exclude the shift of transplants from greenhouse to the steps behind Curtis Hall,
% for hardening off, preparatory to transplanting in the field

                            NextRow \== PutativeRow,
                            track_transplants_to_row(Crop,NextRow,NextDate,PrefixedRow)
                  ;	    
                            format('Warning! unconsidered case in track_transplants_to_row/4 for ~w~n',[PutativeRow]),
                            false
                  )	    
        ).











% ok, the plan gives Ma and Pa, but where did the offspring really go?
%
% That is, given Ma and Pa, find the physical row.

track_transplants_from_parents(Ma,Pa,Crop,PlantedRow) :-
        current_packet(Packet,Ma,Pa),
        packed_packet(Packet,Ma,Pa,_,_,Date,_),
        ( var(Crop) ->
                crop_from_date(Date,Crop)
        ;
                true
        ),
        ( planted(PRow,Packet,_,_,PltngDate,_,_,Crop) -> 
                ( physical_row(PRow,Crop) ->
                        PlantedRow = PRow
                ;
                        track_transplants_to_row(Crop,PRow,PltngDate,PlantedRow)
                )
        ;
                format('Warning! no planted/8 fact for ~w x ~w in crop ~w in track_transplants_from_parents/4~n',[Ma,Pa,Crop])
        ).















mutant_rows(Crop,Lines,MutantRows) :-
        mutant_rows(Crop,Lines,[],MutantRows).



mutant_rows(_,[],A,A).
mutant_rows(Crop,[Row-(_,Family,_,_,_,_,_,_,_,_)|T],Acc,MutantRows) :-
        ( ( mutant_by_family(Family),
            physical_row(Row,Crop),
            nonzero_stand_count(Row,Crop) ) ->
                prefixed_row_to_rownum(Row,IntegerRow),
                append(Acc,[IntegerRow],NewAcc)
        ;
                NewAcc = Acc
        ),
        mutant_rows(Crop,T,NewAcc,MutantRows).






mutant(PlantID) :-
        atom_length(PlantID,Len),
        ( Len == 15 ->
                mutant_by_gtype(PlantID)
        ;
                mutant_by_family(PlantID)
        ).






% this includes Gerry''s 11n lines!
%
% Kazic, 20.5.2014
%
% revised first test from Family >= 1000 to include
% new donated mutants but exclude crop improvement lines, gerry''s 11n
% families,  and fun corn
%
% Kazic, 8.4.2018

mutant_by_family(Family) :-
        integer(Family),
        ( Family < 200
        ;
          Family >= 1000,
          \+ gerry_families(Family)
        ;
          Family >= 642,
          Family < 892
        ;
          Family < 630,
          Family >= 600 
        ).







% covers Gerry''s 11n families

gerry_families(Family) :-
        Family >= 3332,
        Family =< 3393.








mutant_by_gtype(NumGType) :-
        ( once(get_family(NumGType,Family)) ->
                mutant_by_family(Family)
        ;
                format('mutant fails for ~w~n',[NumGType])
        ).














% most recent stand count is returned by find_current_stand_count/3

nonzero_stand_count(Row,Crop) :-
        row_status(Row,num_emerged(StandCount),_,_,_,_,Crop),
        integer(StandCount),
        StandCount > 0.




bag(Bag) :-
        atom(Bag),
        sub_atom(Bag,0,1,5,a).
	   



box(Box) :-
        atom(Box),
        sub_atom(Box,0,1,5,x).
	   
	   

packet(Packet) :-
        atom(Packet),
        sub_atom(Packet,0,1,5,p).
	   


pot(Pot) :-
        atom(Pot),
        sub_atom(Pot,0,1,5,t).


row(Row) :-
        atom(Row),
        sub_atom(Row,0,1,5,r).




sleeve(Sleeve) :-
        atom(Sleeve),
        sub_atom(Sleeve,0,1,5,v).


	   
scored_rows(Crop,ScoredRows) :-
        setof(Row,scored_row(Crop,Row),AllScored),
        list_to_set(AllScored,ScoredRows).




scored_row(Crop,Row) :-
        mutant(PlantID,_,_,_,_,_,_,_),
        get_crop(PlantID,Crop),
        get_row(PlantID,RowAtom),
        remove_padding(RowAtom,Row).





prefixed_row_to_rownum(Prefixed,Row) :-
        remove_row_prefix(Prefixed,Row).






% assume one is only interested in inbred ears, and only the
% most recent datum

% silking_ear(+Year,-Ear,-Type,-EasyDate).

silking_ear(Year,Ear,Type,EasyDate) :-
        setof(ADate-AEar-AType,silking_ear_aux(AEar,Year,ADate,AType),ReportDates),
        convert_dates(ReportDates,TimeStampedDates),
        latest(TimeStampedDates,LatestTimeStampDatum),
        once(arg(1,LatestTimeStampDatum,LatestTimeStamp)),
        once(arg(2,LatestTimeStampDatum,Ear-Type)),
        get_date_from_timestamp(LatestTimeStamp,Date),
        construct_date(Date,EasyDate).







silking_ear_aux(Ear,Year,date(Day,Mon,Year),Type) :-
        cross_prep(Ear,Preps,_,date(Day,Mon,Year),_),
        member(Prep,Preps),
        ( Prep == silking(1) ; Prep == cut(1) ),
        inbred(Ear,_,Type).











year_from_crop(Crop,Year) :-
        sub_atom(Crop,0,2,_,TruncatedYearAtom),
        atomic_list_concat(['20',TruncatedYearAtom],YearAtom),
        atom_number(YearAtom,Year).





        



% revised to eliminate redundant calls
%
% Kazic, 11.4.2018

%! bagged_tassel(+CropMonths:list,?PlantID:atom,-MostRecentDate:compound).

bagged_tassel(CropMonths,PlantID,MostRecentDate) :-
        bagof(Timestamp-Date,find_setup(CropMonths,PlantID,Timestamp-Date),Dates),
        sort(Dates,Sorted),
        reverse(Sorted,[MostRecent|_]),
	once(arg(2,MostRecent,MostRecentDate)).



find_setup(CropMonths,PlantID,Timestamp-date(Day,Mon,Yr)) :-
        cross_prep(PlantID,Preps,_,date(Day,Mon,Yr),Time),
        memberchk(bag(tassel),Preps),
        memberchk(Mon,CropMonths),
	get_timestamp(date(Day,Mon,Yr),Time,Timestamp).










% exclude plants that are dead or kicked down for light or otherwise
% out of the picture


dead_plants(Plants,DeadPlants) :-
        dead_plants(Plants,[],DeadPlants).


dead_plants([],A,A).
dead_plants([PlantID|T],Acc,DeadPlants) :-
        ( dead_plant(PlantID) ->
                append(Acc,[PlantID],NewAcc)
        ;
                NewAcc = Acc
        ),
        dead_plants(T,NewAcc,DeadPlants).




dead_plant(PlantID) :-
          ( plant_fate(PlantID,kicked_down(_),_,_,_)
          ;
            plant_fate(PlantID,dead,_,_,_)
          ;
            plant_fate(PlantID,crown_rot,_,_,_)
          ;
            plant_fate(PlantID,sacrificed(_),_,_,_)
          ;
            mistagged(PlantID,_,_,_,_)
          ).






scored_plants(Plants,ScoredPlants) :-
        scored_plants(Plants,[],ScoredPlants).


scored_plants([],A,A).
scored_plants([PlantID|T],Acc,ScoredPlants) :-
        ( scored_plant(PlantID) ->
                append(Acc,[PlantID],NewAcc)
        ;
                NewAcc = Acc
        ),
        scored_plants(T,NewAcc,ScoredPlants).





scored_plant(PlantID) :-
        mutant(PlantID,_,_,_,_,_,_,_).














calculate_days_since_pollinatn(TodaysTimeStamp,(Date,Time),NumDays) :-
        get_timestamp(Date,Time,PolltnTimeStamp),
        Diff is TodaysTimeStamp - PolltnTimeStamp,
        NumDays is Diff // 86400.








% which rows in the planting_index have had two pairs of parents assigned to them,
% for example because they were planted twice?
%
% Kazic, 21.4.2013

%! check_doubly_assigned_rows(-Doubles:list)  is det.

check_doubly_assigned_rows(Doubles) :-
        setof(Crop,S^L^P^D^HS^HF^crop(Crop,S,L,P,D,HS,HF),Crops),
        check_doubly_assigned_rows(Crops,Doubles).



%! check_doubly_assigned_rows(+Crops:list,-Doubles:list) is det.

check_doubly_assigned_rows(Crops,Doubles) :-
        check_doubly_assigned_rows(Crops,[],Doubles).






% switch to planted facts
%
% Kazic, 12.4.2018



% hmmm, this is a bit noisy . . . it will return all rows that are
% planted twice, even with the same line.
%
% want another predicate that filters those rows and only returns rows
% that have two different lines.
%
% Kazic, 1.5.2018


check_doubly_assigned_rows([],A,A).
check_doubly_assigned_rows([Crop|Crops],Acc,Doubles) :-
%        ( bagof(Row,Ma^Pa^planting_index(Ma,Pa,Crop,Row),Bag) ->
%                ( setof(SRow,SMa^SPa^planting_index(SMa,SPa,Crop,SRow),Set) ->

         ( findall(Row,field_planted(Row,Crop),Bag) ->
                 ( setof(SRow,field_planted(SRow,Crop),Set) ->

                        ( lp_subseq(Bag,Set,CropDoubles) ->
                                ( CropDoubles == [] ->
                                        NewAcc = Acc
                                ;
                                        ( CropDoubles \== [] ->
                                                sort(CropDoubles,Sorted),
                                                append(Acc,[Crop-Sorted],NewAcc)
                                        ;
                                                CropDoubles == undef,
                                                NewAcc = Acc,
                                                format('Warning!  the bag of rows for crop ~w is smaller than the set!~n',[Crop])
                                        )
                                )
                        ;


% failure implies the bag is smaller than the set, which seems unlikely
% there is now a test for this in lp_subseq/3
%
% Kazic, 12.4.2018

                                NewAcc = Acc
                        )
                ;
                        sort(Bag,Sorted),
                        append(Acc,[Crop-Sorted],NewAcc)
                )
        ;
                format('Warning! no planting_index/4 facts for crop ~w.~n',[Crop]),
                NewAcc = Acc
        ),
        check_doubly_assigned_rows(Crops,NewAcc,Doubles).












%! check_doubly_assigned_rows_for_different_parents(+Doubles:list,-MultiParents:list) is semidet.


check_doubly_assigned_rows_for_different_parents(Doubles,MultiParents) :-
        check_doubly_assigned_rows_for_different_parents(Doubles,[],MultiParents).


check_doubly_assigned_rows_for_different_parents([],A,A).
check_doubly_assigned_rows_for_different_parents([Crop-DoubledRows|Doubles],Acc,MultiParents) :-
        ( DoubledRows == [] ->
                NewAcc = Acc
        ;
                check_for_different_parents(Crop,DoubledRows,DiffParents),
                append(Acc,[Crop-DiffParents],NewAcc)
        ),
        check_doubly_assigned_rows_for_different_parents(Doubles,NewAcc,MultiParents).








%! check_for_different_parents(+Crop:atom,+DoubledRows:list,-DiffParents:list) is semidet.

check_for_different_parents(Crop,DoubledRows,DiffParents) :-
        check_for_different_parents(Crop,DoubledRows,[],DiffParents).



check_for_different_parents(_,[],A,A).
check_for_different_parents(Crop,[Row|DoubledRows],Acc,DiffParents) :-
        setof(Parent,parents_in_row(Row,Crop,Parent),Parents),
        length(Parents,NumParents),
        ( NumParents > 1 ->
                append(Acc,[Row-Parents],NewAcc)
        ;
                NewAcc = Acc
        ),
        check_for_different_parents(Crop,DoubledRows,NewAcc,DiffParents).
        


parents_in_row(Row,Crop,(Ma,Pa)) :-
        planted(Row,Packet,_,_,PDate,PTime,_,Crop),
        closest_contemporaneous_packet(Crop,Packet,PDate,PTime,Ma,Pa).






% was this row physically planted in a field?  That is, exclude flats and pots.
%
% Kazic, 12.4.2018

%! field_planted(+Row:atom,+Crop:atom) is det.

field_planted(Row,Crop) :-
        planted(Row,_,_,_,_,_,_,Crop),
        once(physical_row(Row,Crop)).












%! make_barcode_elts(+Crop:atom,+Family:int,-BarcodeElts:atom) is nondet?.


make_barcode_elts(Crop,Family,BarcodeElts) :-

        ( fun_corn(Family,Prefix)  ->
                true
        ;
                ( inbred(Family,Prefix) ->
                        true
                ;
                        Prefix = ''
                )
        ),

        atom_length(Family,FamLen),
        ( FamLen < 4 ->
                pad(Family,4,PaddedFamily)
        ;
                PaddedFamily = Family
        ),
        atomic_list_concat([Crop,PaddedFamily,':',Prefix],BarcodeElts).












% moved from analyze_crop.pl

%! identify_rows(+Crop:atom,-Lines:list) is nondet.

identify_rows(Crop,Lines) :-
        setof(Row,Pkt^Ft^Plntr^Date^Time^Soil^planted(Row,Pkt,Ft,Plntr,Date,Time,Soil,Crop),Rows),
        identify_rows(Crop,Rows,Lines).








% it can happen that a new line was planted but its stand count was 0.  In this
% case, a new genotype fact will not be computed; but when computing the field book,
% the absence of the genotype fact will cause identify_row/3 to fail.  So
% I have added a conditional to handle these cases (which first occurred in 15r, to
% the best of my knowledge).
%
% Kazic, 4.8.2015


% many variations here
%
% call: [load_demeter,analyze_crop],identify_rows('09R',[1,10,12,16,26,68,69,117],X).
%
% identify_rows('09R',[9,12,16,17,26,30,36,42,69,96,97,101,103,111,113,116,130,160,161,162,163,180,181,223,256,257,259,265,266,267,268,269,270,271,272,273,274,275,276,281],X),write_list(X).
%
% identify_rows('09R',[t00198,t00199,t00200,t00201,t00202,t00204,t00205,t00206,t00207,t00208,t00209,t00210,t00211,t00212,t00163,t00164,t00165,t00161,t00162,t00167],X),write_list(X).
%
% identify_rows('09R',[t00161,t00162,t00163,t00164,t00165,t00167,t00168,t00170,],X),write_list(X).
%
% identify_rows('13R',[63,64],X).





identify_rows(_,[],[]).
identify_rows(Crop,[Row|Rows],[Line|Lines]) :-
        ( identify_row(Crop,Row,Line) ->
                true
        ;
                format('Warning! identify_row/3 fails for row ~n in crop ~w.~n',[Row])
        ),
        identify_rows(Crop,Rows,Lines).






identify_rows(Crop,StartRow,EndRow,Lines) :-
        identify_rows(Crop,StartRow,EndRow,[],Lines).


identify_rows(_,StartRow,EndRow,L,L) :-
        StartRow is EndRow + 1.

identify_rows(Crop,Row,EndRow,Acc,Lines) :-
        identify_row(Crop,Row,Line),
        append(Acc,[Line],NewAcc),
        Next is Row + 1,
        identify_rows(Crop,Next,EndRow,NewAcc,Lines).












% what is in that row, pot, flat, or minipot?
%
% row identification not confounded by re-use of packet numbers; 
% warnings thrown if no genotype/11 fact present
%
% Kazic, 17.7.2010
%
%
% oops: when computing indices, the most current packet is NOT the one
% needed to identify the row!  The problem is NOT fixed by calling
% contemporaneous_packet/6 with a long ( > 90 days) window.  Want the
% closest contemporaneous packet instead.  Done.
%
% Kazic, 9.12.2010
%
%
% added a test for conflicting packets in a row, due to multiple plantings
% of the same row caused by crop problems.
%
% Kazic, 15.4.2018


%! identify_row(+Crop:atom,+Row:atom,-RowInfo:term) is nondet.


identify_row(Crop,Row,Row-(PRow,F,Ma,Pa,MGma,MGpa,PGma,PGpa,Marker,K)) :-
        build_row(Row,PRow),
        packets_in_row(PRow,Crop,Conflicts,_),

        ( ( Conflicts == [], 
            planted(PRow,Packet,_,_,PDate,PTime,_,Crop) ) ->
                ( closest_contemporaneous_packet(Crop,Packet,PDate,PTime,Ma,Pa) ->
                        track_transplants(Crop,Packet,ActualPacket),

                        ( genotype(PutF,MFam,Ma,PFam,Pa,MGma,MGpa,PGma,PGpa,Marker,K) ->
                                ( current_inbred(Crop,MFam,PFam,F,ActualPacket) ->
                                        true
			        ;
                                        F = PutF
                                )
                        ;


% lines from others or selfs:  deconstruct_plantID fails for 
% made-up temporary plantIDs, such as for popcorn
%
% Kazic, 18.7.2010

                                ( Ma == Pa ->
                                        ( deconstruct_plantID(Ma,_,F,_,_) ->
                                                ( ( genotype(F,F,_,F,_,MGma,MGpa,PGma,PGpa,Marker,K), 
                                                    ( F < 200
                                                    ;


% upper bound was previously 1000, but with the NAM founders, new lines, crop improvement,
% and the interesting popcorn, it''s better to just exclude the true inbreds.
%
% Kazic, 9.6.2012
                                                      F >= 600 ) ) ->
                                                        true
                                                ;
                                                        format('Warning! genotype/11 fact is needed for row ~w, ~w x ~w.~n',[Row,Ma,Pa])
                                                )
                                        ;
                                                format('Warning!  unconsidered case --- perhaps a missing genotype/11 fact --- in identify_row/3, deconstruct_plantID/5 for row ~w, ~w x ~w.~n',[Row,Ma,Pa])
                                        )
                                ;
                                        format('Warning!  unconsidered case --- perhaps a missing genotype/11 fact --- in identify_row/3 for row ~w, ~w x ~w.~n',[Row,Ma,Pa])
                                )
                       )

                ;


% had inserted a stub for the long-packed inbreds in case closest_contemporaneous_packet/6 did
% not handle that case.  However, it seems to manage it quite well, so simply will print a 
% warning message here for now.
%
% Kazic, 9.12.2010

                         format('Warning! closest_contemporanous_packet/6 called from identify_row/3 failed~n',[])
                )
        ;
                format('Warning! there are conflicts or there is no planted/8 record for row ~w of crop ~w!~n',[Row,Crop])
        ).











% if a row has been planted multiple times (as happened in 09R, 10R, 
% 11R, and 12R due to various crop failure-type causes), make sure 
% the same packet has been planted (excluding skips) and warn if otherwise.
%
% Kazic, 15.4.2018


%! find_multiply_planted_rows(?Crop:atom,-MultipleRows:list) is nondet.

find_multiply_planted_rows(Crop,MultipleRows) :-
        bagof(PRow,P^F^O^D^T^S^planted(PRow,P,F,O,D,T,S,Crop),Bag),
        setof(SPRow,SP^SF^SO^SD^ST^SS^planted(SPRow,SP,SF,SO,SD,ST,SS,Crop),Set),
        remove_singletons(Bag,Set,MultipleRows).








%! packets_in_row(+PRow:atom,+Crop:atom,-Conflicts:list,-TotalCl:int) is nondet.


packets_in_row(PRow,Crop,Conflicts,TotalCl) :-
        get_rows_packets(PRow,Crop,Packets),
        sort(Packets,SortedPackets),
        check_for_packet_conflicts(SortedPackets,Conflicts,TotalCl).












% misses the case where the same row is planted with the more than one
% packet that have identical packetIDs but packed at different times.
% This will only find the packet that was packed closest to planting.
%
% Kazic, 14.4.2018

%! get_rows_packets(+PRow:atom,+Crop:atom,-PlantedPackets:list) is nondet.


get_rows_packets(PRow,Crop,PlantedPackets) :-

        findall(PlntgTimeStamp-(Packet,Ma,Pa,Cl),
            (planted(PRow,Packet,_,_,PlntgDate,PlntgTime,_,Crop),
             get_timestamp(PlntgDate,PlntgTime,PlntgTimeStamp),
             closest_contemporaneous_packet_w_cl(Crop,Packet,PlntgDate,PlntgTime,Cl,Ma,Pa)),
                     PlantedPackets).











% what''s a conflict??
% row planted with packets with different sets of parents

%! check_for_packet_conflicts(+PacketsInRow:list,-Conflicts:list,-TotalCl:int) is nondet.


check_for_packet_conflicts(PacketsInRow,Conflicts,TotalCl) :-
        length(PacketsInRow,NumPackets),
        ( NumPackets > 1 -> 
                check_for_packet_conflicts(PacketsInRow,[],IntConflicts,IntCl),
                length(IntConflicts,ConflictLen),
                ( ConflictLen > 1 ->
                        Conflicts = IntConflicts,
                        TotalCl = IntCl
                ;
                        Conflicts = [],
                        TotalCl = 0
                )

        ;
                Conflicts = [],
                TotalCl = 0
        ).









%! check_for_packet_conflicts(+Packets:list,+Acc:list,-Conflicts:list,-SumCl:int) is nondet.


check_for_packet_conflicts([],Acc,Acc,SumCl) :-
        sum_cl(Acc,SumCl).




check_for_packet_conflicts([_-(Packet,Ma,Pa,Cl)|T],Acc,Conflicts,SumCl) :-
        ( Packet == p0000 ->
                NewAcc = Acc
        ;
                ( selectchk(_-(PriorPacket,Ma,Pa,PriorCl),Acc,Rem) ->
                        NewCl is Cl + PriorCl,
                        append(Rem,[_-(PriorPacket,Ma,Pa,NewCl)],NewAcc)

                ;
                        append(Acc,[_-(Packet,Ma,Pa,Cl)],NewAcc)
                )
        ),
        check_for_packet_conflicts(T,NewAcc,Conflicts,SumCl).










%! sum_cl(+List:list,-Sum:int) is det.

sum_cl(List,Sum) :-
        sum_cl(List,0,Sum).



sum_cl([],Int,Int).
sum_cl([_-(_,_,_,Cl)|T],Int,Sum) :-
        New is Int + Cl,
        sum_cl(T,New,Sum).
























% this assumes I will never have more than 999 rows in a crop!
% that assumption will change in the future!
%
% Kazic, 29.3.2018


%! rowplant_from_plantid(+PlantIDAtom:atom,-RowPlantAtom:atom) is det.

rowplant_from_plantid(PlantIDAtom,RowPlantAtom) :-
        sub_atom(PlantIDAtom,10,5,_,RowPlantAtom).










% find a reasonable number of mutant seed planted in a row, based on the
% row_status/7 fact
%
% Kazic, 8.5.2018


%! estimate_seed(+NumPlants:int,-EstSeed:int) is semidet.


estimate_seed(PaddedRow,Crop,EstSeed) :-
        row_status(PaddedRow,num_emerged(NumPlants),_,_,_,_,Crop),
        ( NumPlants =< 15 ->
                EstSeed = 15
        ;
                ( ( NumPlants > 15,
                    NumPlants =< 20 ) ->
                        EstSeed = 20
                ;
                        ( ( NumPlants > 20,
                            NumPlants =< 30 ) ->
                                EstSeed = 30
                        ;
                                NumPlants > 30,
                                EstSeed = NumPlants
                        )
                )
        ).








%! check_parents(+Ma:atom,+Pa:atom,+Possibilities:list,+Family:int,
%!               +PlntdFamily:int,-Packet:atom,-PackingDate:term) is det.

% Possibilities is always a list, but its elements are of the form 
% either Packet-Date-Timestamp or Ma x Pa


check_parents(Ma,Pa,Possibilities,Family,PlntdFamily,Packet,PackingDate) :-

        ( Possibilities \== [] ->

                ( memberchk(_-_-_,Possibilities) ->
                        grab_parents_from_packets(Possibilities,PossibleParents),
                        ( max_member(p(Ma,Pa,_,Packet,PackingDate),PossibleParents) ->
                                Family == PlntdFamily
                        ;

                                ( Family == PlntdFamily ->
                                        format('Warning! Planted parents ~w x ~w were not in the list of possible parents, but family numbers match for family ~w~n',[Ma,Pa,Family])
                                ;
                                        format('Warning! Planted parents ~w x ~w were not in the list of possible parents and families do not match for plant tag family ~w and planned family ~w~n',[Ma,Pa,Family,PlntdFamily]),
                                        false
                                )
                        )

                ;


% this branch untested so far
%
% Kazic, 12.5.2018

                        atomic_list_concat([Ma,' x ',Pa],CrossedParents),
	
                        ( memberchk(CrossedParents,Possibilities) ->
                                Family == PlntdFamily
	
                        ;
                                ( Family == PlntdFamily ->
                                        format('Warning! Planted parents ~w x ~w were not in the list of possible parents, but family numbers match for family ~w~n',[Ma,Pa,Family])
                                ;
                                        format('Warning! Planted parents ~w x ~w were not in the list of possible parents and families do not match for plant tag family ~w and planned family ~w~n',[Ma,Pa,Family,PlntdFamily]),
                                        false
                                )
                        )
                )
        ;
                false
        ).













%! grab_parents_from_packets(Packets:list,ParentalPairs:list,
%!                           -Packet:atom,-PackingDate:term) is det.


grab_parents_from_packets([],[]).
grab_parents_from_packets([Packet-PackingDate-_|T],
             [p(Ma,Pa,CrossedParents,Packet,PackingDate)|T2]) :-
        packed_packet(Packet,Ma,Pa,_,_,PackingDate,_),
        atomic_list_concat([Ma,' x ',Pa],CrossedParents),
        grab_parents_from_packets(T,T2).









%! get_parental_families(+ParentalGtypes:list,-ParentalFamilies:list) is det.

get_parental_families([],[]).
get_parental_families([(Ma,Pa)|T],[(MaFam,PaFam)|T2]) :-
        get_family(Ma,MaFam),
        get_family(Pa,PaFam),
        get_parental_families(T,T2).







% we have a packet packed on some date, already known to have the right
% ma and pa.  What''s the first crop it could be planted in?


%! find_closest_crop_after_packing(+PackingDate:term,+PackingTime:term,-Crop:atom) is det.


find_closest_crop_after_packing(PackingDate,PackingTime,Crop) :-
        get_timestamp(PackingDate,PackingTime,PackingTimestamp),
        setof(C-Plntg,M^F^D^HD^HF^crop(C,M,F,Plntg,D,HD,HF),CropPlantings),
        group_pairs_by_key(CropPlantings,Grouped),
        get_timestamps_last_plantings(Grouped,CropTimeStamps),
        next_crop(PackingTimestamp,CropTimeStamps,Crop).





get_timestamps_last_plantings([],[]).
get_timestamps_last_plantings([Crop-Grouped|Groups],[TimeStamp-Crop|CropTimeStamps]) :-
        max_member(Grouped,LastPlntg),
        crop(Crop,_,_,LastPlntg,Date,_,_),
        convert_date(Date,_,TimeStamp),
        get_timestamps_last_plantings(Groups,CropTimeStamps).






% ensure the auxiliary predicate will succeed correctly by
% sorting.  Feels dangerous.
%
% Kazic, 12.5.2018

%! next_crop(+PackingTimestamp:int,+CropTimeStamps:list,-Crop:atom) is det.

next_crop(PackingTimestamp,CropTimeStamps,Crop) :-
        sort(CropTimeStamps,Sorted),
        next_crop_aux(PackingTimestamp,Sorted,Crop).




% ooooh, dangerous logic; nextto instead?
%
% Kazic, 12.5.2018

next_crop_aux(_,[],Crop) :-
        var(Crop),
        false.

next_crop_aux(PackingTimestamp,[Timestamp-Candidate|T],Crop) :-
        ( Timestamp =< PackingTimestamp ->
                next_crop_aux(PackingTimestamp,T,Crop)
        ;
                Timestamp > PackingTimestamp,
                Crop = Candidate
        ).


