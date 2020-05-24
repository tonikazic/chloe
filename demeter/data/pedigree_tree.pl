% this is ../c/maize/demeter/data/pedigree_tree.pl

    
% the current classification of the pedigree files.  Names of mutant
% genes are mostly correctly embedded in the file names, but of course
% not always.  This list must be manually maintained.
%
% Kazic, 25.9.2012


% modified based on going through the pedigrees
%
% Kazic, 16.10.2012
%
% further modified based on apparent recessivity of Les3 and Les5 in 12r and 12n.
%
% Kazic, 20.4.2013


% added entries for Braun, Balint-Kurti, and Gardner corn
%
% Kazic, 26.5.2018


% further reclassifications
%
% Kazic, 24.5.2020
    

% pedigree_tree(SubDir,ListFileNames).



% families 192 -- 199, 621, 622, 628, all are seen as founders

% these pedigrees not computed in the batch job, why?  All successfully computed
% using trace_pedigree/3.
%
% Kazic, 16.10.2012.
%
%        'newnecrotic_l522-10',         % ! not computed     622
%        'les*-B1_b73',                 % ! not computed     628
%        'w22_idfBPl',                            % ! not computed  192, 193
%        'gRMZM2G157354_T03_gRMZM2G157354_T03'   % ! not computed    621





% latest revisions include some shifts (all rpX are now in suppressors)
% and name changes due to modification of pedigrees:remove_silly_characters/3.
%
% I have preserved the older classification below.
%
% Kazic, 1.6.2018



% revised to reflect current file names
%
% Kazic, 1.6.2019


pedigree_tree(balint_kurti,[
'les-r1-1-k66700_cml333',
'les-r2-1-k66800_cml333',
'les-r3-1-k66900_cml333',
'les-r4-1-k67000_cml333',
'les-r5-1-k67100_ki11',
'les-r6-1-k67200_ki11',
'les-r7-2-k67300_mo18w',
'les-r8-2-k67400_nc350',
'les-r9-2-k67500_tzi8',
'les-r10-2-k67600_tzi8',
'les-r11-2-k67700_tzi8',
'les-r168-1-k67800_nc262',
'les-r168-2-k67900_nc262',
'les-r169-1-k68000_nc262',
'les-r170-1-k68100_nc262oh7bbc3f45entry155',
'les-r171-1-k68200_nc262oh7bbc3f45entry155',
'les-r171-3-k68300_nc262oh7bbc3f45entry155',
'les-r172-1-k68400_nc262oh7bbc3f45entry155']).





    



pedigree_tree(braun,[
'ij-like-k64214_',
'diffwhnec-k65413_',
'lgyginterveinalstreaks-k65109_',
'lgyginterveinalstreaks-k65211_',
'lgyginterveinalstreaks-k65313_',
'osclgwhlgchl-k64807_',
'osclgwhlgchl-k64914_',
'osclgwhlgchl-k65016_',
'possiblelesionmimicems-k66515_',
'possiblelesionmimicems-k66604_',
'unk-k64311_',
'unk-k64403_',
'unk-k64509_',
'unk-k64613_',
'unk-k64703_']).







pedigree_tree(classify,[]).









pedigree_tree(crop_improvement,[
'mo20w-k20501_mo20w',
'mo20w-k20506_mo20w',
'mo20w-k20511_mo20w',
'w23-k30504_w23',
'w23-k30510_w23',
'w23-k30511_w23',
'm14-k40501_m14',
'w23-k30505_w23',
'w23-k30506_w23',
'm14-k40506_m14',
'b73-k50403_b73',
'b73-k50407_b73',
'b73-_b73']).
















pedigree_tree(exp_nonexp,[
'les17exp-k4800_les17',
'les1exp-k3600_les1nonexp',
'les2exp-k3700_les2nonexp',
'les4exp-k3800_les4nonexp',
'les5exp-k3900_les5exp',
'les6exp-k4000_les6nonexp',
'les7exp-k4100_les7nonexp',
'les8exp-k4200_les8nonexp',
'les9exp-k4300_les9nonexp',
'les10exp-k4400_les10nonexp',
'les11exp-k4500_les11nonexp',
'les12exp-k4600_les12nonexp',
'les15exp-k4700_les15nonexp',
'les18exp-k4900_les18nonexp',
'les19exp-k5000_les19nonexp',
'les20exp-k5100_les20nonexp',
'les21exp-k5200_les21nonexp']).










