% this is ../c/maize/demeter/data/branch_status.pl

% for each mutant/Knum/background combination, are we there yet?
%
% this file should be revised for each crop after the pedigrees are
% computed: it is maintained BY HAND.
%
% Kazic, 22.5.2020




% flagged recessives as such for easier recognition
%
% Kazic, 25.5.2020


% revised 28.5.2021 in preparation for 21r
%
% Kazic, 28.5.2021





% branch_status/11

% branch_status(Mutant,Knum,Inbred,ListCompleted,Comment,TerminalFamily,TerminalMa,TerminalPa,Date,Time,Observer).
%
% Comment includes the furthest along backcross: ['6th','3rd'], etc
% Numeral of the backcross must begin the Comment string.
% TerminalFamily = 0, TerminalMa and TerminalPa are the parents to continue the branch
%
% OR
% If we're at the 6th backcross, then comment includes the quality/status of the ears
% ['infertile ear','no ear','check ear','ok ear'].
%
% TerminalFamily is the family with the bulks, etc;
% TerminalMa and TerminalPa are the parents to use for bulking, etc.
%
% ListCompleted is whatever is done in [inc,'B',self].
%
%
%
% Comment out facts for abandoned Knums.
%
% data are processed by pedigrees:check_status_branches/3
%
% Kazic, 11.5.2022


% branch_status('','K','',[],'',,'',date(22,5,2020),time(12,00,00),toni).






% revised to include 21r results
%
% Kazic, 11.5.2022


% primary dominants



% Les1

branch_status('Les1','K1903','Mo20W',[inc,'B',self],'ok ear',4440,'14R205:S0000212','14R4144:0019801',date(11,5,2022),time(12,00,00),toni).
branch_status('Les1','K1903','W23',[inc,'B',self],'ok ear',3556,'11N305:W0031406','11N3397:0007404',date(11,5,2022),time(12,00,00),toni).
branch_status('Les1','K1903','M14',[inc,'B',self],'ok ear',3908,'12R405:M0003306','12R3557:0018607',date(11,5,2022),time(12,00,00),toni).






% Les2

branch_status('Les2','K0202','Mo20W',[inc,self,'B'],'6th; ear should be ok',4074,'12N205:S0036112','12N3912:0008310',date(11,5,2022),time(12,00,00),toni).
branch_status('Les2','K0202','W23',[inc,self,'B'],'6th',0,'19R305:W0000702','19R4771:0018611',date(11,5,2022),time(12,00,00),toni).
% branch_status('Les2','K0202','M14',[],'6th; plant 23r, 22r has 0.25 germination rate',0,'16R405:M0003112','16R4222:0009405',date(11,5,2022),time(12,00,00),toni).


branch_status('Les2','K0202','M14',[],'5th; reach back',0,'13R405:M0002503','13R4076:0004203',date(21,3,2024),time(23,00,00),toni).
branch_status('Les2','K0202','M14',[],'5th; reach back',0,'13R405:M0002608','13R4076:0004202',date(21,3,2024),time(23,00,00),toni).
branch_status('Les2','K0202','M14',[],'6th; 23r had 0.47 germination rate, 3/19 mutants; do not miss, low cl',0,'16R405:M0003211','16R4222:0009409',date(21,3,2024),time(23,00,00),toni).


branch_status('Les2','K0203','Mo20W',[inc,'B',self],'ok ear',3402,'11R205:S0052004','11R3247:0053608',date(11,5,2022),time(12,00,00),toni).
branch_status('Les2','K0203','W23',[inc,'B',self],'ok ear',3915,'12R305:W0000211','12R3566:0019512',date(11,5,2022),time(12,00,00),toni).
% branch_status('Les2','K0203','M14',['B'],'6th; 0.52 germinatn rate, 3/42 mutants in 23r',0,'14R405:M0001806','14R4077:0007406',date(11,5,2022),time(12,00,00),toni).

branch_status('Les2','K0203','M14',['B'],'6th bulked; parent 14R405:M0001806 had 0.52 germinatn rate, 3/42 mutants in 23r',0,'22R4457:0007402','22R4457:0007404',date(21,3,2024),time(23,00,00),toni).


branch_status('Les2','K0207','Mo20W',[inc,'B',self],'ok ear',4078,'12N205:S0036412','12N3920:0011307',date(11,5,2022),time(12,00,00),toni).
branch_status('Les2','K0207','W23',[inc,'B',self],'6th',4792,'19R305:W0000704','19R4772:0018706',date(11,5,2022),time(12,00,00),toni).
branch_status('Les2','K0207','M14',[inc,'B',self],'ok ear; bulk if room, have 2.5',4225,'13R405:M0002504','13R4079:0004909',date(11,5,2022),time(12,00,00),toni).






branch_status('Les2','K2002','Mo20W',[inc,'B',self],'ok ear',4080,'12N205:S0038508','12N3921:0011908',date(11,5,2022),time(12,00,00),toni).
branch_status('Les2','K2002','W23',[inc,'B',self],'ok ear',3571,'11N305:W0031109','11N3408:0009003',date(11,5,2022),time(12,00,00),toni).
branch_status('Les2','K2002','M14',[inc,'B',self],'ok ear',4226,'13R405:M0002602','13R4081:0005403',date(11,5,2022),time(12,00,00),toni).





% Les2-N845A

branch_status('Les2-N845A','K5515','Mo20W',[inc,'B',self],'ok ear',4258,'13R205:S0000507','13R4145:0018815',date(11,5,2022),time(12,00,00),toni).
branch_status('Les2-N845A','K5515','W23',[inc,'B'],'6th; missed self in 23r; check phe, ear carefully; 0.83 germinatn rate 6/50 mutants in 23r, ',4448,'14R305:W0000905','14R4273:0020102',date(22,3,2024),time(7,00,00),toni).
branch_status('Les2-N845A','K5515','M14',[inc,'B',self],'ok ear; B is sixteenth',4649,'17R405:M0002113','17R4564:0016707',date(11,5,2022),time(12,00,00),toni).




branch_status('Les2-N845A','K5525','',[inc,'B',self],'6th',4562,'17R205:S0001205','17R4562:0016808',date(11,5,2022),time(12,00,00),toni).
branch_status('Les2-N845A','K5525','',[],'4th, very small, infrequent lesions near tip in 23r',0,'23R305:W0006904','23R4936:0022312',date(24,3,2024),time(18,00,00),toni).
branch_status('Les2-N845A','K5525','',[inc,'B',self],'check ear, phe',4259,'13R405:M0002101','13R4150:0019405',date(11,5,2022),time(12,00,00),toni).



% Les4

branch_status('Les4','K0302','Mo20W',[inc,'B',self],'ok ear',4227,'13R205:S0002205','13R4082:0005502',date(11,5,2022),time(12,00,00),toni).
branch_status('Les4','K0302','W23',[inc,'B',self],'ok ear',4228,'13R305:W0000702','13R4083:0005603',date(11,5,2022),time(12,00,00),toni).
branch_status('Les4','K0302','M14',[inc,'B',self],'ok ear',3584,'11N405:M0034004','11N3413:0009901',date(11,5,2022),time(12,00,00),toni).



branch_status('Les4','K0303','Mo20W',[inc,'B',self],'ok ear',4441,'14R205:S0000215','14R4229:0009701',date(11,5,2022),time(12,00,00),toni).
branch_status('Les4','K0303','W23',[inc,'B',self],'ok ear',3943,'12R305:W0000210','12R3586:0023008',date(11,5,2022),time(12,00,00),toni).
branch_status('Les4','K0303','M14',[inc,'B'],'infertile ear',3946,'12R405:M0000310','12R3587:0023110',date(11,5,2022),time(12,00,00),toni).




branch_status('Les4','K2101','Mo20W',[inc,'B',self],'ok ear',4085,'12N205:S0036705','12N3948:0017506',date(11,5,2022),time(12,00,00),toni).
branch_status('Les4','K2101','W23',[inc,'B',self],'ok ear',4086,'12N305:W0038310','12N3949:0017706',date(11,5,2022),time(12,00,00),toni).
branch_status('Les4','K2101','M14',[inc,'B'],'infertile ear',3590,'11N405:M0032808','11N3419:0010704',date(11,5,2022),time(12,00,00),toni).



branch_status('Les4','K2106','Mo20W',[],'is 6th! germination rate 0.65, 5/26 mutants in 23r, missed',0,'22R205:S0015606','22R4939:0018207',date(28,3,2024),time(21,00,00),toni).
branch_status('Les4','K2106','W23',[inc,'B',self],'ok ear',4491,'15R305:W0000711','15R4352:0010904',date(11,5,2022),time(12,00,00),toni).
branch_status('Les4','K2106','M14',[inc,'B'],'infertile ear',4492,'15R405:M0001101','15R4353:0011002',date(11,5,2022),time(12,00,00),toni).




% Les6

branch_status('Les6','K0403','Mo20W',[inc,'B'],'infertile ear',4260,'11N205:S0037004','11N3433:0012810',date(11,5,2022),time(12,00,00),toni).
branch_status('Les6','K0403','W23',[inc,'B'],'infertile ear',4106,'12N3962:0020204','12N3962:0020211',date(11,5,2022),time(12,00,00),toni).
branch_status('Les6','K0403','M14',['B'],'no ear; 6th in M; 0.35 germination rate, 4/7 mutants, 1 with poor tassel in 19r; cl running low',4429,'13R4087:0006905','13R4087:0006903',date(28,3,2024),time(21,00,00),toni).
branch_status('Les6','K0403','M14',['B'],'no ear; bulked 6th in M, just in case there is not enough 13R4087:0006905',4429,'19R4429:0004504','19R4429:0004503',date(28,3,2024),time(21,00,00),toni).





branch_status('Les6','K2202','Mo20W',[inc,'B'],'no ear',4088,'12N205:S0038208','12N3965:0020603',date(11,5,2022),time(12,00,00),toni).
branch_status('Les6','K2202','W23',[inc,'B',self],'ok ear',3966,'12R305:W0000208','12R3602:0025213',date(11,5,2022),time(12,00,00),toni).
branch_status('Les6','K2202','M14',[inc,'B'],'no ear',4651,'15R405:M0001205','15R4355:0011403',date(11,5,2022),time(12,00,00),toni).


% S self 13R4089:0007210','13R4089:0007210 in pedigree and harvest but not inventory --- look for this in seed room!
branch_status('Les6','K2212','Mo20W',[inc,'B',self],'ok ear',4089,'12N205:S0041602','12N3970:0021101',date(11,5,2022),time(12,00,00),toni).
branch_status('Les6','K2212','W23',[inc,'B',self],'ok ear',4090,'12N305:W0037407','12N3971:0021212',date(11,5,2022),time(12,00,00),toni).
branch_status('Les6','K2212','M14',[inc,'B'],'no ear',4561,'16R405:M0001811','16R4356:0010005',date(11,5,2022),time(12,00,00),toni).




% Les7 --- a mess in W

branch_status('Les7','K0509','Mo20W',[inc,'B',self],'ok ear',4091,'12N205:S0037911','12N3973:0021509',date(11,5,2022),time(12,00,00),toni).

