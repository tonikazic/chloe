% this is ../b/artistry/papers/current/chloe/images/dem_facts.pl


%%% primary field and seed room data


% crop(CropID,Location,FieldID,Planting,PlantingDate,HarvestStartDate,HarvestEndDate).
crop('19R',missouri,field33,2,date(10,06,2019),date(17,9,2019),date(24,09,2019)).


% cross(FemaleParent,MaleParent,Ear,Repeat,Bee,Pilot,Date,Time).
cross('19R505:B0001606','19R4442:0009510',ear(1),false,toni,dewi,date(15,08,2019),time(11,15,13)).


% cross_prep(PlantID,ListPreps,Observer,Date,Time).
cross_prep('19R4781:0016604',[bag(tassel)],toni,date(15,08,2019),time(09,02,21)).



% harvest(MaPlantID,PaPlantID,PollinationOutcome,Note,DateOfHarvest,TimeOfHarvest).
harvest('18R4263:0010712','18R4263:0010719',succeeded,'three_quarter',toni,date(20,09,2018),time(15,03,25)).
harvest('18R4263:0010718','18R4263:0010719',succeeded,_,toni,date(20,09,2018),time(15,03,25)).


% image(PlantID,ImageNum,AbsLeafNum,Section,Camera,Light,Observer,Date,Time).
image('19R4719:0016408',0131,e0,'middle',aleph,'ex situ ambient reflected, field',toni,date(17,08,2019),time(17,32,51)).


% leaf_alignmt(PlantID,B0LeafAsTrueRelLeafNum,MarkerLeaf,Observer,Date,Time).
leaf_alignmt('15R0680:0022410',b0_leaf('e-3'),marker_leaf('e0'),avi,date(26,08,2015),time(10,02,02)).


% mutant(PlantID,PhenotypeList,CrossPlan,Photograph,FurtherExaminations,Observer,Date,Time).
mutant('19R4772:0018712',[phenotype(les),phenotype(shorter_by_1_ft),phenotype(small_ear),bug(0)],cross,false,[],toni,date(07,08,2019),time(12,00,00)).
mutant('19R4772:0018713',[phenotype(wild_type),bug(0)],false,false,[],toni,date(07,08,2019),time(12,00,00)).


% packed_packet(PacketNum,MaNumGtype,PaNumGtype,Kernels,Packer,Date,Time).
packed_packet(p01000,'11R892:E0serend','11R892:E0serend',60,toni,date(01,07,2019),time(12,00,00)).


% plant_anatomy(PlantID,Height,NumLeaves,FirstEarLeaf,NumTillers,Observer,Date,Time).
plant_anatomy('07R2272:0035001',cm(185.0),20,12,0,toni,date(08,03,2007),time(06,46,20)).
plant_anatomy('17R405:M0002216',cm(129.54),_,_,_,toni,date(11,08,2017),time(14,30,00)).


% plant_fate(PlantID,Reason,Observer,Date,Time).
plant_fate('14R205:S0000214',sacrificed(_),toni,date(09,08,2014),time(12,00,00)).
plant_fate('17R4565:0019124',kicked_down(light),toni,date(02,08,2017),time(12,00,00)).


% planted(RowPotFlat,PacketNum,Ft,Planter,Date,Time,PlantingNotesOrSoilLevel,Crop).
planted(r00405,p01000,40,chris,date(01,07,2019),time(12,00,00),full,'19R').


% priority_rows(Crop,ListRowsInPriorityOrder).
priority_rows('19R',[
%
% selves		      
%
r00023,
r00024,
...
%
% inbreds
%
r00001,
r00002,
...
%
% dainties
%
r00122,
r00124,
...
r00183]).


% row_harvested(Row,Observer,Date,Time,Crop).
row_harvested(r00113,dewi,date(24,09,2019),time(11,25,36),'19R').


% row_status(Row,num_emerged(Num),ListPhenotypesAndCounts,Observer,Date,Time,Crop).
row_status(r00405,num_emerged(60),[ave_leaf_num(15),phenotype(wild_type,-60),phenotype(mutant,60),phenotype(healthy,0)],dewi,date(07,10,2019),time(11,30,00),'19R').

% sample(PlantID,SampleNum,Organ,TypeSample,Sampler,Date,Time).
sample('19R4719:0016408',e03877,any_leaf,tissue,toni,date(17,08,2019),time(17,33,52)).






%%% genotype and planning data, manually maintained

% genotype(Family,MaFam,MaNumGtype,PaFam,PaNumGtype,MaGMa,MaGPa,PaGMa,PaGPa,GeneticFeaturesOfGreatestInterest,KNumber).
genotype(3450,305,'11R305:W0051204',3267,'11R3267:0021903','W23','W23','W23','(W23/Mo20W)/Les10',['Les10'],'K0801').                                             


% source(MyFamilyNum,Name,DonorsMaNumGtype,DonorsPaNumGtype,CropFirstPlanted,SourceOfLine,DateAcquired).
source(702,'14SGEM:BGEM:23344','((Cateto Nortista - GIN I/PHB47 B)/PHB47)-(2n)-002-001-B','16R0702:0000000','16R','Candy Gardner',date(2,6,2016)).


% inbred_pool(FamilyNum,ListContributingEars).
%
% where each element of the list is of the form
%
%    MaPlantID-(PaPlantID,Observer,Date,Time)
%
% the Observer being the person who shelled the corn and pooled the kernels together.

inbred_pool(505,[
	'13R504:B0002702'-('13R504:B0002702',avi,date(06,06,2014),time(14,06,43)),
	'13R504:B0002707'-('13R504:B0002707',avi,date(06,06,2014),time(14,06,43)),
...
	'13R504:B0002917'-('13R504:B0002917',avi,date(06,06,2014),time(14,06,43))]).



