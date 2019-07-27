% this is ../c/maize/demeter/code/genetic_utilities.pl

    
%declarations%


:-      module(genetic_utilities, [
                add_padding/3,
                all_crops/1,
                all_mutants/1,
		all_preps_except_shootbagging/2,
		annotate_string/3,
                append_to_planning_file/2,
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
                check_inventory/4,
                check_mutant_arg/0,
                check_parents/7,
                check_predicate_format/1,
                check_quantity_cl/3,
                closest_contemporaneous_packet/6,
                closest_contemporaneous_packet_w_cl/7,
                closest_contemporaneous_packet_by_crop/6,
                construct_crop_relative_dirs/4,
                construct_plantIDs/4,
                contemporaneous_packet/6,
                convert_crop/2,
                convert_parental_syntax/2,
                crop_ancestor/3,
                crop_improvement/2,
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
		determine_planting/3,
		disassemble_plantID/8,
                estimate_seed/3,
                extract_row/2,
                filter_by_date/3,
                find_all_mutants/1,
		find_all_plantings_of_line/5,
                find_closest_crop_after_packing/3,
                find_current_stand_count/3,
                find_descendants_of_lines_wo_genotypes/1,
		find_family/3,
                find_max/3,
		find_multiply_planted_rows/2,
                find_plan/2,
                founder/9,
                fun_corn/2,
		fuzzy_greater/2,		
		fuzzy_max/3,
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
		get_true_planting/13,
                get_year/2,
                grab_male_rows/2,
                grab_parents_from_packets/2,
		greater/2,
		has_fungus/2,
                identify_row/3,
                identify_rows/2,
                identify_rows/3,
                identify_rows/4,
                inbred/3,
                inbred/2,
                index_by_ears/4,
                inferred_stand_count/6,
		is_earlier/2,
		is_greater/2,
                issue_warning/2,
		load_crop_planning_data/1,
                make_barcode_elts/3,		       
                make_indices/5,
                make_frpc_index/1,
                make_rest_of_indices/2,
                make_planting_index/1,
                make_rowplant/3,
		max/3,
                most_recent_crop/1,
                most_recent_datum/2,
                mutant/1,
                mutant_rows/3,
%                nonrow/1,
		next_crop/3,
                nonzero_stand_count/2,
                mutant_by_family/1,
                open_planning_warning_file/5,
		output_data/3,
                output_header/3,
                packet/1,
                packets_in_row/4,
                pad/3,
                plan_includes/3,
                pot/1,
		reorganize_plan/3,
%		remove_family/2,
		remove_padding/2,
		remove_padding_aux/2,
		remove_padding_list/2,
		remove_row_prefix/2,
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
                skip/1,
		sleeve/1,
                sort_by_crop/3,
                sort_by_male_rows/2,
                split_crops/2,
                tassel_bagged/2,
                timestamped_packet/5,
                timestamped_packet/6,
                track_transplants/3,
                track_transplants_from_parents/4,
                track_transplants_to_row/3,
                unsplit_crop/3,
                unsplit_crops/2,
		was_planted/9,
		wild_type/1,
                winter_nursery/2,
                write_list_facts_w_skips/2,
                write_undecorated_list/2,
                year_from_crop/2

                ]).




    
:-      use_module(demeter_tree('data/load_data')),
        use_module(demeter_tree('code/demeter_utilities')).

    


%end%






% these predicates now ported to swipl 7.6.4.  Many have been simplified ;-).
%
% Code calling these predicates may fail, as I haven''t yet resolved all related
% calls in all the external code.
%
% There may be some logical redundancy among predicates, though I did prune some.
%
% Kazic, 30.3.2018 -- 23.5.2018


    







%%%%%%%%%%%%%%%%%%%%%%%%% index construction predicates %%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Kazic, 22.5.2018



% use often to keep the indices current!  ---- split call no longer needed.
%
%
% doubly_assigned rows now permanently fixed in the planted/8 facts.
% So check for them, but carry on.  Maybe someday I''ll write the incremental update
% code to save computational time.  That''s been on the horizon since 9.12.2010 ;-).
%
% Kazic, 22.5.2018
%
%
%
% added an index of frpc: family, rowplant, crop, numerical genotype 
% formed from every fact that has a numerical genotype
% to facilitate finding missing genotypes.
%
% Kazic, 25.5.2018
%
%
% call is: make_indices('../data/barcode_index.pl','../data/frpc_index.pl','../data/planting_index.pl','../data/crop_rowplant_index.pl','../data/row_members_index.pl'). 
%    
% Kazic, 29.5.2018









%! make_indices(+BarcodeFile:atom,+FRPCFile:atom,+PltngFile:atom,+RPFile:atom,+RMFile:atom) is semidet.
    
make_indices(BarcodeFile,FRPCFile,PltngFile,RPFile,RMFile) :-
        abolish(barcode_index/7),
        abolish(frpc_index/4),
        abolish(planting_index/4),
        abolish(crop_rowplant_index/4),
        abolish(row_members_index/3),
        make_barcode_index(BarcodeFile),
        make_frpc_index(FRPCFile),
        make_planting_index(PltngFile),
        make_rest_of_indices(RPFile,RMFile).






    





    
% expand_file_name/2 will get just the plant tags'' barcodes, saving
% a lot of time and choice points.  But in the end, it was faster and easier
% to just call a perl script!  Note the script assumes the DefaultOrgztn found
% in ../../label_making/Typesetting/DefaultOrgztn.pm.
%
%
% Note these barcodes will fail the perl script:
%
% 06R200:SI105.106
% 06R300:W0I71.111
% 06R300:W0I71.114
% 06R300:WI105.201
%
% There were some truncated barcodes in 08R of the form
%
% 08R201:S00001
%
% that will also fail.
%
%
% Finally, there are a number of 16-character barcodes 
% in 08G mutants, 11N inbreds, and 13R inbreds --- somehow an
% extra 0 was stuffed into the rowplant field.  This extra zero was
% removed during the perl script.  
%
% I checked for any 16-character barcodes in the demeter data using
% any_recorded_numerical_genotype/1 and setting the atom_length to 16.  
% This found a few in the 11n cross_prep data for the crop improvement
% lines, which I fixed.
%
% Kazic, 30.5.2018

    
%! make_barcode_index(+BarcodeFile:atom) is det.

    
% https://unix.stackexchange.com/questions/45583/argument-list-too-long-how-do-i-deal-with-it-without-changing-my-command
%
% 
% bash-3.2$ 'echo [01]*/*:*.eps | xargs ls | grep  [PLE] > bcs_popcorn'
% 
% and inspection.
%
%
% Kazic, 29.5.2018



    
make_barcode_index(BarcodeFile) :-
        format('making barcode_index~n',[]),     
        atom_concat('../../crops/scripts/make_barcode_index.perl ',BarcodeFile,Cmd),
        shell(Cmd).

    


%! make_frpc_index(+FRPCFile:atom) is semidet.

make_frpc_index(FRPCFile) :-
        format('making frpc_index~n',[]),     
        setof(NumG,any_recorded_numerical_genotype(NumG),NumGs),
        make_frpc_facts(NumGs,ProtoFacts),
        sort(ProtoFacts,Facts),
        output_data(FRPCFile,frpc,Facts).




any_recorded_numerical_genotype(NumG) :-
        (
           cross(NumG,_,_,_,_,_,_,_)
        ; 
           cross(_,NumG,_,_,_,_,_,_)
        ;
           cross_prep(NumG,_,_,_,_)
        ;
           ear(NumG,_,_,_,_)
        ;
           genotype(_,_,NumG,_,_,_,_,_,_,_,_)
        ;
           genotype(_,_,_,_,NumG,_,_,_,_,_,_)
        ;
           harvest(NumG,_,_,_,_,_,_)
        ;
           harvest(_,NumG,_,_,_,_,_)
        ;
           image(NumG,_,_,_,_,_,_,_,_)
        ;
           inventory(NumG,_,_,_,_,_,_)
        ;
           inventory(_,NumG,_,_,_,_,_)
        ;
           leaf_alignmt(NumG,_,_,_,_,_)
        ;
           mutant(NumG,_,_,_,_,_,_,_)
        ;
           packed_packet(_,NumG,_,_,_,_,_)
        ;    
           packed_packet(_,_,NumG,_,_,_,_)
        ;
           plant_anatomy(NumG,_,_,_,_,_,_,_)
        ;
           plant_fate(NumG,_,_,_,_)
        ;
           tassel(NumG,_,_,_,_)
        ;
           sample(NumG,_,_,_,_,_,_)
        ),
        atom_length(NumG,15).








    

make_frpc_facts([],[]).
make_frpc_facts([NumG|NumGs],[frpc_index(RowPlant,Crop,Family,NumG)|Facts]) :-
        ( ( get_crop(NumG,Crop),
            get_rowplant(NumG,RowPlant),
            get_family(NumG,Family) ) ->
                true
        ;
                ( atom_length(NumG,16) ->
                        format('Warning! 16-character numerical genotype ~w found in make_frpc_facts/2~n',[NumG])

                ;
                        format('Warning! make_frpc_facts/2 fails on ~w~n',[NumG])
                )
        ),
        make_frpc_facts(NumGs,Facts).




    



    


%! make_planting_index(+PltngFile:atom) is semidet.
    
make_planting_index(PltngFile) :-
        format('making planting_index~n',[]),     
        make_planting_index_aux(PltngFile),
        [load_data:PltngFile],
        check_doubly_assigned_rows(Doubles),
        write_list(Doubles).
%
%        check_doubly_assigned_rows_for_different_parents(Doubles,MultiParents),
%        format('Warning! comment out any early plantings of multiply planted rows in planted/8 facts~n~n',[]),
%        write_list(MultiParents).





    



    




make_planting_index_aux(File) :-
%        setof(planting_index(Ma,Pa,Crop,Row),F^PNum^Cl^Ft^planting(Crop,Row,F,Ma,Pa,PNum,Cl,Ft),Data),
%
% oops, now need the contemporaneous packet!
%
% Kazic, 25.11.2009
%
        all_crops(Crops),
        gather_planting_data(Crops,Data),
        output_data(File,plin,Data).







    