% planted all in 22r and no phe; wuzzaup?
%
% Kazic, 10.4.2023

% branch_status('Les7','K0509','W23',[],'1st; check phe',0,'06N301:W0031407','06N1005:0003607',date(11,5,2022),time(12,00,00),toni).
% branch_status('Les7','K0509','W23',[],'2nd; check phe',0,'09R301:W0042810','09R2427:0019103',date(11,5,2022),time(12,00,00),toni).
% branch_status('Les7','K0509','W23',[],'3rd; check phe',0,'10R305:W0001502','10R1035:0021906',date(11,5,2022),time(12,00,00),toni).
% branch_status('Les7','K0509','W23',[],'4th; check phe',0,'11N305:W0030810','11N3192:0013803',date(11,5,2022),time(12,00,00),toni).
% branch_status('Les7','K0509','W23',[],'4th; check phe',0,'11N305:W0039501','11N3192:0013810',date(11,5,2022),time(12,00,00),toni).
% branch_status('Les7','K0509','W23',[],'5th; check phe',0,'16R305:W0001607','16R3607:0010403',date(11,5,2022),time(12,00,00),toni).
% branch_status('Les7','K0509','W23',[],'5th; check phe',0,'16R305:W0001609','16R3607:0010402',date(11,5,2022),time(12,00,00),toni).
% branch_status('Les7','K0509','W23',[],'5th; check phe',0,'13R305:W0000803','13R3974:0021303',date(11,5,2022),time(12,00,00),toni).

% branch_status('Les7','K0509','W23',[],'6th; check phe; have some bulks and a self',4762,'16R305:W0002915','16R4279:0010511',date(11,5,2022),time(12,00,00),toni).
% branch_status('Les7','K0509','W23',[],'6th; check phe',0,'16R305:W0001610','16R4279:0010511',date(11,5,2022),time(12,00,00),toni).


branch_status('Les7','K0509','W23',[],'1st; phe lost down this branch',0,'06N301:W0031407','06N1005:0003607',date(22,3,2024),time(7,00,00),toni).
branch_status('Les7','K0509','W23',[],'1st alt',0,'06N301:W0035005','06N1609:0020311',date(22,3,2024),time(7,00,00),toni).


branch_status('Les7','K0509','M14',[inc,'B',self],'ok ear; low cl terminal parent',3975,'12R405:M0000601','12R3608:0025901',date(11,5,2022),time(12,00,00),toni).





branch_status('Les7','K2312','Mo20W',[inc,'B',self],'ok ear',4654,'16R205:S0001301','16R4390:0010611',date(11,5,2022),time(12,00,00),toni).
branch_status('Les7','K2312','W23',[inc,'B'],'no ear',4656,'15R305:W0000707','15R4360:0012608',date(11,5,2022),time(12,00,00),toni).
branch_status('Les7','K2312','M14',[inc,'B',self],'ok ear; poor germinatn 20r',4657,'14R405:M0001212','14R4282:0021303',date(11,5,2022),time(12,00,00),toni).





% Les8

branch_status('Les8','K0601','Mo20W',[],'5th; infrequent, chlorotic lesions with fuzzy boundaries',0,'23R205:S0005902','23R5017:0022706',date(24,3,2024),time(18,00,00),toni).
branch_status('Les8','K0601','W23',[],'6th; lotsa lesions',0,'23R305:W0006808','23R5018:0022811',date(10,4,2023),time(12,00,00),toni).
branch_status('Les8','K0601','M14',[],'4th, 0.49 germination rate, 18/39 mutants in 23r, missed, seems tassels ok; pa had plenty of lesions, so may be fast',0,'21R405:M0001313','21R4868:0011905',date(10,4,2023),time(12,00,00),toni).



branch_status('Les8','K0604','Mo20W',[inc,'B',self],'ok ear',3980,'12R205:S0002812','12R3611:0026307',date(11,5,2022),time(12,00,00),toni).
branch_status('Les8','K0604','W23',[inc,'B',self],'ok ear',3983,'12R305:W0000202','12R3612:0026412',date(11,5,2022),time(12,00,00),toni).
branch_status('Les8','K0604','M14',[inc,'B',self],'ok ear',4453,'14R405:M0001105','14R4283:0021405',date(10,4,2023),time(12,00,00),toni).


branch_status('Les8','K2405','Mo20W',[inc,'B',self],'ok ear',4494,'14R205:S0000105','14R4284:0021512',date(11,5,2022),time(12,00,00),toni).
branch_status('Les8','K2405','W23',[inc,'B',self],'ok ear',4092,'12N305:W0039207','12N3614:0024110',date(11,5,2022),time(12,00,00),toni).
branch_status('Les8','K2405','M14',[inc,'B'],'infertile ear',4452,'14R405:M0001103','14R4285:0021603',date(11,5,2022),time(12,00,00),toni).





% Les9

% good segmentatn challenge for Chimdi

branch_status('Les9','K0707','Mo20W',[inc,'B'],'infertile ear',3616,'11N205:S0036710','11N3445:0015105',date(13,5,2022),time(12,00,00),toni).
branch_status('Les9','K0707','W23',[inc,'B'],'infertile ear, thin stem',4262,'13R4093:0008004','13R4093:0008006',date(13,5,2022),time(12,00,00),toni).
branch_status('Les9','K0707','M14',['B',self],'somewhat infertile ear and tassel; need one more good bulked ear; 0.25 germination rate, 2/4 mutants, only one with good tassel, in 19r',4094,'12N405:M0035703','12N3993:0024910',date(28,3,2024),time(21,00,00),toni).



% branch_status('Les9','K2506','Mo20W',['B',self],'more inc, have 2.5 ears, repeat 20r, v poor germ, 2--3 rows',4764,'18R205:S0001206','18R4505:0025311',date(24,5,2021),time(12,00,00),toni).

branch_status('Les9','K2506','Mo20W',[inc,'B',self],'ok ear',4577,'16R205:S0001210','16R4391:0010710',date(13,5,2022),time(12,00,00),toni).
branch_status('Les9','K2506','W23',[inc,'B'],'infertile ear',3995,'12R305:W0002901','12R3620:0027307',date(13,5,2022),time(12,00,00),toni).
branch_status('Les9','K2506','M14',[inc,'B',self],'ok ear',4659,'17R405:M0002306','17R4578:0017406',date(13,5,2022),time(12,00,00),toni).





% Les10

branch_status('Les10','K0801','Mo20W',[inc,'B'],'no ear',4660,'14R205:S0000307','14R4160:0022114',date(24,2,2022),time(12,00,00),toni).
branch_status('Les10','K0801','W23',[inc,'B'],'no ear',4263,'13R305:W0000706','13R3623:0024902',date(13,5,2022),time(12,00,00),toni).

% 24r pedigree doesn't have this parent
%
% Kazic, 23.3.2024
%
% branch_status('Les10','K0801','M14',[],'5th, parent semi-dwarf, no ear, fast in 21r',0,'21R405:M0001406','21R4870:0023207',date(24,2,2022),time(12,00,00),toni).

branch_status('Les10','K0801','M14',[],'4th; 5th exhausted; 0.45 germination rate, 4/9 mutants, crummy tassels in 21r;  check phe and ear carefully',0,'20R405:M0002107','20R4817:0026103',date(23,3,2024),time(15,00,00),toni).

% 20r/aleph/10.8/DSC_0201.NEF good segmentation challenge for Chimdi
%
% Kazic, 24.2.2022








branch_status('Les10','K2606','Mo20W',[inc,'B'],'no ear',4661,'17R205:S0001307','17R4539:0017501',date(13,5,2022),time(12,00,00),toni).
branch_status('Les10','K2606','W23',[inc,'B'],'no ear',4000,'12R305:W0002609','12R3625:0027904',date(13,5,2022),time(12,00,00),toni).
branch_status('Les10','K2606','M14',[],'5th, no ear; 0.7 germination rate, 10/21 mutants but no good tassels in 23r',0,'20R405:M0002205','20R4818:0026307',date(13,5,2022),time(12,00,00),toni).





% Les11

branch_status('Les11','K0901','Mo20W',[inc,'B',self],'ok ear',4443,'14R205:S0000415','14R4291:0022711',date(13,5,2022),time(12,00,00),toni).
branch_status('Les11','K0901','W23',[inc,'B',self],'ok ear',4002,'12R305:W0002602','12R3627:0028208',date(13,5,2022),time(12,00,00),toni).
branch_status('Les11','K0901','M14',[inc,'B',self],'ok ear; no phe and v poor germ 20r; 3 rows',4541,'16R405:M0003206','16R4511:0011304',date(10,4,2023),time(12,00,00),toni).
% branch_status('Les11','K0901','M14',[],'ok ear; alt for 16R405:M0003206; 3 rows',4541,'16R405:M0003207','16R4511:0011304',date(13,5,2022),time(12,00,00),toni).










% Les12

% branch_status('Les12','K1001','Mo20W',[],'6th; no ear; 2 rows',4663,'17R205:S0001112','17R4543:0017914',date(13,5,2022),time(12,00,00),toni).


branch_status('Les12','K1001','Mo20W',[inc,'B'],'no ear',4663,'17R205:S0001112','17R4543:0017914',date(16,5,2023),time(12,00,00),toni).
branch_status('Les12','K1001','W23',[inc,'B'],'infertile ear',4095,'12N305:W0038909','12N4008:0027205',date(13,5,2022),time(12,00,00),toni).

% branch_status('Les12','K1001','M14',['B'],'6th; infertile ear; low cl, poor germ, 2 rows',4264,'13R405:M0032901','13R4010:0025802',date(25,2,2022),time(12,00,00),toni).

% in 24r pedigree

branch_status('Les12','K1001','M14',['B'],'infertile ear; 6th bulked in M; need 2 more good bulked ears; 0.66 germination rate, 0/40 mutants in 23r; consistently poor yield, runs short',4264,'14R4264:0013208','14R4264:0013209',date(22,3,2024),time(8,00,00),toni).




% branch_status('Les12','K2711','Mo20W',[],'6th; no tassel? male semidwarf in 20r?',0,'20R205:S0000405','20R4713:0026410',date(25,2,2022),time(12,00,00),toni).

branch_status('Les12','K2711','Mo20W',[],'6th; check organs; 20R4713:0026410 sib had 0.6 germination rate, 15/24 mutants, 13 with ok tassels, in 22r; 0.56 germination rate, 5/17 mutants, only one with tassel, in 23r',0,'20R205:S0000402','20R4713:0026408',date(23,3,2024),time(12,00,00),toni).


branch_status('Les12','K2711','W23',[inc,'B'],'infertile ear',4012,'12R305:W0011317','12R3632:0028810',date(14,5,2022),time(12,00,00),toni).
branch_status('Les12','K2711','M14',[inc,'B'],'infertile ear',4013,'12R405:M0003302','12R3633:0028909',date(14,5,2022),time(12,00,00),toni).





% Les13

