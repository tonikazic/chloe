% this is ../maize/demeter/code/inventory_checking.pl

% there are problems in the inventory that afffect the pedigrees.

% If there is a mismatch between the genotype fact and the inventory fact
% for the parents, then construction of the pedigrees dies at that node.
% So for example, in the initially computed les4_mo20W pedigree, we are
% missing at least one whole branch.


% It seems to me there are two sensible checks:
%
% Is every parental pair in genotype.pl represented in the new
% inventory.pl? If not, then for genotype parents not found in inventory,
% what is their genotype?
%
% For every parental pair in new inventory.pl, is it found in old
% inventory.pl, and vice versa?
%
% Then, recompute the pedigrees for the wierdo background/mutant
% combination. 


% We could form the set of all parental pairs from cross.pl, harvest.pl,
% and new inventory.pl and compute set differences.  But I think these
% would not be as informative as the first two tests.






%declarations%



:-      module(inventory_checking, [
                genotype_vs_inventory/1,
                mismatched_plantIDs/2,
                new_vs_old_inventory/2
                ]).





:-      use_module(demeter_tree('code/genetic_utilities')),
        use_module(demeter_tree('code/demeter_utilities')).



:-      ensure_loaded(library(lists)),
        ensure_loaded(library(ordsets)),
        ensure_loaded(library(sets)),
        ensure_loaded(library(basics)),
        ensure_loaded(library(strings)).



%end%




genotype_vs_inventory(File) :-
        setof((Ma,Pa),mutant_line(Ma,Pa),GenotypeParents),
        setof((IMa,IPa),
          load_data:Cl^Observer^Date^Time^Sleeve^inventory(IMa,IPa,Cl,Observer,Date,Time,Sleeve),
            InventoryParents),
        ord_subtract(GenotypeParents,InventoryParents,ParentsNotInInventory),
        grab_genotypes(ParentsNotInInventory,GTypesNotInInventory),
        output_file(File,genotype_vs_inventory,GTypesNotInInventory).






% ignore genotypes which F < 1000, since these are
% ancestral lines and (except for inbred pools, popcorn, and sweet corn) likely have no seed. 
%
% Similarly, exclude families 3332--3393, since these are Gerry''s lines from 
% 11n.


mutant_line(Ma,Pa) :-
        genotype(F,_MF,Ma,_PF,Pa,_MaGma,_MaGPa,_PaGMa,_PaGPa,_Mutant,_K),
        mutant_by_family(F),
        \+ founder(F,_,_,_,_,_,_,_,_).





% a bit redundant, but helps with inventory comparison predicate

grab_genotypes(ParentsNotInInventory,GTypesNotInInventory) :-
        grab_genotypes(ParentsNotInInventory,[],GTypesNotInInventory).







grab_genotypes([],A,A).
grab_genotypes([(Ma,Pa)|Parents],Acc,Gtypes) :-
        ( load_data:genotype(F,_MF,Ma,_PF,Pa,MaGma,_MaGPa,_PaGMa,_PaGPa,Mutant,K) ->
                ( mutant_by_family(F) ->
                      append(Acc,[(Ma,Pa,F,MaGma,Mutant,K)],NewAcc)
		;
                      NewAcc = Acc
                )
	;
                append(Acc,[(Ma,Pa,F,MaGma,Mutant,K)],NewAcc)
        ),
        grab_genotypes(Parents,NewAcc,Gtypes).




new_vs_old_inventory(CropString,FileStem) :-
        setof((NMa,NPa),new_inventory_before_crop(CropString,NMa,NPa),NewInventoryParents),

        ensure_loaded(old:'../data/old.inventory.pl'),
        setof((OMa,OPa),old_nonfounder_mutants(OMa,OPa),OldInventoryParents),

        ord_subtract(OldInventoryParents,NewInventoryParents,OldNotNew),
        ord_subtract(NewInventoryParents,OldInventoryParents,NewNotOld),
        grab_genotypes(OldNotNew,OldNotNewGTypesNotInInventory),
        grab_genotypes(NewNotOld,NewNotOldGTypesNotInInventory),

        concat_atom([FileStem,'_old_not_new'],File1),
        concat_atom([FileStem,'_new_not_old'],File2),
        output_file(File1,old_vs_new_inventory,OldNotNewGTypesNotInInventory),
        output_file(File2,new_vs_old_inventory,NewNotOldGTypesNotInInventory).





