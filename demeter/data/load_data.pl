% this is ../c/maize/demeter/data/load_data.pl
%
% adapted for swipl and more portability across platforms
%
%
% Kazic, 26.3.2018




% Kazic, 19.4.2008
%
% may need multifile or dynamic for this module because of order_packets:load_crop_planning_data/0
%
% Kazic, 22.6.2010


% fun_corn/1 now defined in genetic_utilties:fun_corn/1
% seems easier to maintain the lists and logic there
%
% Kazic, 8.3.2022


    
:-      module(load_data, [
%                barcode_index/7,
%                crop_rowplant_index/4,
%		 decon_planting_index/6,
% 		 decon_harvest_index/8,		       
%                frpc_index/4,
%		 frpc_inv_index/5,
%                planting_index/4,
%                row_members_index/3,
%                fun_corn/1,
%

                barcode_index/7,
                crop_rowplant_index/4,
	        decon_planting_index/10,
		decon_harvest_index/8,
		decon_inventory_index/8,
                frpc_index/4,
		frpc_inv_index/5,
                planting_index/4,
                row_members_index/3,
%                fun_corn/1,



		branch_status/11,
                box/5,
                contaminant/5,
                crop/7,
                cross/8,
                cross_prep/5,
                current_crop/1,
                current_inbred/5,
                ear/5,
                family_prefix/2,
                gene_type/4,
                genotype/11,
                harvest/7,
                image/9,
                inbred_pool/2,
		inventory/7,
		leaf_alignmt/6,   
                mutant/8,
                num_secs/2,
                packed_packet/7,
                pedigree_tree/2,
                person/4,
                phenotypic_class/2,
                plan/6,
                plant_anatomy/8,
                plant_fate/5,
                planted/8,
                pot/2,
                priority_rows/2,
                row_harvested/5,
                row_status/7,
                sample/7,
		scoring_date/6,
                sleeve_bdry/6,
                source/7,
         	tassel/5
           

                ]).



:-
%	ensure_loaded(barcode_index),
%	ensure_loaded(crop_rowplant_index),
%	ensure_loaded(decon_planting_index),	
%	ensure_loaded(decon_harvest_index),	
%	ensure_loaded(frpc_index),
%	ensure_loaded(frpc_inv_index),
%	ensure_loaded(planting_index),
%	ensure_loaded(row_members_index),
%%	ensure_loaded(fun_corn),
%
%

	ensure_loaded(barcode_index),
	ensure_loaded(crop_rowplant_index),
	ensure_loaded(decon_planting_index),
	ensure_loaded(decon_harvest_index),		
	ensure_loaded(decon_inventory_index),		
	ensure_loaded(frpc_index),
	ensure_loaded(frpc_inv_index),
	ensure_loaded(planting_index),
	ensure_loaded(row_members_index),
%	ensure_loaded(fun_corn),


	
	ensure_loaded(branch_status),
	ensure_loaded(box),	
	ensure_loaded(contaminant),
	ensure_loaded(crop),
	ensure_loaded(cross),
	ensure_loaded(cross_prep),
	ensure_loaded(current_crop),
	ensure_loaded(current_inbred),
	ensure_loaded(ear),
	ensure_loaded(family_prefix),
	ensure_loaded(gene_type),
	ensure_loaded(genotype),
	ensure_loaded(harvest),
	ensure_loaded(image),
	ensure_loaded(inbred_pool),
	ensure_loaded(inventory),
	ensure_loaded(leaf_alignmt),
	ensure_loaded(mutant),
	ensure_loaded(num_secs),
	ensure_loaded(packed_packet),
	ensure_loaded(pedigree_tree),
	ensure_loaded(person),
	ensure_loaded(phenotypic_class),
	ensure_loaded(plan),
	ensure_loaded(plant_anatomy),
	ensure_loaded(plant_fate),
	ensure_loaded(planted),
	ensure_loaded(pot),
	ensure_loaded(priority_rows),
	ensure_loaded(row_harvested),
	ensure_loaded(row_status),
	ensure_loaded(scoring_date),
	ensure_loaded(sleeve_bdry),
	ensure_loaded(source),
	ensure_loaded(tassel),
	ensure_loaded(tissue_collectn).










    
