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




% latest revisions
%
% Kazic, 5.6.2014




pedigree_tree(classify,[]).



pedigree_tree(crop_improvement,[
        'mo20W-K20501_mo20W',	
        'mo20W-K20506_mo20W',	
        'mo20W-K20511_mo20W',	
        'w23-K30504_w23',
        'w23-K30505_w23',
        'w23-K30506_w23',
        'w23-K30510_w23',
        'w23-K30511_w23',    
        'm14-K40501_m14',
        'm14-K40506_m14',
        'b73-K50403_b73',
        'b73-K50407_b73']).







pedigree_tree(exp_nonexp,[
        'les1Exp-_les1NonExp',
        'les2Exp-_les2NonExp',
        'les4Exp-_les4NonExp',
        'les5Exp-_les5Exp',
        'les6Exp-_les6NonExp',
        'les7Exp-_les7NonExp',
        'les8Exp-_les8NonExp',
        'les9Exp-_les9NonExp',
        'les10Exp-_les10NonExp',
        'les11Exp-_les11NonExp',
        'les12Exp-_les12NonExp',
        'les15Exp-_les15NonExp',
        'les17Exp-K4800_les17',
        'les18Exp-_les18NonExp',
        'les19Exp-_les19NonExp',
        'les20Exp-_les20NonExp',
        'les21Exp-_les21NonExp']).





pedigree_tree(gerrys_martys_babies,[
        'blh*-N1455-K14800_cM105',
        'blh-1455-K13000_+',
        'les-2240-K13300_a632',
        'les-2240-K15600_a632',
        'les-2274-K13400_m020YW23',
        'les-2318-K13500_mo20Y',  
        'les-2386-K13600_mo17',
        'les-A853-_+',
        'les*-Funk-4-K15000_+',
        'les*-NA853-K15100_w23B77',
        'll-264-K12500_mo20YW23',
        'll*-N264-K15200_+',
        'nec-490A-K12600_aCR',
        'nec-490A-K15700_aCR',
        'nec-831A-K12700_+',
        'nec-1521A-K13100_mo20W',
        'nec-1613-K13200_ahoRnj',
        'nec*-N490A-K15500_+',
        'nec*-N1613-K15400_+',
        'spt-1320C-_+']).







pedigree_tree(nam_fndrs,[
        'b97-K19400_b97',
        'cML103-K19500_cML103',
        'cML228-K19600_cML228',
        'cML247-K19700_cML247',
        'cML277-K19800_cML277',
        'cML322-K19900_cML322',
        'cML333-K60000_cML333',
        'cML52-K60100_cML52',
        'cML69-K60200_cML69',
        'hP301-K60300_hP301',
        'iL144-K60400_iL144',
        'ki11-K60500_ki11',
        'ki21-K60700_ki21',
        'ki3-K60600_ki3',
        'm162W-K60800_m162W',
        'm37W-K60900_m37W',
        'mS71-K61200_mS71',
        'mo17-K61000_mo17',
        'mo17-K61001_mo17',
        'mo18W-K61100_mo18W',
        'nC350-K61300_nC350',
        'nC358-K61400_nC358',
        'oh43-K61500_oh43',
        'oh78-K61600_oh78',
        'p39-K61700_p39',
        'tZi8-K61900_tZi8',
        'tx303-K61800_tx303',
        'w22R-r-K62000_w22R-r:Standard(Brink)']).







pedigree_tree(not_useful,[
        'acd2-K18000_',
        'camo-K13800_b73',
        'csp1-K18100_csp1',
        'd8-N1452-K14300_d8-N1452',
        'd8-N1591-K14200_d8-N1591',
        'd9-K14400_d9',
        'hsf1-K14100_hsf1',
        'ht1-_b73Ht1',
        'ht1-GE440-_ht1-GE440^M14',
        'ht1-Ladyfinger-_m14',
        'ht2-_ht2^A619',
        'ht4-_ht4',
        'htn1-_htn1^W22',
        'ij2-N8-_w22ij2-N8',
        'lep*-8691-_+',
        'les-EC91-K17100_b73',          % was b73_b73
        'les-EC91-K11700_c-13',                % was les-EC91_c-13
        'les-K17200_les',               % was b73_les
        'les*-3F-3330-_+',
        'les*-2119-_w23L317',
        'les*-N502C-K7300_b73Ht1',      % was +_b73Ht1
        'les*-N2015-K7900_+',
        'les*-N2420-K8600_m14',
        'les*-NA1176-K8900_b73AG32',
        'les*-PI251888-K9400_+',
        'les1-N843-_b73Ht1',
        'les2-GJ-K15800_',            % was +_
        'les3-GJ2-K15900_mo17',
        'les3-K5600_w23',
        'les4-N1375-K5700_b77',
        'les5-GJ-K16000_mo20W',       % was les5-GJ_mo20W
        'les5-GJ2-K16100_b73',
        'les5-N1449-K5800_w23',
        'les6-N1451-K5900_+',
        'les7-N1461-_w23',
        'les8-N2005-_w23',
        'les9-N2008-_(M14W23)',
        'les10-NA607-_w23',
        'les11-N1438-_w23',
        'les12-N1453-_w23',
        'les13-N2003-_w23',
        'les15-_mo20W',
        'les15-_w23',
        'les17-N2345-_w23',
        'les18-N2441-_w23',
        'les19-N2450-_w23',
        'les21-_mo20W',
        'les23-K11400_mo20W',
        'les101-K16500_les101',
        'les102-K16600_mo20W',
        'les2014-K16800_+',
        'lesDL(Mop1)-_mo20W',
        'lls1-K17700_',
        'mop1-_mop1mop1',
        'pl-Rhoades-_mcClintockfullcolor',
        'rhm1Y1-_rhm1Y1',
        'rp1-D21-K18300_h95',
        'rp1-D21-K18500_h95',
        'rp1-D21-K18600_h95',
%
% moved 
% Kazic, 5.6.2014
%
        'rp1-D21-K18400_h95',                           
        'rp1-Kr1n-K18700_b73',
        'rp1-Kr1n-K18800_mo20W',
        'rp1-nc3-K18900_rp1-nc3',
        'spc1-N1376-K14000_w23',
        'spc3-N553C-K11000_+',
        'tp2-K14700_tp2',
        'vms*-8522-_m14W23',
        'w22-_920021',
        'zn1-_zn1']).