pedigree_tree(gardner,[
'001-(2n)-002-001-b-k69100_cristalinoamarar21004',
'002-(2n)-001-001-b-k69300_cuzcocuz217',
'002-(2n)-001-002-b-k68800_ancashinoanc102',
'006-(2n)-001-001-b-k69600_patillograndebov649',
'006-(2n)-002-001-b-k70100_yunguenobov362',
'(2n)-003-001-b-k69800_tehua-chs29']).


    







pedigree_tree(gerrys_martys_babies,[
'blh-1455-k13000_+',
'blh-n1455-k14800_cm105',
'les-2240-k13300_a632',
'les-2240-k15600_a632',
'les-2274-k13400_m020yw23',
'les-2318-k13500_mo20y',
'les-2386-k13600_mo17',
'les-a853-k12800_+',
'les-funk-4-k15000_+',
'les-na853-k15100_w23b77',
'll-264-k12500_mo20yw23',
'll-n264-k15200_+',
'nec-490a-k12600_acr',
'nec-490a-k15700_acr',
'nec-831a-k12700_+',
'nec-1521a-k13100_mo20w',
'nec-1613-k13200_ahornj',
'nec-n1613-k15400_+',
'nec-n490a-k15500_+',
'spt-1320c-k12900_+']).








pedigree_tree(nam_fndrs,[
'b97-k19400_b97',
'cml103-k19500_cml103',
'cml228-k19600_cml228',
'cml247-k19700_cml247',
'cml277-k19800_cml277',
'cml322-k19900_cml322',
'cml333-k60000_cml333',
'cml52-k60100_cml52',
'cml69-k60200_cml69',
'hp301-k60300_hp301',
'il144-k60400_il144',
'ki11-k60500_ki11',
'ki21-k60700_ki21',
'ki3-k60600_ki3',
'm162w-k60800_m162w',
'm37w-k60900_m37w',
'mo17-k61000_mo17',
'mo17-k61001_mo17',
'mo18w-k61100_mo18w',
'ms71-k61200_ms71',
'nc350-k61300_nc350',
'nc358-k61400_nc358',
'oh43-k61500_oh43',
'oh78-k61600_oh78',
'p39-k61700_p39',
'tx303-k61800_tx303',
'tzi8-k61900_tzi8',
'w22r-r-k62000_w22r-rstandard(brink)']).









