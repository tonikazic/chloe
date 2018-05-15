% this is ../c/maize/demeter/data/source.pl


% lines that people send, with original names or numerical genotypes if available

% source(MyFamilyNum,Name,DonorsMaNumGtype,DonorsPaNumGtype,CropFirstPlanted,SourceOfLine,DateAcquired).
%
% where DateAcquired is in the form
%
%     date(Day,Month,4DigitYear)
%
%
% modified from the original source/4 facts using clean_data:rewrite_source_n_genotype_facts_for_founders/2
%
% Kazic, 1.8.09


% sources checked; all correct
%
% Kazic, 17.12.09



source(1,'Mo20W/Les1','M18 112 012','M18 114 512','06R','M. G. Neuffer',date(1,5,2006)).
source(2,'Mo20W/Les2','M18 112 103','M18 114 605','06R','M. G. Neuffer',date(1,5,2006)).
source(3,'Mo20W/Les4','M18 112 105','M18 114 810','06R','M. G. Neuffer',date(1,5,2006)).
source(4,'Mo20W/Les6','M18 112 116','M18 115 005','06R','M. G. Neuffer',date(1,5,2006)).
source(5,'Mo20W/Les7','M18 112 110','M18 115 104','06R','M. G. Neuffer',date(1,5,2006)).
source(6,'Mo20W/Les8','M18 112 0xx','M18 115 203','06R','M. G. Neuffer',date(1,5,2006)).
source(7,'Mo20W/Les9','M18 112 001','M18 115 301','06R','M. G. Neuffer',date(1,5,2006)).
source(8,'Mo20W/Les10','M18 112 0xx','M18 115 4xx','06R','M. G. Neuffer',date(1,5,2006)).
source(9,'Mo20W/Les11','M18 112 109','M18 115 50x','06R','M. G. Neuffer',date(1,5,2006)).
source(10,'Mo20W/Les12','M18 112 011','M18 115 604','06R','M. G. Neuffer',date(1,5,2006)).
source(11,'Mo20W/Les13','M18 112 014','M18 115 7xx','06R','M. G. Neuffer',date(1,5,2006)).
source(12,'Mo20W/Les15','M18 112 118','M18 115 9xx','06R','M. G. Neuffer',date(1,5,2006)).
source(13,'Mo20W/Les17','M18 112 112','M18 116 001','06R','M. G. Neuffer',date(1,5,2006)).
source(14,'Mo20W/Les18','M18 112 1xx','M18 116 101','06R','M. G. Neuffer',date(1,5,2006)).
source(15,'Mo20W/Les19','M18 112 015','M18 116 203','06R','M. G. Neuffer',date(1,5,2006)).
source(16,'Mo20W/Les21','M18 122 06','M18 116 404','06R','M. G. Neuffer',date(1,5,2006)).
source(17,'Mo20W/lls1','M18 112 118','M18 116 501','06R','M. G. Neuffer',date(1,5,2006)).
source(18,'Mo20W/les23','M18 112 003','M18 118 01','06R','M. G. Neuffer',date(1,5,2006)).
source(19,'W23/Les1','M18 112 512','M18 114 509','06R','M. G. Neuffer',date(1,5,2006)).
source(20,'W23/Les2','M18 112 410','M18 114 604','06R','M. G. Neuffer',date(1,5,2006)).
source(21,'W23/Les4','M18 112 601','M18 114 814','06R','M. G. Neuffer',date(1,5,2006)).
source(22,'W23/Les6','M18 112 5xx','M18 115 002','06R','M. G. Neuffer',date(1,5,2006)).
source(23,'W23/Les7','M18 113 603','M18 115 102','06R','M. G. Neuffer',date(1,5,2006)).
source(24,'W23/Les8','M18 113 604','M18 115 201','06R','M. G. Neuffer',date(1,5,2006)).
source(25,'W23/Les9','M18 113 606','M18 115 308','06R','M. G. Neuffer',date(1,5,2006)).
source(26,'W23/Les10','M18 112 411','M18 115 405','06R','M. G. Neuffer',date(1,5,2006)).
source(27,'W23/Les12','M18 113 609','M18 560 3','06R','M. G. Neuffer',date(1,5,2006)).
source(28,'W23/Les13','M18 112 513','M18 570 7','06R','M. G. Neuffer',date(1,5,2006)).
source(29,'W23/Les15','M18 113 607','M18 115 901A','06R','M. G. Neuffer',date(1,5,2006)).
source(30,'W23/Les17','M18 112 514','M18 116 002','06R','M. G. Neuffer',date(1,5,2006)).
source(31,'W23/Les18','M18 112 5xx','M18 116 102','06R','M. G. Neuffer',date(1,5,2006)).
source(32,'W23/Les19','M18 112 615','M18 116 205','06R','M. G. Neuffer',date(1,5,2006)).
source(33,'W23/Les21','M18 112 3xx','M18 116 403','06R','M. G. Neuffer',date(1,5,2006)).
source(34,'W23/lls1 121D','M18 112 503','M18 116 601','06R','M. G. Neuffer',date(1,5,2006)).
source(35,'W23/les23','M18 113 602','M18 111 8xx','06R','M. G. Neuffer',date(1,5,2006)).
source(36,'Les1 NonExp/Les1 Exp','M18 114 505','M18 114 503','06R','M. G. Neuffer',date(1,5,2006)).
source(37,'Les2 NonExp/Les2 Exp','M18 114 602','M18 114 603','06R','M. G. Neuffer',date(1,5,2006)).
source(38,'Les4 NonExp/Les4 Exp','M18 114 806','M18 114 807','06R','M. G. Neuffer',date(1,5,2006)).
source(39,'Les5 Exp???/Les5 Exp???','M18 114 905','M18 114 907','06R','M. G. Neuffer',date(1,5,2006)).
source(40,'Les6 NonExp/Les6 Exp','M18 115 001','M18 115 002','06R','M. G. Neuffer',date(1,5,2006)).
source(41,'Les7 NonExp/Les7 Exp','M18 115 103','M18 115 104','06R','M. G. Neuffer',date(1,5,2006)).
source(42,'Les8 NonExp/Les8 Exp','M18 115 202','M18 115 2xx','06R','M. G. Neuffer',date(1,5,2006)).
source(43,'Les9 NonExp/Les9 Exp','M18 115 307','M18 115 308','06R','M. G. Neuffer',date(1,5,2006)).
source(44,'Les10 NonExp/Les10 Exp','M18 115 406','M18 115 405','06R','M. G. Neuffer',date(1,5,2006)).
source(45,'Les11 NonExp/Les11 Exp??','M18 115 512','M18 115 517','06R','M. G. Neuffer',date(1,5,2006)).
source(46,'Les12 NonExp/Les12 Exp','M18 115 609','M18 115 610','06R','M. G. Neuffer',date(1,5,2006)).
source(47,'Les15 NonExp/Les15 Exp','M18 115 901','M18 115 9xx','06R','M. G. Neuffer',date(1,5,2006)).
source(48,'Les17 sib','M18 116 0xx','M18 116 0xy','06R','M. G. Neuffer',date(1,5,2006)).
source(49,'Les18 NonExp/Les18 Exp','M18 116 104','M18 116 102','06R','M. G. Neuffer',date(1,5,2006)).
source(50,'Les19 NonExp/Les19 Exp','M18 116 211','M18 116 206','06R','M. G. Neuffer',date(1,5,2006)).
source(51,'Les20 NonExp/Les20 Exp','M18 116 3xx','M18 116 3xx','06R','M. G. Neuffer',date(1,5,2006)).
source(52,'Les21 NonExp/Les21 Exp','M18 116 4xx','M18 116 4xx','06R','M. G. Neuffer',date(1,5,2006)).
source(53,lls1121D,'M18 116 6xx','M18 116 6xy','06R','M. G. Neuffer',date(1,5,2006)).



