% compute pedigrees for just these genes and Ks, walk backwards along each
% branch from leaf and decide type of cross (s, w, m, @); count longest run
% of consecutive non-self types
%
% in subsequent crops, use the leaf nodes to pick the branch to follow:  so
% here, test branch to determine if leaf present, otherwise discard
%
%
% output K, Gene, SCount, WCount, MCount, BCount, TypeMutant
%
% Kazic, 25.12.2010



% track(Gene,K,MasOrFamilies,TypeMutant,PedigreeFile).

track('Les-102','K12008',['10R205:S0010004','10R305:W0011107'],d,'va35_i-52').
track('Les-102','K12011',['10R205:S0010011','10R305:W0011101'],d,'va35_i-52').
track('Les-EC91','K11703',['07R201:S0026213','07R401:M0030309'],d,'les-EC91_c-13').
track('Les?','K17200',[],d,'b73_les').
track('Les*-mi1','K12205',['10R205:S0009803','10R305:W0003007','10R405:M0001605'],d,'les*-mi1_mop1').
track('Les*-N1378','K7403',['10R205:S0009817','10R305:W0009102','10R405:M0006305'],d,'les*-N1378_cM105').
track('Les*-N1450','K7606',[3074,3075,3076],d,'les*-N1450_+').
track('Les*-N2320','K8114',['09R201:S0042602','09R301:W0051504','09R401:M0042403'],d,'les*-N2320_b73Ht1').
track('Les*-N2397','K8414',['06N201:S0014305','10R305:W0005416','09R401:M0045404'],d,'les*-N2397_+').
track('Les*-N2418','K8501',['10R205:S0010606','09R301:W0056314','10R405:M0001909'],d,'les*-N2418_b73AG32').
track('Les*-N2420','K13902',['10R405:M0008110'],d,'les*-N2420_b73').
track('Les*-N502C','K7300',[],d,'+_b73Ht1').
track('Les*-NA1176','K8900',[],d,'les*-NA1176_b73AG32').
track('Les*-NA7145','K9113',['10R205:S0006101','10R305:W0005915','10R405:M0006913'],d,'les*-NA7145_b73Ht1').
track('Les1','K0106',['10R205:S0003414','10R305:W0005903','10R405:M0000410'],d,'les1_mo20W').
track('Les1','K1903',['10R205:S0003415','10R305:W0004515','10R405:M0003801'],d,'les1_w23').
track('Les10','K0801',['0R205:S0010208','10R305:W0001513','06R0008:0000803'],d,'les10_mo20W').
track('Les10','K2606',['10R305:W0003902','06R0026:0002604'],d,'les10_w23').
track('Les101','K11802',['10R205:S0001101','10R305:W0010501','10R405:M0008108'],d,'va35_i-54').
track('Les101','K16500',[],d,'b73_les101').
track('Les102','K16600',[],d,'les102_mo20W').
track('Les11','K0901',['10R205:S0010007','10R305:W0005415','10R405:M0007201'],d,'les11_mo20W').
track('Les11-N1438','K6408',['10R205:S0010405','10R305:W0009704'],d,'les11-N1438_w23').
track('Les12','K1001',['10R205:S0006102','10R305:W0005908','10R405:M0007803'],d,'les12_mo20W').
track('Les12','K2711',['06R200:S00I9809','10R305:W0005911','10R405:M0008401'],d,'les12_w23').
track('Les13','K1109',['10R205:S0010006','06N301:W0006001','10R405:M0001609'],d,'les13_mo20W').
track('Les13','K2805',['10R205:S0000810','10R305:W0004801','10R405:M0000409'],d,'les13_w23').
track('Les15','K1208',['06N201:S0007407','06N301:W0009604','06N401:M0010907'],d,'les15_mo20W').
track('Les15','K2905',['06R200:SI18.104'],d,'les15_w23').
track('Les15-N2007','K6711',['10R205:S0002302','10R305:W0010502','10R405:M0006612'],d,'les15-N2007_w23').
track('Les17','K1309',['10R205:S0007009','10R305:W0010506','07R401:M0029409'],d,'les17_mo20W').
track('Les17','K3007',['10R205:S0003106','10R305:W0004511','10R405:M0006312'],d,'les17_w23').
track('Les18','K1411',['10R205:S0002606','09R301:W0045202','10R405:M0006309'],d,'les18_mo20W').
track('Les18','K3106',['10R205:S0006103','10R305:W0004211','10R405:M0006308'],d,'les18_w23').
track('Les19','K1501',['09R201:S0040802','10R305:W0010508','10R405:M0006307'],d,'les19_mo20W').
track('Les19','K1506',['10R205:S0010209','10R305:W0005917','10R405:M0006602'],d,'les19_mo20W').
track('Les19','K3206',['10R205:S0001410','10R305:W0010513','10R405:M0006912'],d,'les19_w23').
track('Les2','K0202',['10R205:S0007303','10R305:W0003609','10R405:M0003804'],d,'les2_mo20W').
track('Les2','K2002',['10R205:S0001701','10R305:W0006204','10R405:M0000411'],d,'les2_w23').
track('Les2-GJ','K15800',[],d,'+_').
track('Les2-N845A','K5515',['10R205:S0010019','10R305:W0004802','10R405:M0007808'],d,'w23_les2-N845A').
track('Les20-N2457','K7110',['10R205:S0001406','10R305:W0010509','10R405:M0008103'],d,'les20-N2457_w23').
track('Les21','K3311',['10R205:S0006706','10R305:W0004513','10R405:M0007208'],d,'les21_w23').
track('Les21-N1442','K7205',['10R205:S0001114','10R305:W0005105','10R405:M0000402'],d,'les21-N1442_b73Ht1').
track('Les22-zebra','K16200',[],d,'les22-zebra_').
track('Les28','K16400',[],d,'les28_').
track('Les297','K16700',[],d,'les297_+').
track('Les3','K15900',[],d,'les3_mo17').
track('Les3-GJ','K11901',['09R201:S0041701','09R301:W0041605','09R401:M0041801'],d,'les3_+').
track('Les4','K0302',['10R205:S0001702','10R305:W0006207','10R405:M0001316'],d,'les4_mo20W').
track('Les4','K0303',['10R205:S0007307','10R305:W0003603','10R405:M0005010'],d,'les4_mo20W').
track('Les4','K2101',['10R205:S0007903','07R301:W0025106','09R401:M0045307'],d,'les4_w23').
track('Les4','K2106',['10R205:S0000807','10R305:W0010519','10R405:M0001008'],d,'les4_w23').
track('Les5','K11613',['10R205:S0001415','07R301:W0024505'],d,'les5_').
track('Les5-GJ','K16000',[],d,'les5_mo20W').
track('Les5-GJ2','K16100',[],d,'les5_b73').
track('Les5-N1449','K5804',['10R205:S0010406','10R305:W0009503'],d,'les5-N1449_w23').
track('Les6','K0403',['10R205:S0007905','10R305:W0004503','10R405:M0006608'],d,'les6_mo20W').
track('Les6','K2202',['10R205:S0002011','10R305:W0003607','10R405:M0000706'],d,'les6_w23').
track('Les6','K2210',['10R205:S0007318','09R301:W0042501','10R405:M0006906'],d,'les6_w23').
track('Les6','K2212',['10R205:S0002309','10R205:S0002305','10R405:M0006601'],d,'les6_w23').
track('Les7','K0509',['10R205:S0002308','10R305:W0001502','10R405:M0007204'],d,'les7_mo20W').
track('Les7','K2312',['10R205:S0007001','09R301:W0040711','10R405:M0007509'],d,'les7_w23').
track('Les8','K0604',['10R205:S0003101','10R305:W0005109','10R405:M0007801'],d,'les8_mo20W').
track('Les8','K2405',['10R205:S0010601','10R305:W0004508','10R405:M0008407'],d,'les8_w23').
track('Les9','K0707',['10R205:S0007605','10R305:W0005405','10R405:M0007804'],d,'les9_mo20W').
track('Les9','K2506',['09R201:S0042010','10R305:W0005411, 10R405:M0007806'],d,'les9_w23').
track('LesDS*-1','K16909',['10R305:W0009709'],d,'lesDS*-1_').
track('lesLA','K35807',['10R205:S0010608','10R305:W0010911','10R405:M0007814'],d,'+_lesLA').
track('les*-2119','K9207',[1845],r,'les*-2119_w23L317').
track('les*-3F-3330','K8802',['06R400:MI71.205'],r,'les*-3F-3330_+').
track('les*-3F-3330','K8804',['06R400:MI71.204'],r,'les*-3F-3330_+').
track('les*-74-1820-6','K14906',['09R301:W0057201'],r,'les*-74-1820-6_b73Ht1Mo17').
track('les*-74-1873-9','K9304',['09R201:S0035401','09R201:S0039908','09R201:S0040208',1450,1848],r,'les*-74-1873-9_+').
track('les*-ats','K9502',[95],r,'les*-ats_b73Ht1').
track('les*-ats','K9503',[95],r,'les*-ats_b73Ht1').
track('les*-ats','K9544',[95],r,'les*-ats_b73Ht1').
track('les*-ats','K9509',[95],r,'les*-ats_b73Ht1').
track('les*-ats','K9510',[95],r,'les*-ats_b73Ht1').
track('les*-Funk-4','K15000',[95],r,'les*-Funk-4_+').
track('les*-N1395C','K7501',[1130,1456,1829],r,'les*-N1395C_les*-N1395C').
track('les*-N2012','K7702',['09R201:S0044504','09R301:W0056907','09R401:M0043207'],r,'les*-N2012_+').
track('les*-N2013','K7807',['09R201:S0051301','09R301:W0051201','09R401:M0051102'],r,'les*-N2013_les*-N2013').
track('les*-N2015','K7900',[],r,'les*-N2015_+').
track('les*-N2290A','K8002',['09R201:S0042303','09R301:W0056306','09R401:M0043205'],r,'les*-N2290A_mo20W').
track('les*-N2333A','K8203',[1442],r,'(Ht1les*-N2333A)_(B73AG32)').
track('les*-N2363A','K8304',[1837],r,'les*-N2363A_+').
track('les*-N2502','K8709',['06R200:S00I1009','09R1445:0005701','07R1838:0091911'],r,'les*-N2502_les*-N2502').
track('les*-NA467','K9001',[1133,'06R400:M00I8107'],r,'les*-NA467_les*-NA467').
track('les*-NA467','K9006',[1134],r,'les*-NA467_les*-NA467').
track('les*-NA853','K15100',['09R0151:0054604','09R0151:0054608','09R0151:0054609','09R0151:0054614'],r,'les*-NA853_w23B77').
track('les*-PI251888','K9405',['06R400:M00I7804'],r,'les*-PI251888_+').
track('les*-PI251888','K9406',['06R0094:0009401'],r,'les*-PI251888_+').
track('les*-PI251888','K9412',['06R0094:0009408'],r,'les*-PI251888_+').
track('les*-PI262474','K13708',['09R201:S0041708','09R301:W0041606','09R401:M0044404'],r,'les*-PI262474_+').
track('les*-PI262474','K13714',['09R201:S0041703','09R301:W0041604','09R401:M0044403'],r,'les*-PI262474_+').
track('les*-tilling1','K17404',['10R305:W0011109','10R405:M0007510'],r,'les*-tilling1_').
track('les2014','K16800',[],r,'les2014_+').
track('les23','K16300',['10R0163:0000000'],r,'les23_').
track('les23','K1802',[1057,2172,2175],r,'les23_mo20W').
track('les23','K1804',['10R1003:0011404',2200],r,'les23_mo20W').
track('les23','K3514',[1008,1009,'09R401:M0033011'],r,'les23_w23').
track('les23 Slm1','K11304',[1016,1017,1019],r,'les23slm1_').
track('ll*-N264','K15200',[152],r,'ll*-N264_+').
track('lls1','K10600',[106,'06R0106:0000000'],r,'lls1_+').
track('lls1','K1702',['10R205:S0001412','06N301:W0008109','10R405:M0005313'],r,'lls1_mo20W').
track('lls1','K17700',[],r,'lls1_').
track('lls1 121D','K3400',[],r,'lls1121D_w23').
track('lls1-N501B','K10500',[105,1120,1849,150],r,'lls1-N501B_+').
track('lls1-nk','K17800',[],r,'newlls1kind_').
track('lls1121D','K5302',['06R0053:0005309'],r,'_lls1121D').
track('lls1121D','K5311',['06R0053:0005312'],r,'_lls1121D').
track('nec*-6853','K10712',[1207,1514],r,'nec*-6853_+').
track('nec*-N1613','K15400',[154,'09R0154:0054907'],r,'nec*-N1613_+').
track('nec*-N490A','K15500',[155],r,'nec*-N490A_+').
track('nec2-8147','K15300',[],r,'nec2-8147_+').