pedigree_tree(not_useful,[
'd10-k14500_d10',
'idfbpl-k19200_idfbpl',
'idfbplsib-k19300_idfbpl',
'les1-k0100_mo20w',		      
'-_',
'acd2-k18000_',
'camo-k13800_b73',
'csp1-k18100_csp1',
'd8-n1452-k14300_d8-n1452',
'd8-n1591-k14200_d8-n1591',
'd9-k14400_d9',
'grmzm2g157354_t03-k62100_grmzm2g157354_t03',
'hsf1-k14100_hsf1',
'ht1-ge440-k9700_ht1-ge440m14',
'ht1-k9900_b73ht1',
'ht1-ladyfinger-k9800_m14',
'ht2-k10000_ht2a619',
'ht4-k10100_ht4',
'htn1-k10200_htn1w22',
'ij2-n8-k10300_w22ij2-n8',
'lep-8691-k10400_+',
'les5-n1449-k68500_2007-942-1',
'les-ec91-k11700_c-13',
'les-ec91-k17100_b73',
'les-k17200_les',
'les-3f-3330-k8800_+',
'les-2119-k9200_w23l317',
'les-n502c-k7300_b73ht1',
'les-n2015-k7900_+',
'les-n2420-k8600_m14',
'les-na1176-k8900_b73ag32',
'les-pi251888-k9400_+',
'les1-n843-k5400_b73ht1',
'les2-gj-k15800_',
'les3-gj2-k15900_mo17',
'les3-k5600_w23',
'les4-n1375-k5700_b77',
'les5-gj-k16000_mo20w',
'les5-gj2-k16100_b73',
'les5-n1449-k5800_w23',
'les6-n1451-k5900_+',
'les7-n1461-k6000_w23',
'les8-n2005-k6100_w23',
'les9-n2008-k6200_(m14w23)',
'les10-na607-k6300_w23',
'les11-n1438-k6400_w23',
'les12-n1453-k6500_w23',
'les13-n2003-k6600_w23',
'les15-k1200_mo20w',
'les15-k2900_w23',
'les17-n2345-k6800_w23',
'les18-n2441-k6900_w23',
'les19-n2450-k7000_w23',
'les21-k1600_mo20w',
'les23-k11400_mo20w',
'les101-k16500_les101',
'les102-k16600_mo20w',
'les2014-k16800_+',
'lesdl(mop1)-k01700_mo20w',
'mop1-k12100_mop1mop1',
'pl-rhoades-k12300_mcclintockfullcolor',
'rhm1y1-k10800_rhm1y1',
'spc1-n1376-k14000_w23',
'spc3-n553c-k11000_+',
'tp2-k14700_tp2',
'vms-8522-k11100_m14w23',
'w22-k12400_920021',
'zn1-k11200_zn1',
%
% gardner corn		  
%	
'006-(2n)-003-001-b-k69500_patillograndebov649',
'005-(2n)-003-001-b-k69200_cristalinoamarar21004',
'005-(2n)-002-k70000_yunguenobov362',
'005-(2n)-002-001-001-b-k69900_yucatantol389ica',
'005-(2n)-001-001-b-k69000_connortzac161',
'004-(2n)-001-001-b-k69400_onavenoson24',
'002-(2n)-003-001-b-k68900_bofodgo123',
'002-(2n)-003-001-001-b-k68700_altiplanobov903',
'(2n)-002-001-b-k70200_catetonortista-gini',
'(2n)-003-001-b-k69700_br105',
%
% others
%
'tp1-k14600_tp1',
'lesds-1-k16900_',
'newnecrotic-k62200_l522-10',
'les297-k16700_+',
'les-ats-k9500_b73ht1',
'les-74-1820-6-k14900_b73ht1mo17',
'camocf0-2-k19101_b73',
'camocf0-1-k19002_b73',
'lls1-K17700_'
	      ]).












pedigree_tree(primary_dominants,[
'les-tk1-k70309_w23',
'les1-k0104_mo20w',
'les1-k1900_w23',
'les2-k0200_mo20w',
'les2-k2000_w23',
'les2-n845a-k5500_les2-n845a',
'les4-k0300_mo20w',
'les4-k2100_w23',
'les6-k0400_mo20w',
'les6-k2200_w23',
'les7-k0500_mo20w',
'les7-k2300_w23',
'les8-k0600_mo20w',
'les8-k2400_w23',
'les9-k0700_mo20w',
'les9-k2500_w23',
'les10-k0800_mo20w',
'les10-k2600_w23',
'les11-k0900_mo20w',
'les12-k1000_mo20w',
'les12-k2700_w23',
'les13-k1100_mo20w',
'les13-k2800_w23',
'les15-n2007-k6700_w23',
'les17-k1300_mo20w',
'les17-k3000_w23',
'les18-k1400_mo20w',
'les18-k3100_w23',
'les19-k1500_mo20w',
'les19-k3200_w23',
'les20-n2457-k7100_w23',
'les20-n2459-k68600_w23',
'les21-k3300_w23',
'les21-n1442-k7200_b73ht1']).











pedigree_tree(primary_recessives,[
'les3-gj-k11900_+',
'les5-k11600_',
'les23-k1800_mo20w',
'les23-k3500_w23',
'les23-k16300_',
'lls1-k1700_mo20w',
'lls1-k10600_+',
'lls1121d-k3400_w23',
'lls1121d-k5300_lls1121d',
'les-tk2-k70404_mo20w'
	      ]).










pedigree_tree(puzzles,[
'lls1-n501b-k10500_+',
'les22-zebra-k16200_',
'rm1-k18200_rm1']).