branch_status('Les13','K1109','Mo20W',[],'6th; no ear; 0.88 germination rate, 23/53 mutants, 17 are short with tassels, in 23r; need a couple of good ears',4766,'12N205:S0041605','12N4017:0028305',date(23,3,2024),time(16,00,00),toni).
branch_status('Les13','K1109','W23',[inc,'B',self],'6th; worked great in 22r',4930,'18R305:W0001918','18R4714:0025801',date(10,4,2023),time(12,00,00),toni).
branch_status('Les13','K1109','M14',['B',self],'6th; 0.78 germination rate, 9/31 healthy mutants in 22r; 0.88 germination rate, 0/53 mutants in 23r; need a couple of good ears',4931,'20R405:M0002105','20R4362:0026603',date(23,3,2024),time(16,00,00),toni).




branch_status('Les13','K2805','Mo20W',[inc,'B'],'6th; no ear',4932,'20R205:S0000302','20R4821:0027101',date(10,4,2023),time(12,00,00),toni).
branch_status('Les13','K2805','W23',[inc,'B'],'no ear',4097,'12N305:W0039204','12N4020:0028912',date(14,5,2022),time(12,00,00),toni).

% 0.4 germination, no mutants in 23r
%
% branch_status('Les13','K2805','M14',[],'6th; no ear',0,'21R405:M0001315','21R4873:0012609',date(10,4,2023),time(12,00,00),toni).

branch_status('Les13','K2805','M14',[],'6th; no ear; 0.75 germination rate, 18/46 mutants, missed, lots of crummy tassels in 23r',0,'21R405:M0001311','21R4873:0012603',date(10,4,2023),time(12,00,00),toni).






% only Mo2W still somewhat fragile
%
% W23, M14 now robust
%
% Kazic, 28.3.2024

% branch_status('Les15','K6711','Mo20W',[],'3rd; repeat 19r, ok emergence; germinate and transplant three rows for 22r? alt for 18R205:S0001601',0,'18R205:S0001314','18R4678:0015903',date(14,5,2022),time(12,00,00),toni).
% branch_status('Les15','K6711','Mo20W',[],'3rd; germinate and transplant three rows for 22r? alt for 18R205:S0001314',0,'18R205:S0001601','18R4678:0015901',date(14,5,2022),time(12,00,00),toni).
% branch_status('Les15','K6711','Mo20W',[],'3rd; germinate and transplant three rows for 22r?',0,'21R205:S0000407','21R4875:0012804',date(14,5,2022),time(12,00,00),toni).
% branch_status('Les15','K6711','Mo20W',[],'4th; germinate and transplant three rows for 22r',0,'19R205:S0000402','19R4774:0012602',date(14,5,2022),time(12,00,00),toni).

% branch_status('Les15','K6711','Mo20W',[],'3rd; 0.75 germ in 22r',0,'21R205:S0000409','21R4875:0012806',date(14,5,2022),time(12,00,00),toni).

branch_status('Les15','K6711','Mo20W',[],'3rd; alt ma had poor germination; check robustness',0,'21R205:S0000404','21R4875:0012806',date(24,3,2024),time(18,00,00),toni).
branch_status('Les15','K6711','Mo20W',[],'3rd; alt for 21R205:S0000404; check robustness',0,'21R205:S0000407','21R4875:0012804',date(24,3,2024),time(18,00,00),toni).


% branch_status('Les15','K6711','Mo20W',[],'4th; pa poor fertility, low cl',0,'22R205:S0017106','22R4906:0003514',date(14,5,2022),time(12,00,00),toni).
branch_status('Les15','K6711','W23',[inc,'B',self],'ok ear',4665,'17R305:W0004012','17R4548:0011508',date(14,5,2022),time(12,00,00),toni).

branch_status('Les15','K6711','M14',['B'],'is 6th! 0.625 germination rate, 5/25 in 23r; pa v robust in 22r; S just in case',0,'22R405:M0016505','22R4907:0004101',date(24,3,2024),time(18,00,00),toni).






% Les17

branch_status('Les17','K1309','Mo20W',[inc,'B'],'infertile ear',4098,'12N205:S0035808','12N4021:0029112',date(14,5,2022),time(12,00,00),toni).
branch_status('Les17','K1309','W23',[inc,'B',self],'ok ear',4099,'12N305:W0038903','12N4022:0029201',date(14,5,2022),time(12,00,00),toni).
branch_status('Les17','K1309','M14',[inc,'B'],'infertile ear',4458,'14R405:M0001808','14R4296:0024014',date(14,5,2022),time(12,00,00),toni).


branch_status('Les17','K3007','Mo20W',[inc,'B'],'infertile ear',4023,'12R205:S0003703','12R3641:0029901',date(14,5,2022),time(12,00,00),toni).
branch_status('Les17','K3007','W23',[inc,'B',self],'ok ear',3460,'11R305:W0052104','11R3274:0054302',date(14,5,2022),time(12,00,00),toni).

% branch_status('Les17','K3007','M14',['B',self],'ok ear; inc at 2 ears, need one more',4555,'16R405:M0003312','16R4027:0012203',date(14,5,2022),time(12,00,00),toni).

branch_status('Les17','K3007','M14',['B',self],'ok ear; 6th bulked in M; inc at 2 ears, need one more',4555,'19R4223:0008504','19R4223:0008505',date(28,3,2024),time(22,00,00),toni).





% Les18

branch_status('Les18','K1411','Mo20W',[inc,'B',self],'ok ear',4100,'12N205:S0038205','12N4028:0030308',date(14,5,2022),time(12,00,00),toni).
branch_status('Les18','K1411','W23',[inc,'B',self],'6th',4449,'14R305:W0001006','14R4299:0024502',date(10,4,2023),time(12,00,00),toni).
branch_status('Les18','K1411','M14',[inc,'B',self],'6th; ok ear.  fast and slow kinetics in 20r',4556,'16R405:M0002208','16R4300:0012606',date(10,4,2023),time(12,00,00),toni).





branch_status('Les18','K3106','Mo20W',[inc,'B',self],'ok ear',4438,'14R205:S0000204','14R4301:0024705',date(14,5,2022),time(12,00,00),toni).
branch_status('Les18','K3106','W23',[inc,'B',self],'ok ear',3647,'11N305:W0031405','11N3464:0019405',date(14,5,2022),time(12,00,00),toni).
branch_status('Les18','K3106','M14',[inc,'B',self],'6th; ok ear; repeat 21r, v poor emergence, three rows',4454,'14R405:M0001209','14R4302:0024808',date(10,4,2023),time(12,00,00),toni).








% Les19

branch_status('Les19','K1506','Mo20W',[inc,'B',self],'ok ear',4442,'14R205:S0000405','14R4303:0024904',date(14,5,2022),time(12,00,00),toni).
branch_status('Les19','K1506','W23',[inc,'B'],'infertile ear',4036,'12R305:W0010714','12R3650:0031010',date(14,5,2022),time(12,00,00),toni).
branch_status('Les19','K1506','M14',['B',self,inc],'6th',4667,'12N405:M0039608','12N4037:0031503',date(14,4,2023),time(12,00,00),toni).


branch_status('Les19','K3206','Mo20W',[inc,'B',self],'ok ear',4267,'13R205:S0003403','13R4176:0028502',date(14,5,2022),time(12,00,00),toni).
branch_status('Les19','K3206','W23',[inc,'B',self],'ok ear',4038,'12R305:W0010711','12R3653:0031303',date(14,5,2022),time(12,00,00),toni).


% branch_status('Les19','K3206','M14',['B',self],'6th; ok ear; inc',4668,'17R405:M0004413','17R4518:0018408',date(14,5,2022),time(12,00,00),toni).
branch_status('Les19','K3206','M14',['B',self],'6th bulked in M; ok ear; inc',4668,'20R4668:0010108','20R4668:0010104',date(23,5,2024),time(17,00,00),toni).







% Les20-N2457

% fragile

% branch_status('Les20-N2457','K7110','Mo20W',[],'4th; 0.27 germination rate, 0/16 mutants in 22r; repeat 21r; no ear',0,'20R205:S0000102','20R4043:0016007',date(3,3,2022),time(12,00,00),toni).

branch_status('Les20-N2457','K7110','Mo20W',[],'2nd, alt for 20R205:S0001003; low cl',0,'10R205:S0009812','10R2929:0034509',date(24,3,2024),time(19,00,00),toni).
branch_status('Les20-N2457','K7110','Mo20W',[],'3rd, alt for 20R205:S0001003; very low cl',0,'15R205:S0002302','15R4403:0015507',date(24,3,2024),time(19,00,00),toni).
branch_status('Les20-N2457','K7110','Mo20W',[],'4th; 0.5 germination rate, 0/41 mutants in 23r',0,'20R205:S0001003','20R4043:0016001',date(24,3,2024),time(19,00,00),toni).




branch_status('Les20-N2457','K7110','W23',[inc,'B',self],'6th',4793  ,'19R305:W0000705','19R4719:0016408',date(14,4,2023),time(12,00,00),toni).
branch_status('Les20-N2457','K7110','M14',[inc,'B',self],'6th; watch carefully for phe; low cl 17R405:M0004416',4669,'20R4669:0010504','20R4669:0010401',date(2,5,2023),time(12,00,00),toni).

% branch_status('Les20-N2457','K7110','M14',[],'4th, M',0,'16R405:M0003202','16R4531:0014005',date(14,5,2022),time(12,00,00),toni).





% Les20-N2459

% fragile

% branch_status('Les20-N2459','K68602','Mo20W',[],'1st in S',0,'20R205:S0004202','20R4810:0017701',date(2,5,2023),time(12,00,00),toni).
branch_status('Les20-N2459','K68602','Mo20W',[],'3rd, probably dwarf, cut out wild types; low cl',0,'23R205:S0012213','23R4565:0024119',date(24,3,2024),time(21,00,00),toni).


branch_status('Les20-N2459','K68602','W23',[],'5th; 0.83 germination rate, 8/50 mutants in 23r; very fast, missed in 23r.',0,'21R305:W0002216','21R4809:0013504',date(24,3,2024),time(21,00,00),toni).


% branch_status('Les20-N2459','K68602','M14',[],'3rd; 0.05 germination rate in 23r; probably very fast, watch for leaf roll.',0,'20R405:M0002512','20R4810:0017508',date(14,5,2022),time(12,00,00),toni).

branch_status('Les20-N2459','K68602','M14',[],'3rd; 20R405:M0005009 had 0.05 germination rate in 23r; probably very fast, watch for leaf roll.',0,'20R405:M0005013','20R4810:0017701',date(24,3,2024),time(21,00,00),toni).


branch_status('Les20-N2459','K68607','Mo20W',[],'5th; pa had 1.1 germination rate, 1/32 mutants in 23r; cut out wild types',0,'23R205:S0005112','23R4912:0024630',date(24,3,2024),time(21,00,00),toni).
branch_status('Les20-N2459','K68607','W23',[],'5th; pa had 0.9 germination rate, 5/27 mutants in 23r; runs short, cut out wild types?',0,'23R305:W0006903','23R5023:0025006',date(24,3,2024),time(21,00,00),toni).
% branch_status('Les20-N2459','K68607','M14',[],'3rd; 0.33 germination rate, 0/8 mutants in 23r',0,'21R405:M0001202','21R4813:0014003',date(2,5,2023),time(12,00,00),toni).
branch_status('Les20-N2459','K68607','M14',[],'3rd; pa had 0.6 germination rate, 3/12 mutants in 23r; very short, no ears and no tassel, cut out wild types?',0,'23R405:M0008401','23R4813:0025507',date(24,3,2024),time(21,00,00),toni).