% from Gerry, new series of resuscitation attempts



source(125,'ll-264','46:321-2','46:321-2','09R','M. G. Neuffer',date(8,6,2009)).
source(126,'nec-490A','60:119-3','60:119-3','09R','M. G. Neuffer',date(8,6,2009)).
source(127,'nec-831A','29:1296-1','29:1296-1','09R','M. G. Neuffer',date(8,6,2009)).
source(128,'les-A853','45:347-7','45:347-7','09R','M. G. Neuffer',date(8,6,2009)).
source(129,'Spt-1320C','21:479-7','21:411.1-6 Phs','09R','M. G. Neuffer',date(8,6,2009)).
source(130,'Blh-1455','48:4.1-2','48:188-2','09R','M. G. Neuffer',date(8,6,2009)).
source(131,'nec-1521A','40:498-1','40:498-1','09R','M. G. Neuffer',date(8,6,2009)).
source(132,'nec-1613','41:701','41:715-4','09R','M. G. Neuffer',date(8,6,2009)).
source(133,'les-2240','44:F429-6N','44:429-1','09R','M. G. Neuffer',date(8,6,2009)).
source(134,'les-2274','46:290-2','46:290-2','09R','M. G. Neuffer',date(8,6,2009)).
source(135,'Les-2318','45:727','45:666-4','09R','M. G. Neuffer',date(8,6,2009)).
source(136,'les-2386','52:192-2','52:192-3','09R','M. G. Neuffer',date(8,6,2009)).
source(156,'les-2240','44:F429','44:429-S','09R','M. G. Neuffer',date(8,6,2009)).
source(157,'nec-490A','60:119-5','60:119-5','09R','M. G. Neuffer',date(8,6,2009)).







% from MGCSC