pedigree_tree(secondary_dominants,[
'les-mi1-k12200_mop1',
'les-n1378-k7400_cm105',
'les-n2320-k8100_b73ht1',
'les-n2397-k8400_+',
'les-n2418-k8500_b73ag32',
'les-n2420-k13900_b73',
'les-na7145-k9100_b73ht1',
'les101-k11800_i-54',
'les102-k12000_i-52',
'lls1-nk-k17800_']).


















pedigree_tree(secondary_recessives,[
'cpc1-n2284b-k9600_+',
'csp1-k11500_',
'-k7500_les-n1395c',
'les-74-1873-9-k9300_+',
'les-b1-k62805_b73',
'les-n1395c-k7500_les-n1395c',
'les-n2012-k7700_+',
'les-n2013-k7800_les-n2013',
'les-n2290a-k8000_mo20w',
'les-n2333a-k8200_(b73ag32)',
'les-n2363a-k8300_+',
'les-n2502-k8700_les-n2502',
'les-na467-k9000_les-na467',
'les-pi262474-k13700_+',
'les-tilling1-k17400_',
'les28-k16400_',
'lesla-k17300_lesla',
'nec-6853-k10700_+',
'nec2-8147-k15300_+',
'spc1-n1376-k10900_w23',
'les-n1450-k7600_+']).












pedigree_tree(suppressors,[
'les-m1slm1ems-k17500_',
'les23slm1-k11300_',
'lls-sup-k17900_',
'rp1-d21-k18300_h95',
'rp1-d21-k18400_h95',
'rp1-d21-k18500_h95',
'rp1-d21-k18600_h95',
'rp1-kr1n-k18700_b73',
'rp1-kr1n-k18800_mo20w',
'rp1-nc3-k18900_rp1-nc3',
'slm1-m2ems-k17600_mo20w']).
    














%%%%%%%%%%%%%%%% older classification %%%%%%%%%%%%%%%%%%%%%%%%%


%% % revisions prior to recomputation
%% %
%% % Kazic, 26.5.2018




%% pedigree_tree(classify,[]).



%% pedigree_tree(crop_improvement,[
%%         'mo20W-K20501_mo20W',	
%%         'mo20W-K20506_mo20W',	
%%         'mo20W-K20511_mo20W',	
%%         'w23-K30504_w23',
%%         'w23-K30505_w23',
%%         'w23-K30506_w23',
%%         'w23-K30510_w23',
%%         'w23-K30511_w23',    
%%         'm14-K40501_m14',
%%         'm14-K40506_m14',
%%         'b73-K50403_b73',
%%         'b73-K50407_b73']).







%% pedigree_tree(exp_nonexp,[
%%         'les1Exp-_les1NonExp',
%%         'les2Exp-_les2NonExp',
%%         'les4Exp-_les4NonExp',
%%         'les5Exp-_les5Exp',
%%         'les6Exp-_les6NonExp',
%%         'les7Exp-_les7NonExp',
%%         'les8Exp-_les8NonExp',
%%         'les9Exp-_les9NonExp',
%%         'les10Exp-_les10NonExp',
%%         'les11Exp-_les11NonExp',
%%         'les12Exp-_les12NonExp',
%%         'les15Exp-_les15NonExp',
%%         'les17Exp-K4800_les17',
%%         'les18Exp-_les18NonExp',
%%         'les19Exp-_les19NonExp',
%%         'les20Exp-_les20NonExp',
%%         'les21Exp-_les21NonExp']).





%% pedigree_tree(gerrys_martys_babies,[
%%         'blh*-N1455-K14800_cM105',
%%         'blh-1455-K13000_+',
%%         'les-2240-K13300_a632',
%%         'les-2240-K15600_a632',
%%         'les-2274-K13400_m020YW23',
%%         'les-2318-K13500_mo20Y',  
%%         'les-2386-K13600_mo17',
%%         'les-A853-_+',
%%         'les*-Funk-4-K15000_+',
%%         'les*-NA853-K15100_w23B77',
%%         'll-264-K12500_mo20YW23',
%%         'll*-N264-K15200_+',
%%         'nec-490A-K12600_aCR',
%%         'nec-490A-K15700_aCR',
%%         'nec-831A-K12700_+',
%%         'nec-1521A-K13100_mo20W',
%%         'nec-1613-K13200_ahoRnj',
%%         'nec*-N490A-K15500_+',
%%         'nec*-N1613-K15400_+',
%%         'spt-1320C-_+']).