% Les21

branch_status('Les21','K3311','Mo20W',[inc,'B'],'infertile ear',4439,'14R205:S0000208','14R4308:0026010',date(14,5,2022),time(12,00,00),toni).
branch_status('Les21','K3311','W23',[inc,'B',self],'ok ear',3656,'11N305:W0034102','11N3468:0020608',date(14,5,2022),time(12,00,00),toni).
branch_status('Les21','K3311','M14',['B'],'6th; 0.675 germination rate, 21/80 mutants in 23r; score ears carefully, often poor.  parent had poor germinatn but robust mutants in 20r, ditto 22r but no pollen',0,'20R405:M0002706','20R4824:0027502',date(23,5,2024),time(1,00,00),toni).




branch_status('Les21-N1442','K7205','Mo20W',['B',inc],'no ear',4794,'16R205:S0001310','16R4534:0014307',date(14,5,2022),time(12,00,00),toni).
branch_status('Les21-N1442','K7205','W23',[inc,'B',self],'ok ear',4535,'5R305:W0000701','15R4363:0017408',date(14,5,2022),time(12,00,00),toni).
branch_status('Les21-N1442','K7205','M14',['B',inc],'6th; no ear; two rows; poor germ; repeat 14r, 18r, 19r',4268,'13R405:M0003608','13R4184:0030002',date(14,5,2022),time(12,00,00),toni).



% secondary dominants


% Les*-mi1

branch_status('Les*-mi1','K12205','Mo20W',[inc,'B',self],'ok ear',4538,'16R205:S0001303','16R4537:0014611',date(17,5,2022),time(12,00,00),toni).
branch_status('Les*-mi1','K12205','W23',[inc,'B',self],'ok ear',4671,'14R305:W0001007','14R4186:0026908',date(17,5,2022),time(12,00,00),toni).
branch_status('Les*-mi1','K12205','M14',['B',inc],'infertile ear',4672,'14R405:M0001509','14R4313:0027007',date(17,3,2022),time(12,00,00),toni).







%%%%%%%%%% dominants arising from les23 in K1802 and K16306 %%%%%%%%%%%%%%%%%%%%




% Les*-tk2 K70404 builds in its own pedigree now, but some branches are
% still duplicated in Mo20W/les23
%
% Kazic, 17.5.2022

% Les*-tk2 K70404, aka dominant Mo20W/les23
%
% need dominant in W



% branch_status('les23','K1802','Mo20W',[],'3rd dominant',0,'23R205:S0005710','23R4960:0026409',date(23,3,2024),time(21,00,00),toni).

% branch_status('les23','K1802','Mo20W',[inc,'B'],'6th dominant',4984,'19R205:S0000107','19R4768:0011611',date(23,3,2024),time(21,00,00),toni).



% branch_status('les23','K1802','Mo20W',[inc,'B'],'6th dominant bulked',4984,'23R4984:0021106','23R4984:0021113',date(23,3,2024),time(21,00,00),toni).

% branch_status('Les*-tk2','K70404','Mo20W',[],'3rd; S, W; dominant?; check phe',0,'19R205:S0000107','19R4768:0011611',date(17,5,2022),time(12,00,00),toni).

% branch_status('Les*-tk2','K70404','Mo20W',[],'4th; S, W; dominant?; check phe carefully, pa was slight in 19r',0,'19R205:S0000107','19R4768:0011611',date(17,5,2022),time(12,00,00),toni).

branch_status('Les*-tk2','K70404','Mo20W',[],'3rd in S dominant, need S, W',4984,'23R205:S0005706','23R4960:0026409',date(23,3,2024),time(21,00,00),toni).


% branch_status('Les*-tk2','K70404','M14',[],'1st; M, W; dominant?; check phe carefully, pa was slight in 18r; second planting',0,'18R405:M0004110','18R4626:0029107',date(17,5,2022),time(12,00,00),toni).

% branch_status('les23','K1802','M14',[],'2nd in M dominant, need W too',0,'23R405:M0008909','23R5047:0033903',date(23,3,2024),time(21,00,00),toni).

branch_status('Les*-tk2','K70404','M14',[],'2nd in M dominant, need W too',0,'23R405:M0009205','23R5047:0033906',date(23,3,2024),time(21,00,00),toni).




 













%%%%%%%%%%%%%%%%%%%%% Les*-tk1, aka les23 K1630* %%%%%%%%%%%%%%%%%
%
% this builds in the les23-k16300 pedigree now; fix so it builds its own pedigree
%
% change classification to secondary dominant
%
% Kazic, 25.5.2021

% see primary_recessives/les23-k16300_.org for more of this
%
% Kazic, 17.5.2022



% also a dominant appearing in K16306!  now called Les*-tk1, K70309
%
% Kazic, 26.3.2024


% Les*-tk1, K70309, aka les23 K16306


% branch_status('Les*-tk1','K70309','Mo20W',[],'2nd; S; dominant? check kinetics; compare to 18R205:S0000905',0,'18R205:S0000304','18R4692:0021505',date(17,5,2022),time(12,00,00),toni).
% branch_status('Les*-tk1','K70309','W23',[],'4th; W; dominant? check kinetics; compare to 20R305:W0001703',0,'19R305:W0000504','19R4770:0011910',date(17,5,2022),time(12,00,00),toni).
% branch_status('Les*-tk1','K70309','M14',[],'3rd; M; dominant? check kinetics; compare to other Ms',0,'18R405:M0004505','18R4697:0022104',date(17,5,2022),time(12,00,00),toni).
% branch_status('Les*-tk1','K70309','M14',[],'3rd; M; dominant? check kinetics; compare to other Ms',0,'20R405:M0002409','20R4773:0029402',date(17,5,2022),time(12,00,00),toni).
% branch_status('Les*-tk1','K70309','M14',[],'3rd; M; dominant? check kinetics; compare to other Ms',0,'20R405:M0002410','20R4833:0029503',date(17,5,2022),time(12,00,00),toni).


% branch_status('Les*-tk1','K70309','Mo20W',[],'S; 3rd; dominant? check kinetics; 0.8 germination rate, 13/32 mutants, 11 with good tassels, in 23r, but that had the planting kerfuffle so statistics shaky',0,'22R205:S0015401','22R4953:0021208',date(28,3,2024),time(22,00,00),toni).

branch_status('Les*-tk1','K70309','Mo20W',[],'4th dominant; pa had 0.65 germination rate, 5/13 mutants, often shorter and crummy ears in 23r',0,'23R205:S0005515','23R5029:0026708',date(29,3,2024),time(21,00,00),toni).

branch_status('Les*-tk1','K70309','W23',[],'6th in W; dominant; check kinetics; pa 0.625 germination rate, 10/25 mutants, all with good tassels, in 23r, but that had the planting kerfuffle so statistics shaky',0,'23R305:W0006906','23R5030:0026802',date(28,3,2024),time(22,00,00),toni).

branch_status('Les*-tk1','K70309','M14',[],'M; 4th; dominant? check kinetics; 0.825 germination rate, 10/33 mutants in 23r, 6 with good tassels, but that had the planting kerfuffle so statistics shaky; very very low cl',0,'22R405:M0016401','22R4956:0021502',date(28,3,2024),time(22,00,00),toni).
















% there is some gene linked to lls1-nk that suppresses tassel formation.
% Successive back-crosses expose this, some earlier and some later.
%
% Absent tassel observed repeatedly in multiple seasons for all three
% branches and all mutant plants.  Also tends to suppress height
% (miniscule, dwarf, semi-dwarf, shorter).
%
% Strategy for 22r is fertilizer.  If that doesn't work, then abandon this.
%
% Kazic, 3.3.2022





% lls1-nk

branch_status('lls1-nk','K17806','Mo20W',[],'2nd in S, should be dominant, pa short, no ear in 23r; early phe 23r',0,'23R205:S0005610','23R5034:0034213',date(29,3,2024),time(11,00,00),toni).
branch_status('lls1-nk','K17806','W23',[],'6th, should have ear; early phe 23r',0,'23R305:W0007001','23R5036:0030507',date(29,3,2024),time(11,00,00),toni).
branch_status('lls1-nk','K17806','M14',[],'2nd in M, should be dominant; check phe carefully; early phe 23r?',0,'23R405:M0008507','23R5035:0030721',date(29,3,2024),time(11,00,00),toni).



% branch_status('Les101','K11802','Mo20W',[],'3rd; ok germ 12r',0,'11N205:S0031506','11N3086:0021405',date(18,5,2022),time(12,00,00),toni).
% branch_status('Les101','K11802','M14',[],'3rd; good germ 12r',0,'11N405:M0030910','11N3088:0021601',date(18,5,2022),time(12,00,00),toni).


% Les101

branch_status('Les101','K11802','Mo20W',[],'5th; pa had 0.65 germination rate, 7/13 mutants in 22r',0,'22R205:S0015615','22R4968:0024102',date(25,3,2024),time(20,00,00),toni).
branch_status('Les101','K11802','W23',[],'4th; pa had 1.0 germination rate, 7/20 mutants in 23r',0,'23R305:W0006917','23R5041:0032604',date(25,3,2024),time(20,00,00),toni).
branch_status('Les101','K11802','M14',[],'5th; pa had 0.7 germination rate, 6/14 mutants in 23r',0,'23R405:M0008903','23R5042:0032710',date(25,3,2024),time(20,00,00),toni).



% Les102

branch_status('Les102','K12008','Mo20W',[],'3rd; pa had 0.7 germination rate, 9/21 mutants, short with small or no ears in 23r; early phe 23r',0,'23R205:S0005606','23R4970:0032809',date(25,3,2024),time(20,00,00),toni).
branch_status('Les102','K12008','W23',[],'3rd; pa had 0.5 germination rate, 2/10 mutants, good phenotype in 20r; descendant had 0.6 germination rate, no mutants in 23r; male had little phe in 22r',0,'20R305:W0001412','20R3675:0028801',date(25,3,2024),time(20,00,00),toni).
branch_status('Les102','K12008','M14',[],'3rd; pa had 0.7 germination rate, 11/21 mutants in 23r',0,'23R405:M0010706','23R5044:0033007',date(25,3,2024),time(20,00,00),toni).

% branch_status('Les102','K12008','M14',[],'3rd, had 0.025 germ in 22r',0,'20R405:M0002710','20R3676:0028901',date(15,5,2023),time(12,00,00),toni).





% Les*-NA7145

branch_status('Les*-NA7145','K9113','Mo20W',[],'5th; 0.575 germination rate, 2/23 semi-dwarf mutants in 23r; 0.1 germination rate in  21r',0,'20R205:S0004501','20R4190:0028603',date(23,3,2024),time(18,00,00),toni).

branch_status('Les*-NA7145','K9113','W23',['B',self],'6th in W; inc, do not miss!; 0.92 germination rate, 28/60 mutants in 23r;  M if 12R405:M0009304 has no good tassel',4797,'14R305:W0000712','14R4191:0027713',date(23,3,2024),time(18,00,00),toni).