source(54,'220A','2005-103-1','107-1','06R','MGCSC',date(2,5,2006)).
source(55,'125A','93-793-3','778','06R','MGCSC',date(2,5,2006)).
source(56,'X28E','96-637-9','634-6','06R','MGCSC',date(2,5,2006)).
source(57,'227E','2005-129-8','108-11','06R','MGCSC',date(2,5,2006)).
source(58,'111H','95-6220-6','6209-6','06R','MGCSC',date(2,5,2006)).
source(59,'X27D','89-550-5','550-1','06R','MGCSC',date(2,5,2006)).
source(60,'U240A','94-1294-5','2698-5','06R','MGCSC',date(2,5,2006)).
source(61,'927D','2004-2949-10','2934-8','06R','MGCSC',date(2,5,2006)).
source(62,'716F','90-25-7','25-10','06R','MGCSC',date(2,5,2006)).
source(63,'217I','97-444-4','4735-1','06R','MGCSC',date(2,5,2006)).
source(64,'217J','97-4651-4','4659-11','06R','MGCSC',date(2,5,2006)).
source(65,'X27L','97-573-9','4662-9','06R','MGCSC',date(2,5,2006)).
source(66,'608D','97-4672-6','4689-11','06R','MGCSC',date(2,5,2006)).
source(67,'217K','97-4695-5','4692-3','06R','MGCSC',date(2,5,2006)).
source(68,'312B','97-573-5','4711-4','06R','MGCSC',date(2,5,2006)).
source(69,'217L','97-4695-1','4715-8','06R','MGCSC',date(2,5,2006)).
source(70,'217M','97-4696-2','4717-1','06R','MGCSC',date(2,5,2006)).
source(71,'111F','2003-2747-8','2765-9','06R','MGCSC',date(2,5,2006)).
source(72,'U840D','97-780-6','4661-3','06R','MGCSC',date(2,5,2006)).
source(73,'3908B','98G-24W01','5-1','06R','MGCSC',date(2,5,2006)).
source(74,'3908C','99-197-1','190-1','06R','MGCSC',date(2,5,2006)).
source(74,'3908C','99-197-1','190-1','09R','MGCSC',date(15,5,2009)).
source(75,'3908D','2004-2257-7','2004-2257-7','06R','MGCSC',date(2,5,2006)).
source(76,'3908E','2001-67-3','2001-67-3','06R','MGCSC',date(2,5,2006)).
source(77,'3908G','2002-2257-4','2002-2257-4','06R','MGCSC',date(2,5,2006)).
source(78,'3908H','2003-2209-4','2003-2209-4','06R','MGCSC',date(2,5,2006)).
source(78,'3908H','2003-2209-4','2003-2209-4','09R','MGCSC',date(15,5,2009)).
source(79,'3908I','2002-2258-3','2002-2258-3','06R','MGCSC',date(2,5,2006)).
source(80,'3908L','99-6055-5','99-6055-5','06R','MGCSC',date(2,5,2006)).
source(81,'3908N','2000-200-4','213-7','06R','MGCSC',date(2,5,2006)).
source(81,'3908N','2000-200-4','213-7','09R','MGCSC',date(15,5,2009)).
source(82,'3908O','2004-568-3','2004-568-3','06R','MGCSC',date(2,5,2006)).
source(83,'3908P','2004-260-2','2004-260-2','06R','MGCSC',date(2,5,2006)).
source(84,'3909B','2004-269-7','2004-269-7','06R','MGCSC',date(2,5,2006)).
source(85,'3909C','2004-278-10','270-1','06R','MGCSC',date(2,5,2006)).
source(86,'3909D','99-249-3','235-2','06R','MGCSC',date(2,5,2006)).
source(86,'3909D','99-249-3','235-2','09R','MGCSC',date(15,5,2009)).
source(87,'3909E','2004-2208-1','2004-2208-1','06R','MGCSC',date(2,5,2006)).
source(87,'3909E','2004-2208-1','2004-2208-1','09R','MGCSC',date(15,5,2009)).
source(88,'524B','94-3870-4','94-3870-4','06R','MGCSC',date(2,5,2006)).
source(89,'3909F','2005-130-6','114-3','06R','MGCSC',date(2,5,2006)).
source(89,'3909F','2005-130-6','114-3','09R','MGCSC',date(15,5,2009)).
source(90,'3909G','2003-2288-2','2003-2288-2','06R','MGCSC',date(2,5,2006)).
source(90,'3909G','2003-2288-2','2003-2288-2','09R','MGCSC',date(15,5,2009)).
source(91,'3909H','2003-201-11','237-1','06R','MGCSC',date(2,5,2006)).
source(92,'6007A','91-2060-5','91-2060-5','06R','MGCSC',date(2,5,2006)).
source(93,'6007C','94-4926-7','4927-1','06R','Mgcsc',date(2,5,2006)).
source(94,'6007D','2003-216-8','2003-216-8','06R','MGCSC',date(2,5,2006)).
source(95,'6007G','99-2237-4','99-2237-4','06R','MGCSC',date(2,5,2006)).
source(96,'217N','96W-234-4','96W-234-4','06R','MGCSC',date(2,5,2006)).
source(97,'218D','2002-278-4','2002-278-4','06R','MGCSC',date(2,5,2006)).
source(98,'218DA','2003-642-2','2003-642-2','06R','MGCSC',date(2,5,2006)).
source(99,'218DB','94-256-3','94-256-3','06R','MGCSC',date(2,5,2006)).
source(100,'802C','98P-31-7','98P-31-7','06R','MGCSC',date(2,5,2006)).
source(101,'130F','2001-681-1','2001-681-1','06R','MGCSC',date(2,5,2006)).
source(102,'808C','97-494-7','97-494-7','06R','MGCSC',date(2,5,2006)).
source(103,'128A','2005-40-3','2005-40-3','06R','MGCSC',date(2,5,2006)).
source(104,'X24B','89-2291-5','89-2291-5','06R','MGCSC',date(2,5,2006)).
source(105,'121DA','96-4786-8','96-4786-8','06R','MGCSC',date(2,5,2006)).
source(106,'121D','95W-80-2','95W-80-2','06R','MGCSC',date(2,5,2006)).
source(107,'521F','2003-2785-6','2003-2785-6','06R','MGCSC',date(2,5,2006)).
source(108,'602D','95-198-1','95-198-1','06R','MGCSC',date(2,5,2006)).
source(109,'332M','2005-2622-1','2616-4','06R','MGCSC',date(2,5,2006)).
source(110,'301C','98P-144-1','98P-144-1','06R','MGCSC',date(2,5,2006)).
source(111,'613D','97-1718-3','97-1718-3','06R','MGCSC',date(2,5,2006)).
source(112,'X10F','97-289-2','97-289-2','06R','MGCSC',date(2,5,2006)).