%% pedigree_tree(nam_fndrs,[
%%         'b97-K19400_b97',
%%         'cML103-K19500_cML103',
%%         'cML228-K19600_cML228',
%%         'cML247-K19700_cML247',
%%         'cML277-K19800_cML277',
%%         'cML322-K19900_cML322',
%%         'cML333-K60000_cML333',
%%         'cML52-K60100_cML52',
%%         'cML69-K60200_cML69',
%%         'hP301-K60300_hP301',
%%         'iL144-K60400_iL144',
%%         'ki11-K60500_ki11',
%%         'ki21-K60700_ki21',
%%         'ki3-K60600_ki3',
%%         'm162W-K60800_m162W',
%%         'm37W-K60900_m37W',
%%         'mS71-K61200_mS71',
%%         'mo17-K61000_mo17',
%%         'mo17-K61001_mo17',
%%         'mo18W-K61100_mo18W',
%%         'nC350-K61300_nC350',
%%         'nC358-K61400_nC358',
%%         'oh43-K61500_oh43',
%%         'oh78-K61600_oh78',
%%         'p39-K61700_p39',
%%         'tZi8-K61900_tZi8',
%%         'tx303-K61800_tx303',
%%         'w22R-r-K62000_w22R-r:Standard(Brink)']).







%% pedigree_tree(not_useful,[
%%         'acd2-K18000_',
%%         'camo-K13800_b73',
%%         'csp1-K18100_csp1',
%%         'd8-N1452-K14300_d8-N1452',
%%         'd8-N1591-K14200_d8-N1591',
%%         'd9-K14400_d9',
%%         'hsf1-K14100_hsf1',
%%         'ht1-_b73Ht1',
%%         'ht1-GE440-_ht1-GE440^M14',
%%         'ht1-Ladyfinger-_m14',
%%         'ht2-_ht2^A619',
%%         'ht4-_ht4',
%%         'htn1-_htn1^W22',
%%         'ij2-N8-_w22ij2-N8',
%%         'lep*-8691-_+',
%%         'les-EC91-K17100_b73',          % was b73_b73
%%         'les-EC91-K11700_c-13',         % was les-EC91_c-13
%%         'les-K17200_les',               % was b73_les
%%         'les*-3F-3330-_+',
%%         'les*-2119-_w23L317',
%%         'les*-N502C-K7300_b73Ht1',      % was +_b73Ht1
%%         'les*-N2015-K7900_+',
%%         'les*-N2420-K8600_m14',
%%         'les*-NA1176-K8900_b73AG32',
%%         'les*-PI251888-K9400_+',
%%         'les1-N843-_b73Ht1',
%%         'les2-GJ-K15800_',            % was +_
%%         'les3-GJ2-K15900_mo17',
%%         'les3-K5600_w23',
%%         'les4-N1375-K5700_b77',
%%         'les5-GJ-K16000_mo20W',       % was les5-GJ_mo20W
%%         'les5-GJ2-K16100_b73',
%%         'les5-N1449-K5800_w23',
%%         'les6-N1451-K5900_+',
%%         'les7-N1461-_w23',
%%         'les8-N2005-_w23',
%%         'les9-N2008-_(M14W23)',
%%         'les10-NA607-_w23',
%%         'les11-N1438-_w23',
%%         'les12-N1453-_w23',
%%         'les13-N2003-_w23',
%%         'les15-_mo20W',
%%         'les15-_w23',
%%         'les17-N2345-_w23',
%%         'les18-N2441-_w23',
%%         'les19-N2450-_w23',
%%         'les21-_mo20W',
%%         'les23-K11400_mo20W',
%%         'les101-K16500_les101',
%%         'les102-K16600_mo20W',
%%         'les2014-K16800_+',
%%         'lesDL(Mop1)-_mo20W',
%%         'mop1-_mop1mop1',
%%         'pl-Rhoades-_mcClintockfullcolor',
%%         'rhm1Y1-_rhm1Y1',
%%         'rp1-D21-K18300_h95',
%%         'rp1-D21-K18500_h95',
%%         'rp1-D21-K18600_h95',
%% %
%% % moved 
%% % Kazic, 5.6.2014
%% %
%%         'rp1-D21-K18400_h95',                           
%%         'rp1-Kr1n-K18700_b73',
%%         'rp1-Kr1n-K18800_mo20W',
%%         'rp1-nc3-K18900_rp1-nc3',
%%         'spc1-N1376-K14000_w23',
%%         'spc3-N553C-K11000_+',
%%         'tp2-K14700_tp2',
%%         'vms*-8522-_m14W23',
%%         'w22-_920021',
%%         'zn1-_zn1']).







