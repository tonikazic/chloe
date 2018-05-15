% this is ../c/maize/demeter/data/possibly_missing_data.pl


    
% This file assumes that any plant that was tagged should have the
% data supporting that tag --- most notably genotype.pl and the
% latex file used to generate the tags (probably could have also
% used the plant_list).
%
%    
% The 16r data in this file are derived from ../c/maize/demeter/data/16r_rows
%
% generated from listing the filenames of the numerical genotypes'' barcodes for the
% plant tags.  Inbreds and elites were removed; plant numbers ablated; list
% sorted and uniqued; then prologified by hand in emacs.
%
%
% Kazic, 5.5.2018


    
% possibly_missing_data(Crop,FamilyNum,PaddedRow,FirstPlantNumGtype,LastPlantNumGtype).    




    
% 16r

    
% these data are for sorting out the mutant data missing in 16r.    
% Missing facts are most likely to be packed_packet or planted, but
% will check for row_status ones too.
%
% Kazic, 4.5.2018
    
    
% missing packed_packet/7 and planted/8 facts reconstructed 
% and inserted into the appropriate files using fix_missing_data:fix_missing_data/2.
%
% Kazic, 13.5.2018

    
possibly_missing_data('16R',4460,r00036,'16R4460:0003601','16R4460:0003614').
possibly_missing_data('16R',4461,r00037,'16R4461:0003701','16R4461:0003715').
possibly_missing_data('16R',4462,r00038,'16R4462:0003801','16R4462:0003812').
possibly_missing_data('16R',4463,r00039,'16R4463:0003901','16R4463:0003914').
possibly_missing_data('16R',4464,r00040,'16R4464:0004001','16R4464:0004010').
possibly_missing_data('16R',4465,r00041,'16R4465:0004101','16R4465:0004114').
possibly_missing_data('16R',4466,r00042,'16R4466:0004201','16R4466:0004214').
possibly_missing_data('16R',4467,r00043,'16R4467:0004301','16R4467:0004315').
possibly_missing_data('16R',4468,r00044,'16R4468:0004401','16R4468:0004413').
possibly_missing_data('16R',4469,r00045,'16R4469:0004501','16R4469:0004515').
possibly_missing_data('16R',4470,r00046,'16R4470:0004601','16R4470:0004607').
possibly_missing_data('16R',4471,r00047,'16R4471:0004701','16R4471:0004714').
possibly_missing_data('16R',4472,r00048,'16R4472:0004801','16R4472:0004814').
possibly_missing_data('16R',4473,r00049,'16R4473:0004901','16R4473:0004912').
possibly_missing_data('16R',4474,r00050,'16R4474:0005001','16R4474:0005013').
possibly_missing_data('16R',4475,r00051,'16R4475:0005101','16R4475:0005113').
possibly_missing_data('16R',4476,r00052,'16R4476:0005201','16R4476:0005214').
possibly_missing_data('16R',4477,r00053,'16R4477:0005301','16R4477:0005312').
possibly_missing_data('16R',4478,r00054,'16R4478:0005401','16R4478:0005412').
possibly_missing_data('16R',4479,r00055,'16R4479:0005501','16R4479:0005511').
possibly_missing_data('16R',4480,r00056,'16R4480:0005601','16R4480:0005611').
possibly_missing_data('16R',4481,r00057,'16R4481:0005701','16R4481:0005712').
possibly_missing_data('16R',4482,r00058,'16R4482:0005801','16R4482:0005811').
possibly_missing_data('16R',4483,r00059,'16R4483:0005901','16R4483:0005911').
possibly_missing_data('16R',4484,r00060,'16R4484:0006001','16R4484:0006014').
possibly_missing_data('16R',4485,r00061,'16R4485:0006101','16R4485:0006113').
possibly_missing_data('16R',4486,r00062,'16R4486:0006201','16R4486:0006214').
possibly_missing_data('16R',4487,r00063,'16R4487:0006301','16R4487:0006314').
possibly_missing_data('16R',4488,r00064,'16R4488:0006401','16R4488:0006414').
possibly_missing_data('16R',4489,r00065,'16R4489:0006501','16R4489:0006512').
possibly_missing_data('16R',4227,r00066,'16R4227:0006601','16R4227:0006611').
possibly_missing_data('16R',4227,r00067,'16R4227:0006701','16R4227:0006712').
possibly_missing_data('16R',4228,r00068,'16R4228:0006801','16R4228:0006816').
possibly_missing_data('16R',4228,r00069,'16R4228:0006901','16R4228:0006919').
possibly_missing_data('16R',4441,r00070,'16R4441:0007001','16R4441:0007010').
possibly_missing_data('16R',4441,r00071,'16R4441:0007101','16R4441:0007113').
possibly_missing_data('16R',3946,r00072,'16R3946:0007201','16R3946:0007207').
possibly_missing_data('16R',3946,r00073,'16R3946:0007301','16R3946:0007310').
possibly_missing_data('16R',4085,r00074,'16R4085:0007401','16R4085:0007408').
possibly_missing_data('16R',4085,r00075,'16R4085:0007501','16R4085:0007512').
possibly_missing_data('16R',4086,r00076,'16R4086:0007601','16R4086:0007612').
possibly_missing_data('16R',4086,r00077,'16R4086:0007701','16R4086:0007714').
possibly_missing_data('16R',3590,r00078,'16R3590:0007801','16R3590:0007814').
possibly_missing_data('16R',3590,r00079,'16R3590:0007901','16R3590:0007913').
possibly_missing_data('16R',4491,r00080,'16R4491:0008001','16R4491:0008012').
possibly_missing_data('16R',4491,r00081,'16R4491:0008101','16R4491:0008113').
possibly_missing_data('16R',4492,r00082,'16R4492:0008201','16R4492:0008211').
possibly_missing_data('16R',4492,r00083,'16R4492:0008301','16R4492:0008309').
possibly_missing_data('16R',4493,r00084,'16R4493:0008401','16R4493:0008406').
possibly_missing_data('16R',4493,r00085,'16R4493:0008501','16R4493:0008508').
possibly_missing_data('16R',4494,r00086,'16R4494:0008601','16R4494:0008610').
possibly_missing_data('16R',4494,r00087,'16R4494:0008701','16R4494:0008714').
possibly_missing_data('16R',4092,r00088,'16R4092:0008801','16R4092:0008811').
possibly_missing_data('16R',4092,r00089,'16R4092:0008901','16R4092:0008914').
possibly_missing_data('16R',4452,r00090,'16R4452:0009001','16R4452:0009010').
possibly_missing_data('16R',4452,r00091,'16R4452:0009101','16R4452:0009113').
possibly_missing_data('16R',4496,r00092,'16R4496:0009201','16R4496:0009215').
possibly_missing_data('16R',4497,r00093,'16R4497:0009301','16R4497:0009310').
possibly_missing_data('16R',4222,r00094,'16R4222:0009401','16R4222:0009411').
possibly_missing_data('16R',4498,r00095,'16R4498:0009501','16R4498:0009514').
possibly_missing_data('16R',4499,r00096,'16R4499:0009601','16R4499:0009613').
possibly_missing_data('16R',4274,r00097,'16R4274:0009701','16R4274:0009705').
possibly_missing_data('16R',4445,r00098,'16R4445:0009801','16R4445:0009809').
possibly_missing_data('16R',4393,r00099,'16R4393:0009901','16R4393:0009915').
possibly_missing_data('16R',4356,r00100,'16R4356:0010001','16R4356:0010011').
possibly_missing_data('16R',3192,r00101,'16R3192:0010101','16R3192:0010114').
possibly_missing_data('16R',4503,r00102,'16R4503:0010201','16R4503:0010212').
possibly_missing_data('16R',3974,r00103,'16R3974:0010301','16R3974:0010314').
possibly_missing_data('16R',3607,r00104,'16R3607:0010401','16R3607:0010412').
possibly_missing_data('16R',4279,r00105,'16R4279:0010501','16R4279:0010511').
possibly_missing_data('16R',4390,r00106,'16R4390:0010601','16R4390:0010611').
possibly_missing_data('16R',4391,r00107,'16R4391:0010701','16R4391:0010712').
possibly_missing_data('16R',4392,r00108,'16R4392:0010801','16R4392:0010806').
possibly_missing_data('16R',4507,r00109,'16R4507:0010901','16R4507:0010913').
possibly_missing_data('16R',4508,r00110,'16R4508:0011001','16R4508:0011011').
possibly_missing_data('16R',4509,r00111,'16R4509:0011101','16R4509:0011110').
possibly_missing_data('16R',4510,r00112,'16R4510:0011201','16R4510:0011207').
possibly_missing_data('16R',4511,r00113,'16R4511:0011301','16R4511:0011311').
possibly_missing_data('16R',4512,r00114,'16R4512:0011401','16R4512:0011403').
possibly_missing_data('16R',4513,r00115,'16R4513:0011501','16R4513:0011504').
possibly_missing_data('16R',4007,r00116,'16R4007:0011601','16R4007:0011612').
possibly_missing_data('16R',4011,r00117,'16R4011:0011701','16R4011:0011713').
possibly_missing_data('16R',4514,r00118,'16R4514:0011801','16R4514:0011811').
possibly_missing_data('16R',4515,r00119,'16R4515:0011901','16R4515:0011911').
possibly_missing_data('16R',4516,r00120,'16R4516:0012001','16R4516:0012006').
possibly_missing_data('16R',4170,r00121,'16R4170:0012101','16R4170:0012102').
possibly_missing_data('16R',4027,r00122,'16R4027:0012201','16R4027:0012208').
possibly_missing_data('16R',4297,r00123,'16R4297:0012301','16R4297:0012309').
possibly_missing_data('16R',4298,r00124,'16R4298:0012401','16R4298:0012407').
possibly_missing_data('16R',4399,r00125,'16R4399:0012501','16R4399:0012509').
possibly_missing_data('16R',4300,r00126,'16R4300:0012601','16R4300:0012608').
possibly_missing_data('16R',4518,r00127,'16R4518:0012701','16R4518:0012704').
possibly_missing_data('16R',4519,r00128,'16R4519:0012801','16R4519:0012803').
possibly_missing_data('16R',4520,r00129,'16R4520:0012901','16R4520:0012911').
possibly_missing_data('16R',4521,r00130,'16R4521:0013001','16R4521:0013004').
possibly_missing_data('16R',4522,r00131,'16R4522:0013101','16R4522:0013111').
possibly_missing_data('16R',4523,r00132,'16R4523:0013201','16R4523:0013211').
possibly_missing_data('16R',4524,r00133,'16R4524:0013301','16R4524:0013310').
possibly_missing_data('16R',4525,r00134,'16R4525:0013401','16R4525:0013402').
possibly_missing_data('16R',4526,r00135,'16R4526:0013501','16R4526:0013511').
possibly_missing_data('16R',4527,r00136,'16R4527:0013601','16R4527:0013606').
possibly_missing_data('16R',4528,r00137,'16R4528:0013701','16R4528:0013713').
possibly_missing_data('16R',4529,r00138,'16R4529:0013801','16R4529:0013811').
possibly_missing_data('16R',4530,r00139,'16R4530:0013901','16R4530:0013906').
possibly_missing_data('16R',4531,r00140,'16R4531:0014001','16R4531:0014007').
possibly_missing_data('16R',4532,r00141,'16R4532:0014101','16R4532:0014106').
possibly_missing_data('16R',4533,r00142,'16R4533:0014201','16R4533:0014210').
possibly_missing_data('16R',4534,r00143,'16R4534:0014301','16R4534:0014311').
possibly_missing_data('16R',4535,r00144,'16R4535:0014401','16R4535:0014416').
possibly_missing_data('16R',4536,r00145,'16R4536:0014501','16R4536:0014512').
possibly_missing_data('16R',4537,r00146,'16R4537:0014601','16R4537:0014612').
possibly_missing_data('16R',687,r00147,'16R0687:0014701','16R0687:0014708').
possibly_missing_data('16R',688,r00148,'16R0688:0014801','16R0688:0014812').
possibly_missing_data('16R',689,r00149,'16R0689:0014901','16R0689:0014914').
possibly_missing_data('16R',690,r00150,'16R0690:0015001','16R0690:0015007').
possibly_missing_data('16R',691,r00151,'16R0691:0015101','16R0691:0015110').
possibly_missing_data('16R',692,r00152,'16R0692:0015201','16R0692:0015208').
possibly_missing_data('16R',693,r00153,'16R0693:0015301','16R0693:0015311').
possibly_missing_data('16R',694,r00154,'16R0694:0015401','16R0694:0015414').
possibly_missing_data('16R',695,r00155,'16R0695:0015501','16R0695:0015510').
possibly_missing_data('16R',696,r00156,'16R0696:0015601','16R0696:0015614').
possibly_missing_data('16R',697,r00157,'16R0697:0015701','16R0697:0015715').
possibly_missing_data('16R',698,r00158,'16R0698:0015801','16R0698:0015811').
possibly_missing_data('16R',699,r00159,'16R0699:0015901','16R0699:0015913').
possibly_missing_data('16R',700,r00160,'16R0700:0016001','16R0700:0016007').
possibly_missing_data('16R',701,r00161,'16R0701:0016101','16R0701:0016103').
possibly_missing_data('16R',702,r00162,'16R0702:0016201','16R0702:0016203').
    