source(137,'6007E','1998-5369-1','1998-5369-1','09R','MGCSC',date(15,5,2009)).
source(139,'3909D','1999-225-1','235-7','09R','MGCSC',date(15,5,2009)).
source(140,'332M','2005-2597-1','2616-2','09R','MGCSC',date(15,5,2009)).

source(148,'3612C','1999-197-2','194-3','09R','MGCSC',date(10,6,2009)).
source(149,'6007B','2007-446-3','2007-446-3','09R','MGCSC',date(10,6,2009)).
source(150,'6007F','1995-1909-3','1995-1909-3','09R','MGCSC',date(10,6,2009)).
source(151,'3909J','2006-345-8','2006-345-8','09R','MGCSC',date(10,6,2009)).
source(152,'3811G','2000-2514-1','2000-2514-1','09R','MGCSC',date(10,6,2009)).
source(153,'120B','2005P-231-1','2005P-231-1','09R','MGCSC',date(10,6,2009)).
source(154,'4104O','2002-2194-2','2002-2194-2','09R','MGCSC',date(10,6,2009)).
source(155,'4102K','1998-4182-3','1998-4182-3','09R','MGCSC',date(10,6,2009)).



% from Guri Johal

source(113,'PO65-I39','','','07R','Guri Johal',date(1,5,2007)).
source(114,'Johal les23','','','07R','Guri Johal',date(1,5,2007)).
source(115,'PO45-A15','','','07R','Guri Johal',date(1,5,2007)).
source(116,'PO45-F103','','','07R','Guri Johal',date(1,5,2007)).
source(117,'PO65-21D','','','07R','Guri Johal',date(1,5,2007)).
source(118,'PO55-21C','','','07R','Guri Johal',date(1,5,2007)).
source(119,'PO45-F104','','','07R','Guri Johal',date(1,5,2007)).
source(120,'PO55-21B','','','07R','Guri Johal',date(1,5,2007)).


% from Guri Johal for 10r

source(158,'P09S HN-1750','','','10R','Guri Johal',date(2,6,2010)).
source(159,'P09S HN-1753','','','10R','Guri Johal',date(2,6,2010)).
source(160,'P09S HN-1769','','','10R','Guri Johal',date(2,6,2010)).
source(161,'P09S HN-1764','','','10R','Guri Johal',date(2,6,2010)).
source(162,'P09S HN-1791','','','10R','Guri Johal',date(2,6,2010)).
source(163,'P09S HN-1851','','','10R','Guri Johal',date(2,6,2010)).
source(164,'P09S HN-1795','','','10R','Guri Johal',date(2,6,2010)).
source(165,'P09S HN-1808','','','10R','Guri Johal',date(2,6,2010)).
source(166,'P09S HN-1813','','','10R','Guri Johal',date(2,6,2010)).
source(167,'P09S HN-1806','','','10R','Guri Johal',date(2,6,2010)).
source(168,'P09S HN-1853','','','10R','Guri Johal',date(2,6,2010)).
source(169,'P09S HN-1823','','','10R','Guri Johal',date(2,6,2010)).
source(170,'P09S HN-1834','','','10R','Guri Johal',date(2,6,2010)).
source(171,'P09S HN-1804','','','10R','Guri Johal',date(2,6,2010)).
source(172,'P09S HN-1820','','','10R','Guri Johal',date(2,6,2010)).
source(173,'P09S HN-1844','','','10R','Guri Johal',date(2,6,2010)).
source(174,'P09S HN-1858','','','10R','Guri Johal',date(2,6,2010)).
source(175,'P09S HN-1798','','','10R','Guri Johal',date(2,6,2010)).
source(176,'P09S HN-1800','','','10R','Guri Johal',date(2,6,2010)).
source(177,'HN-1456','P03S-1154','?','10R','Guri Johal',date(2,6,2010)).
source(178,'P09S HN-1868','','','10R','Guri Johal',date(2,6,2010)).
source(179,'P09S HN-1866','','','10R','Guri Johal',date(2,6,2010)).
source(180,'HN-1565','P03S-662','?','10R','Guri Johal',date(2,6,2010)).
source(181,'P09S HN-1860','','','10R','Guri Johal',date(2,6,2010)).
source(182,'P09S HN-1855','','','10R','Guri Johal',date(2,6,2010)).
source(183,'P08S I-21','','','10R','Guri Johal',date(2,6,2010)).
source(184,'P08S H-11','','','10R','Guri Johal',date(2,6,2010)).
source(185,'P08S F-3','','','10R','Guri Johal',date(2,6,2010)).
source(186,'P08S F-5','','','10R','Guri Johal',date(2,6,2010)).
source(187,'HN-2580','','','10R','Guri Johal',date(2,6,2010)).
source(188,'HN-2579','','','10R','Guri Johal',date(2,6,2010)).
source(189,'P10W-PR HN-40','P-44 #2','','10R','Guri Johal',date(2,6,2010)).






% from Damon Lisch

source(121,'mop1 tester','6415-3','6402-1','09R','Damon Lisch',date(15,5,2008)).
source(122,'mop1 Les*-mi1','6415-19','6402-2','09R','Damon Lisch',date(15,5,2008)).


% from Karen Cone, secretly, via Barb Sonderman, Miriam Hankins, and Pam Cooper

source(123,'McClintock full color stock Pl-Rhoades x W22','Karen Cone','','','08G',date(29,1,2009)).
source(124,'920021 x r-g W22/Stock1','','','08G','Karen Cone',date(29,1,2009)).



% from Ming Shu Huang in David Braun's lab at Penn State, while David was at PSU

source(138,'camo/+ in B73^6','','','09R','Ming Shu Cao',date(20,5,2008)).