% pedigree_tree(SubDir,ListFileNames).    
pedigree_tree(primary_dominants,[
'les-tk1-k70309_w23',
'les1-k0104_mo20w',
'les1-k1900_w23',
...
'les21-n1442-k7200_b73ht1']).




% plan(MaNumGtype,PaNumGtype,Planting,PlanList,Notes,Crop).
plan('18R405:M0004914','18R4727:0029611',1,[self],'is 5th','19R').

















%%% inventory management


% box(Box,SleeveOrBag,Observer,Date,Time).
box(x00056,v00247,toni,date(7,5,2013),time(11,0,0)).



% inventory(MaNumGtype,PaNumGtype,num_kernels(EstimatedOrCounted),Observer,Date,Time,Sleeve).

inventory('13R4102:0010102','13R4102:0010107',num_kernels(three_quarter),toni,date(21,11,2018),time(16,11,57),v00150).
inventory('13R4102:0010102','13R4102:0010107',num_kernels(sixteenth),toni,date(02,06,2019),time(16,26,21),v00150).

inventory('14R405:M0001808','14R4296:0024014',num_kernels(half),mason,date(15,06,2018),time(15,19,20),v00175).
inventory('14R405:M0001808','14R4296:0024014',num_kernels(3),toni,date(07,06,2019),time(15,00,00),v00175).
inventory('16R405:M0003312','16R4027:0012203',num_kernels(0),toni,date(07,06,2019),time(15,00,00),v00192).

inventory('17R891:L0xxxxxx','17R891:L0xxxxxx',num_kernels(inf),toni,date(25,07,2019),time(04,39,00),z00000).





% sleeve_bdry(FirstMaInSleeve,LastMaInSleeve,Sleeve,Observer,Date,Time).    
sleeve_bdry('11N405:M0037603','12R3528:0015415',v00119,toni,date(03,06,2019),time(17,03,40)).









%%% metadata on people, crops, lines, standard packet numbers, genes, and ideas

% current_crop(CropParticle).
current_crop('19R').

% current_inbred(Crop,MaFamily,PaFamily,InbredFamily,StdPacketNum).
current_inbred('19R',401,401,405,p00003).
current_inbred('19R',000,000,000,p00000).


% family_prefix(Inbred,Prefix).
family_prefix('B73','B').


% ClassOfLine(ListFamilyNumbers).
elite_corn([890,891]).
fun_corn([999,998,997,991,990]).


% gene_type(Locus,Gene,Allele,Type).
gene_type('(B73/AG32)','(B73/AG32)','',wild_type).
gene_type('Les*-N1378','Les*','N1378',dominant).
gene_type(les23,les23,'',recessive).
gene_type('lls1 121D','lls1','121D',recessive).
%
% it's not in my backgrounds, so fixed the facts
%
% Kazic, 2.1.2020
%
% gene_type('Les5','Les5','',dominant).
gene_type('Les5','Les5','',recessive).


% idea(Num,Idea,Ideator,Date,Time).
idea(125,'We still have problems with HR''s field crews separating tags from bags.  For the inbreds and selves, we can always determine the order.  But write a male sign on the male tag in sibs.  This is just for winter nursery.',date(19,4,2013),time(05,31,00)).


% inbred_packet_num(InbredPrefix,StdPacketNum).
inbred_packet_num('M',p00003).


% person(Name,GivenName,Surname,Crops).
person(toni,'Toni','Kazic',['06r','06n','06g','07g','07r','08r','08g','09r','09g',
            '10r','11r','11n','12r','12n','13r','14r','15r','16r','17r','18r','19r']).
person(dewi,'Dewi','Kharismawati',['19r']).


% prefix(Line,Prefix).
prefix('B73','B').






%%% one-off for a specific experiment; this is from the 2009 national NAM grow-out

% nam(Row,TotalPlants,TotalLesMutants,Note,PhotoPlant,ImageRangeStart,ImageRangeEnd,Camera,Observer,Date,Time).
nam(row(2511229),num_plants(13),num_les(13),'small necrotic',photo_plant(4),image(start,10),image(end,22),aleph,toni,date(17,09,2009),time(09,36,21)).







%%% utility facts

% num_secs(NumberOfDays,Seconds).
num_secs(400,34560000).






%%% inverted indices for faster computation; automatically generated


% barcode_index(RowNumOrAtom,Crop,RowPlant,Plant,Family,PostColon,Barcode).
barcode_index(164,'14R','0016412','12',4201,':0016412','14R4201:0016412').


% crop_rowplant_index(NumericalGenotype,Crop,Row,Plant).
crop_rowplant_index('06R301:WI82.120','06R','I82.1','20').


% frpc_index(RowPlant,Crop,Family,NumericalGenotype).
frpc_index('W013619','13R',4121,'13R4121:W013619').


% planting_index(MaNumGType,PaNumGType,Crop,Row).
planting_index('18R305:W0001801','18R4709:0023802','19R',187).


% row_members_index(Crop,Row,ListRowMembers).
row_members_index('06R','I82.1',['06R301:WI82.101','06R301:WI82.102','06R301:WI82.103','06R301:WI82.104','06R301:WI82.105','06R301:WI82.106','06R301:WI82.107','06R301:WI82.108','06R301:WI82.109','06R301:WI82.110','06R301:WI82.111','06R301:WI82.112','06R301:WI82.113','06R301:WI82.114','06R301:WI82.115','06R301:WI82.116','06R301:WI82.117','06R301:WI82.118','06R301:WI82.119','06R301:WI82.120']).





%%% some obsolete predicates

% ear, mistagged, missing_genotype, tassel