new_inventory_before_crop(CropString,NMa,NPa) :-
          load_data:inventory(NMa,NPa,_Cl,_Observer,_Date,_Time,_Sleeve),
          \+ midstring(NMa,CropString,_,0),
          get_family(NMa,Family),
          \+ founder(Family,_,_,_,_,_,_,_,_).




old_nonfounder_mutants(OMa,OPa) :-
          old:inventory(OMa,OPa,_OCl,_OObserver,_ODate,_OTime,_OSleeve),
          get_family(OMa,Family),
          \+ founder(Family,_,_,_,_,_,_,_,_).




% form the set of all plantIDs in the genotype facts.
%
% check for their exact match in the new inventory.
%
% for the remaining mismatches, ask which parts of the string mismatch, for
% all possible mismatches.


mismatched_plantIDs(CropString,File) :-
        setof(Ma,load_data:F^MF^PF^Pa^MaGma^MaGPa^PaGMa^PaGPa^Mutant^K^genotype(F,MF,Ma,PF,Pa,MaGma,MaGPa,PaGMa,PaGPa,Mutant,K),Mas),
        setof(NPa,load_data:F^MF^NMa^PF^MaGma^MaGPa^PaGMa^PaGPa^Mutant^K^genotype(F,MF,NMa,PF,NPa,MaGma,MaGPa,PaGMa,PaGPa,Mutant,K),Pas),
        union(Mas,Pas,Pars),
        list_to_ord_set(Pars,Parents),      


        setof(IMa,load_data:IPa^Cl^Observer^Date^Time^Sleeve^inventory(IMa,IPa,Cl,Observer,Date,Time,Sleeve),IMas),
        setof(NIPa,load_data:NIMa^Cl^Observer^Date^Time^Sleeve^inventory(NIMa,NIPa,Cl,Observer,Date,Time,Sleeve),IPas),
        union(IMas,IPas,IPars),
        list_to_ord_set(IPars,IParents),


% we are interested in all parents that are in the genotype facts that do not appear in the new inventory.
%
% Since we have not added 13R parents to the genotype yet, they won't appear; however, we include a test
% for a crop to add functionality.

        subtract(Parents,IParents,GParsNotInInv),
        remove_parents_of_crop(CropString,GParsNotInInv,PrunedGPars),
        test_for_near_matches(PrunedGPars,IParents,NearMatches),
        output_file(File,mismatched_plantIDs,NearMatches).






remove_parents_of_crop(CropString,GParsNotInInv,PrunedGPars) :-
        remove_parents_of_crop(CropString,GParsNotInInv,[],PrunedGPars).



remove_parents_of_crop(_,[],A,A).
remove_parents_of_crop(CropString,[Par|GParsNotInInv],Acc,PrunedGPars) :-
        ( midstring(Par,CropString,_,0) ->
                NewAcc = Acc
        ;
                append(Acc,[Par],NewAcc)
        ),
        remove_parents_of_crop(CropString,GParsNotInInv,NewAcc,PrunedGPars).









% first, build lists of plantIDs broken into parts
%
% then, test for various combinations of parts, forming sets of near-matches
% for manual evaluation.
%
% this will run slowly for the string operations, and many setofs with members, so probably it will run
% like a pig.
%
% can be speeded up by asserting the parts temporarily and then running setof over the assertions.



test_for_near_matches(PrunedGPars,IParents,NearMatches) :-
        break_into_parts(PrunedGPars,GParParts),
        break_into_parts(IParents,IParParts),
        test_by_parts(GParParts,IParParts,NearMatches).






% break out 06R Is and decimal separately???? maybe