branch_status('Les*-NA7145','K9113','M14',[],'2nd; no ear, pa shift in 15r',0,'15R405:M0001513','15R4367:0020401',date(18,5,2022),time(12,00,00),toni).

% branch_status('Les*-NA7145','K9113','M14',[],'3rd; v poor germ 20r, transplant; repeat of 13r, 14r, 15r, 20r; dwarf, poor tassel, no ear mutant in 20r',0,'12R405:M0009304','12R3323:0037602',date(18,5,2022),time(12,00,00),toni).

branch_status('Les*-NA7145','K9113','M14',[],'2nd; 0.85 germination rate, 6/20 mutants in 22r; smaller, no ear mutant in 22r',0,'15R405:M0001513','15R4367:0020401',date(23,3,2024),time(20,00,00),toni).





% Les*-N2420

% fragile
branch_status('Les*-N2420','K13902','Mo20W',[],'4th; fragile; pa had 0.8 germination rate, 10/32 mutants, semidwarf, no ears, 1 crummy tassel in 23r',0,'23R205:S0006001','23R4998:0015810',date(25,3,2024),time(17,00,00),toni).
branch_status('Les*-N2420','K13902','W23',[],'5th; fragile; pa had 0.825 germination rate, 9/33 mutants, semidwarf, no ear in 23r',0,'23R305:W0012310','23R4829:0015909',date(25,3,2024),time(17,00,00),toni).
branch_status('Les*-N2420','K13902','M14',[],'2nd in M; fragile; pa had 0.975 germination rate, 5/39 mutants, no ears, mixed heights in 23r',0,'23R405:M0008403','23R4996:0015602',date(25,3,2024),time(17,00,00),toni).



branch_status('Les*-N2420','K13905','Mo20W',[],'2nd; fragile; pa had 1.0 germination rate, 3/30 mutants, most robust plant in 23r; cut out wild types?; split/finger leaf phenotype in ancestor',0,'23R205:S0005009','23R4997:0015705',date(25,3,2024),time(17,00,00),toni).
branch_status('Les*-N2420','K13905','W23',[],'3rd; fragile; pa had 0.966 germination rate, 10/29 mutants, semidwarf, no ear in 23r; fewer kernels but taller plant than 23R305:W0012417; cut out wild types?; low cl',0,'23R305:W0012405','23R4999:0016214',date(25,3,2024),time(17,00,00),toni).
branch_status('Les*-N2420','K13905','M14',[],'2nd; fragile; pa had 0.93 germination rate, 9/28 mutants, semidwarf, no ear in 23r; cut out wild types?',0,'23R405:M0008503','23R5000:0016315',date(25,3,2024),time(17,00,00),toni).






% Les*-N2418

branch_status('Les*-N2418','K8501','Mo20W',[inc,'B',self],'6th; ok ear',3701,'11N205:S0031513','11N3490:0023809',date(18,5,2022),time(12,00,00),toni).
branch_status('Les*-N2418','K8501','W23',[inc,'B',self],'good ears in 20r; forebear has 0 cl, so had to build selves from a sib; offspring family 4433',4102,'14R4102:0015303','14R4102:0015305',date(18,5,2022),time(12,00,00),toni).
branch_status('Les*-N2418','K8501','M14',[inc,'B',self],'6th',4673,'15R405:M0001414','15R4365:0019903',date(18,5,2022),time(12,00,00),toni).




% Les*-N2397

branch_status('Les*-N2397','K8414','Mo20W',[],'5th',0,'23R205:S0012103','23R5040:0031610',date(23,3,2024),time(18,00,00),toni).
branch_status('Les*-N2397','K8414','W23',[inc,'B'],'infertile ear; phe unconvincing in 20r; fast!',4270,'11N305:W0039211','11N3488:0023605',date(18,5,2022),time(12,00,00),toni).
branch_status('Les*-N2397','K8414','M14',['B'],'6th; 0.675 germination rate, 15/40 mutants in 23r; diffuse, profuse small chlorotic lesns in 22r',0,'22R405:M0016710','22R4883:0023206',date(15,5,2023),time(12,00,00),toni).






% Les*-N2320

branch_status('Les*-N2320','K8114','Mo20W',[],'6th; pa had 0.5 germination rate, 7/20 mutants in 23r',0,'23R205:S0012106','23R5037:0031311',date(25,3,2024),time(17,00,00),toni).
branch_status('Les*-N2320','K8114','W23',[],'5th; small, watery lesions in 23r',0,'23R305:W0007019','23R5038:0031405',date(25,3,2024),time(17,00,00),toni).
branch_status('Les*-N2320','K8114','M14',[],'4th; medium watery lesions, more than in W, in 23r',0,'23R405:M0012702','23R5039:0031515',date(25,3,2024),time(17,00,00),toni).





% Les*-N1378

branch_status('Les*-N1378','K7403','Mo20W',[inc,'B',self],'ok ear',4436,'14R205:S0000101','14R4314:0027101',date(19,5,2022),time(12,00,00),toni).
branch_status('Les*-N1378','K7403','W23',[inc,'B',self],'ok ear',4269,'13R305:W0003502','13R4188:0030801',date(19,5,2022),time(12,00,00),toni).
branch_status('Les*-N1378','K7403','M14',[inc,'B'],'no ear',4456,'14R405:M0001512','14R4315:0027205',date(19,5,2022),time(12,00,00),toni).






% primary recessives


% les5

branch_status('les5','K11605','Mo20W',[],'2nd in S selfed; recessive',0,'23R4989:0014910','23R4989:0014910',date(24,3,2024),time(18,00,00),toni).
branch_status('les5','K11605','W23',[],'1st in W selfed, M/W hybrid; recessive',0,'23R4990:0015006','23R4990:0015006',date(24,3,2024),time(18,00,00),toni).
branch_status('les5','K11605','M14',[],'2nd in M; recessive',0,'23R405:M0010403','23R4947:0025906',date(24,3,2024),time(18,00,00),toni).





% Les3-GJ

branch_status('Les3-GJ','K11906','Mo20W',[],'6th; recessive; lesions faint',0,'23R205:S0012205','23R5024:0025608',date(24,3,2024),time(18,00,00),toni).
branch_status('Les3-GJ','K11906','W23',[],'5th; recessive; lesions faint',0,'23R305:W0007015','23R4836:0025718',date(24,3,2024),time(18,00,00),toni).
branch_status('Les3-GJ','K11906','M14',[],'6th; recessive; lesions a bit stronger than in S or W',0,'23R405:M0008404','23R5025:0025807',date(24,3,2024),time(18,00,00),toni).








%%%%%%%%%%%%%%%%%%%%% assorted lls %%%%%%%%%%%%%%%%%%%%%%%%%%

% hold lls in abeyance for 21r and try the sidedress/transplant idea on lls 121D first?
%
% in 22r, try testing the S lines as marked in pedigree and ../../crops/22r/planning/todo.org
%
% Kazic, 25.5.2021
%

% a chronic bust
%
% try growing inside somehow and carry pollen to the field, Chris says the
% pollen will survive (if normalish)
%
% Kazic, 27.3.2024

branch_status('lls1','K1702','Mo20W',[],'0th selfed; test, S; two rows; 2nd planting; defer?; recessive',0,'06N1050:0002805','06N1050:0002805',date(17,5,2022),time(12,00,00),toni).
% branch_status('lls1','K1702','Mo20W',[],'1st selfed; test, S; two rows; 2nd planting; defer?; recessive',0,'09R1413:0008005','09R1413:0008005',date(17,5,2022),time(12,00,00),toni).
% branch_status('lls1','K1702','Mo20W',[],'2nd selfed; test, S; two rows; 2nd planting; defer?; lethal? recessive',0,'10R205:S0001412','10R2265:0013305',date(17,5,2022),time(12,00,00),toni).
% branch_status('lls1','K1702','Mo20W',[],'3rd selfed; test, S; two rows; 2nd planting; defer?; lethal? recessive',0,'13R4057:0013901','13R4057:0013901',date(17,5,2022),time(12,00,00),toni).

branch_status('lls1','K1702','Mo20W',[],'3rd selfed in S; 16R4460:0003604 had 0.85 germination rate, 19/160 mutants, only 2 had tassels in 23r, now only 59 kernels; candidate for lab growing, has never been planted; alt is 16R4460:0003602, which had 0.97 germination rate but 0/29 mutants in 17r; recessive',0,'16R4460:0003611','16R4460:0003611',date(26,3,2024),time(15,00,00),toni).


branch_status('lls1','K1702','W23',[],'3rd selfed in W; 0.95 germination rate, 11/57 mutants, all but 2 had no or crummy tassels, all no ears in 22r; 0.925 germination rate, 28/148, 11 with no or crummy tassel, but no pollen in 23r; candidate for lab growing; recessive',0,'15R4335:0006107','15R4335:0006107',date(26,3,2024),time(15,00,00),toni).

branch_status('lls1','K1702','W23',[],'3rd selfed in W; 0.8 germination rate, 5/20 mutants, all no tassels in 18r; packed but not planted in 19r; recessive',0,'15R4335:0006104','15R4335:0006104',date(26,3,2024),time(15,00,00),toni).

branch_status('lls1','K1702','W23',[],'3rd selfed in W; 0.97 germination rate, 14/58 mutants, all with no or crummy tassels in 22r; recessive',0,'15R4335:0006113','15R4335:0006113',date(17,5,2022),time(12,00,00),toni).


% branch_status('lls1','K1702','M14',[],'3rd selfed in M; parent of 23R4684:0028017; in 18r; in 19r; in 20r; in 22r; 0.56 germination rate, 18/90 mutants, 8 with tassels, in 23r; recessive',0,'15R4336:0006204','15R4336:0006204',date(17,5,2022),time(12,00,00),toni).

branch_status('lls1','K1702','M14',[],'4th in M; pa had 0.55 germination rate, 6/22, 4 dwarf mutants with tassels; no ear for this pa in 23r; recessive',0,'23R405:M0010511','23R4684:0028017',date(26,3,2024),time(15,00,00),toni).






branch_status('lls1','K10602','Mo20W',[],'2nd selfed in S; 0.53 germination rate, 5/8 mutants, no tassel info in 13r; recessive; 12N3890:0004906 and 12N3890:0004907 have never been planted',0,'12N3890:0004902','12N3890:0004902',date(26,3,2024),time(15,00,00),toni).
branch_status('lls1','K10602','Mo20W',[],'2nd selfed in S; 0.66 germination rate, 3/10 mutants, no tassel info in 13r; recessive; 12N3890:0004906 and 12N3890:0004907 have never been planted',0,'12N3890:0004903','12N3890:0004903',date(26,3,2024),time(15,00,00),toni).
branch_status('lls1','K10602','Mo20W',[],'2nd selfed in S; 0.97 germination rate, 10/29 mutants, 1 tassel on dwarf, all others dwarf or semi-dwarf in 14r; 0.88 germination rate, 7/22 mutants, all no tassel in 18r; packed but not planted in 19r; 0.8 germination rate, 1/16 mutant, dwarf with no tassel in 20r; 0.97 germination rate, 6/29, all crummy or no tassels and short in 22r; recessive; 12N3890:0004906 and 12N3890:0004907 have never been planted; candidate for lab growin',0,'12N3890:0004911','12N3890:0004911',date(26,3,2024),time(15,00,00),toni).