% from Mike Gerau

source(141,'GD05062913','','','09R','Mike Gerau',date(5,6,2009)).
source(142,'D8-N1591','','','09R','Mike Gerau',date(5,6,2009)).
source(143,'D8-N1452','','','09R','Mike Gerau',date(5,6,2009)).
source(144,'GD05061611','','','09R','Mike Gerau',date(5,6,2009)).
source(145,'GD06005201','','','09R','Mike Gerau',date(5,6,2009)).
source(146,'GD05068201','','','09R','Mike Gerau',date(5,6,2009)).
source(147,'GD05068303','','','09R','Mike Gerau',date(5,6,2009)).




% from David Braun, U. of Missouri

source(190,'row 322','temporarily b198*','','10R','David Braun',date(31,7,2010)).
source(191,'row 324','temporarily b199*','','10R','David Braun',date(31,7,2010)).


% from Jim Birchler, U. of Missouri

source(192,'Idf B Pl','0711','0711 self','11R','Jim Birchler',date(21,3,2011)).
source(193,'Idf B Pl','0711','0711 sib','11R','Jim Birchler',date(21,3,2011)).








% from USDA station at Peoria, Illinois; date approximate

source(200,'Mo20W','PI 550442','PI 550442','06R','USDA Peoria, order 180215, accession PI 550442, lot 97ncai01, id 47848, Coe A3126',date(15,4,2006)).
source(300,'W23','NSL 30060','NSL 30060','06R','USDA Peoria, order 180215, accession NSL 30060, lot 96ncai01, id 64101, Coe A3127',date(15,4,2006)).
source(400,'M14','NSL 30867','NSL 30867','06R','USDA Peoria, order 180215, accession NSL 30867, lot 96ncai01, id 47821, Coe A3128',date(15,4,2006)).


% from Sherry; one NAM parent; sequenced

source(500,'B73','09FG0058','09FG0058','11R','Sherry Flint-Garcia',date(1,4,2011)).



% NAM founders from Sherry Flint-Garcia, U. of Missouri

source(194,'B97','09PR0001','09PR0001','11R','Sherry Flint-Garcia',date(1,4,2011)).
source(195,'CML103','09PR0002','09PR0002','11R','Sherry Flint-Garcia',date(1,4,2011)).
source(196,'CML288','09PR0003','09PR0003','11R','Sherry Flint-Garcia',date(1,4,2011)).
source(197,'CML247','09PR0006','09PR0006','11R','Sherry Flint-Garcia',date(1,4,2011)).
source(198,'CML277','09PR0008','09PR0008','11R','Sherry Flint-Garcia',date(1,4,2011)).
source(199,'CML322','09PR0009','09PR0009','11R','Sherry Flint-Garcia',date(1,4,2011)).
source(600,'CML333','09PR0010','09PR0010','11R','Sherry Flint-Garcia',date(1,4,2011)).
source(601,'CML52','09PR0011','09PR0011','11R','Sherry Flint-Garcia',date(1,4,2011)).
source(602,'CML69','09PR0014','09PR0014','11R','Sherry Flint-Garcia',date(1,4,2011)).
source(603,'HP301','09PR0015','09PR0015','11R','Sherry Flint-Garcia',date(1,4,2011)).
source(604,'IL144','09PR0016','09PR0016','11R','Sherry Flint-Garcia',date(1,4,2011)).
source(605,'Ki11','09PR0017','09PR0017','11R','Sherry Flint-Garcia',date(1,4,2011)).
source(606,'Ki3','09PR0018','09PR0018','11R','Sherry Flint-Garcia',date(1,4,2011)).
source(607,'Ki21','09PR0019','09PR0019','11R','Sherry Flint-Garcia',date(1,4,2011)).
source(608,'M162W','09PR0020','09PR0020','11R','Sherry Flint-Garcia',date(1,4,2011)).
source(609,'M37W','09PR0021','09PR0021','11R','Sherry Flint-Garcia',date(1,4,2011)).
source(610,'Mo17','09PR0022','09PR0022','11R','Sherry Flint-Garcia',date(1,4,2011)).
%
% this one must be planted at low density, one cl/2ft!
%
source(611,'Mo18W','09PR0023','09PR0023','11R','Sherry Flint-Garcia',date(1,4,2011)).
%
source(612,'MS71','09PR0026','09PR0026','11R','Sherry Flint-Garcia',date(1,4,2011)).
source(613,'NC350','09PR0027','09PR0027','11R','Sherry Flint-Garcia',date(1,4,2011)).
source(614,'NC358','09PR0028','09PR0028','11R','Sherry Flint-Garcia',date(1,4,2011)).
source(615,'Oh43','09PR0029','09PR0029','11R','Sherry Flint-Garcia',date(1,4,2011)).
source(616,'Oh78','09PR0030','09PR0030','11R','Sherry Flint-Garcia',date(1,4,2011)).
source(617,'P39','09PR0031','09PR0031','11R','Sherry Flint-Garcia',date(1,4,2011)).
source(618,'Tx303','09PR0032','09PR0032','11R','Sherry Flint-Garcia',date(1,4,2011)).
source(619,'TZi8','09PR0033','09PR0033','11R','Sherry Flint-Garcia',date(1,4,2011)).
%
% full packet note is W22R-r: Standard (Brink)
%
source(620,'W22R-r: Standard (Brink)','09PR0036','09PR0036','11R','Sherry Flint-Garcia',date(1,4,2011)).



% from Alice Barkan''s group, the uniform Mu lines