%! all_crops(-Crops:list) is semidet.
    

all_crops(Crops) :-
        setof(Crop,
              Locatn^Fld^Plntg^PltgDate^HarvestStartDate^HarvestStopDate^crop(Crop,Locatn,Fld,Plntg,PltgDate,HarvestStartDate,HarvestStopDate),
              Crops).








%! all_mutants(Mutants:keylist) is det.    


all_mutants(Mutants) :-
        findall(M-K-(Ma,Pa),(genotype(_,_,Ma,_,Pa,_,_,_,_,[M],K),mutant(Pa),M \== '?'),Mutants).
    



gather_planting_data(Crops,Data) :-
        setof(Packet,MaF^PaF^F^Crop^current_inbred(Crop,MaF,PaF,F,Packet),InbredPackets),
        gather_planting_data(InbredPackets,Crops,[],List),
        sort(List,Int),
        pairs_keys_values(Int,_,Data).


gather_planting_data(_,[],A,A).
gather_planting_data(InbredPackets,[Crop|Crops],Acc,Data) :-

        ( setof(Crop-Row-planting_index(Ma,Pa,Crop,Row),for_planting_index(InbredPackets,Ma,Pa,Crop,Row),List) ->
                append(Acc,List,NewAcc)
	;
                NewAcc = Acc
        ),
        gather_planting_data(InbredPackets,Crops,NewAcc,Data).










% amended to use closest_contemporaneous_packet/6
%
% Kazic, 9.12.2010
%
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
%
%
% amended to use list of inbred packets for all crops
%
% Kazic, 22.5.2018



% not physical_row/2 here as that relies on having row_status/7, which we 
% didn''t have until 09R.   
%
% Kazic, 22.5.2018 


% if a genotype/11 fact is missing, we will miss a legit row!
%
% Kazic, 25.5.2018
   