%% pedigree_tree(primary_dominants,[
%%         'les1-_mo20W',
%%         'les1-_w23',
%%         'les2-_mo20W',
%%         'les2-_w23',
%%         'les2-N845A-_les2-N845A',       % was w23_les2-N845A
%%         'les4-_mo20W',
%%         'les4-_w23',
%%         'les6-_mo20W',
%%         'les6-_w23',
%%         'les7-_mo20W',
%%         'les7-_w23',
%%         'les8-_mo20W',
%%         'les8-_w23',
%%         'les9-_mo20W',
%%         'les9-_w23',
%%         'les10-_mo20W',
%%         'les10-_w23',
%%         'les11-_mo20W',
%%         'les12-_mo20W',
%%         'les12-_w23',
%%         'les13-_mo20W',
%%         'les13-_w23',
%%         'les15-N2007-_w23',
%%         'les17-_mo20W',
%%         'les17-_w23',
%%         'les18-_mo20W',
%%         'les18-_w23',
%%         'les19-_mo20W',
%%         'les19-_w23',
%%         'les20-N2457-_w23',
%%         'les21-_w23',
%%         'les21-N1442-_b73Ht1',
%% %
%% % moved based on phenotypic results for our backgrounds
%% % probably recessive for Guri Johal
%% %
%% % Kazic, 5.6.2014
%% %
%%         'lls1-nk-K17800_'               % was lls1-nk_

%%         ]).







%% pedigree_tree(primary_recessives,[
%%         'les3-GJ-K11900_+',             % was les3-GJ_+
%%         'les5-K11600_',                 % was les5_ ? enter harvest data!
%%         'lls1121D-K5300_lls1121D',       % was _lls1121D
%%         'lls1121D-K3400_w23',            % was lls1121D_w23
%%         'lls1-K10600_+',
%%         'lls1-_mo20W',
%%         'les23-K16300_',                 % was les23_
%%         'les23-_w23',
%%         'les23-_mo20W']).               






%% pedigree_tree(puzzles,[
%% %
%% % moved here as no recent phenotype, but check some time in the future
%% %
%% % Kazic, 5.6.2014
%% %
%%        'lls1-N501B-K10500_+',           % was lls1-N501B_+
%%         'les22-zebra-K16200_',
%%         'rm1-K18200_rm1'                 % was rm1_rm1
%%         ]).







%% pedigree_tree(secondary_dominants,[
%%         'd10-K14500_d10',                      % was musib_d10
%%         'les*-mi1-_mop1',
%%         'les*-N1378-_cM105',
%%         'les*-N2320-_b73Ht1',
%%         'les*-N2397-_+',
%%         'les*-N2418-_b73AG32',
%%         'les*-N2420-K13900_b73',               % was les*-N2420_b73
%%         'les*-NA7145-_b73Ht1',
%%         'les101-K11800_i-54',                  % was va35_i-54
%%         'les102-K12000_i-52',                  % was va35_i-52
%%         'lesDS*-1-_',
%%         'tp1-K14600_tp1',                      % was n_tp1
%%         'idfBPl@-K19200_idfBPl',                        
%%         'idfBPlsib-K19300_idfBPl']).