branch_status('lls1','K10602','Mo20W',[],'2nd selfed in S; never planted; recessive',0,'12N3891:0005004','12N3891:0005004',date(26,3,2024),time(15,00,00),toni).
branch_status('lls1','K10602','Mo20W',[],'2nd selfed in S; 0.93 germination rate, 5/28 mutants, none with tassels, in 14r; 0.73 germination rate, 7/22 mutants, only 1 with tassel, in 15r; recessive; candidate for lab growing',0,'12N3891:0005005','12N3891:0005005',date(26,3,2024),time(15,00,00),toni).
branch_status('lls1','K10602','Mo20W',[],'2nd selfed in S; never planted; recessive',0,'12N3891:0005007','12N3891:0005007',date(26,3,2024),time(15,00,00),toni).
branch_status('lls1','K10602','Mo20W',[],'2nd selfed in S; never planted; recessive',0,'12N3891:0005009','12N3891:0005009',date(26,3,2024),time(15,00,00),toni).
branch_status('lls1','K10602','Mo20W',[],'2nd selfed in S; 0.84 germination rate, 5/21 mutants, none with tassels, in 18r; 0.65 germination rate, 3/26 and no tassels in 20r; 0.9 germination rate, 7/27 mutants, none with tassels, in 22r; 0.97 germination rate, 20/153 mutants, none with tassels, in 23r; recessive; candidate for lab growing',0,'12N3891:0005011','12N3891:0005011',date(26,3,2024),time(15,00,00),toni).
branch_status('lls1','K10602','Mo20W',[],'2nd selfed in S; never planted; recessive',0,'12N3891:0005012','12N3891:0005012',date(26,3,2024),time(15,00,00),toni).


branch_status('lls1','K10602','W23',[],'3rd selfed in W; never planted, low cl; recessive',0,'18R4699:0022302','18R4699:0022302',date(26,3,2024),time(15,00,00),toni).
branch_status('lls1','K10602','W23',[],'3rd selfed in W; packed but not planted in 19r; 0.8 germination rate, 4/16 mutants, all dwarves with no tassels, in 20r; 0.87 germination rate, 11/52 mutants, all (semi-)dwarves with no tassels, in 22r; recessive',0,'18R4699:0022310','18R4699:0022310',date(26,3,2024),time(15,00,00),toni).



branch_status('lls1','K10602','W23',[],'3rd selfed in W; 0.825 germination rate, 24/132, 7 short with tassels, mutants in 23r; recessive; candidate for lab growing',0,'19R4699:0003208','19R4699:0003208',date(26,3,2024),time(15,00,00),toni).
branch_status('lls1','K10602','W23',[],'3rd selfed in W; never planted; recessive',0,'19R4699:0003209','19R4699:0003209',date(26,3,2024),time(15,00,00),toni).
branch_status('lls1','K10602','W23',[],'3rd selfed in W; never planted; recessive',0,'19R4699:0003210','19R4699:0003210',date(26,3,2024),time(15,00,00),toni).





branch_status('lls1','K10602','M14',[],'1st selfed in M; 0.77 germination rate, 5/23 mutants, all dwarvish with no tassels, in 14r; 0.4 germination rate, 3/12 dwarvish mutants, only one with tassel, in 15r; 0.96 germination rate, 6/24 mutants, apparently all with tassels, in 18r; not planted in 19r; 0.87 germination rate, 8/26 mutants, 1 semi-dwarf with tassel, in 22r; 0.57 germination rate, 11/91 mutants, only 2 shorties with tassels, in 23r; recessive; candidate for lab growing',0,'13R4059:0014102','13R4059:0014102',date(26,3,2024),time(15,00,00),toni).

branch_status('lls1','K10602','M14',[],'1st selfed in M; 0.7 germination rate, 5/21, dwarfish and 2 with crummy tassel, mutants in 14r; recessive',0,'13R4059:0014105','13R4059:0014105',date(26,3,2024),time(15,00,00),toni).

branch_status('lls1','K10602','M14',[],'1st selfed in M; never planted; recessive',0,'13R4059:0014110','13R4059:0014110',date(26,3,2024),time(15,00,00),toni).





% lls1 121D


branch_status('lls1 121D','K3402','Mo20W',[],'3rd selfed in S; stronger mutants, good germ in 20r; 0.5 germination rate, 4/20 mutants, none with tassels, in 23r; sibs 22R4902:0006011 and 22R4902:0006014 never planted; recessive; candidate for lab growing',0,'22R4902:0006001','22R4902:0006001',date(27,3,2024),time(18,00,00),toni).


branch_status('lls1 121D','K3402','W23',[],'3rd selfed in W; grandpa had fertile tassel in 15r; 0.83 germination rate,  8/50 mutants, only 1 with tassel, rest dwarfish with crummy tassels in 21r; recessive',0,'16R4461:0003709','16R4461:0003709',date(27,3,2024),time(18,00,00),toni).

branch_status('lls1 121D','K3402','W23',[],'3rd selfed in W; grandpa had fertile tassel in 15r; 0.8 germination rate, 7/24 mutants, 2 semi-dwarves with tassels in 22r; 0.55 germination rate, 4/22 dwarvish mutants, none with tassels in 23r; recessive; candidate for lab growing',0,'16R4461:0003711','16R4461:0003711',date(27,3,2024),time(18,00,00),toni).

branch_status('lls1 121D','K3402','W23',[],'3rd selfed in W; grandpa had fertile tassel in 15r; 0.57 germination rate, 6/17 semi-dwarf mutants, none with tassels, in 17r; 0.78 germination rate, 6/23 dwarf mutants, none with tassels, in 22r;  recessive',0,'16R4461:0003713','16R4461:0003713',date(27,3,2024),time(18,00,00),toni).



branch_status('lls1 121D','K3402','M14',[],'3rd selfed in M; check organs carefully; grandpa was shorter by 2 ft, no ear; 0.63 germination rate, 5/19 mutants, 1 good height that had tassel, rest dwarfish with no tassels, in 22r; 0.6 germination rate, 5/24 dwarvish mutants without tassels in 23r; other sibs not planted; recessive',0,'21R4890:0003201','21R4890:0003201',date(27,3,2024),time(18,00,00),toni).



% branch_status('lls1 121D','K5302','Mo20W',[],'2nd selfed; S; alt for 15R4337:0006312@; 1st and 2nd plantings',0,'15R4337:0006305','15R4337:0006305',date(17,5,2022),time(12,00,00),toni).
% branch_status('lls1 121D','K5302','Mo20W',[],'2nd selfed; S; alt for 15R4337:0006305@; 1st and 2nd plantings',0,'15R4337:0006312','15R4337:0006312',date(17,5,2022),time(12,00,00),toni).

branch_status('lls1 121D','K5302','Mo20W',[],'2nd selfed in S; 0.97 germination rate, 5/29 mutants, 3 ok height with tassels, in 22r; 0.93 germination rate,  8/37 mutants, 3 ok height with tassels, in 23r; recessive; candidate for lab growing',0,'15R4338:0006406','15R4338:0006406',date(27,3,2024),time(18,00,00),toni).

branch_status('lls1 121D','K5302','Mo20W',[],'2nd selfed in S; 0.95 germination rate, 11/57 mutants, 4 shortish with tassels, in 22r; 1st and 2nd plantings; recessive; candidate for lab growing, but 15R4338:0006406 marginally better',0,'15R4338:0006411','15R4338:0006411',date(27,3,2024),time(18,00,00),toni).




branch_status('lls1 121D','K5302','W23',[],'3rd selfed in W; 0.57 germination rate,  6/34 mutants, 1 ok height with tassel, in 21r; 0.75 germination rate, 11/45 mutants, all with crummy to no tassels, in 22r; 0.65 germination rate, 5/26 mutants, none with tassels, in 23r;  1st and 2nd plantings; recessive; candidate for lab growing',0,'16R4463:0003902','16R4463:0003902',date(27,3,2024),time(18,00,00),toni).

branch_status('lls1 121D','K5302','W23',[],'3rd selfed in W; 0.68 germination rate, 0/41 mutants in 22r; 0.73 germination rate, 0/22 mutants in 23r; 1st and 2nd plantings; recessive',0,'16R4463:0003904','16R4463:0003904',date(27,3,2024),time(18,00,00),toni).

branch_status('lls1 121D','K5302','W23',[],'3rd selfed in W; 0.82 germination rate, 0/49 mutants in 22r; 0.65 germination rate, 0/26 mutants in 23r; 1st and 2nd plantings; recessive',0,'16R4463:0003907','16R4463:0003907',date(27,3,2024),time(18,00,00),toni).


% branch_status('lls1 121D','K5302','M14',[],'3rd selfed; M; fertilize; 1st and 2nd plantings; alt for 16R4464:0004010@; recessive',0,'16R4464:0004001','16R4464:0004001',date(17,5,2022),time(12,00,00),toni).

% branch_status('lls1 121D','K5302','M14',[],'3rd selfed; M; parent of 23R4752:0030208; fertilize; 1st and 2nd plantings; alt for 16R4464:0004001@; 0.85 germination rate, 2/34 tallish mutants with tassels in 23r; recessive',0,'16R4464:0004002','16R4464:0004002',date(17,5,2022),time(12,00,00),toni).

branch_status('lls1 121D','K5302','M14',[],'4th in M; fertilize; ma 2nd planting, pa 1st planting; recessive',0,'23R405:M0012607','23R4752:0030208',date(27,3,2024),time(18,00,00),toni).






%%%%%%%%%%%% les23 and offspring %%%%%%%%%%%%%%%%%%





% recessive les23; dominant Les*-tk2, K70404 will also be in these pedigrees
%
% Kazic, 26.3.2024


% les23 recessive



branch_status('les23','K1802','Mo20W',[],'2nd selfed; test, S; sib of dominant forebear',0,'13R4065:0014710','13R4065:0014710',date(3,5,2023),time(12,00,00),toni).



% branch_status('les23','K1802','Mo20W',[],'4th; test, self or S; check kinetics; recessive',0,'20R205:S0000710','20R4839:0030205',date(15,4,2023),time(12,00,00),toni).


branch_status('les23','K1802','Mo20W',[],'3rd; recessive? S if dominant',0,'23R205:S0012204','23R4230:0026123',date(23,3,2024),time(21,00,00),toni).

branch_status('les23','K1802','W23',[inc,'B',self],'ok ear; offspring family 4670; recessive',4618,'17R4618:0012502','17R4618:0012502',date(23,3,2024),time(21,00,00),toni).
branch_status('les23','K1802','M14',[inc,'B',self],'ok ear; offspring family 4795; recessive',4753,'19R4753:0002308','19R4753:0002308',date(17,5,2022),time(12,00,00),toni).




branch_status('les23','K1804','Mo20W',[],'5th selfed; recessive; 0.45 germination rate, 2/9 mutants in 23r; lesns in 22r likely infectns',0,'22R4898:0003106','22R4898:0003106',date(23,5,2024),time(21,00,00),toni).