source(621,'L421-2','GRMZM2G157354_T03','GRMZM2G157354_T03','11R','Alice Barkan and Karen Koch',date(15,4,2011)).
source(622,'L522-10','new necrotic seedling','new necrotic seedling','11R','Alice Barkan and Karen Koch',date(15,4,2011)).



% from Chi-Ren Shyu, for Jason Green, but really from Guri Johal, for 11r

source(623,'P10S 2645','P10S 2645','aka CR1','11R','Guri Johal via Chi-Ren Shyu',date(1,6,2011)).
source(624,'P10S 2689','P10S 2689','aka CR2','11R','Guri Johal via Chi-Ren Shyu',date(1,6,2011)).
source(625,'P10S 2644','P10S 2644','aka CR3','11R','Guri Johal via Chi-Ren Shyu',date(1,6,2011)).
source(626,'P10S 2661','P10S 2661','aka CR4','11R','Guri Johal via Chi-Ren Shyu',date(1,6,2011)).
source(627,'P10S 2669','P10S 2669','aka CR5','11R','Guri Johal via Chi-Ren Shyu',date(1,6,2011)).



% from Frank Bauer in David Braun''s lab:  Frank noticed some unusual "lesion mimics"
% in a couple of their B73 lines.  It looks more like csp or cpc to me ---
% the patches are white, hmm, but not clear --- but there is a light oscillation with green
% tissue in the middle.  Also, the inner ellipse is off-axis relative
% to the major axis of the outer ellipse.
%
% They crossed it to B73 and I crossed one to Mo20W since that''s what
% I had.
%
% Kazic, 8.8.2011


source(628,'C54605','C54605','white, off-axis oscillatory elliptical lesions','11R','Frank Baker and David Braun',date(7,8,2011)).





% 12r

% These are interesting mutants from Frank Baker and David Braun''s field.  They were crossed into the Braun B73 stock
% since that was what was available at the time.  These are EMS mutagenized, as I recall.  The rowplant numbers are the 
% Braun rows, obviously.
%
% Kazic, 26.3.2014

% source(630,'B73','12R:B133415','possible lesion mimic; EMS?','12R','Frank Baker and David Braun',date(29,7,2012)).
% source(631,'B73','12R:B133204','possible lesion mimic; EMS?','12R','Frank Baker and David Braun',date(29,7,2012)).





source(642,'B73','12R0642:0132014','ij-like; EMS?','12R','Frank Baker and David Braun',date(29,7,2012)).
source(643,'B73','12R0643:0132211','unknown; EMS?','12R','Frank Baker and David Braun',date(29,7,2012)).
source(644,'B73','12R0644:0132303','unknown; EMS?','12R','Frank Baker and David Braun',date(29,7,2012)).
source(645,'B73','12R0645:0132309','unknown; EMS?','12R','Frank Baker and David Braun',date(29,7,2012)).
source(646,'B73','12R0646:0132313','unknown; EMS?','12R','Frank Baker and David Braun',date(29,7,2012)).
source(647,'B73','12R0647:0133203','unknown; EMS?','12R','Frank Baker and David Braun',date(29,7,2012)).
source(648,'B73','12R0648:0133407','oscillating large white/light green chloroses; EMS?','12R','Frank Baker and David Braun',date(29,7,2012)).
source(649,'B73','12R0649:0133414','oscillating large white/light green chloroses; EMS?','12R','Frank Baker and David Braun',date(29,7,2012)).
source(650,'B73','12R0650:0133416','oscillating large white/light green chloroses; EMS?','12R','Frank Baker and David Braun',date(29,7,2012)).
source(651,'B73','12R0651:0133509','large yellow/green interveinal streaks, possible diurnal striping; EMS?','12R','Frank Baker and David Braun',date(29,7,2012)).
source(652,'B73','12R0652:0133511','large yellow/green interveinal streaks, possible diurnal striping; EMS?','12R','Frank Baker and David Braun',date(29,7,2012)).
source(653,'B73','12R0653:0133513','large yellow/green interveinal streaks, possible diurnal striping; EMS?','12R','Frank Baker and David Braun',date(29,7,2012)).
source(654,'B73','12R0654:0134713','diffuse white necroses; EMS?','12R','Frank Baker and David Braun',date(29,7,2012)).
source(665,'B73','12R0665:0133415','possible lesion mimic; EMS?','12R','Frank Baker and David Braun',date(29,7,2012)).
source(666,'B73','12R0666:0133204','possible lesion mimic; EMS?','12R','Frank Baker and David Braun',date(29,7,2012)).



% from Peter Balint-Kurti, April 2015:  interesting lines he thinks I''ll enjoy