for_planting_index(InbredPackets,Ma,Pa,Crop,Row) :-
        planted(PaddedRow,Packet,_Ft,_Planter,Date,Time,_SoilLevel,Crop),
        sub_atom(PaddedRow,0,1,_,r),
        ( packet(Packet) ->
                ( memberchk(Packet,InbredPackets) ->
                        current_inbred(Crop,_,_,F,Packet),
                        genotype(F,_,Ma,_,Pa,_,_,_,_,_,_)
	        ;
                        closest_contemporaneous_packet(Crop,Packet,Date,Time,Ma,Pa)
		),
                remove_row_prefix(PaddedRow,Row)
	 ;


% hey, we don''t do stand counts on pots

                closest_contemporaneous_packet(Crop,Packet,Date,Time,Ma,Pa),
                track_transplants_to_row(Crop,PaddedRow,Date,PrefixedRow),
                remove_row_prefix(PrefixedRow,Row)
%                format('row: ~w trans: ~w packet: ~w~n',[Row,PaddedRow,Packet])
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
        nonvar(Packet),
        var(Ma),
        var(Pa),
        bagof(PacketTimeStamp-(PMa,PPa),Cl^timestamped_packet(Packet,PMa,PPa,PacketTimeStamp,Cl),Packets),

        get_timestamp(PltngDate,PltngTime,PltngTimeStamp),
        find_closest_prior_datum(Packets,PltngTimeStamp,_-(Ma,Pa)),

        ( crop_ancestor(Crop,Ma,Pa) ->
                true
        ;
                format('Warning! crop_ancestor/3 called from closest_contemporaneous_packet/6 fails for ~w, ~w, ~w x ~w planted on ~w, ~w~n',[Crop,Packet,Ma,Pa,PltngDate,PltngTime])
        ).






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
        ( crop_ancestor(Crop,Ma,Pa) ->
                true
        ;
                format('Warning! crop_ancestor/3 called from closest_contemporaneous_packet/6 fails for ~w, ~w, ~w x ~w planted on ~w, ~w~n',[Crop,Packet,Ma,Pa,PltngDate,PltngTime])
        ).





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
        ( crop_ancestor(Crop,Ma,Pa) ->
                true
        ;
                format('Warning! crop_ancestor/3 called from closest_contemporaneous_packet_by_crop/6 fails for ~w, ~w packed on ~w, ~w x ~w planted on ~w~n',[Crop,Packet,PackingTimeStamp,Ma,Pa,FirstPltngTimeStamp])
        ).








%! closest_contemporaneous_packet_w_cl(+Crop:atom,+Packet:atom,
%!      +PltngDate:term,+PltngTime:term,-Cl:int,-Ma:atom,-Pa:atom) is nondet.

closest_contemporaneous_packet_w_cl(Crop,Packet,PltngDate,PltngTime,Cl,Ma,Pa) :-
        var(Ma),
        var(Pa),
        nonvar(Packet),
        get_timestamp(PltngDate,PltngTime,PltngTimeStamp),
        bagof(PacketTimeStamp-(PMa,PPa,PCl),timestamped_packet(Packet,PMa,PPa,PacketTimeStamp,PCl),Packets),
        find_closest_prior_datum(Packets,PltngTimeStamp,_-(Ma,Pa,Cl)),
        ( crop_ancestor(Crop,Ma,Pa) ->
                true
        ;
                format('Warning! crop_ancestor/3 called from closest_contemporaneous_packet_w_cl/7 fails for ~w, ~w with ~w cl, ~w x ~w planted on ~w, ~w~n',[Crop,Packet,Cl,Ma,Pa,PltngDate,PltngTime])
        ).







%! closest_contemporaneous_packet_w_cl(+Crop:atom,-Packet:atom,
%!    +PltngDate:term,+PltngTime:term,-Cl:int,+Ma:atom,+Pa:atom) is nondet.

closest_contemporaneous_packet_w_cl(Crop,Packet,PltngDate,PltngTime,NumCl,Ma,Pa) :-
        nonvar(Ma),
        nonvar(Pa),
        var(Packet),
        bagof(PacketTimeStamp-(PPacket,PCl),timestamped_packet(PPacket,Ma,Pa,PacketTimeStamp,PCl),Packets),

        get_timestamp(PltngDate,PltngTime,PltngTimeStamp),
        find_closest_prior_datum(Packets,PltngTimeStamp,_-(Packet,NumCl)),
        ( crop_ancestor(Crop,Ma,Pa) ->
                true
        ;
                format('Warning! crop_ancestor/3 called from closest_contemporaneous_packet_w_cl/7 fails for ~w, ~w with ~w cl, ~w x ~w planted on ~w, ~w~n',[Crop,Packet,NumCl,Ma,Pa,PltngDate,PltngTime])
        ).













% just timestamp the packet here and decrease the size of the
% returned data
%
% Kazic, 14.4.2018

%! timestamped_packet(?Packet:atom,?Ma:atom,?Pa:atom,
%!                     -PacketTimeStamp:float,-Cl:int) is nondet.

timestamped_packet(Packet,Ma,Pa,PacketTimeStamp,Cl) :-
        packed_packet(Packet,Ma,Pa,Cl,_,PackingDate,PackingTime),
        get_timestamp(PackingDate,PackingTime,PacketTimeStamp).
        





% to enable transplant tracking
%
% Kazic, 21.5.2018

timestamped_packet(Crop,Packet,Ma,Pa,PacketTimeStamp,Cl) :-
        ( packed_packet(Packet,Ma,Pa,Cl,_,PackingDate,PackingTime) ->
                get_timestamp(PackingDate,PackingTime,PacketTimeStamp)
        ;
                ( track_transplants(Crop,Packet,ActualPacket) ->
                        packed_packet(ActualPacket,Ma,Pa,Cl,_,PackingDate,PackingTime),
                        get_timestamp(PackingDate,PackingTime,PacketTimeStamp)         
                ;
                        format('Warning!  track_transplants/3 fails for packet ~w of crop ~w~n',[Packet,Crop]),
                        false
                )
        ).
        









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
        ( ( nonvar(Crop),
            nonvar(Ma),
            nonvar(Pa) ) ->
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
                )
         ;
                format('Warning! uninstantiated variables passed to genetic_utilities:crop_ancestor/3: crop ~w, ~w x ~w~n',[Crop,Ma,Pa]),
                false
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
% Kazic, 5.5.2009
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



% If nothing ever happens in a row because the stand counts are 0 or uninstantiated, or
% the row was not planted (planted/8 has a row length of 0) --- 
% then there will be no row_members_index computed for a row.  A warning message will be issued
% by pedigrees:get_row_members_index/3.
%
% Kazic, 2.5.2012



% old version really rococo . . . in swipl, it looks like the make_num_gytpes/2
% runs out of stack space in the append/3.
%
% We now have the supporting data for all crops, so just start from there,
% and make it more efficient.
% 
% Kazic, 22.5.2018


%! make_rest_of_indices(+RPFile:atom,+RMFile:atom) is det.


make_rest_of_indices(RPFile,RMFile) :-
        ensure_loaded(load_data:demeter_tree('data/planting_index')),
        make_rest_of_indices_aux(RPFile,RMFile).






make_rest_of_indices_aux(RPFile,RMFile) :-
        open(RPFile,write,RPStream),
        output_header(crp,RPFile,RPStream),
        open(RMFile,write,RMStream),
        output_header(rowm,RMFile,RMStream),
        format('starting crop_rowplant_index and row_members_index~n',[]),     
        make_row_members_facts(RPStream,RMStream),
        close(RPStream),
        close(RMStream).



















% print out on the fly to the two streams
%
% Kazic, 22.5.2018

%! make_row_members_facts(+RPStream:atom,+RMStream:atom) is semidet.


make_row_members_facts(RPStream,RMStream) :-
        setof(Row-(Crop,Family),
              MF^PF^MGma^MGPa^PGma^PGpa^M^K^Ma^Pa^(planting_index(Ma,Pa,Crop,Row),
                      genotype(Family,MF,Ma,PF,Pa,MGma,MGPa,PGma,PGpa,M,K)),RowsFams),
        build_crop_rowplant_facts(RPStream,RMStream,RowsFams).
        












% errors in assigning families to the categories used in make_barcode_elts/3
% will cause back-tracking into make_num_gtypes_aux/4, in turn back-tracking into
% pad/3 in that clause.  pad/3 will produce complaints of the form
%
% Warning! StringOrAtom X is too large to pad to 5 in genetic_utiliies:pad/3
%
% and back-tracking continues indefinitely.  The format/2 calls here show the
% last successful Row-(Crop,Family):  the point of failure that follows that one
% can be found by looking at planting_index/4.
%
% I've made corrections to make_barcode_elts/3 to include the nam_founder/1 condition
% and added my family 620 (the Brink W22-r) to the list of other_peoples_corn/1.
%
%
% nb: my funky 06R inbred I rows will throw the pad/3 warning, but compile anyway.
%
% Kazic, 24.5.2019


build_crop_rowplant_facts(_,_,[]).
build_crop_rowplant_facts(RPStream,RMStream,[Row-(Crop,Family)|RowsFams]) :-
%         format('bcrf/3: row ~w, crop ~w, family ~w~n',[Row,Crop,Family]),
         construct_plant_prefix(Crop,Row,Family,PlantPrefix),
%         format('bcrf/3: row ~w, crop ~w, family ~w, prefix ~w~n',[Row,Crop,Family,PlantPrefix]),
         pad(Row,5,PaddedRow),
         find_current_stand_count(PaddedRow,Crop,NumPlants),
         make_num_gtypes_aux(PlantPrefix,NumPlants,RowNumGtypes),

         write_crop_rowplant_facts(RPStream,Crop,PaddedRow,RowNumGtypes),
%	 arg(1,RowNumGtypes,Foo),
%         format('bcrf/3: row ~w, prow ~w, crop ~w, family ~w, prefix ~w, gtypes ~w ~n',[Row,PaddedRow,Crop,Family,PlantPrefix,Foo]),	 

	 format(RMStream,'row_members_index(~q,~q,~q).~n',[Crop,Row,RowNumGtypes]),
         build_crop_rowplant_facts(RPStream,RMStream,RowsFams).





write_crop_rowplant_facts(_,_,_,[]).
write_crop_rowplant_facts(RPStream,Crop,PaddedRow,[NumGtype|NumGtypes]) :-
        get_plant(NumGtype,Plant),
        format(RPStream,'crop_rowplant_index(~q,~q,~q,~q).~n',[NumGtype,Crop,PaddedRow,Plant]),
        write_crop_rowplant_facts(RPStream,Crop,PaddedRow,NumGtypes).




















% rows before we had stand counts!
%
% Kazic, 1.12.2009

early_row(Crop,Row) :-
        planted(Row,_,_,_,_,_,_,Crop),
        Crop @< '09R'.













% rewritten to handle all ways of passing in parents, including ('Ma,Pa'), 'Ma,Pa', 'Ma x Pa',
% and 'Ma','Pa' in the same predicate
%
% Kazic, 20.7.2019


%! convert_parental_syntax(+CrossAlternatives:list,-Alternatives:list) is semidet.

convert_parental_syntax(CrossAlternatives,Alternatives) :-
        convert_parental_syntax(CrossAlternatives,[],Alternatives).



convert_parental_syntax([],A,A).
convert_parental_syntax([(Ma,Pa)|CrossAlternatives],Acc,Alternatives) :-
        append(Acc,[(Ma,Pa)],NewAcc),
        convert_parental_syntax(CrossAlternatives,NewAcc,Alternatives).



convert_parental_syntax([Ma,Pa|CrossAlternatives],Acc,Alternatives) :-
        atom_length(Ma,15),
	atom_length(Pa,15),
        append(Acc,[(Ma,Pa)],NewAcc),
        convert_parental_syntax(CrossAlternatives,NewAcc,Alternatives).





convert_parental_syntax([Parents|CrossAlternatives],Acc,Alternatives) :-
	atom_length(Parents,Len),
	Len > 30,
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
        format('row ~w, crop ~w~n',[Row,Crop]),
        ( identify_row(Crop,Row,_-(_,Family,_Ma,_Pa,_MaGma,_MaGpa,_PaGma,_PaMutant,_,_)) ->
                find_current_stand_count(Row,Crop,NumPlants),
 
                ( make_num_gtypes(Crop,Row,NumPlants,Family,RowNumGtypes) ->
                        append(Acc,RowNumGtypes,NewAcc)
                ;
                        format('Warning! make_num_gtypes/5 called from make_num_types/3 fails for row ~w of ~w plants in family ~w~n',[Row,NumPlants,Family]),
                        NewAcc = Acc
                )
        ;
                format('Warning! identify_row/3 called from make_num_types/3 fails for crop ~w, row ~w~n',[Crop,Row]),
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
        ( planted(Row,Packet,_,_,Date,Time,_,Crop) ->
          closest_contemporaneous_packet_w_cl(Crop,Packet,Date,Time,NumPlants,Ma,Pa)
        ;


% just assume the summer crop canonical plantings for the early crops or missing data
%
% Kazic, 1.12.2009
%
% well, 06N had 13 cl/row for all rows
%
% Kazic, 9.12.2010
%
%
% we now have packed_packet/7 and planted/8 facts for all crops, 
% but pre-09R crops had no row_status facts.  Optionally, throw a warning message
% if we get here.
%
% Kazic, 22.5.2018


%          format('Warning! guessing stand counts for row ~w of crop ~w using inferred_stand_count/6~n',[Row,Crop]),
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
% Kazic, 1.12.2009

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








% inappropriately named; originally used for generating crop_rowplant_indexs
%
% Kazic, 30.7.2009

deconstruct_plantIDs(NGs,Data) :-
        deconstruct_plantIDs(NGs,[],Data).


deconstruct_plantIDs([],A,A).
deconstruct_plantIDs([G|Gs],Acc,Data) :-
        ( deconstruct_plantID(G,Crop,_,Row,Plant) ->
                append(Acc,[crop_rowplant_index(G,Crop,Row,Plant)],NewAcc)
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




% added clauses in conditional to handle inbreds
%
% Kazic, 25.7.2019

deconstruct_plantID_aux(PlantID,Crop,Family,Row,Plant) :-
        atom_length(PlantID,15),
        get_crop(PlantID,Crop),
        get_family(PlantID,Family),
        get_row(PlantID,PaddedRow),
        get_plant(PlantID,PaddedPlant),
        ( ( PaddedRow \== '00000',
            PaddedRow \== 'xxxxx',
            PaddedRow \== '0xxxx',	    
            PaddedRow \== 'yyyyy',
            PaddedRow \== '0yyyy', 	    
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
%
% if it''s an 06r inbred row, just return the atom

%! remove_row_prefix(+RRow:atom,-Row:intORatom) is semidet.


remove_row_prefix(RRow,Row) :-
        ( integer(RRow) ->
                Row = RRow
        ;
                ( sub_atom(RRow,0,1,_,'r') ->
                        sub_atom(RRow,1,5,_,RowAtom),
                        ( atom_number(RowAtom,Row) ->
                                true
                        ;
                                sub_atom(RRow,_,1,_,'I'),
                                sub_atom(RRow,1,_,0,Row)
                        )
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














% cope with the crazy 06r plantIDs
%
% Kazic, 30.5.2018

%! get_row(+PlantID:atom,-Row:atom) is semidet.


get_row(PlantID,Row) :-
        ( regularize_rowplant(PlantID,UnPrefixedRowPlant) ->
                sub_atom(UnPrefixedRowPlant,RowLen,2,0,_),
                sub_atom(UnPrefixedRowPlant,0,RowLen,2,Row)
        ;
                Row = '00000',
                format('Warning! unconsidered case for plant ~w in get_row/2~n',[PlantID])
        ).











%! get_plant(+PlantID:atom,-Plant:atom) is semidet.

get_plant(PlantID,Plant) :-
        ( regularize_rowplant(PlantID,UnPrefixedRowPlant) ->
                sub_atom(UnPrefixedRowPlant,_,2,0,Plant)
        ;
                Plant = '00',
                format('Warning! unconsidered case for plant ~w in get_plant/2~n',[PlantID])
        ).













% this does not remove the 06r Is, by design.
%
% Kazic, 30.5.2018


%! regularize_rowplant(+PlantID:atom,-UnPrefixedRowPlant:atom) is semidet.


regularize_rowplant(PlantID,UnPrefixedRowPlant) :-
        sub_atom(PlantID,ColonPos,1,_,':'),
        NextChar is ColonPos + 1,
        sub_atom(PlantID,NextChar,_,0,PreRowPlant),
        sub_atom(PreRowPlant,0,1,_,Prefix),
        ( memberchk(Prefix,['S','W','M','B','P','E','L','X']) ->
                sub_atom(PreRowPlant,1,_,0,UnPrefixedRowPlant)
        ;
                UnPrefixedRowPlant = PreRowPlant
        ).


























% get K number by unpadding rowplant of FoundingMale --- only works for a founding male!
%
get_knum(PlantID,KNum) :-
        get_rowplant(PlantID,RowPlant),
        remove_padding(RowPlant,KNum).






% deconstruct the crop particle

get_nursery_from_particle(Crop,Nursery) :-
        sub_atom(Crop,2,1,_,Nursery).


% modified to return year as number, not atom
%
% Kazic, 14.6.2019

get_year_from_particle(Crop,YearSuffix,Year) :-
        sub_atom(Crop,0,2,_,YearSuffix),
        atom_concat('20',YearSuffix,YearAtom),
	atom_number(YearAtom,Year).






% a founder is a line donated by someone: Gerry, USDA Peoria, MGCSC, Guri,
% Damon, Karen, etc.
%
%
% Identifying founders relies on allocating blocks of family numbers below
% 1000.
%
% Family numbers for founders are manually assigned and are always less
% than 1000.  Numbers between 200 and 499 inclusive are reserved for my
% inbred lines: 2** is Mo20W, 3** is W23, 4** is M14, and 5** is B73;
% *[00-49] are selfed, *[51-99] are sibbed.  These are usually made in
% sufficient quantity to last several years, so I believe I will not run
% out of integers.
%
% B73 now occupies the 500s, and inbred lines with the same names as mine,
% but from different sources, are now numbered from 99 backwards.  So with
% the Weil B73 David Braun had in 12r, this is 599.
%
%
% Numerical genotypes of the founders are quite irregular, since they
% originate in other labs, and so will fail
% genetic_utilites:deconstruct_plantID_aux/5.  If a numerical genotype was
% not supplied I construct one: CropOfFirstPlanting * 0 *
% AccessionedFamilyNumber * : * 0000000.  Notice that the family number in
% the numerical genotype is padded so that it is four characters, but in
% the genotype/11 fact it is not.
% 
% Kazic, 21.2.2009


% modified to use mutant_by_family/1, so the record of who is a mutant is
% kept just there.
%
% Kazic, 23.5.2018



% modified to exclude the second generation of crop improvement lines,
% families 655--664, so that those are included in the pedigrees computed
% from families 631--641.  That's the easiest work-around for erroneous
% assignment of family numbers.
%
% expanded to include the founding crop improvement lines and to explicitly
% exclude inbreds.
%
% Kazic, 30.11.2018
%
%
% revised using new family specs --- a reminder, these are dependent on my
% idiosyncratic ordering of family numbers, and will have to be modified
% for yours
%
% Kazic, 1.12.2018
%
%
% in the future, will have to add a clause for four-digit
% founder mutant families
%
%
% fun corn is excluded by setting the upper bound to 890
% if pedigrees of the popcorn are desired, upper bound should
% go to 1000 and a conditional memberchk for popcorn should be
% included



% modified to remove conditional; see founder_cndtnl/9 below for comments.
%
% founder/9 is mainly used in pedigree construction, and I have tested this
% unconditional version there.  I HAVE NOT TESTED THIS VERSION IN
% inventory_checking.pl.
%
% Kazic, 6.3.2019



%! founder(+F:num,-MN:atom,-PN:atom,-MG1:atom,-MG2:atom,
%!                -PG1:atom,-PG2:atom,-Gs:list,-K:atom) is semi-det.


founder(F,MN,PN,MG1,MG2,PG1,PG2,Gs,K) :-
        genotype(F,_,MN,_,PN,MG1,MG2,PG1,PG2,Gs,K),
        F > 0,
        F < 890,
	\+ inbred(F,_),
        \+ nam_founder(F), 
        \+ other_peoples_corn(F),
	\+ crop_improvement_second_gen(F).








% predicate as defined on 1.12.2018.  Since then, I included a genotype/11
% fact for the skipped rows, family = 0000, which causes this predicate to
% fail (or return []) when finding all founders using setof, bagof, or
% findall.  In retrospect, I think the conditional is incorrect logic,
% since if the first set of conditions fails, the predicate fails; and
% including the conditional false guarantees failure no matter what.  So I
% have placed the conditional version here for reference.
%
% Kazic, 6.3.2019

founder_cndtnl(F,MN,PN,MG1,MG2,PG1,PG2,Gs,K) :-
        ( genotype(F,_,MN,_,PN,MG1,MG2,PG1,PG2,Gs,K) ->
                F > 0,
                F < 890,
	        \+ inbred(F,_),
                \+ nam_founder(F), 
                \+ other_peoples_corn(F),
		\+ crop_improvement_second_gen(F)
        ;
                false
        ).










%%%%%%%%% specification of family blocks, according to table in ../data/genotype.pl %%%%%%%
%
% revised to specify blocks of families more cleanly
%
% Kazic, 30.11.2018



inbred(Family,InbredPrefix) :-
	Family > 199,
	Family < 600,
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










%! nam_founder(+Family:int) is det.

nam_founder(Family) :-
	memberchk(Family,[194,195,196,197,198,199,
			  600,601,602,603,604,605,606,607,608,609,
			  610,611,612,613,614,615,616,617,618,619,
			  629]).










% corn I planted for other people who are not Gerry Neuffer, such as Jason Green
%
% right now this is just Jason's corn
%
% Kazic, 1.6.2018

% added the Brink W22R-r
%
% Kazic, 24.5.2019


%! other_peoples_corn(+Family:int) is det.

other_peoples_corn(Family) :-
         memberchk(Family,[620,623,624,625,626,627]).












% the crop improvement families, which end up with suitable particles
% in every generation.  This means that construct_plant_prefix/4
% must test for 4-digit crop improvement families and pad rows to 4 digits
% only.
%
% Kazic, 1.6.2018


%! crop_improvement(+Family:int,-Prefix:atom) is semidet.

crop_improvement(Family,Prefix) :-
        ( memberchk(Family,[631,632,633,634,655,656,4118,4119]),
          Prefix = 'S' )
        ;
        ( memberchk(Family,[635,636,637,638,639,657,658]),
          Prefix = 'W' )
        ;

        ( memberchk(Family,[640,641,659,660,661,662]),
          Prefix = 'M' )
        ;

        ( memberchk(Family,[663,664,4116,4117]),
          Prefix = 'B' ).
        




% to kludge around incorrect family assignment for the second
% generation of crop improvement, distinguish the founding
% members from the remainder
%
% Kazic, 1.12.2018

crop_improvement_founder(Family,Prefix) :-
        ( memberchk(Family,[631,632,633,634]),
          Prefix = 'S' )
        ;
        ( memberchk(Family,[635,636,637,638,639]),
          Prefix = 'W' )
        ;

        ( memberchk(Family,[640,641]),
          Prefix = 'M' )
        ;

        ( memberchk(Family,[663,664]),
          Prefix = 'B' ).
        




crop_improvement_second_gen(Family) :-
        memberchk(Family,[655,656,657,658,659,660,661,662]).









% popcorn P
% sweet E
% elite L

%! fun_corn(+Family:int,-FunCorn:atom) is det.

fun_corn(Family,FunCornPrefix) :-
	Family >= 890,
	Family =< 999,
        ( elite(Family,FunCornPrefix)
        ;
	  sweet_corn(Family,FunCornPrefix)
	;
	  popcorn(Family,FunCornPrefix)
	).



elite(Family,'L') :-
	memberchk(Family,[890,891]).


sweet_corn(Family,'E') :-
        memberchk(Family,[892,893,894,895,897,897,898,899,990,991]).


popcorn(Family,'P') :-
        Family >= 900,
	Family =< 999,
	\+ sweet_corn(Family,_).








% covers Gerry''s 11n families

%! gerry_families(+Family:int) is det.

gerry_families(Family) :-
        Family >= 3332,
        Family =< 3393.










% we now skip rows for computer vision experiments, so detect that
%
% detect by either:
%     maternal numerical genotype
%     standard packet number
%     number of kernels planted
%
% Kazic, 23.7.2019

skip('06R0000:0000000').
skip(p00000).
skip(0).




genotype(NumGType,GType) :-
        crop_rowplant_index(NumGType,Crop,Row,_),
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
% 
% slightly reorganized to test what''s passed in and whether it needs conversion,
% rather than relying on argument order.
%
% Kazic, 31.5.2018


%! convert_crop(?UpperCaseCrop:atom,?LowerCaseCrop:atom) is semidet.


convert_crop(UpperCaseCrop,LowerCaseCrop) :-
        ( ( nonvar(UpperCaseCrop),
            var(LowerCaseCrop) ) ->
                sub_atom(UpperCaseCrop,2,1,_,Season),
                ( letter(LSeason,Season) ->
                        sub_atom(UpperCaseCrop,0,2,_,Year),
                        atomic_list_concat([Year,LSeason],LowerCaseCrop)
                ;        
                        letter(Season,_),
                        LowerCaseCrop = UpperCaseCrop
                )
        ;
                var(UpperCaseCrop),
                nonvar(LowerCaseCrop),
                sub_atom(LowerCaseCrop,2,1,_,Season),
                ( letter(Season,USeason) ->
                        sub_atom(LowerCaseCrop,0,2,_,Year),
                        atomic_list_concat([Year,USeason],UpperCaseCrop)
                ;
                        letter(_,Season),
                        UpperCaseCrop = LowerCaseCrop
                )
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











%! annotate_string(+Prefix:atom,+StringOrList,-Annotated:string) is semidet.

annotate_string(Prefix,StringOrList,Annotated) :-
	( is_list(StringOrList) ->
	        ( StringOrList == [] ->
	                Merged = ''
		;
	                atomic_list_concat(StringOrList,', ',Merged)
                )
	;
	        Merged = StringOrList
	),
        ( Merged == '' ->
                Annotated = Merged
        ;
	        atomic_list_concat([Prefix,':  ',Merged,'.  '],Annotated)
        ).





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
        ( sub_atom(File,0,3,_,'../') ->
                sub_atom(File,3,_,0,SansDots)
        ;
                SansDots = File
        ),
        format(Stream,'% this is ../c/maize/demeter/~w~n~n',[SansDots]),
        utc_timestamp_n_date(UTCTimeStamp,Date),
        format(Stream,'% generated on ~w (= ~w) by~n',[Date,UTCTimeStamp]),
        output_header_aux(Switch,Stream). 




output_header_aux(brcd,Stream) :-
        format(Stream,'% genetic_utilities:make_barcode_index/7.~n~n~n',[]),
        format(Stream,'% barcode_index(RowNum,Crop,Plant,RowPlant,Family,PostColon,Barcode).~n~n~n',[]).



output_header_aux(crp,Stream) :-
        format(Stream,'% genetic_utilities:make_crop_row_plant/1.~n~n~n',[]),
        format(Stream,'% crop_rowplant_index(NumericalGenotype,Crop,Row,Plant).~n~n~n',[]).



output_header_aux(fake,Stream) :-
        format(Stream,'% clean_data:confect_planting_n_stand_count_data/4.~n~n~n',[]),
        format(Stream,'% Two types of FAKE data generated for computing plant tags and field book.~n',[]),
        format(Stream,'% Plntr, Dates, Times, NumEmerged, Phenotypes, and Observer all faked.~n~n~n',[]),
        format(Stream,'% planted(Row,Packet,Plntr,Date,Time,Soil,Crop).~n~n~n',[]),
        format(Stream,'% row_status(Row,NumEmerged,Phenotypes,Obsrvr,Date,Time,Crop).~n~n~n',[]).



output_header_aux(plin,Stream) :-
        format(Stream,'% genetic_utilities:make_planting_index/1.~n~n~n',[]),
        format(Stream,'% planting_index(MaNumGType,PaNumGType,Crop,Row).~n~n~n',[]).


output_header_aux(rowm,Stream) :-
        format(Stream,'% genetic_utilities:make_row_members_index/1.~n~n~n',[]),
        format(Stream,'% row_members_index(Crop,Row,ListRowMembers).~n~n~n',[]).


output_header_aux(frpc,Stream) :-
        format(Stream,'% genetic_utilities:make_rpc_index/1.~n~n~n',[]),
        format(Stream,'% frpc_index(RowPlant,Crop,Family,NumericalGenotype).~n~n~n',[]).



output_header_aux(plan,Stream) :-
        format(Stream,'% genetic_utilities:find_plan/2.~n~n~n',[]),
        format(Stream,'% plan(MaNumGtype,PaNumGtype,Planting,PlanList,Notes,Crop).~n~n~n',[]).

 

output_header_aux(pkt,Stream) :-
        format(Stream,'% analyze_crop:repack_packets/3.~n~n~n',[]),
        format(Stream,'% Sleeve-(MaNumGtype,PaNumGtype,Row).~n~n~n',[]).


output_header_aux(mutls,Stream) :-
        format(Stream,'% analyze_crop:identify_mutant_row_plans/2.~n~n~n',[]),
        format(Stream,'% Row  Planting KNum   Family             Ma  x  Pa~n%       Genotype~n%       Plan~n%       Notes~n~n~n',[]).




output_header_aux(muts,Stream) :-
        format(Stream,'% genetic_utilities:find_all_mutants/1.~n~n~n',[]),
        format(Stream,'% Sorted list of all markers of interest in genotype/11~n~n~n',[]).





output_header_aux(plntags,Stream) :-
        format(Stream,'% crop_management/generate_plant_tags_file/3.~n~n~n',[]),
        format(Stream,'% Data for label_making/make_plant_tags.perl, using priority_rows/2.~n~n~n',[]).



output_header_aux(self,Stream) :-
        format(Stream,'% crop_management:all_mutant_rows_for_selfing/2 called in daily_status_report/3.~n~n~n',[]),
        format(Stream,'% Row-SelfingStatus.~n~n~n',[]).


output_header_aux(tslw,Stream) :-
        format(Stream,'% crop_management:tassel_watch/2 called in daily_status_report/3.~n~n~n',[]),
        format(Stream,'% RowPlant-(TasselStatus,StatusDay,Plan,ToDo).~n~n~n',[]).


output_header_aux(dads,Stream) :-
        format(Stream,'% crop_management:find_daddies/2 called in daily_status_report/3.~n~n~n',[]),
        format(Stream,'% RowPlant-(PlantID,PreviousFemales,Plan,ToDo).~n~n~n',[]).


output_header_aux(scor,Stream) :-
        format(Stream,'% crop_management:find_rows_to_score/3 called in daily_status_report/3.~n~n~n',[]),
        format(Stream,'% RowToScore.~n~n~n',[]).





output_header_aux(silk,Stream) :-
        format(Stream,'% crop_management:find_silking_ears/2 called in daily_status_report/3.~n~n~n',[]),
        format(Stream,'% Ear-OrderedListSilkingDates.~n~n~n',[]).


output_header_aux(orph,Stream) :-
        format(Stream,'% crop_management:find_orphan_tassels/3 called in daily_status_report/3.~n~n~n',[]),
        format(Stream,'% double-check output against the field and against all possible selfs!~n~n~n',[]),
        format(Stream,'% RowPlant-(PlantID,Day,Mon,Time).~n~n~n',[]).


output_header_aux(tocr,Stream) :-
        format(Stream,'% crop_management:find_rows_to_cross/3 called in daily_status_report/3.~n~n~n',[]),
        format(Stream,'% Row-SoFar.~n~n~n',[]).


output_header_aux(phto,Stream) :-
        format(Stream,'% crop_management:find_crossed_plants_to_photo/2.~n~n% **** Be sure to check plant for ALL blue twist-ties! ****~n~n~n',[]),
        format(Stream,'% PlantToPhotograph.~n~n~n',[]).



output_header_aux(uphto,Stream) :-
        format(Stream,'% crop_management:find_uncrossed_plants_to_photo/1.~n~n% **** Be sure to check plant for ALL blue twist-ties! ****~n~n~n',[]),
        format(Stream,'% PlantToPhotograph.~n~n~n',[]).



output_header_aux(harv,Stream) :-
        format(Stream,'% crop_management:order_harvest/2.~n~n% **** Be sure to check row for ALL ears! ****~n~n~n',[]),
        format(Stream,'% EarToHarvest.~n~n~n',[]).




output_header_aux(harvi,Stream) :-
        format(Stream,'% crop_management:harvest_inbred_selfs/2.~n~n% **** Be sure to check row for ALL ears! ****~n~n~n',[]),
        format(Stream,'% EarToHarvest.~n~n~n',[]).



output_header_aux(harvg,Stream) :-
        format(Stream,'% crop_management:find_goofs/2.~n~n% **** Spoil bags --- DO NOT HARVEST! ****~n~n~n',[]),
        format(Stream,'% BagToSpoil.~n~n~n',[]).



output_header_aux(harve,Stream) :-
        format(Stream,'% crop_management:harvested_early/2.~n~n~n',[]),
        format(Stream,'% (Ma,Pa,DifferenceInDays).~n~n~n',[]).




output_header_aux(harvu,Stream) :-
        format(Stream,'% crop_management:find_unrecorded_pollinations/2.~n~n~n',[]),
        format(Stream,'% Ma,Pa.~n~n~n',[]).


output_header_aux(tags,Stream) :-
        format(Stream,'need_tags:need_tags/2.~n~n~n',[]),
        format(Stream,'% PlantID.~n~n~n',[]).




output_header_aux(plano,Stream) :-
        format(Stream,'% pack_corn:pack_corn/1.~n~n~n',[]),
        format(Stream,'% plan(Ma,Pa,Planting,Instructions,Notes,Crop).~n~n~n',[]).




output_header_aux(plntg,Stream) :-
        format(Stream,'order_packets:insert_later_packets_in_row/6.~n~n~n',[]),
        format(Stream,'% Row ~10|Packet ~23|Sequence Number~n~n~n',[]).



output_header_aux(replant,Stream) :-
        format(Stream,'% crop_management:find_rows_to_replant/2.~n~n~n',[]),
        format(Stream,'% Row-(Packet,Seq,Ma,Pa,ClNeeded)   packets sorted into packing order!~n~n~n',[]).






% catch-all cases for the rest

output_header_aux(foo,Stream) :-
        format(Stream,'% some predicate; file is likely to be temporary.~n~n~n',[]).

output_header_aux(bar,Stream) :-
        format(Stream,'% some predicate; file is likely to be temporary.~n~n~n',[]).




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


% works fine for iphone 6S
%
% Kazic, 1.8.2018

write_plans_for_ipad(Stream,[Row-Marker-(Family,Ma,Pa,MGma,MGpa,PGma,PGpa,K,Plan,Notes,Plntg)|Rows]) :-
        write_plans_for_ipad(Stream,_,[Row-Marker-(Family,Ma,Pa,MGma,MGpa,PGma,PGpa,K,Plan,Notes,Plntg)|Rows]).



write_plans_for_ipad(_,_,[]).
write_plans_for_ipad(Stream,PriorMarker,[Row-Marker-(Family,Ma,Pa,MGma,MGpa,PGma,PGpa,K,Plan,Notes,Plntg)|Rows]) :-
        ( ( Marker == PriorMarker
          ;
            var(Marker) ) ->
                NewMarker = PriorMarker,
                format(Stream,'~d ~8|~w  ~16|~w  ~24|~w  ~30|~w x ~w~n~8|(~w,~w,~w,~w)~n~8|~w~n~8|~w~n~n~n',[Row,Plntg,K,Family,Ma,Pa,MGma,MGpa,PGma,PGpa,Plan,Notes])
        ;
                NewMarker = Marker,
                format(Stream,'~n~n%%%%% ~w %%%%%~n~n~d ~8|~w  ~16|~w  ~24|~w  ~30|~w x ~w~n~8|(~w,~w,~w,~w)~n~8|~w~n~8|~w~n~n~n',[Marker,Row,Plntg,K,Family,Ma,Pa,MGma,MGpa,PGma,PGpa,Plan,Notes])
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

%! pad(+StringOrAtom:atom,+TotalLengthNeeded:int,-PaddedString:atom) is semidet.


pad(StringOrAtom,TotalLengthNeeded,PaddedString) :-
        atom_length(StringOrAtom,Len),
        NumCharsNeeded is TotalLengthNeeded - Len,
        ( NumCharsNeeded =:= 0 ->
                PaddedString = StringOrAtom
        ;
                ( add_padding(NumCharsNeeded,StringOrAtom,PaddedString) ->
                        true
                ;
                        format('Warning! StringOrAtom ~w is too large to pad to ~w in genetic_utiliies:pad/3~n',[StringOrAtom,TotalLengthNeeded]),
                        PaddedString = StringOrAtom
                )
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






check_inventory(Ma,Pa,Sleeve,RNum) :-
        setof(TS-(Ma,Pa,Num,FSleeve),timestamp_inventory(Ma,Pa,Num,FSleeve,TS),List),
        reverse(List,[_-(Ma,Pa,num_kernels(RNum),Sleeve)|_]),
	( harvest(Ma,Pa,_,_,_,_,_) ->
	        check_ear_status(Ma)
        ;
                true
        ).




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










% for comparing amounts of kernels for choose_lines:pick_best/5
% modelled on find_max/3 and dependents
%
% Kazic, 21.7.2019


is_greater(Term1,Term2) :-
        ( ( number(Term1),
            number(Term2) ) ->
                    ( Term1 >= Term2 ->
                            true
                    ;
                            false
                    )
        ;
                    ( ( \+ number(Term1),
                        \+ number(Term2) ) ->
                            greater(Term1,Term2)
                    ;
                            ( ( number(Term1),
                                \+ number(Term2) ) ->
                                    fuzzy_greater(Term1,Term2)
                            ;
                                    \+ number(Term1),
                                    number(Term2),
                                    fuzzy_greater(Term2,Term1)
                            )
                    )
        ).
               




greater(X,X).

greater(whole,_).

greater(three_quarter,half).
greater(three_quarter,quarter).
greater(three_quarter,eighth).
greater(three_quarter,sixteenth).

greater(half,quarter).
greater(half,eighth).
greater(half,sixteenth).

greater(quarter,eighth).
greater(quarter,sixteenth).

greater(eighth,sixteenth).






fuzzy_greater(Num,Term) :-
        ( Num >= 200 ->
                is_greater(whole,Term)
        ;
                ( Num >= 100 ->
                        is_greater(half,Term)
                ;
                        ( Num >= 50 ->
                                is_greater(quarter,Term)
                        ;
                                format('Warning!  low kernel count for ~w cl!~n',[Num])
                        )
                )
        ).












% transplanted from choose_lines.pl, not sure these are really needed,
% but the model for is_greater/2 and dependents
%
% Kazic, 21.7.2019

find_max(Term1,Term2,Term1) :- 
        Term1 == Term2.
find_max(Term1,Term2,Max) :-
        ( ( number(Term1),
            number(Term2) ) ->
                    ( Term1 >= Term2 ->
                            Max = Term1
                    ;
                            Max = Term2
                    )
        ;
                    ( ( \+ number(Term1),
                        \+ number(Term2) ) ->
                            max(Term1,Term2,Max)
                    ;
                            ( ( number(Term1),
                                \+ number(Term2) ) ->
                                    fuzzy_max(Term1,Term2,Max)
                            ;
                                    \+ number(Term1),
                                    number(Term2),
                                    fuzzy_max(Term2,Term1,Max)
                            )
                    )
        ).
               




% need all combinations in both directions!

max(X,X,X).

max(whole,_,whole).
max(_,whole,whole).

max(three_quarter,half,three_quarter).
max(half,three_quarter,three_quarter).
max(three_quarter,quarter,three_quarter).
max(quarter,three_quarter,three_quarter).
max(three_quarter,eighth,three_quarter).
max(eighth,three_quarter,three_quarter).
max(three_quarter,sixteenth,three_quarter).
max(sixteenth,three_quarter,three_quarter).

max(half,quarter,half).
max(quarter,half,half).
max(half,eighth,half).
max(eighth,half,half).
max(half,sixteenth,half).
max(sixteenth,half,half).

max(quarter,eighth,quarter).
max(eighth,quarter,quarter).
max(quarter,sixteenth,quarter).
max(sixteenth,quarter,quarter).

max(eighth,sixteenth,eighth).
max(sixteenth,eighth,eighth).





        


fuzzy_max(Num,Term,Max) :-
        ( Num >= 200 ->
                find_max(whole,Term,Max)
        ;
                ( Num >= 100 ->
                        find_max(half,Term,Max)
                ;
                        ( Num >= 24 ->
                                find_max(quarter,Term,Max)
                        ;
                                format('Warning!  low kernel count for ~w cl!~n',[Num])
                        )
                )
        ).




% if we're in the same crop and one of the lines is an inbred, make
% sure the other is the same inbred

is_earlier(NumGtype1,NumGtype2) :-
        ( NumGtype1 == NumGtype2 ->
                true
        ;
                disassemble_plantID(NumGtype1,Crop1,Yr1,_,FirstMon1,Family1,Row1,Plant1),
                disassemble_plantID(NumGtype2,Crop2,Yr2,_,FirstMon2,Family2,Row2,Plant2),
                ( Crop1 == Crop2 ->
		        ( Row1 < Row2 ->
		                ( ( inbred(Family1,InbredPrefix),
		                    inbred(Family2,InbredPrefix) ) ->
			                true
			        ;  
                                        mutant_by_family(Family1),
                                        mutant_by_family(Family2)
                                )
			;
                                Row1 == Row2, 
                                Plant1 < Plant2
                        ;
		                false
                        )

                ;
                        ( Yr1 < Yr2 ->
		                true
                        ;
                                ( Yr1 > Yr2 ->
			                false
			        ;
                                        Yr1 == Yr2,
				        ( FirstMon1 =< FirstMon2 ->
				                ( Row1 < Row2 ->
                                                        true	    
                                                ;
                                                        Row1 == Row2, 
                                                        Plant1 < Plant2
                                                )
					;
		  	                        false
                                        )
			        )
		        )
                )
	).



	



%! disassemble_plantID(+NumGtype:atom,-Crop:atom,-Yr:integer,-Nursery:atom,-FirstMon:integer,
%                      -Family:integer,-Row:integer,Plant:integer).
	
disassemble_plantID(NumGtype,Crop,Yr,Nursery,FirstMon,Family,Row,Plant) :-	
        deconstruct_plantID(NumGtype,Crop,Family,Row,Plant),
        get_year_from_particle(Crop,_,Yr),
	get_nursery_from_particle(Crop,Nursery),
        crop_months(Nursery,[FirstMon|_]).















% only for ears that have harvest facts!
%
% Kazic, 7.5.20211
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








% if the ear has fungus, the predicate is true; note call from
% choose_lines:choose_line/3.
%
% Kazic, 20.7.2019

has_fungus(Ma,Pa) :-
        harvest(Ma,Pa,succeeded,Comment,_,_,_),
        ( var(Comment) ->
                false
        ;
	        ( sub_atom(Comment,_,_,_,fungus) ->
                        true
                ;
                        false
                )
	).





find_all_mutants(File) :-
        setof(Mutants,F^MF^MN^PF^PN^MGM^MGP^PGM^PGP^K^genotype(F,MF,MN,PF,PN,MGM,MGP,PGM,PGP,Mutants,K),L),
        flatten(L,Flat),
        sort(Flat,ListMuts),
        output_data(File,muts,ListMuts).







% for converting old genotype and source facts to the new ones
%
% Kazic, 1.8.2009

build_numerical_genotype(F,Crop,DummyNumGType) :-
        F < 1000,
        pad(F,4,PaddedF),
        atomic_list_concat([Crop,PaddedF,':0000000'],DummyNumGType).
















construct_plantIDs(Crop,Row,Family,Plants) :-
        construct_plant_prefix(Crop,Row,Family,PlantIDPrefix),
        find_current_stand_count(Row,Crop,NumPlants),
        build_row_members(PlantIDPrefix,NumPlants,Plants).
       






% accomodate the crop improvement families, which end up with suitable particles
% in every generation.  This means that construct_plant_prefix/4
% must test for 4-digit crop improvement families and pad rows to 4 digits
% only.
%
% Kazic, 1.6.2018


%! construct_plant_prefix(+Crop:atom,+Row:int,+Family:int,-PlantIDPrefix:atom) is semidet.


construct_plant_prefix(Crop,Row,Family,PlantIDPrefix) :-
        make_barcode_elts(Crop,Family,BarcodeElts),
        ( crop_improvement(Family,_) ->
                ( atom_length(Family,3) ->
                        pad(Row,5,PaddedRow)
                ;
                        atom_length(Family,4),
                        pad(Row,4,PaddedRow)
                )
        ;
                pad(Row,5,PaddedRow)
        ),
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

%                format('Warning!  no stand count data for row ~w of crop ~w, trying inferred_stand_count/6 instead!~n',[Row,Crop]),
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
        pad(CurrNum,2,PlantNumAtom),
        atomic_list_concat([PlantIDPrefix,PlantNumAtom],Plant),
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
get_rowplants([PlantID|PlantIDs],[crop_rowplant_index(PlantID,Crop,Row,Plant)|RowPlants]) :-
        get_crop(PlantID,Crop),
        get_row(PlantID,Row),
        get_plant(PlantID,Plant),
        get_rowplants(PlantIDs,RowPlants).





get_rowplant(PlantID,RowPlant) :-
        sub_atom(PlantID,8,7,0,RowPlant).











% given a date, return the crop for that date
%
% use only in the context of dates from packed_packet, otherwise logic
% is not guaranteed to be correct.
%
% correctness verified by inspection of results of
%
% setof(Crop-Date,P^M^Pa^C^O^T^(packed_packet(P,M,Pa,C,O,Date,T),crop_from_date(Date,Crop)),L),write_list(L).
%
% Kazic, 29.5.2018


% crop_from_date(+PackingDate:term,-Crop:atom).

crop_from_date(PackingDate,Crop) :-
        ( our_date(PackingDate) ->
                arg(2,PackingDate,Mon),
                arg(3,PackingDate,Yr)
        ;
                swi_to_our_date(PackingDate,date(_,Mon,Yr))
        ),
        sub_atom(Yr,2,2,_,TruncatedYr),

        ( ( Mon >= 3,
            Mon =< 6 ) ->
                atom_concat(TruncatedYr,'R',Crop)
        ;
                ( ( Mon >= 10,
                    Mon =< 11,
                    atom_concat(TruncatedYr,'N',Crop),
                    crop(Crop,molokaii,_,_,_,_,_) ) ->
                        true
                ;
                        ( ( atom_concat(TruncatedYr,'G',Crop),
                            crop(Crop,_,Field,_,_,_,_) ) ->
                                sub_atom(Field,0,5,_,sears)
                        ;
                                PriorYr is Yr - 1,
                                sub_atom(PriorYr,2,2,_,TruncatedPriorYr),
                                atom_concat(TruncatedPriorYr,'G',Crop),
                                crop(Crop,_,Field,_,_,_,_),
                                sub_atom(Field,0,5,_,sears)
                        )
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
        crop_rowplant_index(PlantID,Crop,RowNum,_),
        identify_row(Crop,RowNum,_-(_,_,Ma,Pa,_,_,_,_,_,_)),
        plan(Ma,Pa,_,Plan,_,Crop),
        plan_includes(self,Plan,_).




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
                remove_row_prefix(Row,IntegerRow),
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






% revised to include new donated mutants but exclude:
%        Jason Green''s 11R corn (623--627)
%        crop improvement lines (630--664 and 4116, 4117)
%        gerry''s 11n families (3332--3340, 3361--3393)
%        elite lines (890--891)
%        sweet corn (892--899, 990--991)
%        popcorn (992--999, 902--989)
%
% Kazic, 1.6.2018


% want to preserve the distinction between mutants and crop improvement
% lines; we want to consider the latter only when building pedigrees.
%
% Kazic, 30.11.2018


% bounds incorrect!
% not all corn returned by crop_improvement/2 is a founder
%
% Kazic, 30.11.2018

%! mutant_by_family(+Family:int) is semi-det.

mutant_by_family(Family) :-
        integer(Family),
        ( Family < 194
        ;
          Family >= 621,
          \+ nam_founder(Family), 
          \+ other_peoples_corn(Family),
          \+ crop_improvement(Family,_),
	  \+ fun_corn(Family,_),
          \+ gerry_families(Family)
        ).

%        ;
%          Family >= 642,
%          Family < 890
%        ;
%          Family >= 599,
%          Family =< 622
%        ;
%          memberchk(Family,[599,628,629])








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









% added the nam_founder/1 clause
%
% Kazic, 24.5.2019


%! make_barcode_elts(+Crop:atom,+Family:int,-BarcodeElts:atom) is nondet?.


make_barcode_elts(Crop,Family,BarcodeElts) :-

        ( ( inbred(Family,Prefix) 
          ; fun_corn(Family,Prefix)) ->
                PaddedFamily = Family
        ;
                mutant_by_family(Family),
                Prefix = '',
                pad(Family,4,PaddedFamily)

        ;
                gerry_families(Family),
                Prefix = '',
                PaddedFamily = Family
        ;
                crop_improvement(Family,Prefix),
                PaddedFamily = Family
        ;
                other_peoples_corn(Family),
                Prefix = '',
                pad(Family,4,PaddedFamily)

        ;
                nam_founder(Family),
                Prefix = '',
                pad(Family,4,PaddedFamily)

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
%
%
% inserted 'false's so that predicate fails if the row can''t be identified
%
% Kazic, 21.5.2018



%! identify_row(+Crop:atom,+Row:atom,-RowInfo:term) is nondet.


identify_row(Crop,Row,Row-(PRow,F,Ma,Pa,MGma,MGpa,PGma,PGpa,Marker,K)) :-
        build_row(Row,PRow),
        packets_in_row(PRow,Crop,Conflicts,_),

        ( planted(PRow,Packet,_,_,PDate,PTime,_,Crop) ->
                ( Conflicts == [] ->
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
                                                            \+ inbred(F,_) ) ->
                                                                true
                                                        ;
                                                                format('Warning! no genotype/11 fact found for crop ~w, row ~w, ~w x ~w by identify_row/3!~n',[Crop,Row,Ma,Pa]),
                                                                false
                                                        )
                                                ;



                                                        format('Warning!  deconstruct_plantID/5 fails in identify_row/3 for crop ~w, row ~w, ~w x ~w.~n',[Crop,Row,Ma,Pa]),
                                                        false
                                                )
                                        ;

                                                 format('Warning! no genotype/11 fact found for crop ~w, row ~w, ~w x ~w by identify_row/3!~n',[Crop,Row,Ma,Pa]),
                                                 false
                                        )
                                )
                        ;


% had inserted a stub for the long-packed inbreds in case closest_contemporaneous_packet/6 did
% not handle that case.  However, it seems to manage it quite well, so simply will print a 
% warning message here for now.
%
% Kazic, 9.12.2010

                                format('Warning! closest_contemporanous_packet/6 failed when called by identify_row/3 for crop ~w, row ~w, ~w x ~w.~n',[Crop,Row,Ma,Pa]),
                                false
                        )
                ;
                       format('Warning! conflicts exist for crop ~w, row ~w in identify_row/3!~n',[Crop,Row]),
                       false
                )
        ;
                format('Warning! no planted/8 fact for crop ~w, row ~w in identify_row/3!~n',[Crop,Row]),
                false
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
        ( Packet == p00000 ->
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














% find all the crops in which a mutant line was planted, and retrieve the
% plans for that line.  Issue a warning if we've tried this too many times
% already.
%
% Someday, have the code root through the data for the outcomes.
%
% Kazic, 26.7.2019


find_all_plantings_of_line(CurrentCrop,WarningStream,Ma,Pa,PriorCropData) :-
	get_family(Pa,PaFam),
        ( ( Pa \== '06R0000:0000000', mutant_by_family(PaFam) ) ->
		findall(TimeStamp-(Packet,Row,Crop,Plan,Comments),
		      was_planted(CurrentCrop,Ma,Pa,TimeStamp,Packet,Row,Crop,Plan,Comments),
		           PriorCropData),

		length(PriorCropData,NumPriorPlantings),
                ( NumPriorPlantings > 3 ->
		        format(WarningStream,'Warning!  ~w x ~w planted in ~w previous crops ~w, check outcomes.~n~n',[Ma,Pa,NumPriorPlantings,PriorCropData])	         
                ;
		        true
		)
        ;
                PriorCropData = []
	).





was_planted(CurrentCrop,Ma,Pa,PlntgTS,Packet,Row,Crop,Plan,Comments) :-
	packed_packet(Packet,Ma,Pa,_,_,date(KD,KM,PkingYr),KTime),
	get_timestamp(date(KD,KM,PkingYr),KTime,PkingTS),
        get_year(Ma,MaYr),
	atomic_concat(20,MaYr,MaYrAtom),
	atom_number(MaYrAtom,MaFullYr),
        planted(Row,Packet,_,_,date(PD,PM,PlntgYr),PTime,_,Crop),
	Crop @< CurrentCrop,
	get_timestamp(date(PD,PM,PlntgYr),PTime,PlntgTS),	
	MaFullYr =< PkingYr,
        PkingTS < PlntgTS,
        ( plan(Ma,Pa,_,Plan,Comments,Crop) ->
	        true
        ;
                Plan = [],
	        Comments = ''
	).















% for the purpose of packing seed, if we don't have a genotype/11 fact for
% the line yet (won't if the line has never been planted), then confect the
% 0000 family for it.
%
% Kazic, 22.7.2019

%! find_family(+Ma:atom,+Pa:atom,-Family:atom) is semidet.

find_family(Ma,Pa,Family) :-
        ( genotype(Family,_,Ma,_,Pa,_,_,_,_,_,_) ->
                true
        ;
                Family = '0000'
        ).
	












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




















% hmmm --- more dark matter hunting.
%
% Did we plant something for which no genotype fact was issued?
%
% In the end, decided not to compute the trees since I prefer to double-check
% everything by hand.
%
% Kazic, 31.5.2018

find_descendants_of_lines_wo_genotypes(NeedsGenotypes) :-
        missing_lines(RowsPlantedMissing),
        find_descendants(RowsPlantedMissing,NeedsGenotypes).







missing_lines(RowsPlantedMissing) :-
        setof((Ma,Pa),lines_wo_genotypes(Ma,Pa),Oops),
        all_rows_planted_missing(Oops,RowsPlantedMissing).



lines_wo_genotypes(Ma,Pa) :-
        packed_packet(_,Ma,Pa,_,_,_,_),
        get_family(Ma,Fam),
        Fam =\= 0,
        \+ genotype(_,_,Ma,_,Pa,_,_,_,_,_,_).







% hmmm, don''t want to inherit the pkingdate on the output list

all_rows_planted_missing([],[]).
all_rows_planted_missing([(Ma,Pa)|Missing],[(Ma,Pa)-MaPaList|Lists]) :-
        findall((Crop,Row,Packet,PkingDate),all_plantings_of_a_line(Ma,Pa,Crop,Row,Packet,PkingDate),List),
        sort(List,MaPaList),
        all_rows_planted_missing(Missing,Lists).










%! all_plantings_of_a_line(+Ma:atom,+Pa:atom,-Crop:atom,-Row:atom,-Packet:atom) is semidet.


all_plantings_of_a_line(Ma,Pa,Crop,Row,Packet,PkingDate) :-
        packed_packet(Packet,Ma,Pa,_,_,PkingDate,_),
        crop_from_date(PkingDate,Crop),
        ( planted(Row,Packet,_,_,_,_,_,Crop) ->


%        ( contemporaneous_planting(Packet,PkingDate,Row,Crop) ->
%                true
%        ;
%                later_planting(Ma,Pa,Crop,Row,Packet)
%        ),


                ( row_status(Row,num_emerged(Num),_,_,_,_,Crop) ->
                        ( Num > 0 ->
                                true
                        ;
                                format('Warning! zero stand count for row ~w in crop ~w~n',[Row,Crop]),
                                false
                        )
                ;
                        format('Warning! no row_status/7 fact for row ~w in crop ~w~n',[Row,Crop]),
                        false
                )
        ;


% shut off the chatter once we know the problems with the lines missing
% genotypes

%                setof((Packet,Date),C^O^T^packed_packet(Packet,Ma,Pa,C,O,Date,T),L),
%                format('~w with ~w x ~w was not planted in crop ~w;~n',[Packet,Ma,Pa,Crop]),
%                format('all packets packed with these parents are:~n',[]),
%                write_list(L),
%                format('~n~n',[]),
                false
        ).





% is the packet planted in the same crop it was packed in?


%! contemporaneous_planting(+Packet:atom,+Date:term,-Row:atom,-Crop:atom) is det.


contemporaneous_planting(Packet,Date,Row,Crop) :-
        crop_from_date(Date,Crop),
        planted(Row,Packet,_,_,_,_,_,Crop).











% or is it planted in a later crop?


%! later_planting(+Ma:atom,+Pa:atom,-Crop:atom,-Row:atom,-Packet:atom) is semidet.

% 11r > 11n,g > 12r > 12n,g

later_planting(Ma,Pa,Crop,Row,Packet) :-
        packed_packet(Packet,Ma,Pa,_,_,PkingDate,_),
        crop_from_date(PkingDate,PkingCrop),
        get_crop_components(PkingCrop,PkingYear,PkingNursery),

        planted(Row,Packet,_,_,_,_,_,Crop),
        get_crop_components(Crop,Year,Nursery),

        ( ( PkingNursery == 'R',
            memberchk(Nursery,['G','N']) ) ->
                PkingYear @=< Year
        ;
                PkingYear @< Year
        ).












find_descendants(RowsPlantedMissing,NeedsGenotypes):-
        find_descendants(RowsPlantedMissing,[],NeedsGenotypes).



find_descendants([],A,A).
find_descendants([(ForeMa,ForePa)-LaterPlantings|T],GAcc,NeedsGenotypes) :-
        ( LaterPlantings == [] ->
                NewGAcc = GAcc
        ;
                find_descendants_aux(LaterPlantings,ThoseGenotypes),
                append([GAcc,[(ForeMa,ForePa)],ThoseGenotypes],NewGAcc)
        ),
        find_descendants(T,NewGAcc,NeedsGenotypes).







find_descendants_aux(LaterPlantings,ThoseGenotypes) :-
        find_descendants_aux(LaterPlantings,[],ThoseGenotypes).






% Warning! This assumes that mutants are only used as males!  
% Your experiment may be different!
%
% could also look in harvest, inventory, and genotype facts for these guys,
% but by crop and rowplant.
%
% Kazic, 29.5.2018


find_descendants_aux([],A,A).
find_descendants_aux([(Crop,Row,Packet,PkingDate)|T],GAcc,ThoseGenotypes) :-
        format('checking ~w ~w ~w ~w~n',[Crop,Row,Packet,PkingDate]),
        remove_row_prefix(Row,RowAtom),
        barcode_index(RowAtom,Crop,_RowPlant,_Plant,AssignedFamily,_PostColon,_Barcode),
        ( packed_packet(Packet,PkMa,PkPa,_,_,PkingDate,_) ->
                true
        ;
                PkMa = unk,
                PkPa = unk
        ),

        ( genotype(AssignedFamily,_,F1Ma,_,F1Pa,_,_,_,_,_,_) ->
                true
        ;
                F1Ma = unk,
                F1Pa = unk
        ),

        append(GAcc,[foo(Crop,Row,Packet,PkingDate,p(PkMa,PkPa),g(F1Ma,F1Pa))],NewGAcc),
        find_descendants_aux(T,NewGAcc,ThoseGenotypes).












% build the relative paths to a crop''s directories

%! construct_crop_relative_dirs(+Crop:atom,+PlngDir:atom,+MgmtDir:atom,+TagsDir:atom) is det.


construct_crop_relative_dirs(Crop,PlngDir,MgmtDir,TagsDir) :-
        downcase_atom(Crop,CropParticle),
        pedigree_root_directory(Root),
        planning_directory(Plng),
        management_directory(Mgmt),
        tags_directory(Tags),
        atomic_list_concat([Root,CropParticle,Plng],PlngDir),
        atomic_list_concat([Root,CropParticle,Mgmt],MgmtDir),
        atomic_list_concat([Root,CropParticle,Tags],TagsDir).











% the field and plan had to be rearranged because of weather,
% miscalculation, skips, replantings, or whatever.  So now, compute the
% plan for what was really done so this can be used to generate the field
% book.
%
% Kazic, 14.6.2019


% still some screwy dupes ....
%
% Kazic, 14.6.2019

reorganize_plan(Crop,OldPackingPlanFile,NewPPFile) :-
	ensure_loaded(OldPackingPlanFile),
        get_year_from_particle(Crop,_,Year),
        get_nursery_from_particle(Crop,Nursery),
	crop_months(Nursery,Months),
	order_planting_dates(Crop,PlantingDates),
        setof(Seq-(Ma,Pa,Pltng,Plan,Comment,Knum,Cl,Ft),get_true_planting(Crop,Year,Months,PlantingDates,Seq,Ma,Pa,Plan,Comment,Knum,Pltng,Cl,Ft),L),

	keysort(L,Sorted),
	output_new_plan(Crop,NewPPFile,Sorted).




% The naive version would ignore rows skipped for computer vision or
% planted with elite lines.  The former are determined in the field during
% the first planting.  The latter are ``packed'' in the sense we bulk-plant
% them using the Jang planter, aiming for ~30 kernels/row.  The
% packed_packet/7 facts give the numerical genotypes, but the
% packing_plan/10 called here just say
%
%
%        [elite],
%
% instead of
%
%        ['17R891:L0xxxxxx','17R891:L0xxxxxx'],
%
% so there would be no unification.  The former problem is handled by
% adding a fact for the skipped rows to
% ../c/maize/crops/CROP/planning/sequenced.packing_plan.pl and the latter
% by the alternation in calling packing_plan/10.
%
% Kazic, 14.6.2019





% this doesn't incorporate closest_contemporaneous_packet*/{6,7}, but
% should: if packets are packed in a prior year but not planted until a
% subsequent year and then the field is rearranged from the plan, this
% predicate will fail on those rows.
%
% Kazic, 15.6.2019

get_true_planting(Crop,Year,Months,PlantingDates,Seq,Ma,Pa,Plan,Comment,Knum,Pltng,Cl,Ft) :-
         planted(Row,Pkt,Ft,_,date(Day,Mo,Year),_,_,Crop),
	 packed_packet(Pkt,Ma,Pa,Cl,_,date(_,_,Year),_),
	 memberchk(Mo,Months),
	 ( packing_plan(_,_,[Ma,Pa],_,Plan,Comment,Knum,Crop,_,_)
	 ;
	   packing_plan(_,_,[elite],_,Plan,Comment,Knum,Crop,_,_),
	   Ma = '17R891:L0xxxxxx',
	   Pa = Ma
	 ),
 	 extract_row(Row,Seq),
         determine_planting(Year-Mo-Day,PlantingDates,Pltng).





order_planting_dates(Crop,PlantingDates) :-
	setof(Yr-Mo-Day,R^P^K^H^T^W^planted(R,P,K,H,date(Day,Mo,Yr),T,W,Crop),Dates),
	sort(Dates,PlantingDates).







output_new_plan(Crop,NewPPFile,Sorted) :-
        open(NewPPFile,write,Stream),
	local_timestamp_n_date(_,Today),
	format(Stream,'% this is ~w~n~n% computed by genetic_utilities:reorganize_plan/3~n% on ~w~n% because the field had to be reorganized to accommodate weather and last-minute changes to the plan.~n% This file reflects what was actually done and incorporates prior relevant plan information.~n~n~n~n',[NewPPFile,Today]),
	output_new_plan_aux(Crop,Stream,Sorted),
	close(Stream).



output_new_plan_aux(_,_,[]).
output_new_plan_aux(Crop,Stream,[Seq-(Ma,Pa,Pltng,Plan,Comment,Knum,Cl,Ft)|T]) :-
         format(Stream,'packing_plan(~w,1,[~q,~q],~w,~w,~q,~q,~q,~w,~w).~n',[Seq,Ma,Pa,Pltng,Plan,Comment,Knum,Crop,Cl,Ft]),
	 output_new_plan_aux(Crop,Stream,T).








% assumes PlantingDates are sorted chronologically using
% order_planting_dates/2 above
%
% Kazic, 14.6.2019

determine_planting(Date,[Date|_],1).
determine_planting(Date,[_,Date|_],2).
determine_planting(Date,[_,_,Date|_],3).
determine_planting(Date,[_,_,_,Date|_],4).












%%%%%%%%% utilities for pack_corn:pack_corn/1

% transplanted from old order_packets.pl
%
% assumes default directory organization; change if yours differs
%
% Kazic, 25.7.2019

load_crop_planning_data(Crop) :-
        current_crop(Crop),
        convert_crop(Crop,LCrop),
        atomic_list_concat(['../../crops/',LCrop,'/planning/packing_plan.pl'],PackingPlanFile),
        ensure_loaded(pack_corn:[PackingPlanFile]).







%! open_planning_warning_file(+Crop:atom,-LCrop:atom,-TimeStamp:atom,-UTCDate:atom,-WarningStream:io_stream) is det.

open_planning_warning_file(Crop,LCrop,TimeStamp,UTCDate,WarningStream) :-
        convert_crop(Crop,LCrop),
        utc_timestamp_n_date(TimeStamp,UTCDate),
	
        atomic_list_concat(['../../crops/',LCrop,'/planning/packing_warnings'],WarningsFile),
	open(WarningsFile,write,WarningStream),
        format(WarningStream,'% this is ~w~n~n',[WarningsFile]),
        format(WarningStream,'% generated on ~w (=~w) by pack_corn:pack_corn/1.~n%~n% check the results of prior plantings and adjust the plan accordingly!~n~n~n~n',[UTCDate,TimeStamp]).





append_to_planning_file(LCrop,Plans) :-
	open('../data/plan.pl',append,Stream),
        format(Stream,'~n~n~n~n% ~w~n~n',[LCrop]),
        output_header(plano,'../data/plan.pl',Stream),
        write_list_facts(Stream,Plans),
        close(Stream).












%%%%%%%%%%%%%%%%%% obsolete %%%%%%%%%%%%%%%%%%%%

% for pedigree matching
%
% nah, use the already computed crop_rowplant_index/4
%
% Kazic, 18.3.2019


%! remove_family(+PlantID:atom,-PlantIDSansFam:atom) is det.

remove_family(PlantID,PlantIDSansFam) :-
        sub_atom(PlantID,0,3,_,Crop),
        sub_atom(PlantID,FrontLen,1,BackLen,':'),
        IncColon is BackLen + 1,
        sub_atom(PlantID,FrontLen,IncColon,_,Back),
        atom_concat(Crop,Back,PlantIDSansFam).