%% pedigree_tree(secondary_recessives,[
%%         '-_les*-N1395C',                        
%%         'camocf0-1-K19002_b73',
%%         'camocf0-2-K19101_b73',
%%         'cpc1-N2284B-K9600_+',
%%         'csp1-K11500_',
%%         'gRMZM2G157354_T03-K62100_gRMZM2G157354_T03',
%%         'les*-74-1820-6-K14900_b73Ht1Mo17',     % was les*-74-1820-6_b73Ht1Mo17
%%         'les*-74-1873-9-_+',
%%         'les*-ats-_b73Ht1',
%%         'les*-B1-K62805_b73',   
%%         'les*-N2012-_+',
%%         'les*-N2013-_les*-N2013',
%%         'les*-N2290A-_mo20W',
%%         'les*-N2333A-_(B73AG32)',               % was (Ht1les*-N2333A)_(B73AG32)
%%         'les*-N2363A-_+',
%%         'les*-N2502-_les*-N2502',
%%         'les*-NA467-_les*-NA467',
%%         'les*-PI262474-_+',
%%         'les*-tilling1-_',
%%         'les28-K16400_',
%%         'les297-K16700_+',
%%         'lesLA-_lesLA',                         % was +_lesLA
%%         'nec*-6853-_+',
%%         'nec2-8147-K15300_+',                   % was nec2-8147_+
%%         'newnecrotic-K62200_l522-10',  
%%         'spc1-N1376-K10900_w23',
%% %
%% % moved
%% %
%% % Kazic,5.6.2014
%% %
%%         'les*-N1450-_+'

%% ]).




%% pedigree_tree(suppressors,[
%%         'les-M1Slm1EMS-K17500_',                % was les-M1-Slm1EMS_
%%         'les23Slm1-K11300_',                    % was les23Slm1_
%%         'lls-sup-K17900_',
%%         'slm1-M2EMS-K17600_mo20W']).            % was b73_mo20W




%% pedigree_tree(braun,[
%%         'ij_like-K64214_',                
%%         'unk-K64311_',
%%         'unk-K64403_',
%%         'unk-K64509_',
%%         'unk-K64613_',
%%         'unk-K64703_',
%%         'osc_lg_wh_lg_chl-K64807_',
%%         'osc_lg_wh_lg_chl-K64914_',
%%         'osc_lg_wh_lg_chl-K65016_',
%%         'lg_yg_interveinal_streaks-K65109_',
%%         'lg_yg_interveinal_streaks-K65211_',
%%         'lg_yg_interveinal_streaks-K65313_',
%%         'diff_wh_nec-K65413_',
%%         'poss_les_ems-K66515_',
%%         'poss_les_ems-K66604_']).      



%% pedigree_tree(balint_kurti,[
%%         'les-R1-1-K66700_',                
%%         'les-R2-1-K66800_',                
%%         'les-R3-1-K66900_',                
%%         'les-R4-1-K67000_',                
%%         'les-R5-1-K67100_',                
%%         'les-R6-1-K67200_',                
%%         'les-R7-2-K67300_',                
%%         'les-R8-2-K67400_',                
%%         'les-R9-2-K67500_',                
%%         'les-R10-2-K67600_',                
%%         'les-R11-2-K67700_',                
%%         'les-R168-1-K67800_',                
%%         'les-R168-2-K67900_',                
%%         'les-R169-1-K68000_',                
%%         'les-R170-1-K68100_',                
%%         'les-R171-1-K68200_',                
%%         'les-R171-3-K68300_',                
%%         'les-R172-1-K68400_']).



    


%% pedigree_tree(gardner,[
%%         'altiplano-K68700_',                
%%         'ancashino-K68800_',                
%%         'bofo-K68900_',                
%%         'con_nort-K69000_',                
%%         'cristalino-K69100_',                
%%         'cristalino-K69200_',                
%%         'cuzco-K69300_',                
%%         'onaveno-K69400_',                
%%         'patillo-K69500_',                
%%         'patillo-K69600_',                
%%         'br105-K69700_',                
%%         'tehua-K69800_',                
%%         'yucatan-K69900_',                
%%         'yungueno-K70000_',                
%%         'yungueno-K70100_',                
%%         'cateto-K70200_']).




%% % pedigree_tree(,[
%% %         '-K_',                
%% %     ]).
    