source(667,'15R0667:0000000','FL14-15 R1-1','B73 NIL-1002/les*-R1-1','15R','Peter Balint-Kurti',date(15,4,2015)).
source(668,'15R0668:0000000','FL14-15 R2-1','B73 NIL-1002/les*-R2-1','15R','Peter Balint-Kurti',date(15,4,2015)).
source(669,'15R0669:0000000','FL14-15 R3-1','B73 NIL-1007/les*-R3-1','15R','Peter Balint-Kurti',date(15,4,2015)).
source(670,'15R0670:0000000','FL14-15 R4-1','B73 NIL-1007/les*-R4-1','15R','Peter Balint-Kurti',date(15,4,2015)).
source(671,'15R0671:0000000','FL14-15 R5-1','B73 NIL-1103/les*-R5-1','15R','Peter Balint-Kurti',date(15,4,2015)).
source(672,'15R0672:0000000','FL14-15 R6-1','B73 NIL-1104/les*-R6-1','15R','Peter Balint-Kurti',date(15,4,2015)).
source(673,'15R0673:0000000','FL14-15 R7-2','B73 NIL-1020B/les*-R7-2','15R','Peter Balint-Kurti',date(15,4,2015)).
source(674,'15R0674:0000000','FL14-15 R8-2','B73 NIL-1004/les*-R8-2','15R','Peter Balint-Kurti',date(15,4,2015)).
source(675,'15R0675:0000000','FL14-15 R9-2','B73 NIL-1304/les*-R9-2','15R','Peter Balint-Kurti',date(15,4,2015)).
source(676,'15R0676:0000000','FL14-15 R10-2','B73 NIL-1337/les*-R10-2','15R','Peter Balint-Kurti',date(15,4,2015)).
source(677,'15R0677:0000000','FL14-15 R11-2','B73 NIL-1337/les*-R11-2','15R','Peter Balint-Kurti',date(15,4,2015)).
source(678,'15R0678:0000000','FL14-15 R168-1','Oh7B F2/les*-R168-1','15R','Peter Balint-Kurti',date(15,4,2015)).
source(679,'15R0679:0000000','FL14-15 R168-2','Oh7B F2/les*-R168-2','15R','Peter Balint-Kurti',date(15,4,2015)).
source(680,'15R0680:0000000','FL14-15 R169-1','Oh7B F2/les*-R169-1','15R','Peter Balint-Kurti',date(15,4,2015)).
source(681,'15R0681:0000000','FL14-15 R170-1','les*-R170-1','15R','Peter Balint-Kurti',date(15,4,2015)).
source(682,'15R0682:0000000','FL14-15 R171-1','les*-R171-1','15R','Peter Balint-Kurti',date(15,4,2015)).
source(683,'15R0683:0000000','FL14-15 R171-3','les*-R171-3','15R','Peter Balint-Kurti',date(15,4,2015)).
source(684,'15R0684:0000000','FL14-15 R172-1','les*-R172-1','15R','Peter Balint-Kurti',date(15,4,2015)).




% from Marty Sachs of MGCSC:  new versions of Les5 and Les20.  
% Separately accessioned since there''s no guarantee they''re the same as the previous ones.
%
% May, 2015


source(685,'15R0685:0000000','111H','les5','15R','MGCSC',date(15,5,2015)).
source(686,'15R0686:0000000','111F','Les20','15R','MGCSC',date(15,5,2015)).



% Candy Gardner doubled haploid lines for 16r

source(687,'16R0687:0000000','15SGEM:BGEM:13397','(ALTIPLANO BOV903/PHZ51)/PHZ51','#002-(2n)-003-001-001-B','Candy Gardner',date(2,6,2016)).
source(688,'16R0688:0000000','14SGEM:BGEM:17314','(ANCASHINO ANC102/PHB47)/PHB47','#002-(2n)-001-002-B','Candy Gardner',date(2,6,2016)).
source(689,'16R0689:0000000','14SGEM:BGEM:12345','(BOFO DGO123/PHB47)/PHB47','#002-(2n)-003-001-B','Candy Gardner',date(2,6,2016)).
source(690,'16R0690:0000000','14SGEM:BGEM:19336','(CON NORT ZAC161/PHB47)/PHB47','#005-(2n)-001-001-B','Candy Gardner',date(2,6,2016)).
source(691,'16R0691:0000000','14SGEM:BGEM:08337','(CRISTALINO AMAR AR21004/PHB47)/PHB47','#001-(2n)-002-001-B','Candy Gardner',date(2,6,2016)).
source(692,'16R0692:0000000','14SGEM:BGEM:04349','(CRISTALINO AMAR AR21004/PHB47)/PHB47','#005-(2n)-003-001-B','Candy Gardner',date(2,6,2016)).
source(693,'16R0693:0000000','14SGEM:BGEM:08361','(CUZCO CUZ217/PHZ51)/PHZ51','#002-(2n)-001-001-B','Candy Gardner',date(2,6,2016)).
source(694,'16R0694:0000000','14SGEM:BGEM:13350','(ONAVENO SON24/PHB47)/PHB47','#004-(2n)-001-001-B','Candy Gardner',date(2,6,2016)).
source(695,'16R0695:0000000','14SGEM:BGEM:25341','(PATILLO GRANDE BOV649/PHZ51)/PHZ51','#006-(2n)-003-001-B','Candy Gardner',date(2,6,2016)).
source(696,'16R0696:0000000','14SGEM:BGEM:11338','(PATILLO GRANDE BOV649/PHB47)/PHB47','#006-(2n)-001-001-B','Candy Gardner',date(2,6,2016)).
source(697,'16R0697:0000000','14SGEM:BGEM:08313','BR105:N(PHZ51)(PHZ51)-(2n)-003-001-B','','Candy Gardner',date(2,6,2016)).
source(698,'16R0698:0000000','14SGEM:BGEM:15346','((Tehua - CHS29/PHB47 B)/PHB47)-(2n)-003-001-B','','Candy Gardner',date(2,6,2016)).
source(699,'16R0699:0000000','15SGEM:BGEM:14378','(YUCATAN TOL389 ICA/PHZ51)/PHZ51','#005-(2n)-002-001-001-B','Candy Gardner',date(2,6,2016)).
source(700,'16R0700:0000000','13SGEM:06-N3:4962','(YUNGUENO BOV362/PHZ51)/PHZ51','#005-(2n)-002','Candy Gardner',date(2,6,2016)).
source(701,'16R0701:0000000','14SGEM:BGEM:06313','(YUNGUENO BOV362/PHZ51)/PHZ51','#006-(2n)-002-001-B','Candy Gardner',date(2,6,2016)).
source(702,'16R0702:0000000','14SGEM:BGEM:23344','((Cateto Nortista - GIN I/PHB47 B)/PHB47)-(2n)-002-001-B','','Candy Gardner',date(2,6,2016)).