pedigree_tree(primary_dominants,[
        'les1-_mo20W',
        'les1-_w23',
        'les2-_mo20W',
        'les2-_w23',
        'les2-N845A-_les2-N845A',       % was w23_les2-N845A
        'les4-_mo20W',
        'les4-_w23',
        'les6-_mo20W',
        'les6-_w23',
        'les7-_mo20W',
        'les7-_w23',
        'les8-_mo20W',
        'les8-_w23',
        'les9-_mo20W',
        'les9-_w23',
        'les10-_mo20W',
        'les10-_w23',
        'les11-_mo20W',
        'les12-_mo20W',
        'les12-_w23',
        'les13-_mo20W',
        'les13-_w23',
        'les15-N2007-_w23',
        'les17-_mo20W',
        'les17-_w23',
        'les18-_mo20W',
        'les18-_w23',
        'les19-_mo20W',
        'les19-_w23',
        'les20-N2457-_w23',
        'les21-_w23',
        'les21-N1442-_b73Ht1',
%
% moved based on phenotypic results for our backgrounds
% probably recessive for Guri Johal
%
% Kazic, 5.6.2014
%
        'lls1-nk-K17800_'               % was lls1-nk_

        ]).







pedigree_tree(primary_recessives,[
        'les3-GJ-K11900_+',             % was les3-GJ_+
        'les5-K11600_',                 % was les5_ ? enter harvest data!
        'lls1121D-K5300_lls1121D',       % was _lls1121D
        'lls1121D-K3400_w23',            % was lls1121D_w23
        'lls1-K10600_+',
        'lls1-_mo20W',
        'les23-K16300_',                 % was les23_
        'les23-_w23',
        'les23-_mo20W']).               






pedigree_tree(puzzles,[
%
% moved here as no recent phenotype, but check some time in the future
%
% Kazic, 5.6.2014
%
       'lls1-N501B-K10500_+',           % was lls1-N501B_+
        'les22-zebra-K16200_',
        'rm1-K18200_rm1'                 % was rm1_rm1
        ]).







pedigree_tree(secondary_dominants,[
        'd10-K14500_d10',                      % was musib_d10
        'les*-mi1-_mop1',
        'les*-N1378-_cM105',
        'les*-N2320-_b73Ht1',
        'les*-N2397-_+',
        'les*-N2418-_b73AG32',
        'les*-N2420-K13900_b73',               % was les*-N2420_b73
        'les*-NA7145-_b73Ht1',
        'les101-K11800_i-54',                  % was va35_i-54
        'les102-K12000_i-52',                  % was va35_i-52
        'lesDS*-1-_',
        'tp1-K14600_tp1',                      % was n_tp1
        'idfBPl@-K19200_idfBPl',                        
        'idfBPlsib-K19300_idfBPl']).








pedigree_tree(secondary_recessives,[
        '-_les*-N1395C',                        % was les*-N1395C_les*-N1395C
        'camocf0-1-K19002_b73',
        'camocf0-2-K19101_b73',
        'cpc1-N2284B-K9600_+',
        'csp1-K11500_',
        'gRMZM2G157354_T03-K62100_gRMZM2G157354_T03',
        'les*-74-1820-6-K14900_b73Ht1Mo17',     % was les*-74-1820-6_b73Ht1Mo17
        'les*-74-1873-9-_+',
        'les*-ats-_b73Ht1',
        'les*-B1-K62805_b73',   
        'les*-N2012-_+',
        'les*-N2013-_les*-N2013',
        'les*-N2290A-_mo20W',
        'les*-N2333A-_(B73AG32)',               % was (Ht1les*-N2333A)_(B73AG32)
        'les*-N2363A-_+',
        'les*-N2502-_les*-N2502',
        'les*-NA467-_les*-NA467',
        'les*-PI262474-_+',
        'les*-tilling1-_',
        'les28-K16400_',
        'les297-K16700_+',
        'lesLA-_lesLA',                         % was +_lesLA
        'nec*-6853-_+',
        'nec2-8147-K15300_+',                   % was nec2-8147_+
        'newnecrotic-K62200_l522-10',  
        'spc1-N1376-K10900_w23',
%
% moved
%
% Kazic,5.6.2014
%
        'les*-N1450-_+'

]).




pedigree_tree(suppressors,[
        'les-M1Slm1EMS-K17500_',                % was les-M1-Slm1EMS_
        'les23Slm1-K11300_',                    % was les23Slm1_
        'lls-sup-K17900_',
        'slm1-M2EMS-K17600_mo20W']).            % was b73_mo20W

