branch_status('les23','K1804','W23',[inc,'B',self],'6th selfed; recessive',5012,'22R4899:0003208','22R4899:0003208',date(23,3,2024),time(21,00,00),toni).

branch_status('les23','K1804','M14',['B',self],'6th selfed in M; recessive; 0.725 germination rate, 8/29 mutants in 23r',4900,'22R4900:0003309','22R4900:0003309',date(23,3,2024),time(21,00,00),toni).





branch_status('les23','K3514','Mo20W',[],'2nd selfed in S; test, S; recessive; reach back because descendants have horrible germination',0,'12N3895:0005406','12N3895:0005406',date(25,4,2024),time(17,00,00),toni).

branch_status('les23','K3514','Mo20W',[],'5th selfed in S; test, S; recessive; 0.17 germination rate, 0/6 mutants in 23r; sib 21R4887:0002903 had 0.05 germ in 22r',0,'21R4887:0002906','21R4887:0002906',date(25,4,2024),time(17,00,00),toni).

branch_status('les23','K3514','W23',[inc,'B',self],'ok ear; offspring family 4796; recessive',4756,'19R4756:0002707','19R4756:0002707',date(17,5,2022),time(12,00,00),toni).

branch_status('les23','K3514','M14',[],'5th selfed; outcross to S; recessive',0,'23R4985:0014501','23R4985:0014501',date(25,4,2024),time(17,00,00),toni).






branch_status('les23','K16306','Mo20W',[],'5th selfed in S; recessive',0,'23R4986:0014601','23R4986:0014601',date(23,3,2024),time(21,00,00),toni).
branch_status('les23','K16306','W23',[self],'6th selfed in W; recessive, check ears',4987,'23R4987:0014706','23R4987:0014706',date(23,3,2024),time(21,00,00),toni).
branch_status('les23','K16306','M14',[self],'6th selfed in M; recessive, check ears',4988,'23R4988:0014807','23R4988:0014807',date(23,3,2024),time(21,00,00),toni).







% secondary recessives





branch_status('les*-74-1873-9','K9304','Mo20W',[],'4th selfed in S; recessive; 0.7 germination rate, no mutants? in 23r; few small chlorotic lesions in 22r',0,'22R4904:0006501','22R4904:0006501',date(26,3,2024),time(14,00,00),toni).

branch_status('les*-74-1873-9','K9304','W23',[],'4th selfed in W; test, W; recessive; grandpa had 0.6, 3/12 mutants germination rate in 23r',0,'23R5003:0016602','23R5003:0016602',date(26,3,2024),time(14,00,00),toni).

branch_status('les*-74-1873-9','K9304','M14',[],'4th in M; recessive',0,'23R405:M0012711','23R5046:0033401',date(26,3,2024),time(14,00,00),toni).



% les*-N1395C

% mutants may die faster in the cold room?
%
% Kazic, 19.5.2022

branch_status('les*-N1395C','K7501','Mo20W',[],'4th selfed in S; recessive; pa had 0.9 germination rate in 23r',0,'23R4991:0015109','23R4991:0015109',date(26,3,2024),time(14,00,00),toni).
branch_status('les*-N1395C','K7501','W23',[],'2nd selfed in W; recessive; 0.9 germination rate, 2/36 mutants in 23r; cut out wild types?; low cl',0,'12R3533:0015906','12R3533:0015906',date(26,3,2024),time(14,00,00),toni).
branch_status('les*-N1395C','K7501','M14',[],'3rd in M; recessive',0,'23R405:M0008603','23R3777:0031002',date(26,3,2024),time(14,00,00),toni).

% branch_status('les*-N1395C','K7501','W23',[],'2nd; test, W; no phe 20r; recessive',0,'12R3533:0015906','12R3533:0015906',date(19,5,2022),time(12,00,00),toni).
% branch_status('les*-N1395C','K7501','M14',[],'2nd; test, M; no phe 20r; recessive',0,'11N3512:0028406','11N3512:0028406',date(19,5,2022),time(12,00,00),toni).





% les*-N1450

branch_status('les*-N1450','K7606','Mo20W',[],'4th in S; recessive; pa had 0.95 germination rate, 7/19 mutants, infrequent, small watery lesions in 23r',0,'23R205:S0005604','23R4975:0031114',date(26,3,2024),time(14,00,00),toni).

branch_status('les*-N1450','K7606','W23',[],'2nd selfed in W; grandpa had 0.9 germination rate, 8/18 mutants in 22r; small, profuse watery chlorotic lesns; recessive',0,'23R4992:0015201','23R4992:0015201',date(26,3,2024),time(14,00,00),toni).

branch_status('les*-N1450','K7606','M14',[],'2nd in M; recessive',0,'23R405:M0008811','23R3690:0031220',date(26,3,2024),time(14,00,00),toni).


% branch_status('les*-N1450','K7606','W23',[],'1st; self; recessive',0,'12R305:W0011609','12R3690:0035709',date(19,5,2022),time(12,00,00),toni).
% branch_status('les*-N1450','K7606','W23',[],'1st selfed; test, W; 2nd planting; recessive',0,'14R4200:0016304','14R4200:0016304',date(19,5,2022),time(12,00,00),toni).





% les*-N2012

branch_status('les*-N2012','K7702','Mo20W',[],'2nd selfed in S; recessive; pa had 0.95 germination rate in 23r; large diffuse chlorotic watery lesns at med freq',0,'23R4993:0015307','23R4993:0015307',date(26,3,2024),time(14,00,00),toni).

branch_status('les*-N2012','K7702','W23',[],'4th selfed in W; recessive; pa had 0.9 germination rate in 23r; large diffuse chlorotic watery lesns at med freq',0,'23R4994:0015402','23R4994:0015402',date(26,3,2024),time(14,00,00),toni).

branch_status('les*-N2012','K7702','M14',[],'3rd selfed in M; recessive; pa had 0.95 germination rate in 23r; smaller, numerous chlorotic lesns',0,'23R4995:0015504','23R4995:0015504',date(26,3,2024),time(14,00,00),toni).






% les*-NA467

% abandon? phe becoming more convincing

branch_status('les*-NA467','K9001','Mo20W',[],'3rd selfed in S; pa had 0.85 germination rate in 23r; partially dominant??? profuse small chlorotic lesns fusing into a few really large necrotic ones; recessive',0,'23R5001:0016410','23R5001:0016410',date(26,3,2024),time(14,00,00),toni).

branch_status('les*-NA467','K9001','W23',[],'2nd selfed in W; recessive; pa had 1.05 germination rate in 23r; partially dominant??? many small chlorotic lesns fusing into some large necrotic one',0,'23R5002:0016501','23R5002:0016501',date(26,3,2024),time(14,00,00),toni).


branch_status('les*-NA467','K9001','M14',[],'1st self in M; short -- dwarf plants with crummy ears in 23r; check phe carefully, v faint in 23r; recessive',0,'20R4789:0005902','20R4789:0005902',date(14,5,2024),time(18,00,00),toni).


% image 23r/aleph/8.8/DSC_0142.NEF doesn't have phenotype, but
% image 23r/aleph/8.8/DSC_0190.NEF for sib 31714 does
%
% Kazic, 14.5.2024

branch_status('les*-NA467','K9001','M14',[],'2nd in M; pa had 0.7 germination rate, 5/14 mutants, short -- dwarf plants with crummy ears in 23r; check phe carefully, v faint in 23r; recessive',0,'23R405:M0012802','23R4981:0031802',date(19,5,2022),time(12,00,00),toni).







% lesLA

branch_status('lesLA','K17307','Mo20W',[],'1st selfed in S; 2nd planting; recessive; 1.0 germination rate in 22r',0,'11N3098:0024703','11N3098:0024703',date(19,5,2022),time(12,00,00),toni).
branch_status('lesLA','K17307','W23',[],'3rd in W; recessive; sib has all wt descendants; check phe carefully; pa had v high freq n lesns in 12r',0,'12R305:W0004106','12R3717:0039310',date(17,5,2024),time(6,00,00),toni).
branch_status('lesLA','K17307','M14',[],'1st selfed in M; 1.0 germination rate in 23r; recessive',0,'11N3100:0024910','11N3100:0024910',date(15,5,2023),time(12,00,00),toni).


















%%%%%%%%%%%% continue to neglect these for the foreseeable future
%
% like, til 22r
%
% the non-balint-kurti may not be worth bothering with ever
%
% Kazic, 19.5.2022


% les28

% abandoned, phe not convincing
%
% Kazic, 19.5.2022
%
% branch_status('les28','K16406','Mo20W',[],'1st selfed; test, S; 2nd planting; recessive',0,'11N3472:0021101','11N3472:0021101',date(25,5,2021),time(12,00,00),toni).
% branch_status('les28','K16406','W23',[],'2nd selfed; test, W; recessive',0,'20R4788:0005601','20R4788:0005601',date(25,5,2021),time(12,00,00),toni).
% branch_status('les28','K16406','M14',[],'1st selfed; test, M; 2nd planting; recessive',0,'11N3474:0021306','11N3474:0021306',date(25,5,2021),time(12,00,00),toni).





% abandoned
%
% Kazic, 26.3.2024

% branch_status('nec*-6853','K10712','Mo20W',[],'1st selfed; test, S; 2nd planting; recessive',0,'09R1207:0010910','09R1207:0010910',date(22,5,2020),time(12,00,00),toni).
% branch_status('nec*-6853','K10712','W23',[],'2nd selfed; test, W; recessive',0,'20R4790:0006003','20R4790:0006003',date(22,5,2020),time(12,00,00),toni).
% branch_status('nec*-6853','K10712','M14',[],'1st selfed; test, M; 2nd planting; recessive',0,'12R3548:0017604','12R3548:0017604',date(22,5,2020),time(12,00,00),toni).



%% branch_status('spc1-N1376','K10913','?',[],'S,W,M; 2nd planting; recessive',0,'09R0109:0011113','09R0109:0011113',date(22,5,2020),time(12,00,00),toni).


%% branch_status('nec2-8147','K15305','W23',[],'1st; W, S; 2nd planting; recessive',0,'12R3544:0017110','12R3544:0017110',date(22,5,2020),time(12,00,00),toni).
%% branch_status('nec2-8147','K15305','M14',[],'1st; M, S; 2nd planting; recessive',0,'12R3545:0017202','12R3545:0017202',date(22,5,2020),time(12,00,00),toni).


%% branch_status('les*-tilling1','K17404','W23',[],'1st; W, S; 2nd planting; recessive',0,'11R3096:0007107','11R3096:0007107',date(22,5,2020),time(12,00,00),toni).
%% branch_status('les*-tilling1','K17404','M14',[],'1st; M, S; 2nd planting; recessive',0,'11R3097:0007212','11R3097:0007212',date(22,5,2020),time(12,00,00),toni).


%% branch_status('les*-PI262474','K13708','Mo20W',[],'1st; S; 2nd planting; recessive',0,'11R3089:0006805','11R3089:0006805',date(22,5,2020),time(12,00,00),toni).
%% branch_status('les*-PI262474','K13708','W23',[],'1st; W; 2nd planting; recessive',0,'11R3090:0006604','11R3090:0006604',date(22,5,2020),time(12,00,00),toni).
%% branch_status('les*-PI262474','K13708','M14',[],'1st; M; 2nd planting; recessive',0,'11R3091:0006702','11R3091:0006702',date(22,5,2020),time(12,00,00),toni).


