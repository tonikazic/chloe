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





    
:-      module(load_data, [
                box/5,
                contaminant/5,
                crop/7,
                crop_rowplant/4,
                cross/8,
                cross_prep/5,
                current_crop/1,
                current_inbred/5,
                ear/5,
                family_prefix/2,
                fun_corn/1,
                gene_type/4,
                genotype/11,
                harvest/7,
                image/9,
                inbred_pool/2,
                inventory/7,
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
                planting_index/4,
                pot/2,
%                priority_rows/2,
                row_members/3,
                row_status/7,
                source/7,
         	tassel/5
                ]).



:-
	ensure_loaded(box),
	ensure_loaded(contaminant),
	ensure_loaded(crop),
	ensure_loaded(crop_rowplant),
	ensure_loaded(cross),
	ensure_loaded(cross_prep),
	ensure_loaded(current_crop),
	ensure_loaded(current_inbred),
	ensure_loaded(ear),
	ensure_loaded(family_prefix),
	ensure_loaded(fun_corn),
	ensure_loaded(gene_type),
	ensure_loaded(genotype),
	ensure_loaded(harvest),
	ensure_loaded(image),
	ensure_loaded(inbred_pool),
	ensure_loaded(inventory),
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
	ensure_loaded(planting_index),
	ensure_loaded(pot),
%	ensure_loaded(priority_rows),
	ensure_loaded(row_members),
	ensure_loaded(row_status),
	ensure_loaded(source),
	ensure_loaded(tassel).










    