% elite lines from Matt Boyer or Chris Browne

source(890,'16R890:L0xxxxxx','16R890:L0xxxxxx','16R890:L0xxxxxx','16R','unknown MFA elite',date(1,5,2016)).
source(891,'17R891:L0xxxxxx','17R891:L0xxxxxx','17R891:L0xxxxxx','17R','MFA elite',date(1,5,2017)).


    

% popcorn lines


source(992,'07R992:P0mawhyl','07R992:P0mawhyl','07R992:P0mawhyl','07R','yellow/white, pointed kernel strawberry popcorn bought by Bill from Whole Foods, Amherst',date(30,11,2007)).
source(993,'07R993:P0madkpu','07R993:P0madkpu','07R993:P0madkpu','07R','dark purple/blue-black, pointed kernel strawberry popcorn bought by Bill from Whole Foods, Amherst',date(30,11,2007)).
source(994,'07R994:P0modkpi','07R994:P0modkpi','07R994:P0modkpi','07R','slightly darker light pink, flat kernel strawberry popcorn from ear picked up by Bill at Bradford in fall, 2006',date(15,10,2007)).
source(995,'07R995:P0moltpi','07R995:P0moltpi','07R995:P0moltpi','07R','very light pink, flat kernel strawberry popcorn from ear picked up by Bill at Bradford in fall, 2006',date(15,10,2007)).
source(996,'07R996:P0moclwh','07R996:P0moclwh','07R996:P0moclwh','07R','open-pollinated nearly clearish white, flat kernel strawberry popcorn from ear picked up by Bill at Bradford in fall, 2006',date(15,10,2007)).
source(997,'07R997:P0molryl','07R997:P0molryl','07R997:P0molryl','07R','open-pollinated light red/yellow, flat kernel strawberry popcorn from ear picked up by Bill at Bradford in fall, 2006',date(15,10,2007)).
source(998,'07R998:P0momdpu','07R998:P0momdpu','07R998:P0momdpu','07R','open-pollinated purple, flat kernel strawberry popcorn from ear picked up by Bill at Bradford in fall, 2006',date(15,10,2007)).
source(999,'07R999:P0molrpi','07R999:P0molrpi','07R999:P0molrpi','07R','open-pollinated light red/pinkish kernel, flat strawberry popcorn from ear picked up by Bill at Bradford in fall, 2006',date(15,10,2007)).


% new popcorn lines will run between 900 and 989
%
% Kazic, 28.4.2010


source(911,'10R911:P0000000','10R911:P0000000','10R911:P0000000','10R','Weiler ear 1, from Mrs. Weiler of Weiler Dairy, bought in the farmers market',date(15,10,2009)).
source(912,'10R912:P0000000','10R912:P0000000','10R912:P0000000','10R','Weiler ear 1, from Mrs. Weiler of Weiler Dairy, bought in the farmers market',date(15,10,2009)).
source(913,'10R913:P0000000','10R913:P0000000','10R913:P0000000','10R','Weiler ear 2, from Mrs. Weiler of Weiler Dairy, bought in the farmers market',date(15,10,2009)).
source(914,'10R914:P0000000','10R914:P0000000','10R914:P0000000','10R','Weiler ear 3, from Mrs. Weiler of Weiler Dairy, bought in the farmers market',date(15,10,2009)).





% sweet corn; purchased as needed


source(892,'11R892:E0serend','11R892:E0serend','11R892:E0serend','11R','serendipity, Rogers/Syngenta bicolor triple sweet, 82 days, from little Westlake',date(6,5,2011)).
source(893,'08R893:E0earsun','08R893:E0earsun','08R893:E0earsun','07R','early sunglow, 63--68 days, from Lilly Miller',date(22,5,2008)).
source(894,'08R894:E0goljub','08R894:E0goljub','08R894:E0goljub','07R','golden jubilee, 87 days, from Lilly Miller',date(22,5,2008)).
source(895,'08R895:E0cogent','08R895:E0cogent','08R895:E0cogent','07R','country gentleman, 92 days, from Ferry-Morse heirloom',date(22,5,2008)).
source(896,'08R896:E0kankrn','08R896:E0kankrn','08R896:E0kankrn','07R','kandy korn, 85--89 days, from Lake Valley',date(22,5,2008)).
source(897,'08R897:E0silqun','08R897:E0silqun','08R897:E0silqun','07R','silver queen, 88 days, from Wilson''s, fungicide',date(22,5,2008)).
source(898,'08R898:E0bodcus','08R898:E0bodcus','08R898:E0bodcus','07R','bodacious, 75--90 days, from Wilson''s, fungicide',date(22,5,2008)).
source(899,'08R899:E0bnjour','08R899:E0bnjour','08R899:E0bnjour','07R','bon jour, bicolor, 70 days,  from Renee''s Garden',date(22,5,2008)).
source(990,'08R990:E0casino','08R990:E0casino','08R990:E0casino','07R','casino, 70 days, from Renee''s Garden',date(1,4,2008)).
source(991,'08R991:E0golban','08R991:E0golban','08R991:E0golban','07R','Burpee''s golden bantam, 70--80 days, from Burpee',date(1,4,2008)).