%% branch_status('les*-N2502','K8709','Mo20W',[],'1st; S; 2nd planting; recessive',0,'11R1223:0006305','11R1223:0006305',date(22,5,2020),time(12,00,00),toni).
%% branch_status('les*-N2502','K8709','W23',[],'2nd; W; 2nd planting; recessive',0,'12R3540:0016604','12R3540:0016604',date(22,5,2020),time(12,00,00),toni).
%% branch_status('les*-N2502','K8709','M14',[],'1st; M; 2nd planting; recessive',0,'07R1838:0091910','07R1838:0091910',date(22,5,2020),time(12,00,00),toni).


%% branch_status('les*-N2363A','K8304','Mo20W',[],'1st; S; 2nd planting; recessive',0,'12R3535:0016101','12R3535:0016101',date(22,5,2020),time(12,00,00),toni).
%% branch_status('les*-N2363A','K8304','W23',[],'1st; W; 2nd planting; recessive',0,'12R3536:0016201','12R3536:0016201',date(22,5,2020),time(12,00,00),toni).
%% branch_status('les*-N2363A','K8304','M14',[],'1st; M; 2nd planting; recessive',0,'12R3539:0016504','12R3539:0016504',date(22,5,2020),time(12,00,00),toni).


%% branch_status('les*-N2333A','K8210','Mo20W',[],'1st; S, W; 2nd planting; recessive',0,'12R3542:0016904','12R3542:0016904',date(22,5,2020),time(12,00,00),toni).
%% branch_status('les*-N2333A','K8210','M14',[],'1st; M, W; 2nd planting; recessive',0,'12R3543:0017002','12R3543:0017002',date(22,5,2020),time(12,00,00),toni).


%% branch_status('les*-N2290A','K8002','Mo20W',[],'1st; S; 2nd planting; recessive',0,'11R3101:0006002','11R3101:0006002',date(22,5,2020),time(12,00,00),toni).
%% branch_status('les*-N2290A','K8002','W23',[],'1st; W; 2nd planting; recessive',0,'11R3102:0006101','11R3102:0006101',date(22,5,2020),time(12,00,00),toni).
%% branch_status('les*-N2290A','K8002','M14',[],'1st; M; 2nd planting; recessive',0,'11R3103:0006201','11R3103:0006201',date(22,5,2020),time(12,00,00),toni).


%% branch_status('les*-N2013','K7807','Mo20W',[],'1st; S; 2nd planting; recessive',0,'11R3237:0005707','11R3237:0005707',date(22,5,2020),time(12,00,00),toni).
%% branch_status('les*-N2013','K7807','W23',[],'1st; W; 2nd planting; recessive',0,'11R3238:0005801','11R3238:0005801',date(22,5,2020),time(12,00,00),toni).
%% branch_status('les*-N2013','K7807','M14',[],'2nd; M; 2nd planting; recessive',0,'15R4383:0008901','15R4383:0008901',date(22,5,2020),time(12,00,00),toni).


%% branch_status('les*-B1','K62805','Mo20W',[],'1st; S, W, M; 2nd planting; recessive',0,'11N3513:0029602','11N3513:0029602',date(22,5,2020),time(12,00,00),toni).


%% branch_status('csp1','K11503','Mo20W',[],'1st; S; 2nd planting; recessive',0,'10R1020:0012508','10R1020:0012508',date(22,5,2020),time(12,00,00),toni).
%% branch_status('csp1','K11503','W23',[],'1st; W; 2nd planting; recessive',0,'10R1021:0012604','10R1021:0012604',date(22,5,2020),time(12,00,00),toni).
%% branch_status('csp1','K11503','M14',[],'1st; M; 2nd planting; recessive',0,'10R1025:0012704','10R1025:0012704',date(22,5,2020),time(12,00,00),toni).


%% branch_status('cpc1-N2284B','K9606','?',[],'1st; S, W, M; 2nd planting; recessive',0,'11R3113:0008704','11R3113:0008704',date(22,5,2020),time(12,00,00),toni).





%% % balint-kurti

%% branch_status('les*-R172-1','K68402','M14',[],'1st; S, W, M; 2nd planting; recessive',0,'17R4594:0022902','17R4594:0022902',date(22,5,2020),time(12,00,00),toni).
%% branch_status('les*-R171-3','K68301','M14',[],'1st; S, W, M; 2nd planting; recessive',0,'17R4593:0022802','17R4593:0022802',date(22,5,2020),time(12,00,00),toni).
%% branch_status('bk*-19','K68203','M14',[],'1st; S, W, M; 2nd planting; recessive',0,'17R4645:0022706','17R4645:0022706',date(22,5,2020),time(12,00,00),toni).
%% branch_status('les*-R170-1','K68105','M14',[],'1st; S, W, M; 2nd planting; recessive',0,'17R4592:0022609','17R4592:0022609',date(22,5,2020),time(12,00,00),toni).
%% branch_status('les*-R169-1','K68011','Mo20W',[],'1st; S, W; 2nd planting; recessive',0,'17R4590:0022403','17R4590:0022403',date(22,5,2020),time(12,00,00),toni).
%% branch_status('les*-R169-1','K68011','M14',[],'1st; M, W; 2nd planting; recessive',0,'17R4591:0022506','17R4591:0022506',date(22,5,2020),time(12,00,00),toni).
%% branch_status('les*-R168-2','K67904','Mo20W',[],'1st; S, W; 2nd planting; recessive',0,'17R4588:0022201','17R4588:0022201',date(22,5,2020),time(12,00,00),toni).
%% branch_status('les*-R168-2','K67904','M14',[],'1st; M, W; 2nd planting; recessive',0,'17R4589:0022303','17R4589:0022303',date(22,5,2020),time(12,00,00),toni).
%% branch_status('les*-R11-2','K67710','Mo20W',[],'1st; S, W; 2nd planting; recessive',0,'17R4585:0021905','17R4585:0021905',date(22,5,2020),time(12,00,00),toni).
%% branch_status('les*-R11-2','K67710','M14',[],'1st; M, W; 2nd planting; recessive',0,'17R4586:0022010','17R4586:0022010',date(22,5,2020),time(12,00,00),toni).
%% branch_status('les*-R10-2','K67602','Mo20W',[],'1st; S, W; 2nd planting; recessive',0,'17R4583:0021703','17R4583:0021703',date(22,5,2020),time(12,00,00),toni).
%% branch_status('les*-R10-2','K67602','M14',[],'1st; M, W; 2nd planting; recessive',0,'17R4584:0021802','17R4584:0021802',date(22,5,2020),time(12,00,00),toni).
%% branch_status('les*-R9-2','K67510','M14',[],'1st; M, S, W; 2nd planting; recessive',0,'17R4582:0021602','17R4582:0021602',date(22,5,2020),time(12,00,00),toni).
%% branch_status('les*-R8-2','K67410','Mo20W',[],'1st; S, W; 2nd planting; recessive',0,'18R4701:0022506','18R4701:0022506',date(22,5,2020),time(12,00,00),toni).
%% branch_status('les*-R8-2','K67410','M14',[],'1st; M, W; 2nd planting; recessive',0,'17R4581:0021502','17R4581:0021502',date(22,5,2020),time(12,00,00),toni).
%% branch_status('les*-R7-2','K67305','Mo20W',[],'1st; S, W; 2nd planting; recessive',0,'17R4608:0021301','17R4608:0021301',date(22,5,2020),time(12,00,00),toni).
%% branch_status('les*-R7-2','K67305','M14',[],'1st; M, W; 2nd planting; recessive',0,'17R4609:0021405','17R4609:0021405',date(22,5,2020),time(12,00,00),toni).
%% branch_status('les*-R6-1','K67208','Mo20W',[],'1st; S, W; 2nd planting; recessive',0,'17R4606:0021104','17R4606:0021104',date(22,5,2020),time(12,00,00),toni).
%% branch_status('les*-R6-1','K67208','M14',[],'1st; M, W; 2nd planting; recessive',0,'17R4607:0021201','17R4607:0021201',date(22,5,2020),time(12,00,00),toni).
%% branch_status('les*-R5-1','K67102','Mo20W',[],'1st; S, W; 2nd planting; recessive',0,'17R4604:0020906','17R4604:0020906',date(22,5,2020),time(12,00,00),toni).
%% branch_status('les*-R5-1','K67102','M14',[],'1st; M, W; 2nd planting; recessive',0,'17R4605:0021011','17R4605:0021011',date(22,5,2020),time(12,00,00),toni).
%% branch_status('les*-R4-1','K67005','Mo20W',[],'1st; S; 2nd planting; recessive',0,'17R4601:0020601','17R4601:0020601',date(22,5,2020),time(12,00,00),toni).
%% branch_status('les*-R4-1','K67005','W23',[],'1st; W; 2nd planting; recessive',0,'17R4602:0020703','17R4602:0020703',date(22,5,2020),time(12,00,00),toni).
%% branch_status('les*-R4-1','K67005','M14',[],'1st; M; 2nd planting; recessive',0,'17R4603:0020804','17R4603:0020804',date(22,5,2020),time(12,00,00),toni).
%% branch_status('les*-R3-1','K66911','Mo20W',[],'1st; S; 2nd planting; recessive',0,'17R4597:0020208','17R4597:0020208',date(22,5,2020),time(12,00,00),toni).
%% branch_status('les*-R3-1','K66911','W23',[],'1st; W; 2nd planting; recessive',0,'17R4598:0020301','17R4598:0020301',date(22,5,2020),time(12,00,00),toni).
%% branch_status('les*-R3-1','K66911','M14',[],'1st; M; 2nd planting; recessive',0,'17R4599:0020401','17R4599:0020401',date(22,5,2020),time(12,00,00),toni).
%% branch_status('les*-R2-1','K66801','Mo20W',[],'1st; S, W; 2nd planting; recessive',0,'17R4595:0020015','17R4595:0020015',date(22,5,2020),time(12,00,00),toni).
%% branch_status('les*-R2-1','K66801','M14',[],'1st; M, W; 2nd planting; recessive',0,'17R4596:0020105','17R4596:0020105',date(22,5,2020),time(12,00,00),toni).
%% branch_status('les*-R1-1','K66707','Mo20W',[],'1st; S, W; 2nd planting; recessive',0,'17R4579:0019804','17R4579:0019804',date(22,5,2020),time(12,00,00),toni).
%% branch_status('les*-R1-1','K66707','M14',[],'1st; M, W; 2nd planting; recessive',0,'17R4580:0019906','17R4580:0019906',date(22,5,2020),time(12,00,00),toni).
%% branch_status('les*-R168-1','K67812','Mo20W',[],'1st; S, W; 2nd planting; recessive',0,'18R4702:0022603','18R4702:0022603',date(22,5,2020),time(12,00,00),toni).
%% branch_status('les*-R168-1','K67812','M14',[],'1st; M, W; 2nd planting; recessive',0,'17R4587:0022111','17R4587:0022111',date(22,5,2020),time(12,00,00),toni).