break_into_parts([],[]).
break_into_parts([PlantID|Pars],[p(PlantID,Crop,Family,RowPlant,Row,Plant)|Parts]) :-
        index_by_ears(PlantID,Crop,Family,RowPlant),
        get_row(PlantID,Row),
        get_plant(PlantID,Plant),
        break_into_parts(Pars,Parts).










test_by_parts([],_,[]).
test_by_parts([p(PlantID,Crop,Family,RowPlant,Row,Plant)|Parts],IParParts,
              [PlantID-[FamilyMismatch,PlantMaybeFamilyMismatch,PlantMismatch,RowMismatch]|NearMatches]) :-

        match_crop_rowplant(Crop,Family,RowPlant,IParParts,FamilyMismatch),

        match_crop_row_not_plant(Crop,Family,Row,Plant,IParParts,PlantMaybeFamilyMismatch),

        match_crop_family_row(Crop,Family,Row,Plant,IParParts,PlantMismatch),

        match_crop_family_plant_not_row(Crop,Family,Row,Plant,IParParts,RowMismatch),

        test_by_parts(Parts,IParParts,NearMatches).








% definitions of partial matches

match_crop_rowplant(Crop,Family,RowPlant,IParParts,FamilyMismatch) :-
        ( setof(mfam(Family,MisFamily),
                  match_crop_rowplant_aux(Crop,Family,RowPlant,IParParts,MisFamily),FamilyMismatch) ->
                true
        ;
                FamilyMismatch = []
        ).

match_crop_rowplant_aux(Crop,Family,RowPlant,IParParts,MisFamily) :-
        member(p(_,Crop,MisFamily,RowPlant,_,_),IParParts),
        MisFamily \== Family.







% if we cross multiple plants in a row but only use offspring of one or a few crosses, 
% these will show up as mismatches even if they are correctly inventoried

match_crop_row_not_plant(Crop,Family,Row,Plant,IParParts,PlantMaybeFamilyMismatch) :-
        ( setof(mpltfam(Plant,MisPlant,Family,MisFamily),
              match_crop_row_not_plant_aux(Crop,Row,Plant,IParParts,MisPlant,MisFamily),PlantMaybeFamilyMismatch) ->
                true
        ;
                PlantMaybeFamilyMismatch = []
        ).


match_crop_row_not_plant_aux(Crop,Row,Plant,IParParts,MisPlant,MisFamily) :-
        member(p(_,Crop,MisFamily,_,Row,MisPlant),IParParts),
        MisPlant \== Plant.







% if we cross multiple plants in a row but only use offspring of one or a few crosses, 
% these will show up as mismatches even if they are correctly inventoried

match_crop_family_row(Crop,Family,Row,Plant,IParParts,PlantMismatch) :-
        ( setof(mplt(Plant,MisPlant),
                   match_crop_family_row_aux(Crop,Family,Row,Plant,IParParts,MisPlant),PlantMismatch) ->
                true
        ;
                PlantMismatch = []
        ).


match_crop_family_row_aux(Crop,Family,Row,Plant,IParParts,MisPlant) :-
        member(p(_,Crop,Family,_,Row,MisPlant),IParParts),
        MisPlant \== Plant.










match_crop_family_plant_not_row(Crop,Family,Row,Plant,IParParts,RowMismatch) :-
        ( setof(mrow(Row,MisRow),
                match_crop_family_plant_not_row_aux(Crop,Family,Row,Plant,IParParts,MisRow),RowMismatch)  ->
                true
        ;
                RowMismatch = []
        ).



match_crop_family_plant_not_row_aux(Crop,Family,Row,Plant,IParParts,MisRow) :-
        member(p(_,Crop,Family,_,MisRow,Plant),IParParts),
        MisRow \== Row.











output_file(File,Predicate,Data) :-
        utc_timestamp_n_date(Timestamp,UTCDate),
        length(Data,N),
        open(File,write,Stream),
        format(Stream,'% this is ~w~n',[File]),
        format(Stream,'% generated on ~w (~w) by ~w~n~n~n',[UTCDate,Timestamp,Predicate]),
        format(Stream,'% the following list contains ~w items~n~n~n~n',[N]),
        write_list(Stream,Data),
        close(Stream).
