% this is ../c/maize/demeter/data/genotype.pl
%
% cleaned by clean_data:clean_data/4 on 16.4.2008
%
% Kazic, 16.4.2008
%
% extensive manual cleaning and checking
%
% Kazic, 8.5.2008



% for the recessives, all of these genotypes so far are merely notional
%
% notational rules:  if a parental component is homozygous, then that genotype
% is shown only once
%
% if Gerry or the MGCSC show a marker only once, it is assumed to be homozygous over all
% positions
%
% parentheses around a genotype from Gerry and the MGCSC are 100% correlated with a "self" notation,
% so I assume this is just redundant indication of the selfing, not an indication of ambiguity in
% the genotype.
%
% For the selfs, the calculated notional genotype takes the indicated genotype of the parents at face
% value, and assumes the latter are not ambiguous.  What is shown is the OUTPUT phenotype, not the inputs!





%%%%%%%%%%%%% notational conventions %%%%%%%%%%%%%
%
% Well, I am not altogether sure what the previous two sentences mean, 
% now six years later (12.12.2012).  Now that I am selfing and test-crossing
% dominants, I decided I needed to work through all the cases systematically.
% Here is what I did for 12N onwards, starting with family 3617 ff.
%
%    
% The genotypes recorded here are of two kinds.  The first is the genotype of 
% a family as a whole, after a cross but before any needed test-crosses.  The second
% is of an individual family member whose genotype is known.  Both are output 
% genotypes.  The notational problem comes because I have four positions for what
% are really two data for a single mutant.  So what should the extra arguments be?
%
% In principle, as I have done in working through the cases, that argument should be
% empty --- here indicated by a ".".  But this is visually and computationally
% awkward --- and won''t help at all when constructing double mutants.  So what is
% recorded is denoted here as the "re-written genotype".
%
% Usually, since we mainly work with dominants, the family and individual
% plant''s genotypes will be the same.  Similarly,
% the recessives that show phenotype are therefore homozygous; the ones that don''t
% are either heterozygous or wild-type.  
%
% Most of the confusion comes when representing selves of heterozygotes:  am I 
% recording the parents or the offspring?  The answer is, it depends on what I know
% about the family or plant.  This changes over time with more data, and so I go
% back and revise the genotype as needed.
%
% The facts give either the re-written, confirmed genotypes of individual plants
% OR the population of genotypes in the family, prior to confirming the genotypes
% of individual plants by any needed selfing or test-crosses.
%
% In principle I should distinguish the two types of genotype explictly, but I 
% don''t because in practice if I have an alternative at a position, then it is the
% genotype of the entire family, not yet that of the particular individual (which
% gets resolved only later).
%
% 
%
% So here are the five cases, letting L represent any mutant, dominant or recessive,
% and "." represent the true value of that argument BEFORE re-writing the output
% genotype of that family or plant.  By "observed mutants", I mean the genotype of
% mutants BEFORE resolution by test-crosses.  The resolved genotype is then the
% "parental genotype" of that particular individual.
%
%
% (1) +/+ x +/L      (only happens with dominants)
% (2) +/L x +/L      (happens with dominants and recessives)
% (3) +/+ x L/L                    ditto
% (4) +/L x L/L                    ditto
% (5) L/L x L/L                    ditto
%
%
%
%
% case 1:  +/+ x +/L
%
%       +        L   male
% f  +  +/+     +/L
% e  +  +/+     +/L
% m
%
% offspring classes:      +/+        +/L
% parental gametes:   +,+,+,+      +,+,+,L
%
% true population:         .,+,.,{+|L}
% observed mutants:        .,+,.,L
% confirmed mutants:       .,+,.,L
% re-written mutants:      +,+,+,L            ======>  +/L
%
%
%
% case 2:  +/L x +/L
%
%       +        L   male
% f  +  +/+     +/L
% e  L  L/+     L/L
% m
%
% offspring classes:      +/+         L/+            +/L           L/L        
% parental gametes:     +,+,+,+      +,L,+,+       +,+,+,L       +,L,+,L
%    
% true population:         .,{+|L},.,{+|L}
% observed mutants:        .,{+|L},.,L
% confirmed mutants:       .,+,.,L  or  .,L,.,L
% re-written mutants:      +,+,+,L  or  +,L,+,L
%
%                          ===> +/L         =====> L/L
%
% nb:  for the benefit of the computer, confirmed +,L,+,+ offspring are
% written as +,+,+,L.  This does a little violence to the maternal line but
% lets all code pluck out the mutation nicely.  From now on, insert a note in
% the file when this is done.  I hadn''t envisioned this cross when I wrote the
% code!
%
%
%
%
% case 3:  +/+ x L/L
%
%       L        L   male
% f  +  +/L     +/L
% e  +  +/L     +/L
% m
%
% offspring classes:        +/L         
% parental gametes:        +,+,L,L 
%
% true population:         .,+,.,L
% observed mutants:        .,+,.,L
% confirmed mutants:       .,+,.,L 
% re-written mutants:      +,+,+,L  =======> +/L
%
%
%
%
% case 4:  +/L x L/L
%
%       L        L   male
% f  +  +/L     +/L
% e  L  L/L     L/L
% m
%
% offspring classes:          +/L          L/L       
% parental gametes:         +,+,L,L      +,L,L,L   
%    
% true population:         .,{L|+},.,L
% observed mutants:        .,{L|+},.,L
% confirmed mutants:       .,+,.,L  or  .,L,.,L
% re-written mutants:      +,+,+,L  or  +,L,+,L
%                         ====> +/L      ====>  L/L
%
%
% case 5:  L/L x L/L
%
%       L        L   male
% f  L  L/L     L/L
% e  L  L/L     L/L
% m
%
% offspring classes:        L/L       
% parental gametes:        L,L,L,L   
%    
% true population:         .,L,.,L
% observed mutants:        .,L,.,L
% confirmed mutants:       .,L,.,L
% re-written mutants:      +,L,+,L   ====> L/L
%
%
%
% Notice that only the population has alternation of markers!!!!  For the dominants,
% any family worthy to have its genotype recorded here is by definition a mutant.
% It''s important to remember that the genotype of selfed dominants isn''t known until
% the test-crosses are examined:  the offspring could be homozygous or heterozygous
% (or wild-type, of course).  So it makes sense to have at least one position with alternates; 
% but we know for sure that one of the four positions has the mutation, by convention
% the last argument of the genotype.
%
% For most crosses, a line will be a heterozygous mutant and obvious.   But as we
% start the test-crosses for selfed dominant mutants, it gets a little trickier, 
% because now we have to distinguish cases 2 and 5.
%
%
% In summary, 
%
% heterozygotes     +/L
% family genotypes  .,+,.,{+|L} or .,{+|L},.,{+|L} or .,{L|+},.,L or .,+,.,L
% confirmed         +,+,+,L
%
% homozygotes       L/L
% family genotypes  .,{+|L},.,{+|L} or .,{L|+},.,L or .,L,.,L
% confirmed         +,L,+,L.
%
% Fortunately, there''s no ambiguity in the notation of the confirmed genotypes, and the
% ambiguities in the two family genotypes (.,{+|L},.,{+|L} and .,{L|+},.,L) are really there
% and require confirmation.
%
% Kazic, 18.12.2012



% see ../archival/old_genotype.pl for the genotype/10 facts; first 29 families are missing from that file but
% can be trivially reconstructed from this one if needed.



% genotype/11

% genotype(Family,MaFam,MaNumGtype,PaFam,PaNumGtype,MaGMa,MaGPa,PaGMa,PaGPa,GeneticFeaturesOfGreatestInterest,KNumber).


% genotype of ``line'' that represents a skipped row; add a new fact for each crop
%
% Kazic, 23.7.2011
%
% no, just keep using this 06R dummy
%
% Kazic, 25.5.2018
    
genotype(0000,0000,'06R0000:0000000',0000,'06R0000:0000000','','','','',[''],'').


% and in the grand tradition of the IUPAC-IUBMB Enzyme Nomenclature Committee,
% a family for a plant for which we have no genetic data, was unsuccessful in
% pollinations, but for which we collected some data, usually images: 9999.  Notably,
% this occurred in 12r.
%
%
% the founder is presumed to be in 06R, though this is terribly arbitrary
%
%
% Kazic, 25.5.2018

genotype(9999,9999,'06R9999:0000000',9999,'06R9999:0000000','?','?','?','?',['?'],'K99999').












    

% genotypes of donated lines checked; all correct
%
% Kazic, 17.12.2009


%%%%%%%%%%%% corrections based on manual tracking through rows


% family 1109 is really family 1155, 06n row 40 = 06R200:S00I1911 x 06R0076:0007616, Mo20W x (+/Les-1450)^2
%
% genotype(2933,201,'06N201:S0013805',1109,'06N1109:0004004','Mo20W','Mo20W','+/Les*-N1450','+/Les*-N1450','K7616').
% genotype(2934,301,'06N301:W0032609',1109,'06N1109:0004004','W23','W23','Mo20W/(+/Les*-N1450)','+/Les*-N1450','K7616').
% genotype(2935,401,'06N401:M0013003',1109,'06N1109:0004004','M14','M14','Mo20W','Mo20W','+/Les*-N1450','+/Les*-N1450','K7616').
%
% Kazic, 17.4.08

genotype(2933,201,'06N201:S0013805',1155,'06N1155:0004004','Mo20W','Mo20W','Mo20W','+/Les*-N1450',['Les*-N1450'],'K7616').
genotype(2934,301,'06N301:W0032609',1155,'06N1155:0004004','W23','W23','Mo20W','+/Les*-N1450',['Les*-N1450'],'K7616').
genotype(2935,401,'06N401:M0013003',1155,'06N1155:0004004','M14','M14','Mo20W','+/Les*-N1450',['Les*-N1450'],'K7616').


% family 1434 is really 1159, 06N row 192 is 06R300:W00I4214 x 06R0084:0008414, W23 x (+/Les*-N2397)^2
%
% Kazic, 17.4.08
%
%
% genotype(2936,201,'06N201:S0013711',1434,'06N1434:0019212','Mo20W','Mo20W','W23','W23','+/Les*-N2397','+/Les*-N2397','K8414').
% genotype(2937,301,'06N301:W0010811',1434,'06N1434:0019212','W23','W23','W23','W23','+/Les*-N2397','+/Les*-N2397','K8414').
% genotype(2938,401,'06N401:M0011806',1434,'06N1434:0019212','M14','M14','W23','W23','+/Les*-N2397','+/Les*-N2397','K8414').
% genotype(2939,201,'06N201:S0007701',1434,'06N1434:0019209','Mo20W','Mo20W','W23','W23','+/Les*-N2397','+/Les*-N2397','K8414').
% genotype(2940,301,'06N301:W0010806',1434,'06N1434:0019209','W23','W23','W23','W23','+/Les*-N2397','+/Les*-N2397','K8414').
% genotype(2941,201,'06N201:S0013804',1434,'06N1434:0019207','Mo20W','Mo20W','W23','W23','+/Les*-N2397','+/Les*-N2397','K8414').
% genotype(2942,301,'06N301:W0010509',1434,'06N1434:0019207','W23','W23','W23','W23','+/Les*-N2397','+/Les*-N2397','K8414').
% genotype(2943,301,'06N301:W0009904',1434,'06N1434:0019207','W23','W23','W23','W23','+/Les*-N2397','+/Les*-N2397','K8414').
% genotype(2944,401,'06N401:M0011909',1434,'06N1434:0019207','M14','M14','W23','W23','+/Les*-N2397','+/Les*-N2397','K8414').
% genotype(2945,201,'06N201:S0013807',1434,'06N1434:0019206','Mo20W','Mo20W','W23','W23','+/Les*-N2397','+/Les*-N2397','K8414').
% genotype(2946,301,'06N301:W0010804',1434,'06N1434:0019206','W23','W23','W23','W23','+/Les*-N2397','+/Les*-N2397','K8414').
% genotype(2947,401,'06N401:M0012201',1434,'06N1434:0019206','M14','M14','W23','W23','+/Les*-N2397','+/Les*-N2397','K8414').
% genotype(2948,301,'06N301:W0010802',1434,'06N1434:0019205','W23','W23','W23','W23','+/Les*-N2397','+/Les*-N2397','K8414').
% genotype(2949,401,'06N401:M0012202',1434,'06N1434:0019205','M14','M14','W23','W23','+/Les*-N2397','+/Les*-N2397','K8414').
% genotype(2950,201,'06N201:S0013808',1434,'06N1434:0019204','Mo20W','Mo20W','W23','W23','+/Les*-N2397','+/Les*-N2397','K8414').
% genotype(2951,301,'06N301:W0036307',1434,'06N1434:0019204','W23','W23','W23','W23','+/Les*-N2397','+/Les*-N2397','K8414').
% genotype(2952,301,'06N301:W0010501',1434,'06N1434:0019204','W23','W23','W23','W23','+/Les*-N2397','+/Les*-N2397','K8414').
% genotype(2953,401,'06N401:M0012306',1434,'06N1434:0019204','M14','M14','W23','W23','+/Les*-N2397','+/Les*-N2397','K8414').
% genotype(2954,301,'06N301:W0010203',1434,'06N1434:0019203','W23','W23','W23','W23','+/Les*-N2397','+/Les*-N2397','K8414').
% genotype(2955,201,'06N201:S0014305',1434,'06N1434:0019201','Mo20W','Mo20W','W23','W23','+/Les*-N2397','+/Les*-N2397','K8414').
% genotype(2956,301,'06N301:W0009312',1434,'06N1434:0019201','W23','W23','W23','W23','+/Les*-N2397','+/Les*-N2397','K8414').
% genotype(2957,301,'06N301:W0010503',1434,'06N1434:0019201','W23','W23','W23','W23','+/Les*-N2397','+/Les*-N2397','K8414').
% genotype(2958,301,'06N301:W0036508',1434,'06N1434:0019201','W23','W23','W23','W23','+/Les*-N2397','+/Les*-N2397','K8414').
% genotype(2959,401,'06N401:M0013005',1434,'06N1434:0019201','M14','M14','W23','W23','+/Les*-N2397','+/Les*-N2397','K8414').


% these are written out further on, found by clean_data:check_family_assignments/1
%
% have commented these out as I believe that was the intention
%
% Kazic, 27.4.2010
%
% genotype(2936,201,'06N201:S0013711',1159,'06N1434:0019212','Mo20W','Mo20W','W23/{+|Les*-N2397}','W23/{+|Les*-N2397}',['Les*-N2397'],'K8414').
% genotype(2937,301,'06N301:W0010811',1159,'06N1434:0019212','W23','W23','W23/{+|Les*-N2397}','W23/{+|Les*-N2397}',['Les*-N2397'],'K8414').
% genotype(2938,401,'06N401:M0011806',1159,'06N1434:0019212','M14','M14','W23/{+|Les*-N2397}','W23/{+|Les*-N2397}',['Les*-N2397'],'K8414').
% genotype(2939,201,'06N201:S0007701',1159,'06N1434:0019209','Mo20W','Mo20W','W23/{+|Les*-N2397}','W23/{+|Les*-N2397}',['Les*-N2397'],'K8414').
% genotype(2940,301,'06N301:W0010806',1159,'06N1434:0019209','W23','W23','W23/{+|Les*-N2397}','W23/{+|Les*-N2397}',['Les*-N2397'],'K8414').
% genotype(2941,201,'06N201:S0013804',1159,'06N1434:0019207','Mo20W','Mo20W','W23/{+|Les*-N2397}','W23/{+|Les*-N2397}',['Les*-N2397'],'K8414').
% genotype(2942,301,'06N301:W0010509',1159,'06N1434:0019207','W23','W23','W23/{+|Les*-N2397}','W23/{+|Les*-N2397}',['Les*-N2397'],'K8414').
% genotype(2943,301,'06N301:W0009904',1159,'06N1434:0019207','W23','W23','W23/{+|Les*-N2397}','W23/{+|Les*-N2397}',['Les*-N2397'],'K8414').
% genotype(2944,401,'06N401:M0011909',1159,'06N1434:0019207','M14','M14','W23/{+|Les*-N2397}','W23/{+|Les*-N2397}',['Les*-N2397'],'K8414').
% genotype(2945,201,'06N201:S0013807',1159,'06N1434:0019206','Mo20W','Mo20W','W23/{+|Les*-N2397}','W23/{+|Les*-N2397}',['Les*-N2397'],'K8414').
% genotype(2946,301,'06N301:W0010804',1159,'06N1434:0019206','W23','W23','W23/{+|Les*-N2397}','W23/{+|Les*-N2397}',['Les*-N2397'],'K8414').
% genotype(2947,401,'06N401:M0012201',1159,'06N1434:0019206','M14','M14','W23/{+|Les*-N2397}','W23/{+|Les*-N2397}',['Les*-N2397'],'K8414').
% genotype(2948,301,'06N301:W0010802',1159,'06N1434:0019205','W23','W23','W23/{+|Les*-N2397}','W23/{+|Les*-N2397}',['Les*-N2397'],'K8414').
% genotype(2949,401,'06N401:M0012202',1159,'06N1434:0019205','M14','M14','W23/{+|Les*-N2397}','W23/{+|Les*-N2397}',['Les*-N2397'],'K8414').
% genotype(2950,201,'06N201:S0013808',1159,'06N1434:0019204','Mo20W','Mo20W','W23/{+|Les*-N2397}','W23/{+|Les*-N2397}',['Les*-N2397'],'K8414').
% genotype(2951,301,'06N301:W0036307',1159,'06N1434:0019204','W23','W23','W23/{+|Les*-N2397}','W23/{+|Les*-N2397}',['Les*-N2397'],'K8414').
% genotype(2952,301,'06N301:W0010501',1159,'06N1434:0019204','W23','W23','W23/{+|Les*-N2397}','W23/{+|Les*-N2397}',['Les*-N2397'],'K8414').
% genotype(2953,401,'06N401:M0012306',1159,'06N1434:0019204','M14','M14','W23/{+|Les*-N2397}','W23/{+|Les*-N2397}',['Les*-N2397'],'K8414').
% genotype(2954,301,'06N301:W0010203',1159,'06N1434:0019203','W23','W23','W23/{+|Les*-N2397}','W23/{+|Les*-N2397}',['Les*-N2397'],'K8414').
% genotype(2955,201,'06N201:S0014305',1159,'06N1434:0019201','Mo20W','Mo20W','W23/{+|Les*-N2397}','W23/{+|Les*-N2397}',['Les*-N2397'],'K8414').
% genotype(2956,301,'06N301:W0009312',1159,'06N1434:0019201','W23','W23','W23/{+|Les*-N2397}','W23/{+|Les*-N2397}',['Les*-N2397'],'K8414').
% genotype(2957,301,'06N301:W0010503',1159,'06N1434:0019201','W23','W23','W23/{+|Les*-N2397}','W23/{+|Les*-N2397}',['Les*-N2397'],'K8414').
% genotype(2958,301,'06N301:W0036508',1159,'06N1434:0019201','W23','W23','W23/{+|Les*-N2397}','W23/{+|Les*-N2397}',['Les*-N2397'],'K8414').
% genotype(2959,401,'06N401:M0013005',1159,'06N1434:0019201','M14','M14','W23/{+|Les*-N2397}','W23/{+|Les*-N2397}',['Les*-N2397'],'K8414').





% genotype of family 1013 was incorrectly listed in some earlier versions
%
% Kazic, 18.5.08
%
% genotype(1013,200,'06R200:S00I5601',7,'06R0007:0000709','Mo20W','Mo20W','Mo20W/+','Mo20W/Les9','K0709').
%
%
% hmm, per pedigree and 06n field book these are really Les2 K0202
%
% Kazic, 19.7.2010
%
%
% corrected to Les2 K0202
%
% Kazic, 20.7.2010
%
% genotype(1013,200,'06R200:S00I5601',7,'06R0007:0000709','Mo20W','Mo20W','Mo20W/+','Mo20W/Les9',['Les9'],'K0709').
% genotype(2285,201,'06N201:S0010406',1013,'06N1013:0000310','Mo20W','Mo20W','Mo20W','Mo20W/Les9',['Les9'],'K0709').
% genotype(2286,401,'06N401:M0010901',1013,'06N1013:0000310','M14','M14','Mo20W','Mo20W/Les9',['Les9'],'K0709').
% genotype(2287,201,'06N201:S0010709',1013,'06N1013:0000306','Mo20W','Mo20W','Mo20W','Mo20W/Les9',['Les9'],'K0709').
% genotype(2288,301,'06N301:W0004509',1013,'06N1013:0000306','W23','W23','Mo20W','Mo20W/Les9',['Les9'],'K0709').
% genotype(2289,401,'06N401:M0005505',1013,'06N1013:0000306','M14','M14','Mo20W','Mo20W/Les9',['Les9'],'K0709').
% genotype(2290,1013,'06N1013:0000308',1013,'06N1013:0000301','Mo20W','Mo20W','Mo20W','Mo20W/Les9',['Les9'],'K0709').
% genotype(2291,301,'06N301:W0004503',1013,'06N1013:0000301','W23','W23','Mo20W','Mo20W/Les9',['Les9'],'K0709').
% genotype(2292,301,'06N301:W0004507',1013,'06N1013:0000301','W23','W23','Mo20W','Mo20W/Les9',['Les9'],'K0709').


genotype(1013,200,'06R200:S00I5601',7,'06R0007:0000709','Mo20W','Mo20W','Mo20W/+','Mo20W/Les2',['Les2'],'K0202').
genotype(2285,201,'06N201:S0010406',1013,'06N1013:0000310','Mo20W','Mo20W','Mo20W','Mo20W/Les2',['Les2'],'K0202').
genotype(2286,401,'06N401:M0010901',1013,'06N1013:0000310','M14','M14','Mo20W','Mo20W/Les2',['Les2'],'K0202').
genotype(2287,201,'06N201:S0010709',1013,'06N1013:0000306','Mo20W','Mo20W','Mo20W','Mo20W/Les2',['Les2'],'K0202').
genotype(2288,301,'06N301:W0004509',1013,'06N1013:0000306','W23','W23','Mo20W','Mo20W/Les2',['Les2'],'K0202').
genotype(2289,401,'06N401:M0005505',1013,'06N1013:0000306','M14','M14','Mo20W','Mo20W/Les2',['Les2'],'K0202').
genotype(2290,1013,'06N1013:0000308',1013,'06N1013:0000301','Mo20W','Mo20W','Mo20W','Mo20W/Les2',['vLes2'],'K0202').
genotype(2291,301,'06N301:W0004503',1013,'06N1013:0000301','W23','W23','Mo20W','Mo20W/Les2',['Les2'],'K0202').
genotype(2292,301,'06N301:W0004507',1013,'06N1013:0000301','W23','W23','Mo20W','Mo20W/Les2',['Les2'],'K0202').



% BUT WAIT!
%
% /athe/c/maize/crops/06r/management/06r_planting.csv says that row 7 is Mo20W/Les9;
%
% row 2 was Mo20W/Les2.  So the original genotype should be correct!
%
% This may explain some of our Les2 results . . . I''m not going to change this without sleeping on it,
% and we''re in the midst of the reinventory trauma.  But later this summer, I will go back and recheck.
%
% Kazic, 30.5.2014





%%%%%%%%%% think the rest of these are ok
%
% Kazic, 8.5.2008



% oops, found another:  
%
% families 1329 and 1330 refer to the same row in 06N! have converted 1329 to 1330 in the records
% as shown below, since this is the least invasive.
%
% grep 06N1330 genotype.pl inventory.pl mutant_packing.pl packed_packet.pl plan.pl planting.pl
% genotype.pl:genotype(2207,301,'06N301:W0004208',1330,'06N1330:0017710','W23','W23','W23','Les18',['Les18'],'K3106').
% genotype.pl:genotype(2208,301,'06N301:W0007508',1330,'06N1330:0017702','W23','W23','W23','Les18',['Les18'],'K3106').
% genotype.pl:genotype(2209,301,'06N301:W0007503',1330,'06N1330:0017706','W23','W23','W23','Les18',['Les18'],'K3106').
% inventory.pl:inventory('06N301:W0004208','06N1330:0017710',num_kernels(half),matt,date(03,1,2008),time(13,31,11),v00049).
% inventory.pl:inventory('06N301:W0007508','06N1330:0017702',num_kernels(half),matt,date(03,1,2008),time(13,0,37),v00055).
% inventory.pl:inventory('06N301:W0007803','06N1330:0017706',num_kernels(whole),matt,date(02,1,2008),time(14,4,59),v00056).
% mutant_packing.pl:mutant_packing(229,[('06N301:W0004208','06N1330:0017710'),('06N301:W0007508','06N1330:0017702'),('06N301:W0007803','06N1330:0017706')],1,'09R').
% packed_packet.pl:packed_packet(p00166,'06N301:W0007803','06N1330:0017706',toni,date(18,5,2009),time(09,29,26)).
% plan.pl:plan('06N301:W0007803','06N1330:0017706',2,'W','','09R').
%
%
% grep 06N1329 genotype.pl inventory.pl mutant_packing.pl packed_packet.pl plan.pl planting.pl
% genotype.pl:genotype(2896,301,'06N301:W0004208',1329,'06N1329:0017710','W23','W23','W23','Les18',['Les18'],'K3106').
% genotype.pl:genotype(2897,301,'06N301:W0007803',1329,'06N1329:0017706','W23','W23','W23','Les18',['Les18'],'K3106').
% genotype.pl:genotype(2898,301,'06N301:W0007508',1329,'06N1329:0017702','W23','W23','W23','Les18',['Les18'],'K3106').
% planting.pl:planting('07R',676,'','06N301:W0007508','06N1329:0017702',2,15,10).
% planting.pl:planting('07R',677,'','06N301:W0007803','06N1329:0017706',2,15,10).
% planting.pl:planting('07R',678,'','06N301:W0004208','06N1329:0017710',2,15,10).
%
% Kazic, 14.6.2009
%
%
% oops, this was a mistake.  What was planted in row 177 in 06n was 1329, not 1330.  
% They''re both W23/Les18, but the first is
% K3106 and the second K3103.  Family 1330 was planted in row 176.
%
% So changed these from 1330 back to 1329:
%
% genotype(2896,301,'06N301:W0004208',1330,'06N1330:0017710','W23','W23','W23','Les18',['Les18'],'K3106').
% genotype(2897,301,'06N301:W0007803',1330,'06N1330:0017706','W23','W23','W23','Les18',['Les18'],'K3106').
% genotype(2898,301,'06N301:W0007508',1330,'06N1330:0017702','W23','W23','W23','Les18',['Les18'],'K3106').
% genotype(2207,301,'06N301:W0004208',1330,'06N1330:0017710','W23','W23','W23','Les18',['Les18'],'K3106').
% genotype(2208,301,'06N301:W0007508',1330,'06N1330:0017702','W23','W23','W23','Les18',['Les18'],'K3106').
%
% inventory('06N301:W0004208','06N1330:0017710',num_kernels(half),matt,date(03,1,2008),time(13,31,11),v00049).
% inventory('06N301:W0007508','06N1330:0017702',num_kernels(half),matt,date(03,1,2008),time(13,0,37),v00055).
% inventory('06N301:W0007803','06N1330:0017706',num_kernels(whole),matt,date(02,1,2008),time(14,4,59),v00056).
%
% mutant_packing(229,[('06N301:W0004208','06N1330:0017710'),('06N301:W0007508','06N1330:0017702'),('06N301:W0007803','06N1330:0017706')],1,'09R').
%
% packed_packet(p00637,'06N301:W0007508','06N1330:0017702',15,toni,date(21,4,2007),time(12,0,0)).
% packed_packet(p00638,'06N301:W0007803','06N1330:0017706',15,toni,date(21,4,2007),time(12,0,0)).
% packed_packet(p00639,'06N301:W0004208','06N1330:0017710',15,toni,date(21,4,2007),time(12,0,0)).
%
% plan('06N301:W0007803','06N1330:0017706',2,['W'],'','09R').
%
% believe that planting_index will be fixed on recomputation:
%
% planting_index.pl:planting_index('06N301:W0007508','06N1330:0017702','07R',676).
% planting_index.pl:planting_index('06N301:W0007803','06N1330:0017706','07R',677).
% planting_index.pl:planting_index('06N301:W0004208','06N1330:0017710','07R',678).
% planting_index.pl:planting_index('06N301:W0007803','06N1330:0017706','09R',268).
%
% crop_rowplant, row_members are correct for both families 1329 and 1330 in 06N





% the following facts had the maternal numerical genotype repadded to conform to
% the expectations of genetic_utilities:remove_padding/2 (called in 
% genetic_utilities:make_num_gtypes/5).  This shifted I# to I0# in inbred rows
% 1--10.  Family numbers and the rest of the data are unchanged.
%
% genotype(2994,200,'06R200:S000I104',55,'06R0055:0005515','Mo20W','Mo20W','Les2-N845A/+','M14/W23',['Les2-N845A'],'K5515').
% genotype(1458,300,'06R300:W000I208',77,'06R0077:0007718','W23','W23','{+|les*-N2012}','{+|les*-N2012}',['les*-N2012'],'K7718').
% genotype(1209,300,'06R300:W000I219',97,'06R0097:0009706','W23','W23','Ht1-GE440 ^M14/Ht1-GE440 ^M14','Ht1-GE440 ^M14/Ht1-GE440 ^M14',['Ht1-GE440'],'K9706').
% genotype(1215,400,'06R400:M000I308',97,'06R0097:0009706','M14','M14','Ht1-GE440 ^M14/Ht1-GE440 ^M14','Ht1-GE440 ^M14/Ht1-GE440 ^M14',['Ht1-GE440'],'K9706').
% genotype(1212,400,'06R400:M000I309',97,'06R0097:0009707','M14','M14','Ht1-GE440 ^M14/Ht1-GE440 ^M14','Ht1-GE440 ^M14/Ht1-GE440 ^M14',['Ht1-GE440'],'K9707').
% genotype(1227,300,'06R300:W000I504',55,'06R0055:0005515','W23','W23','Les2-N845A/+','M14/W23',['Les2-N845A'],'K5515').
% genotype(1157,300,'06R300:W000I507',61,'06R0061:0006106','W23','W23','W23/L317','+/Les8-N2005',['Les8-N2005'],'K6106').
% genotype(1208,300,'06R300:W000I518',97,'06R0097:0009707','W23','W23','Ht1-GE440 ^M14/Ht1-GE440 ^M14','Ht1-GE440 ^M14/Ht1-GE440 ^M14',['Ht1-GE440'],'K9707').
% genotype(1103,300,'06R300:W000I805',112,'06R0112:0011201','W23','W23',zn1,zn1,[zn1],'K11201').
% genotype(1075,300,'06R300:W000I815',40,'06R0040:0004003','W23','W23','Les6 NonExp/?','?/Les6 Exp',['Les6 Exp'],'K4003').		  				 %
%
% Kazic, 2.5.2018




											      

%%%%%%%%%%%%%%%%%%%%%%%% lines from others %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% from Gerry Neuffer


% I''m assuming 1 -- 35 were back-crossed to the inbred female
%
% Kazic, 11.5.08




genotype(1,1,'06R0001:0000000',1,'06R0001:0000000','Mo20W','Mo20W','Mo20W/+','Les1',['Les1'],'').
genotype(2,2,'06R0002:0000000',2,'06R0002:0000000','Mo20W','Mo20W','Mo20W/+','Les2',['Les2'],'').
genotype(3,3,'06R0003:0000000',3,'06R0003:0000000','Mo20W','Mo20W','Mo20W/+','Les4',['Les4'],'').
genotype(4,4,'06R0004:0000000',4,'06R0004:0000000','Mo20W','Mo20W','Mo20W/+','Les6',['Les6'],'').
genotype(5,5,'06R0005:0000000',5,'06R0005:0000000','Mo20W','Mo20W','Mo20W/+','Les7',['Les7'],'').
genotype(6,6,'06R0006:0000000',6,'06R0006:0000000','Mo20W','Mo20W','Mo20W/+','Les8',['Les8'],'').
genotype(7,7,'06R0007:0000000',7,'06R0007:0000000','Mo20W','Mo20W','Mo20W/+','Les9',['Les9'],'').
genotype(8,8,'06R0008:0000000',8,'06R0008:0000000','Mo20W','Mo20W','Mo20W/+','Les10',['Les10'],'').
genotype(9,9,'06R0009:0000000',9,'06R0009:0000000','Mo20W','Mo20W','Mo20W/+','Les11',['Les11'],'').
genotype(10,10,'06R0010:0000000',10,'06R0010:0000000','Mo20W','Mo20W','Mo20W/+','Les12',['Les12'],'').
genotype(11,11,'06R0011:0000000',11,'06R0011:0000000','Mo20W','Mo20W','Mo20W/+','Les13',['Les13'],'').
genotype(12,12,'06R0012:0000000',12,'06R0012:0000000','Mo20W','Mo20W','Mo20W/+','Les15',['Les15'],'').
genotype(13,13,'06R0013:0000000',13,'06R0013:0000000','Mo20W','Mo20W','Mo20W/+','Les17',['Les17'],'').
genotype(14,14,'06R0014:0000000',14,'06R0014:0000000','Mo20W','Mo20W','Mo20W/+','Les18',['Les18'],'').
genotype(15,15,'06R0015:0000000',15,'06R0015:0000000','Mo20W','Mo20W','Mo20W/+','Les19',['Les19'],'').
genotype(16,16,'06R0016:0000000',16,'06R0016:0000000','Mo20W','Mo20W','Mo20W/+','Les21',['Les21'],'').
genotype(17,17,'06R0017:0000000',17,'06R0017:0000000','Mo20W','Mo20W','Mo20W/+',lls1,[lls1],'').
genotype(18,18,'06R0018:0000000',18,'06R0018:0000000','Mo20W','Mo20W','Mo20W/+',les23,[les23],'').
genotype(19,19,'06R0019:0000000',19,'06R0019:0000000','W23','W23','W23/+','Les1',['Les1'],'').
genotype(20,20,'06R0020:0000000',20,'06R0020:0000000','W23','W23','W23/+','Les2',['Les2'],'').
genotype(21,21,'06R0021:0000000',21,'06R0021:0000000','W23','W23','W23/+','Les4',['Les4'],'').
genotype(22,22,'06R0022:0000000',22,'06R0022:0000000','W23','W23','W23/+','Les6',['Les6'],'').
genotype(23,23,'06R0023:0000000',23,'06R0023:0000000','W23','W23','W23/+','Les7',['Les7'],'').
genotype(24,24,'06R0024:0000000',24,'06R0024:0000000','W23','W23','W23/+','Les8',['Les8'],'').
genotype(25,25,'06R0025:0000000',25,'06R0025:0000000','W23','W23','W23/+','Les9',['Les9'],'').
genotype(26,26,'06R0026:0000000',26,'06R0026:0000000','W23','W23','W23/+','Les10',['Les10'],'').
genotype(27,27,'06R0027:0000000',27,'06R0027:0000000','W23','W23','W23/+','Les12',['Les12'],'').
genotype(28,28,'06R0028:0000000',28,'06R0028:0000000','W23','W23','W23/+','Les13',['Les13'],'').
genotype(29,29,'06R0029:0000000',29,'06R0029:0000000','W23','W23','W23/+','Les15',['Les15'],'').
genotype(30,30,'06R0030:0000000',30,'06R0030:0000000','W23','W23','W23/+','Les17',['Les17'],'').
genotype(31,31,'06R0031:0000000',31,'06R0031:0000000','W23','W23','W23/+','Les18',['Les18'],'').
genotype(32,32,'06R0032:0000000',32,'06R0032:0000000','W23','W23','W23/+','Les19',['Les19'],'').
genotype(33,33,'06R0033:0000000',33,'06R0033:0000000','W23','W23','W23/+','Les21',['Les21'],'').
genotype(34,34,'06R0034:0000000',34,'06R0034:0000000','W23','W23','W23/+','lls1 121D',['lls1 121D'],'K3400').
genotype(35,35,'06R0035:0000000',35,'06R0035:0000000','W23','W23','W23/+',les23,[les23],'').
genotype(36,36,'06R0036:0000000',36,'06R0036:0000000','Les1 NonExp',?,?,'Les1 Exp',['Les1 Exp'],'').
genotype(37,37,'06R0037:0000000',37,'06R0037:0000000','Les2 NonExp',?,?,'Les2 Exp',['Les2 Exp'],'').
genotype(38,38,'06R0038:0000000',38,'06R0038:0000000','Les4 NonExp',?,?,'Les4 Exp',['Les4 Exp'],'').
genotype(39,39,'06R0039:0000000',39,'06R0039:0000000','Les5 Exp???',?,?,'Les5 Exp???',['Les5 Exp???'],'').
genotype(40,40,'06R0040:0000000',40,'06R0040:0000000','Les6 NonExp',?,?,'Les6 Exp',['Les6 Exp'],'').
genotype(41,41,'06R0041:0000000',41,'06R0041:0000000','Les7 NonExp',?,?,'Les7 Exp',['Les7 Exp'],'').
genotype(42,42,'06R0042:0000000',42,'06R0042:0000000','Les8 NonExp',?,?,'Les8 Exp',['Les8 Exp'],'').
genotype(43,43,'06R0043:0000000',43,'06R0043:0000000','Les9 NonExp',?,?,'Les9 Exp',['Les9 Exp'],'').
genotype(44,44,'06R0044:0000000',44,'06R0044:0000000','Les10 NonExp',?,?,'Les10 Exp',['Les10 Exp'],'').
genotype(45,45,'06R0045:0000000',45,'06R0045:0000000','Les11 NonExp',?,?,'Les11 Exp??',['Les11 Exp??'],'').
genotype(46,46,'06R0046:0000000',46,'06R0046:0000000','Les12 NonExp',?,?,'Les12 Exp',['Les12 Exp'],'').
genotype(47,47,'06R0047:0000000',47,'06R0047:0000000','Les15 NonExp',?,?,'Les15 Exp',['Les15 Exp'],'').
genotype(48,48,'06R0048:0000000',48,'06R0048:0000000','Les17',?,?,?,['Les17 Exp?'],'K4800').
genotype(49,49,'06R0049:0000000',49,'06R0049:0000000','Les18 NonExp',?,?,'Les18 Exp',['Les18 Exp'],'').
genotype(50,50,'06R0050:0000000',50,'06R0050:0000000','Les19 NonExp',?,?,'Les19 Exp',['Les19 Exp'],'').
genotype(51,51,'06R0051:0000000',51,'06R0051:0000000','Les20 NonExp',?,?,'Les20 Exp',['Les20 Exp'],'').
genotype(52,52,'06R0052:0000000',52,'06R0052:0000000','Les21 NonExp',?,?,'Les21 Exp',['Les21 Exp'],'').
genotype(53,53,'06R0053:0000000',53,'06R0053:0000000','lls1 121D',?,'lls1 121D',?,['lls1 121D'],'K5300').













 
% new from Gerry; attempted resuscitations; each allele number should be prefixed by N; here I
% am recording exactly what is on the packet

genotype(125,125,'09R0125:0000000',125,'09R0125:0000000','Mo20Y W23','ll-264','Mo20Y W23','ll-264',['ll-264'],'K12500').

genotype(126,126,'09R0126:0000000',126,'09R0126:0000000','A C R','nec-490A','A C R','nec-490A',['nec-490A'],'K12600').
% also:
% genotype(157,157,'60:119-5',157,'60:119-5','A C R','nec-490A','A C R','nec-490A',['nec-490A'],'').
% note is: leaf tip necrosis

genotype(130,130,'09R0130:0000000',130,'09R0130:0000000',+,'Blh-1455',wxr,'Twx3-9 (8447)',['Blh-1455'],'K13000').
%
% % genotype is: +/Blh-1455; wxr x Twx 3-9(8447)  (could be 8442)
 

genotype(131,131,'09R0131:0000000',131,'09R0131:0000000','Mo20W',+,'M14','nec-1521A',['nec-1521A'],'K13100').
% note is: like lls


genotype(127,127,'09R0127:0000000',127,'09R0127:0000000',+,'nec-831A',+,'nec-831A',['nec-831A'],'K12700').

genotype(128,128,'09R0128:0000000',128,'09R0128:0000000',+,'les-A853',+,'les-A853',['les-A853'],'').

genotype(129,129,'09R0129:0000000',129,'09R0129:0000000',+,'Spt-1320C',+,'Twx-6-9a',['Spt-1320C'],'').
%
% also:
% % genotype(*130,*130,'21:479-13',*130,'21:478-6','Ph5 +','Spt-1320C','Ph5 +?','Spt-1320C',['Spt-1320C'],'').
% 5? S? ask; but not needed





% nb: for family 132, packet corrects nec to les, but MGCSC has nec
%
genotype(132,132,'09R0132:0000000',132,'09R0132:0000000','Aho Rnj','Aho Rnj',+,'nec-1613',['nec-1613'],'K13200').
%
% also:
% 41:715-8 x 41:715-8  +/nec-1613

genotype(133,133,'09R0133:0000000',133,'09R0133:0000000','A632','les-2240?','Mo17 les-2240','les-2240',['les-2240'],'K13300').

genotype(156,156,'09R0156:0000000',156,'09R0156:0000000','A632','les-2240?','Mo17 les-2240','les-2240',['les-2240'],'K15600').
% 
% also:
% 44:F429 x 44:429-S (or 5?) +/les*-2240? x les*-2240; A632 Mo17 and 
% 44:F429-5 x 44:429N  les-2240 x +/les-2240?; A632 Mo17


genotype(134,134,'09R0134:0000000',134,'09R0134:0000000','M020Y/W23','les-2274','Mo20Y/W23','les-2274',['les-2274'],'K13400').

genotype(135,135,'09R0135:0000000',135,'09R0135:0000000','Mo20Y','W23',+,'Les-2318; sh2 Ga504',['Les-2318'],'K13500').
%
% not really, it is:  Mo20Y/W23 x +/Les-2318; sh2 Ga504
%
% also:
% 45:727 x 45:666-7,'Mo20Y','W23','+','Les-2318?; sh2 Ga504'


genotype(136,136,'09R0136:0000000',136,'09R0136:0000000','Mo17','A632',+,'les-2386',['les-2386'],'K13600').
%
% says:  Normal x les-2386; Mo17 A632


genotype(157,157,'09R0157:0000000',157,'09R0157:0000000','A C R','nec-490A','A C R','nec-490A',['nec-490A'],'K15700').




% from MGCSC


genotype(54,54,'06R0054:0000000',54,'06R0054:0000000','B73 Ht1','B73 Ht1',+,'Les1-N843',['Les1-N843'],'').
genotype(55,55,'06R0055:0000000',55,'06R0055:0000000','Les2-N845A',+,'M14','W23',['Les2-N845A'],'').
genotype(56,56,'06R0056:0000000',56,'06R0056:0000000','W23','L317',+,'Les3-',['Les3'],'K5600').
genotype(57,57,'06R0057:0000000',57,'06R0057:0000000','B77','A636',+,'Les4-N1375',['Les4-N1375'],'K5700').
genotype(58,58,'06R0058:0000000',58,'06R0058:0000000','W23','M14',+,'Les5-N1449',['Les5-N1449'],'K5800').
genotype(59,59,'06R0059:0000000',59,'06R0059:0000000',+,+,+,'Les6-N1451',['Les6-N1451'],'K5900').
genotype(60,60,'06R0060:0000000',60,'06R0060:0000000','W23','L317',+,'Les7-N1461',['Les7-N1461'],'').
genotype(61,61,'06R0061:0000000',61,'06R0061:0000000','W23','L317',+,'Les8-N2005',['Les8-N2005'],'').
genotype(62,62,'06R0062:0000000',62,'06R0062:0000000','(M14/W23)',+,'(M14/W23)','Les9-N2008',['Les9-N2008'],'').
genotype(63,63,'06R0063:0000000',63,'06R0063:0000000','W23','M14',+,'Les10-NA607',['Les10-NA607'],'').
genotype(64,64,'06R0064:0000000',64,'06R0064:0000000','W23','M14',+,'Les11-N1438',['Les11-N1438'],'').
genotype(65,65,'06R0065:0000000',65,'06R0065:0000000','W23','M14',+,'Les12-N1453',['Les12-N1453'],'').
genotype(66,66,'06R0066:0000000',66,'06R0066:0000000','W23','L317',+,'Les13-N2003',['Les13-N2003'],'').
genotype(67,67,'06R0067:0000000',67,'06R0067:0000000','W23','M14',+,'Les15-N2007',['Les15-N2007'],'').
genotype(68,68,'06R0068:0000000',68,'06R0068:0000000','W23','M14',+,'Les17-N2345',['Les17-N2345'],'').
genotype(69,69,'06R0069:0000000',69,'06R0069:0000000','W23','M14',+,'Les18-N2441',['Les18-N2441'],'').
genotype(70,70,'06R0070:0000000',70,'06R0070:0000000','W23','M14',+,'Les19-N2450',['Les19-N2450'],'').
genotype(71,71,'06R0071:0000000',71,'06R0071:0000000','W23','L317',+,'Les20-N2457',['Les20-N2457'],'').
genotype(72,72,'06R0072:0000000',72,'06R0072:0000000','B73 Ht1','B73 Ht1',+,'Les21-N1442',['Les21-N1442'],'').
genotype(73,73,'06R0073:0000000',73,'06R0073:0000000','B73 Ht1','B73 Ht1','Les*-N502C',+,['Les*-N502C'],'K7300').
genotype(74,74,'06R0074:0000000',74,'06R0074:0000000','CM105','Oh43E',+,'Les*-N1378',['Les*-N1378'],'').
genotype(75,75,'06R0075:0000000',75,'06R0075:0000000','les*-N1395C','les*-N1395C','les*-N1395C','les*-N1395C',[''],'').
genotype(76,76,'06R0076:0000000',76,'06R0076:0000000',+,'Les*-N1450',+,'Les*-N1450',['Les*-N1450'],'').
genotype(77,77,'06R0077:0000000',77,'06R0077:0000000',+,'les*-N2012',+,'les*-N2012',['les*-N2012'],'').
genotype(78,78,'06R0078:0000000',78,'06R0078:0000000','les*-N2013','les*-N2013','les*-N2013','les*-N2013',['les*-N2013'],'').
genotype(79,79,'06R0079:0000000',79,'06R0079:0000000',+,'les*-N2015',+,'les*-N2015',['les*-N2015'],'K7900').
genotype(80,80,'06R0080:0000000',80,'06R0080:0000000','Mo20W','les*-N2290A','Mo20W','les*-N2290A',['les*-N2290A'],'').
genotype(81,81,'06R0081:0000000',81,'06R0081:0000000','B73 Ht1','Mo17',+,'Les*-N2320',['Les*-N2320'],'').
genotype(82,82,'06R0082:0000000',82,'06R0082:0000000','(B73/AG32)','(Ht1/les*-N2333A)','(B73/AG32)','(Ht1/les*-N2333A)',['les*-N2333A'],'').
genotype(83,83,'06R0083:0000000',83,'06R0083:0000000',+,'les*-N2363A',+,'les*-N2363A',['les*-N2363A'],'').
genotype(84,84,'06R0084:0000000',84,'06R0084:0000000',+,'Les*-N2397',+,'Les*-N2397',['Les*-N2397'],'').
genotype(85,85,'06R0085:0000000',85,'06R0085:0000000','B73/AG32','Ht1',+,'Les*-N2418',['Les*-N2418'],'').
genotype(86,86,'06R0086:0000000',86,'06R0086:0000000','M14','W23',+,'Les*-N2420',['Les*-N2420'],'K8600').
genotype(87,87,'06R0087:0000000',87,'06R0087:0000000','les*-N2502','les*-N2502','les*-N2502','les*-N2502',['les*-N2502'],'').
genotype(88,88,'06R0088:0000000',88,'06R0088:0000000',+,'les*-3F-3330',+,'les*-3F-3330',['les*-3F-3330'],'').
genotype(89,89,'06R0089:0000000',89,'06R0089:0000000','B73/AG32','Ht1',+,'Les*-NA1176',['Les*-NA1176'],'K8900').
genotype(90,90,'06R0090:0000000',90,'06R0090:0000000','les*-NA467','les*-NA467','les*-NA467','les*-NA467',['les*-NA467'],'').
genotype(91,91,'06R0091:0000000',91,'06R0091:0000000','B73 Ht1','Mo17',+,'Les*-NA7145',['Les*-NA7145'],'').
genotype(92,92,'06R0092:0000000',92,'06R0092:0000000','W23/L317','les*-2119','W23/L317','les*-2119',['les*-2119'],'').
genotype(93,93,'06R0093:0000000',93,'06R0093:0000000',+,'les*-74-1873-9','les*-74-1873-9','les*-74-1873-9',['les*-74-1873-9'],'').
genotype(94,94,'06R0094:0000000',94,'06R0094:0000000',+,'les*-PI251888',+,'les*-PI251888',['les*-PI251888'],'K9400').
genotype(95,95,'06R0095:0000000',95,'06R0095:0000000','B73 Ht1','les*-ats','B73 Ht1','les*-ats',['les*-ats'],'').
%
% temporary K pending outcome of selfs
%
% Kazic, 9.12.2010
%
genotype(96,96,'06R0096:0000000',96,'06R0096:0000000',+,'cpc1-N2284B',+,'cpc1-N2284B',['cpc1-N2284B'],'K9600').
genotype(97,97,'06R0097:0000000',97,'06R0097:0000000','Ht1-GE440 ^M14','Ht1-GE440 ^M14','Ht1-GE440 ^M14','Ht1-GE440 ^M14',['Ht1-GE440'],'').
% genotype(98,98,'06R0098:0000000',98,'06R0098:0000000','Ht1-Ladyfinger ^M14','Ht1-Ladyfinger ^M14','Ht1-Ladyfinger ^M14','Ht1-Ladyfinger ^M14',['Ht1-Ladyfinger'],'').
%
% assuming I know the direction of the back-cross, which I don''t, really
%
% Kazic, 18.10.2012
genotype(98,98,'06R0098:0000000',98,'06R0098:0000000','M14','Ht1-Ladyfinger','M14','Ht1-Ladyfinger',['Ht1-Ladyfinger'],'').
%
genotype(99,99,'06R0099:0000000',99,'06R0099:0000000','B73 Ht1','B73 Ht1','B73 Ht1','B73 Ht1',['Ht1'],'').
genotype(100,100,'06R0100:0000000',100,'06R0100:0000000','Ht2 ^A619','Ht2 ^A619','Ht2 ^A619','Ht2 ^A619',['Ht2'],'').
genotype(101,101,'06R0101:0000000',101,'06R0101:0000000',ht4,ht4,ht4,ht4,[ht4],'').
genotype(102,102,'06R0102:0000000',102,'06R0102:0000000','Htn1 ^W22','Htn1 ^W22','Htn1 ^W22','Htn1 ^W22',['Htn1'],'').
genotype(103,103,'06R0103:0000000',103,'06R0103:0000000','W22 ij2-N8','W22 ij2-N8','W22 ij2-N8','W22 ij2-N8',['ij2-N8'],'').
genotype(104,104,'06R0104:0000000',104,'06R0104:0000000',+,'lep*-8691',+,'lep*-8691',['lep*-8691'],'').
genotype(105,105,'06R0105:0000000',105,'06R0105:0000000',+,'lls1-N501B',+,'lls1-N501B',['lls1-N501B'],'K10500').
genotype(106,106,'06R0106:0000000',106,'06R0106:0000000',+,lls1,+,lls1,[lls1],'K10600').
genotype(107,107,'06R0107:0000000',107,'06R0107:0000000',+,'nec*-6853',+,'nec*-6853',['nec*-6853'],'').
genotype(108,108,'06R0108:0000000',108,'06R0108:0000000',rhm1Y1,rhm1Y1,rhm1Y1,rhm1Y1,[rhm1Y1],'').
genotype(109,109,'06R0109:0000000',109,'06R0109:0000000','W23','M14',+,'spc1-N1376',['spc1-N1376'],'K10900').
genotype(110,110,'06R0110:0000000',110,'06R0110:0000000',+,'spc3-N553C',+,'spc3-N553C',['spc3-N553C'],'K11000').
genotype(111,111,'06R0111:0000000',111,'06R0111:0000000','M14/W23','vms*-8522','M14/W23','vms*-8522',['vms*-8522'],'').
genotype(112,112,'06R0112:0000000',112,'06R0112:0000000',zn1,zn1,zn1,zn1,[zn1],'').


genotype(137,137,'09R0137:0000000',137,'09R0137:0000000',+,'les*-PI262474',+,'les*-PI262474',['les*-PI262474'],'').
genotype(139,139,'09R0139:0000000',139,'09R0139:0000000','B73','Mo17',+,'Les*-N2420',['Les*-N2420'],'K13900').
genotype(140,140,'09R0140:0000000',140,'09R0140:0000000','W23','M14',+,'spc1-N1376',['spc1-N1376'],'K14000').



genotype(148,148,'09R0148:0000000',148,'09R0148:0000000','CM105','Oh43E',+,'Blh*-N1455',['Blh*-N1455'],'K14800').
genotype(149,149,'09R0149:0000000',149,'09R0149:0000000','B73 Ht1/Mo17','les*-74-1820-6','B73 Ht1/Mo17','les*-74-1820-6',['les*-74-1820-6'],'K14900').
genotype(150,150,'09R0150:0000000',150,'09R0150:0000000',+,'les*-Funk-4',+,'les*-Funk-4',['les*-Funk-4'],'K15000').
genotype(151,151,'09R0151:0000000',151,'09R0151:0000000','W23/B77','les*-NA853','W23/B77','les*-NA853',['les*-NA853'],'K15100').
genotype(152,152,'09R0152:0000000',152,'09R0152:0000000',+,'ll*-N264',+,'ll*-N264',['ll*-N264'],'K15200').
genotype(153,153,'09R0153:0000000',153,'09R0153:0000000',+,'nec2-8147',+,'nec2-8147',['nec2-8147'],'K15300').
genotype(154,154,'09R0154:0000000',154,'09R0154:0000000',+,'nec*-N1613',+,'nec*-N1613',['nec*-N1613'],'K15400').
genotype(155,155,'09R0155:0000000',155,'09R0155:0000000',+,'nec*-N490A',+,'nec*-N490A',['nec*-N490A'],'K15500').





% from Guri Johal

% genotype(113,113,'07R0113:0000000',113,'07R0113:0000000',?,'?/les23 slm1',?,'?/les23 slm1',['les23 slm1'],'').
genotype(113,113,'07R0113:0000000',113,'07R0113:0000000','?','?/les23 Slm1','?','?/les23 Slm1',['les23 Slm1'],'K11300').
genotype(114,114,'07R0114:0000000',114,'07R0114:0000000','Mo20W','+/les23','Mo20W','+/les23',[les23],'K11400').
genotype(115,115,'07R0115:0000000',115,'07R0115:0000000','?','csp1/?','?','csp1/?',['csp1'],'K11500').
genotype(116,116,'07R0116:0000000',116,'07R0116:0000000','?','?/Les5','?','?/Les5',['Les5'],'K11600').
genotype(117,117,'07R0117:0000000',117,'07R0117:0000000','C-13','AG32','?','?/Les-EC91',['Les-EC91'],'K11700').
genotype(118,118,'07R0118:0000000',118,'07R0118:0000000','I-54/?','?/Les101','Va35','Va35',['Les101'],'K11800').
genotype(119,119,'07R0119:0000000',119,'07R0119:0000000','+',+,'?','?/Les3-GJ',['Les3-GJ'],'K11900').
%
% regularized
%
% Kazic, 3.11.2011
%
% genotype(120,120,'07R0120:0000000',120,'07R0120:0000000','I-52/?','Les-102/?','Va35','Va35',['Les-102'],'').     
%
genotype(120,120,'07R0120:0000000',120,'07R0120:0000000','I-52/?','Les102/?','Va35','Va35',['Les102'],'K12000').    


% from Guri Johal for 10r; start at 158

% genotype(158,158,'10R0158:0000000',158,'10R0158:0000000','?','Les2','?','+',['Les2'],'K15800').
%
% renamed this next to distinguish it from the allele from the stock center, family 56
%
% Kazic, 23.12.2010
%
genotype(158,158,'10R0158:0000000',158,'10R0158:0000000','?','Les2-GJ','?','+',['Les2-GJ'],'K15800').
%
% presume this next is identical to Les3-GJ, but since I don't know am treating it as a different allele
%
% Kazic, 23.12.2010
%
genotype(159,159,'10R0159:0000000',159,'10R0159:0000000','Mo17','Mo17','?','Les3-GJ2',['Les3-GJ2'],'K15900').
genotype(160,160,'10R0160:0000000',160,'10R0160:0000000','Mo20W','Mo20W','?','Les5-GJ',['Les5-GJ'],'K16000').
genotype(161,161,'10R0161:0000000',161,'10R0161:0000000','B73','B73','?','Les5-GJ2',['Les5-GJ2'],'K16100').
genotype(162,162,'10R0162:0000000',162,'10R0162:0000000','?','?','?','Les22-zebra',['Les22-zebra'],'K16200').
genotype(163,163,'10R0163:0000000',163,'10R0163:0000000','?','les23','les23','les23',['les23'],'K16300').
genotype(164,164,'10R0164:0000000',164,'10R0164:0000000','?','?','?','Les28',['Les28'],'K16400').
genotype(165,165,'10R0165:0000000',165,'10R0165:0000000','Les101','AG32','B73','B73',['Les101'],'K16500').
genotype(166,166,'10R0166:0000000',166,'10R0166:0000000','Mo20W','Mo20W','?','Les102',['Les102'],'K16600').
genotype(167,167,'10R0167:0000000',167,'10R0167:0000000','+','+','+','Les297',['Les297'],'K16700').
genotype(168,168,'10R0168:0000000',168,'10R0168:0000000','+','les2014','les2014','les2014',['les2014'],'K16800').
genotype(169,169,'10R0169:0000000',169,'10R0169:0000000','?','LesDS*-1','?','LesDS*-1',['LesDS*-1'],'').
%
% I''m guessing this next is from Damon Lisch and is what I''m calling Les*-mi1
%
% Kazic, 2.6.2010
%
genotype(170,170,'10R0170:0000000',170,'10R0170:0000000','Mo20W','Mo20W','Mo20W','Les DL(Mop1)',['Les DL (Mop1)'],''). 
%
% assume this next is Les-EC91; packet just said EC91
%
% Kazic, 23.12.2010
%
genotype(171,171,'10R0171:0000000',171,'10R0171:0000000','B73','B73','Les-EC91','B73',['Les-EC91'],'K17100').
genotype(172,172,'10R0172:0000000',172,'10R0172:0000000','Les?','B73','Les?','B73',['Les?'],'K17200').
genotype(173,173,'10R0173:0000000',173,'10R0173:0000000','LesLA','+','+','+',['LesLA'],'').
genotype(174,174,'10R0174:0000000',174,'10R0174:0000000','?','les*-tilling1','?','les*-tilling1',['les*-tilling1'],'').
genotype(175,175,'10R0175:0000000',175,'10R0175:0000000','?','Les-M1-Slm1 EMS','?','Les-M1-Slm1 EMS',['Les-M1 Slm1 EMS'],'K17500').
genotype(176,176,'10R0176:0000000',176,'10R0176:0000000','Mo20W','Slm1/Slm1-M2 EMS','B73','B73',['Slm1-M2 EMS'],'K17600').
genotype(177,177,'10R0177:0000000',177,'10R0177:0000000','?','?','?','lls1',['lls1'],'K17700').
% genotype(178,178,'10R0178:0000000',178,'10R0178:0000000','?','new lls1 kind','?','new lls1 kind',['new lls1 kind'],'K17800').
genotype(178,178,'10R0178:0000000',178,'10R0178:0000000','?','lls1-nk','?','lls1-nk',['lls1-nk'],'K17800').
% genotype(179,179,'10R0179:0000000',179,'10R0179:0000000','?','tall br2 lls supp','?','tall br2 lls supp',['lls supp'],'K17900').
genotype(179,179,'10R0179:0000000',179,'10R0179:0000000','?','lls-sup','?','lls-sup',['lls-sup'],'K17900').
genotype(180,180,'10R0180:0000000',180,'10R0180:0000000','?','acd2','?','acd2',['acd2'],'K18000').
genotype(181,181,'10R0181:0000000',181,'10R0181:0000000','csp1','B73','csp1','B73',['csp1'],'K18100').
genotype(182,182,'10R0182:0000000',182,'10R0182:0000000','rm1','+','rm1','rm1',['rm1'],'K18200').
genotype(183,183,'10R0183:0000000',183,'10R0183:0000000','H95','B97','?','Rp1-D21',['Rp1-D21'],'K18300').
genotype(184,184,'10R0184:0000000',184,'10R0184:0000000','H95','CML228','?','Rp1-D21',['Rp1-D21'],'K18400').
genotype(185,185,'10R0185:0000000',185,'10R0185:0000000','H95','M37W','?','Rp1-D21',['Rp1-D21'],'K18500').
genotype(186,186,'10R0186:0000000',186,'10R0186:0000000','H95','Mo18W','?','Rp1-D21',['Rp1-D21'],'K18600').
genotype(187,187,'10R0187:0000000',187,'10R0187:0000000','B73','B73','?','H95:Rp1-Kr1n',['Rp1-Kr1n'],'K18700').
genotype(188,188,'10R0188:0000000',188,'10R0188:0000000','Mo20W','Mo20W','?','H95:Rp1-Kr1n',['Rp1-Kr1n'],'K18800').
genotype(189,189,'10R0189:0000000',189,'10R0189:0000000','Rp1-nc3','Mo20W','Mo20W','Mo20W',['Rp1-nc3'],'K18900').           








% from Damon Lisch

genotype(121,121,'09R0121:0000000',121,'09R0121:0000000','mop1/mop1','Les/-','B'' mop1','-',[mop1],'').   % 6415-3 x 6402-1
%
% family 122 segregated for a dominant lesion mutant.  I have called this 
% Les*-mi1 for now ("Les*-mop1-induced allele 1").  The symbolic genotype
% is that given by Lisch.
%
% Kazic, 4.12.09
%
% genotype(122,122,'09R0122:0000000',122,'09R0122:0000000','mop1/mop1','Les/-','mop1','+',['Les*-mi1'],'').   % 6415-19 x 6402-2

genotype(122,122,'09R0122:0000000',122,'09R0122:0000000','mop1','mop1','+','Les*-mi1',['Les*-mi1'],'').   % 6415-19 x 6402-2





% from Karen Cone, secretly via Miriam Hankins, Barb Sonderman, and Pam Cooper

genotype(123,123,'08G0123:0000000',123,'08G0123:0000000','McClintock full color','Pl-Rhoades','W22','W22',['Pl-Rhoades'],'').
genotype(124,124,'08G0124:0000000',124,'08G0124:0000000','920021','r-g','W22','Stock1',['W22'],'').






% from Ming Shu Huang in David Braun''s lab at Penn State; introgressed 6 times into B73

genotype(138,138,'09R0138:0000000',138,'09R0138:0000000','B73','B73',camo,'+',[camo],'K13800').






% from Mike Gerau

genotype(141,141,'09R0141:0000000',141,'09R0141:0000000','Hsf1','-','Hsf1','-',['Hsf1'],'K14100').
genotype(142,142,'09R0142:0000000',142,'09R0142:0000000','D8-N1591','','','',['D8-N1591'],'K14200').
genotype(143,143,'09R0143:0000000',143,'09R0143:0000000','D8-N1452','','','',['D8-N1452'],'K14300').
genotype(144,144,'09R0144:0000000',144,'09R0144:0000000','D9','-','N','mu sib',['D9'],'K14400').
genotype(145,145,'09R0145:0000000',145,'09R0145:0000000','D10','-','N','mu sib',['D10'],'K14500').
genotype(146,146,'09R0146:0000000',146,'09R0146:0000000','Tp1','-','mu','N',['Tp1'],'K14600').
genotype(147,147,'09R0147:0000000',147,'09R0147:0000000','Tp2','-','mu','N',['Tp2'],'K14700').







% from David Braun, U. of Missouri

genotype(190,190,'10R0190:0000000',190,'10R0190:0000000','B73','camo cf0-1','B73','camo cf0-1',['camo cf0-1'],'K19002').
genotype(191,191,'10R0191:0000000',191,'10R0191:0000000','B73','camo cf0-2','B73','camo cf0-2',['camo cf0-2'],'K19101').






% 11r

% from Jim Birchler, U. of Missouri

genotype(192,192,'11R0192:0000000',192,'11R0192:0000000','Idf B Pl','W22','Idf B Pl','W22',['Idf B Pl @'],'K19200').
genotype(193,193,'11R0193:0000000',193,'11R0193:0000000','Idf B Pl','W22','Idf B Pl','W22',['Idf B Pl sib'],'K19300').







% from Sherry Flint-Garcia and Susan Melia-Hancock, U. of Missouri
%
% NAM founders; these are treated as regular mutants (even though they''re inbreds) 
% except for B73, which is assigned family 500 and will be produced like Mo20W, W23, and M14
%
% Kazic, 10.4.2011

genotype(194,194,'11R0194:0000000',194,'11R0194:0000000','B97','B97','B97','B97',['B97'],'K19400').
genotype(195,195,'11R0195:0000000',195,'11R0195:0000000','CML103','CML103','CML103','CML103',['CML103'],'K19500').
genotype(196,196,'11R0196:0000000',196,'11R0196:0000000','CML228','CML228','CML228','CML228',['CML228'],'K19600').
genotype(197,197,'11R0197:0000000',197,'11R0197:0000000','CML247','CML247','CML247','CML247',['CML247'],'K19700').
genotype(198,198,'11R0198:0000000',198,'11R0198:0000000','CML277','CML277','CML277','CML277',['CML277'],'K19800').
genotype(199,199,'11R0199:0000000',199,'11R0199:0000000','CML322','CML322','CML322','CML322',['CML322'],'K19900').
genotype(600,600,'11R0600:0000000',600,'11R0600:0000000','CML333','CML333','CML333','CML333',['CML333'],'K60000').
genotype(601,601,'11R0601:0000000',601,'11R0601:0000000','CML52','CML52','CML52','CML52',['CML52'],'K60100').
genotype(602,602,'11R0602:0000000',602,'11R0602:0000000','CML69','CML69','CML69','CML69',['CML69'],'K60200').
genotype(603,603,'11R0603:0000000',603,'11R0603:0000000','HP301','HP301','HP301','HP301',['HP301'],'K60300').
genotype(604,604,'11R0604:0000000',604,'11R0604:0000000','IL144','IL144','IL144','IL144',['IL144'],'K60400').
genotype(605,605,'11R0605:0000000',605,'11R0605:0000000','Ki11','Ki11','Ki11','Ki11',['Ki11'],'K60500').
genotype(606,606,'11R0606:0000000',606,'11R0606:0000000','Ki3','Ki3','Ki3','Ki3',['Ki3'],'K60600').
genotype(607,607,'11R0607:0000000',607,'11R0607:0000000','Ki21','Ki21','Ki21','Ki21',['Ki21'],'K60700').
genotype(608,608,'11R0608:0000000',608,'11R0608:0000000','M162W','M162W','M162W','M162W',['M162W'],'K60800').
genotype(609,609,'11R0609:0000000',609,'11R0609:0000000','M37W','M37W','M37W','M37W',['M37W'],'K60900').
%
% Mo17, miserable in 11R
%
genotype(610,610,'11R0610:0000000',610,'11R0610:0000000','Mo17','Mo17','Mo17','Mo17',['Mo17'],'K61000').
genotype(629,610,'11R0610:0013804',610,'11R0610:0013801','Mo17','Mo17','Mo17','Mo17',['Mo17'],'K61001').
%
genotype(611,611,'11R0611:0000000',611,'11R0611:0000000','Mo18W','Mo18W','Mo18W','Mo18W',['Mo18W'],'K61100').
genotype(612,612,'11R0612:0000000',612,'11R0612:0000000','MS71','MS71','MS71','MS71',['MS71'],'K61200').
genotype(613,613,'11R0613:0000000',613,'11R0613:0000000','NC350','NC350','NC350','NC350',['NC350'],'K61300').
genotype(614,614,'11R0614:0000000',614,'11R0614:0000000','NC358','NC358','NC358','NC358',['NC358'],'K61400').
genotype(615,615,'11R0615:0000000',615,'11R0615:0000000','Oh43','Oh43','Oh43','Oh43',['Oh43'],'K61500').
genotype(616,616,'11R0616:0000000',616,'11R0616:0000000','Oh78','Oh78','Oh78','Oh78',['Oh78'],'K61600').
genotype(617,617,'11R0617:0000000',617,'11R0617:0000000','P39','P39','P39','P39',['P39'],'K61700').
genotype(618,618,'11R0618:0000000',618,'11R0618:0000000','Tx303','Tx303','Tx303','Tx303',['Tx303'],'K61800').
genotype(619,619,'11R0619:0000000',619,'11R0619:0000000','TZi8','TZi8','TZi8','TZi8',['TZi8'],'K61900').
%
% full packet note is W22R-r: Standard (Brink)
%
genotype(620,620,'11R0620:0000000',620,'11R0620:0000000','W22R-r: Standard (Brink)','W22R-r: Standard (Brink)','W22R-r: Standard (Brink)','W22R-r: Standard (Brink)',['W22R-r'],'K62000').






% from Alice Barkan''s group, the uniform Mu lines built by Karen Koch et alia.

genotype(621,621,'11R0621:0000000',621,'11R0621:0000000','GRMZM2G157354_T03','GRMZM2G157354_T03','GRMZM2G157354_T03','GRMZM2G157354_T03',['GRMZM2G157354_T03'],'K62100').

%
% not sure why this fails crop_management:compute_genotype/12, but since the genotype may not be correct anyway, I''m going to re-arrange
% it slightly.
%
genotype(622,622,'11R0622:0000000',622,'11R0622:0000000','L522-10','L522-10','new necrotic','new necrotic',['new necrotic'],'K62200').
%
% Kazic, 9.6.2012

% genotype(622,622,'11R0622:0000000',622,'11R0622:0000000','new necrotic','new necrotic','new necrotic','new necrotic',['new necrotic'],'K62200').






% from Chi-Ren Shyu, for Jason Green, but really from Guri Johal, for 11r

genotype(623,623,'11R0623:0000000',623,'11R0623:0000000','Tzi8','Tzi8','Rp1-D21:H95','Rp1-D21:H95',['Rp1-D21'],'K62300').
genotype(624,624,'11R0624:0000000',624,'11R0624:0000000','M162W','M162W','Rp1-D21:H95','Rp1-D21:H95',['Rp1-D21'],'K62400').
genotype(625,625,'11R0625:0000000',625,'11R0625:0000000','Tx303','Tx303','Rp1-D21:H95','Rp1-D21:H95',['Rp1-D21'],'K62500').
genotype(626,626,'11R0626:0000000',626,'11R0626:0000000','B97','B97','Rp1-D21:H95','Rp1-D21:H95',['Rp1-D21'],'K62600').
genotype(627,627,'11R0627:0000000',627,'11R0627:0000000','CML228','CML228','Rp1-D21:H95','Rp1-D21:H95',['Rp1-D21'],'K62700').






% new mutant found by Frank Baker in David Braun''s group; dominance is only tentatively assumed
%
% Kazic, 15.12.2011
%
% genotype(628,628,'11R0628:0000000',628,'11R0628:0000000','B73','B73','?','Les*-B1',['Les*-B1'],'K62805').
%
% Based on the lack of phenotype in 11n, I am provisionally calling this a recessive.
%
% Note that 11n had some conditional recessives, e.g., Les28.
%
% Kazic, 2.5.2012

genotype(628,628,'11R0628:0000000',628,'11R0628:0000000','B73','B73','?','les*-B1',['les*-B1'],'K62805').









    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% my main inbred lines %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

genotype(200,200,'06R200:S0Ixxxxx',200,'06R200:S0Ixxxxx','Mo20W','Mo20W','Mo20W','Mo20W',['Mo20W'],'').
genotype(300,300,'06R300:W0Ixxxxx',300,'06R300:W0Ixxxxx','W23','W23','W23','W23',['W23'],'').
genotype(400,400,'06R400:M0Ixxxxx',400,'06R400:M0Ixxxxx','M14','M14','M14','M14',['M14'],'').

genotype(201,200,'06R200:S0Ixxxxx',200,'06R200:S0Ixxxxx','Mo20W','Mo20W','Mo20W','Mo20W',['Mo20W'],'').
genotype(202,201,'06N201:S0xxxxxx',201,'06N201:S0xxxxxx','Mo20W','Mo20W','Mo20W','Mo20W',['Mo20W'],'').
genotype(203,201,'07R201:S0xxxxxx',201,'07R201:S0xxxxxx','Mo20W','Mo20W','Mo20W','Mo20W',['Mo20W'],'').
genotype(204,201,'08R201:S0xxxxxx',201,'08R201:S0xxxxxx','Mo20W','Mo20W','Mo20W','Mo20W',['Mo20W'],'').
genotype(205,201,'09R201:S0xxxxxx',201,'09R201:S0xxxxxx','Mo20W','Mo20W','Mo20W','Mo20W',['Mo20W'],'').
genotype(251,200,'06R200:S0Ixxxxx',200,'06R200:S0Iyyyyy','Mo20W','Mo20W','Mo20W','Mo20W',['Mo20W'],'').
genotype(252,201,'06N201:S0xxxxxx',201,'06N201:S0yyyyyy','Mo20W','Mo20W','Mo20W','Mo20W',['Mo20W'],'').
genotype(253,201,'07R201:S0xxxxxx',201,'07R201:S0yyyyyy','Mo20W','Mo20W','Mo20W','Mo20W',['Mo20W'],'').

genotype(301,300,'06R300:W0Ixxxxx',300,'06R300:W0Ixxxxx','W23','W23','W23','W23',['W23'],'').
genotype(302,301,'06N301:W0xxxxxx',301,'06N301:W0xxxxxx','W23','W23','W23','W23',['W23'],'').
genotype(303,301,'07R301:W0xxxxxx',301,'07R301:W0xxxxxx','W23','W23','W23','W23',['W23'],'').
genotype(304,301,'08R301:W0xxxxxx',301,'08R301:W0xxxxxx','W23','W23','W23','W23',['W23'],'').
genotype(305,301,'09R301:W0xxxxxx',301,'09R301:W0xxxxxx','W23','W23','W23','W23',['W23'],'').
genotype(351,300,'06R300:W0Ixxxxx',300,'06R300:W0Iyyyyy','W23','W23','W23','W23',['W23'],'').
genotype(352,301,'06N301:W0xxxxxx',301,'06N301:W0yyyyyy','W23','W23','W23','W23',['W23'],'').
genotype(353,301,'07R301:W0xxxxxx',301,'07R301:W0yyyyyy','W23','W23','W23','W23',['W23'],'').

genotype(401,400,'06R400:M0Ixxxxx',400,'06R400:M0Ixxxxx','M14','M14','M14','M14',['M14'],'').
genotype(402,401,'06N401:M0xxxxxx',401,'06N401:M0xxxxxx','M14','M14','M14','M14',['M14'],'').
genotype(403,401,'07R401:M0xxxxxx',401,'07R401:M0xxxxxx','M14','M14','M14','M14',['M14'],'').
genotype(404,403,'08R403:M0xxxxxx',403,'08R403:M0xxxxxx','M14','M14','M14','M14',['M14'],'').
genotype(405,401,'09R401:M0xxxxxx',401,'09R401:M0xxxxxx','M14','M14','M14','M14',['M14'],'').
genotype(451,400,'06R400:M0Ixxxxx',400,'06R400:M0Iyyyyy','M14','M14','M14','M14',['M14'],'').
genotype(452,401,'06N401:M0xxxxxx',401,'06N401:M0yyyyyy','M14','M14','M14','M14',['M14'],'').
genotype(453,401,'07R401:M0xxxxxx',401,'07R401:M0yyyyyy','M14','M14','M14','M14',['M14'],'').


% from Sherry Flint-Garcia; the B73 that founded the NAMs and was sequenced

genotype(500,500,'11R500:B0000000',500,'11R500:B0000000','B73','B73','B73','B73',['B73'],'').
genotype(501,500,'11R500:B0xxxxxx',500,'11R500:B0xxxxxx','B73','B73','B73','B73',['B73'],'').
genotype(502,501,'11N501:B0xxxxxx',501,'11N501:B0xxxxxx','B73','B73','B73','B73',['B73'],'').
genotype(503,501,'11R501:B0xxxxxx',501,'11R501:B0xxxxxx','B73','B73','B73','B73',['B73'],'').
% genotype(504,502,'11N502:B0000000',502,'11N502:B0000000','B73','B73','B73','B73',['B73'],'').
genotype(504,502,'11N502:B0xxxxxx',502,'11N502:B0xxxxxx','B73','B73','B73','B73',['B73'],'').
genotype(505,504,'13R504:B0xxxxxx',504,'13R504:B0xxxxxx','B73','B73','B73','B73',['B73'],'').





    
% David Braun''s B73 in 12r; per David, really from Cliff Weil

genotype(599,599,'12R599:B0000000',599,'12R599:B0000000','B73','B73','B73','B73',['B73'],'').







% crop improvement for inbred lines
%
% started in 11N
%
% For Mo20W, W23, and M14, nice (not neccessarily best or perfect) plants selected from
% families 205, 305, and 405, respectively, and chain-sibbed.  Individual ears retained.
%
% For B73, members of family 504 were selfed in 11N with very little selection and all 
% offspring pooled.  In 12R and subsequent crops, plants were selected and chain-sibbed,
% just like the other three lines.
%
%
% In 13R, offspring of these lines have 4 digit families and are filed among the mutants,
% since that''s the inventory sorting and scootching algorithms.
%
% Kazic, 19.11.2018
    

% genotype(630,205,'11N205:S0039102',205,'11N205:S0039104','Mo20W','Mo20W','Mo20W','Mo20W',['Mo20W'],'K20502').
genotype(631,205,'11N205:S0039105',205,'11N205:S0039104','Mo20W','Mo20W','Mo20W','Mo20W',['Mo20W'],'K20501').
genotype(632,205,'11N205:S0036301',205,'11N205:S0039906','Mo20W','Mo20W','Mo20W','Mo20W',['Mo20W'],'K20501').
genotype(633,205,'11N205:S0036311',205,'11N205:S0039906','Mo20W','Mo20W','Mo20W','Mo20W',['Mo20W'],'K20511').
genotype(634,205,'11N205:S0039906',205,'11N205:S0041108','Mo20W','Mo20W','Mo20W','Mo20W',['Mo20W'],'K20506').
genotype(635,305,'11N305:W0035011',305,'11N305:W0035001','W23','W23','W23','W23',['W23'],'K30511').
genotype(636,305,'11N305:W0039511',305,'11N305:W0039510','W23','W23','W23','W23',['W23'],'K30510').
genotype(637,305,'11N305:W0042506',305,'11N305:W0041604','W23','W23','W23','W23',['W23'],'K30506').
genotype(638,305,'11N305:W0041604',305,'11N305:W0041605','W23','W23','W23','W23',['W23'],'K30504').
genotype(639,305,'11N305:W0041605',305,'11N305:W0042505','W23','W23','W23','W23',['W23'],'K30505').
genotype(640,405,'11N405:M0040806',405,'11N405:M0039606','M14','M14','M14','M14',['M14'],'K40506').
genotype(641,405,'11N405:M0040901',405,'11N405:M0040806','M14','M14','M14','M14',['M14'],'K40501').



% really, giving these next three-digit family numbers was a mistake: since they descend
% from the real founders 631--641, they should have four digit family numbers so that
% the pedigrees are properly computed.
%
% the work-around is to simply exclude the following family numbers in the definition of
% genetic_utilities:founder/9:  655--664.
    

genotype(655,632,'12R632:S0013004',634,'12R634:S0013213','Mo20W','Mo20W','Mo20W','Mo20W',['Mo20W'],'K20506').
genotype(656,633,'12R633:S0013113',632,'12R632:S0013006','Mo20W','Mo20W','Mo20W','Mo20W',['Mo20W'],'K20501').
genotype(657,638,'12R638:W0013616',637,'12R637:W0013509','W23','W23','W23','W23',['W23'],'K30506').
genotype(658,637,'12R637:W0013515',639,'12R639:W0013711','W23','W23','W23','W23',['W23'],'K30505').
genotype(659,640,'12R640:M0013801',641,'12R641:M0013907','M14','M14','M14','M14',['M14'],'K40506').
genotype(660,641,'12R641:M0013902',640,'12R640:M0013801','M14','M14','M14','M14',['M14'],'K40506').
genotype(661,641,'12R641:M0013907',640,'12R640:M0013807','M14','M14','M14','M14',['M14'],'K40506').
genotype(662,641,'12R641:M0013903',640,'12R640:M0013802','M14','M14','M14','M14',['M14'],'K40506').
genotype(663,504,'12R504:B0014106',504,'12R504:B0014007','B73','B73','B73','B73',['B73'],'K50407').
genotype(664,504,'12R504:B0014007',504,'12R504:B0014103','B73','B73','B73','B73',['B73'],'K50403').













% mutants in David Braun''s 12R field 19.  These were sent by Cliff Weil after selfing the M1s or M2s.
% Probably in or back-crossed to B73.  The mutants were generated by EMS on pollen, probably by Gerry.
%
% I am using the 12R plant as the paternal forebear and a zeroed plantid, same family number,
% as the maternal forebear.  My rationale is that I don''t know the pedigrees of what was planted,
% but these are distinct from successful selves I obtained in David''s corn, and I still need
% to identify the offspring of individual plants.
%
% Kazic, 25.10.2012

% iojap striping
%
genotype(642,642,'12R0642:0000000',642,'12R0642:0132014','?','ij-like','?','ij-like',['ij-like'],'K64214').


% no image --- assign a better descriptor based on offspring later
%
genotype(643,643,'12R0643:0000000',643,'12R0643:0132211','?','unk','?','unk',['unk'],'K64311').


% no image --- assign a better descriptor based on offspring later
%
genotype(644,644,'12R0644:0000000',644,'12R0644:0132303','?','unk','?','unk',['unk'],'K64403').



% no images for these next two --- assign better descriptors based on offspring later
%
genotype(645,645,'12R0645:0000000',645,'12R0645:0132309','?','unk','?','unk',['unk'],'K64509').
genotype(646,646,'12R0646:0000000',646,'12R0646:0132313','?','unk','?','unk',['unk'],'K64613').





% no image --- assign a better descriptor based on offspring later
%
genotype(647,647,'12R0647:0000000',647,'12R0647:0133203','?','unk','?','unk',['unk'],'K64703').



% oscillating large white/light green chloroses
%
genotype(648,648,'12R0648:0000000',648,'12R0648:0133407','?','osc lg wh/lg chl','?','osc lg wh/lg chl',['osc lg wh/lg chl'],'K64807').
genotype(649,649,'12R0649:0000000',649,'12R0649:0133414','?','osc lg wh/lg chl','?','osc lg wh/lg chl',['osc lg wh/lg chl'],'K64914').
genotype(650,650,'12R0650:0000000',650,'12R0650:0133416','?','osc lg wh/lg chl','?','osc lg wh/lg chl',['osc lg wh/lg chl'],'K65016').



% large yellow/green interveinal streaks, possible diurnal striping
%
genotype(651,651,'12R0651:0000000',651,'12R0651:0133509','?','lg y/g interveinal streaks','?','lg y/g interveinal streaks',['lg y/g interveinal streaks'],'K65109').
genotype(652,652,'12R0652:0000000',652,'12R0652:0133511','?','lg y/g interveinal streaks','?','lg y/g interveinal streaks',['lg y/g interveinal streaks'],'K65211').
genotype(653,653,'12R0653:0000000',653,'12R0653:0133513','?','lg y/g interveinal streaks','?','lg y/g interveinal streaks',['lg y/g interveinal streaks'],'K65313').


% diffuse white necroses
%
genotype(654,654,'12R0654:0000000',654,'12R0654:0134713','?','diff wh nec','?','diff wh nec',['diff wh nec'],'K65413').



% possible lesion mimics
%
genotype(665,665,'12R0665:0000000',665,'12R0665:0133415','?','possible lesion mimic; EMS?','?','possible lesion mimic; EMS?',['possible lesion mimic; EMS?'],'K66515').
genotype(666,666,'12R0666:0000000',666,'12R0666:0133204','?','possible lesion mimic; EMS?','?','possible lesion mimic; EMS?',['possible lesion mimic; EMS?'],'K66604').















% from Peter Balint-Kurti, April 2015:  interesting lines he thinks I''ll enjoy

genotype(667,667,'15R0667:0000000',667,'15R0667:0000000','CML333','CML333','B73 NIL-1002','B73 NIL-1002/les*-R1-1',['les*-R1-1'],'K66700').
genotype(668,668,'15R0668:0000000',668,'15R0668:0000000','CML333','CML333','B73 NIL-1002','B73 NIL-1002/les*-R2-1',['les*-R2-1'],'K66800').
genotype(669,669,'15R0669:0000000',669,'15R0669:0000000','CML333','CML333','B73 NIL-1007','B73 NIL-1007/les*-R3-1',['les*-R3-1'],'K66900').
genotype(670,670,'15R0670:0000000',670,'15R0670:0000000','CML333','CML333','B73 NIL-1007','B73 NIL-1007/les*-R4-1',['les*-R4-1'],'K67000').
genotype(671,671,'15R0671:0000000',671,'15R0671:0000000','Ki11','Ki11','B73 NIL-1103','B73 NIL-1103/les*-R5-1',['les*-R5-1'],'K67100').
genotype(672,672,'15R0672:0000000',672,'15R0672:0000000','Ki11','Ki11','B73 NIL-1104','B73 NIL-1104/les*-R6-1',['les*-R6-1'],'K67200').
genotype(673,673,'15R0673:0000000',673,'15R0673:0000000','Mo18W','Mo18W','B73 NIL-1020B','B73 NIL-1020B/les*-R7-2',['les*-R7-2'],'K67300').
genotype(674,674,'15R0674:0000000',674,'15R0674:0000000','NC350','NC350','B73 NIL-1004','B73 NIL-1004/les*-R8-2',['les*-R8-2'],'K67400').
genotype(675,675,'15R0675:0000000',675,'15R0675:0000000','Tzi8','Tzi8','B73 NIL-1304','B73 NIL-1304/les*-R9-2',['les*-R9-2'],'K67500').
genotype(676,676,'15R0676:0000000',676,'15R0676:0000000','Tzi8','Tzi8','B73 NIL-1337','B73 NIL-1337/les*-R10-2',['les*-R10-2'],'K67600').
genotype(677,677,'15R0677:0000000',677,'15R0677:0000000','Tzi8','Tzi8','B73 NIL-1337','B73 NIL-1337/les*-R11-2',['les*-R11-2'],'K67700').
genotype(678,678,'15R0678:0000000',678,'15R0678:0000000','NC262','Oh7B BC3F4:5 Entry 155','Oh7B F2','Oh7B F2/les*-R168-1',['les*-R168-1'],'K67800').
genotype(679,679,'15R0679:0000000',679,'15R0679:0000000','NC262','Oh7B BC3F4:5 Entry 155','Oh7B F2','Oh7B F2/les*-R168-2',['les*-R168-2'],'K67900').
genotype(680,680,'15R0680:0000000',680,'15R0680:0000000','NC262','Oh7B BC3F4:5 Entry 155','Oh7B F2','Oh7B F2/les*-R169-1',['les*-R169-1'],'K68000').
genotype(681,681,'15R0681:0000000',681,'15R0681:0000000','NC262/Oh7B BC3F4:5 Entry 155','les*-R170-1','NC262/Oh7B BC3F4:5 Entry 155','les*-R170-1',['les*-R170-1'],'K68100').
genotype(682,682,'15R0682:0000000',682,'15R0682:0000000','NC262/Oh7B BC3F4:5 Entry 155','les*-R171-1','NC262/Oh7B BC3F4:5 Entry 155','les*-R171-1',['les*-R171-1'],'K68200').
genotype(683,683,'15R0683:0000000',683,'15R0683:0000000','NC262/Oh7B BC3F4:5 Entry 155','les*-R171-3','NC262/Oh7B BC3F4:5 Entry 155','les*-R171-3',['les*-R171-3'],'K68300').
genotype(684,684,'15R0684:0000000',684,'15R0684:0000000','NC262/Oh7B BC3F4:5 Entry 155','les*-R172-1','NC262/Oh7B BC3F4:5 Entry 155','les*-R172-1',['les*-R172-1'],'K68400').




% from Marty Sachs of MGCSC:  new versions of Les5 and Les20.  
% Separately accessioned since there''s no guarantee they''re the same as the previous ones.
%
% May, 2015


genotype(685,685,'15R0685:0000000',685,'15R0685:0000000','2007-942-1','+/les5-N1449','2007-942-1','+/les5-N1449',['les5-N1449'],'K68500').
genotype(686,686,'15R0686:0000000',686,'15R0686:0000000','W23','L317','+','Les20-N2459',['Les20-N2459'],'K68600').







% from Candy Gardner, doubled haploids for 16r    

    
genotype(687,687,'16R0687:0000000',687,'16R0687:0000000','ALTIPLANO BOV903','PHZ51','PHZ51','PHZ51',['#002-(2n)-003-001-001-B'],'K68700').
genotype(688,688,'16R0688:0000000',688,'16R0688:0000000','ANCASHINO ANC102','PHB47','PHB47','PHB47',['#002-(2n)-001-002-B'],'K68800').
genotype(689,689,'16R0689:0000000',689,'16R0689:0000000','BOFO DGO123','PHB47','PHB47','PHB47',['#002-(2n)-003-001-B'],'K68900').
genotype(690,690,'16R0690:0000000',690,'16R0690:0000000','CON NORT ZAC161','PHB47','PHB47','PHB47',['#005-(2n)-001-001-B'],'K69000').
genotype(691,691,'16R0691:0000000',691,'16R0691:0000000','CRISTALINO AMAR AR21004','PHB47','PHB47','PHB47',['#001-(2n)-002-001-B'],'K69100').
genotype(692,692,'16R0692:0000000',692,'16R0692:0000000','CRISTALINO AMAR AR21004','PHB47','PHB47','PHB47',['#005-(2n)-003-001-B'],'K69200').
genotype(693,693,'16R0693:0000000',693,'16R0693:0000000','CUZCO CUZ217','PHZ51','PHZ51','PHZ51',['#002-(2n)-001-001-B'],'K69300').
genotype(694,694,'16R0694:0000000',694,'16R0694:0000000','ONAVENO SON24','PHB47','PHB47','PHB47',['#004-(2n)-001-001-B'],'K69400').
genotype(695,695,'16R0695:0000000',695,'16R0695:0000000','PATILLO GRANDE BOV649','PHZ51','PHZ51','PHZ51',['#006-(2n)-003-001-B'],'K69500').
genotype(696,696,'16R0696:0000000',696,'16R0696:0000000','PATILLO GRANDE BOV649','PHB47','PHB47','PHB47',['#006-(2n)-001-001-B'],'K69600').
genotype(697,697,'16R0697:0000000',697,'16R0697:0000000','BR105','N(PHZ51)','N(PHZ51)','N(PHZ51)',['(2n)-003-001-B'],'K69700').
genotype(698,698,'16R0698:0000000',698,'16R0698:0000000','Tehua - CHS29','PHB47 B','PHB47','PHB47',['(2n)-003-001-B'],'K69800').
genotype(699,699,'16R0699:0000000',699,'16R0699:0000000','YUCATAN TOL389 ICA','PHZ51','PHZ51','PHZ51',['#005-(2n)-002-001-001-B'],'K69900').
genotype(700,700,'16R0700:0000000',700,'16R0700:0000000','YUNGUENO BOV362','PHZ51','PHZ51','PHZ51',['#005-(2n)-002'],'K70000').
genotype(701,701,'16R0701:0000000',701,'16R0701:0000000','YUNGUENO BOV362','PHZ51','PHZ51','PHZ51',['#006-(2n)-002-001-B'],'K70100').
genotype(702,702,'16R0702:0000000',702,'16R0702:0000000','Cateto Nortista - GIN I','PHB47 B','PHB47','PHB47',['(2n)-002-001-B'],'K70200').


% 703 foo
% this is the possible dominant or contaminant les23. I have changed it''s family
% number from 4477 to 703 so it can be a founder and its pedigree built.    
%
% genotype fact for 4477 commented out; other phenotypes from that
% line were given new family numbers per 
% ../../crops/17r/management/new_genotypes.org
%
% All this may throw errors in identify_row/3.
% 
%
% K is now K70309
%
% Kazic, 4.6.2018
%
%
% This appeared in a les23 line and may be a dominant les23, but
% there is no direct evidence for that.  So for now, it is denoted
% Les*-tk1.
%
% Kazic, 20.5.2018
    
genotype(703,305,'15R305:W0000908',4373,'15R4373:0007409','W23','W23','M14','Les*-tk1',['Les*-tk1'],'K70309').    

    



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% my lines %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


genotype(1000,200,'06R200:S00I0608',1,'06R0001:0000104','Mo20W','Mo20W','Mo20W/+','Mo20W/Les1',['Les1'],'K0104').
genotype(1001,37,'06R0037:0003706',37,'06R0037:0003709','Les2 NonExp/?','?','?','?/Les2 Exp',['Les2 Exp'],'K3709').
genotype(1002,37,'06R0037:0003714',37,'06R0037:0003708','Les2 NonExp/?','?','?','?/Les2 Exp',['Les2 Exp'],'K3708').
genotype(1005,200,'06R200:S00I1606',5,'06R0005:0000509','Mo20W','Mo20W','Mo20W/+','Mo20W/Les7',['Les7'],'K0509').
genotype(1006,39,'06R0039:0003901',39,'06R0039:0003907','Les5 Exp???/?','?','Les5 Exp???/?','?',['Les5 Exp???'],'K3907').
genotype(1007,200,'06R200:S00I2213',7,'06R0007:0000707','Mo20W','Mo20W','Mo20W/+','Mo20W/Les9',['Les9'],'K0707').
genotype(1010,200,'06R200:S00I1608',1,'06R0001:0000104','Mo20W','Mo20W','Mo20W/+','Mo20W/Les1',['Les1'],'K0104').
genotype(1011,200,'06R200:S00I6614',3,'06R0003:0000304','Mo20W','Mo20W','Mo20W/+','Mo20W/Les4',['Les4'],'K0304').
genotype(1012,2,'06R0002:0000208',2,'06R0002:0000207','Mo20W/+','Mo20W/+','Mo20W/+','Mo20W/Les2',['Les2'],'K0207').
genotype(1014,200,'06R200:S00I5620',10,'06R0010:0001001','Mo20W','Mo20W','Mo20W/+','Mo20W/Les12',['Les12'],'K1001').
genotype(1015,3,'06R0003:0000308',3,'06R0003:0000303','Mo20W/+','Mo20W/+','Mo20W/+','Mo20W/Les4',['Les4'],'K0303').
genotype(1018,5,'06R0005:0000504',5,'06R0005:0000508','Mo20W/+','Mo20W/+','Mo20W/+','Mo20W/Les7',['Les7'],'K0508').
genotype(1022,6,'06R0006:0000614',6,'06R0006:0000610','Mo20W/+','Mo20W/+','Mo20W/+','Mo20W/Les8',['Les8'],'K0610').
genotype(1023,7,'06R0007:0000711',7,'06R0007:0000709','Mo20W/+','Mo20W/+','Mo20W/+','Mo20W/Les9',['Les9'],'K0709').
genotype(1024,8,'06R0008:0000803',8,'06R0008:0000801','Mo20W/+','Mo20W/+','Mo20W/+','Mo20W/Les10',['Les10'],'K0801').
genotype(1026,40,'06R0040:0004004',40,'06R0040:0004005','Les6 NonExp/?','?/Les6 Exp','Les6 NonExp/?','?/Les6 Exp',['Les6 Exp'],'K4005').
genotype(1027,40,'06R0040:0004010',40,'06R0040:0004007','Les6 NonExp/?','?/Les6 Exp','Les6 NonExp/?','?/Les6 Exp',['Les6 Exp'],'K4007').
genotype(1028,40,'06R0040:0004002',40,'06R0040:0004001','Les6 NonExp/?','?/Les6 Exp','Les6 NonExp/?','?/Les6 Exp',['Les6 Exp'],'K4001').
genotype(1029,11,'06R0011:0001104',11,'06R0011:0001101','Mo20W/+','Mo20W/+','Mo20W/+','Mo20W/Les13',['Les13'],'K1101').
genotype(1030,11,'06R0011:0001114',11,'06R0011:0001110','Mo20W/+','Mo20W/+','Mo20W/+','Mo20W/Les13',['Les13'],'K1110').
genotype(1031,11,'06R0011:0001108',11,'06R0011:0001103','Mo20W/+','Mo20W/+','Mo20W/+','Mo20W/Les13',['Les13'],'K1103').
genotype(1032,11,'06R0011:0001107',11,'06R0011:0001109','Mo20W/+','Mo20W/+','Mo20W/+','Mo20W/Les13',['Les13'],'K1109').
genotype(1036,13,'06R0013:0001306',13,'06R0013:0001309','Mo20W/+','Mo20W/+','Mo20W/+','Mo20W/Les17',['Les17'],'K1309').
genotype(1037,13,'06R0013:0001301',13,'06R0013:0001305','Mo20W/+','Mo20W/+','Mo20W/+','Mo20W/Les17',['Les17'],'K1305').
genotype(1040,14,'06R0014:0001412',14,'06R0014:0001411','Mo20W/+','Mo20W/+','Mo20W/+','Mo20W/Les18',['Les18'],'K1411').
genotype(1042,15,'06R0015:0001505',15,'06R0015:0001506','Mo20W/+','Mo20W/+','Mo20W/+','Mo20W/Les19',['Les19'],'K1506').
genotype(1043,15,'06R0015:0001502',15,'06R0015:0001501','Mo20W/+','Mo20W/+','Mo20W/+','Mo20W/Les19',['Les19'],'K1501').
genotype(1044,15,'06R0015:0001503',15,'06R0015:0001511','Mo20W/+','Mo20W/+','Mo20W/+','Mo20W/Les19',['Les19'],'K1511').
genotype(1045,16,'06R0016:0001601',16,'06R0016:0001601','Mo20W/+','Mo20W/+','Mo20W/+','Mo20W/Les21',['Les21'],'K1601').
genotype(1046,41,'06R0041:0004114',41,'06R0041:0004109','Les7 NonExp/?','?/Les7 Exp','Les7 NonExp/?','?/Les7 Exp',['Les7 Exp'],'K4109').
genotype(1048,41,'06R0041:0004109',41,'06R0041:0004101','Les7 NonExp/?','?/Les7 Exp','?','?/Les7 Exp',['Les7 Exp'],'K4101').
genotype(1050,17,'06R0017:0001708',17,'06R0017:0001702','Mo20W/+','Mo20W/lls1','Mo20W/+','Mo20W/lls1',[lls1],'K1702').
genotype(1051,17,'06R0017:0001707',17,'06R0017:0001708','Mo20W/+','Mo20W/{+|lls1}','Mo20W/+','Mo20W/{+|lls1}',[lls1],'K1708').
genotype(1052,200,'06R200:S00I7203',14,'06R0014:0001411','Mo20W','Mo20W','Mo20W/+','Mo20W/Les18',['Les18'],'K1411').
genotype(1053,200,'06R200:S00I7210',15,'06R0015:0001511','Mo20W','Mo20W','Mo20W/+','Mo20W/Les19',['Les19'],'K1511').
genotype(1054,200,'06R200:S00I7205',15,'06R0015:0001504','Mo20W','Mo20W','Mo20W/+','Mo20W/Les19',['Les19'],'K1504').
genotype(1055,200,'06R200:S00I7207',15,'06R0015:0001506','Mo20W','Mo20W','Mo20W/+','Mo20W/Les19',['Les19'],'K1506').
genotype(1056,200,'06R200:S00I7211',17,'06R0017:0001701','Mo20W','Mo20W','Mo20W/+','Mo20W/{+|lls1}',[lls1],'K1701').
genotype(1057,200,'06R200:S00I7212',18,'06R0018:0001802','Mo20W','Mo20W','Mo20W/+','Mo20W/les23',[les23],'K1802').
genotype(1058,41,'06R0041:0004107',41,'06R0041:0004108','Les7 NonExp/?','?/Les7 Exp','Les7 NonExp/?','?/Les7 Exp',['Les7 Exp'],'K4108').
genotype(1059,41,'06R0041:0004102',41,'06R0041:0004106','Les7 NonExp/?','?/Les7 Exp','Les7 NonExp/?','?/Les7 Exp',['Les7 Exp'],'K4106').
genotype(1060,41,'06R0041:0004110',41,'06R0041:0004107','Les7 NonExp/?','?/Les7 Exp','Les7 NonExp/?','?/Les7 Exp',['Les7 Exp'],'K4107').
genotype(1061,42,'06R0042:0004207',42,'06R0042:0004209','Les8 NonExp/?','?/Les8 Exp','Les8 NonExp/?','?/Les8 Exp',['Les8 Exp'],'K4209').
genotype(1062,44,'06R0044:0004406',44,'06R0044:0004407','Les10 NonExp/?','?/Les10 Exp','Les10 NonExp/?','?/Les10 Exp',['Les10 Exp'],'K4407').
genotype(1063,45,'06R0045:0004506',45,'06R0045:0004510','Les11 NonExp/?','?/Les11 Exp??','Les11 NonExp/?','?/Les11 Exp??',['Les11 Exp??'],'K4510').
genotype(1064,46,'06R0046:0004608',46,'06R0046:0004603','Les12 NonExp/?','?/Les12 Exp','Les12 NonExp/?','?/Les12 Exp',['Les12 Exp'],'K4603').
genotype(1065,46,'06R0046:0004609',46,'06R0046:0004611','Les12 NonExp/?','?/Les12 Exp','Les12 NonExp/?','?/Les12 Exp',['Les12 Exp'],'K4611').
genotype(1066,47,'06R0047:0004702',47,'06R0047:0004707','Les15 NonExp/?','?/Les15 Exp','Les15 NonExp/?','?/Les15 Exp',['Les15 Exp'],'K4707').
genotype(1067,47,'06R0047:0004706',47,'06R0047:0004704','Les15 NonExp/?','?/Les15 Exp','Les15 NonExp/?','?/Les15 Exp',['Les15 Exp'],'K46704').
genotype(1068,48,'06R0048:0004809',48,'06R0048:0004806','Les17/?','?','Les17/?','?',['Les17 Exp?'],'K4806').
genotype(1069,49,'06R0049:0004905',49,'06R0049:0004901','Les18 NonExp/?','?/Les18 Exp','Les18 NonExp/?','?/Les18 Exp',['Les18 Exp'],'K4901').
genotype(1070,200,'06R200:S00I7909',40,'06R0040:0004005','Mo20W','Mo20W','Les6 NonExp/?','?/Les6 Exp',['Les6 Exp'],'K4005').
genotype(1071,200,'06R200:S00I6804',103,'06R0103:0010307','Mo20W','Mo20W','ij2-N8','ij2-N8',['ij2-N8'],'K10307').
genotype(1072,200,'06R200:S00I1007',38,'06R0038:0003806','Mo20W','Mo20W','Les4 NonExp/?','?/Les4 Exp',['Les4 Exp'],'K3806').
genotype(1073,200,'06R200:S00I1011',40,'06R0040:0004003','Mo20W','Mo20W','Les6 NonExp/?','?/Les6 Exp',['Les6 Exp'],'K4003').
genotype(1074,200,'06R200:S00I2210',54,'06R0054:0005401','Mo20W','Mo20W','{B73 Ht1|+}/{?|+}','+/Les1-N843',['Les1-N843'],'K5401').
genotype(1075,300,'06R300:W00I0815',40,'06R0040:0004003','W23','W23','Les6 NonExp/?','?/Les6 Exp',['Les6 Exp'],'K4003').
genotype(1076,300,'06R300:W00I9208',47,'06R0047:0004707','W23','W23','Les15 NonExp/?','?/Les15 Exp',['Les15 Exp'],'K4707').
genotype(1077,300,'06R300:W00I6904',54,'06R0054:0005404','W23','W23','{B73 Ht1|+}/{?|+}','+/Les1-N843',['Les1-N843'],'K5406').
genotype(1078,300,'06R300:W00I3501',54,'06R0054:0005401','W23','W23','{B73 Ht1|+}/{?|+}','+/Les1-N843',['Les1-N843'],'K5404').
genotype(1079,300,'06R300:W00I3207',54,'06R0054:0005401','W23','W23','{B73 Ht1|+}/{?|+}','+/Les1-N843',['Les1-N843'],'K5401').
genotype(1080,400,'06R400:M00I3301',54,'06R0054:0005406','M14','M14','{B73 Ht1|+}/{?|+}','+/Les1-N843',['Les1-N843'],'K5406').
genotype(1081,400,'06R400:M00I3308',103,'06R0103:0010307','M14','M14','ij2-N8','ij2-N8',['ij2-N8'],'K10307').
genotype(1082,400,'06R400:M00I9603',47,'06R0047:0004707','M14','M14','Les15 NonExp/?','?/Les15 Exp',['Les15 Exp'],'K4707').
genotype(1083,400,'06R400:M00I7002',54,'06R0054:0005401','M14','M14','{B73 Ht1|+}/{?|+}','+/Les1-N843',['Les1-N843'],'K5401').
genotype(1084,400,'06R400:M00I5403',36,'06R0036:0003601','M14','M14','Les1 NonExp/?','?/Les1 Exp',['Les1 Exp'],'K3601').
genotype(1085,400,'06R400:M00I0602',40,'06R0040:0004003','M14','M14','Les6 NonExp/?','?/Les6 Exp',['Les6 Exp'],'K4003').
genotype(1086,200,'06R200:S00I2209',78,'06R0078:0007807','Mo20W','Mo20W','les*-N2013','les*-N2013',['les*-N2013'],'K7807').
genotype(1087,200,'06R200:S00I0403',78,'06R0078:0007801','Mo20W','Mo20W','les*-N2013','les*-N2013',['les*-N2013'],'K7801').
genotype(1088,200,'06R200:S00I0113',78,'06R0078:0007808','Mo20W','Mo20W','les*-N2013','les*-N2013',['les*-N2013'],'K7808').
genotype(1089,400,'06R400:M0I10901',78,'06R0078:0007807','M14','M14','les*-N2013','les*-N2013',['les*-N2013'],'K7807').
genotype(1090,200,'06R200:S00I2609',82,'06R0082:0008203','Mo20W','Mo20W','{(B73/AG32)|(Ht1/les*-N2333A)}','{(B73/AG32)|(Ht1/les*-N2333A)}',['les*-N2333A'],'K8203').
genotype(1091,200,'06R200:S00I3403',82,'06R0082:0008211','Mo20W','Mo20W','{(B73/AG32)|(Ht1/les*-N2333A)}','{(B73/AG32)|(Ht1/les*-N2333A)}',['les*-N2333A'],'K8211').
genotype(1092,400,'06R400:M00I2903',82,'06R0082:0008203','M14','M14','{(B73/AG32)|(Ht1/les*-N2333A)}','{(B73/AG32)|(Ht1/les*-N2333A)}',['les*-N2333A'],'K8203').
genotype(1093,400,'06R400:M00I9003',82,'06R0082:0008211','M14','M14','{(B73/AG32)|(Ht1/les*-N2333A)}','{(B73/AG32)|(Ht1/les*-N2333A)}',['les*-N2333A'],'K8211').
genotype(1094,400,'06R400:M00I3610',101,'06R0101:0010101','M14','M14',ht4,ht4,[ht4],'K10101').
genotype(1095,400,'06R400:M00I3602',102,'06R0102:0010210','M14','M14','Htn1 ^W22','Htn1 ^W22',['Htn1'],'K10210').
genotype(1096,400,'06R400:M0I10708',102,'06R0102:0010206','M14','M14','Htn1 ^W22','Htn1 ^W22',['Htn1'],'K10206').
genotype(1097,200,'06R200:S00I2502',112,'06R0112:0011201','Mo20W','Mo20W',zn1,zn1,[zn1],'K11201').
genotype(1098,200,'06R200:S00I2508',112,'06R0112:0011211','Mo20W','Mo20W',zn1,zn1,[zn1],'K11211').
genotype(1099,200,'06R200:S00I3702',112,'06R0112:0011208','Mo20W','Mo20W',zn1,zn1,[zn1],'K11208').
genotype(1100,200,'06R200:S00I3705',112,'06R0112:0011206','Mo20W','Mo20W',zn1,zn1,[zn1],'K11206').
genotype(1101,200,'06R200:S00I3701',112,'06R0112:0011209','Mo20W','Mo20W',zn1,zn1,[zn1],'K11209').
%
% See /athe/c/maize/data/reinventory/resolution_weird_cases.org for details.
%
% this family is duplicated by family 1527, just by inserting a 0 between the I and 8 in ma.
% Since the tag was replaced during new inventory, this family is retired.  Neither family has
% offspring.  
%
% Kazic, 31.5.2014
%
% genotype(1102,300,'06R300:W000I810',112,'06R0112:0011205','W23','W23',zn1,zn1,[zn1],'K11205').
%
genotype(1103,300,'06R300:W00I0805',112,'06R0112:0011201','W23','W23',zn1,zn1,[zn1],'K11201').
genotype(1104,400,'06R400:M00I7407',112,'06R0112:0011208','M14','M14',zn1,zn1,[zn1],'K11208').
genotype(1105,400,'06R400:M00I0907',112,'06R0112:0011205','M14','M14',zn1,zn1,[zn1],'K11205').
genotype(1106,400,'06R400:M00I0903',112,'06R0112:0011201','M14','M14',zn1,zn1,[zn1],'K11201').
genotype(1107,400,'06R400:M00I0909',112,'06R0112:0011211','M14','M14',zn1,zn1,[zn1],'K11211').

genotype(1109,201,'07R201:S0000101',2354,'07R2354:0040306','Mo20W','Mo20W','Mo20W','Les4',['Les4'],'K0303').
genotype(1110,200,'06R200:S00I6602',76,'06R0076:0007616','Mo20W','Mo20W','{+|Les*-N1450}','{+|Les*-N1450}',['Les*-N1450'],'K7616').
genotype(1111,64,'06R0064:0006403',64,'06R0064:0006405','W23/M14','+','W23/M14','+/Les11-N1438',['Les11-N1438'],'K6405').
genotype(1112,200,'06R200:S00I2607',77,'06R0077:0007708','Mo20W','Mo20W','{+|les*-N2012}','{+|les*-N2012}',['les*-N2012'],'K7708').
genotype(1113,68,'06R0068:0006808',68,'06R0068:0006811','W23/M14','+','W23/M14','+/Les17-N2345',['Les17-N2345'],'K6811').
genotype(1114,69,'06R0069:0006913',69,'06R0069:0006906','W23/M14','+','W23/M14','+/Les18-N2441',['Les18-N2441'],'K6906').
genotype(1115,70,'06R0070:0007013',70,'06R0070:0007011','W23/M14','+','W23/M14','+/Les19-N2450',['Les19-N2450'],'K7011').
genotype(1116,70,'06R0070:0007008',70,'06R0070:0007004','W23/M14','+','W23/M14','+/Les19-N2450',['Les19-N2450'],'K7004').
genotype(1117,72,'06R0072:0007210',72,'06R0072:0007207','B73 Ht1/?','+','B73 Ht1/?','+/Les21-N1442',['Les21-N1442'],'K7207').
genotype(1118,72,'06R0072:0007201',72,'06R0072:0007205','B73 Ht1/?','+','B73 Ht1/?','+/Les21-N1442',['Les21-N1442'],'K7205').
genotype(1119,74,'06R0074:0007401',74,'06R0074:0007408','CM105/Oh43E','+','CM105/Oh43E','+/Les*-N1378',['Les*-N1378'],'K7408').
genotype(1120,200,'06R200:S00I4002',105,'06R0105:0010502','Mo20W','Mo20W/+','{+|lls1-N501B}','{+|lls1-N501B}',['lls1-N501B'],'K10502').
genotype(1121,200,'06R200:S00I6810',54,'06R0054:0005404','Mo20W','Mo20W/+','{B73 Ht1|+}/{?|+}','+/Les1-N843',['Les1-N843'],'K5404').
genotype(1122,200,'06R200:S00I5602',55,'06R0055:0005509','Mo20W','Mo20W','Les2-N845A/+','M14/W23',['Les2-N845A'],'K5509').
genotype(1123,200,'06R200:S00I9705',55,'06R0055:0005515','Mo20W','Mo20W','Les2-N845A/+','M14/W23',['Les2-N845A'],'K5515').
genotype(1124,200,'06R200:S00I4806',55,'06R0055:0005501','Mo20W','Mo20W','Les2-N845A/+','M14/W23',['Les2-N845A'],'K5501').
genotype(1125,200,'06R200:S00I5612',61,'06R0061:0006114','Mo20W','Mo20W','W23/L317','+/Les8-N2005',['Les8-N2005'],'K6114').
genotype(1126,200,'06R200:S00I9803',61,'06R0061:0006106','Mo20W','Mo20W','W23/L317','+/Les8-N2005',['Les8-N2005'],'K6106').
genotype(1127,200,'06R200:S00I5615',62,'06R0062:0006206','Mo20W','Mo20W','(M14/W23)/+','(M14/W23)/Les9-N2008',['Les9-N2008'],'K6206').
genotype(1128,200,'06R200:S00I6815',70,'06R0070:0007012','Mo20W','Mo20W','W23/M14','+/Les19-N2450',['Les19-N2450'],'K7012').
genotype(1129,400,'06R400:M00I6105',71,'06R0071:0007110','M14','M14','W23/L317','+/Les20-N2457',['Les20-N2457'],'K7110').
genotype(1130,200,'06R200:S0I10214',75,'06R0075:0007501','Mo20W','Mo20W','les*-N1395C','les*-N1395C',['les*-N1395C'],'K7501').
genotype(1131,200,'06R200:S00I5911',78,'06R0078:0007801','Mo20W','Mo20W','les*-N2013','les*-N2013',['les*-N2013'],'K7801').
genotype(1132,200,'06R200:S00I6615',85,'06R0085:0008510','Mo20W','Mo20W','(B73/AG32)/Ht1','+/Les*-N2418',['Les*-N2418'],'K8510').
genotype(1133,200,'06R200:S0I10202',90,'06R0090:0009001','Mo20W','Mo20W','les*-NA467','les*-NA467',['les*-NA467'],'K9001').
genotype(1134,200,'06R200:S0I10017',90,'06R0090:0009006','Mo20W','Mo20W','les*-NA467','les*-NA467',['les*-NA467'],'K9006').
genotype(1135,200,'06R200:S0I10110',91,'06R0091:0009113','Mo20W','Mo20W','B73 Ht1/Mo17','+/Les*-NA7145',['Les*-NA7145'],'K9113').
genotype(1136,200,'06R200:S00I1012',93,'06R0093:0009304','Mo20W','Mo20W','+/les*-74-1873-9','les*-74-1873-9/les*-74-1873-9',['les*-74-1873-9'],'K9304').
genotype(1137,200,'06R200:S0I10015',97,'06R0097:0009708','Mo20W','Mo20W','Ht1-GE440 ^M14/Ht1-GE440 ^M14','Ht1-GE440 ^M14/Ht1-GE440 ^M14',['Ht1-GE440'],'K9708').
genotype(1138,200,'06R200:S0I10008',97,'06R0097:0009709','Mo20W','Mo20W','Ht1-GE440 ^M14/Ht1-GE440 ^M14','Ht1-GE440 ^M14/Ht1-GE440 ^M14',['Ht1-GE440'],'K9709').
genotype(1139,200,'06R200:S0I10003',100,'06R0100:0010002','Mo20W','Mo20W','Ht2 ^A619','Ht2 ^A619',['Ht2'],'K10002').
genotype(1140,91,'06R0091:0009112',91,'06R0091:0009110','B73 Ht1/Mo17','+','B73 Ht1/Mo17','+/Les*-NA7145',['Les*-NA7145'],'K9110').
genotype(1141,91,'06R0091:0009101',91,'06R0091:0009108','B73 Ht1/Mo17','+','B73 Ht1/Mo17','+/Les*-NA7145',['Les*-NA7145'],'K9108').
genotype(1142,91,'06R0091:0009105',91,'06R0091:0009104','B73 Ht1/Mo17','+','B73 Ht1/Mo17','+/Les*-NA7145',['Les*-NA7145'],'K9104').
genotype(1143,106,'06R0106:0010612',106,'06R0106:0010613','{+|lls1}','{+|lls1}','{+|lls1}','{+|lls1}',[lls1],'K10613').
genotype(1144,200,'06R200:S00I2612',84,'06R0084:0008414','Mo20W','Mo20W','{+|Les*-N2397}','{+|Les*-N2397}',['Les*-N2397'],'K8414').
genotype(1145,200,'06R200:S00I1907',76,'06R0076:0007604','Mo20W','Mo20W','{+|Les*-N1450}','{+|Les*-N1450}',['Les*-N1450'],'K7604').
genotype(1146,200,'06R200:S00I0711',61,'06R0061:0006107','Mo20W','Mo20W','W23/L317','+/Les8-N2005',['Les8-N2005'],'K6107').
genotype(1147,200,'06R200:S00I2518',76,'06R0076:0007613','Mo20W','Mo20W','{+|Les*-N1450}','{+|Les*-N1450}',['Les*-N1450'],'K7613').
genotype(1148,200,'06R200:S00I1917',77,'06R0077:0007718','Mo20W','Mo20W','{+|les*-N2012}','{+|les*-N2012}',['les*-N2012'],'K7718').
genotype(1149,200,'06R200:S00I2515',76,'06R0076:0007609','Mo20W','Mo20W','{+|Les*-N1450}','{+|Les*-N1450}',['Les*-N1450'],'K7609').
genotype(1150,200,'06R200:S00I2513',76,'06R0076:0007608','Mo20W','Mo20W','{+|Les*-N1450}','{+|Les*-N1450}',['Les*-N1450'],'K7608').
genotype(1151,200,'06R200:S00I2520',76,'06R0076:0007614','Mo20W','Mo20W','{+|Les*-N1450}','{+|Les*-N1450}',['Les*-N1450'],'K7614').
genotype(1152,200,'06R200:S00I0115',61,'06R0061:0006106','Mo20W','Mo20W','W23/L317','+/Les8-N2005',['Les8-N2005'],'K6106').
genotype(1153,200,'06R200:S00I3407',83,'06R0083:0008304','Mo20W','Mo20W','{+|les*-N2363A}','{+|les*-N2363A}',['les*-N2363A'],'K8304').
genotype(1154,200,'06R200:S00I2512',76,'06R0076:0007601','Mo20W','Mo20W','{+|Les*-N1450}','{+|Les*-N1450}',['Les*-N1450'],'K7601').
genotype(1155,200,'06R200:S00I1911',76,'06R0076:0007616','Mo20W','Mo20W','{+|Les*-N1450}','{+|Les*-N1450}',['Les*-N1450'],'K7616').
genotype(1156,300,'06R300:W00I2717',76,'06R0076:0007614','W23','W23','{+|Les*-N1450}','{+|Les*-N1450}',['Les*-N1450'],'K7614').
genotype(1157,300,'06R300:W00I0507',61,'06R0061:0006106','W23','W23','W23/L317','+/Les8-N2005',['Les8-N2005'],'K6106').
genotype(1158,300,'06R300:W00I3802',60,'06R0060:0006002','W23','W23','W23/L317','+/Les7-N1461',['Les7-N1461'],'K6002').
genotype(1159,300,'06R300:W00I4214',84,'06R0084:0008414','W23','W23','{+|Les*-N2397}','{+|Les*-N2397}',['Les*-N2397'],'K8414').
genotype(1160,300,'06R300:W00I1202',76,'06R0076:0007616','W23','W23','{+|Les*-N1450}','{+|Les*-N1450}',['Les*-N1450'],'K7616').
genotype(1161,300,'06R300:W00I3512',59,'06R0059:0005909','W23','W23','+','+/Les6-N1451',['Les6-N1451'],'K5909').
genotype(1162,300,'06R300:W00I5302',70,'06R0070:0007012','W23','W23','W23/M14','+/Les19-N2450',['Les19-N2450'],'K7012').
genotype(1163,300,'06R300:W112.104',59,'06R0059:0005908','W23','W23','+','+/Les6-N1451',['Les6-N1451'],'K5908').
genotype(1164,400,'06R400:M00I0605',76,'06R0076:0007601','M14','M14','{+|Les*-N1450}','{+|Les*-N1450}',['Les*-N1450'],'K7601').
genotype(1165,400,'06R400:M00I8403',76,'06R0076:0007604','M14','M14','{+|Les*-N1450}','{+|Les*-N1450}',['Les*-N1450'],'K7604').
genotype(1166,400,'06R400:M00I1813',110,'06R0110:0011002','M14','M14','{+|spc3-N553C}','{+|spc3-N553C}',['spc3-N553C'],'K11002').
genotype(1167,400,'06R400:M00I6505',67,'06R0067:0006711','M14','M14','W23/M14','+/Les15-N2007',['Les15-N2007'],'K6711').
genotype(1168,400,'06R400:M00I6512',67,'06R0067:0006711','M14','M14','W23/M14','+/Les15-N2007',['Les15-N2007'],'K6711').
genotype(1169,400,'06R400:M00I6101',70,'06R0070:0007012','M14','M14','W23/M14','+/Les19-N2450',['Les19-N2450'],'K7012').
genotype(1170,400,'06R400:M00I8108',22,'06R0022:0002210','M14','M14','W23/+','W23/Les6',['Les6'],'K2210').
%
% See /athe/c/maize/data/reinventory/resolution_weird_cases.org for details.
%
% this family is duplicated by family 1193, just by inserting a 0 between the I and 6 in ma.
% Neither family has offspring.  
%
% Tag was incorrectly replaced and will be corrected back to I0602
%
% Kazic, 31.5.2014
%
% genotype(1171,400,'06R400:M000I610',107,'06R0107:0010708','M14','M14','{+|nec*-6853}','{+|nec*-6853}',['nec*-6853'],'K10708').
%
genotype(1172,400,'06R400:M00I3912',61,'06R0061:0006115','M14','M14','W23/L317','+/Les8-N2005',['Les8-N2005'],'K6115').
genotype(1173,400,'06R400:MI53.303',107,'06R0107:0010701','M14','M14','{+|nec*-6853}','{+|nec*-6853}',['nec*-6853'],'K10701').
genotype(1174,400,'06R400:M0I10806',76,'06R0076:0007604','M14','M14','{+|Les*-N1450}','{+|Les*-N1450}',['Les*-N1450'],'K7604').
genotype(1175,400,'06R400:M00I0615',107,'06R0107:0010711','M14','M14','{+|nec*-6853}','{+|nec*-6853}',['nec*-6853'],'K10711').
genotype(1176,400,'06R400:M00I0914',76,'06R0076:0007611','M14','M14','{+|Les*-N1450}','{+|Les*-N1450}',['Les*-N1450'],'K7611').
genotype(1177,400,'06R400:M00I1812',110,'06R0110:0011003','M14','M14','{+|spc3-N553C}','{+|spc3-N553C}',['spc3-N553C'],'K11003').
genotype(1178,400,'06R400:M00I1405',76,'06R0076:0007614','M14','M14','{+|Les*-N1450}','{+|Les*-N1450}',['Les*-N1450'],'K7614').
genotype(1179,400,'06R400:M00I8410',76,'06R0076:0007616','M14','M14','{+|Les*-N1450}','{+|Les*-N1450}',['Les*-N1450'],'K7616').
genotype(1180,400,'06R400:M105.313',59,'06R0059:0005908','M14','M14','+','+/Les6-N1451',['Les6-N1451'],'K5908').
genotype(1181,400,'06R400:M00I7809',91,'06R0091:0009113','M14','M14','B73 Ht1/Mo17','+/Les*-NA7145',['Les*-NA7145'],'K9113').
genotype(1182,400,'06R400:MI71.205',88,'06R0088:0008802','M14','M14','{+|les*-3F-3330}','{+|les*-3F-3330}',['les*-3F-3330'],'K8802').
genotype(1183,400,'06R400:M00I0901',107,'06R0107:0010712','M14','M14','{+|nec*-6853}','{+|nec*-6853}',['nec*-6853'],'K10712').
genotype(1184,400,'06R400:M0I10702',61,'06R0061:0006106','M14','M14','W23/L317','+/Les8-N2005',['Les8-N2005'],'K6106').
genotype(1185,400,'06R400:M00I3905',61,'06R0061:0006114','M14','M14','W23/L317','+/Les8-N2005',['Les8-N2005'],'K6114').
genotype(1186,400,'06R400:M00I1502',76,'06R0076:0007616','M14','M14','{+|Les*-N1450}','{+|Les*-N1450}',['Les*-N1450'],'K7616').
genotype(1187,400,'06R400:M00I5010',61,'06R0061:0006106','M14','M14','W23/L317','+/Les8-N2005',['Les8-N2005'],'K6106').
genotype(1188,400,'06R400:M00I0609',76,'06R0076:0007608','M14','M14','{+|Les*-N1450}','{+|Les*-N1450}',['Les*-N1450'],'K7608').
genotype(1189,400,'06R400:MI71.204',88,'06R0088:0008804','M14','M14','{+|les*-3F-3330','{+|les*-3F-3330',['les*-3F-3330'],'K8804').
genotype(1190,400,'06R400:M00I7804',94,'06R0094:0009405','M14','M14','{+|les*-PI251888}','{+|les*-PI251888}',['les*-PI251888'],'K9405').
genotype(1191,400,'06R400:M00I6506',85,'06R0085:0008501','M14','M14','(B73/AG32)/Ht1','+/Les*-N2418',['Les*-N2418'],'K8501').
% genotype(1192,401,'07R401:M0026506',118,'07R0118:0086714','M14','M14','{I-54|?}/Les101','Va35/Va35',['Les101'],'K118xx').
genotype(1192,401,'07R401:M0026506',118,'07R0118:0086714','M14','M14','{I-54|?}/Les101','Va35/Va35',['Les101'],'K11814').
genotype(1193,400,'06R400:M00I0610',107,'06R0107:0010708','M14','M14','{+|nec*-6853}','{+|nec*-6853}',['nec*-6853'],'K10708').
genotype(1194,400,'06R400:M00I3609',60,'06R0060:0006002','M14','M14','W23/L317','+/Les7-N1461',['Les7-N1461'],'K6002').
genotype(1195,57,'06R0057:0005705',57,'06R0057:0005702','B77/A636','+','B77/A636','+/Les4-N1375',['Les4-N1375'],'K5702').
genotype(1196,200,'06R200:S00I3704',95,'06R0095:0009504','Mo20W','Mo20W','{B73 Ht1|les*-ats}','{B73 Ht1|les*-ats}',['les*-ats'],'K9504').
genotype(1197,300,'06R300:W00I3211',99,'06R0099:0009905','W23','W23','B73 Ht1','B73 Ht1',['Ht1'],'K9905').
genotype(1198,400,'06R400:M0I10805',95,'06R0095:0009504','M14','M14','{B73 Ht1|les*-ats}','{B73 Ht1|les*-ats}',['les*-ats'],'K9504').
genotype(1199,400,'06R400:M00I3909',99,'06R0099:0009905','M14','M14','B73 Ht1','B73 Ht1',['Ht1'],'K9905').
genotype(1200,400,'06R400:M00I7801',95,'06R0095:0009504','M14','M14','{B73 Ht1|les*-ats}','{B73 Ht1|les*-ats}',['les*-ats'],'K9504').
genotype(1201,200,'06R200:S00I1105',97,'06R0097:0009707','Mo20W','Mo20W','Ht1-GE440 ^M14/Ht1-GE440 ^M14','Ht1-GE440 ^M14/Ht1-GE440 ^M14',['Ht1-GE440'],'K9707').
genotype(1202,200,'06R200:S00I1114',104,'06R0104:0010405','Mo20W','Mo20W','{+|lep*-8691}','{+|lep*-8691}',['lep*-8691'],'K10405').
genotype(1203,200,'06R200:S00I1115',104,'06R0104:0010407','Mo20W','Mo20W','{+|lep*-8691}','{+|lep*-8691}',['lep*-8691'],'K10407').
genotype(1204,200,'06R200:S00I1017',97,'06R0097:0009706','Mo20W','Mo20W','Ht1-GE440 ^M14/Ht1-GE440 ^M14','Ht1-GE440 ^M14/Ht1-GE440 ^M14',['Ht1-GE440'],'K9706').
genotype(1205,300,'06R300:W00I3811',97,'06R0097:0009709','W23','W23','Ht1-GE440 ^M14/Ht1-GE440 ^M14','Ht1-GE440 ^M14/Ht1-GE440 ^M14',['Ht1-GE440'],'K9709').
genotype(1206,200,'06R200:S00I1118',107,'06R0107:0010708','Mo20W','Mo20W','{+|nec*-6853}','{+|nec*-6853}',['nec*-6853'],'K10708').
genotype(1207,200,'06R200:S00I2503',107,'06R0107:0010712','Mo20W','Mo20W','{+|nec*-6853}','{+|nec*-6853}',['nec*-6853'],'K10712').
genotype(1208,300,'06R300:W00I0518',97,'06R0097:0009707','W23','W23','Ht1-GE440 ^M14/Ht1-GE440 ^M14','Ht1-GE440 ^M14/Ht1-GE440 ^M14',['Ht1-GE440'],'K9707').
genotype(1209,300,'06R300:W00I0219',97,'06R0097:0009706','W23','W23','Ht1-GE440 ^M14/Ht1-GE440 ^M14','Ht1-GE440 ^M14/Ht1-GE440 ^M14',['Ht1-GE440'],'K9706').
genotype(1210,300,'06R300:W00I4902',97,'06R0097:0009708','W23','W23','Ht1-GE440 ^M14/Ht1-GE440 ^M14','Ht1-GE440 ^M14/Ht1-GE440 ^M14',['Ht1-GE440'],'K9708').
genotype(1211,200,'06R200:S00I2511',112,'06R0112:0011205','Mo20W','Mo20W',zn1,zn1,[zn1],'K11205').
genotype(1212,400,'06R400:M00I0309',97,'06R0097:0009707','M14','M14','Ht1-GE440 ^M14/Ht1-GE440 ^M14','Ht1-GE440 ^M14/Ht1-GE440 ^M14',['Ht1-GE440'],'K9707').
genotype(1213,200,'06R200:S00I3712',112,'06R0112:0011202','Mo20W','Mo20W',zn1,zn1,[zn1],'K11202').
genotype(1214,400,'06R400:M00I3910',97,'06R0097:0009711','M14','M14','Ht1-GE440 ^M14/Ht1-GE440 ^M14','Ht1-GE440 ^M14/Ht1-GE440 ^M14',['Ht1-GE440'],'K9711').
genotype(1215,400,'06R400:M00I0308',97,'06R0097:0009706','M14','M14','Ht1-GE440 ^M14/Ht1-GE440 ^M14','Ht1-GE440 ^M14/Ht1-GE440 ^M14',['Ht1-GE440'],'K9706').
genotype(1216,200,'06R200:S00I6312',112,'06R0112:0011208','Mo20W','Mo20W',zn1,zn1,[zn1],'K11208').
genotype(1217,200,'06R200:S00I6309',112,'06R0112:0011208','Mo20W','Mo20W',zn1,zn1,[zn1],'K11208').
genotype(1218,400,'06R400:M00I3915',97,'06R0097:0009708','M14','M14','Ht1-GE440 ^M14/Ht1-GE440 ^M14','Ht1-GE440 ^M14/Ht1-GE440 ^M14',['Ht1-GE440'],'K9708').
genotype(1219,400,'06R400:M00I3914',97,'06R0097:0009709','M14','M14','Ht1-GE440 ^M14/Ht1-GE440 ^M14','Ht1-GE440 ^M14/Ht1-GE440 ^M14',['Ht1-GE440'],'K9709').
genotype(1220,400,'06R400:M00I3907',100,'06R0100:0010002','M14','M14','Ht2 ^A619','Ht2 ^A619',['Ht2'],'K10002').
genotype(1221,200,'06R200:S00I1904',75,'06R0075:0007501','Mo20W','Mo20W','les*-N1395C','les*-N1395C',['les*-N1395C'],'K7501').
genotype(1222,200,'06R200:S00I1010',87,'06R0087:0008710','Mo20W','Mo20W','les*-N2502','les*-N2502',['les*-N2502'],'K8710').
genotype(1223,200,'06R200:S00I1009',87,'06R0087:0008709','Mo20W','Mo20W','les*-N2502','les*-N2502',['les*-N2502'],'K8709').
genotype(1224,400,'06R400:M00I9601',87,'06R0087:0008706','M14','M14','les*-N2502','les*-N2502',['les*-N2502'],'K8706').
genotype(1225,400,'06R400:M105.312',87,'06R0087:0008707','M14','M14','les*-N2502','les*-N2502',['les*-N2502'],'K8707').
genotype(1226,400,'06R400:M00I8107',90,'06R0090:0009001','M14','M14','les*-NA467','les*-NA467',['les*-NA467'],'K9001').
genotype(1227,300,'06R300:W00I0504',55,'06R0055:0005515','W23','W23','Les2-N845A/+','M14/W23',['Les2-N845A'],'K5515').
genotype(1228,300,'06R300:W00I9214',55,'06R0055:0005515','W23','W23','Les2-N845A/+','M14/W23',['Les2-N845A'],'K5515').
genotype(1229,400,'06R400:M105.405',55,'06R0055:0005515','M14','M14','Les2-N845A/+','M14/W23',['Les2-N845A'],'K5515').
genotype(1230,400,'06R400:M00I9606',55,'06R0055:0005515','M14','M14','Les2-N845A/+','M14/W23',['Les2-N845A'],'K5515').
genotype(1231,300,'06R300:W00I2010',111,'06R0111:0011113','W23','W23','{(M14/W23)|vms*-8522}','{(M14/W23)|vms*-8522}',['vms*-8522'],'K11103').
genotype(1232,300,'06R300:W00I3814',62,'06R0062:0006206','W23','W23','(M14/W23)/+','(M14/W23)/Les9-N2008',['Les9-N2008'],'K6206').
genotype(1233,400,'06R400:M00I1802',111,'06R0111:0011104','M14','M14','{(M14/W23)|vms*-8522}','{(M14/W23)|vms*-8522}',['vms*-8522'],'K11104').
genotype(1234,1,'06R0001:0000108',1,'06R0001:0000106','Mo20W/+','Mo20W/+','Mo20W/+','Mo20W/Les1',['Les1'],'K0106').
genotype(1235,2,'06R0002:0000209',2,'06R0002:0000203','Mo20W/+','Mo20W/+','Mo20W/+','Mo20W/Les2',['Les2'],'K0203').
genotype(1236,2,'06R0002:0000204',2,'06R0002:0000202','Mo20W/+','Mo20W/+','Mo20W/+','Mo20W/Les2',['Les2'],'K0202').
genotype(1237,5,'06R0005:0000510',5,'06R0005:0000505','Mo20W/+','Mo20W/+','Mo20W/+','Mo20W/Les7',['Les7'],'K0505').
genotype(1238,5,'06R0005:0000501',5,'06R0005:0000506','Mo20W/+','Mo20W/+','Mo20W/+','Mo20W/Les7',['Les7'],'K0506').
genotype(1239,6,'06R0006:0000607',6,'06R0006:0000604','Mo20W/+','Mo20W/+','Mo20W/+','Mo20W/Les8',['Les8'],'K0604').
genotype(1240,6,'06R0006:0000613',6,'06R0006:0000601','Mo20W/+','Mo20W/+','Mo20W/+','Mo20W/Les8',['Les8'],'K0601').
genotype(1241,6,'06R0006:0000606',6,'06R0006:0000609','Mo20W/+','Mo20W/+','Mo20W/+','Mo20W/Les8',['Les8'],'K0609').
genotype(1242,9,'06R0009:0000905',9,'06R0009:0000904','Mo20W/+','Mo20W/+','Mo20W/+','Mo20W/Les11',['Les11'],'K0904').
genotype(1243,9,'06R0009:0000908',9,'06R0009:0000901','Mo20W/+','Mo20W/+','Mo20W/+','Mo20W/Les11',['Les11'],'K0901').
genotype(1244,12,'06R0012:0001208',12,'06R0012:0001207','Mo20W/+','Mo20W/+','Mo20W/+','Mo20W/Les15',['Les15'],'K1207').
genotype(1245,12,'06R0012:0001207',12,'06R0012:0001208','Mo20W/+','Mo20W/+','Mo20W/+','Mo20W/Les15',['Les15'],'K1208').
genotype(1246,13,'06R0013:0001315',13,'06R0013:0001312','Mo20W/+','Mo20W/+','Mo20W/+','Mo20W/Les17',['Les17'],'K1312').
genotype(1247,13,'06R0013:0001304',13,'06R0013:0001302','Mo20W/+','Mo20W/+','Mo20W/+','Mo20W/Les17',['Les17'],'K1302').
genotype(1248,14,'06R0014:0001403',14,'06R0014:0001406','Mo20W/+','Mo20W/+','Mo20W/+','Mo20W/Les18',['Les18'],'K1406').
genotype(1249,14,'06R0014:0001404',14,'06R0014:0001407','Mo20W/+','Mo20W/+','Mo20W/+','Mo20W/Les18',['Les18'],'K1407').
genotype(1250,17,'06R0017:0001709',17,'06R0017:0001703','Mo20W/+','Mo20W/{+|lls}','Mo20W/+','Mo20W/{+|lls1}',[lls1],'K1703').
genotype(1251,17,'06R0017:0001704',17,'06R0017:0001706','Mo20W/+','Mo20W/{+|lls}','Mo20W/+','Mo20W/{+|lls1}',[lls1],'K1706').
genotype(1252,200,'06R200:S00I7914',24,'06R0024:0002402','Mo20W','Mo20W','W23/+','W23/Les8',['Les8'],'K2402').
%
%
% revised based on 10R results
%
% Kazic, 4.10.2010
% 
% genotype(1253,18,'06R0018:0001808',18,'06R0018:0001804','Mo20W/+','Mo20W/{+|les23}','Mo20W/+','Mo20W/{+|les23}',[les23],'K1804').
genotype(1253,18,'06R0018:0001808',18,'06R0018:0001804','Mo20W/+','Mo20W/les23','Mo20W/+','Mo20W/les23',[les23],'K1804').
%
genotype(1254,200,'06R200:S00I8604',24,'06R0024:0002405','Mo20W','Mo20W','W23/+','W23/Les8',['Les8'],'K2405').
genotype(1255,200,'06R200:S00I9809',27,'06R0027:0002711','Mo20W','Mo20W','W23/+','W23/Les12',['Les12'],'K2711').
genotype(1256,200,'06R200:S00I9918',28,'06R0028:0002808','Mo20W','Mo20W','W23/+','W23/Les13',['Les13'],'K2808').
genotype(1257,200,'06R200:S00I9907',28,'06R0028:0002802','Mo20W','Mo20W','W23/+','W23/Les13',['Les13'],'K2802').
genotype(1258,200,'06R200:S00I9911',28,'06R0028:0002805','Mo20W','Mo20W','W23/+','W23/Les13',['Les13'],'K2805').
genotype(1259,200,'06R200:S0I10001',30,'06R0030:0003007','Mo20W','Mo20W','W23/+','W23/Les17',['Les17'],'K3007').
genotype(1260,200,'06R200:S0I10010',31,'06R0031:0003102','Mo20W','Mo20W','W23/+','W23/Les18',['Les18'],'K3102').
genotype(1261,200,'06R200:S0I10011',31,'06R0031:0003103','Mo20W','Mo20W','W23/+','W23/Les18',['Les18'],'K3103').
genotype(1262,18,'06R0018:0001805',18,'06R0018:0001809','Mo20W/+','Mo20W/{+|les23}','Mo20W/+','Mo20W/{+|les23}',[les23],'K1809').
genotype(1263,200,'06R200:S0I10113',32,'06R0032:0003208','Mo20W','Mo20W','W23/+','W23/Les19',['Les19'],'K3208').
genotype(1264,200,'06R200:S0I10014',32,'06R0032:0003204','Mo20W','Mo20W','W23/+','W23/Les19',['Les19'],'K3204').
genotype(1265,200,'06R200:S0I10114',33,'06R0033:0003308','Mo20W','Mo20W','W23/+','W23/Les21',['Les21'],'K3308').
genotype(1266,200,'06R200:S0I10206',35,'06R0035:0003506','Mo20W','Mo20W','W23/+','W23/{+|les23}',[les23],'K3506').
genotype(1267,200,'06R200:S00I1908',17,'06R0017:0001703','Mo20W','Mo20W','Mo20W/+','Mo20W/{+|lls1}',[lls1],'K1703').
genotype(1268,200,'06R200:S00I5508',7,'06R0007:0000708','Mo20W','Mo20W','Mo20W/+','Mo20W/Les9',['Les9'],'K0708').
genotype(1269,200,'06R200:S00I1611',11,'06R0011:0001113','Mo20W/+','Mo20W/+','Mo20W/+','Mo20W/Les13',['Les13'],'K1113').
genotype(1270,200,'06R200:S00I6608',9,'06R0009:0000904','Mo20W','Mo20W','Mo20W/+','Mo20W/Les11',['Les11'],'K0904').
genotype(1271,200,'06R200:S00I1909',4,'06R0004:0000403','Mo20W','Mo20W','Mo20W/+','Mo20W/Les6',['Les6'],'K0403').
genotype(1272,200,'06R200:S00I1906',4,'06R0004:0000401','Mo20W','Mo20W','Mo20W/+','Mo20W/Les6',['Les6'],'K0401').
genotype(1273,200,'06R200:S00I1919',4,'06R0004:0000405','Mo20W','Mo20W','Mo20W/+','Mo20W/Les6',['Les6'],'K0405').
genotype(1274,300,'06R300:W00I6901',14,'06R0014:0001407','W23','W23','Mo20W/+','Mo20W/Les18',['Les18'],'K1407').
genotype(1276,300,'06R300:W00I1713',8,'06R0008:0000802','W23','W23','Mo20W/+','Mo20W/Les10',['Les10'],'K0802').
genotype(1277,300,'06R300:W00I1716',8,'06R0008:0000802','W23','W23','Mo20W/+','Mo20W/Les10',['Les10'],'K0802').
genotype(1278,300,'06R300:W00I2006',3,'06R0003:0000302','W23','W23','Mo20W/+','Mo20W/Les4',['Les4'],'K0302').
genotype(1279,300,'06R300:W00I1702',1,'06R0001:0000104','W23','W23','Mo20W/+','Mo20W/Les1',['Les1'],'K0104').
genotype(1280,300,'06R300:W00I1701',1,'06R0001:0000104','W23','W23','Mo20W/+','Mo20W/Les1',['Les1'],'K0104').
genotype(1281,30,'06R0030:0003011',30,'06R0030:0003012','W23/+','W23/+','W23/+','W23/Les17',['Les17'],'K3012').
genotype(1282,200,'06R200:S00I1604',35,'06R0035:0003509','Mo20W','Mo20W','W23/+','W23/{+|les23}',[les23],'K3509').
genotype(1283,200,'06R200:S0I10016',32,'06R0032:0003206','Mo20W','Mo20W','W23/+','W23/Les19',['Les19'],'K3206').
genotype(1285,300,'06R300:W00I8308',27,'06R0027:0002711','W23','W23','W23/+','W23/Les12',['Les12'],'K2711').
genotype(1286,300,'06R300:W00I8715',32,'06R0032:0003206','W23','W23','W23/+','W23/Les19',['Les19'],'K3206').
genotype(1287,300,'06R300:W00I8904',32,'06R0032:0003208','W23','W23','W23/+','W23/Les19',['Les19'],'K3208').
genotype(1288,300,'06R300:W00I8906',33,'06R0033:0003308','W23','W23','W23/+','W23/Les21',['Les21'],'K3308').
genotype(1289,300,'06R300:W00I8311',28,'06R0028:0002805','W23','W23','W23/+','W23/Les13',['Les13'],'K2805').
genotype(1290,400,'06R400:M00I8510',32,'06R0032:0003206','M14','M14','W23/+','W23/Les19',['Les19'],'K3206').
genotype(1291,400,'06R400:M00I2402',24,'06R0024:0002410','M14','M14','W23/+','W23/Les8',['Les8'],'K2410').
genotype(1292,400,'06R400:M00I8109',23,'06R0023:0002310','M14','M14','W23/+','W23/Les7',['Les7'],'K2310').
genotype(1293,400,'06R400:M00I8514',35,'06R0035:0003501','M14','M14','W23/+','W23/{+|les23}',[les23],'K3501').
genotype(1294,400,'06R400:M00I8505',31,'06R0031:0003102','M14','M14','W23/+','W23/Les18',['Les18'],'K3102').
genotype(1295,400,'06R400:M00I8802',35,'06R0035:0003503','M14','M14','W23/+','W23/{+|les23}',[les23],'K3503').
genotype(1296,400,'06R400:M00I8506',31,'06R0031:0003103','M14','M14','W23/+','W23/Les18',['Les18'],'K3103').
genotype(1297,400,'06R400:M00I8513',33,'06R0033:0003308','M14','M14','W23/+','W23/Les21',['Les21'],'K3308').
genotype(1298,400,'06R400:M00I8504',30,'06R0030:0003012','M14','M14','W23/+','W23/Les17',['Les17'],'K3012').
genotype(1299,400,'06R400:M00I8404',26,'06R0026:0002610','M14','M14','W23/+','W23/Les10',['Les10'],'K2610').
genotype(1300,300,'06R300:W00I7702',19,'06R0019:0001909','W23','W23','W23/+','W23/Les1',['Les1'],'K1909').
genotype(1301,300,'06R300:W00I7304',19,'06R0019:0001903','W23','W23','W23/+','W23/Les1',['Les1'],'K1903').
genotype(1302,300,'06R300:W00I7703',19,'06R0019:0001912','W23','W23','W23/+','W23/Les1',['Les1'],'K1912').
genotype(1303,300,'06R300:W00I7713',20,'06R0020:0002009','W23','W23','W23/+','W23/Les2',['Les2'],'K2009').
genotype(1304,300,'06R300:W00I7717',21,'06R0021:0002101','W23','W23','W23/+','W23/Les4',['Les4'],'K2101').
genotype(1305,400,'06R400:M00I8806',35,'06R0035:0003506','M14','M14','W23/+','W23/{+|les23}',[les23],'K3506').
genotype(1306,400,'06R400:M00I8511',32,'06R0032:0003208','M14','M14','W23/+','W23/Les19',['Les19'],'K3208').
genotype(1307,400,'06R400:M00I2110',21,'06R0021:0002104','M14','M14','W23/+','W23/Les4',['Les4'],'K2104').
genotype(1308,400,'06R400:M00I7803',20,'06R0020:0002003','M14','M14','W23/+','W23/Les2',['Les2'],'K2003').
genotype(1309,300,'06R300:W00I8010',22,'06R0022:0002210','W23','W23','W23/+','W23/Les6',['Les6'],'K2210').
genotype(1310,400,'06R400:M00I8113',24,'06R0024:0002402','M14','M14','W23/+','W23/Les8',['Les8'],'K2402').
genotype(1311,400,'06R400:M00I8103',22,'06R0022:0002207','M14','M14','W23/+','W23/Les6',['Les6'],'K2207').
genotype(1312,201,'07R201:S0000102',116,'07R0116:0086403','Mo20W','Mo20W','?/Les5','?/Les5',['Les5'],'K11603').
genotype(1315,300,'06R300:W00I8202',24,'06R0024:0002402','W23','W23','W23/+','W23/Les8',['Les8'],'K2402').
genotype(1316,300,'06R300:W105.201',112,'06R0112:0011206','W23','W23',zn1,zn1,[zn1],'K11206').
genotype(1317,300,'06R300:W00I6009',25,'06R0025:0002506','W23','W23','W23/+','W23/Les9',['Les9'],'K2506').
genotype(1318,300,'06R300:W105.313',59,'06R0059:0005908','W23','W23','+','+/Les6-N1451',['Les6-N1451'],'K5908').
genotype(1319,201,'07R201:S0000108',2281,'07R2281:0035415','Mo20W','Mo20W','Mo20W','Les1',['Les1'],'K0106').
genotype(1320,201,'07R201:S0000112',2786,'07R2786:0045303','Mo20W','Mo20W','Mo20W/(M14/W23)','Les6',['Les6'],'K2210').
genotype(1322,300,'06R300:W00I8313',28,'06R0028:0002808','W23','W23','W23/+','W23/Les13',['Les13'],'K2808').
genotype(1324,201,'07R201:S0001311',2488,'07R2488:0052511','Mo20W','Mo20W','M14/Mo20W','Les8',['Les8'],'K0611').
genotype(1325,300,'06R300:W00I8709',30,'06R0030:0003012','W23','W23','W23/+','W23/Les17',['Les17'],'K3012').
genotype(1326,300,'06R300:W00I8704',30,'06R0030:0003007','W23','W23','W23/+','W23/Les17',['Les17'],'K3007').
genotype(1327,300,'06R300:W00I6405',30,'06R0030:0003007','W23','W23','W23/+','W23/Les17',['Les17'],'K3007').
genotype(1328,300,'06R300:W00I8217',24,'06R0024:0002405','W23','W23','W23/+','W23/Les8',['Les8'],'K2405').
genotype(1329,300,'06R300:W00I8712',31,'06R0031:0003106','W23','W23','W23/+','W23/Les18',['Les18'],'K3106').
genotype(1330,300,'06R300:W00I8711',31,'06R0031:0003103','W23','W23','W23/+','W23/Les18',['Les18'],'K3103').
genotype(1331,201,'07R201:S0001314',2645,'07R2645:0068408','Mo20W','Mo20W','M14/Mo20W','Les19',['Les19'],'K1504').
genotype(1333,300,'06R300:W00I8713',32,'06R0032:0003204','W23','W23','W23/+','W23/Les19',['Les19'],'K3204').
genotype(1334,300,'06R300:W00I6005',33,'06R0033:0003311','W23','W23','W23/+','W23/Les21',['Les21'],'K3311').
genotype(1336,300,'06R300:W00I1703',35,'06R0035:0003509','W23','W23','W23/+','W23/{+|les23}',[les23],'K3509').
genotype(1337,300,'06R300:W00I9106',35,'06R0035:0003503','W23','W23','W23/+','W23/{+|les23}',[les23],'K3503').
genotype(1338,300,'06R300:W00I9109',35,'06R0035:0003506','W23','W23','W23/+','W23/{+|les23}',[les23],'K3506').
genotype(1339,300,'06R300:W00I8908',35,'06R0035:0003501','W23','W23','W23/+','W23/{+|les23}',[les23],'K3501').
genotype(1340,19,'06R0019:0001901',19,'06R0019:0001902','W23/+','W23/+','W23/+','W23/Les1',['Les1'],'K1902').
genotype(1341,19,'06R0019:0001913',19,'06R0019:0001909','W23/+','W23/+','W23/+','W23/Les1',['Les1'],'K1909').
genotype(1342,20,'06R0020:0002007',20,'06R0020:0002003','W23/+','W23/+','W23/+','W23/Les2',['Les2'],'K2003').
genotype(1343,20,'06R0020:0002006',20,'06R0020:0002002','W23/+','W23/+','W23/+','W23/Les2',['Les2'],'K2002').
genotype(1344,20,'06R0020:0002008',20,'06R0020:0002011','W23/+','W23/+','W23/+','W23/Les2',['Les2'],'K2011').
genotype(1345,21,'06R0021:0002107',21,'06R0021:0002106','W23/+','W23/+','W23/+','W23/Les4',['Les4'],'K2106').
genotype(1346,22,'06R0022:0002211',22,'06R0022:0002212','W23/+','W23/+','W23/+','W23/Les6',['Les6'],'K2212').
genotype(1347,22,'06R0022:0002205',22,'06R0022:0002202','W23/+','W23/+','W23/+','W23/Les6',['Les6'],'K2202').
genotype(1348,23,'06R0023:0002305',23,'06R0023:0002310','W23/+','W23/+','W23/+','W23/Les7',['Les7'],'K2310').
genotype(1349,23,'06R0023:0002306',23,'06R0023:0002312','W23/+','W23/+','W23/+','W23/Les7',['Les7'],'K2312').
genotype(1350,23,'06R0023:0002311',23,'06R0023:0002304','W23/+','W23/+','W23/+','W23/Les7',['Les7'],'K2304').
genotype(1351,25,'06R0025:0002503',25,'06R0025:0002512','W23/+','W23/+','W23/+','W23/Les9',['Les9'],'K2512').
genotype(1352,25,'06R0025:0002507',25,'06R0025:0002510','W23/+','W23/+','W23/+','W23/Les9',['Les9'],'K2510').
genotype(1353,26,'06R0026:0002609',26,'06R0026:0002615','W23/+','W23/+','W23/+','W23/Les10',['Les10'],'K2615').
genotype(1354,26,'06R0026:0002604',26,'06R0026:0002606','W23/+','W23/+','W23/+','W23/Les10',['Les10'],'K2606').
genotype(1355,27,'06R0027:0002708',27,'06R0027:0002710','W23/+','W23/+','W23/+','W23/Les12',['Les12'],'K2710').
genotype(1356,27,'06R0027:0002707',27,'06R0027:0002706','W23/+','W23/+','W23/+','W23/Les12',['Les12'],'K2706').
genotype(1357,27,'06R0027:0002701',27,'06R0027:0002702','W23/+','W23/+','W23/+','W23/Les12',['Les12'],'K2702').
genotype(1358,30,'06R0030:0003009',30,'06R0030:0003005','W23/+','W23/+','W23/+','W23/Les17',['Les17'],'K3005').
genotype(1359,30,'06R0030:0003003',30,'06R0030:0003002','W23/+','W23/+','W23/+','W23/Les17',['Les17'],'K3002').
genotype(1360,201,'07R201:S0003610',2641,'07R2641:0068602','Mo20W','Mo20W','M14/Mo20W','Les19',['Les19'],'K1504').
genotype(1361,30,'06R0030:0003008',30,'06R0030:0003007','W23/+','W23/+','W23/+','W23/Les17',['Les17'],'K3007').
genotype(1362,31,'06R0031:0003108',31,'06R0031:0003105','W23/+','W23/+','W23/+','W23/Les18',['Les18'],'K3105').
genotype(1363,32,'06R0032:0003203',32,'06R0032:0003209','W23/+','W23/+','W23/+','W23/Les19',['Les19'],'K3209').
genotype(1364,33,'06R0033:0003307',33,'06R0033:0003311','W23/+','W23/+','W23/+','W23/Les21',['Les21'],'K3311').
genotype(1365,33,'06R0033:0003301',33,'06R0033:00033xx','W23/+','W23/+','W23/+','W23/Les21',['Les21'],'K33xx').
genotype(1366,35,'06R0035:0003505',35,'06R0035:0003510','W23/+','W23/{+|les23}','W23/+','W23/{+|les23}',[les23],'K3510').
genotype(1367,35,'06R0035:0003502',35,'06R0035:0003507','W23/+','W23/{+|les23}','W23/+','W23/{+|les23}',[les23],'K3507').
%
% modified based on 10R results
%
% Kazic, 4.10.2010
%
% genotype(1368,35,'06R0035:0003513',35,'06R0035:0003514','W23/+','W23/{+|les23}','W23/+','W23/{+|les23}',[les23],'K3514').
%
genotype(1368,35,'06R0035:0003513',35,'06R0035:0003514','W23/+','W23/les23','W23/+','W23/les23',[les23],'K3514').
%
genotype(1369,35,'06R0035:0003501',35,'06R0035:0003503','W23/+','W23/{+|les23}','W23/+','W23/{+|les23}',[les23],'K3503').
genotype(1370,34,'06R0034:0003414',34,'06R0034:0003402','W23/+','W23/{+|lls1 121D}','W23/+','W23/{+|lls1 121D}',['lls1 121D'],'K3402').
genotype(1371,34,'06R0034:0003409',34,'06R0034:0003406','W23/+','W23/{+|lls1 121D}','W23/+','W23/{+|lls1 121D}',['lls1 121D'],'K3406').
genotype(1372,34,'06R0034:0003403',34,'06R0034:0003401','W23/+','W23/{+|lls1 121D}','W23/+','W23/{+|lls1 121D}',['lls1 121D'],'K3401').
genotype(1373,34,'06R0034:0003410',34,'06R0034:0003411','W23/+','W23/{+|lls1 121D}','W23/+','W23/{+|lls1 121D}',['lls1 121D'],'K3411').
genotype(2203,200,'06R200:SI18.104',29,'06R0029:0002905','Mo20W','Mo20W','W23/+','W23/Les15',['Les15'],'K2905').
genotype(2204,200,'06R200:S00I1006',32,'06R0032:0003206','Mo20W','Mo20W','W23/+','W23/Les19',['Les19'],'K3206').
genotype(2205,200,'06R200:S00I2516',76,'06R0076:0007611','Mo20W','Mo20W','+','Les*-N1450',['Les*-N1450'],'K7611').
%
% added for 06n planting
%
% Kazic, 25.11.09
%
genotype(2979,300,'06R300:W00I1219',76,'06R0076:0007611','W23','W23','+','Les*-N1450',['Les*-N1450'],'K7611').
genotype(2980,300,'06R300:W00I1216',76,'06R0076:0007609','Mo20W','Mo20W','{+|Les*-N1450}','{+|Les*-N1450}',['Les*-N1450'],'K7609').


% 07r

genotype(1374,201,'07R201:S0004801',2641,'07R2641:0068605','Mo20W','Mo20W','M14/Mo20W','Les19',['Les19'],'K1504').
genotype(1375,201,'07R201:S0006419',2567,'07R2567:0063216','Mo20W','Mo20W','Mo20W','Les17',['Les17'],'K1302').
genotype(1376,201,'07R201:S0006701',115,'07R0115:0086506','Mo20W','Mo20W','csp1/?','csp1/?',['csp1'],'K11506').
genotype(1377,201,'07R201:S0006705',114,'07R0114:0086808','Mo20W','Mo20W','Mo20W/les23','Mo20W/les23',[les23],'K114xx').
genotype(1378,201,'07R201:S0007801',2737,'07R2737:0036006','Mo20W','Mo20W','W23','(M14/W23)/Les1',['Les1'],'K1903').
genotype(1379,201,'07R201:S0007804',2737,'07R2737:0036009','Mo20W','Mo20W','W23','(M14/W23)/Les1',['Les1'],'K1903').
genotype(1380,201,'07R201:S0008406',2873,'07R2873:0062408','Mo20W','Mo20W','M14','(M14/W23)/Les13',['Les13'],'K2808').
genotype(1381,201,'07R201:S0008715',2953,'07R2953:0089706','Mo20W','Mo20W','M14','(M14/W23)/({+|Les*-N2397}/{+|Les*-N2397})',['Les*-N2397'],'K8414').
genotype(1382,201,'07R201:S0011206',2277,'07R2277:0093502','Mo20W','Mo20W','M14','(M14/Mo20W)/Les1',['Les1'],'K0106').
genotype(1383,201,'07R201:S0015711',2277,'07R2277:0093505','Mo20W','Mo20W','M14','(M14/Mo20W)/Les1',['Les1'],'K0106').
genotype(1384,201,'07R201:S0016001',2277,'07R2277:0093509','Mo20W','Mo20W','M14','(M14/Mo20W)/Les1',['Les1'],'K0106').
genotype(1385,201,'07R201:S0017402',2283,'07R2283:0035209','Mo20W','Mo20W','Mo20W','Les1',['Les1'],'K0106').
genotype(1386,201,'07R201:S0017405',2360,'07R2360:0043409','Mo20W','Mo20W','Mo20W','(M14/Mo20W)/Les6',['Les6'],'K0401').
genotype(1387,201,'07R201:S0017701',2734,'07R2734:0093601','Mo20W','Mo20W','Mo20W','(M14/W23)/Les1',['Les1'],'K1903').
genotype(1388,201,'07R201:S0018309',1135,'07R1135:0087709','Mo20W','Mo20W','Mo20W','(B73 Ht1/Mo17)/Les*-NA7145',['Les*-NA7145'],'K9113').
genotype(1389,201,'07R201:S0018310',1057,'07R1057:0072912','Mo20W','Mo20W','Mo20W','{+|les23}',[les23],'K1802').
genotype(1390,201,'07R201:S0018915',2644,'07R2644:0116308','Mo20W','Mo20W','W23','(W23/(M14/Mo20W))/Les19',['Les19'],'K1504').
genotype(1391,201,'07R201:S0019201',1057,'07R1057:0072902','Mo20W','Mo20W','Mo20W','{+|les23}',[les23],'K1802').
genotype(1392,201,'07R201:S0019209',116,'07R0116:0086406','Mo20W','Mo20W','?/Les5','?/Les5',['Les5'],'K11606').
genotype(1393,201,'07R201:S0019210',2666,'07R2666:0069710','Mo20W','Mo20W','Mo20W','Les19',['Les19'],'K1511').
genotype(1394,201,'07R201:S0019302',1326,'07R1326:0113704','Mo20W','Mo20W','W23','W23/Les17',['Les17'],'K3007').

genotype(1396,201,'07R201:S0020204',2495,'07R2495:0053412','Mo20W','Mo20W','M14','(M14/Mo20W)/Les8',['Les8'],'K0612').
genotype(1397,201,'07R201:S0020501',2281,'07R2281:0035401','Mo20W','Mo20W','Mo20W','Les1',['Les1'],'K0106').
genotype(1398,201,'07R201:S0020504',2666,'07R2666:0069707','Mo20W','Mo20W','Mo20W','Les19',['Les19'],'K1511').
genotype(1399,201,'07R201:S0020511',2290,'07R2290:0094205','Mo20W','Mo20W','Mo20W','Les9',['Les9'],'K0709').
genotype(1400,201,'07R201:S0020801',2281,'07R2281:0035403','Mo20W','Mo20W','Mo20W','Les1',['Les1'],'K0106').
genotype(1401,201,'07R201:S0020802',2742,'07R2742:0036806','Mo20W','Mo20W','W23','Les1',['Les1'],'K1909').
genotype(1402,201,'07R201:S0020804',2742,'07R2742:0036810','Mo20W','Mo20W','W23','Les1',['Les1'],'K1909').
genotype(1403,201,'07R201:S0020812',1300,'07R1300:0036906','Mo20W','Mo20W','W23','Les1',['Les1'],'K1909').
genotype(1404,201,'07R201:S0021102',2283,'07R2283:0035213','Mo20W','Mo20W','Mo20W','Les1',['Les1'],'K0106').
genotype(1405,201,'07R201:S0021110',2740,'07R2740:0035714','Mo20W','Mo20W','W23','Les1',['Les1'],'K1903').
genotype(1406,201,'07R201:S0021112',2742,'07R2742:0036806','Mo20W','Mo20W','W23','Les1',['Les1'],'K1909').
% genotype(1407,300,'06R300:W0013808',24,'06R0024:0002404','W23','W23','W23/+','W23/Les8',['Les8'],'K2404').
genotype(1407,300,'06R300:W00I3808',24,'06R0024:0002404','W23','W23','W23/+','W23/Les8',['Les8'],'K2404').
genotype(1408,400,'06R400:M00I2105',4,'06R0004:0000401','M14','M14','Mo20W/+','Mo20W/Les6',['Les6'],'K0401').
genotype(1409,400,'06R400:M00I0910',76,'06R0076:0007609','M14','M14','{+|Les*-N1450}','{+|Les*-N1450}',['Les*-N1450'],'K7609').
genotype(1410,201,'07R201:S0021113',2739,'07R2739:0035812','Mo20W','Mo20W','W23','Les1',['Les1'],'K1903').
genotype(1411,201,'07R201:S0021116',2798,'07R2798:0050315','Mo20W','Mo20W','W23','Les7',['Les7'],'K2312').
genotype(1412,201,'07R201:S0021902',1582,'07R1582:0069111','Mo20W','Mo20W','W23','W23/(Mo20W/Les19)',['Les19'],'K1504').
genotype(1413,201,'07R201:S0021907',2685,'07R2685:0078305','Mo20W','Mo20W','Mo20W/lls1','Mo20W/lls1',[lls1],'K1702').
genotype(1414,201,'07R201:S0021910',2738,'07R2738:0035910','Mo20W','Mo20W','W23','Les1',['Les1'],'K1903').
genotype(1415,300,'06R300:W00I0509',67,'06R0067:0006711','W23','W23','W23/M14','+/Les15-N2007',['Les15-N2007'],'K6711').
genotype(1416,300,'06R300:W00I8705',67,'06R0067:0006711','W23','W23','W23/M14','+/Les15-N2007',['Les15-N2007'],'K6711').
genotype(1417,201,'07R201:S0022203',1582,'07R1582:0069109','Mo20W','Mo20W','W23','W23/(Mo20W/Les19)',['Les19'],'K1504').
genotype(1418,201,'07R201:S0022501',1582,'07R1582:0069103','Mo20W','Mo20W','W23','W23/(Mo20W/Les19)',['Les19'],'K1504').
genotype(1419,201,'07R201:S0022504',2746,'07R2746:0037105','Mo20W','Mo20W','W23','Les1',['Les1'],'K1912').
genotype(1420,201,'07R201:S0022506',2448,'07R2448:0051513','Mo20W','Mo20W','Mo20W','Les8',['Les8'],'K0604').
genotype(1421,201,'07R201:S0022512',2632,'07R2632:0067901','Mo20W','Mo20W','Mo20W','Les19',['Les19'],'K1501').
genotype(1422,201,'07R201:S0022803',2580,'07R2580:0063506','Mo20W','Mo20W','Mo20W','Les17',['Les17'],'K1309').
genotype(1423,201,'07R201:S0023102',2504,'07R2504:0055207','Mo20W','Mo20W','Mo20W','Les9',['Les9'],'K0709').
genotype(1424,201,'07R201:S0023109',2524,'07R2524:0057802','Mo20W','Mo20W','Mo20W','Les11',['Les11'],'K0904').
genotype(1425,201,'07R201:S0024011',2523,'07R2523:0057915','Mo20W','Mo20W','M14','(M14/Mo20W)/Les11',['Les11'],'K0904').
genotype(1426,201,'07R201:S0024102',115,'07R0115:0086506','Mo20W','Mo20W','csp1/?','csp1/?',['csp1'],'K11506').
genotype(1427,201,'07R201:S0024105',115,'07R0115:0086508','Mo20W','Mo20W','csp1/?','csp1/?',['csp1'],'K11508').
genotype(1428,201,'07R201:S0024403',2284,'07R2284:0035111','Mo20W','Mo20W','Mo20W','Les1',['Les1'],'K0106').
genotype(1429,201,'07R201:S0025009',2340,'07R2340:0041013','Mo20W','Mo20W','Mo20W','(M14/Mo20W)/Les4',['Les4'],'K0303').
genotype(1430,300,'06R300:W00I6003',85,'06R0085:0008510','W23','W23','(B73/AG32)/Ht1','+/Les*-N2418',['Les*-N2418'],'K8510').
genotype(1431,300,'06R300:W00I6906',85,'06R0085:0008501','W23','W23','(B73/AG32)/Ht1','+/Les*-N2418',['Les*-N2418'],'K8501').
genotype(1432,201,'07R201:S0025014',2966,'07R2966:0090715','Mo20W','Mo20W','Mo20W/(W23/((B73/AG32)/Ht1))','Mo20W/(W23/Les*-N2418)',['Les*-N2418'],'K8501').
genotype(1433,201,'07R201:S0025017',2343,'07R2343:0040803','Mo20W','Mo20W','Mo20W','(M14/Mo20W)/Les4',['Les4'],'K0303').
%
% this is re-use of 1434 and correctly disambiguates Les2 from Les*-2397 in 1159
%
% Kazic, 29.4.2010
%
genotype(1434,201,'07R201:S0025301',2748,'07R2748:0039402','Mo20W','Mo20W','W23','Les2',['Les2'],'K2002').
genotype(1435,300,'06R300:W00I4914',91,'06R0091:0009113','W23','W23','(B73 Ht1)/Mo17','+/Les*-NA7145',['Les*-NA7145'],'K9113').
genotype(1436,201,'07R201:S0025303',2366,'07R2366:0044612','Mo20W','Mo20W','Mo20W','(M14/Mo20W)/Les6',['Les6'],'K0403').
genotype(1437,201,'07R201:S0025304',2281,'07R2281:0035402','Mo20W','Mo20W','Mo20W','Les1',['Les1'],'K0106').
genotype(1438,201,'07R201:S0025306',2740,'07R2740:0035708','Mo20W','Mo20W','W23','Les1',['Les1'],'K1903').
genotype(1439,300,'06R300:W00I6908',78,'06R0078:0007801','W23','W23','les*-N2013','les*-N2013',['les*-N2013'],'K7801').
genotype(1440,201,'07R201:S0025307',2636,'07R2636:0068903','Mo20W','Mo20W','Mo20W','(M14/Mo20W)/Les19',['Les19'],'K1504').
genotype(1441,201,'07R201:S0025309',2740,'07R2740:0035712','Mo20W','Mo20W','W23','Les1',['Les1'],'K1903').
genotype(1442,300,'06R300:W00I4208',82,'06R0082:0008203','W23','W23','{(B73/AG32)|(Ht1/les*-N2333A)}','{(B73/AG32)|(Ht1/les*-N2333A)}',['les*-N2333A'],'K8203').
genotype(1443,300,'06R300:W00I1310',82,'06R0082:0008211','W23','W23','{(B73/AG32)|(Ht1/les*-N2333A)}','{(B73/AG32)|(Ht1/les*-N2333A)}',['les*-N2333A'],'K8211').
genotype(1444,300,'06R300:W00I1314',83,'06R0083:0008304','W23','W23','{+|les*-N2363A}','{+|les*-N2363A}',['les*-N2363A'],'K8304').
genotype(1445,300,'06R300:W00I0203',87,'06R0087:0008709','W23','W23','les*-N2502','les*-N2502',['les*-N2502'],'K8709').
genotype(1446,201,'07R201:S0025311',2636,'07R2636:0068912','Mo20W','Mo20W','Mo20W','(M14/Mo20W)/Les19',['Les19'],'K1504').
%
% evidently lost or exhausted, not in inventory
%
% Kazic, 9.12.2010
%
genotype(1447,300,'06R300:W00I4913',92,'06R0092:0009207','W23','W23','{(W23/L317)|les*-2119}','{(W23/L317)|les*-2119}',['les*-2119'],'K9207').
genotype(1448,201,'07R201:S0025312',2660,'07R2660:0069205','Mo20W','Mo20W','Mo20W','Les19',['Les19'],'K1506').
genotype(1449,201,'07R201:S0025615',2348,'07R2348:0040704','Mo20W','Mo20W','M14','M14/Les4',['Les4'],'K0303').
genotype(1450,300,'06R300:W00I0217',93,'06R0093:0009304','W23','W23','+/les*-74-1873-9','les*-74-1873-9/les*-74-1873-9',['les*-74-1873-9'],'K9304').
genotype(1451,201,'07R201:S0025617',2738,'07R2738:0035914','Mo20W','Mo20W','W23','Les1',['Les1'],'K1903').
genotype(1452,201,'07R201:S0025902',2737,'07R2737:0036015','Mo20W','Mo20W','W23','(M14/W23)/Les1',['Les1'],'K1903').
genotype(1453,300,'06R300:W00I3503',7,'06R0007:0000707','W23','W23','Mo20W/+','Mo20W/Les9',['Les9'],'K0707').
genotype(1454,201,'07R201:S0025903',2736,'07R2736:0036211','Mo20W','Mo20W','M14','(M14/W23)/Les1',['Les1'],'K1903').
genotype(1455,201,'07R201:S0025904',2736,'07R2736:0036211','Mo20W','Mo20W','M14','(M14/W23)/Les1',['Les1'],'K1903').
genotype(1456,300,'06R300:W00I0511',75,'06R0075:0007501','W23','W23','les*-N1395C','les*-N1395C',['les*-N1395C'],'K7501').
genotype(1457,300,'06R300:W00I4206',77,'06R0077:0007708','W23','W23','{+|les*-N2012}','{+|les*-N2012}',['les*-N2012'],'K7708').
genotype(1458,300,'06R300:W00I0208',77,'06R0077:0007718','W23','W23','{+|les*-N2012}','{+|les*-N2012}',['les*-N2012'],'K7718').
genotype(1459,300,'06R300:W00I3809',7,'06R0007:0000709','W23','W23','Mo20W/+','Mo20W/Les9',['Les9'],'K0709').
genotype(1460,201,'07R201:S0025908',2440,'07R2440:0050501','Mo20W','Mo20W','Mo20W','Les8',['Les8'],'K0601').
genotype(1461,201,'07R201:S0025910',2733,'07R2733:0036406','Mo20W','Mo20W','M14','(M14/W23)/Les1',['Les1'],'K1903').
genotype(1462,201,'07R201:S0025911',2747,'07R2747:0037003','Mo20W','Mo20W','W23','Les1',['Les1'],'K1912').
genotype(1463,201,'07R201:S0025912',2747,'07R2747:0037006','Mo20W','Mo20W','W23','Les1',['Les1'],'K1912').
genotype(1464,201,'07R201:S0026211',2746,'07R2746:0037105','Mo20W','Mo20W','W23','Les1',['Les1'],'K1912').
genotype(1465,201,'07R201:S0026212',2624,'07R2624:0068106','Mo20W','Mo20W','Mo20W','Les19',['Les19'],'K1501').
genotype(1466,201,'07R201:S0026213',117,'07R0117:0087103','Mo20W','Mo20W','C-13/AG32','?/Les-EC91',['Les-EC91'],'K11703').
genotype(1467,201,'07R201:S0026215',2645,'07R2645:0068408','Mo20W','Mo20W','M14','(M14/Mo20W)/Les19',['Les19'],'K1504').
genotype(1468,201,'07R201:S0026216',2743,'07R2743:0037408','Mo20W','Mo20W','W23','Les1',['Les1'],'K1912').
genotype(1469,201,'07R201:S0026701',117,'07R0117:0087108','Mo20W','Mo20W','C-13/AG32','?/Les-EC91',['Les-EC91'],'K11708').
genotype(1470,201,'07R201:S0026709',2641,'07R2641:0068605','Mo20W','Mo20W','M14','(M14/Mo20W)/Les19',['Les19'],'K1504').
genotype(1471,201,'07R201:S0026710',117,'07R0117:0087109','Mo20W','Mo20W','C-13/AG32','?/Les-EC91',['Les-EC91'],'K11709').
genotype(1472,201,'07R201:S0026713',2966,'07R2966:0090713','Mo20W','Mo20W','Mo20W/(W23/((B73/AG32)/Ht1))','Mo20W/(W23/Les*-N2418)',['Les*-N2418'],'K8501').
genotype(1473,201,'07R201:S0026714',2966,'07R2966:0090715','Mo20W','Mo20W','Mo20W/(W23/((B73/AG32)/Ht1))','Mo20W/(W23/Les*-N2418)',['Les*-N2418'],'K8501').
genotype(1474,201,'07R201:S0026718',2620,'07R2620:0066801','Mo20W','Mo20W','Mo20W','Les18',['Les18'],'K1411').
genotype(1475,201,'07R201:S0027001',2287,'07R2287:0037512','Mo20W','Mo20W','Mo20W','Les9',['Les9'],'K0709').
genotype(1476,201,'07R201:S0027006',2761,'07R2761:0039810','Mo20W','Mo20W','W23','Les2',['Les2'],'K2011').
genotype(1477,201,'07R201:S0027010',2641,'07R2641:0068602','Mo20W','Mo20W','M14','(M14/Mo20W)/Les19',['Les19'],'K1504').
genotype(1478,201,'07R201:S0027304',2351,'07R2351:0040502','Mo20W','Mo20W','Mo20W','Les4',['Les4'],'K0303').
genotype(1479,201,'07R201:S0027305',2746,'07R2746:0037107','Mo20W','Mo20W','W23','Les1',['Les1'],'K1912').
genotype(1480,201,'07R201:S0027306',2351,'07R2351:0040501','Mo20W','Mo20W','Mo20W','Les4',['Les4'],'K0303').
genotype(1481,201,'07R201:S0027307',1435,'07R1435:0092303','Mo20W','Mo20W','W23','((B73 Ht1)/Mo17)/Les*-NA7145',['Les*-NA7145'],'K9113').
genotype(1482,201,'07R201:S0027311',2745,'07R2745:0037206','Mo20W','Mo20W','W23','Les1',['Les1'],'K1912').
genotype(1483,201,'07R201:S0027601',2786,'07R2786:0045303','Mo20W','Mo20W','Mo20W','(M14/W23)/Les6',['Les6'],'K2210').
genotype(1484,201,'07R201:S0027605',2324,'07R2324:0038413','Mo20W','Mo20W','Mo20W','Les2',['Les2'],'K0207').
genotype(1485,201,'07R201:S0027606',2624,'07R2624:0068108','Mo20W','Mo20W','Mo20W','Les19',['Les19'],'K1501').
genotype(1486,201,'07R201:S0027607',2577,'07R2577:0063604','Mo20W','Mo20W','Mo20W','Les17',['Les17'],'K1309').
genotype(1487,201,'07R201:S0027608',2752,'07R2752:0039005','Mo20W','Mo20W','W23','Les2',['Les2'],'K2002').
genotype(1488,201,'07R201:S0027609',2788,'07R2788:0045501','Mo20W','Mo20W','M14','(M14/W23)/Les6',['Les6'],'K2210').
genotype(1489,201,'07R201:S0027610',2346,'07R2346:0040606','Mo20W','Mo20W','Mo20W','(Mo20W/M14)/Les4',['Les4'],'K0303').
genotype(1490,201,'07R201:S0027612',2784,'07R2784:0045809','Mo20W','Mo20W','M14','(M14/W23)/Les6',['Les6'],'K2210').
genotype(1491,201,'07R201:S0027617',2624,'07R2624:0068112','Mo20W','Mo20W','Mo20W','Les19',['Les19'],'K1501').
genotype(1492,201,'07R201:S0027908',2277,'07R2277:0093502','Mo20W','Mo20W','M14','(M14/Mo20W)/Les1',['Les1'],'K0106').
genotype(1493,201,'07R201:S0027917',2290,'07R2290:0094205','Mo20W','Mo20W','Mo20W','Les9',['Les9'],'K0709').
genotype(1494,201,'07R201:S0028202',2488,'07R2488:0052508','Mo20W','Mo20W','M14','(M14/Mo20W)/Les8',['Les8'],'K0611').
genotype(1495,201,'07R201:S0028203',2753,'07R2753:0038902','Mo20W','Mo20W','W23','Les2',['Les2'],'K2002').
genotype(1496,201,'07R201:S0028205',2316,'07R2316:0038701','Mo20W','Mo20W','Mo20W','Les2',['Les2'],'K0207').
genotype(1497,201,'07R201:S0028206',115,'07R0115:0086503','Mo20W','Mo20W','csp1/?','csp1/?',['csp1'],'K11503').
genotype(1498,201,'07R201:S0028208',2427,'07R2427:0048502','Mo20W','Mo20W','W23','(W23/Mo20W)/Les7',['Les7'],'K0509').
genotype(1499,201,'07R201:S0028509',2363,'07R2363:0043306','Mo20W','Mo20W','M14','(M14/Mo20W)/Les6',['Les6'],'K0401').
genotype(1500,201,'07R201:S0028816',2495,'07R2495:0053408','Mo20W','Mo20W','M14','(M14/Mo20W)/Les8',['Les8'],'K0612').
genotype(1501,201,'07R201:S0029201',2348,'07R2348:0040709','Mo20W','Mo20W','M14','M14/Les4',['Les4'],'K0303').
genotype(1502,201,'07R201:S0029509',2742,'07R2742:0036806','Mo20W','Mo20W','W23','Les1',['Les1'],'K1909').
genotype(1503,201,'07R201:S0029802',2772,'07R2772:0042401','Mo20W','Mo20W','M14','(M14/W23)/Les4',['Les4'],'K2101').
genotype(1504,201,'07R201:S0029805',2343,'07R2343:0040803','Mo20W','Mo20W','Mo20W','(Mo20W/M14)/Les4',['Les4'],'K0303').
genotype(1505,201,'07R201:S0029808',2336,'07R2336:0041505','Mo20W','Mo20W','M14','M14/Les4',['Les4'],'K0303').
genotype(1506,201,'07R201:S0029810',2354,'07R2354:0040307','Mo20W','Mo20W','Mo20W','Les4',['Les4'],'K0303').
genotype(1507,201,'07R201:S0029811',2758,'07R2758:0039501','Mo20W','Mo20W','W23','Les2',['Les2'],'K2003').
genotype(1508,201,'07R201:S0029812',2807,'07R2807:0054001','Mo20W','Mo20W','W23','W23/Les8',['Les8'],'K2404').
genotype(1509,300,'06R300:W00I9303',103,'06R0103:0010307','W23','W23','ij2-N8','ij2-N8',['ij2-N8'],'K10307').
genotype(1510,300,'06R300:W00I6902',103,'06R0103:0010307','W23','W23','ij2-N8','ij2-N8',['ij2-N8'],'K10307').
genotype(1511,300,'06R300:W00I0514',104,'06R0104:0010405','W23','W23','{+|lep*-8691}','{+|lep*-8691}',['lep*-8691'],'K10405').
genotype(1512,201,'07R201:S0030104',2525,'07R2525:0057706','Mo20W','Mo20W','Mo20W','Les11',['Les11'],'K0904').
genotype(1513,201,'07R201:S0030108',2856,'07R2856:0059701','Mo20W','Mo20W','W23','(M14/W23)/Les12',['Les12'],'K2711').
genotype(1514,300,'06R300:W00I0804',107,'06R0107:0010712','W23','W23','{+|nec*-6853}','{+|nec*-6853}',['nec*-6853'],'K10712').
genotype(1515,201,'07R201:S0030111',2857,'07R2857:0059801','Mo20W','Mo20W','M14','(M14/W23)/Les12',['Les12'],'K2711').
genotype(1516,300,'06R300:W0I10305',107,'06R0107:0010701','W23','W23','{+|nec*-6853}','{+|nec*-6853}',['nec*-6853'],'K10701').
genotype(1517,201,'07R201:S0030112',2540,'07R2540:0061003','Mo20W','Mo20W','Mo20W','Les13',['Les13'],'K1109').
genotype(1518,201,'07R201:S0030403',2342,'07R2342:0041105','Mo20W','Mo20W','M14','M14/Les4',['Les4'],'K0303').
genotype(1519,201,'07R201:S0030405',2769,'07R2769:0042601','Mo20W','Mo20W','M14','(M14/W23)/Les4',['Les4'],'K2101').
genotype(1520,201,'07R201:S0030411',2772,'07R2772:0042408','Mo20W','Mo20W','M14','(M14/W23)/Les4',['Les4'],'K2101').
genotype(1521,300,'06R300:W00I8001',111,'06R0111:0011104','W23','W23','{(M14/W23)|vms*-8522}','{(M14/W23)|vms*-8522}',['vms*-8522'],'K11104').
genotype(1523,300,'06R300:W00I2703',112,'06R0112:0011202','W23','W23',zn1,zn1,[zn1],'K11202').
genotype(1524,201,'07R201:S0030414',2799,'07R2799:0050204','Mo20W','Mo20W','W23','Les7',['Les7'],'K2312').
genotype(1525,201,'07R201:S0030415',2799,'07R2799:0050209','Mo20W','Mo20W','W23','Les7',['Les7'],'K2312').
genotype(1526,300,'06R300:W00I6008',112,'06R0112:0011208','W23','W23',zn1,zn1,[zn1],'K11208').
genotype(1527,300,'06R300:W00I0810',112,'06R0112:0011205','W23','W23',zn1,zn1,[zn1],'K11205').
genotype(1528,300,'06R300:W00I6010',112,'06R0112:0011206','W23','W23',zn1,zn1,[zn1],'K11206').
genotype(1529,201,'07R201:S0030416',2797,'07R2797:0050403','Mo20W','Mo20W','W23','Les7',['Les7'],'K2312').
genotype(1530,300,'06R300:W00I0515',104,'06R0104:0010407','W23','W23','{+|lep*-8691}','{+|lep*-8691}',['lep*-8691'],'K10407').
genotype(1531,201,'07R201:S0030707',2363,'07R2363:0043303','Mo20W','Mo20W','M14','(M14/Mo20W)/Les6',['Les6'],'K0401').
genotype(1532,201,'07R201:S0030708',2867,'07R2867:0061912','Mo20W','Mo20W','W23','(M14/W23)/Les13',['Les13'],'K2805').
genotype(1533,201,'07R201:S0030710',2495,'07R2495:0053412','Mo20W','Mo20W','M14','(M14/Mo20W)/Les8',['Les8'],'K0612').
genotype(1534,201,'07R201:S0030711',1309,'07R1309:0046308','Mo20W','Mo20W','W23','W23/Les6',['Les6'],'K2210').
genotype(1535,201,'07R201:S0030715',2504,'07R2504:0055207','Mo20W','Mo20W','Mo20W','Les9',['Les9'],'K0709').
genotype(1536,201,'07R201:S0030716',2328,'07R2328:0040111','Mo20W','Mo20W','M14','M14/Les4',['Les4'],'K0302').
genotype(1537,201,'07R201:S0030717',2440,'07R2440:0050503','Mo20W','Mo20W','Mo20W','Les8',['Les8'],'K0601').
genotype(1538,201,'07R201:S0031001',2328,'07R2328:0040106','Mo20W','Mo20W','M14','M14/Les4',['Les4'],'K0302').
genotype(1539,201,'07R201:S0031002',2537,'07R2537:0061101','Mo20W','Mo20W','Mo20W','Les13',['Les13'],'K1109').
genotype(1540,201,'07R201:S0031012',2577,'07R2577:0063603','Mo20W','Mo20W','Mo20W','Les17',['Les17'],'K1309').
genotype(1541,201,'07R201:S0031508',2318,'07R2318:0038611','Mo20W','Mo20W','Mo20W','Les2',['Les2'],'K0207').
genotype(1542,201,'07R201:S0031512',2524,'07R2524:0057802','Mo20W','Mo20W','Mo20W','Les11',['Les11'],'K0904').
genotype(1543,201,'07R201:S0031801',2510,'07R2510:0057311','Mo20W','Mo20W','Mo20W','Les11',['Les11'],'K0901').
genotype(1544,201,'07R201:S0031802',2490,'07R2490:0053608','Mo20W','Mo20W','Mo20W','(M14/Mo20W)/Les8',['Les8'],'K0612').
genotype(1545,201,'07R201:S0031804',2498,'07R2498:0054904','Mo20W','Mo20W','Mo20W','Les9',['Les9'],'K0707').
genotype(1546,201,'07R201:S0031805',2513,'07R2513:0057207','Mo20W','Mo20W','Mo20W','Les11',['Les11'],'K0901').
genotype(1547,201,'07R201:S0031806',2490,'07R2490:0053604','Mo20W','Mo20W','Mo20W','(M14/Mo20W)/Les8',['Les8'],'K0612').
genotype(1548,201,'07R201:S0031809',2867,'07R2867:0061908','Mo20W','Mo20W','W23','(M14/W23)/Les13',['Les13'],'K2805').
genotype(1549,201,'07R201:S0031814',2513,'07R2513:0057212','Mo20W','Mo20W','Mo20W','Les11',['Les11'],'K0901').
genotype(1550,201,'07R201:S0032102',2454,'07R2454:0051211','Mo20W','Mo20W','Mo20W','Les8',['Les8'],'K0604').
genotype(1551,201,'07R201:S0032107',113,'07R0113:0086915','Mo20W','Mo20W','?/les23 Slm1','?/les23 Slm1',['les23 Slm1'],'K113xx').
genotype(1552,201,'07R201:S0032109',2488,'07R2488:0052509','Mo20W','Mo20W','M14','(M14/Mo20W)/Les8',['Les8'],'K0611').
genotype(1553,201,'07R201:S0032112',2364,'07R2364:0043204','Mo20W','Mo20W','M14','(M14/Mo20W)/Les6',['Les6'],'K0401').
genotype(1555,300,'06R300:W00I1707',3,'06R0003:0000304','W23','W23','Mo20W/+','Mo20W/Les4',['Les4'],'K0304').
genotype(1556,300,'06R300:W00I2016',4,'06R0004:0000403','W23','W23','Mo20W/+','Mo20W/Les6',['Les6'],'K0403').
genotype(1557,300,'06R300:W00I2014',4,'06R0004:0000401','W23','W23','Mo20W/+','Mo20W/Les6',['Les6'],'K0401').
genotype(1558,201,'07R201:S0032114',2489,'07R2489:0052406','Mo20W','Mo20W','Mo20W','(M14/Mo20W)/Les8',['Les8'],'K0611').
genotype(1559,201,'07R201:S0032402',2534,'07R2534:0061204','Mo20W','Mo20W','Mo20W','Les13',['Les13'],'K1109').
genotype(1560,201,'07R201:S0032408',2582,'07R2582:0063414','Mo20W','Mo20W','Mo20W','Les17',['Les17'],'K1309').
genotype(1561,201,'07R201:S0032413',2577,'07R2577:0063604','Mo20W','Mo20W','Mo20W','Les17',['Les17'],'K1309').
genotype(1562,300,'06R300:W00I1706',6,'06R0006:0000612','W23','W23','Mo20W/+','Mo20W/Les8',['Les8'],'K0612').
genotype(1563,300,'06R300:W00I1717',6,'06R0006:0000611','W23','W23','Mo20W/+','Mo20W/Les8',['Les8'],'K0611').
genotype(1564,201,'07R201:S0032414',2543,'07R2543:0061412','Mo20W','Mo20W','Mo20W','Les13',['Les13'],'K1113').
genotype(1565,201,'07R201:S0032705',2354,'07R2354:0040304','Mo20W','Mo20W','Mo20W','Les4',['Les4'],'K0303').
genotype(1566,300,'06R300:W00I2007',8,'06R0008:0000805','W23','W23','Mo20W/+','Mo20W/Les10',['Les10'],'K0805').
genotype(1567,201,'07R201:S0032707',2477,'07R2477:0053210','Mo20W','Mo20W','M14','(M14/Mo20W)/Les8',['Les8'],'K0611').
genotype(1568,201,'07R201:S0032713',2328,'07R2328:0040101','Mo20W','Mo20W','M14','M14/Les4',['Les4'],'K0302').
genotype(1569,300,'06R300:W00I2002',8,'06R0008:0000801','W23','W23','Mo20W/+','Mo20W/Les10',['Les10'],'K0801').
genotype(1570,300,'06R300:W00I5308',9,'06R0009:0000904','W23','W23','Mo20W/+','Mo20W/Les11',['Les11'],'K0904').
genotype(1571,300,'06R300:W00I2801',10,'06R0010:0001001','W23','W23','Mo20W/+','Mo20W/Les12',['Les12'],'K1001').
genotype(1572,300,'06R300:W00I2812',10,'06R0010:0001007','W23','W23','Mo20W/+','Mo20W/Les12',['Les12'],'K1007').
genotype(1573,201,'07R201:S0032717',2477,'07R2477:0053211','Mo20W','Mo20W','M14','(M14/Mo20W)/Les8',['Les8'],'K0611').
genotype(1574,201,'07R201:S0033005',2495,'07R2495:0053402','Mo20W','Mo20W','M14','(M14/Mo20W)/Les8',['Les8'],'K0612').
genotype(1575,201,'07R201:S0033006',2377,'07R2377:0044004','Mo20W','Mo20W','Mo20W','(M14/Mo20W)/Les6',['Les6'],'K0403').
genotype(1576,300,'06R300:W00I3506',13,'06R0013:0001305','W23','W23','Mo20W/+','Mo20W/Les17',['Les17'],'K1305').
genotype(1577,201,'07R201:S0033011',2787,'07R2787:0045404','Mo20W','Mo20W','W23','(M14/W23)/Les6',['Les6'],'K2210').
genotype(1578,300,'06R300:W00I6909',14,'06R0014:0001411','W23','W23','Mo20W/+','Mo20W/Les18',['Les18'],'K1411').
genotype(1579,201,'07R201:S0033303',2975,'07R2975:0092205','Mo20W','Mo20W','W23','(W23/(B73/Ht1))/Les*-NA7145)',['Les*-NA7145'],'K9113').
genotype(1580,201,'07R201:S0033304',2620,'07R2620:0066810','Mo20W','Mo20W','Mo20W','Les18',['Les18'],'K1411').
genotype(1581,300,'06R300:WI71.114',15,'06R0015:0001511','W23','W23','Mo20W/+','Mo20W/Les19',['Les19'],'K1504').
genotype(1582,300,'06R300:WI71.111',15,'06R0015:0001504','W23','W23','Mo20W/+','Mo20W/Les19',['Les19'],'K1504').
genotype(1583,201,'07R201:S0033602',2594,'07R2594:0065904','Mo20W','Mo20W','Mo20W','Les18',['Les18'],'K1406').
genotype(1584,300,'06R300:W00I7302',17,'06R0017:0001701','W23','W23','Mo20W/+','Mo20W/{+|lls1}',[lls1],'K1701').
genotype(1585,300,'06R300:W00I2305',17,'06R0017:0001703','W23','W23','Mo20W/+','Mo20W/{+|lls1}',[lls1],'K1703').
genotype(1586,300,'06R300:W00I7303',18,'06R0018:0001802','W23','W23','Mo20W/+','Mo20W/{+|les23}',[les23],'K1802').
genotype(1587,201,'07R201:S0033604',2613,'07R2613:0066401','Mo20W','Mo20W','Mo20W','Les18',['Les18'],'K1407').
genotype(1588,201,'07R201:S0033605',2318,'07R2318:0038611','Mo20W','Mo20W','Mo20W','Les2',['Les2'],'K0207').
genotype(1589,201,'07R201:S0033607',2836,'07R2836:0059002','Mo20W','Mo20W','W23','Les12',['Les12'],'K2702').
genotype(1590,201,'07R201:S0033608',2849,'07R2849:0060206','Mo20W','Mo20W','M14','(M14/W23)/Les12',['Les12'],'K2711').
genotype(1591,201,'07R201:S0033609',2613,'07R2613:0066408','Mo20W','Mo20W','Mo20W','Les18',['Les18'],'K1407').
genotype(1592,201,'07R201:S0033610',2620,'07R2620:0066809','Mo20W','Mo20W','Mo20W','Les18',['Les18'],'K1411').
genotype(1593,201,'07R201:S0033701',2739,'07R2739:0035801','Mo20W','Mo20W','W23','Les1',['Les1'],'K1903').
genotype(1594,201,'07R201:S0033705',2733,'07R2733:0036406','Mo20W','Mo20W','M14','(M14/W23)/Les1',['Les1'],'K1903').
genotype(1595,201,'07R201:S0033706',2602,'07R2602:0065706','Mo20W','Mo20W','Mo20W','Les18',['Les18'],'K1406').
genotype(1596,201,'07R201:S0033710',2608,'07R2608:0065512','Mo20W','Mo20W','Mo20W','Les18',['Les18'],'K1406').
genotype(1597,201,'07R201:S0033711',113,'07R0113:0086909','Mo20W','Mo20W','?/les23 Slm1','?/les23 Slm1',['les23 Slm1'],'K113xx').
genotype(1598,201,'07R201:S0033712',2513,'07R2513:0057213','Mo20W','Mo20W','Mo20W','Les11',['Les11'],'K0901').
genotype(1599,201,'07R201:S0033713',2805,'07R2805:0054201','Mo20W','Mo20W','W23','W23/Les8',['Les8'],'K2404').
genotype(1600,400,'06R400:M00I2412',1,'06R0001:0000104','M14','M14','Mo20W/+','Mo20W/Les1',['Les1'],'K0104').
genotype(1601,400,'06R400:M00I2102',1,'06R0001:0000104','M14','M14','Mo20W/+','Mo20W/Les1',['Les1'],'K0104').
genotype(1602,400,'06R400:M00I6106',3,'06R0003:0000303','M14','M14','Mo20W/+','Mo20W/Les4',['Les4'],'K0303').
genotype(1603,400,'06R400:M00I2104',3,'06R0003:0000302','M14','M14','Mo20W/+','Mo20W/Les4',['Les4'],'K0302').
genotype(1604,201,'07R201:S0033714',2540,'07R2540:0061006','Mo20W','Mo20W','Mo20W','Les13',['Les13'],'K1109').
genotype(1605,400,'06R400:M00I2109',4,'06R0004:0000403','M14','M14','Mo20W/+','Mo20W/Les6',['Les6'],'K0403').
genotype(1606,400,'06R400:M00I2112',4,'06R0004:0000405','M14','M14','Mo20W/+','Mo20W/Les6',['Les6'],'K0405').
genotype(1608,201,'07R201:S0033715',2733,'07R2733:0036408','Mo20W','Mo20W','M14','(M14/W23)/Les1',['Les1'],'K1903').
genotype(1609,400,'06R400:M00I1805',5,'06R0005:0000509','M14','M14','Mo20W/+','Mo20W/Les7',['Les7'],'K0509').
genotype(1610,201,'07R201:S0033716',2772,'07R2772:0042406','Mo20W','Mo20W','M14','(M14/W23)/Les4',['Les4'],'K2101').
genotype(1611,400,'06R400:M0I10707',6,'06R0006:0000612','M14','M14','Mo20W/+','Mo20W/Les8',['Les8'],'K0612').
genotype(1612,400,'06R400:M00I1806',6,'06R0006:0000611','M14','M14','Mo20W/+','Mo20W/Les8',['Les8'],'K0611').
genotype(1613,201,'07R201:S0034001',2882,'07R2882:0064711','Mo20W','Mo20W','W23','(M14/W23)/Les17',['Les17'],'K3007').
genotype(1614,400,'06R400:M00I2406',7,'06R0007:0000708','M14','M14','Mo20W/+','Mo20W/Les9',['Les9'],'K0708').
genotype(1615,400,'06R400:M00I3306',8,'06R0008:0000802','M14','M14','Mo20W/+','Mo20W/Les10',['Les10'],'K0802').
genotype(1616,400,'06R400:M00I3606',9,'06R0009:0000904','M14','M14','Mo20W/+','Mo20W/Les11',['Les11'],'K0904').
genotype(1617,400,'06R400:M00I3002',10,'06R0010:0001001','M14','M14','Mo20W/+','Mo20W/Les12',['Les12'],'K1001').
genotype(1618,201,'07R201:S0034002',1300,'07R1300:0036906','Mo20W','Mo20W','W23','Les1',['Les1'],'K1909').
genotype(1619,201,'07R201:S0034004',2454,'07R2454:0051202','Mo20W','Mo20W','Mo20W','Les8',['Les8'],'K0604').
genotype(1620,400,'06R400:M00I1815',13,'06R0013:0001309','M14','M14','Mo20W/+','Mo20W/Les17',['Les17'],'K1309').
genotype(1621,201,'07R201:S0034005',1015,'07R1015:0098406','Mo20W','Mo20W','Mo20W/+','Mo20W/Les4',['Les4'],'K0303').
genotype(1622,201,'07R201:S0034007',1015,'07R1015:0098406','Mo20W','Mo20W','Mo20W/+','Mo20W/Les4',['Les4'],'K0303').
genotype(1623,400,'06R400:M00I7403',15,'06R0015:0001511','M14','M14','Mo20W/+','Mo20W/Les19',['Les19'],'K1511').
%
% this next was mislabelled as K1509
%
% Kazic, 20.12.09
%
genotype(1624,400,'06R400:M00I6102',15,'06R0015:0001504','M14','M14','Mo20W/+','Mo20W/Les19',['Les19'],'K1504').
genotype(1625,400,'06R400:M00I7405',18,'06R0018:0001802','M14','M14','Mo20W/+','Mo20W/{+|les23}',[les23],'K1802').
genotype(1626,400,'06R400:M00I1818',17,'06R0017:0001703','M14','M14','Mo20W/+','Mo20W/{+|lls1}',[lls1],'K1703').
genotype(1627,400,'06R400:M00I7404',17,'06R0017:0001701','M14','M14','Mo20W/+','Mo20W/{+|lls1}',[lls1],'K1701').
genotype(1628,201,'07R201:S0034010',1036,'07R1036:0113001','Mo20W','Mo20W','Mo20W/+','Mo20W/Les17',['Les17'],'K1309').
genotype(1629,201,'07R201:S0034301',2316,'07R2316:0038701','Mo20W','Mo20W','Mo20W','Les2',['Les2'],'K0207').
genotype(1630,201,'07R201:S0034302',2502,'07R2502:0054808','Mo20W','Mo20W','Mo20W','Les9',['Les9'],'K0707').
genotype(1631,201,'07R201:S0034303',2316,'07R2316:0038712','Mo20W','Mo20W','Mo20W','Les2',['Les2'],'K0207').
genotype(1632,201,'07R201:S0034304',2753,'07R2753:0038902','Mo20W','Mo20W','W23','Les2',['Les2'],'K2002').
genotype(1633,201,'07R201:S0034307',2360,'07R2360:0043401','Mo20W','Mo20W','Mo20W','(M14/Mo20W)/Les6',['Les6'],'K0401').
genotype(1634,201,'07R201:S0034308',2504,'07R2504:0055201','Mo20W','Mo20W','Mo20W','Les9',['Les9'],'K0709').
genotype(1635,201,'07R201:S0034311',2513,'07R2513:0057213','Mo20W','Mo20W','Mo20W','Les11',['Les11'],'K0901').
genotype(1636,201,'07R201:S0034601',2526,'07R2526:0057605','Mo20W','Mo20W','Mo20W','Les11',['Les11'],'K0904').
genotype(1637,201,'07R201:S0034603',2747,'07R2747:0037012','Mo20W','Mo20W','W23','Les1',['Les1'],'K1912').
genotype(1638,201,'07R201:S0034605',2302,'07R2302:0038002','Mo20W','Mo20W','Mo20W','Les2',['Les2'],'K0203').
genotype(1639,201,'07R201:S0034606',2869,'07R2869:0061807','Mo20W','Mo20W','W23','W23/Les13',['Les13'],'K2805').
genotype(1640,201,'07R201:S0034607',2562,'07R2562:0063311','Mo20W','Mo20W','Mo20W','Les17',['Les17'],'K1302').
genotype(1641,201,'07R201:S0034610',2886,'07R2886:0064401','Mo20W','Mo20W','W23','W23/Les17',['Les17'],'K3007').
genotype(1642,201,'07R201:S0034612',2842,'07R2842:0060806','Mo20W','Mo20W','M14','(M14/W23)/Les12',['Les12'],'K2711').
genotype(1643,201,'07R201:S0034614',2890,'07R2890:0065408','Mo20W','Mo20W','W23','W23/Les17',['Les17'],'K3012').
genotype(1644,201,'07R201:S0034615',1303,'07R1303:0039703','Mo20W','Mo20W','W23','W23/Les2',['Les2'],'K2009').
genotype(1645,201,'07R201:S0085211',2429,'07R2429:0048315','Mo20W','Mo20W','Mo20W','Les7',['Les7'],'K0509').
genotype(1646,201,'07R201:S0085803',2407,'07R2407:0047516','Mo20W','Mo20W','Mo20W','Les7',['Les7'],'K0506').
genotype(1647,201,'07R201:S0085805',2394,'07R2394:0048101','Mo20W','Mo20W','Mo20W','Les7',['Les7'],'K0506').
genotype(1648,201,'07R201:S0119103',2413,'07R2413:0049402','Mo20W','Mo20W','Mo20W','(M14/Mo20W)/Les7',['Les7'],'K0509').
genotype(1649,201,'07R201:S0119104',2798,'07R2798:0050315','Mo20W','Mo20W','W23','Les7',['Les7'],'K2312').
genotype(1650,201,'07R201:S0119105',2495,'07R2495:0053409','Mo20W','Mo20W','M14','(M14/Mo20W)/Les8',['Les8'],'K0612').
genotype(1651,201,'07R201:S0119108',2857,'07R2857:0059806','Mo20W','Mo20W','M14','(M14/W23)/Les12',['Les12'],'K2711').
genotype(1652,201,'07R201:S0119113',2641,'07R2641:0068609','Mo20W','Mo20W','M14','(M14/Mo20W)/Les19',['Les19'],'K1504').
genotype(1653,201,'07R201:S0119115',2914,'07R2914:0071401','Mo20W','Mo20W','M14','(M14/W23)/Les19',['Les19'],'K3208').
genotype(1654,201,'07R201:S0119408',113,'07R0113:0086903','Mo20W','Mo20W','?/les23 Slm1','?/les23 Slm1',['les23 Slm1'],'K113xx').
genotype(1655,201,'07R201:S0119409',115,'07R0115:0086502','Mo20W','Mo20W','csp1/?','csp1/?',['csp1'],'K11502').
genotype(1656,201,'07R201:S0119410',2644,'07R2644:0116308','Mo20W','Mo20W','W23','(W23/(M14/Mo20W))/Les19',['Les19'],'K1504').
genotype(1657,201,'07R201:S0119413',2851,'07R2851:0060001','Mo20W','Mo20W','W23','(M14/W23)/Les12',['Les12'],'K2711').
genotype(1658,201,'07R201:S0119414',2413,'07R2413:0049401','Mo20W','Mo20W','Mo20W','(M14/Mo20W)/Les7',['Les7'],'K0509').
genotype(1659,201,'07R201:S0119415',1301,'07R1301:0093808','Mo20W','Mo20W','W23','Les1',['Les1'],'K1903').
genotype(1660,201,'07R201:S0119701',1302,'07R1302:0094102','Mo20W','Mo20W','W23','Les1',['Les1'],'K1912').
genotype(1661,201,'07R201:S0119706',1302,'07R1302:0094108','Mo20W','Mo20W','W23','Les1',['Les1'],'K1912').
genotype(1662,201,'07R201:S0119707',1036,'07R1036:0113001','Mo20W','Mo20W','Mo20W/+','Mo20W/Les17',['Les17'],'K1309').
genotype(1663,201,'07R201:S0119709',1302,'07R1302:0094109','Mo20W','Mo20W','W23','Les1',['Les1'],'K1912').
genotype(1664,201,'07R201:S0119711',1330,'07R1330:0067010','Mo20W','Mo20W','W23','W23/Les18',['Les18'],'K3103').
genotype(1665,201,'07R201:S0120001',1326,'07R1326:0113704','Mo20W','Mo20W','W23','W23/Les17',['Les17'],'K3007').
genotype(1666,301,'07R301:W0000211',116,'07R0116:0086403','W23','W23','?/Les5','?/Les5',['Les5'],'K11603').
genotype(1667,301,'07R301:W0000805',1330,'07R1330:0067010','W23','W23','W23','W23/Les18',['Les18'],'K3103').
genotype(1668,301,'07R301:W0000811',2495,'07R2495:0053412','W23','W23','M14','(M14/Mo20W)/Les8',['Les8'],'K0612').
genotype(1669,301,'07R301:W0001707',2281,'07R2281:0035415','W23','W23','Mo20W','Les1',['Les1'],'K0106').
genotype(1670,301,'07R301:W0002307',2772,'07R2772:0042408','W23','W23','M14','(M14/W23)/Les4',['Les4'],'K2101').
genotype(1671,301,'07R301:W0002603',2364,'07R2364:0043204','W23','W23','M14','(M14/Mo20W)/Les6',['Les6'],'K0401').
genotype(1672,301,'07R301:W0002606',2769,'07R2769:0042601','W23','W23','M14','(M14/W23)/Les4',['Les4'],'K2101').
genotype(1673,301,'07R301:W0002609',1582,'07R1582:0069111','W23','W23','W23','W23/(Mo20W/Les19)',['Les19'],'K1504').
genotype(1674,301,'07R301:W0004102',1302,'07R1302:0094101','W23','W23','W23','Les1',['Les1'],'K1912').
genotype(1675,301,'07R301:W0005604',2906,'07R2906:0070801','W23','W23','W23','W23/Les19',['Les19'],'K3206').
genotype(1676,301,'07R301:W0007403',2801,'07R2801:0050007','W23','W23','W23','Les7',['Les7'],'K2312').
genotype(1677,301,'07R301:W0007405',2732,'07R2732:0036309','W23','W23','W23','(M14/W23)/Les1',['Les1'],'K1903').
genotype(1678,301,'07R301:W0008001',2567,'07R2567:0063216','W23','W23','Mo20W','Les17',['Les17'],'K1302').
genotype(1679,301,'07R301:W0008305',2873,'07R2873:0062408','W23','W23','M14','(M14/W23)/Les13',['Les13'],'K2808').
genotype(1680,301,'07R301:W0014607',2906,'07R2906:0070809','W23','W23','W23','W23/Les19',['Les19'],'K3206').
genotype(1681,301,'07R301:W0015807',2281,'07R2281:0035403','W23','W23','Mo20W','Les1',['Les1'],'K0106').
genotype(1682,301,'07R301:W0015814',2281,'07R2281:0035401','W23','W23','Mo20W','Les1',['Les1'],'K0106').
genotype(1683,301,'07R301:W0016109',2903,'07R2903:0070211','W23','W23','W23','W23/Les19',['Les19'],'K3204').
genotype(1684,301,'07R301:W0016703',2742,'07R2742:0036806','W23','W23','W23','Les1',['Les1'],'K1909').
genotype(1685,301,'07R301:W0016706',2742,'07R2742:0036810','W23','W23','W23','Les1',['Les1'],'K1909').
genotype(1686,301,'07R301:W0017004',1300,'07R1300:0036906','W23','W23','W23','Les1',['Les1'],'K1909').
genotype(1687,301,'07R301:W0017302',2360,'07R2360:0043409','W23','W23','Mo20W','(M14/Mo20W)/Les6',['Les6'],'K0401').
genotype(1688,301,'07R301:W0017310',2283,'07R2283:0035209','W23','W23','Mo20W','Les1',['Les1'],'K0106').
genotype(1689,301,'07R301:W0017613',2746,'07R2746:0037105','W23','W23','W23','Les1',['Les1'],'K1912').
genotype(1690,301,'07R301:W0018511',2905,'07R2905:0070906','W23','W23','W23','W23/Les19',['Les19'],'K3206').
genotype(1691,301,'07R301:W0019701',2967,'07R2967:0090809','W23','W23','W23','(W23/((B73/AG32)/Ht1))/(W23/Les*-N2418)',['Les*-N2418'],'K8501').
genotype(1692,301,'07R301:W0020310',2799,'07R2799:0050204','W23','W23','W23','Les7',['Les7'],'K2312').
genotype(1693,301,'07R301:W0020601',2342,'07R2342:0041105','W23','W23','M14','(M14/Mo20W)/Les4',['Les4'],'K0303').
genotype(1694,301,'07R301:W0020910',2543,'07R2543:0061412','W23','W23','Mo20W','Les13',['Les13'],'K1113').
genotype(1695,301,'07R301:W0021202',2283,'07R2283:0035213','W23','W23','Mo20W','Les1',['Les1'],'K0106').
genotype(1696,301,'07R301:W0021203',2282,'07R2282:0035303','W23','W23','Mo20W','Les1',['Les1'],'K0106').
genotype(1697,301,'07R301:W0021205',2276,'07R2276:0035602','W23','W23','Mo20W','Les1',['Les1'],'K0106').
genotype(1698,301,'07R301:W0021207',2740,'07R2740:0035714','W23','W23','W23','Les1',['Les1'],'K1903').
genotype(1699,301,'07R301:W0021208',2739,'07R2739:0035803','W23','W23','W23','Les1',['Les1'],'K1903').
genotype(1700,400,'06R400:M00I7408',19,'06R0019:0001909','M14','M14','W23/+','W23/Les1',['Les1'],'K1909').
genotype(1701,400,'06R400:M00I7406',19,'06R0019:0001903','M14','M14','W23/+','W23/Les1',['Les1'],'K1903').
genotype(1702,301,'07R301:W0021210',2322,'07R2322:0038513','W23','W23','Mo20W','Les2',['Les2'],'K0207').
genotype(1703,400,'06R400:M00I7807',20,'06R0020:0002009','M14','M14','W23/+','W23/Les2',['Les2'],'K2009').
genotype(1704,301,'07R301:W0021211',2738,'07R2738:0035903','W23','W23','W23','Les1',['Les1'],'K1903').
genotype(1705,400,'06R400:M00I7810',21,'06R0021:0002101','M14','M14','W23/+','W23/Les4',['Les4'],'K2101').
genotype(1707,301,'07R301:W0021813',2798,'07R2798:0050301','W23','W23','W23','Les7',['Les7'],'K2312').
genotype(1708,301,'07R301:W0022105',2737,'07R2737:0036006','W23','W23','W23','(M14/W23)/Les1',['Les1'],'K1903').
genotype(1709,301,'07R301:W0022109',2318,'07R2318:0038611','W23','W23','Mo20W','Les2',['Les2'],'K0207').
genotype(1710,301,'07R301:W0022110',2746,'07R2746:0037106','W23','W23','W23','Les1',['Les1'],'K1912').
genotype(1711,301,'07R301:W0022401',2761,'07R2761:0039810','W23','W23','W23','Les2',['Les2'],'K2011').
genotype(1712,400,'06R400:M00I8405',26,'06R0026:0002613','M14','M14','W23/+','W23/Les10',['Les10'],'K2613').
genotype(1713,400,'06R400:M00I8409',27,'06R0027:0002711','M14','M14','W23/+','W23/Les12',['Les12'],'K2711').
genotype(1714,400,'06R400:M00I8501',28,'06R0028:0002808','M14','M14','W23/+','W23/Les13',['Les13'],'K2808').
genotype(1715,400,'06R400:M00I8412',28,'06R0028:0002805','M14','M14','W23/+','W23/Les13',['Les13'],'K2805').
genotype(1716,400,'06R400:M00I8411',28,'06R0028:0002802','M14','M14','W23/+','W23/Les13',['Les13'],'K2802').
genotype(1717,301,'07R301:W0022410',2738,'07R2738:0035910','W23','W23','W23','Les1',['Les1'],'K1903').
genotype(1718,301,'07R301:W0022701',2379,'07R2379:0044115','W23','W23','M14','(M14/Mo20W)/Les6',['Les6'],'K0403').
genotype(1719,400,'06R400:M00I8503',30,'06R0030:0003007','M14','M14','W23/+','W23/Les17',['Les17'],'K3007').
genotype(1720,301,'07R301:W0023006',2770,'07R2770:0042507','W23','W23','W23','(M14/W23)/Les4',['Les4'],'K2101').
genotype(1721,301,'07R301:W0023308',2340,'07R2340:0041013','W23','W23','Mo20W','(M14/Mo20W)/Les4',['Les4'],'K0303').
genotype(1722,301,'07R301:W0023906',2345,'07R2345:0040908','W23','W23','M14','(M14/Mo20W)/Les4',['Les4'],'K0303').
genotype(1724,400,'06R400:M00I8508',32,'06R0032:0003204','M14','M14','W23/+','W23/Les19',['Les19'],'K3204').
genotype(1726,301,'07R301:W0023908',2348,'07R2348:0040709','W23','W23','M14','(M14/Mo20W)/Les4',['Les4'],'K0303').
genotype(1727,301,'07R301:W0024201',115,'07R0115:0086506','W23','W23','csp1/?','csp1/?',['csp1'],'K11506').
genotype(1728,301,'07R301:W0024206',115,'07R0115:0086508','W23','W23','csp1/?','csp1/?',['csp1'],'K11508').
genotype(1729,400,'06R400:M00I1801',35,'06R0035:0003509','M14','M14','W23/+','W23/{+|les23}',[les23],'K3509').
genotype(1730,301,'07R301:W0024209',2504,'07R2504:0055213','W23','W23','Mo20W','Les9',['Les9'],'K0709').
genotype(1731,301,'07R301:W0024505',116,'07R0116:0086413','W23','W23','?/Les5','?/Les5',['Les5'],'K11613').
genotype(1732,301,'07R301:W0024508',2851,'07R2851:0060001','W23','W23','W23','(M14/W23)/Les12',['Les12'],'K2711').
genotype(1733,301,'07R301:W0024509',2836,'07R2836:0059002','W23','W23','W23','Les12',['Les12'],'K2702').
genotype(1734,301,'07R301:W0025104',1011,'07R1011:0042006','W23','W23','Mo20W','Mo20W/Les4',['Les4'],'K0304').
genotype(1735,301,'07R301:W0025106',2771,'07R2771:0042301','W23','W23','W23','(M14/W23)/Les4',['Les4'],'K2101').
genotype(1736,301,'07R301:W0025110',2748,'07R2748:0039402','W23','W23','W23','Les2',['Les2'],'K2002').
genotype(1737,301,'07R301:W0025111',2793,'07R2793:0049711','W23','W23','W23','Les7',['Les7'],'K2304').
genotype(1738,301,'07R301:W0025407',2347,'07R2347:0040803','W23','W23','W23','(W23/M14)/(Mo20W/Les4)',['Les4'],'K0303').
genotype(1739,301,'07R301:W0025409',1011,'07R1011:0042006','W23','W23','Mo20W','Mo20W/Les4',['Les4'],'K0304').
genotype(1740,301,'07R301:W0025412',2281,'07R2281:0035402','W23','W23','Mo20W','Les1',['Les1'],'K0106').
genotype(1741,301,'07R301:W0025701',2740,'07R2740:0035708','W23','W23','W23','Les1',['Les1'],'K1903').
genotype(1742,301,'07R301:W0025705',2736,'07R2736:0036211','W23','W23','M14','(M14/W23)/Les1',['Les1'],'K1903').
genotype(1743,301,'07R301:W0025707',2740,'07R2740:0035712','W23','W23','W23','Les1',['Les1'],'K1903').
genotype(1744,301,'07R301:W0025711',2290,'07R2290:0094202','W23','W23','Mo20W','Les9',['Les9'],'K0709').
genotype(1745,301,'07R301:W0026004',2747,'07R2747:0037006','W23','W23','W23','Les1',['Les1'],'K1912').
genotype(1746,301,'07R301:W0026007',2743,'07R2743:0037408','W23','W23','W23','Les1',['Les1'],'K1912').
genotype(1747,301,'07R301:W0026603',2801,'07R2801:0050011','W23','W23','W23','Les7',['Les7'],'K2312').
genotype(1748,301,'07R301:W0026903',2287,'07R2287:0037512','W23','W23','Mo20W','Les9',['Les9'],'K0709').
genotype(1749,301,'07R301:W0026909',2920,'07R2920:0071803','W23','W23','W23','Les19',['Les19'],'K3209').
genotype(1750,301,'07R301:W0027205',2737,'07R2737:0036015','W23','W23','W23','(M14/W23)/Les1',['Les1'],'K1903').
genotype(1751,301,'07R301:W0027207',2739,'07R2739:0035812','W23','W23','W23','Les1',['Les1'],'K1903').
genotype(1752,301,'07R301:W0027210',2747,'07R2747:0037003','W23','W23','W23','Les1',['Les1'],'K1912').
genotype(1753,301,'07R301:W0027212',2836,'07R2836:0059004','W23','W23','W23','Les12',['Les12'],'K2702').
genotype(1754,301,'07R301:W0027213',2448,'07R2448:0051513','W23','W23','Mo20W','Les8',['Les8'],'K0604').
genotype(1755,301,'07R301:W0027507',2340,'07R2340:0041011','W23','W23','Mo20W','(M14/Mo20W)/Les4',['Les4'],'K0303').
genotype(1756,301,'07R301:W0027510',2366,'07R2366:0044612','W23','W23','Mo20W','(M14/Mo20W)/Les6',['Les6'],'K0403').
genotype(1757,301,'07R301:W0027511',2770,'07R2770:0042506','W23','W23','W23','(M14/W23)/Les4',['Les4'],'K2101').
genotype(1758,301,'07R301:W0027513',2821,'07R2821:0056003','W23','W23','W23','Les9',['Les9'],'K2512').
genotype(1759,301,'07R301:W0027514',2771,'07R2771:0042301','W23','W23','W23','(M14/W23)/Les4',['Les4'],'K2101').
genotype(1760,301,'07R301:W0027809',2758,'07R2758:0039501','W23','W23','W23','Les2',['Les2'],'K2003').
genotype(1761,301,'07R301:W0027810',2836,'07R2836:0059012','W23','W23','W23','Les12',['Les12'],'K2702').
genotype(1762,301,'07R301:W0027811',2316,'07R2316:0038701','W23','W23','Mo20W','Les2',['Les2'],'K0207').
genotype(1763,301,'07R301:W0027812',2641,'07R2641:0068602','W23','W23','M14','(M14/Mo20W)/Les19',['Les19'],'K1504').
genotype(1764,301,'07R301:W0028103',2316,'07R2316:0038701','W23','W23','Mo20W','Les2',['Les2'],'K0207').
genotype(1765,301,'07R301:W0028104',2738,'07R2738:0035914','W23','W23','W23','Les1',['Les1'],'K1903').
genotype(1766,301,'07R301:W0028107',2754,'07R2754:0038808','W23','W23','W23','Les2',['Les2'],'K2002').
genotype(1767,301,'07R301:W0028112',2753,'07R2753:0038902','W23','W23','W23','Les2',['Les2'],'K2002').
genotype(1768,301,'07R301:W0028405',2363,'07R2363:0043306','W23','W23','M14','(M14/Mo20W)/Les6',['Les6'],'K0401').
genotype(1769,301,'07R301:W0028408',1309,'07R1309:0046308','W23','W23','W23','W23/Les6',['Les6'],'K2210').
genotype(1770,301,'07R301:W0028411',2920,'07R2920:0071802','W23','W23','W23','Les19',['Les19'],'K3209').
genotype(1771,301,'07R301:W0029002',2742,'07R2742:0036806','W23','W23','W23','Les1',['Les1'],'K1909').
genotype(1772,301,'07R301:W0029003',2823,'07R2823:0056401','W23','W23','W23','Les10',['Les10'],'K2606').
genotype(1773,301,'07R301:W0029004',2797,'07R2797:0050403','W23','W23','W23','Les7',['Les7'],'K2312').
genotype(1774,301,'07R301:W0029006',2823,'07R2823:0056406','W23','W23','W23','Les10',['Les10'],'K2606').
genotype(1775,301,'07R301:W0029305',2771,'07R2771:0042302','W23','W23','W23','(M14/W23)/Les4',['Les4'],'K2101').
genotype(1776,301,'07R301:W0029306',2746,'07R2746:0037107','W23','W23','W23','Les1',['Les1'],'K1912').
genotype(1777,301,'07R301:W0029308',2875,'07R2875:0062212','W23','W23','M14','(M14/W23)/Les13',['Les13'],'K2808').
genotype(1778,301,'07R301:W0029309',2340,'07R2340:0041011','W23','W23','Mo20W','(M14/Mo20W)/Les4',['Les4'],'K0303').
genotype(1779,301,'07R301:W0029311',2343,'07R2343:0040808','W23','W23','Mo20W','(M14/Mo20W)/Les4',['Les4'],'K0303').
genotype(1780,301,'07R301:W0029601',2869,'07R2869:0061807','W23','W23','W23','W23/Les13',['Les13'],'K2805').
genotype(1781,301,'07R301:W0029603',1322,'07R1322:0062501','W23','W23','W23','W23/Les13',['Les13'],'K2808').
genotype(1782,301,'07R301:W0029608',2336,'07R2336:0041505','W23','W23','M14','(M14/Mo20W)/Les4',['Les4'],'K0303').
genotype(1783,301,'07R301:W0029609',1337,'07R1337:0073309','W23','W23','W23','W23/{+|les23}',[les23],'K3503').
genotype(1784,301,'07R301:W0029610',2748,'07R2748:0039402','W23','W23','W23','Les2',['Les2'],'K2002').
genotype(1785,301,'07R301:W0029613',2898,'07R2898:0067602','W23','W23','W23','W23/Les18',['Les18'],'K3106').
genotype(1786,301,'07R301:W0029615',2745,'07R2745:0037206','W23','W23','W23','Les1',['Les1'],'K1912').
genotype(1787,301,'07R301:W0029616',2752,'07R2752:0039005','W23','W23','W23','Les2',['Les2'],'K2002').
genotype(1788,301,'07R301:W0029617',2886,'07R2886:0064401','W23','W23','W23','W23/Les17',['Les17'],'K3007').
genotype(1789,301,'07R301:W0029906',2799,'07R2799:0050209','W23','W23','W23','Les7',['Les7'],'K2312').
genotype(1790,301,'07R301:W0029909',2758,'07R2758:0039501','W23','W23','W23','Les2',['Les2'],'K2003').
genotype(1791,301,'07R301:W0030204',2514,'07R2514:0057102','W23','W23','Mo20W','Les11',['Les11'],'K0901').
genotype(1792,301,'07R301:W0030210',2340,'07R2340:0041013','W23','W23','Mo20W','(M14/Mo20W)/Les4',['Les4'],'K0303').
genotype(1793,301,'07R301:W0030213',2525,'07R2525:0057706','W23','W23','Mo20W','Les11',['Les11'],'K0904').
genotype(1794,301,'07R301:W0030216',2613,'07R2613:0066401','W23','W23','Mo20W','Les18',['Les18'],'K1407').
genotype(1795,301,'07R301:W0030501',2632,'07R2632:0067901','W23','W23','Mo20W','Les19',['Les19'],'K1501').
genotype(1796,301,'07R301:W0030503',2351,'07R2351:0040502','W23','W23','Mo20W','Les4',['Les4'],'K0303').
genotype(1797,301,'07R301:W0030507',2967,'07R2967:0090803','W23','W23','W23','(W23/((B73/AG32)/Ht1))/(W23/Les*-N2418)',['Les*-N2418'],'K8501').
genotype(1798,301,'07R301:W0030510',2351,'07R2351:0040501','W23','W23','Mo20W','Les4',['Les4'],'K0303').
genotype(1799,301,'07R301:W0030511',2329,'07R2329:0041801','W23','W23','Mo20W','(M14/Mo20W)/Les4',['Les4'],'K0303').
genotype(1800,301,'07R301:W0030512',1322,'07R1322:0062501','W23','W23','W23','W23/Les13',['Les13'],'K2808').
genotype(1801,400,'06R400:M00I2413',54,'06R0054:0005404','M14','M14','{B73 Ht1|+}/{?|+}','+/Les1-N843',['Les1-N843'],'K5404').
genotype(1802,301,'07R301:W0030514',2328,'07R2328:0040111','W23','W23','M14','(M14/Mo20W)/Les4',['Les4'],'K0302').
genotype(1803,301,'07R301:W0030516',2800,'07R2800:0050112','W23','W23','W23','Les7',['Les7'],'K2312').
genotype(1804,301,'07R301:W0030517',2345,'07R2345:0040604','W23','W23','M14','(M14/Mo20W)/Les4',['Les4'],'K0303').
genotype(1805,400,'06R400:M00I2116',55,'06R0055:0005525','M14','M14','Les2-N845A/+','M14/W23',['Les2-N845A'],'K5525').
genotype(1806,301,'07R301:W0030801',2302,'07R2302:0038002','W23','W23','Mo20W','Les2',['Les2'],'K0203').
genotype(1807,301,'07R301:W0031109',2797,'07R2797:0050406','W23','W23','W23','Les7',['Les7'],'K2312').
genotype(1808,301,'07R301:W0031401',2363,'07R2363:0043308','W23','W23','M14','(M14/Mo20W)/Les6',['Les6'],'K0401').
genotype(1809,301,'07R301:W0031411',2807,'07R2807:0054003','W23','W23','W23','W23/Les8',['Les8'],'K2404').
genotype(1810,301,'07R301:W0031709',2805,'07R2805:0054201','W23','W23','W23','W23/Les8',['Les8'],'K2404').
genotype(1811,301,'07R301:W0032001',2348,'07R2348:0040704','W23','W23','M14','(M14/Mo20W)/Les4',['Les4'],'K0303').
genotype(1812,301,'07R301:W0032002',2348,'07R2348:0040709','W23','W23','M14','(M14/Mo20W)/Les4',['Les4'],'K0303').
genotype(1813,301,'07R301:W0032010',2510,'07R2510:0057311','W23','W23','Mo20W','Les11',['Les11'],'K0901').
genotype(1814,301,'07R301:W0032012',2513,'07R2513:0057212','W23','W23','Mo20W','Les11',['Les11'],'K0901').
genotype(1815,301,'07R301:W0032306',2525,'07R2525:0057713','W23','W23','Mo20W','Les11',['Les11'],'K0904').
genotype(1817,301,'07R301:W0032307',2856,'07R2856:0059701','W23','W23','W23','(M14/W23)/Les12',['Les12'],'K2711').
genotype(1818,301,'07R301:W0032311',2889,'07R2889:0064108','W23','W23','W23','W23/Les17',['Les17'],'K3007').
genotype(1819,301,'07R301:W0032604',1327,'07R1327:0065303','W23','W23','W23','W23/Les17',['Les17'],'K3007').
genotype(1820,301,'07R301:W0032605',2798,'07R2798:0050315','W23','W23','W23','Les7',['Les7'],'K2312').
genotype(1821,301,'07R301:W0032608',2346,'07R2346:0040606','W23','W23','Mo20W','(M14/Mo20W)/Les4',['Les4'],'K0303').
genotype(1822,301,'07R301:W0032611',2354,'07R2354:0040304','W23','W23','Mo20W','Les4',['Les4'],'K0303').
genotype(1823,301,'07R301:W0032613',2440,'07R2440:0050501','W23','W23','Mo20W','Les8',['Les8'],'K0601').
genotype(1824,301,'07R301:W0032903',2787,'07R2787:0045404','W23','W23','W23','(M14/W23)/Les6',['Les6'],'K2210').
genotype(1825,301,'07R301:W0032906',2440,'07R2440:0050503','W23','W23','Mo20W','Les8',['Les8'],'K0601').
genotype(1826,400,'06R400:M00I2905',84,'06R0084:0008414','M14','M14','{+|Les*-N2397}','{+|Les*-N2397}',['Les*-N2397'],'K8414').
genotype(1827,301,'07R301:W0033204',2336,'07R2336:0041502','W23','W23','M14','(M14/Mo20W)/Les4',['Les4'],'K0303').
genotype(1828,301,'07R301:W0033207',2799,'07R2799:0050209','W23','W23','W23','Les7',['Les7'],'K2312').
genotype(1829,400,'06R400:M0I10804',75,'06R0075:0007501','M14','M14','les*-N1395C','les*-N1395C',['les*-N1395C'],'K7501').
genotype(1830,400,'06R400:M00I7011',75,'06R0075:0007501','M14','M14','les*-N1395C','les*-N1395C',['les*-N1395C'],'K7501').
genotype(1831,400,'06R400:M00I1510',77,'06R0077:0007708','M14','M14','{+|les*-N2012}','{+|les*-N2012}',['les*-N2012'],'K7708').
genotype(1832,400,'06R400:M0I10902',77,'06R0077:0007718','M14','M14','{+|les*-N2012}','{+|les*-N2012}',['les*-N2012'],'K7718').
genotype(1833,400,'06R400:M00I6504',78,'06R0078:0007801','M14','M14','les*-N2013','les*-N2013',['les*-N2013'],'K7801').
genotype(1834,301,'07R301:W0033208',1315,'07R1315:0053906','W23','W23','W23','W23/Les8',['Les8'],'K2402').
genotype(1835,301,'07R301:W0033507',2318,'07R2318:0038611','W23','W23','Mo20W','Les2',['Les2'],'K0207').
genotype(1836,301,'07R301:W0033510',2427,'07R2427:0048504','W23','W23','W23','(W23/Mo20W)/Les7',['Les7'],'K0509').
genotype(1837,400,'06R400:M00I9604',83,'06R0083:0008304','M14','M14','{+|les*-N2363A}','{+|les*-N2363A}',['les*-N2363A'],'K8304').
genotype(1838,400,'06R400:M00I0302',87,'06R0087:0008709','M14','M14','les*-N2502','les*-N2502',['les*-N2502'],'K8709').
genotype(1839,301,'07R301:W0033515',2801,'07R2801:0050003','W23','W23','W23','Les7',['Les7'],'K2312').
genotype(1840,301,'07R301:W0033801',2739,'07R2739:0035801','W23','W23','W23','Les1',['Les1'],'K1903').
genotype(1841,301,'07R301:W0033802',2733,'07R2733:0036406','W23','W23','M14','(M14/W23)/Les1',['Les1'],'K1903').
genotype(1842,301,'07R301:W0033809',2733,'07R2733:0036408','W23','W23','M14','(M14/W23)/Les1',['Les1'],'K1903').
genotype(1843,301,'07R301:W0033813',2878,'07R2878:0065211','W23','W23','M14','(M14/W23)/Les17',['Les17'],'K3007').
genotype(1844,301,'07R301:W0033815',1435,'07R1435:0092303','W23','W23','W23','((B73 Ht1)/Mo17)/Les*-NA7145',['Les*-NA7145'],'K9113').
genotype(1845,400,'06R400:M00I7808',92,'06R0092:0009207','M14','M14','{(W23/L317)|les*-2119}','{(W23/L317)|les*-2119}',['les*-2119'],'K9207').
genotype(1846,301,'07R301:W0034101',2882,'07R2882:0064711','W23','W23','W23','(M14/W23)/Les17',['Les17'],'K3007').
genotype(1847,301,'07R301:W0034102',1315,'07R1315:0053901','W23','W23','W23','W23/Les8',['Les8'],'K2402').
genotype(1848,400,'06R400:M00I0306',93,'06R0093:0009304','M14','M14','+/les*-74-1873-9','les*-74-1873-9/les*-74-1873-9',['les*-74-1873-9'],'K9304').
genotype(1849,400,'06R400:MI53.302',105,'06R0105:0010502','M14','M14','{+|lls1-N501B}','{+|lls1-N501B}',['lls1-N501B'],'K10502').
genotype(1850,301,'07R301:W0034103',2807,'07R2807:0054001','W23','W23','W23','W23/Les8',['Les8'],'K2404').
genotype(1851,301,'07R301:W0034104',2783,'07R2783:0045708','W23','W23','W23','(M14/W23)/Les6',['Les6'],'K2210').
genotype(1852,301,'07R301:W0034105',2454,'07R2454:0051202','W23','W23','Mo20W','Les8',['Les8'],'K0604').
genotype(1853,301,'07R301:W0034106',2742,'07R2742:0036806','W23','W23','W23','Les1',['Les1'],'K1909').
genotype(1854,301,'07R301:W0034108',1300,'07R1300:0036906','W23','W23','W23','Les1',['Les1'],'K1909').
genotype(1855,301,'07R301:W0034110',2890,'07R2890:0065409','W23','W23','W23','W23/Les17',['Les17'],'K3012').
genotype(1856,301,'07R301:W0034401',2316,'07R2316:0038712','W23','W23','Mo20W','Les2',['Les2'],'K0207').
genotype(1857,301,'07R301:W0034402',2753,'07R2753:0038902','W23','W23','W23','Les2',['Les2'],'K2002').
genotype(1858,301,'07R301:W0034403',2746,'07R2746:0037105','W23','W23','W23','Les1',['Les1'],'K1912').
genotype(1859,301,'07R301:W0034406',2889,'07R2889:0064109','W23','W23','W23','W23/Les17',['Les17'],'K3007').
genotype(1860,301,'07R301:W0034409',2886,'07R2886:0064402','W23','W23','W23','W23/Les17',['Les17'],'K3007').
genotype(1861,301,'07R301:W0034411',2761,'07R2761:0039810','W23','W23','W23','Les2',['Les2'],'K2011').
genotype(1862,301,'07R301:W0034412',1303,'07R1303:0039703','W23','W23','W23','W23/Les2',['Les2'],'K2009').
genotype(1863,301,'07R301:W0034414',2784,'07R2784:0045803','W23','W23','M14','(M14/W23)/Les6',['Les6'],'K2210').
genotype(1864,301,'07R301:W0034703',2772,'07R2772:0042406','W23','W23','M14','(M14/W23)/Les4',['Les4'],'K2101').
genotype(1865,301,'07R301:W0034712',2801,'07R2801:0050013','W23','W23','W23','Les7',['Les7'],'K2312').
genotype(1866,301,'07R301:W0034713',2890,'07R2890:0065408','W23','W23','W23','W23/Les17',['Les17'],'K3012').
genotype(1867,301,'07R301:W0034714',2747,'07R2747:0037012','W23','W23','W23','Les1',['Les1'],'K1912').
genotype(1868,301,'07R301:W0084701',2498,'07R2498:0054904','W23','W23','Mo20W','Les9',['Les9'],'K0707').
genotype(1869,301,'07R301:W0084704',2513,'07R2513:0057213','W23','W23','Mo20W','Les11',['Les11'],'K0901').
genotype(1870,301,'07R301:W0084714',2523,'07R2523:0057911','W23','W23','M14','(M14/Mo20W)/Les11',['Les11'],'K0904').
genotype(1871,301,'07R301:W0085005',1015,'07R1015:0098410','W23','W23','Mo20W/+','Mo20W/Les4',['Les4'],'K0303').
genotype(1872,301,'07R301:W0085006',1555,'07R1555:0098507','W23','W23','W23/Mo20W','W23/(Mo20W/Les4)',['Les4'],'K0304').
genotype(1873,301,'07R301:W0085007',2975,'07R2975:0092204','W23','W23','W23','(W23/(B73/Ht1))/Les*-NA7145)',['Les*-NA7145'],'K9113').
genotype(1874,301,'07R301:W0085008',2363,'07R2363:0043302','W23','W23','M14','(M14/Mo20W)/Les6',['Les6'],'K0401').
genotype(1875,301,'07R301:W0085009',2495,'07R2495:0053409','W23','W23','M14','(M14/Mo20W)/Les8',['Les8'],'K0612').
genotype(1876,301,'07R301:W0085010',2495,'07R2495:0053412','W23','W23','M14','(M14/Mo20W)/Les8',['Les8'],'K0612').
genotype(1877,301,'07R301:W0085013',2524,'07R2524:0057802','W23','W23','Mo20W','Les11',['Les11'],'K0904').
genotype(1878,301,'07R301:W0085302',2504,'07R2504:0055207','W23','W23','Mo20W','Les9',['Les9'],'K0709').
genotype(1879,301,'07R301:W0085304',113,'07R0113:0086915','W23','W23','?/les23 Slm1','?/les23 Slm1',['les23 Slm1'],'K113xx').
genotype(1880,301,'07R301:W0085308',2523,'07R2523:0057915','W23','W23','M14','(M14/Mo20W)/Les11',['Les11'],'K0904').
genotype(1881,301,'07R301:W0085310',2914,'07R2914:0071401','W23','W23','M14','(M14/W23)/Les19',['Les19'],'K3208').
genotype(1882,301,'07R301:W0085311',2836,'07R2836:0059004','W23','W23','W23','Les12',['Les12'],'K2702').
genotype(1883,301,'07R301:W0085312',2857,'07R2857:0059803','W23','W23','M14','(M14/W23)/Les12',['Les12'],'K2711').
genotype(1884,301,'07R301:W0085601',2975,'07R2975:0092205','W23','W23','W23','(W23/(B73/Ht1))/Les*-NA7145)',['Les*-NA7145'],'K9113').
genotype(1885,301,'07R301:W0085616',1326,'07R1326:0113704','W23','W23','W23','W23/Les17',['Les17'],'K3007').
genotype(1886,301,'07R301:W0085913',1582,'07R1582:0069111','W23','W23','W23','W23/(Mo20W/Les19)',['Les19'],'K1504').
genotype(1887,301,'07R301:W0118908',2641,'07R2641:0068602','W23','W23','M14','(M14/Mo20W)/Les19',['Les19'],'K1504').
genotype(1888,301,'07R301:W0119208',116,'07R0116:0086410','W23','W23','?/Les5','?/Les5',['Les5'],'K11610').
genotype(1889,301,'07R301:W0119503',1302,'07R1302:0094102','W23','W23','W23','Les1',['Les1'],'K1912').
genotype(1890,301,'07R301:W0119811',115,'07R0115:0086509','W23','W23','csp1/?','csp1/?',['csp1'],'K11509').
genotype(1891,301,'07R301:W0120108',113,'07R0113:0086903','W23','W23','?/les23 Slm1','?/les23 Slm1',['les23 Slm1'],'K113xx').
genotype(1892,301,'07R301:W0120110',113,'07R0113:0086909','W23','W23','?/les23 Slm1','?/les23 Slm1',['les23 Slm1'],'K113xx').
genotype(1893,301,'07R301:W0120111',2644,'07R2644:0116307','W23','W23','W23','(W23/(M14/Mo20W))/Les19',['Les19'],'K1504').
genotype(1894,301,'07R301:W0120113',2644,'07R2644:0116308','W23','W23','W23','(W23/(M14/Mo20W))/Les19',['Les19'],'K1504').
genotype(1895,401,'07R401:M0000601',2363,'07R2363:0043306','M14','M14','M14','(M14/Mo20W)/Les6',['Les6'],'K0401').
genotype(1896,401,'07R401:M0000901',2281,'07R2281:0035415','M14','M14','Mo20W','Les1',['Les1'],'K0106').
genotype(1897,401,'07R401:M0001508',2485,'07R2485:0052606','M14','M14','M14','(M14/Mo20W)/Les8',['Les8'],'K0611').
genotype(1898,401,'07R401:M0001512',116,'07R0116:0086403','M14','M14','?/Les5','?/Les5',['Les5'],'K11603').
genotype(1899,401,'07R401:M0002105',2524,'07R2524:0057802','M14','M14','Mo20W','Les11',['Les11'],'K0904').
genotype(1900,401,'07R401:M0002107',2772,'07R2772:0042408','M14','M14','M14','(M14/W23)/Les4',['Les4'],'K2101').
genotype(1901,401,'07R401:M0004001',2821,'07R2821:0056009','M14','M14','W23','Les9',['Les9'],'K2512').
genotype(1902,401,'07R401:M0004606',2620,'07R2620:0066801','M14','M14','Mo20W','Les18',['Les18'],'K1411').
genotype(1903,401,'07R401:M0004611',2641,'07R2641:0068602','M14','M14','M14','(M14/Mo20W)/Les19',['Les19'],'K1504').
genotype(1904,401,'07R401:M0005707',1315,'07R1315:0053903','M14','M14','W23','W23/Les8',['Les8'],'K2402').
genotype(1905,401,'07R401:M0006302',2567,'07R2567:0063216','M14','M14','Mo20W','Les17',['Les17'],'K1302').
genotype(1906,401,'07R401:M0006608',2769,'07R2769:0042601','M14','M14','M14','(M14/W23)/Les4',['Les4'],'K2101').
genotype(1907,401,'07R401:M0007309',2666,'07R2666:0069710','M14','M14','Mo20W','Les19',['Les19'],'K1511').
genotype(1908,401,'07R401:M0007908',2645,'07R2645:0068408','M14','M14','M14','(M14/Mo20W)/Les19',['Les19'],'K1504').
genotype(1909,401,'07R401:M0008203',2440,'07R2440:0050501','M14','M14','Mo20W','Les8',['Les8'],'K0601').
genotype(1910,400,'06R400:MI53.601',103,'06R0103:0010307','M14','M14','ij2-N8','ij2-N8',['ij2-N8'],'K10307').
genotype(1911,401,'07R401:M0008509',2495,'07R2495:0053409','M14','M14','M14','(M14/Mo20W)/Les8',['Les8'],'K0612').
genotype(1912,400,'06R400:M00I0607',104,'06R0104:0010407','M14','M14','{+|lep*-8691}','{+|lep*-8691}',['lep*-8691'],'K10407').
genotype(1913,400,'06R400:M00I0606',104,'06R0104:0010405','M14','M14','{+|lep*-8691}','{+|lep*-8691}',['lep*-8691'],'K10405').
genotype(1914,401,'07R401:M0009404',2666,'07R2666:0069707','M14','M14','Mo20W','Les19',['Les19'],'K1511').
genotype(1915,401,'07R401:M0010507',2281,'07R2281:0035401','M14','M14','Mo20W','Les1',['Les1'],'K0106').
genotype(1916,401,'07R401:M0010509',2281,'07R2281:0035403','M14','M14','Mo20W','Les1',['Les1'],'K0106').
genotype(1917,401,'07R401:M0010511',2742,'07R2742:0036806','M14','M14','W23','Les1',['Les1'],'K1909').
genotype(1918,400,'06R400:M00I2108',109,'06R0109:0010908','M14','M14','W23/M14','+/spc1-N1376',['spc1-N1376'],'K10908').
genotype(1919,400,'06R400:M00I2106',109,'06R0109:0010912','M14','M14','W23/M14','+/spc1-N1376',['spc1-N1376'],'K10912').
genotype(1920,401,'07R401:M0010512',2742,'07R2742:0036810','M14','M14','W23','Les1',['Les1'],'K1909').
genotype(1921,401,'07R401:M0010801',2498,'07R2498:0054904','M14','M14','Mo20W','Les9',['Les9'],'K0707').
genotype(1922,400,'06R400:M00I7411',111,'06R0111:0011112','M14','M14','{(M14/W23)|vms*-8522}','{(M14/W23)|vms*-8522}',['vms*-8522'],'K11112').
genotype(1923,401,'07R401:M0010802',1300,'07R1300:0036906','M14','M14','W23','Les1',['Les1'],'K1909').
genotype(1924,401,'07R401:M0010810',2504,'07R2504:0055207','M14','M14','Mo20W','Les9',['Les9'],'K0709').
genotype(1925,401,'07R401:M0011102',2513,'07R2513:0057207','M14','M14','Mo20W','Les11',['Les11'],'K0901').
genotype(1926,401,'07R401:M0011109',2513,'07R2513:0057213','M14','M14','Mo20W','Les11',['Les11'],'K0901').
genotype(1927,400,'06R400:MI53.304',112,'06R0112:0011208','M14','M14',zn1,zn1,[zn1],'K11208').
genotype(1928,401,'07R401:M0011112',2360,'07R2360:0043409','M14','M14','Mo20W','(M14/Mo20W)/Les6',['Les6'],'K0401').
genotype(1929,400,'06R400:M00I6107',112,'06R0112:0011209','M14','M14',zn1,zn1,[zn1],'K11209').
genotype(1930,400,'06R400:M00I7409',112,'06R0112:0011206','M14','M14',zn1,zn1,[zn1],'K11206').
genotype(1931,400,'06R400:M0I10814',112,'06R0112:0011202','M14','M14',zn1,zn1,[zn1],'K11202').
genotype(1932,53,'06R0053:0005309',53,'06R0053:0005302','lls1 121D','lls1 121D','lls1 121D','lls1 121D',['lls1 121D'],'K5302').
genotype(1933,53,'06R0053:0005312',53,'06R0053:0005311','lls1 121D','lls1 121D','lls1 121D','lls1 121D',['lls1 121D'],'K5311').
genotype(1934,54,'06R0054:0005407',54,'06R0054:0005401','B73 Ht1/?','+','B73 Ht1/?','+/Les1-N843',['Les1-N843'],'K5401').
genotype(1935,55,'06R0055:0005502',55,'06R0055:0005508','+','M14/W23','Les2-N845A/+','M14/W23',['Les2-N845A'],'K5508').
genotype(1936,55,'06R0055:0005508',55,'06R0055:0005502','+','M14/W23','Les2-N845A/+','M14/W23',['Les2-N845A'],'K5502').
genotype(1937,56,'06R0056:0005605',56,'06R0056:0005609','W23/L317','+','W23/L317','+/Les3-',['Les3'],'K5609').
genotype(1938,401,'07R401:M0012109',2524,'07R2524:0057802','M14','M14','Mo20W','Les11',['Les11'],'K0904').
genotype(1939,57,'06R0057:0005707',57,'06R0057:0005703','B77/A636','+','B77/A636','+/Les4-N1375',['Les4-N1375'],'K5703').
genotype(1940,57,'06R0057:0005710',57,'06R0057:0005704','B77/A636','+','B77/A636','+/Les4-N1375',['Les4-N1375'],'K5704').
genotype(1941,58,'06R0058:0005808',58,'06R0058:0005809','W23/M14','+','W23/M14','+/Les5-N1449',['Les5-N1449'],'K5809').
genotype(1942,59,'06R0059:0005903',59,'06R0059:0005914','+',+,'+','+/Les6-N1451',['Les6-N1451'],'K5914').
genotype(1943,60,'06R0060:0006009',60,'06R0060:0006010','W23/L317','+','W23/L317','+/Les7-N1461',['Les7-N1461'],'K6010').
genotype(1944,60,'06R0060:0006012',60,'06R0060:0006014','W23/L317','+','W23/L317','+/Les7-N1461',['Les7-N1461'],'K6014').
genotype(1945,60,'06R0060:0006005',60,'06R0060:0006008','W23/L317','+','W23/L317','+/Les7-N1461',['Les7-N1461'],'K6008').
genotype(1946,60,'06R0060:0006001',60,'06R0060:0006003','W23/L317','+','W23/L317','+/Les7-N1461',['Les7-N1461'],'K6003').
genotype(1947,61,'06R0061:0006111',61,'06R0061:0006115','W23/L317','+','W23/L317','+/Les8-N2005',['Les8-N2005'],'K6115').
genotype(1948,61,'06R0061:0006102',61,'06R0061:0006104','W23/L317','+','W23/L317','+/Les8-N2005',['Les8-N2005'],'K6104').
genotype(1949,63,'06R0063:0006305',63,'06R0063:0006303','W23/M14','+','W23/M14','+/Les10-NA607',['Les10-NA607'],'K6303').
genotype(1950,37,'06R0037:0003708',37,'06R0037:0003704','Les2 NonExp/?','?','?','?/Les2 Exp',['Les2 Exp'],'K3704').
genotype(1951,64,'06R0064:0006410',64,'06R0064:0006408','W23/M14','+','W23/M14','+/Les11-N1438',['Les11-N1438'],'K6408').
genotype(1952,65,'06R0065:0006508',65,'06R0065:0006505','W23/M14','+','W23/M14','+/Les12-N1453',['Les12-N1453'],'K6505').
genotype(1953,65,'06R0065:0006509',65,'06R0065:0006510','W23/M14','+','W23/M14','+/Les12-N1453',['Les12-N1453'],'K6510').
genotype(1954,66,'06R0066:0006607',66,'06R0066:0006601','W23/L317','+','W23/L317','+/Les13-N2003',['Les13-N2003'],'K6601').
genotype(1955,41,'06R0041:0004106',41,'06R0041:0004105','Les7 NonExp/?','?/Les7 Exp','Les7 NonExp/?','?/Les7 Exp',['Les7 Exp'],'K4105').
genotype(1956,68,'06R0068:0006801',68,'06R0068:0006805','W23/M14','+','W23/M14','+/Les17-N2345',['Les17-N2345'],'K6805').
genotype(1957,43,'06R0043:0004306',43,'06R0043:0004305','Les9 NonExp/?','?/Les9 Exp','Les9 NonExp/?','?/Les9 Exp',['Les9 Exp'],'K4305').
genotype(1958,69,'06R0069:0006910',69,'06R0069:0006908','W23/M14','+','W23/M14','+/Les18-N2441',['Les18-N2441'],'K6908').
genotype(1959,45,'06R0045:0004502',45,'06R0045:0004504','Les11 NonExp/?','?/Les11 Exp??','Les11 NonExp/?','?/Les11 Exp??',['Les11 Exp??'],'K4504').
genotype(1960,70,'06R0070:0007001',70,'06R0070:0007003','W23/M14','+','W23/M14','+/Les19-N2450',['Les19-N2450'],'K7003').
genotype(1961,45,'06R0045:0004507',45,'06R0045:0004508','Les11 NonExp/?','?/Les11 Exp??','Les11 NonExp/?','?/Les11 Exp??',['Les11 Exp??'],'K4508').
genotype(1962,45,'06R0045:0004512',45,'06R0045:0004506','Les11 NonExp/?','?/Les11 Exp??','Les11 NonExp/?','?/Les11 Exp??',['Les11 Exp??'],'K4506').
genotype(1963,72,'06R0072:0007202',72,'06R0072:0007206','B73 Ht1/?','+','B73 Ht1/?','+/Les21-N1442',['Les21-N1442'],'K7206').
genotype(1964,50,'06R0050:0005008',50,'06R0050:0005009','Les19 NonExp/?','?/Les19 Exp','Les19 NonExp/?','?/Les19 Exp',['Les19 Exp'],'K5009').
genotype(1965,74,'06R0074:0007409',74,'06R0074:0007414','CM105/Oh43E','+','CM105/Oh43E','+/Les*-N1378',['Les*-N1378'],'K7414').
genotype(1966,78,'06R0078:0007808',78,'06R0078:0007807','les*-N2013','les*-N2013','les*-N2013','les*-N2013',['les*-N2013'],'K7807').
genotype(1967,82,'06R0082:0008205',82,'06R0082:0008203','{(B73/AG32)|(Ht1/les*-N2333A)}','{(B73/AG32)|(Ht1/les*-N2333A)}','{(B73/AG32)|(Ht1/les*-N2333A)}','{(B73/AG32)|(Ht1/les*-N2333A)}',['les*-N2333A'],'K8203').
genotype(1968,83,'06R0083:0008303',83,'06R0083:0008302','{+|les*-N2363A}','{+|les*-N2363A}','{+|les*-N2363A}','{+|les*-N2363A}',['les*-N2363A'],'K8302').
genotype(1969,94,'06R0094:0009404',94,'06R0094:0009404','{+|les*-PI251888}','{+|les*-PI251888}','{+|les*-PI251888}','{+|les*-PI251888}',['les*-PI251888'],'K9404').
genotype(1970,94,'06R0094:0009401',94,'06R0094:0009406','{+|les*-PI251888}','{+|les*-PI251888}','{+|les*-PI251888}','{+|les*-PI251888}',['les*-PI251888'],'K9406').
genotype(1971,94,'06R0094:0009408',94,'06R0094:0009412','{+|les*-PI251888}','{+|les*-PI251888}','{+|les*-PI251888}','{+|les*-PI251888}',['les*-PI251888'],'K9412').
genotype(1972,105,'06R0105:0010501',105,'06R0105:0010503','{+|lls1-N501B}','{+|lls1-N501B}','{+|lls1-N501B}','{+|lls1-N501B}',['lls1-N501B'],'K10503').
genotype(1973,109,'06R0109:0010908',109,'06R0109:0010912','W23/M14','+/spc1-N1376','W23/M14','+/spc1-N1376',['spc1-N1376'],'K10912').
genotype(1974,110,'06R0110:0011005',110,'06R0110:0011003','{+|spc3-N553C}','{+|spc3-N553C}','{+|spc3-N553C}','{+|spc3-N553C}',['spc3-N553C'],'K11003').
genotype(1975,110,'06R0110:0011003',110,'06R0110:0011007','{+|spc3-N553C}','{+|spc3-N553C}','{+|spc3-N553C}','{+|spc3-N553C}',['spc3-N553C'],'K11107').
genotype(1976,111,'06R0111:0011107',111,'06R0111:0011112','(M14/W23)/{+|vms*-8522}','(M14/W23)/{+|vms*-8522}','(M14/W23)/{+|vms*-8522}','(M14/W23)/{+|vms*-8522}',['vms*-8522'],'K11112').
genotype(1977,111,'06R0111:0011102',111,'06R0111:0011104','(M14/W23)/{+|vms*-8522}','(M14/W23)/{+|vms*-8522}','(M14/W23)/{+|vms*-8522}','(M14/W23)/{+|vms*-8522}',['vms*-8522'],'K11104').
genotype(1978,111,'06R0111:0011106',111,'06R0111:0011108','(M14/W23)/{+|vms*-8522}','(M14/W23)/{+|vms*-8522}','(M14/W23)/{+|vms*-8522}','(M14/W23)/{+|vms*-8522}',['vms*-8522'],'K11108').
genotype(1979,112,'06R0112:0011209',112,'06R0112:0011206','{(zn1)|(?)}/{(zn1)|(?)}','{(zn1)|(?)}/{(zn1)|(?)}','{(zn1)|(?)}/{(zn1)|(?)}','{(zn1)|(?)}/{(zn1)|(?)}',['zn1'],'K11206').
genotype(1980,112,'06R0112:0011206',112,'06R0112:0011208','{(zn1)|(?)}/{(zn1)|(?)}','{(zn1)|(?)}/{(zn1)|(?)}','{(zn1)|(?)}/{(zn1)|(?)}','{(zn1)|(?)}/{(zn1)|(?)}',['zn1'],'K11208').
genotype(1981,106,'06R0106:0010610',106,'06R0106:0010607','{+|lls1}','{+|lls1}','{+|lls1}','{+|lls1}',[lls1],'K10607').
genotype(1982,401,'07R401:M0013907',2857,'07R2857:0059803','M14','M14','M14','(M14/W23)/Les12',['Les12'],'K2711').
genotype(1983,401,'07R401:M0014210',2620,'07R2620:0066801','M14','M14','Mo20W','Les18',['Les18'],'K1411').
genotype(1984,401,'07R401:M0015005',1330,'07R1330:0067010','M14','M14','W23','W23/Les18',['Les18'],'K3103').
genotype(1985,401,'07R401:M0016206',2642,'07R2642:0068510','M14','M14','M14','(M14/Mo20W)/Les19',['Les19'],'K1504').
genotype(1986,401,'07R401:M0017513',2283,'07R2283:0035209','M14','M14','Mo20W','Les1',['Les1'],'K0106').
genotype(1987,401,'07R401:M0019801',2641,'07R2641:0068605','M14','M14','M14','(M14/Mo20W)/Les19',['Les19'],'K1504').
genotype(1988,401,'07R401:M0020105',2914,'07R2914:0071412','M14','M14','M14','(M14/W23)/Les19',['Les19'],'K3208').
genotype(1989,401,'07R401:M0020701',2926,'07R2926:0072304','M14','M14','W23','W23/Les21',['Les21'],'K3308').
genotype(1990,401,'07R401:M0020703',2277,'07R2277:0093502','M14','M14','M14','(M14/Mo20W)/Les1',['Les1'],'K0106').
genotype(1991,401,'07R401:M0021008',2342,'07R2342:0041105','M14','M14','M14','(M14/Mo20W)/Les4',['Les4'],'K0303').
genotype(1992,401,'07R401:M0021310',2283,'07R2283:0035213','M14','M14','Mo20W','Les1',['Les1'],'K0106').
genotype(1993,401,'07R401:M0021603',2685,'07R2685:0078311','M14','M14','Mo20W/lls1','Mo20W/lls1',[lls1],'K1702').
genotype(1994,401,'07R401:M0022003',2815,'07R2815:0055309','M14','M14','W23','W23/Les9',['Les9'],'K2506').
genotype(1995,401,'07R401:M0022004',2363,'07R2363:0043303','M14','M14','M14','(M14/Mo20W)/Les6',['Les6'],'K0401').
genotype(1996,401,'07R401:M0022012',2276,'07R2276:0035602','M14','M14','Mo20W','Les1',['Les1'],'K0106').
genotype(1997,401,'07R401:M0022301',2740,'07R2740:0035714','M14','M14','W23','Les1',['Les1'],'K1903').
genotype(1998,401,'07R401:M0022302',2739,'07R2739:0035803','M14','M14','W23','Les1',['Les1'],'K1903').
genotype(1999,401,'07R401:M0022303',2746,'07R2746:0037106','M14','M14','W23','Les1',['Les1'],'K1912').
genotype(2000,401,'07R401:M0022304',2739,'07R2739:0035813','M14','M14','W23','Les1',['Les1'],'K1903').
genotype(2001,401,'07R401:M0022305',2738,'07R2738:0035903','M14','M14','W23','Les1',['Les1'],'K1903').
genotype(2002,401,'07R401:M0022308',2737,'07R2737:0036009','M14','M14','W23','(M14/W23)/Les1',['Les1'],'K1903').
genotype(2003,401,'07R401:M0022909',2277,'07R2277:0093509','M14','M14','M14','(M14/Mo20W)/Les1',['Les1'],'K0106').
genotype(2004,401,'07R401:M0023206',2366,'07R2366:0044612','M14','M14','Mo20W','(M14/Mo20W)/Les6',['Les6'],'K0403').
genotype(2005,401,'07R401:M0023207',2379,'07R2379:0044115','M14','M14','M14','(M14/Mo20W)/Les6',['Les6'],'K0403').
genotype(2006,401,'07R401:M0023508',2639,'07R2639:0068807','M14','M14','M14','(M14/Mo20W)/Les19',['Les19'],'K1504').
genotype(2007,401,'07R401:M0024305',2345,'07R2345:0040908','M14','M14','M14','(M14/Mo20W)/Les4',['Les4'],'K0303').
genotype(2008,200,'06R200:S00I1109',40,'06R0040:0004003','Mo20W','Mo20W','?/Les6 NonExp','?/Les6 Exp',['Les6 Exp'],'K4003').
genotype(2009,401,'07R401:M0024306',115,'07R0115:0086506','M14','M14','csp1/?','csp1/?',['csp1'],'K11506').
genotype(2010,401,'07R401:M0024308',2348,'07R2348:0040709','M14','M14','M14','(M14/Mo20W)/Les4',['Les4'],'K0303').
genotype(2011,401,'07R401:M0024310',2641,'07R2641:0068609','M14','M14','M14','(M14/Mo20W)/Les19',['Les19'],'K1504').
genotype(2012,401,'07R401:M0024311',2281,'07R2281:0035402','M14','M14','Mo20W','Les1',['Les1'],'K0106').
genotype(2013,401,'07R401:M0024903',2770,'07R2770:0042506','M14','M14','W23','(M14/W23)/Les4',['Les4'],'K2101').
genotype(2014,401,'07R401:M0024905',2771,'07R2771:0042301','M14','M14','W23','(M14/W23)/Les4',['Les4'],'K2101').
genotype(2015,401,'07R401:M0024906',2340,'07R2340:0041013','M14','M14','Mo20W','(M14/Mo20W)/Les4',['Les4'],'K0303').
genotype(2016,401,'07R401:M0025212',2641,'07R2641:0068602','M14','M14','M14','(M14/Mo20W)/Les19',['Les19'],'K1504').
genotype(2017,401,'07R401:M0025501',2739,'07R2739:0035801','M14','M14','W23','Les1',['Les1'],'K1903').
genotype(2018,401,'07R401:M0025502',116,'07R0116:0086401','M14','M14','?/Les5','?/Les5',['Les5'],'K11601').
genotype(2019,401,'07R401:M0025503',2740,'07R2740:0035712','M14','M14','W23','Les1',['Les1'],'K1903').
genotype(2020,401,'07R401:M0025505',2738,'07R2738:0035914','M14','M14','W23','Les1',['Les1'],'K1903').
genotype(2021,401,'07R401:M0025506',2746,'07R2746:0037107','M14','M14','W23','Les1',['Les1'],'K1912').
genotype(2022,401,'07R401:M0025509',2752,'07R2752:0039005','M14','M14','W23','Les2',['Les2'],'K2002').
%
% See /athe/c/maize/data/reinventory/resolution_weird_cases.org for details.
%
% this family is duplicated by family 1085, just by inserting a 0 between the I and 6 in ma.
% Neither family has offspring.  
%
% Tag was incorrectly replaced and will be corrected back to I0602
%
% Kazic, 31.5.2014
%
% genotype(2023,400,'06R400:M000I602',40,'06R0040:0004003','M14','M14','?/Les6 NonExp','?/Les6 Exp',['Les6 Exp'],'K4003').
%
genotype(2024,401,'07R401:M0025510',2644,'07R2644:0116308','M14','M14','W23','(W23/(M14/Mo20W))/Les19',['Les19'],'K1504').
genotype(2025,401,'07R401:M0025511',2346,'07R2346:0040606','M14','M14','Mo20W','(M14/Mo20W)/Les4',['Les4'],'K0303').
genotype(2026,401,'07R401:M0025802',2737,'07R2737:0036015','M14','M14','W23','(M14/W23)/Les1',['Les1'],'K1903').
genotype(2027,401,'07R401:M0025803',2448,'07R2448:0051513','M14','M14','Mo20W','Les8',['Les8'],'K0604').
genotype(2028,401,'07R401:M0025808',2736,'07R2736:0036211','M14','M14','M14','(M14/W23)/Les1',['Les1'],'K1903').
genotype(2029,401,'07R401:M0026101',2336,'07R2336:0041502','M14','M14','M14','(M14/Mo20W)/Les4',['Les4'],'K0303').
genotype(2030,401,'07R401:M0026102',2495,'07R2495:0053408','M14','M14','M14','(M14/Mo20W)/Les8',['Les8'],'K0612').
genotype(2031,401,'07R401:M0026103',2732,'07R2732:0036307','M14','M14','W23','(M14/W23)/Les1',['Les1'],'K1903').
genotype(2032,401,'07R401:M0026105',2594,'07R2594:0065904','M14','M14','Mo20W','Les18',['Les18'],'K1406').
genotype(2033,401,'07R401:M0026106',2733,'07R2733:0036406','M14','M14','M14','(M14/W23)/Les1',['Les1'],'K1903').
genotype(2034,401,'07R401:M0026401',2807,'07R2807:0054001','M14','M14','W23','W23/Les8',['Les8'],'K2404').
genotype(2035,401,'07R401:M0026404',2925,'07R2925:0072402','M14','M14','M14','(M14/W23)/Les21',['Les21'],'K3308').
genotype(2036,401,'07R401:M0026409',115,'07R0115:0086508','M14','M14','csp1/?','csp1/?',['csp1'],'K11508').
genotype(2037,401,'07R401:M0026411',2922,'07R2922:0072504','M14','M14','M14','(M14/W23)/Les21',['Les21'],'K3308').
genotype(2038,401,'07R401:M0026501',2504,'07R2504:0055213','M14','M14','Mo20W','Les9',['Les9'],'K0709').
genotype(2039,401,'07R401:M0026801',2514,'07R2514:0057102','M14','M14','Mo20W','Les11',['Les11'],'K0901').
genotype(2040,401,'07R401:M0026806',2747,'07R2747:0037003','M14','M14','W23','Les1',['Les1'],'K1912').
genotype(2041,401,'07R401:M0027106',2747,'07R2747:0037006','M14','M14','W23','Les1',['Les1'],'K1912').
genotype(2042,401,'07R401:M0027109',2743,'07R2743:0037408','M14','M14','W23','Les1',['Les1'],'K1912').
genotype(2043,401,'07R401:M0027408',2525,'07R2525:0057706','M14','M14','Mo20W','Les11',['Les11'],'K0904').
genotype(2044,401,'07R401:M0027701',2316,'07R2316:0038701','M14','M14','Mo20W','Les2',['Les2'],'K0207').
genotype(2045,401,'07R401:M0027702',2523,'07R2523:0057911','M14','M14','M14','(M14/Mo20W)/Les11',['Les11'],'K0904').
genotype(2046,401,'07R401:M0028002',1011,'07R1011:0042006','M14','M14','Mo20W','Mo20W/Les4',['Les4'],'K0304').
genotype(2047,401,'07R401:M0028003',2340,'07R2340:0041011','M14','M14','Mo20W','(M14/Mo20W)/Les4',['Les4'],'K0303').
genotype(2048,401,'07R401:M0028004',2343,'07R2343:0040803','M14','M14','Mo20W','(M14/Mo20W)/Les4',['Les4'],'K0303').
genotype(2049,401,'07R401:M0028005',2343,'07R2343:0040808','M14','M14','Mo20W','(M14/Mo20W)/Les4',['Les4'],'K0303').
genotype(2050,401,'07R401:M0028007',2525,'07R2525:0057713','M14','M14','Mo20W','Les11',['Les11'],'K0904').
genotype(2051,401,'07R401:M0028312',2854,'07R2854:0059904','M14','M14','M14','(M14/W23)/Les12',['Les12'],'K2711').
genotype(2052,401,'07R401:M0029101',2786,'07R2786:0045303','M14','M14','Mo20W','(M14/W23)/Les6',['Les6'],'K2210').
genotype(2053,401,'07R401:M0029104',2363,'07R2363:0043306','M14','M14','M14','(M14/Mo20W)/Les6',['Les6'],'K0401').
genotype(2054,401,'07R401:M0029105',2782,'07R2782:0045604','M14','M14','Mo20W','(M14/W23)/Les6',['Les6'],'K2210').
genotype(2055,401,'07R401:M0029106',2363,'07R2363:0043306','M14','M14','M14','(M14/Mo20W)/Les6',['Les6'],'K0401').
genotype(2056,401,'07R401:M0029107',2772,'07R2772:0042401','M14','M14','M14','(M14/W23)/Les4',['Les4'],'K2101').
genotype(2057,401,'07R401:M0029109',2784,'07R2784:0045809','M14','M14','M14','(M14/W23)/Les6',['Les6'],'K2210').
genotype(2058,401,'07R401:M0029111',2363,'07R2363:0043308','M14','M14','M14','(M14/Mo20W)/Les6',['Les6'],'K0401').
genotype(2059,401,'07R401:M0029402',2753,'07R2753:0038904','M14','M14','W23','Les2',['Les2'],'K2002').
genotype(2060,401,'07R401:M0029403',2316,'07R2316:0038701','M14','M14','Mo20W','Les2',['Les2'],'K0207').
genotype(2061,401,'07R401:M0029404',2754,'07R2754:0038808','M14','M14','W23','Les2',['Les2'],'K2002').
genotype(2062,401,'07R401:M0029406',2495,'07R2495:0053404','M14','M14','M14','(M14/Mo20W)/Les8',['Les8'],'K0612').
genotype(2063,401,'07R401:M0029408',2771,'07R2771:0042302','M14','M14','W23','(M14/W23)/Les4',['Les4'],'K2101').
genotype(2064,401,'07R401:M0029409',2573,'07R2573:0063906','M14','M14','M14','(M14/Mo20W)/Les17',['Les17'],'K1309').
genotype(2065,401,'07R401:M0029411',2748,'07R2748:0039404','M14','M14','W23','Les2',['Les2'],'K2002').
genotype(2066,401,'07R401:M0029412',2748,'07R2748:0039402','M14','M14','W23','Les2',['Les2'],'K2002').
genotype(2067,401,'07R401:M0029703',2805,'07R2805:0054205','M14','M14','W23','W23/Les8',['Les8'],'K2404').
genotype(2068,401,'07R401:M0029709',1309,'07R1309:0046308','M14','M14','W23','W23/Les6',['Les6'],'K2210').
genotype(2069,401,'07R401:M0029710',2787,'07R2787:0045404','M14','M14','W23','(M14/W23)/Les6',['Les6'],'K2210').
genotype(2070,401,'07R401:M0030003',2573,'07R2573:0063907','M14','M14','M14','(M14/Mo20W)/Les17',['Les17'],'K1309').
genotype(2071,401,'07R401:M0030005',2336,'07R2336:0041505','M14','M14','M14','(M14/Mo20W)/Les4',['Les4'],'K0303').
genotype(2072,401,'07R401:M0030302',117,'07R0117:0087109','M14','M14','C-13/AG32','?/Les-EC91',['Les-EC91'],'K11709').
genotype(2073,401,'07R401:M0030303',2351,'07R2351:0040501','M14','M14','Mo20W','Les4',['Les4'],'K0303').
genotype(2074,401,'07R401:M0030304',2351,'07R2351:0040502','M14','M14','Mo20W','Les4',['Les4'],'K0303').
genotype(2075,401,'07R401:M0030305',2346,'07R2346:0040604','M14','M14','Mo20W','(M14/Mo20W)/Les4',['Les4'],'K0303').
genotype(2076,401,'07R401:M0030306',2348,'07R2348:0040704','M14','M14','M14','(M14/Mo20W)/Les4',['Les4'],'K0303').
genotype(2077,401,'07R401:M0030307',2878,'07R2878:0065211','M14','M14','M14','(M14/W23)/Les17',['Les17'],'K3007').
genotype(2078,401,'07R401:M0030309',117,'07R0117:0087103','M14','M14','C-13/AG32','?/Les-EC91',['Les-EC91'],'K11703').
genotype(2079,401,'07R401:M0030310',2348,'07R2348:0040709','M14','M14','M14','(M14/Mo20W)/Les4',['Les4'],'K0303').
genotype(2080,401,'07R401:M0030601',2329,'07R2329:0041801','M14','M14','Mo20W','(M14/Mo20W)/Les4',['Les4'],'K0303').
genotype(2081,401,'07R401:M0030602',2287,'07R2287:0037512','M14','M14','Mo20W','Les9',['Les9'],'K0709').
genotype(2082,401,'07R401:M0030603',2427,'07R2427:0048504','M14','M14','W23','(W23/Mo20W)/Les7',['Les7'],'K0509').
genotype(2083,401,'07R401:M0030610',2328,'07R2328:0040111','M14','M14','M14','(M14/Mo20W)/Les4',['Les4'],'K0302').
genotype(2084,401,'07R401:M0030905',2510,'07R2510:0057311','M14','M14','Mo20W','Les11',['Les11'],'K0901').
genotype(2085,401,'07R401:M0031201',2422,'07R2422:0048705','M14','M14','Mo20W','(M14/Mo20W)/Les7',['Les7'],'K0509').
genotype(2086,401,'07R401:M0031202',2969,'07R2969:0090901','M14','M14','M14','(W23/((B73/AG32)/Ht1))/(W23/Les*-N2418)',['Les*-N2418'],'K8501').
genotype(2087,401,'07R401:M0031204',2801,'07R2801:0050013','M14','M14','W23','Les7',['Les7'],'K2312').
genotype(2088,401,'07R401:M0031205',2799,'07R2799:0050204','M14','M14','W23','Les7',['Les7'],'K2312').
genotype(2089,401,'07R401:M0031206',2799,'07R2799:0050209','M14','M14','W23','Les7',['Les7'],'K2312').
genotype(2090,401,'07R401:M0031209',2797,'07R2797:0050403','M14','M14','W23','Les7',['Les7'],'K2312').
genotype(2091,401,'07R401:M0031210',2454,'07R2454:0051211','M14','M14','Mo20W','Les8',['Les8'],'K0604').
genotype(2092,401,'07R401:M0031211',2969,'07R2969:0090908','M14','M14','M14','(W23/((B73/AG32)/Ht1))/(W23/Les*-N2418)',['Les*-N2418'],'K8501').
genotype(2093,401,'07R401:M0031212',2489,'07R2489:0052406','M14','M14','Mo20W','(M14/Mo20W)/Les8',['Les8'],'K0611').
genotype(2094,401,'07R401:M0031213',2477,'07R2477:0053210','M14','M14','M14','(M14/Mo20W)/Les8',['Les8'],'K0611').
genotype(2095,401,'07R401:M0031301',2495,'07R2495:0053412','M14','M14','M14','(M14/Mo20W)/Les8',['Les8'],'K0612').
genotype(2096,401,'07R401:M0031305',2475,'07R2475:0053302','M14','M14','M14','(M14/Mo20W)/Les8',['Les8'],'K0611').
genotype(2097,401,'07R401:M0031308',1315,'07R1315:0053906','M14','M14','W23','W23/Les8',['Les8'],'K2402').
genotype(2098,401,'07R401:M0031606',2494,'07R2494:0053501','M14','M14','M14','(M14/Mo20W)/Les8',['Les8'],'K0612').
genotype(2099,401,'07R401:M0031607',2857,'07R2857:0059814','M14','M14','M14','(M14/W23)/Les12',['Les12'],'K2711').
genotype(2100,401,'07R401:M0031608',2807,'07R2807:0054003','M14','M14','W23','W23/Les8',['Les8'],'K2404').
genotype(2101,401,'07R401:M0031612',2842,'07R2842:0060806','M14','M14','M14','(M14/W23)/Les12',['Les12'],'K2711').
genotype(2102,401,'07R401:M0031901',2318,'07R2318:0038611','M14','M14','Mo20W','Les2',['Les2'],'K0207').
genotype(2103,401,'07R401:M0031905',2488,'07R2488:0052509','M14','M14','M14','(M14/Mo20W)/Les8',['Les8'],'K0611').
genotype(2104,401,'07R401:M0031906',2513,'07R2513:0057212','M14','M14','Mo20W','Les11',['Les11'],'K0901').
genotype(2105,401,'07R401:M0031909',2849,'07R2849:0060206','M14','M14','M14','(M14/W23)/Les12',['Les12'],'K2711').
genotype(2106,401,'07R401:M0032201',2379,'07R2379:0044103','M14','M14','M14','(M14/Mo20W)/Les6',['Les6'],'K0403').
genotype(2107,401,'07R401:M0032202',2974,'07R2974:0092105','M14','M14','Mo20W','(W23/(B73/Ht1))/(W23/Les*-NA7145)',['Les*-NA7145'],'K9113').
genotype(2108,401,'07R401:M0032203',1435,'07R1435:0092303','M14','M14','W23','((B73 Ht1)/Mo17)/Les*-NA7145',['Les*-NA7145'],'K9113').
genotype(2109,401,'07R401:M0032204',2805,'07R2805:0054201','M14','M14','W23','W23/Les8',['Les8'],'K2404').
genotype(2110,401,'07R401:M0032207',2495,'07R2495:0053408','M14','M14','M14','(M14/Mo20W)/Les8',['Les8'],'K0612').
genotype(2111,401,'07R401:M0032501',2761,'07R2761:0039810','M14','M14','W23','Les2',['Les2'],'K2011').
genotype(2112,401,'07R401:M0032502',2360,'07R2360:0043401','M14','M14','Mo20W','(M14/Mo20W)/Les6',['Les6'],'K0401').
genotype(2113,401,'07R401:M0032503',2504,'07R2504:0055201','M14','M14','Mo20W','Les9',['Les9'],'K0709').
genotype(2114,401,'07R401:M0032504',1303,'07R1303:0039703','M14','M14','W23','W23/Les2',['Les2'],'K2009').
genotype(2115,401,'07R401:M0032802',2328,'07R2328:0040106','M14','M14','M14','(M14/Mo20W)/Les4',['Les4'],'K0302').
genotype(2116,401,'07R401:M0032808',2354,'07R2354:0040304','M14','M14','Mo20W','Les4',['Les4'],'K0303').
genotype(2117,401,'07R401:M0032809',2523,'07R2523:0057915','M14','M14','M14','(M14/Mo20W)/Les11',['Les11'],'K0904').
genotype(2118,401,'07R401:M0033102',2869,'07R2869:0061807','M14','M14','W23','W23/Les13',['Les13'],'K2805').
genotype(2119,401,'07R401:M0033104',2526,'07R2526:0057605','M14','M14','Mo20W','Les11',['Les11'],'K0904').
genotype(2120,401,'07R401:M0033106',1327,'07R1327:0065303','M14','M14','W23','W23/Les17',['Les17'],'K3007').
genotype(2121,401,'07R401:M0033109',2878,'07R2878:0065211','M14','M14','M14','(M14/W23)/Les17',['Les17'],'K3007').
genotype(2122,401,'07R401:M0033110',2528,'07R2528:0058614','M14','M14','M14','(M14/Mo20W)/Les12',['Les12'],'K1001').
genotype(2123,401,'07R401:M0033115',2613,'07R2613:0066401','M14','M14','Mo20W','Les18',['Les18'],'K1407').
genotype(2124,401,'07R401:M0033402',2881,'07R2881:0065010','M14','M14','M14','(M14/W23)/Les17',['Les17'],'K3007').
genotype(2125,401,'07R401:M0033404',2490,'07R2490:0053608','M14','M14','Mo20W','(M14/Mo20W)/Les8',['Les8'],'K0612').
genotype(2126,401,'07R401:M0033405',2881,'07R2881:0065005','M14','M14','M14','(M14/W23)/Les17',['Les17'],'K3007').
genotype(2127,401,'07R401:M0033406',2318,'07R2318:0038611','M14','M14','Mo20W','Les2',['Les2'],'K0207').
genotype(2128,401,'07R401:M0033408',113,'07R0113:0086909','M14','M14','?/les23 Slm1','?/les23 Slm1',['les23 Slm1'],'K113xx').
genotype(2129,401,'07R401:M0033410',2537,'07R2537:0061104','M14','M14','Mo20W','Les13',['Les13'],'K1109').
genotype(2130,401,'07R401:M0033411',2845,'07R2845:0060608','M14','M14','M14','(M14/W23)/Les12',['Les12'],'K2711').
genotype(2131,401,'07R401:M0033901',2882,'07R2882:0064711','M14','M14','W23','(M14/W23)/Les17',['Les17'],'K3007').
genotype(2132,401,'07R401:M0033903',2495,'07R2495:0053409','M14','M14','M14','(M14/Mo20W)/Les8',['Les8'],'K0612').
genotype(2133,401,'07R401:M0033905',2733,'07R2733:0036406','M14','M14','M14','(M14/W23)/Les1',['Les1'],'K1903').
genotype(2134,401,'07R401:M0033907',2562,'07R2562:0063311','M14','M14','Mo20W','Les17',['Les17'],'K1302').

genotype(2136,401,'07R401:M0034202',2783,'07R2783:0045708','M14','M14','W23','(M14/W23)/Les6',['Les6'],'K2210').
genotype(2137,401,'07R401:M0034203',2733,'07R2733:0036408','M14','M14','M14','(M14/W23)/Les1',['Les1'],'K1903').
genotype(2138,401,'07R401:M0034204',2857,'07R2857:0059803','M14','M14','M14','(M14/W23)/Les12',['Les12'],'K2711').
genotype(2139,401,'07R401:M0034206',1300,'07R1300:0036906','M14','M14','W23','Les1',['Les1'],'K1909').
genotype(2140,401,'07R401:M0034207',2885,'07R2885:0064606','M14','M14','M14','(M14/W23)/Les17',['Les17'],'K3007').
genotype(2141,401,'07R401:M0034213',2857,'07R2857:0059808','M14','M14','M14','(M14/W23)/Les12',['Les12'],'K2711').
genotype(2142,401,'07R401:M0034501',2316,'07R2316:0038712','M14','M14','Mo20W','Les2',['Les2'],'K0207').
genotype(2143,401,'07R401:M0034503',2753,'07R2753:0038902','M14','M14','W23','Les2',['Les2'],'K2002').
genotype(2144,401,'07R401:M0034505',1303,'07R1303:0039703','M14','M14','W23','W23/Les2',['Les2'],'K2009').
genotype(2145,401,'07R401:M0034507',2890,'07R2890:0065408','M14','M14','W23','W23/Les17',['Les17'],'K3012').
genotype(2146,401,'07R401:M0034508',2302,'07R2302:0038002','M14','M14','Mo20W','Les2',['Les2'],'K0203').
genotype(2147,401,'07R401:M0034511',2772,'07R2772:0042406','M14','M14','M14','(M14/W23)/Les4',['Les4'],'K2101').
genotype(2148,401,'07R401:M0034808',2917,'07R2917:0071007','M14','M14','M14','(M14/W23)/Les19',['Les19'],'K3208').
genotype(2149,401,'07R401:M0034810',2454,'07R2454:0051202','M14','M14','Mo20W','Les8',['Les8'],'K0604').
genotype(2150,401,'07R401:M0085707',2363,'07R2363:0043302','M14','M14','M14','(M14/Mo20W)/Les6',['Les6'],'K0401').
genotype(2151,401,'07R401:M0085711',2495,'07R2495:0053409','M14','M14','M14','(M14/Mo20W)/Les8',['Les8'],'K0612').
genotype(2152,401,'07R401:M0086305',2975,'07R2975:0092204','M14','M14','W23','(W23/(B73/Ht1))/Les*-NA7145)',['Les*-NA7145'],'K9113').
genotype(2153,401,'07R401:M0086314',113,'07R0113:0086915','M14','M14','?/les23 Slm1','?/les23 Slm1',['les23 Slm1'],'K113xx').
genotype(2154,401,'07R401:M0119002',113,'07R0113:0086903','M14','M14','?/les23 Slm1','?/les23 Slm1',['les23 Slm1'],'K113xx').
genotype(2155,401,'07R401:M0119013',2914,'07R2914:0071401','M14','M14','M14','(M14/W23)/Les19',['Les19'],'K3208').
genotype(2156,401,'07R401:M0120510',1301,'07R1301:0093808','M14','M14','W23','Les1',['Les1'],'K1903').
genotype(2157,1057,'07R1057:0072903',1057,'07R1057:0072909','Mo20W/{+|les23}','Mo20W/{+|les23}','Mo20W/{+|les23}','Mo20W/{+|les23}',[les23],'K1802').
genotype(2158,1057,'07R1057:0072912',1057,'07R1057:0072909','Mo20W/{+|les23}','Mo20W/{+|les23}','Mo20W/{+|les23}','Mo20W/{+|les23}',[les23],'K1802').
genotype(2159,1136,'07R1136:0088009',1136,'07R1136:0088009','Mo20W/{+|les*-74-1873-9}','Mo20W/(les*-74-1873-9/les*-74-1873-9)','Mo20W/{+|les*-74-1873-9}','Mo20W/(les*-74-1873-9/les*-74-1873-9)',['les*-74-1873-9'],'K9304').
genotype(2160,1136,'07R1136:0088011',1136,'07R1136:0088011','Mo20W/{+|les*-74-1873-9}','Mo20W/(les*-74-1873-9/les*-74-1873-9)','Mo20W/{+|les*-74-1873-9}','Mo20W/(les*-74-1873-9/les*-74-1873-9)',['les*-74-1873-9'],'K9304').
genotype(2161,1136,'07R1136:0088013',1136,'07R1136:0088013','Mo20W/{+|les*-74-1873-9}','Mo20W/(les*-74-1873-9/les*-74-1873-9)','Mo20W/{+|les*-74-1873-9}','Mo20W/(les*-74-1873-9/les*-74-1873-9)',['les*-74-1873-9'],'K9304').
genotype(2162,1203,'07R1203:0087410',1203,'07R1203:0087410','Mo20W/{+|lep*-8691}','Mo20W/{+|lep*-8691}','Mo20W/{+|lep*-8691}','Mo20W/{+|lep*-8691}',['lep*-8691'],'K10407').
genotype(2163,1211,'07R1211:0083402',1211,'07R1211:0083402','Mo20W/zn1','Mo20W/zn1','Mo20W/zn1','Mo20W/zn1',[zn1],'K11205').
genotype(2164,1367,'07R1367:0077201',1367,'07R1367:0077201','W23/{+|les23}','W23/{+|les23}','W23/{+|les23}','W23/{+|les23}',[les23],'K3507').
genotype(2165,1443,'07R1443:0089101',1443,'07R1443:0089101','W23/({(B73/AG32)|(Ht1/les*-N2333A)})','W23/({(B73/AG32)|(Ht1/les*-N2333A)})','W23/({(B73/AG32)|(Ht1/les*-N2333A)})','W23/({(B73/AG32)|(Ht1/les*-N2333A)})',['les*-N2333A'],'K8211').
genotype(2166,1447,'07R1447:0087811',1447,'07R1447:0087811','W23/({(W23/L317)|les*-2119})','W23/({(W23/L317)|les*-2119})','W23/({(W23/L317)|les*-2119})','W23/({(W23/L317)|les*-2119})',['les*-2119'],'K9207').
genotype(2167,1456,'07R1456:0088502',1456,'07R1456:0088502','W23/les*-N1395C','W23/les*-N1395C','W23/les*-N1395C','W23/les*-N1395C',['les*-N1395C'],'K7501').
genotype(2168,1456,'07R1456:0088507',1456,'07R1456:0088507','W23/les*-N1395C','W23/les*-N1395C','W23/les*-N1395C','W23/les*-N1395C',['les*-N1395C'],'K7501').
genotype(2169,1457,'07R1457:0088601',1457,'07R1457:0088601','W23/({+|les*-N2012})','W23/({+|les*-N2012})','W23/({+|les*-N2012})','W23/({+|les*-N2012})',['les*-N2012'],'K7708').
genotype(2170,1586,'07R1586:0076101',1586,'07R1586:0076101','W23/Mo20W','W23/(Mo20W/{+|les23})','W23/Mo20W','W23/(Mo20W/{+|les23})',['les23'],'K1802').
genotype(2171,1586,'07R1586:0076102',1586,'07R1586:0076102','W23/Mo20W','W23/(Mo20W/{+|les23})','W23/Mo20W','W23/(Mo20W/{+|les23})',['les23'],'K1802').
genotype(2172,1586,'07R1586:0076105',1586,'07R1586:0076105','W23/Mo20W','W23/(Mo20W/les23)','W23/Mo20W','W23/(Mo20W/les23)',['les23'],'K1802').
genotype(2173,1586,'07R1586:0076106',1586,'07R1586:0076106','W23/Mo20W','W23/(Mo20W/{+|les23})','W23/Mo20W','W23/(Mo20W/{+|les23})',['les23'],'K1802').
genotype(2174,1586,'07R1586:0076115',1586,'07R1586:0076115','W23/Mo20W','W23/(Mo20W/{+|les23})','W23/Mo20W','W23/(Mo20W/{+|les23})',['les23'],'K1802').
genotype(2175,1625,'07R1625:0076202',1625,'07R1625:0076202','M14/Mo20W','M14/(Mo20W/les23)','M14/Mo20W','M14/(Mo20W/les23)',['les23'],'K1802').
genotype(2176,1627,'07R1627:0077602',1627,'07R1627:0077602','M14/Mo20W','M14/(Mo20W/{+|lls1})','M14/Mo20W','M14/(Mo20W/{+|lls1})',['lls1'],'K1701').
genotype(2177,1627,'07R1627:0077605',1627,'07R1627:0077605','M14/Mo20W','M14/(Mo20W/{+|lls1})','M14/Mo20W','M14/(Mo20W/{+|lls1})',['lls1'],'K1701').
genotype(2178,1627,'07R1627:0077606',1627,'07R1627:0077606','M14/Mo20W','M14/(Mo20W/{+|lls1})','M14/Mo20W','M14/(Mo20W/{+|lls1})',['lls1'],'K1701').
genotype(2179,1627,'07R1627:0077608',1627,'07R1627:0077608','M14/Mo20W','M14/(Mo20W/{+|lls1})','M14/Mo20W','M14/(Mo20W/{+|lls1})',['lls1'],'K1701').
genotype(2180,1729,'07R1729:0077314',1729,'07R1729:0077314','M14/W23','M14/(W23/{+|les23})','M14/W23','M14/(W23/{+|les23})',['les23'],'K3509').
genotype(2181,1832,'07R1832:0088802',1832,'07R1832:0088802','M14/({+|les*-N2012})','M14/({+|les*-N2012})','M14/({+|les*-N2012})','M14/({+|les*-N2012})',['les*-N2012'],'K7718').
genotype(2182,1832,'07R1832:0088811',1832,'07R1832:0088811','M14/({+|les*-N2012})','M14/({+|les*-N2012})','M14/({+|les*-N2012})','M14/({+|les*-N2012})',['les*-N2012'],'K7718').
genotype(2183,1833,'07R1833:0088908',1833,'07R1833:0088908','M14/les*-N2013','M14/les*-N2013','M14/les*-N2013','M14/les*-N2013',['les*-N2013'],'K7801').
genotype(2184,1838,'07R1838:0091910',1838,'07R1838:0091910','M14/les*-N2502','M14/les*-N2502','M14/les*-N2502','M14/les*-N2502',['les*-N2502'],'K8709').
genotype(2185,1838,'07R1838:0091911',1838,'07R1838:0091911','M14/les*-N2502','M14/les*-N2502','M14/les*-N2502','M14/les*-N2502',['les*-N2502'],'K8709').
genotype(2186,1845,'07R1845:0087902',1845,'07R1845:0087902','M14/({(W23/L317)|les*-2119})','M14/({(W23/L317)|les*-2119})','M14/({(W23/L317)|les*-2119})','M14/({(W23/L317)|les*-2119})',['les*-2119'],'K9207').
genotype(2187,1845,'07R1845:0087903',1845,'07R1845:0087903','M14/({(W23/L317)|les*-2119})','M14/({(W23/L317)|les*-2119})','M14/({(W23/L317)|les*-2119})','M14/({(W23/L317)|les*-2119})',['les*-2119'],'K9207').
genotype(2188,1845,'07R1845:0087904',1845,'07R1845:0087904','M14/({(W23/L317)|les*-2119})','M14/({(W23/L317)|les*-2119})','M14/({(W23/L317)|les*-2119})','M14/({(W23/L317)|les*-2119})',['les*-2119'],'K9207').
genotype(2189,1845,'07R1845:0087913',1845,'07R1845:0087913','M14/({(W23/L317)|les*-2119})','M14/({(W23/L317)|les*-2119})','M14/({(W23/L317)|les*-2119})','M14/({(W23/L317)|les*-2119})',['les*-2119'],'K9207').
genotype(2190,1910,'07R1910:0087201',1910,'07R1910:0087201','M14/ij2-N8','M14/ij2-N8','M14/ij2-N8','M14/ij2-N8',['ij2-N8'],'K10307').
genotype(2191,1910,'07R1910:0087212',1910,'07R1910:0087212','M14/ij2-N8','M14/ij2-N8','M14/ij2-N8','M14/ij2-N8',['ij2-N8'],'K10307').
genotype(2192,1913,'07R1913:0087602',1913,'07R1913:0087602','M14/({+|lep*-8691})','M14/({+|lep*-8691})','M14/({+|lep*-8691})','M14/({+|lep*-8691})',['lep*-8691'],'K10405').
genotype(2193,1913,'07R1913:0087614',1913,'07R1913:0087614','M14/({+|lep*-8691})','M14/({+|lep*-8691})','M14/({+|lep*-8691})','M14/({+|lep*-8691})',['lep*-8691'],'K10405').
genotype(2194,2422,'07R2422:0048705',2422,'07R2422:0048705','Mo20W','(M14/Mo20W)/Les7','Mo20W','(M14/Mo20W)/Les7',['Les7'],'K0509').
genotype(2195,2488,'07R2488:0052508',2488,'07R2488:0052508','M14','(M14/Mo20W)/Les8','M14','(M14/Mo20W)/Les8',['Les8'],'K0611').
genotype(2196,2674,'07R2674:0074001',2674,'07R2674:0074001','Mo20W','Mo20W/{+|lls1}','Mo20W','Mo20W/{+|lls1}',[lls1],'K1702').
genotype(2197,2720,'07R2720:0076801',2720,'07R2720:0076801','Mo20W/les23','Mo20W/les23','Mo20W/les23','Mo20W/les23',[les23],'K1804').
genotype(2198,2720,'07R2720:0076804',2720,'07R2720:0076804','Mo20W/les23','Mo20W/les23','Mo20W/les23','Mo20W/les23',[les23],'K1804').
genotype(2199,2720,'07R2720:0076808',2720,'07R2720:0076810','Mo20W/les23','Mo20W/les23','Mo20W/les23','Mo20W/les23',[les23],'K1804').
genotype(2200,2724,'07R2724:0076501',2724,'07R2724:0076501','W23','(W23/Mo20W)/les23','W23','(W23/Mo20W)/les23',[les23],'K1804').
genotype(2201,2724,'07R2724:0076502',2724,'07R2724:0076502','W23','(W23/Mo20W)/les23','W23','(W23/Mo20W)/les23',[les23],'K1804').
genotype(2202,2724,'07R2724:0076503',2724,'07R2724:0076503','W23','(W23/Mo20W)/les23','W23','(W23/Mo20W)/les23',[les23],'K1804').



% 06n

genotype(2270,301,'06N301:W0034103',1600,'06N1600:0019806','W23','W23','M14/Mo20W','Les1',['Les1'],'K0104').
genotype(2271,301,'06N301:W0034101',1600,'06N1600:0019804','W23','W23','M14/Mo20W','Les1',['Les1'],'K0104').
genotype(2272,201,'06N201:S0013305',1000,'06N1000:0003302','Mo20W','Mo20W','{Mo20W|M14}/Mo20W','Les1',['Les1'],'K0104').
genotype(2273,301,'06N301:W0031404',1000,'06N1000:0003302','W23','W23','{Mo20W|M14}/Mo20W','Les1',['Les1'],'K0104').
genotype(2274,301,'06N301:W0008706',1000,'06N1000:0003302','W23','W23','{Mo20W|M14}/Mo20W','Les1',['Les1'],'K0104').
genotype(2275,401,'06N401:M0012601',1000,'06N1000:0003302','M14','M14','{Mo20W|M14}/Mo20W','Les1',['Les1'],'K0104').
genotype(2276,201,'06N201:S0004111',1011,'06N1011:0000111','Mo20W','Mo20W','Mo20W/+','Les1',['Les1'],'K0106').
genotype(2277,401,'06N401:M0004904',1011,'06N1011:0000111','M14','M14','Mo20W/+','Les1',['Les1'],'K0106').
genotype(2278,201,'06N201:S0010701',1011,'06N1011:0000108','Mo20W','Mo20W','Mo20W/+','Les1',['Les1'],'K0106').
genotype(2279,301,'06N301:W0004203',1011,'06N1011:0000108','W23','W23','Mo20W/+','Les1',['Les1'],'K0106').
genotype(2280,401,'06N401:M0004601',1011,'06N1011:0000108','M14','M14','Mo20W/+','Les1',['Les1'],'K0106').
genotype(2281,201,'06N201:S0004713',1011,'06N1011:0000105','Mo20W','Mo20W','Mo20W/+','Les1',['Les1'],'K0106').
genotype(2282,201,'06N201:S0004701',1011,'06N1011:0000103','Mo20W','Mo20W','Mo20W/+','Les1',['Les1'],'K0106').
genotype(2283,201,'06N201:S0004411',1011,'06N1011:0000102','Mo20W','Mo20W','Mo20W/+','Les1',['Les1'],'K0106').
genotype(2284,201,'06N201:S0004105',1011,'06N1011:0000101','Mo20W','Mo20W','Mo20W/+','Les1',['Les1'],'K0106').
genotype(2293,201,'06N201:S0005610',1014,'06N1014:0000412','Mo20W','Mo20W','Mo20W/+','Les2',['Les2'],'K0203').
genotype(2294,301,'06N301:W0011401',1014,'06N1014:0000412','W23','W23','Mo20W/+','Les2',['Les2'],'K0203').
genotype(2295,201,'06N201:S0007103',1014,'06N1014:0000410','Mo20W','Mo20W','Mo20W/+','Les2',['Les2'],'K0203').
genotype(2296,201,'06N201:S0005006',1014,'06N1014:0000410','Mo20W','Mo20W','Mo20W/+','Les2',['Les2'],'K0203').
genotype(2297,301,'06N301:W0005103',1014,'06N1014:0000410','W23','W23','Mo20W/+','Les2',['Les2'],'K0203').
genotype(2298,201,'06N201:S0004708',1014,'06N1014:0000408','Mo20W','Mo20W','Mo20W/+','Les2',['Les2'],'K0203').
genotype(2299,301,'06N301:W0004506',1014,'06N1014:0000408','W23','W23','Mo20W/+','Les2',['Les2'],'K0203').
genotype(2300,301,'06N301:W0004804',1014,'06N1014:0000408','W23','W23','Mo20W/+','Les2',['Les2'],'K0203').
genotype(2301,401,'06N401:M0005504',1014,'06N1014:0000408','M14','M14','Mo20W/+','Les2',['Les2'],'K0203').
genotype(2302,201,'06N201:S0004107',1014,'06N1014:0000407','Mo20W','Mo20W','Mo20W/+','Les2',['Les2'],'K0203').
genotype(2303,301,'06N301:W0004803',1014,'06N1014:0000407','W23','W23','Mo20W/+','Les2',['Les2'],'K0203').
genotype(2304,201,'06N201:S0004702',1014,'06N1014:0000406','Mo20W','Mo20W','Mo20W/+','Les2',['Les2'],'K0203').
genotype(2305,301,'06N301:W0004802',1014,'06N1014:0000406','W23','W23','Mo20W/+','Les2',['Les2'],'K0203').
genotype(2306,401,'06N401:M0011802',1014,'06N1014:0000406','M14','M14','Mo20W/+','Les2',['Les2'],'K0203').
genotype(2307,301,'06N301:W0004511',1014,'06N1014:0000405','W23','W23','Mo20W/+','Les2',['Les2'],'K0203').
genotype(2308,201,'06N201:S0004103',1014,'06N1014:0000404','Mo20W','Mo20W','Mo20W/+','Les2',['Les2'],'K0203').
genotype(2309,301,'06N301:W0005701',1014,'06N1014:0000404','W23','W23','Mo20W/+','Les2',['Les2'],'K0203').
genotype(2310,301,'06N301:W0011402',1014,'06N1014:0000404','W23','W23','Mo20W/+','Les2',['Les2'],'K0203').
genotype(2311,201,'06N201:S0011303',1014,'06N1014:0000403','Mo20W','Mo20W','Mo20W/+','Les2',['Les2'],'K0203').
genotype(2312,201,'06N201:S0004101',1014,'06N1014:0000403','Mo20W','Mo20W','Mo20W/+','Les2',['Les2'],'K0203').
genotype(2313,1014,'06N1014:0000411',1014,'06N1014:0000401','Mo20W/+','Mo20W/+','Mo20W/+','Les2',['Les2'],'K0203').
genotype(2314,301,'06N301:W0004512',1014,'06N1014:0000401','W23','W23','Mo20W/+','Les2',['Les2'],'K0203').
genotype(2316,201,'06N201:S0004408',1012,'06N1012:0000206','Mo20W','Mo20W','Mo20W/+','Les2',['Les2'],'K0207').
genotype(2317,301,'06N301:W0011403',1012,'06N1012:0000206','W23','W23','Mo20W/+','Les2',['Les2'],'K0207').
genotype(2318,201,'06N201:S0004401',1012,'06N1012:0000205','Mo20W','Mo20W','Mo20W/+','Les2',['Les2'],'K0207').
genotype(2319,301,'06N301:W0004501',1012,'06N1012:0000205','W23','W23','Mo20W/+','Les2',['Les2'],'K0207').
genotype(2320,401,'06N401:M0012003',1012,'06N1012:0000205','M14','M14','Mo20W/+','Les2',['Les2'],'K0207').
genotype(2321,201,'06N201:S0005601',1012,'06N1012:0000202','Mo20W','Mo20W','Mo20W/+','Les2',['Les2'],'K0207').
genotype(2322,201,'06N201:S0014304',1012,'06N1012:0000202','Mo20W','Mo20W','Mo20W/+','Les2',['Les2'],'K0207').
genotype(2323,401,'06N401:M0024301',1012,'06N1012:0000202','M14','M14','Mo20W/+','Les2',['Les2'],'K0207').
genotype(2324,201,'06N201:S0004404',1012,'06N1012:0000201','Mo20W','Mo20W','Mo20W/+','Les2',['Les2'],'K0207').
genotype(2325,301,'06N301:W0004207',1012,'06N1012:0000201','W23','W23','Mo20W/+','Les2',['Les2'],'K0207').
genotype(2326,401,'06N401:M0005203',1012,'06N1012:0000201','M14','M14','Mo20W/+','Les2',['Les2'],'K0207').
genotype(2327,301,'06N301:W0034504',1603,'06N1603:0020008','W23','W23','M14','Mo20W/Les4',['Les4'],'K0302').
genotype(2328,401,'06N401:M0004302',1603,'06N1603:0020008','M14','M14','M14','Mo20W/Les4',['Les4'],'K0302').
genotype(2329,201,'06N201:S0009804',1602,'06N1602:0019913','Mo20W','Mo20W','M14','Mo20W/Les4',['Les4'],'K0303').
genotype(2330,301,'06N301:W0025402',1602,'06N1602:0019913','W23','W23','M14','Mo20W/Les4',['Les4'],'K0303').
genotype(2331,401,'06N401:M0004304',1602,'06N1602:0019913','M14','M14','M14','Mo20W/Les4',['Les4'],'K0303').
genotype(2332,201,'06N201:S0008906',1602,'06N1602:0019912','Mo20W','Mo20W','M14','Mo20W/Les4',['Les4'],'K0303').
genotype(2333,401,'06N401:M0006101',1602,'06N1602:0019912','M14','M14','M14','Mo20W/Les4',['Les4'],'K0303').
genotype(2334,201,'06N201:S0008309',1602,'06N1602:0019911','Mo20W','Mo20W','M14','Mo20W/Les4',['Les4'],'K0303').
genotype(2335,301,'06N301:W0006605',1602,'06N1602:0019911','W23','W23','M14','Mo20W/Les4',['Les4'],'K0303').
genotype(2336,401,'06N401:M0005201',1602,'06N1602:0019911','M14','M14','M14','Mo20W/Les4',['Les4'],'K0303').
genotype(2337,301,'06N301:W0025401',1602,'06N1602:0019910','W23','W23','M14','Mo20W/Les4',['Les4'],'K0303').
genotype(2338,401,'06N401:M0007001',1602,'06N1602:0019910','M14','M14','M14','Mo20W/Les4',['Les4'],'K0303').
genotype(2339,401,'06N401:M0005202',1602,'06N1602:0019909','M14','M14','M14','Mo20W/Les4',['Les4'],'K0303').
genotype(2340,201,'06N201:S0008305',1602,'06N1602:0019907','Mo20W','Mo20W','M14','Mo20W/Les4',['Les4'],'K0303').
genotype(2341,301,'06N301:W0029904',1602,'06N1602:0019907','W23','W23','M14','Mo20W/Les4',['Les4'],'K0303').
genotype(2342,401,'06N401:M0005509',1602,'06N1602:0019907','M14','M14','M14','Mo20W/Les4',['Les4'],'K0303').
genotype(2343,201,'06N201:S0031904',1602,'06N1602:0019905','Mo20W','Mo20W','M14','Mo20W/Les4',['Les4'],'K0303').
genotype(2344,301,'06N301:W0025101',1602,'06N1602:0019905','W23','W23','M14','Mo20W/Les4',['Les4'],'K0303').
genotype(2345,401,'06N401:M0004909',1602,'06N1602:0019905','M14','M14','M14','Mo20W/Les4',['Les4'],'K0303').
genotype(2346,201,'06N201:S0008301',1602,'06N1602:0019901','Mo20W','Mo20W','M14','Mo20W/Les4',['Les4'],'K0303').
genotype(2347,301,'06N301:W0006307',1602,'06N1602:0019901','W23','W23','M14','Mo20W/Les4',['Les4'],'K0303').
genotype(2348,401,'06N401:M0004902',1602,'06N1602:0019901','M14','M14','M14','Mo20W/Les4',['Les4'],'K0303').
genotype(2349,301,'06N301:W0004801',1015,'06N1015:0000511','W23','W23','Mo20W/+','Les4',['Les4'],'K0303').
genotype(2350,401,'06N401:M0006104',1015,'06N1015:0000511','M14','M14','Mo20W/+','Les4',['Les4'],'K0303').
genotype(2351,201,'06N201:S0005908',1015,'06N1015:0000506','Mo20W','Mo20W','Mo20W/+','Les4',['Les4'],'K0303').
genotype(2352,201,'06N201:S0005611',1015,'06N1015:0000505','Mo20W','Mo20W','Mo20W/+','Les4',['Les4'],'K0303').
genotype(2353,301,'06N301:W0004513',1015,'06N1015:0000505','W23','W23','Mo20W/+','Les4',['Les4'],'K0303').
genotype(2354,201,'06N201:S0004710',1015,'06N1015:0000502','Mo20W','Mo20W','Mo20W/+','Les4',['Les4'],'K0303').
genotype(2355,301,'06N301:W0004209',1015,'06N1015:0000502','W23','W23','Mo20W/+','Les4',['Les4'],'K0303').
genotype(2356,401,'06N401:M0005507',1015,'06N1015:0000502','M14','M14','Mo20W/+','Les4',['Les4'],'K0303').
genotype(2357,201,'06N201:S0005602',1015,'06N1015:0000501','Mo20W','Mo20W','Mo20W/+','Les4',['Les4'],'K0303').
%
% changed per ../results/asymmetric_families
%
% Kazic, 7.5.2010
%
% genotype(2358,401,'06N401:M0007901',1607,'06N1607:0020211','M14','M14','M14/Mo20W','Les6',['Les6'],'K0401').
% genotype(2359,1607,'06N1607:0020207',1607,'06N1607:0020207','M14','M14','Mo20W/Les6','Mo20W/Les6',['Les6'],'K0401').
% genotype(2360,201,'06N201:S0004705',1607,'06N1607:0020207','Mo20W','Mo20W','M14/Mo20W','Les6',['Les6'],'K0401').
% genotype(2361,301,'06N301:W0034807',1607,'06N1607:0020207','W23','W23','M14/Mo20W','Les6',['Les6'],'K0401').
% genotype(2362,401,'06N401:M0005207',1607,'06N1607:0020207','M14','M14','M14/Mo20W','Les6',['Les6'],'K0401').
% genotype(2363,401,'06N401:M0005502',1607,'06N1607:0020203','M14','M14','M14/Mo20W','Les6',['Les6'],'K0401').
% genotype(2364,401,'06N401:M0005501',1607,'06N1607:0020202','M14','M14','M14/Mo20W','Les6',['Les6'],'K0401').
% 
genotype(2358,401,'06N401:M0007901',1408,'06N1408:0020211','M14','M14','M14/Mo20W','Les6',['Les6'],'K0401').
genotype(2359,1408,'06N1408:0020207',1408,'06N1408:0020207','M14','M14','Mo20W/Les6','Mo20W/Les6',['Les6'],'K0401').
genotype(2360,201,'06N201:S0004705',1408,'06N1408:0020207','Mo20W','Mo20W','M14/Mo20W','Les6',['Les6'],'K0401').
genotype(2361,301,'06N301:W0034807',1408,'06N1408:0020207','W23','W23','M14/Mo20W','Les6',['Les6'],'K0401').
genotype(2362,401,'06N401:M0005207',1408,'06N1408:0020207','M14','M14','M14/Mo20W','Les6',['Les6'],'K0401').
genotype(2363,401,'06N401:M0005502',1408,'06N1408:0020203','M14','M14','M14/Mo20W','Les6',['Les6'],'K0401').
genotype(2364,401,'06N401:M0005501',1408,'06N1408:0020202','M14','M14','M14/Mo20W','Les6',['Les6'],'K0401').
%
genotype(2365,401,'06N401:M0011605',1605,'06N1605:0020107','M14','M14','M14/Mo20W','Les6',['Les6'],'K0403').
genotype(2366,201,'06N201:S0004412',1605,'06N1605:0020106','Mo20W','Mo20W','M14/Mo20W','Les6',['Les6'],'K0403').
genotype(2367,301,'06N301:W0025702',1605,'06N1605:0020106','W23','W23','M14/Mo20W','Les6',['Les6'],'K0403').
genotype(2368,301,'06N301:W0034804',1605,'06N1605:0020106','W23','W23','M14/Mo20W','Les6',['Les6'],'K0403').
genotype(2369,401,'06N401:M0007002',1605,'06N1605:0020106','M14','M14','M14/Mo20W','Les6',['Les6'],'K0403').
genotype(2370,401,'06N401:M0005206',1605,'06N1605:0020106','M14','M14','M14/Mo20W','Les6',['Les6'],'K0403').
genotype(2371,201,'06N201:S0004409',1605,'06N1605:0020105','Mo20W','Mo20W','M14/Mo20W','Les6',['Les6'],'K0403').
genotype(2372,301,'06N301:W0034802',1605,'06N1605:0020105','W23','W23','M14/Mo20W','Les6',['Les6'],'K0403').
genotype(2373,401,'06N401:M0005204',1605,'06N1605:0020105','M14','M14','M14/Mo20W','Les6',['Les6'],'K0403').
genotype(2374,201,'06N201:S0004113',1605,'06N1605:0020102','Mo20W','Mo20W','M14/Mo20W','Les6',['Les6'],'K0403').
genotype(2375,301,'06N301:W0034801',1605,'06N1605:0020102','W23','W23','M14/Mo20W','Les6',['Les6'],'K0403').
genotype(2376,401,'06N401:M0004903',1605,'06N1605:0020102','M14','M14','M14/Mo20W','Les6',['Les6'],'K0403').
genotype(2377,201,'06N201:S0004109',1605,'06N1605:0020101','Mo20W','Mo20W','M14/Mo20W','Les6',['Les6'],'K0403').
genotype(2378,301,'06N301:W0034607',1605,'06N1605:0020101','W23','W23','M14/Mo20W','Les6',['Les6'],'K0403').
genotype(2379,401,'06N401:M0004901',1605,'06N1605:0020101','M14','M14','M14/Mo20W','Les6',['Les6'],'K0403').
%
% changed per ../results/asymmetric_families
%
% Kazic, 7.5.2010
%
%
% 06N row 35 was Les6 35Les6 Mo20W/(Mo20W/Les6) I1909/0403 F1 Mo20W/(Mo20W/Les6)
%
% per field book
%
% genotype(2380,201,'06N201:S0023810',1004,'06N1004:0003509','Mo20W','Mo20W','Mo20W','Les6',['Les6'],'K0403').
% genotype(2381,201,'06N201:S0013902',1004,'06N1004:0003503','Mo20W','Mo20W','Mo20W','Les6',['Les6'],'K0403').
% genotype(2382,201,'06N201:S0013901',1004,'06N1004:0003502','Mo20W','Mo20W','Mo20W','Les6',['Les6'],'K0403').
%
genotype(2380,201,'06N201:S0023810',1271,'06N1271:0003509','Mo20W','Mo20W','Mo20W','Les6',['Les6'],'K0403').
genotype(2381,201,'06N201:S0013902',1271,'06N1271:0003503','Mo20W','Mo20W','Mo20W','Les6',['Les6'],'K0403').
genotype(2382,201,'06N201:S0013901',1271,'06N1271:0003502','Mo20W','Mo20W','Mo20W','Les6',['Les6'],'K0403').
%
%
% discrepancy!  family 1003 is supposedly les23; 10R phenotype supports this.  Families 2383 and 2384 not planted in 10R
%
% Kazic, 24.9.2010
%
% genotype(2383,201,'06N201:S0025001',1003,'06N1003:0003407','Mo20W','Mo20W','Mo20W','Les6',['Les6'],'K0405').
% genotype(2384,201,'06N201:S0023802',1003,'06N1003:0003406','Mo20W','Mo20W','Mo20W','Les6',['Les6'],'K0405').
%
%
% 06N row 34 was Les6 34Les6 Mo20W/(Mo20W/Les6) I1919/0405 F1 Mo20W/(Mo20W/Les6) per spreadsheet
% 06R row 4 was Les6 M18 112 116 M18 115 005 Mo20W + Les6
%
% line abandoned due to this confusion and family 1003 re-assigned.  But I need a new family number
% to let the computation of the indices work.  So I am giving these two lines their revised family number and correcting the
% inventory and packed_packets facts.
%
% Kazic, 9.12.2010
%
genotype(2383,201,'06N201:S0025001',1273,'06N1273:0003407','Mo20W','Mo20W','Mo20W','Les6',['Les6'],'K0405').
genotype(2384,201,'06N201:S0023802',1273,'06N1273:0003406','Mo20W','Mo20W','Mo20W','Les6',['Les6'],'K0405').







%
% changed per ../results/asymmetric_families
%
% Kazic, 7.5.2010
%
% genotype(2385,201,'06N201:S0005301',1016,'06N1016:0000612','Mo20W','Mo20W','Mo20W/+','Les7',['Les7'],'K0505').
% genotype(2386,301,'06N301:W0004810',1016,'06N1016:0000612','W23','W23','Mo20W/+','Les7',['Les7'],'K0505').
% genotype(2387,201,'06N201:S0011301',1016,'06N1016:0000611','Mo20W','Mo20W','Mo20W/+','Les7',['Les7'],'K0505').
% genotype(2388,301,'06N301:W0004809',1016,'06N1016:0000611','W23','W23','Mo20W/+','Les7',['Les7'],'K0505').
% genotype(2389,201,'06N201:S0006809',1016,'06N1016:0000607','Mo20W','Mo20W','Mo20W/+','Les7',['Les7'],'K0505').
% genotype(2390,201,'06N201:S0005603',1016,'06N1016:0000605','Mo20W','Mo20W','Mo20W/+','Les7',['Les7'],'K0505').
% genotype(2391,201,'06N201:S0005007',1016,'06N1016:0000602','Mo20W','Mo20W','Mo20W/+','Les7',['Les7'],'K0505').
% genotype(2392,301,'06N301:W0004805',1016,'06N1016:0000602','W23','W23','Mo20W/+','Les7',['Les7'],'K0505').
% genotype(2393,401,'06N401:M0006107',1016,'06N1016:0000602','M14','M14','Mo20W/+','Les7',['Les7'],'K0505').
%
genotype(2385,201,'06N201:S0005301',1237,'06N1237:0000612','Mo20W','Mo20W','Mo20W/+','Les7',['Les7'],'K0505').
genotype(2386,301,'06N301:W0004810',1237,'06N1237:0000612','W23','W23','Mo20W/+','Les7',['Les7'],'K0505').
genotype(2387,201,'06N201:S0011301',1237,'06N1237:0000611','Mo20W','Mo20W','Mo20W/+','Les7',['Les7'],'K0505').
genotype(2388,301,'06N301:W0004809',1237,'06N1237:0000611','W23','W23','Mo20W/+','Les7',['Les7'],'K0505').
genotype(2389,201,'06N201:S0006809',1237,'06N1237:0000607','Mo20W','Mo20W','Mo20W/+','Les7',['Les7'],'K0505').
genotype(2390,201,'06N201:S0005603',1237,'06N1237:0000605','Mo20W','Mo20W','Mo20W/+','Les7',['Les7'],'K0505').
genotype(2391,201,'06N201:S0005007',1237,'06N1237:0000602','Mo20W','Mo20W','Mo20W/+','Les7',['Les7'],'K0505').
genotype(2392,301,'06N301:W0004805',1237,'06N1237:0000602','W23','W23','Mo20W/+','Les7',['Les7'],'K0505').
genotype(2393,401,'06N401:M0006107',1237,'06N1237:0000602','M14','M14','Mo20W/+','Les7',['Les7'],'K0505').
%
genotype(2394,201,'06N201:S0010702',1017,'06N1017:0000713','Mo20W','Mo20W','Mo20W/+','Les7',['Les7'],'K0506').
genotype(2395,301,'06N301:W0005708',1017,'06N1017:0000713','W23','W23','Mo20W/+','Les7',['Les7'],'K0506').
genotype(2396,201,'06N201:S0005304',1017,'06N1017:0000711','Mo20W','Mo20W','Mo20W/+','Les7',['Les7'],'K0506').
genotype(2397,301,'06N301:W0010801',1017,'06N1017:0000711','W23','W23','Mo20W/+','Les7',['Les7'],'K0506').
genotype(2398,201,'06N201:S0013310',1017,'06N1017:0000709','Mo20W','Mo20W','Mo20W/+','Les7',['Les7'],'K0506').
genotype(2399,301,'06N301:W0005110',1017,'06N1017:0000709','W23','W23','Mo20W/+','Les7',['Les7'],'K0506').
genotype(2400,401,'06N401:M0010301',1017,'06N1017:0000709','M14','M14','Mo20W/+','Les7',['Les7'],'K0506').
genotype(2401,201,'06N201:S0010401',1017,'06N1017:0000707','Mo20W','Mo20W','Mo20W/+','Les7',['Les7'],'K0506').
genotype(2402,201,'06N201:S0008001',1017,'06N1017:0000707','Mo20W','Mo20W','Mo20W/+','Les7',['Les7'],'K0506').
genotype(2403,301,'06N301:W0005105',1017,'06N1017:0000707','W23','W23','Mo20W/+','Les7',['Les7'],'K0506').
genotype(2404,201,'06N201:S0005303',1017,'06N1017:0000705','Mo20W','Mo20W','Mo20W/+','Les7',['Les7'],'K0506').
genotype(2405,301,'06N301:W0005101',1017,'06N1017:0000705','W23','W23','Mo20W/+','Les7',['Les7'],'K0506').
genotype(2406,201,'06N201:S0005903',1017,'06N1017:0000704','Mo20W','Mo20W','Mo20W/+','Les7',['Les7'],'K0506').
genotype(2407,201,'06N201:S0013107',1017,'06N1017:0000702','Mo20W','Mo20W','Mo20W/+','Les7',['Les7'],'K0506').
genotype(2408,301,'06N301:W0004811',1017,'06N1017:0000702','W23','W23','Mo20W/+','Les7',['Les7'],'K0506').
genotype(2409,401,'06N401:M0006703',1017,'06N1017:0000702','M14','M14','Mo20W/+','Les7',['Les7'],'K0506').
genotype(2410,1017,'06N1017:0000708',1017,'06N1017:0000701','Mo20W/+','Mo20W/+','Mo20W/+','Les7',['Les7'],'K0506').
genotype(2411,201,'06N201:S0009213',1017,'06N1017:0000701','Mo20W','Mo20W','Mo20W/+','Les7',['Les7'],'K0506').
genotype(2412,401,'06N401:M0009401',1609,'06N1609:0020312','M14','M14','M14/Mo20W','Les7',['Les7'],'K0509').
genotype(2413,201,'06N201:S0004709',1609,'06N1609:0020311','Mo20W','Mo20W','M14/Mo20W','Les7',['Les7'],'K0509').
genotype(2414,301,'06N301:W0035005',1609,'06N1609:0020311','W23','W23','M14/Mo20W','Les7',['Les7'],'K0509').
genotype(2415,401,'06N401:M0005506',1609,'06N1609:0020311','M14','M14','M14/Mo20W','Les7',['Les7'],'K0509').
genotype(2416,401,'06N401:M0009102',1609,'06N1609:0020310','M14','M14','M14/Mo20W','Les7',['Les7'],'K0509').
genotype(2417,301,'06N301:W0025708',1609,'06N1609:0020307','W23','W23','M14/Mo20W','Les7',['Les7'],'K0509').
genotype(2418,401,'06N401:M0007903',1609,'06N1609:0020307','M14','M14','M14/Mo20W','Les7',['Les7'],'K0509').
genotype(2419,401,'06N401:M0008807',1609,'06N1609:0020305','M14','M14','M14/Mo20W','Les7',['Les7'],'K0509').
genotype(2420,401,'06N401:M0011808',1609,'06N1609:0020304','M14','M14','M14/Mo20W','Les7',['Les7'],'K0509').
genotype(2421,401,'06N401:M0007904',1609,'06N1609:0020302','M14','M14','M14/Mo20W','Les7',['Les7'],'K0509').
genotype(2422,201,'06N201:S0010103',1609,'06N1609:0020301','Mo20W','Mo20W','M14/Mo20W','Les7',['Les7'],'K0509').
genotype(2423,301,'06N301:W0025707',1609,'06N1609:0020301','W23','W23','M14/Mo20W','Les7',['Les7'],'K0509').
genotype(2424,401,'06N401:M0007605',1609,'06N1609:0020301','M14','M14','M14/Mo20W','Les7',['Les7'],'K0509').
genotype(2425,201,'06N201:S0025910',1005,'06N1005:0003612','Mo20W','Mo20W','Mo20W','Les7',['Les7'],'K0509').
genotype(2426,201,'06N201:S0006803',1005,'06N1005:0003607','Mo20W','Mo20W','Mo20W','Les7',['Les7'],'K0509').
genotype(2427,301,'06N301:W0031407',1005,'06N1005:0003607','W23','W23','Mo20W','Les7',['Les7'],'K0509').
genotype(2428,301,'06N301:W0009602',1005,'06N1005:0003607','W23','W23','Mo20W','Les7',['Les7'],'K0509').
genotype(2429,201,'06N201:S0025905',1005,'06N1005:0003605','Mo20W','Mo20W','Mo20W','Les7',['Les7'],'K0509').
genotype(2430,201,'06N201:S0025902',1005,'06N1005:0003602','Mo20W','Mo20W','Mo20W','Les7',['Les7'],'K0509').
%
% changed per ../results/asymmetric_families
%
% Kazic, 7.5.2010
%
% genotype(2431,201,'06N201:S0007702',1021,'06N1021:0001012','Mo20W','Mo20W','Mo20W/+','Les8',['Les8'],'K0601').
% genotype(2432,201,'06N201:S0007108',1021,'06N1021:0001011','Mo20W','Mo20W','Mo20W/+','Les8',['Les8'],'K0601').
% genotype(2433,201,'06N201:S0006806',1021,'06N1021:0001009','Mo20W','Mo20W','Mo20W/+','Les8',['Les8'],'K0601').
% genotype(2434,301,'06N301:W0006908',1021,'06N1021:0001008','W23','W23','Mo20W/+','Les8',['Les8'],'K0601').
% genotype(2435,201,'06N201:S0009206',1021,'06N1021:0001007','Mo20W','Mo20W','Mo20W/+','Les8',['Les8'],'K0601').
% genotype(2436,301,'06N301:W0006906',1021,'06N1021:0001007','W23','W23','Mo20W/+','Les8',['Les8'],'K0601').
% genotype(2437,401,'06N401:M0007603',1021,'06N1021:0001007','M14','M14','Mo20W/+','Les8',['Les8'],'K0601').
% genotype(2438,201,'06N201:S0006808',1021,'06N1021:0001003','Mo20W','Mo20W','Mo20W/+','Les8',['Les8'],'K0601').
% genotype(2439,301,'06N301:W0006609',1021,'06N1021:0001003','W23','W23','Mo20W/+','Les8',['Les8'],'K0601').
% genotype(2440,201,'06N201:S0009201',1021,'06N1021:0001002','Mo20W','Mo20W','Mo20W/+','Les8',['Les8'],'K0601').
% genotype(2441,301,'06N301:W0006305',1021,'06N1021:0001002','W23','W23','Mo20W/+','Les8',['Les8'],'K0601').
% genotype(2442,301,'06N301:W0005107',1021,'06N1021:0001002','W23','W23','Mo20W/+','Les8',['Les8'],'K0601').
% genotype(2443,401,'06N401:M0007302',1021,'06N1021:0001002','M14','M14','Mo20W/+','Les8',['Les8'],'K0601').
%
genotype(2431,201,'06N201:S0007702',1240,'06N1240:0001012','Mo20W','Mo20W','Mo20W/+','Les8',['Les8'],'K0601').
genotype(2432,201,'06N201:S0007108',1240,'06N1240:0001011','Mo20W','Mo20W','Mo20W/+','Les8',['Les8'],'K0601').
genotype(2433,201,'06N201:S0006806',1240,'06N1240:0001009','Mo20W','Mo20W','Mo20W/+','Les8',['Les8'],'K0601').
genotype(2434,301,'06N301:W0006908',1240,'06N1240:0001008','W23','W23','Mo20W/+','Les8',['Les8'],'K0601').
genotype(2435,201,'06N201:S0009206',1240,'06N1240:0001007','Mo20W','Mo20W','Mo20W/+','Les8',['Les8'],'K0601').
genotype(2436,301,'06N301:W0006906',1240,'06N1240:0001007','W23','W23','Mo20W/+','Les8',['Les8'],'K0601').
genotype(2437,401,'06N401:M0007603',1240,'06N1240:0001007','M14','M14','Mo20W/+','Les8',['Les8'],'K0601').
genotype(2438,201,'06N201:S0006808',1240,'06N1240:0001003','Mo20W','Mo20W','Mo20W/+','Les8',['Les8'],'K0601').
genotype(2439,301,'06N301:W0006609',1240,'06N1240:0001003','W23','W23','Mo20W/+','Les8',['Les8'],'K0601').
genotype(2440,201,'06N201:S0009201',1240,'06N1240:0001002','Mo20W','Mo20W','Mo20W/+','Les8',['Les8'],'K0601').
genotype(2441,301,'06N301:W0006305',1240,'06N1240:0001002','W23','W23','Mo20W/+','Les8',['Les8'],'K0601').
genotype(2442,301,'06N301:W0005107',1240,'06N1240:0001002','W23','W23','Mo20W/+','Les8',['Les8'],'K0601').
genotype(2443,401,'06N401:M0007302',1240,'06N1240:0001002','M14','M14','Mo20W/+','Les8',['Les8'],'K0601').
%
%
genotype(2444,201,'06N201:S0006505',1019,'06N1019:0000812','Mo20W','Mo20W','Mo20W/+','Les8',['Les8'],'K0604').
genotype(2445,201,'06N201:S0005906',1019,'06N1019:0000811','Mo20W','Mo20W','Mo20W/+','Les8',['Les8'],'K0604').
genotype(2446,301,'06N301:W0006006',1019,'06N1019:0000811','W23','W23','Mo20W/+','Les8',['Les8'],'K0604').
genotype(2447,201,'06N201:S0006503',1019,'06N1019:0000808','Mo20W','Mo20W','Mo20W/+','Les8',['Les8'],'K0604').
genotype(2448,201,'06N201:S0008008',1019,'06N1019:0000808','Mo20W','Mo20W','Mo20W/+','Les8',['Les8'],'K0604').
genotype(2449,301,'06N301:W0010803',1019,'06N1019:0000808','W23','W23','Mo20W/+','Les8',['Les8'],'K0604').
genotype(2450,201,'06N201:S0008005',1019,'06N1019:0000807','Mo20W','Mo20W','Mo20W/+','Les8',['Les8'],'K0604').
genotype(2451,301,'06N301:W0010510',1019,'06N1019:0000807','W23','W23','Mo20W/+','Les8',['Les8'],'K0604').
genotype(2452,401,'06N401:M0006706',1019,'06N1019:0000807','M14','M14','Mo20W/+','Les8',['Les8'],'K0604').
genotype(2453,201,'06N201:S0005909',1019,'06N1019:0000806','Mo20W','Mo20W','Mo20W/+','Les8',['Les8'],'K0604').
genotype(2454,201,'06N201:S0005307',1019,'06N1019:0000805','Mo20W','Mo20W','Mo20W/+','Les8',['Les8'],'K0604').
genotype(2455,301,'06N301:W0010504',1019,'06N1019:0000805','W23','W23','Mo20W/+','Les8',['Les8'],'K0604').
genotype(2456,301,'06N301:W0005709',1019,'06N1019:0000803','W23','W23','Mo20W/+','Les8',['Les8'],'K0604').
genotype(2457,301,'06N301:W0005104',1019,'06N1019:0000803','W23','W23','Mo20W/+','Les8',['Les8'],'K0604').
genotype(2458,401,'06N401:M0006704',1019,'06N1019:0000803','M14','M14','Mo20W/+','Les8',['Les8'],'K0604').
genotype(2459,201,'06N201:S0014102',1019,'06N1019:0000802','Mo20W','Mo20W','Mo20W/+','Les8',['Les8'],'K0604').
genotype(2460,301,'06N301:W0005109',1019,'06N1019:0000802','W23','W23','Mo20W/+','Les8',['Les8'],'K0604').
genotype(2461,301,'06N301:W0007201',1019,'06N1019:0000802','W23','W23','Mo20W/+','Les8',['Les8'],'K0604').
%
% changed per ../results/asymmetric_families
%
% Kazic, 7.5.2010
%
% genotype(2462,201,'06N201:S0006510',1020,'06N1020:0000913','Mo20W','Mo20W','Mo20W/+','Les8',['Les8'],'K0609').
% genotype(2463,201,'06N201:S0006509',1020,'06N1020:0000911','Mo20W','Mo20W','Mo20W/+','Les8',['Les8'],'K0609').
% genotype(2464,301,'06N301:W0006304',1020,'06N1020:0000911','W23','W23','Mo20W/+','Les8',['Les8'],'K0609').
% genotype(2465,201,'06N201:S0008308',1020,'06N1020:0000909','Mo20W','Mo20W','Mo20W/+','Les8',['Les8'],'K0609').
% genotype(2466,301,'06N301:W0006009',1020,'06N1020:0000909','W23','W23','Mo20W/+','Les8',['Les8'],'K0609').
% genotype(2467,401,'06N401:M0007301',1020,'06N1020:0000909','M14','M14','Mo20W/+','Les8',['Les8'],'K0609').
% genotype(2468,201,'06N201:S0006804',1020,'06N1020:0000905','Mo20W','Mo20W','Mo20W/+','Les8',['Les8'],'K0609').
% genotype(2469,301,'06N301:W0006008',1020,'06N1020:0000905','W23','W23','Mo20W/+','Les8',['Les8'],'K0609').
% genotype(2470,201,'06N201:S0006508',1020,'06N1020:0000903','Mo20W','Mo20W','Mo20W/+','Les8',['Les8'],'K0609').
% genotype(2471,201,'06N201:S0006802',1020,'06N1020:0000903','Mo20W','Mo20W','Mo20W/+','Les8',['Les8'],'K0609').
% genotype(2472,301,'06N301:W0006607',1020,'06N1020:0000903','W23','W23','Mo20W/+','Les8',['Les8'],'K0609').
% genotype(2473,401,'06N401:M0007003',1020,'06N1020:0000903','M14','M14','Mo20W/+','Les8',['Les8'],'K0609').
% genotype(2474,201,'06N201:S0006506',1020,'06N1020:0000901','Mo20W','Mo20W','Mo20W/+','Les8',['Les8'],'K0609').
%
%
genotype(2462,201,'06N201:S0006510',1241,'06N1241:0000913','Mo20W','Mo20W','Mo20W/+','Les8',['Les8'],'K0609').
genotype(2463,201,'06N201:S0006509',1241,'06N1241:0000911','Mo20W','Mo20W','Mo20W/+','Les8',['Les8'],'K0609').
genotype(2464,301,'06N301:W0006304',1241,'06N1241:0000911','W23','W23','Mo20W/+','Les8',['Les8'],'K0609').
genotype(2465,201,'06N201:S0008308',1241,'06N1241:0000909','Mo20W','Mo20W','Mo20W/+','Les8',['Les8'],'K0609').
genotype(2466,301,'06N301:W0006009',1241,'06N1241:0000909','W23','W23','Mo20W/+','Les8',['Les8'],'K0609').
genotype(2467,401,'06N401:M0007301',1241,'06N1241:0000909','M14','M14','Mo20W/+','Les8',['Les8'],'K0609').
genotype(2468,201,'06N201:S0006804',1241,'06N1241:0000905','Mo20W','Mo20W','Mo20W/+','Les8',['Les8'],'K0609').
genotype(2469,301,'06N301:W0006008',1241,'06N1241:0000905','W23','W23','Mo20W/+','Les8',['Les8'],'K0609').
genotype(2470,201,'06N201:S0006508',1241,'06N1241:0000903','Mo20W','Mo20W','Mo20W/+','Les8',['Les8'],'K0609').
genotype(2471,201,'06N201:S0006802',1241,'06N1241:0000903','Mo20W','Mo20W','Mo20W/+','Les8',['Les8'],'K0609').
genotype(2472,301,'06N301:W0006607',1241,'06N1241:0000903','W23','W23','Mo20W/+','Les8',['Les8'],'K0609').
genotype(2473,401,'06N401:M0007003',1241,'06N1241:0000903','M14','M14','Mo20W/+','Les8',['Les8'],'K0609').
genotype(2474,201,'06N201:S0006506',1241,'06N1241:0000901','Mo20W','Mo20W','Mo20W/+','Les8',['Les8'],'K0609').
%
genotype(2475,401,'06N401:M0010303',1612,'06N1612:0020512','M14','M14','M14/Mo20W','Les8',['Les8'],'K0611').
genotype(2476,201,'06N201:S0006501',1612,'06N1612:0020508','Mo20W','Mo20W','M14/Mo20W','Les8',['Les8'],'K0611').
genotype(2477,401,'06N401:M0007308',1612,'06N1612:0020508','M14','M14','M14/Mo20W','Les8',['Les8'],'K0611').
genotype(2478,201,'06N201:S0005606',1612,'06N1612:0020507','Mo20W','Mo20W','M14/Mo20W','Les8',['Les8'],'K0611').
genotype(2479,401,'06N401:M0010005',1612,'06N1612:0020507','M14','M14','M14/Mo20W','Les8',['Les8'],'K0611').
genotype(2480,201,'06N201:S0005901',1612,'06N1612:0020506','Mo20W','Mo20W','M14/Mo20W','Les8',['Les8'],'K0611').
genotype(2481,301,'06N301:W0036004',1612,'06N1612:0020506','W23','W23','M14/Mo20W','Les8',['Les8'],'K0611').
genotype(2482,401,'06N401:M0010004',1612,'06N1612:0020506','M14','M14','M14/Mo20W','Les8',['Les8'],'K0611').
genotype(2483,401,'06N401:M0006404',1612,'06N1612:0020506','M14','M14','M14/Mo20W','Les8',['Les8'],'K0611').
genotype(2484,301,'06N301:W0026606',1612,'06N1612:0020505','W23','W23','M14/Mo20W','Les8',['Les8'],'K0611').
genotype(2485,401,'06N401:M0008804',1612,'06N1612:0020505','M14','M14','M14/Mo20W','Les8',['Les8'],'K0611').
genotype(2486,301,'06N301:W0026303',1612,'06N1612:0020503','W23','W23','M14/Mo20W','Les8',['Les8'],'K0611').
genotype(2487,301,'06N301:W0035905',1612,'06N1612:0020501','W23','W23','M14/Mo20W','Les8',['Les8'],'K0611').
genotype(2488,401,'06N401:M0005802',1612,'06N1612:0020501','M14','M14','M14/Mo20W','Les8',['Les8'],'K0611').
genotype(2489,201,'06N201:S0005306',1612,'06N1612:0020501','Mo20W','Mo20W','M14/Mo20W','Les8',['Les8'],'K0611').
genotype(2490,201,'06N201:S0005004',1611,'06N1611:0020404','Mo20W','Mo20W','M14/Mo20W','Les8',['Les8'],'K0612').
genotype(2491,301,'06N301:W0035901',1611,'06N1611:0020404','W23','W23','M14/Mo20W','Les8',['Les8'],'K0612').
genotype(2492,401,'06N401:M0005801',1611,'06N1611:0020404','M14','M14','M14/Mo20W','Les8',['Les8'],'K0612').
genotype(2493,301,'06N301:W0026005',1611,'06N1611:0020402','W23','W23','M14/Mo20W','Les8',['Les8'],'K0612').
genotype(2494,401,'06N401:M0008503',1611,'06N1611:0020402','M14','M14','M14/Mo20W','Les8',['Les8'],'K0612').
genotype(2495,401,'06N401:M0011204',1611,'06N1611:0020401','M14','M14','M14/Mo20W','Les8',['Les8'],'K0612').
genotype(2496,201,'06N201:S0006807',1007,'06N1007:0003707','Mo20W','Mo20W','Mo20W','Les9',['Les9'],'K0707').
genotype(2497,301,'06N301:W0024201',1007,'06N1007:0003707','W23','W23','Mo20W','Les9',['Les9'],'K0707').
genotype(2498,201,'06N201:S0013609',1007,'06N1007:0003706','Mo20W','Mo20W','Mo20W','Les9',['Les9'],'K0707').
genotype(2499,301,'06N301:W0032005',1007,'06N1007:0003706','W23','W23','Mo20W','Les9',['Les9'],'K0707').
genotype(2500,301,'06N301:W0032002',1007,'06N1007:0003703','W23','W23','Mo20W','Les9',['Les9'],'K0707').
genotype(2501,401,'06N401:M0012906',1007,'06N1007:0003703','M14','M14','Mo20W','Les9',['Les9'],'K0707').
genotype(2502,201,'06N201:S0013402',1007,'06N1007:0003701','Mo20W','Mo20W','Mo20W','Les9',['Les9'],'K0707').
genotype(2503,401,'06N401:M0012703',1007,'06N1007:0003701','M14','M14','Mo20W','Les9',['Les9'],'K0707').
genotype(2504,201,'06N201:S0008302',1023,'06N1023:0001110','Mo20W','Mo20W','Mo20W/+','Les9',['Les9'],'K0709').
genotype(2505,301,'06N301:W0007801',1023,'06N1023:0001110','W23','W23','Mo20W/+','Les9',['Les9'],'K0709').
genotype(2506,201,'06N201:S0014103',1023,'06N1023:0001103','Mo20W','Mo20W','Mo20W/+','Les9',['Les9'],'K0709').
genotype(2507,401,'06N401:M0004908',1615,'06N1615:0020602','M14','M14','M14/Mo20W','Les10',['Les10'],'K0802').
%
% changed per ../results/asymmetric_families
%
% Kazic, 7.5.2010
%
% genotype(2508,201,'06N201:S0008306',1025,'06N1025:0001212','Mo20W','Mo20W','Mo20W/+','Les11',['Les11'],'K0901').
% genotype(2509,201,'06N201:S0008304',1025,'06N1025:0001211','Mo20W','Mo20W','Mo20W/+','Les11',['Les11'],'K0901').
% genotype(2510,201,'06N201:S0009210',1025,'06N1025:0001207','Mo20W','Mo20W','Mo20W/+','Les11',['Les11'],'K0901').
% genotype(2511,301,'06N301:W0008105',1025,'06N1025:0001207','W23','W23','Mo20W/+','Les11',['Les11'],'K0901').
% genotype(2512,401,'06N401:M0009101',1025,'06N1025:0001207','M14','M14','Mo20W/+','Les11',['Les11'],'K0901').
% genotype(2513,201,'06N201:S0008303',1025,'06N1025:0001202','Mo20W','Mo20W','Mo20W/+','Les11',['Les11'],'K0901').
% genotype(2514,201,'06N201:S0014106',1025,'06N1025:0001201','Mo20W','Mo20W','Mo20W/+','Les11',['Les11'],'K0901').
% genotype(2515,301,'06N301:W0008104',1025,'06N1025:0001201','W23','W23','Mo20W/+','Les11',['Les11'],'K0901').
% genotype(2516,401,'06N401:M0008806',1025,'06N1025:0001201','M14','M14','Mo20W/+','Les11',['Les11'],'K0901').
% 
genotype(2508,201,'06N201:S0008306',1243,'06N1243:0001212','Mo20W','Mo20W','Mo20W/+','Les11',['Les11'],'K0901').
genotype(2509,201,'06N201:S0008304',1243,'06N1243:0001211','Mo20W','Mo20W','Mo20W/+','Les11',['Les11'],'K0901').
genotype(2510,201,'06N201:S0009210',1243,'06N1243:0001207','Mo20W','Mo20W','Mo20W/+','Les11',['Les11'],'K0901').
genotype(2511,301,'06N301:W0008105',1243,'06N1243:0001207','W23','W23','Mo20W/+','Les11',['Les11'],'K0901').
genotype(2512,401,'06N401:M0009101',1243,'06N1243:0001207','M14','M14','Mo20W/+','Les11',['Les11'],'K0901').
genotype(2513,201,'06N201:S0008303',1243,'06N1243:0001202','Mo20W','Mo20W','Mo20W/+','Les11',['Les11'],'K0901').
genotype(2514,201,'06N201:S0014106',1243,'06N1243:0001201','Mo20W','Mo20W','Mo20W/+','Les11',['Les11'],'K0901').
genotype(2515,301,'06N301:W0008104',1243,'06N1243:0001201','W23','W23','Mo20W/+','Les11',['Les11'],'K0901').
genotype(2516,401,'06N401:M0008806',1243,'06N1243:0001201','M14','M14','Mo20W/+','Les11',['Les11'],'K0901').
%
genotype(2517,201,'06N201:S0006502',1616,'06N1616:0020709','Mo20W','Mo20W','M14/Mo20W','Les11',['Les11'],'K0904').
genotype(2518,301,'06N301:W0036202',1616,'06N1616:0020709','W23','W23','M14/Mo20W','Les11',['Les11'],'K0904').
genotype(2519,401,'06N401:M0007309',1616,'06N1616:0020709','M14','M14','M14/Mo20W','Les11',['Les11'],'K0904').
genotype(2520,401,'06N401:M0022905',1616,'06N1616:0020708','M14','M14','M14/Mo20W','Les11',['Les11'],'K0904').
genotype(2521,301,'06N301:W0026911',1616,'06N1616:0020707','W23','W23','M14/Mo20W','Les11',['Les11'],'K0904').
genotype(2522,401,'06N401:M0022904',1616,'06N1616:0020702','M14','M14','M14/Mo20W','Les11',['Les11'],'K0904').
genotype(2523,401,'06N401:M0022801',1616,'06N1616:0020701','M14','M14','M14/Mo20W','Les11',['Les11'],'K0904').
%
% changed per ../results/asymmetric_families
%
% Kazic, 7.5.2010
%
% genotype(2524,201,'06N201:S0029201',1008,'06N1008:0003808','Mo20W','Mo20W','Mo20W','Les11',['Les11'],'K0904').
% genotype(2525,201,'06N201:S0027103',1008,'06N1008:0003803','Mo20W','Mo20W','Mo20W','Les11',['Les11'],'K0904').
% genotype(2526,201,'06N201:S0027102',1008,'06N1008:0003802','Mo20W','Mo20W','Mo20W','Les11',['Les11'],'K0904').
%
genotype(2524,201,'06N201:S0029201',1270,'06N1270:0003808','Mo20W','Mo20W','Mo20W','Les11',['Les11'],'K0904').
genotype(2525,201,'06N201:S0027103',1270,'06N1270:0003803','Mo20W','Mo20W','Mo20W','Les11',['Les11'],'K0904').
genotype(2526,201,'06N201:S0027102',1270,'06N1270:0003802','Mo20W','Mo20W','Mo20W','Les11',['Les11'],'K0904').
%
genotype(2527,201,'06N201:S0010402',1617,'06N1617:0020801','Mo20W','Mo20W','M14/Mo20W','Les12',['Les12'],'K1001').
genotype(2528,401,'06N401:M0006402',1617,'06N1617:0020801','M14','M14','M14/Mo20W','Les12',['Les12'],'K1001').
genotype(2529,301,'06N301:W0005111',1029,'06N1029:0001310','W23','W23','Mo20W/+','Les13',['Les13'],'K1101').
genotype(2530,201,'06N201:S0010101',1029,'06N1029:0001303','Mo20W','Mo20W','Mo20W/+','Les13',['Les13'],'K1101').
genotype(2531,201,'06N201:S0010110',1032,'06N1032:0001412','Mo20W','Mo20W','Mo20W/+','Les13',['Les13'],'K1109').
genotype(2532,301,'06N301:W0006001',1032,'06N1032:0001412','W23','W23','Mo20W/+','Les13',['Les13'],'K1109').
genotype(2533,1032,'06N1032:0001407',1032,'06N1032:0001409','Mo20W/+','Mo20W/+','Mo20W/+','Les13',['Les13'],'K1109').
genotype(2534,201,'06N201:S0007110',1032,'06N1032:0001409','Mo20W','Mo20W','Mo20W/+','Les13',['Les13'],'K1109').
genotype(2535,301,'06N301:W0007501',1032,'06N1032:0001409','W23','W23','Mo20W/+','Les13',['Les13'],'K1109').
genotype(2536,401,'06N401:M0010603',1032,'06N1032:0001409','M14','M14','Mo20W/+','Les13',['Les13'],'K1109').
genotype(2537,201,'06N201:S0014109',1032,'06N1032:0001406','Mo20W','Mo20W','Mo20W/+','Les13',['Les13'],'K1109').
genotype(2538,301,'06N301:W0009003',1032,'06N1032:0001406','W23','W23','Mo20W/+','Les13',['Les13'],'K1109').
genotype(2539,401,'06N401:M0009704',1032,'06N1032:0001406','M14','M14','Mo20W/+','Les13',['Les13'],'K1109').
genotype(2540,201,'06N201:S0007109',1032,'06N1032:0001403','Mo20W','Mo20W','Mo20W/+','Les13',['Les13'],'K1109').
genotype(2541,301,'06N301:W0008702',1032,'06N1032:0001403','W23','W23','Mo20W/+','Les13',['Les13'],'K1109').
genotype(2542,401,'06N401:M0009701',1032,'06N1032:0001403','M14','M14','Mo20W/+','Les13',['Les13'],'K1109').
%
% changed per ../results/asymmetric_families
%
% Kazic, 7.5.2010
%
% genotype(2543,201,'06N201:S0013306',1009,'06N1009:0003910','Mo20W','Mo20W','Mo20W','Les13',['Les13'],'K1113').
% genotype(2544,301,'06N301:W0008708',1009,'06N1009:0003910','W23','W23','Mo20W','Les13',['Les13'],'K1113').
% genotype(2545,301,'06N301:W0032301',1009,'06N1009:0003910','W23','W23','Mo20W','Les13',['Les13'],'K1113').
% genotype(2546,401,'06N401:M0012901',1009,'06N1009:0003910','M14','M14','Mo20W','Les13',['Les13'],'K1113').
% genotype(2547,301,'06N301:W0008707',1009,'06N1009:0003908','W23','W23','Mo20W','Les13',['Les13'],'K1113').
%
genotype(2543,201,'06N201:S0013306',1269,'06N1269:0003910','Mo20W','Mo20W','Mo20W','Les13',['Les13'],'K1113').
genotype(2544,301,'06N301:W0008708',1269,'06N1269:0003910','W23','W23','Mo20W','Les13',['Les13'],'K1113').
genotype(2545,301,'06N301:W0032301',1269,'06N1269:0003910','W23','W23','Mo20W','Les13',['Les13'],'K1113').
genotype(2546,401,'06N401:M0012901',1269,'06N1269:0003910','M14','M14','Mo20W','Les13',['Les13'],'K1113').
genotype(2547,301,'06N301:W0008707',1269,'06N1269:0003908','W23','W23','Mo20W','Les13',['Les13'],'K1113').
%
%
% changed per ../results/asymmetric_families
%
% Kazic, 7.5.2010
%
% genotype(2548,201,'06N201:S0008605',1033,'06N1033:0001509','Mo20W','Mo20W','Mo20W/+','Les15',['Les15'],'K1207').
% genotype(2549,201,'06N201:S0008307',1033,'06N1033:0001508','Mo20W','Mo20W','Mo20W/+','Les15',['Les15'],'K1207').
% genotype(2550,201,'06N201:S0010405',1033,'06N1033:0001501','Mo20W','Mo20W','Mo20W/+','Les15',['Les15'],'K1207').
% genotype(2551,301,'06N301:W0009305',1033,'06N1033:0001501','W23','W23','Mo20W/+','Les15',['Les15'],'K1207').
% genotype(2552,401,'06N401:M0010902',1033,'06N1033:0001501','M14','M14','Mo20W/+','Les15',['Les15'],'K1207').
% 
genotype(2548,201,'06N201:S0008605',1244,'06N1244:0001509','Mo20W','Mo20W','Mo20W/+','Les15',['Les15'],'K1207').
genotype(2549,201,'06N201:S0008307',1244,'06N1244:0001508','Mo20W','Mo20W','Mo20W/+','Les15',['Les15'],'K1207').
genotype(2550,201,'06N201:S0010405',1244,'06N1244:0001501','Mo20W','Mo20W','Mo20W/+','Les15',['Les15'],'K1207').
genotype(2551,301,'06N301:W0009305',1244,'06N1244:0001501','W23','W23','Mo20W/+','Les15',['Les15'],'K1207').
genotype(2552,401,'06N401:M0010902',1244,'06N1244:0001501','M14','M14','Mo20W/+','Les15',['Les15'],'K1207').
%
genotype(2553,201,'06N201:S0007707',1034,'06N1034:0001608','Mo20W','Mo20W','Mo20W/+','Les15',['Les15'],'K1208').
genotype(2554,301,'06N301:W0009907',1034,'06N1034:0001608','W23','W23','Mo20W/+','Les15',['Les15'],'K1208').
genotype(2555,201,'06N201:S0007703',1034,'06N1034:0001605','Mo20W','Mo20W','Mo20W/+','Les15',['Les15'],'K1208').
genotype(2556,301,'06N301:W0009906',1034,'06N1034:0001605','W23','W23','Mo20W/+','Les15',['Les15'],'K1208').
genotype(2557,401,'06N401:M0011602',1034,'06N1034:0001605','M14','M14','Mo20W/+','Les15',['Les15'],'K1208').
genotype(2558,201,'06N201:S0008908',1034,'06N1034:0001604','Mo20W','Mo20W','Mo20W/+','Les15',['Les15'],'K1208').
genotype(2559,301,'06N301:W0009604',1034,'06N1034:0001604','W23','W23','Mo20W/+','Les15',['Les15'],'K1208').
genotype(2560,301,'06N301:W0009603',1034,'06N1034:0001601','W23','W23','Mo20W/+','Les15',['Les15'],'K1208').
genotype(2561,401,'06N401:M0010907',1034,'06N1034:0001601','M14','M14','Mo20W/+','Les15',['Les15'],'K1208').
%
% changed per ../results/asymmetric_families
%
% Kazic, 7.5.2010
%
% genotype(2562,201,'06N201:S0013209',1038,'06N1038:0001907','Mo20W','Mo20W','Mo20W/+','Les17',['Les17'],'K1302').
% genotype(2563,301,'06N301:W0010810',1038,'06N1038:0001907','W23','W23','Mo20W/+','Les17',['Les17'],'K1302').
% genotype(2564,401,'06N401:M0012005',1038,'06N1038:0001907','M14','M14','Mo20W/+','Les17',['Les17'],'K1302').
% genotype(2565,1038,'06N1038:0001906',1038,'06N1038:0001903','Mo20W/+','Mo20W/+','Mo20W/+','Les17',['Les17'],'K1302').
% genotype(2566,301,'06N301:W0006306',1038,'06N1038:0001903','W23','W23','Mo20W/+','Les17',['Les17'],'K1302').
% genotype(2567,201,'06N201:S0008010',1038,'06N1038:0001901','Mo20W','Mo20W','Mo20W/+','Les17',['Les17'],'K1302').
% genotype(2568,201,'06N201:S0009503',1038,'06N1038:0001901','Mo20W','Mo20W','Mo20W/+','Les17',['Les17'],'K1302').
% genotype(2569,301,'06N301:W0010812',1038,'06N1038:0001901','W23','W23','Mo20W/+','Les17',['Les17'],'K1302').
% genotype(2570,401,'06N401:M0011908',1038,'06N1038:0001901','M14','M14','Mo20W/+','Les17',['Les17'],'K1302').
% 
genotype(2562,201,'06N201:S0013209',1247,'06N1247:0001907','Mo20W','Mo20W','Mo20W/+','Les17',['Les17'],'K1302').
genotype(2563,301,'06N301:W0010810',1247,'06N1247:0001907','W23','W23','Mo20W/+','Les17',['Les17'],'K1302').
genotype(2564,401,'06N401:M0012005',1247,'06N1247:0001907','M14','M14','Mo20W/+','Les17',['Les17'],'K1302').
genotype(2565,1247,'06N1247:0001906',1247,'06N1247:0001903','Mo20W/+','Mo20W/+','Mo20W/+','Les17',['Les17'],'K1302').
genotype(2566,301,'06N301:W0006306',1247,'06N1247:0001903','W23','W23','Mo20W/+','Les17',['Les17'],'K1302').
genotype(2567,201,'06N201:S0008010',1247,'06N1247:0001901','Mo20W','Mo20W','Mo20W/+','Les17',['Les17'],'K1302').
genotype(2568,201,'06N201:S0009503',1247,'06N1247:0001901','Mo20W','Mo20W','Mo20W/+','Les17',['Les17'],'K1302').
genotype(2569,301,'06N301:W0010812',1247,'06N1247:0001901','W23','W23','Mo20W/+','Les17',['Les17'],'K1302').
genotype(2570,401,'06N401:M0011908',1247,'06N1247:0001901','M14','M14','Mo20W/+','Les17',['Les17'],'K1302').
%
genotype(2571,201,'06N201:S0010411',1620,'06N1620:0020905','Mo20W','Mo20W','M14/Mo20W','Les17',['Les17'],'K1309').
genotype(2572,301,'06N301:W0027201',1620,'06N1620:0020905','W23','W23','M14/Mo20W','Les17',['Les17'],'K1309').
genotype(2573,401,'06N401:M0009707',1620,'06N1620:0020905','M14','M14','M14/Mo20W','Les17',['Les17'],'K1309').
genotype(2574,201,'06N201:S0010407',1620,'06N1620:0020903','Mo20W','Mo20W','M14/Mo20W','Les17',['Les17'],'K1309').
genotype(2575,301,'06N301:W0009005',1620,'06N1620:0020903','W23','W23','M14/Mo20W','Les17',['Les17'],'K1309').
genotype(2576,401,'06N401:M0006701',1620,'06N1620:0020903','M14','M14','M14/Mo20W','Les17',['Les17'],'K1309').
genotype(2577,201,'06N201:S0008002',1036,'06N1036:0001807','Mo20W','Mo20W','Mo20W/+','Les17',['Les17'],'K1309').
genotype(2578,301,'06N301:W0011406',1036,'06N1036:0001807','W23','W23','Mo20W/+','Les17',['Les17'],'K1309').
genotype(2579,401,'06N401:M0011907',1036,'06N1036:0001807','M14','M14','Mo20W/+','Les17',['Les17'],'K1309').
genotype(2580,201,'06N201:S0013307',1036,'06N1036:0001806','Mo20W','Mo20W','Mo20W/+','Les17',['Les17'],'K1309').
genotype(2581,301,'06N301:W0010809',1036,'06N1036:0001806','W23','W23','Mo20W/+','Les17',['Les17'],'K1309').
genotype(2582,201,'06N201:S0014101',1036,'06N1036:0001804','Mo20W','Mo20W','Mo20W/+','Les17',['Les17'],'K1309').
genotype(2583,301,'06N301:W0010808',1036,'06N1036:0001804','W23','W23','Mo20W/+','Les17',['Les17'],'K1309').
%
% changed per ../results/asymmetric_families
%
% Kazic, 7.5.2010
%
% genotype(2584,201,'06N201:S0014208',1035,'06N1035:0001703','Mo20W','Mo20W','Mo20W/+','Les17',['Les17'],'K1312').
% genotype(2585,301,'06N301:W0010805',1035,'06N1035:0001703','W23','W23','Mo20W/+','Les17',['Les17'],'K1312').
% genotype(2586,401,'06N401:M0011702',1035,'06N1035:0001703','M14','M14','Mo20W/+','Les17',['Les17'],'K1312').
% 
genotype(2584,201,'06N201:S0014208',1246,'06N1246:0001703','Mo20W','Mo20W','Mo20W/+','Les17',['Les17'],'K1312').
genotype(2585,301,'06N301:W0010805',1246,'06N1246:0001703','W23','W23','Mo20W/+','Les17',['Les17'],'K1312').
genotype(2586,401,'06N401:M0011702',1246,'06N1246:0001703','M14','M14','Mo20W/+','Les17',['Les17'],'K1312').
%
genotype(2587,201,'06N201:S0009508',1039,'06N1039:0002013','Mo20W','Mo20W','Mo20W/+','Les18',['Les18'],'K1406').
genotype(2588,301,'06N301:W0026301',1039,'06N1039:0002013','W23','W23','Mo20W/+','Les18',['Les18'],'K1406').
genotype(2589,401,'06N401:M0013002',1039,'06N1039:0002013','M14','M14','Mo20W/+','Les18',['Les18'],'K1406').
genotype(2590,201,'06N201:S0009501',1039,'06N1039:0002011','Mo20W','Mo20W','Mo20W/+','Les18',['Les18'],'K1406').
genotype(2591,301,'06N301:W0005106',1039,'06N1039:0002011','W23','W23','Mo20W/+','Les18',['Les18'],'K1406').
genotype(2592,301,'06N301:W0025705',1039,'06N1039:0002011','W23','W23','Mo20W/+','Les18',['Les18'],'K1406').
genotype(2593,401,'06N401:M0012907',1039,'06N1039:0002011','M14','M14','Mo20W/+','Les18',['Les18'],'K1406').
genotype(2594,201,'06N201:S0009212',1039,'06N1039:0002009','Mo20W','Mo20W','Mo20W/+','Les18',['Les18'],'K1406').
genotype(2595,301,'06N301:W0025703',1039,'06N1039:0002009','W23','W23','Mo20W/+','Les18',['Les18'],'K1406').
genotype(2596,301,'06N301:W0007505',1039,'06N1039:0002009','W23','W23','Mo20W/+','Les18',['Les18'],'K1406').
genotype(2597,401,'06N401:M0012103',1039,'06N1039:0002009','M14','M14','Mo20W/+','Les18',['Les18'],'K1406').
genotype(2598,201,'06N201:S0009207',1039,'06N1039:0002008','Mo20W','Mo20W','Mo20W/+','Les18',['Les18'],'K1406').
genotype(2599,301,'06N301:W0007503',1039,'06N1039:0002008','W23','W23','Mo20W/+','Les18',['Les18'],'K1406').
genotype(2600,301,'06N301:W0025701',1039,'06N1039:0002008','W23','W23','Mo20W/+','Les18',['Les18'],'K1406').
genotype(2601,1039,'06N1039:0002002',1039,'06N1039:0002007','Mo20W/+','Mo20W/+','Mo20W/+','Les18',['Les18'],'K1406').
genotype(2602,201,'06N201:S0009204',1039,'06N1039:0002007','Mo20W','Mo20W','Mo20W/+','Les18',['Les18'],'K1406').
genotype(2603,301,'06N301:W0010511',1039,'06N1039:0002007','W23','W23','Mo20W/+','Les18',['Les18'],'K1406').
genotype(2604,201,'06N201:S0008601',1039,'06N1039:0002006','Mo20W','Mo20W','Mo20W/+','Les18',['Les18'],'K1406').
genotype(2605,301,'06N301:W0006005',1039,'06N1039:0002006','W23','W23','Mo20W/+','Les18',['Les18'],'K1406').
genotype(2606,301,'06N301:W0025406',1039,'06N1039:0002006','W23','W23','Mo20W/+','Les18',['Les18'],'K1406').
genotype(2607,401,'06N401:M0013001',1039,'06N1039:0002006','M14','M14','Mo20W/+','Les18',['Les18'],'K1406').
genotype(2608,201,'06N201:S0013301',1039,'06N1039:0002001','Mo20W','Mo20W','Mo20W/+','Les18',['Les18'],'K1406').
genotype(2609,301,'06N301:W0011110',1039,'06N1039:0002001','W23','W23','Mo20W/+','Les18',['Les18'],'K1406').
genotype(2610,401,'06N401:M0012006',1039,'06N1039:0002001','M14','M14','Mo20W/+','Les18',['Les18'],'K1406').
genotype(2611,301,'06N301:W0011408',1602,'06N1602:0019912','W23','W23','Mo20W/+','Les4',['Les4'],'K0303').
%
% changed per ../results/asymmetric_families
%
% Kazic, 7.5.2010
%
% genotype(2612,201,'06N201:S0013802',1041,'06N1041:0002211','Mo20W','Mo20W','Mo20W/+','Les18',['Les18'],'K1407').
% genotype(2613,201,'06N201:S0013506',1041,'06N1041:0002206','Mo20W','Mo20W','Mo20W/+','Les18',['Les18'],'K1407').
% genotype(2614,201,'06N201:S0010109',1041,'06N1041:0002204','Mo20W','Mo20W','Mo20W/+','Les18',['Les18'],'K1407').
% genotype(2615,401,'06N401:M0012302',1041,'06N1041:0002204','M14','M14','Mo20W/+','Les18',['Les18'],'K1407').
% genotype(2616,201,'06N201:S0010106',1041,'06N1041:0002203','Mo20W','Mo20W','Mo20W/+','Les18',['Les18'],'K1407').
% genotype(2617,301,'06N301:W0011407',1041,'06N1041:0002203','W23','W23','Mo20W/+','Les18',['Les18'],'K1407').
% genotype(2618,401,'06N401:M0012104',1041,'06N1041:0002203','M14','M14','Mo20W/+','Les18',['Les18'],'K1407').
% 
genotype(2612,201,'06N201:S0013802',1249,'06N1249:0002211','Mo20W','Mo20W','Mo20W/+','Les18',['Les18'],'K1407').
genotype(2613,201,'06N201:S0013506',1249,'06N1249:0002206','Mo20W','Mo20W','Mo20W/+','Les18',['Les18'],'K1407').
genotype(2614,201,'06N201:S0010109',1249,'06N1249:0002204','Mo20W','Mo20W','Mo20W/+','Les18',['Les18'],'K1407').
genotype(2615,401,'06N401:M0012302',1249,'06N1249:0002204','M14','M14','Mo20W/+','Les18',['Les18'],'K1407').
genotype(2616,201,'06N201:S0010106',1249,'06N1249:0002203','Mo20W','Mo20W','Mo20W/+','Les18',['Les18'],'K1407').
genotype(2617,301,'06N301:W0011407',1249,'06N1249:0002203','W23','W23','Mo20W/+','Les18',['Les18'],'K1407').
genotype(2618,401,'06N401:M0012104',1249,'06N1249:0002203','M14','M14','Mo20W/+','Les18',['Les18'],'K1407').
%
genotype(2619,201,'06N201:S0011001',1040,'06N1040:0002108','Mo20W','Mo20W','Mo20W/+','Les18',['Les18'],'K1411').
genotype(2620,201,'06N201:S0009502',1040,'06N1040:0002104','Mo20W','Mo20W','Mo20W/+','Les18',['Les18'],'K1411').
genotype(2621,201,'06N201:S0010408',1040,'06N1040:0002102','Mo20W','Mo20W','Mo20W/+','Les18',['Les18'],'K1411').
genotype(2622,201,'06N201:S0008606',1040,'06N1040:0002101','Mo20W','Mo20W','Mo20W/+','Les18',['Les18'],'K1411').
genotype(2623,201,'06N201:S0013803',1043,'06N1043:0002411','Mo20W','Mo20W','Mo20W/+','Les19',['Les19'],'K1501').
genotype(2624,201,'06N201:S0013207',1043,'06N1043:0002405','Mo20W','Mo20W','Mo20W/+','Les19',['Les19'],'K1501').
genotype(2625,301,'06N301:W0008107',1043,'06N1043:0002405','W23','W23','Mo20W/+','Les19',['Les19'],'K1501').
genotype(2626,301,'06N301:W0029001',1043,'06N1043:0002405','W23','W23','Mo20W/+','Les19',['Les19'],'K1501').
genotype(2627,401,'06N401:M0012407',1043,'06N1043:0002405','M14','M14','Mo20W/+','Les19',['Les19'],'K1501').
genotype(2628,201,'06N201:S0013204',1043,'06N1043:0002403','Mo20W','Mo20W','Mo20W/+','Les19',['Les19'],'K1501').
genotype(2629,201,'06N201:S0004410',1043,'06N1043:0002403','Mo20W','Mo20W','Mo20W/+','Les19',['Les19'],'K1501').
genotype(2630,301,'06N301:W0008102',1043,'06N1043:0002403','W23','W23','Mo20W/+','Les19',['Les19'],'K1501').
genotype(2631,301,'06N301:W0027501',1043,'06N1043:0002403','W23','W23','Mo20W/+','Les19',['Les19'],'K1501').
genotype(2632,201,'06N201:S0013201',1043,'06N1043:0002401','Mo20W','Mo20W','Mo20W/+','Les19',['Les19'],'K1501').
genotype(2633,301,'06N301:W0007806',1043,'06N1043:0002401','W23','W23','Mo20W/+','Les19',['Les19'],'K1501').
genotype(2634,301,'06N301:W0027204',1043,'06N1043:0002401','W23','W23','Mo20W/+','Les19',['Les19'],'K1501').
genotype(2635,401,'06N401:M0012303',1043,'06N1043:0002401','M14','M14','Mo20W/+','Les19',['Les19'],'K1501').
genotype(2636,201,'06N201:S0008603',1624,'06N1624:0021012','Mo20W','Mo20W','M14/Mo20W','Les19',['Les19'],'K1504').
genotype(2637,301,'06N301:W0036208',1624,'06N1624:0021012','W23','W23','M14/Mo20W','Les19',['Les19'],'K1504').
genotype(2638,401,'06N401:M0008203',1624,'06N1624:0021012','M14','M14','M14/Mo20W','Les19',['Les19'],'K1504').
genotype(2639,401,'06N401:M0023606',1624,'06N1624:0021007','M14','M14','M14/Mo20W','Les19',['Les19'],'K1504').
genotype(2640,401,'06N401:M0023603',1624,'06N1624:0021006','M14','M14','M14/Mo20W','Les19',['Les19'],'K1504').
genotype(2641,401,'06N401:M0023602',1624,'06N1624:0021005','M14','M14','M14/Mo20W','Les19',['Les19'],'K1504').
genotype(2642,401,'06N401:M0022908',1624,'06N1624:0021003','M14','M14','M14/Mo20W','Les19',['Les19'],'K1504').
genotype(2643,201,'06N201:S0008006',1624,'06N1624:0021002','Mo20W','Mo20W','M14/Mo20W','Les19',['Les19'],'K1504').
genotype(2644,301,'06N301:W0036204',1624,'06N1624:0021002','W23','W23','M14/Mo20W','Les19',['Les19'],'K1504').
genotype(2645,401,'06N401:M0008201',1624,'06N1624:0021002','M14','M14','M14/Mo20W','Les19',['Les19'],'K1504').
genotype(2646,201,'06N201:S0013104',1042,'06N1042:0002308','Mo20W','Mo20W','Mo20W/+','Les19',['Les19'],'K1506').
genotype(2647,301,'06N301:W0006002',1042,'06N1042:0002308','W23','W23','Mo20W/+','Les19',['Les19'],'K1506').
genotype(2648,301,'06N301:W0008701',1042,'06N1042:0002308','W23','W23','Mo20W/+','Les19',['Les19'],'K1506').
genotype(2649,201,'06N201:S0010703',1042,'06N1042:0002306','Mo20W','Mo20W','Mo20W/+','Les19',['Les19'],'K1506').
genotype(2650,301,'06N301:W0027203',1042,'06N1042:0002306','W23','W23','Mo20W/+','Les19',['Les19'],'K1506').
genotype(2651,401,'06N401:M0012405',1042,'06N1042:0002306','M14','M14','Mo20W/+','Les19',['Les19'],'K1506').
genotype(2652,201,'06N201:S0010410',1042,'06N1042:0002305','Mo20W','Mo20W','Mo20W/+','Les19',['Les19'],'K1506').
genotype(2653,301,'06N301:W0026908',1042,'06N1042:0002305','W23','W23','Mo20W/+','Les19',['Les19'],'K1506').
genotype(2654,401,'06N401:M0012502',1042,'06N1042:0002305','M14','M14','Mo20W/+','Les19',['Les19'],'K1506').
genotype(2655,201,'06N201:S0010404',1042,'06N1042:0002304','Mo20W','Mo20W','Mo20W/+','Les19',['Les19'],'K1506').
genotype(2656,301,'06N301:W0026905',1042,'06N1042:0002304','W23','W23','Mo20W/+','Les19',['Les19'],'K1506').
genotype(2657,301,'06N301:W0007507',1042,'06N1042:0002304','W23','W23','Mo20W/+','Les19',['Les19'],'K1506').
genotype(2658,201,'06N201:S0010403',1042,'06N1042:0002302','Mo20W','Mo20W','Mo20W/+','Les19',['Les19'],'K1506').
genotype(2659,401,'06N401:M0012301',1042,'06N1042:0002302','M14','M14','Mo20W/+','Les19',['Les19'],'K1506').
genotype(2660,201,'06N201:S0013607',1042,'06N1042:0002301','Mo20W','Mo20W','Mo20W/+','Les19',['Les19'],'K1506').
genotype(2661,201,'06N201:S0013304',1044,'06N1044:0002508','Mo20W','Mo20W','Mo20W/+','Les19',['Les19'],'K1511').
genotype(2662,301,'06N301:W0029003',1044,'06N1044:0002508','W23','W23','Mo20W/+','Les19',['Les19'],'K1511').
genotype(2663,401,'06N401:M0012408',1044,'06N1044:0002508','M14','M14','Mo20W/+','Les19',['Les19'],'K1511').
genotype(2664,201,'06N201:S0013909',1044,'06N1044:0002506','Mo20W','Mo20W','Mo20W/+','Les19',['Les19'],'K1511').
genotype(2665,201,'06N201:S0013906',1044,'06N1044:0002504','Mo20W','Mo20W','Mo20W/+','Les19',['Les19'],'K1511').
genotype(2666,201,'06N201:S0013904',1044,'06N1044:0002501','Mo20W','Mo20W','Mo20W/+','Les19',['Les19'],'K1511').
genotype(2667,1050,'06N1050:0002813',1050,'06N1050:0002813','Mo20W/+',lls1,'Mo20W/+',lls1,[lls1],'K1702').
genotype(2668,201,'06N201:S0014301',1050,'06N1050:0002813','Mo20W','Mo20W','Mo20W/+',lls1,[lls1],'K1702').
genotype(2669,301,'06N301:W0031111',1050,'06N1050:0002813','W23','W23','Mo20W/+',lls1,[lls1],'K1702').
genotype(2670,1050,'06N1050:0002812',1050,'06N1050:0002812','Mo20W/+',lls1,'Mo20W/+',lls1,[lls1],'K1702').
genotype(2671,201,'06N201:S0005904',1050,'06N1050:0002812','Mo20W','Mo20W','Mo20W/+',lls1,[lls1],'K1702').
genotype(2672,301,'06N301:W0006004',1050,'06N1050:0002812','W23','W23','Mo20W/+',lls1,[lls1],'K1702').
genotype(2673,1050,'06N1050:0002810',1050,'06N1050:0002810','Mo20W/+',lls1,'Mo20W/+',lls1,[lls1],'K1702').
genotype(2674,201,'06N201:S0005609',1050,'06N1050:0002810','Mo20W','Mo20W','Mo20W/+',lls1,[lls1],'K1702').
genotype(2675,301,'06N301:W0005706',1050,'06N1050:0002810','W23','W23','Mo20W/+',lls1,[lls1],'K1702').
genotype(2676,1050,'06N1050:0002808',1050,'06N1050:0002808','Mo20W/+',lls1,'Mo20W/+',lls1,[lls1],'K1702').
genotype(2677,201,'06N201:S0005608',1050,'06N1050:0002808','Mo20W','Mo20W','Mo20W/+',lls1,[lls1],'K1702').
genotype(2678,301,'06N301:W0005406',1050,'06N1050:0002808','W23','W23','Mo20W/+',lls1,[lls1],'K1702').
genotype(2679,1050,'06N1050:0002807',1050,'06N1050:0002807','Mo20W/+',lls1,'Mo20W/+',lls1,[lls1],'K1702').
genotype(2680,201,'06N201:S0005605',1050,'06N1050:0002807','Mo20W','Mo20W','Mo20W/+',lls1,[lls1],'K1702').
genotype(2681,301,'06N301:W0031101',1050,'06N1050:0002807','W23','W23','Mo20W/+',lls1,[lls1],'K1702').
genotype(2682,301,'06N301:W0008401',1050,'06N1050:0002807','W23','W23','Mo20W/+',lls1,[lls1],'K1702').
genotype(2683,1050,'06N1050:0002806',1050,'06N1050:0002806','Mo20W/+',lls1,'Mo20W/+',lls1,[lls1],'K1702').
genotype(2684,301,'06N301:W0030802',1050,'06N1050:0002806','W23','W23','Mo20W/+',lls1,[lls1],'K1702').
genotype(2685,1050,'06N1050:0002805',1050,'06N1050:0002805','Mo20W/+',lls1,'Mo20W/+',lls1,[lls1],'K1702').
genotype(2686,301,'06N301:W0008109',1050,'06N1050:0002805','W23','W23','Mo20W/+',lls1,[lls1],'K1702').
genotype(2687,1050,'06N1050:0002804',1050,'06N1050:0002804','Mo20W/+',lls1,'Mo20W/+',lls1,[lls1],'K1702').
genotype(2688,201,'06N201:S0005311',1050,'06N1050:0002804','Mo20W','Mo20W','Mo20W/+',lls1,[lls1],'K1702').
genotype(2689,301,'06N301:W0005403',1050,'06N1050:0002804','W23','W23','Mo20W/+',lls1,[lls1],'K1702').
genotype(2690,1050,'06N1050:0002802',1050,'06N1050:0002802','Mo20W/+',lls1,'Mo20W/+',lls1,[lls1],'K1702').
genotype(2691,301,'06N301:W0007504',1050,'06N1050:0002802','W23','W23','Mo20W/+',lls1,[lls1],'K1702').
genotype(2692,1050,'06N1050:0002801',1050,'06N1050:0002801','Mo20W/+',lls1,'Mo20W/+',lls1,[lls1],'K1702').
genotype(2693,301,'06N301:W0007502',1050,'06N1050:0002801','W23','W23','Mo20W/+',lls1,[lls1],'K1702').
genotype(2694,1049,'06N1049:0002708',1049,'06N1049:0002708','Mo20W/+',lls1,'Mo20W/+',lls1,[lls1],'K1703').
genotype(2695,201,'06N201:S0014107',1049,'06N1049:0002708','Mo20W','Mo20W','Mo20W/+',lls1,[lls1],'K1703').
genotype(2696,1049,'06N1049:0002707',1049,'06N1049:0002707','Mo20W/+',lls1,'Mo20W/+',lls1,[lls1],'K1703').
genotype(2697,201,'06N201:S0005309',1049,'06N1049:0002707','Mo20W','Mo20W','Mo20W/+',lls1,[lls1],'K1703').
genotype(2698,301,'06N301:W0005401',1049,'06N1049:0002707','W23','W23','Mo20W/+',lls1,[lls1],'K1703').
genotype(2699,1049,'06N1049:0002706',1049,'06N1049:0002706','Mo20W/+',lls1,'Mo20W/+',lls1,[lls1],'K1703').
genotype(2700,201,'06N201:S0005005',1049,'06N1049:0002706','Mo20W','Mo20W','Mo20W/+',lls1,[lls1],'K1703').
genotype(2701,301,'06N301:W0004210',1049,'06N1049:0002706','W23','W23','Mo20W/+',lls1,[lls1],'K1703').
genotype(2702,201,'06N201:S0013302',1049,'06N1049:0002704','Mo20W','Mo20W','Mo20W/+',lls1,[lls1],'K1703').
genotype(2703,1049,'06N1049:0002703',1049,'06N1049:0002703','Mo20W/+',lls1,'Mo20W/+',lls1,[lls1],'K1703').
genotype(2704,201,'06N201:S0033410',1049,'06N1049:0002703','Mo20W','Mo20W','Mo20W/+',lls1,[lls1],'K1703').
genotype(2705,1049,'06N1049:0002702',1049,'06N1049:0002702','Mo20W/+',lls1,'Mo20W/+',lls1,[lls1],'K1703').
genotype(2706,301,'06N301:W0007208',1049,'06N1049:0002702','W23','W23','Mo20W/+',lls1,[lls1],'K1703').
genotype(2707,301,'06N301:W0029602',1049,'06N1049:0002702','W23','W23','Mo20W/+',lls1,[lls1],'K1703').
genotype(2708,301,'06N301:W0006602',1051,'06N1051:0002902','W23','W23','Mo20W/+',lls1,[lls1],'K1708').
genotype(2709,1051,'06N1051:0002910',1051,'06N1051:0002910','Mo20W/+',lls1,'Mo20W/+',lls1,[lls1],'K1708').
genotype(2710,1051,'06N1051:0002909',1051,'06N1051:0002909','Mo20W/+',lls1,'Mo20W/+',lls1,[lls1],'K1708').
genotype(2711,201,'06N201:S0005907',1051,'06N1051:0002909','Mo20W','Mo20W','Mo20W/+',lls1,[lls1],'K1708').
genotype(2712,301,'06N301:W0006603',1051,'06N1051:0002909','W23','W23','Mo20W/+',lls1,[lls1],'K1708').
genotype(2713,1051,'06N1051:0002908',1051,'06N1051:0002908','Mo20W/+',lls1,'Mo20W/+',lls1,[lls1],'K1708').
genotype(2714,301,'06N301:W0008410',1051,'06N1051:0002908','W23','W23','Mo20W/+',lls1,[lls1],'K1708').
genotype(2715,1051,'06N1051:0002907',1051,'06N1051:0002907','Mo20W/+',lls1,'Mo20W/+',lls1,[lls1],'K1708').
genotype(2716,301,'06N301:W0008405',1051,'06N1051:0002907','W23','W23','Mo20W/+',lls1,[lls1],'K1708').
genotype(2717,1051,'06N1051:0002902',1051,'06N1051:0002902','Mo20W/+',lls1,'Mo20W/+',lls1,[lls1],'K1708').
genotype(2718,201,'06N201:S0005905',1051,'06N1051:0002902','Mo20W','Mo20W','Mo20W/+',lls1,[lls1],'K1708').
%
% changed per ../results/asymmetric_families
%
% Kazic, 7.5.2010
%
% genotype(2719,1047,'06N1047:0002611',1047,'06N1047:0002611','Mo20W/+',les23,'Mo20W/+',les23,[les23],'K1804').
% genotype(2720,1047,'06N1047:0002610',1047,'06N1047:0002610','Mo20W/+',les23,'Mo20W/+',les23,[les23],'K1804').
% genotype(2721,301,'06N301:W0029601',1047,'06N1047:0002610','W23','W23','Mo20W/+',les23,[les23],'K1804').
% genotype(2722,201,'06N201:S0014302',1047,'06N1047:0002607','Mo20W','Mo20W','Mo20W/+',les23,[les23],'K1804').
% genotype(2723,1047,'06N1047:0002603',1047,'06N1047:0002603','Mo20W/+',les23,'Mo20W/+',les23,[les23],'K1804').
% genotype(2724,301,'06N301:W0029301',1047,'06N1047:0002603','W23','W23','Mo20W/+',les23,[les23],'K1804').
% genotype(2725,1047,'06N1047:0002601',1047,'06N1047:0002601','Mo20W/+',les23,'Mo20W/+',les23,[les23],'K1804').
% genotype(2726,201,'06N201:S0005002',1047,'06N1047:0002601','Mo20W','Mo20W','Mo20W/+',les23,[les23],'K1804').
% genotype(2727,301,'06N301:W0004206',1047,'06N1047:0002601','W23','W23','Mo20W/+',les23,[les23],'K1804').
% 
genotype(2719,1253,'06N1253:0002611',1253,'06N1253:0002611','Mo20W/+',les23,'Mo20W/+',les23,[les23],'K1804').
genotype(2720,1253,'06N1253:0002610',1253,'06N1253:0002610','Mo20W/+',les23,'Mo20W/+',les23,[les23],'K1804').
genotype(2721,301,'06N301:W0029601',1253,'06N1253:0002610','W23','W23','Mo20W/+',les23,[les23],'K1804').
genotype(2722,201,'06N201:S0014302',1253,'06N1253:0002607','Mo20W','Mo20W','Mo20W/+',les23,[les23],'K1804').
genotype(2723,1253,'06N1253:0002603',1253,'06N1253:0002603','Mo20W/+',les23,'Mo20W/+',les23,[les23],'K1804').
genotype(2724,301,'06N301:W0029301',1253,'06N1253:0002603','W23','W23','Mo20W/+',les23,[les23],'K1804').
genotype(2725,1253,'06N1253:0002601',1253,'06N1253:0002601','Mo20W/+',les23,'Mo20W/+',les23,[les23],'K1804').
genotype(2726,201,'06N201:S0005002',1253,'06N1253:0002601','Mo20W','Mo20W','Mo20W/+',les23,[les23],'K1804').
genotype(2727,301,'06N301:W0004206',1253,'06N1253:0002601','W23','W23','Mo20W/+',les23,[les23],'K1804').
%
genotype(2728,301,'06N301:W0009301',1701,'06N1701:0021512','W23','W23','M14/W23','Les1',['Les1'],'K1903').
genotype(2729,201,'06N201:S0011302',1701,'06N1701:0021511','Mo20W','Mo20W','M14/W23','Les1',['Les1'],'K1903').
genotype(2730,301,'06N301:W0027806',1701,'06N1701:0021511','W23','W23','M14/W23','Les1',['Les1'],'K1903').
genotype(2731,301,'06N301:W0027805',1701,'06N1701:0021510','W23','W23','M14/W23','Les1',['Les1'],'K1903').
genotype(2732,301,'06N301:W0027804',1701,'06N1701:0021507','W23','W23','M14/W23','Les1',['Les1'],'K1903').
genotype(2733,401,'06N401:M0010601',1701,'06N1701:0021507','M14','M14','M14/W23','Les1',['Les1'],'K1903').
genotype(2734,201,'06N201:S0008907',1701,'06N1701:0021506','Mo20W','Mo20W','M14/W23','Les1',['Les1'],'K1903').
genotype(2735,301,'06N301:W0027803',1701,'06N1701:0021506','W23','W23','M14/W23','Les1',['Les1'],'K1903').
genotype(2736,401,'06N401:M0008502',1701,'06N1701:0021506','M14','M14','M14/W23','Les1',['Les1'],'K1903').
genotype(2737,301,'06N301:W0026912',1701,'06N1701:0021503','W23','W23','M14/W23','Les1',['Les1'],'K1903').
genotype(2738,301,'06N301:W0029303',1301,'06N1301:0016308','W23','W23','W23','Les1',['Les1'],'K1903').
genotype(2739,301,'06N301:W0004201',1301,'06N1301:0016305','W23','W23','W23','Les1',['Les1'],'K1903').
genotype(2740,301,'06N301:W0029302',1301,'06N1301:0016303','W23','W23','W23','Les1',['Les1'],'K1903').
genotype(2741,301,'06N301:W0029903',1300,'06N1300:0016206','W23','W23','W23','Les1',['Les1'],'K1909').
genotype(2742,301,'06N301:W0030502',1300,'06N1300:0016202','W23','W23','W23','Les1',['Les1'],'K1909').
genotype(2743,301,'06N301:W0026309',1302,'06N1302:0016413','W23','W23','W23','Les1',['Les1'],'K1912').
genotype(2744,301,'06N301:W0004508',1302,'06N1302:0016411','W23','W23','W23','Les1',['Les1'],'K1912').
genotype(2745,301,'06N301:W0025706',1302,'06N1302:0016410','W23','W23','W23','Les1',['Les1'],'K1912').
genotype(2746,301,'06N301:W0025704',1302,'06N1302:0016406','W23','W23','W23','Les1',['Les1'],'K1912').
genotype(2747,301,'06N301:W0024207',1302,'06N1302:0016401','W23','W23','W23','Les1',['Les1'],'K1912').
genotype(2748,301,'06N301:W0007510',1343,'06N1343:0014511','W23','W23','W23/+','Les2',['Les2'],'K2002').
genotype(2749,301,'06N301:W0004505',1343,'06N1343:0014509','W23','W23','W23/+','Les2',['Les2'],'K2002').
genotype(2750,301,'06N301:W0005704',1343,'06N1343:0014508','W23','W23','W23/+','Les2',['Les2'],'K2002').
genotype(2751,301,'06N301:W0008404',1343,'06N1343:0014507','W23','W23','W23/+','Les2',['Les2'],'K2002').
genotype(2752,301,'06N301:W0006904',1343,'06N1343:0014506','W23','W23','W23/+','Les2',['Les2'],'K2002').
genotype(2753,301,'06N301:W0007804',1343,'06N1343:0014502','W23','W23','W23/+','Les2',['Les2'],'K2002').
genotype(2754,301,'06N301:W0008403',1343,'06N1343:0014501','W23','W23','W23/+','Les2',['Les2'],'K2002').
genotype(2755,301,'06N301:W0005703',1342,'06N1342:0014410','W23','W23','W23/+','Les2',['Les2'],'K2003').
genotype(2756,301,'06N301:W0009903',1342,'06N1342:0014410','W23','W23','W23/+','Les2',['Les2'],'K2003').
genotype(2757,201,'06N201:S0013704',1342,'06N1342:0014404','Mo20W','Mo20W','W23/+','Les2',['Les2'],'K2003').
genotype(2758,301,'06N301:W0005702',1342,'06N1342:0014404','W23','W23','W23/+','Les2',['Les2'],'K2003').
genotype(2759,301,'06N301:W0011109',1344,'06N1344:0014612','W23','W23','W23/+','Les2',['Les2'],'K2011').
genotype(2760,301,'06N301:W0011102',1344,'06N1344:0014606','W23','W23','W23/+','Les2',['Les2'],'K2011').
genotype(2761,301,'06N301:W0008407',1344,'06N1344:0014604','W23','W23','W23/+','Les2',['Les2'],'K2011').
genotype(2762,201,'06N201:S0011308',1705,'06N1705:0021606','Mo20W','Mo20W','M14/W23','Les4',['Les4'],'K2101').
genotype(2763,301,'06N301:W0028706',1705,'06N1705:0021606','W23','W23','M14/W23','Les4',['Les4'],'K2101').
genotype(2764,401,'06N401:M0007601',1705,'06N1705:0021606','M14','M14','M14/W23','Les4',['Les4'],'K2101').
genotype(2765,301,'06N301:W0028705',1705,'06N1705:0021605','W23','W23','M14/W23','Les4',['Les4'],'K2101').
genotype(2766,401,'06N401:M0008202',1705,'06N1705:0021605','M14','M14','M14/W23','Les4',['Les4'],'K2101').
genotype(2767,201,'06N201:S0011304',1705,'06N1705:0021603','Mo20W','Mo20W','M14/W23','Les4',['Les4'],'K2101').
genotype(2768,301,'06N301:W0028704',1705,'06N1705:0021603','W23','W23','M14/W23','Les4',['Les4'],'K2101').
genotype(2769,401,'06N401:M0012902',1705,'06N1705:0021603','M14','M14','M14/W23','Les4',['Les4'],'K2101').
genotype(2770,301,'06N301:W0028703',1705,'06N1705:0021602','W23','W23','M14/W23','Les4',['Les4'],'K2101').
genotype(2771,301,'06N301:W0027808',1705,'06N1705:0021601','W23','W23','M14/W23','Les4',['Les4'],'K2101').
genotype(2772,401,'06N401:M0011506',1705,'06N1705:0021601','M14','M14','M14/W23','Les4',['Les4'],'K2101').

genotype(2774,301,'06N301:W0005102',1304,'06N1304:0016603','W23','W23','W23','Les4',['Les4'],'K2101').
genotype(2775,301,'06N301:W0034809',1347,'06N1347:0014804','W23','W23','W23/+','Les6',['Les6'],'K2202').
genotype(2776,301,'06N301:W0011405',1347,'06N1347:0014801','W23','W23','W23/+','Les6',['Les6'],'K2202').
genotype(2777,201,'06N201:S0013504',1706,'06N1706:0021712','Mo20W','Mo20W','M14/W23','Les6',['Les6'],'K2210').
genotype(2778,301,'06N301:W0029008',1706,'06N1706:0021712','W23','W23','M14/W23','Les6',['Les6'],'K2210').
genotype(2779,401,'06N401:M0011707',1706,'06N1706:0021712','M14','M14','M14/W23','Les6',['Les6'],'K2210').
genotype(2780,301,'06N301:W0009308',1706,'06N1706:0021709','W23','W23','M14/W23','Les6',['Les6'],'K2210').
genotype(2781,401,'06N401:M0007905',1706,'06N1706:0021709','M14','M14','M14/W23','Les6',['Les6'],'K2210').
genotype(2782,201,'06N201:S0013208',1706,'06N1706:0021708','Mo20W','Mo20W','M14/W23','Les6',['Les6'],'K2210').
genotype(2783,301,'06N301:W0028708',1706,'06N1706:0021708','W23','W23','M14/W23','Les6',['Les6'],'K2210').
genotype(2784,401,'06N401:M0011507',1706,'06N1706:0021708','M14','M14','M14/W23','Les6',['Les6'],'K2210').
genotype(2785,1706,'06N1706:0021704',1706,'06N1706:0021704','M14','M14','W23/Les6','W23/Les6',['Les6'],'K2210').
genotype(2786,201,'06N201:S0013105',1706,'06N1706:0021704','Mo20W','Mo20W','M14/W23','Les6',['Les6'],'K2210').
genotype(2787,301,'06N301:W0009006',1706,'06N1706:0021704','W23','W23','M14/W23','Les6',['Les6'],'K2210').
genotype(2788,401,'06N401:M0007602',1706,'06N1706:0021704','M14','M14','M14/W23','Les6',['Les6'],'K2210').
genotype(2789,301,'06N301:W0006601',1346,'06N1346:0014711','W23','W23','W23/+','Les6',['Les6'],'K2212').
genotype(2790,301,'06N301:W0011101',1346,'06N1346:0014710','W23','W23','W23/+','Les6',['Les6'],'K2212').
genotype(2791,301,'06N301:W0008409',1346,'06N1346:0014707','W23','W23','W23/+','Les6',['Les6'],'K2212').
genotype(2792,301,'06N301:W0008408',1346,'06N1346:0014703','W23','W23','W23/+','Les6',['Les6'],'K2212').
genotype(2793,301,'06N301:W0036201',1350,'06N1350:0015101','W23','W23','W23/+','Les7',['Les7'],'K2304').
genotype(2794,301,'06N301:W0008704',1348,'06N1348:0014908','W23','W23','W23/+','Les7',['Les7'],'K2310').
genotype(2795,301,'06N301:W0008703',1348,'06N1348:0014902','W23','W23','W23/+','Les7',['Les7'],'K2310').
genotype(2796,301,'06N301:W0036205',1348,'06N1348:0014902','W23','W23','W23/+','Les7',['Les7'],'K2310').
genotype(2797,301,'06N301:W0006606',1349,'06N1349:0015011','W23','W23','W23/+','Les7',['Les7'],'K2312').
genotype(2798,301,'06N301:W0006303',1349,'06N1349:0015008','W23','W23','W23/+','Les7',['Les7'],'K2312').
genotype(2799,301,'06N301:W0011111',1349,'06N1349:0015006','W23','W23','W23/+','Les7',['Les7'],'K2312').
genotype(2800,301,'06N301:W0008406',1349,'06N1349:0015003','W23','W23','W23/+','Les7',['Les7'],'K2312').
genotype(2801,301,'06N301:W0008709',1349,'06N1349:0015002','W23','W23','W23/+','Les7',['Les7'],'K2312').
genotype(2802,301,'06N301:W0024804',1315,'06N1315:0016901','W23','W23','W23','Les8',['Les8'],'K2402').
%
% changed per ../results/asymmetric_families
%
% Kazic, 7.5.2010
%
% genotype(2803,301,'06N301:W0027810',1313,'06N1313:0016706','W23','W23','W23','Les8',['Les8'],'K2404').
% genotype(2804,301,'06N301:W0027809',1313,'06N1313:0016704','W23','W23','W23','Les8',['Les8'],'K2404').
% genotype(2805,301,'06N301:W0027802',1313,'06N1313:0016703','W23','W23','W23','Les8',['Les8'],'K2404').
% genotype(2806,301,'06N301:W0005711',1313,'06N1313:0016702','W23','W23','W23','Les8',['Les8'],'K2404').
% genotype(2807,301,'06N301:W0027202',1313,'06N1313:0016701','W23','W23','W23','Les8',['Les8'],'K2404').
% 
genotype(2803,301,'06N301:W0027810',1407,'06N1407:0016706','W23','W23','W23','Les8',['Les8'],'K2404').
genotype(2804,301,'06N301:W0027809',1407,'06N1407:0016704','W23','W23','W23','Les8',['Les8'],'K2404').
genotype(2805,301,'06N301:W0027802',1407,'06N1407:0016703','W23','W23','W23','Les8',['Les8'],'K2404').
genotype(2806,301,'06N301:W0005711',1407,'06N1407:0016702','W23','W23','W23','Les8',['Les8'],'K2404').
genotype(2807,301,'06N301:W0027202',1407,'06N1407:0016701','W23','W23','W23','Les8',['Les8'],'K2404').
%
%
% changed per ../results/asymmetric_families
%
% Kazic, 7.5.2010
%
% genotype(2808,301,'06N301:W0024802',1314,'06N1314:0016809','W23','W23','W23','Les8',['Les8'],'K2405').
% genotype(2809,301,'06N301:W0028702',1314,'06N1314:0016806','W23','W23','W23','Les8',['Les8'],'K2405').
% genotype(2810,301,'06N301:W0028401',1314,'06N1314:0016804','W23','W23','W23','Les8',['Les8'],'K2405').
% 
genotype(2808,301,'06N301:W0024802',1328,'06N1328:0016809','W23','W23','W23','Les8',['Les8'],'K2405').
genotype(2809,301,'06N301:W0028702',1328,'06N1328:0016806','W23','W23','W23','Les8',['Les8'],'K2405').
genotype(2810,301,'06N301:W0028401',1328,'06N1328:0016804','W23','W23','W23','Les8',['Les8'],'K2405').
%
genotype(2811,301,'06N301:W0033202',1317,'06N1317:0017007','W23','W23','W23','Les9',['Les9'],'K2506').
genotype(2812,301,'06N301:W0007203',1317,'06N1317:0017007','W23','W23','W23','Les9',['Les9'],'K2506').
genotype(2813,301,'06N301:W0032905',1317,'06N1317:0017006','W23','W23','W23','Les9',['Les9'],'K2506').
genotype(2814,301,'06N301:W0006902',1317,'06N1317:0017005','W23','W23','W23','Les9',['Les9'],'K2506').
genotype(2815,301,'06N301:W0024807',1317,'06N1317:0017001','W23','W23','W23','Les9',['Les9'],'K2506').
genotype(2816,301,'06N301:W0004205',1352,'06N1352:0015305','W23','W23','W23/+','Les9',['Les9'],'K2510').
genotype(2817,301,'06N301:W0009001',1352,'06N1352:0015302','W23','W23','W23/+','Les9',['Les9'],'K2510').
genotype(2818,301,'06N301:W0006903',1352,'06N1352:0015301','W23','W23','W23/+','Les9',['Les9'],'K2510').
genotype(2819,301,'06N301:W0009901',1351,'06N1351:0015210','W23','W23','W23/+','Les9',['Les9'],'K2512').
genotype(2820,301,'06N301:W0009601',1351,'06N1351:0015210','W23','W23','W23/+','Les9',['Les9'],'K2512').
genotype(2821,301,'06N301:W0006901',1351,'06N1351:0015209','W23','W23','W23/+','Les9',['Les9'],'K2512').
genotype(2822,301,'06N301:W0006608',1351,'06N1351:0015201','W23','W23','W23/+','Les9',['Les9'],'K2512').
genotype(2823,301,'06N301:W0034803',1354,'06N1354:0015508','W23','W23','W23/+','Les10',['Les10'],'K2606').
genotype(2824,301,'06N301:W0032901',1354,'06N1354:0015504','W23','W23','W23/+','Les10',['Les10'],'K2606').
genotype(2825,301,'06N301:W0034805',1354,'06N1354:0015501','W23','W23','W23/+','Les10',['Les10'],'K2606').
genotype(2826,401,'06N401:M0024002',1712,'06N1712:0021801','M14','M14','M14/W23','Les10',['Les10'],'K2613').
genotype(2827,301,'06N301:W0008103',1353,'06N1353:0015412','W23','W23','W23/+','Les10',['Les10'],'K2615').
genotype(2828,301,'06N301:W0006909',1353,'06N1353:0015410','W23','W23','W23/+','Les10',['Les10'],'K2615').
genotype(2829,301,'06N301:W0009606',1353,'06N1353:0015403','W23','W23','W23/+','Les10',['Les10'],'K2615').
genotype(2830,301,'06N301:W0006905',1353,'06N1353:0015402','W23','W23','W23/+','Les10',['Les10'],'K2615').
genotype(2831,301,'06N301:W0009605',1353,'06N1353:0015401','W23','W23','W23/+','Les10',['Les10'],'K2615').
genotype(2832,301,'06N301:W0009304',1357,'06N1357:0015713','W23','W23','W23/+','Les12',['Les12'],'K2702').
genotype(2833,301,'06N301:W0009610',1357,'06N1357:0015713','W23','W23','W23/+','Les12',['Les12'],'K2702').
genotype(2834,301,'06N301:W0009302',1357,'06N1357:0015712','W23','W23','W23/+','Les12',['Les12'],'K2702').
genotype(2835,301,'06N301:W0009902',1357,'06N1357:0015710','W23','W23','W23/+','Les12',['Les12'],'K2702').
genotype(2836,301,'06N301:W0010506',1357,'06N1357:0015710','W23','W23','W23/+','Les12',['Les12'],'K2702').
genotype(2837,301,'06N301:W0010201',1357,'06N1357:0015707','W23','W23','W23/+','Les12',['Les12'],'K2702').
genotype(2838,301,'06N301:W0009908',1357,'06N1357:0015703','W23','W23','W23/+','Les12',['Les12'],'K2702').
genotype(2839,301,'06N301:W0009613',1356,'06N1356:0015601','W23','W23','W23/+','Les12',['Les12'],'K2706').
genotype(2840,201,'06N201:S0013706',1713,'06N1713:0021913','Mo20W','Mo20W','M14/W23','Les12',['Les12'],'K2711').
genotype(2841,301,'06N301:W0009310',1713,'06N1713:0021913','W23','W23','M14/W23','Les12',['Les12'],'K2711').
genotype(2842,401,'06N401:M0009705',1713,'06N1713:0021913','M14','M14','M14/W23','Les12',['Les12'],'K2711').
genotype(2843,201,'06N201:S0013705',1713,'06N1713:0021912','Mo20W','Mo20W','M14/W23','Les12',['Les12'],'K2711').
genotype(2844,301,'06N301:W0029906',1713,'06N1713:0021912','W23','W23','M14/W23','Les12',['Les12'],'K2711').
genotype(2845,401,'06N401:M0010904',1713,'06N1713:0021912','M14','M14','M14/W23','Les12',['Les12'],'K2711').
genotype(2846,201,'06N201:S0010102',1713,'06N1713:0021911','Mo20W','Mo20W','M14/W23','Les12',['Les12'],'K2711').
genotype(2847,301,'06N301:W0036305',1713,'06N1713:0021911','W23','W23','M14/W23','Les12',['Les12'],'K2711').
genotype(2848,401,'06N401:M0010302',1713,'06N1713:0021911','M14','M14','M14/W23','Les12',['Les12'],'K2711').
genotype(2849,401,'06N401:M0009104',1713,'06N1713:0021908','M14','M14','M14/W23','Les12',['Les12'],'K2711').
genotype(2850,201,'06N201:S0009506',1713,'06N1713:0021905','Mo20W','Mo20W','M14/W23','Les12',['Les12'],'K2711').
genotype(2851,301,'06N301:W0029305',1713,'06N1713:0021905','W23','W23','M14/W23','Les12',['Les12'],'K2711').
genotype(2852,401,'06N401:M0012406',1713,'06N1713:0021905','M14','M14','M14/W23','Les12',['Les12'],'K2711').
genotype(2853,401,'06N401:M0012203',1713,'06N1713:0021903','M14','M14','M14/W23','Les12',['Les12'],'K2711').
genotype(2854,401,'06N401:M0007906',1713,'06N1713:0021903','M14','M14','M14/W23','Les12',['Les12'],'K2711').
genotype(2855,201,'06N201:S0008909',1713,'06N1713:0021902','Mo20W','Mo20W','M14/W23','Les12',['Les12'],'K2711').
genotype(2856,301,'06N301:W0036301',1713,'06N1713:0021902','W23','W23','M14/W23','Les12',['Les12'],'K2711').
genotype(2857,401,'06N401:M0008805',1713,'06N1713:0021902','M14','M14','M14/W23','Les12',['Les12'],'K2711').
genotype(2858,401,'06N401:M0011708',1713,'06N1713:0021901','M14','M14','M14/W23','Les12',['Les12'],'K2711').
%
% changed per ../results/asymmetric_families
%
% Kazic, 7.5.2010
%
% genotype(2859,301,'06N301:W0007209',1321,'06N1321:0017107','W23','W23','W23','Les12',['Les12'],'K2711').
% genotype(2860,301,'06N301:W0033808',1321,'06N1321:0017107','W23','W23','W23','Les12',['Les12'],'K2711').
% genotype(2861,301,'06N301:W0033208',1321,'06N1321:0017103','W23','W23','W23','Les12',['Les12'],'K2711').
% 
genotype(2859,301,'06N301:W0007209',1285,'06N1285:0017107','W23','W23','W23','Les12',['Les12'],'K2711').
genotype(2860,301,'06N301:W0033808',1285,'06N1285:0017107','W23','W23','W23','Les12',['Les12'],'K2711').
genotype(2861,301,'06N301:W0033208',1285,'06N1285:0017103','W23','W23','W23','Les12',['Les12'],'K2711').
%
genotype(2862,201,'06N201:S0010710',1716,'06N1716:0022202','Mo20W','Mo20W','M14/W23','Les13',['Les13'],'K2802').
genotype(2863,301,'06N301:W0036504',1716,'06N1716:0022202','W23','W23','M14/W23','Les13',['Les13'],'K2802').
genotype(2864,201,'06N201:S0010108',1716,'06N1716:0022201','Mo20W','Mo20W','M14/W23','Les13',['Les13'],'K2802').
genotype(2865,301,'06N301:W0036502',1716,'06N1716:0022201','W23','W23','M14/W23','Les13',['Les13'],'K2802').
genotype(2866,201,'06N201:S0010104',1715,'06N1715:0022103','Mo20W','Mo20W','M14/W23','Les13',['Les13'],'K2805').
genotype(2867,301,'06N301:W0036501',1715,'06N1715:0022103','W23','W23','M14/W23','Les13',['Les13'],'K2805').
genotype(2868,401,'06N401:M0010305',1715,'06N1715:0022103','M14','M14','M14/W23','Les13',['Les13'],'K2805').
genotype(2869,301,'06N301:W0034402',1323,'06N1323:0017302','W23','W23','W23','Les13',['Les13'],'K2805').
genotype(2870,301,'06N301:W0034401',1323,'06N1323:0017301','W23','W23','W23','Les13',['Les13'],'K2805').
genotype(2871,201,'06N201:S0013710',1714,'06N1714:0022008','Mo20W','Mo20W','M14/W23','Les13',['Les13'],'K2808').
genotype(2872,301,'06N301:W0030503',1714,'06N1714:0022008','W23','W23','M14/W23','Les13',['Les13'],'K2808').
genotype(2873,401,'06N401:M0023601',1714,'06N1714:0022008','M14','M14','M14/W23','Les13',['Les13'],'K2808').
genotype(2874,201,'06N201:S0013709',1714,'06N1714:0022004','Mo20W','Mo20W','M14/W23','Les13',['Les13'],'K2808').
genotype(2875,401,'06N401:M0012505',1714,'06N1714:0022004','M14','M14','M14/W23','Les13',['Les13'],'K2808').
genotype(2876,301,'06N301:W0029909',1714,'06N1714:0022003','W23','W23','M14/W23','Les13',['Les13'],'K2808').
genotype(2877,301,'06N301:W0030801',1719,'06N1719:0022306','W23','W23','M14/W23','Les17',['Les17'],'K3007').
genotype(2878,401,'06N401:M0026406',1719,'06N1719:0022306','M14','M14','M14/W23','Les17',['Les17'],'K3007').
genotype(2879,201,'06N201:S0013903',1719,'06N1719:0022304','Mo20W','Mo20W','M14/W23','Les17',['Les17'],'K3007').
genotype(2880,301,'06N301:W0011409',1719,'06N1719:0022304','W23','W23','M14/W23','Les17',['Les17'],'K3007').
genotype(2881,401,'06N401:M0009706',1719,'06N1719:0022304','M14','M14','M14/W23','Les17',['Les17'],'K3007').
genotype(2882,301,'06N301:W0009910',1719,'06N1719:0022303','W23','W23','M14/W23','Les17',['Les17'],'K3007').
genotype(2883,401,'06N401:M0012002',1719,'06N1719:0022303','M14','M14','M14/W23','Les17',['Les17'],'K3007').
genotype(2884,301,'06N301:W0036509',1719,'06N1719:0022302','W23','W23','M14/W23','Les17',['Les17'],'K3007').
genotype(2885,401,'06N401:M0011905',1719,'06N1719:0022302','M14','M14','M14/W23','Les17',['Les17'],'K3007').
genotype(2886,301,'06N301:W0034601',1326,'06N1326:0017508','W23','W23','W23','Les17',['Les17'],'K3007').
genotype(2887,301,'06N301:W0034505',1326,'06N1326:0017505','W23','W23','W23','Les17',['Les17'],'K3007').
genotype(2888,301,'06N301:W0034501',1326,'06N1326:0017503','W23','W23','W23','Les17',['Les17'],'K3007').
genotype(2889,301,'06N301:W0034407',1326,'06N1326:0017502','W23','W23','W23','Les17',['Les17'],'K3007').
genotype(2890,301,'06N301:W0034406',1325,'06N1325:0017401','W23','W23','W23','Les17',['Les17'],'K3012').
genotype(2891,301,'06N301:W0007506',1325,'06N1325:0017401','W23','W23','W23','Les17',['Les17'],'K3012').
genotype(2892,301,'06N301:W0032608',1362,'06N1362:0015909','W23','W23','W23/+','Les18',['Les18'],'K3105').
genotype(2893,301,'06N301:W0009909',1362,'06N1362:0015908','W23','W23','W23/+','Les18',['Les18'],'K3105').
genotype(2894,301,'06N301:W0009905',1362,'06N1362:0015907','W23','W23','W23/+','Les18',['Les18'],'K3105').
genotype(2895,301,'06N301:W0034107',1362,'06N1362:0015902','W23','W23','W23/+','Les18',['Les18'],'K3105').
genotype(2896,301,'06N301:W0004208',1329,'06N1329:0017710','W23','W23','W23','Les18',['Les18'],'K3106').
genotype(2897,301,'06N301:W0007803',1329,'06N1329:0017706','W23','W23','W23','Les18',['Les18'],'K3106').
genotype(2898,301,'06N301:W0007508',1329,'06N1329:0017702','W23','W23','W23','Les18',['Les18'],'K3106').
genotype(2899,301,'06N301:W0036303',1333,'06N1333:0017907','W23','W23','W23','Les19',['Les19'],'K3204').
genotype(2900,301,'06N301:W0036207',1333,'06N1333:0017906','W23','W23','W23','Les19',['Les19'],'K3204').
genotype(2901,301,'06N301:W0036206',1333,'06N1333:0017904','W23','W23','W23','Les19',['Les19'],'K3204').
genotype(2902,301,'06N301:W0008106',1333,'06N1333:0017902','W23','W23','W23','Les19',['Les19'],'K3204').
genotype(2903,301,'06N301:W0034608',1333,'06N1333:0017902','W23','W23','W23','Les19',['Les19'],'K3204').
genotype(2904,301,'06N301:W0034602',1333,'06N1333:0017901','W23','W23','W23','Les19',['Les19'],'K3204').
%
% changed per ../results/asymmetric_families
%
% Kazic, 7.5.2010
%
% genotype(2905,301,'06N301:W0007805',1332,'06N1332:0017806','W23','W23','W23','Les19',['Les19'],'K3206').
% genotype(2906,301,'06N301:W0005405',1332,'06N1332:0017805','W23','W23','W23','Les19',['Les19'],'K3206').
% genotype(2907,301,'06N301:W0005402',1332,'06N1332:0017801','W23','W23','W23','Les19',['Les19'],'K3206').
% 
genotype(2905,301,'06N301:W0007805',1286,'06N1286:0017806','W23','W23','W23','Les19',['Les19'],'K3206').
genotype(2906,301,'06N301:W0005405',1286,'06N1286:0017805','W23','W23','W23','Les19',['Les19'],'K3206').
genotype(2907,301,'06N301:W0005402',1286,'06N1286:0017801','W23','W23','W23','Les19',['Les19'],'K3206').
%
genotype(2908,201,'06N201:S0014110',1723,'06N1723:0022413','Mo20W','Mo20W','M14/W23','Les19',['Les19'],'K3208').
genotype(2909,301,'06N301:W0032008',1723,'06N1723:0022413','W23','W23','M14/W23','Les19',['Les19'],'K3208').
genotype(2910,401,'06N401:M0012402',1723,'06N1723:0022411','M14','M14','M14/W23','Les19',['Les19'],'K3208').
genotype(2911,301,'06N301:W0031702',1723,'06N1723:0022408','W23','W23','M14/W23','Les19',['Les19'],'K3208').
genotype(2912,201,'06N201:S0014006',1723,'06N1723:0022405','Mo20W','Mo20W','M14/W23','Les19',['Les19'],'K3208').
genotype(2913,301,'06N301:W0031701',1723,'06N1723:0022405','W23','W23','M14/W23','Les19',['Les19'],'K3208').
genotype(2914,401,'06N401:M0035502',1723,'06N1723:0022405','M14','M14','M14/W23','Les19',['Les19'],'K3208').
genotype(2915,301,'06N301:W0031107',1723,'06N1723:0022402','W23','W23','M14/W23','Les19',['Les19'],'K3208').
genotype(2916,401,'06N401:M0030602',1723,'06N1723:0022402','M14','M14','M14/W23','Les19',['Les19'],'K3208').
genotype(2917,401,'06N401:M0012102',1723,'06N1723:0022401','M14','M14','M14/W23','Les19',['Les19'],'K3208').
genotype(2918,301,'06N301:W0010505',1363,'06N1363:0016007','W23','W23','W23/+','Les19',['Les19'],'K3209').
genotype(2919,301,'06N301:W0010502',1363,'06N1363:0016003','W23','W23','W23/+','Les19',['Les19'],'K3209').
genotype(2920,301,'06N301:W0029910',1363,'06N1363:0016001','W23','W23','W23/+','Les19',['Les19'],'K3209').
%
% changed per ../results/asymmetric_families
%
% Kazic, 7.5.2010
%
% genotype(2921,401,'06N401:M0024304',1725,'06N1725:0022609','M14','M14','M14/W23','Les21',['Les21'],'K3308').
% genotype(2922,401,'06N401:M0012507',1725,'06N1725:0022608','M14','M14','M14/W23','Les21',['Les21'],'K3308').
% genotype(2923,201,'06N201:S0011010',1725,'06N1725:0022602','Mo20W','Mo20W','M14/W23','Les21',['Les21'],'K3308').
% genotype(2924,401,'06N401:M0024003',1725,'06N1725:0022602','M14','M14','M14/W23','Les21',['Les21'],'K3308').
% genotype(2925,401,'06N401:M0010905',1725,'06N1725:0022602','M14','M14','M14/W23','Les21',['Les21'],'K3308').
% 
genotype(2921,401,'06N401:M0024304',1297,'06N1297:0022609','M14','M14','M14/W23','Les21',['Les21'],'K3308').
genotype(2922,401,'06N401:M0012507',1297,'06N1297:0022608','M14','M14','M14/W23','Les21',['Les21'],'K3308').
genotype(2923,201,'06N201:S0011010',1297,'06N1297:0022602','Mo20W','Mo20W','M14/W23','Les21',['Les21'],'K3308').
genotype(2924,401,'06N401:M0024003',1297,'06N1297:0022602','M14','M14','M14/W23','Les21',['Les21'],'K3308').
genotype(2925,401,'06N401:M0010905',1297,'06N1297:0022602','M14','M14','M14/W23','Les21',['Les21'],'K3308').
%
%
%
% changed per ../results/asymmetric_families
%
% Kazic, 7.5.2010
%
% genotype(2926,301,'06N301:W0033205',1335,'06N1335:0018101','W23','W23','W23','Les21',['Les21'],'K3308').
%
genotype(2926,301,'06N301:W0033205',1288,'06N1288:0018101','W23','W23','W23','Les21',['Les21'],'K3308').
%
genotype(2927,301,'06N301:W0008402',1334,'06N1334:0018012','W23','W23','W23','Les21',['Les21'],'K3311').
genotype(2928,301,'06N301:W0008108',1334,'06N1334:0018011','W23','W23','W23','Les21',['Les21'],'K3311').
%
%
% collision with family 1816, from 06N this is really Les2, K0202
%
% but 06N row 231 is Les20-N2457, K7110!  So these families and their forebear
% were redefined as shown.  No other changes were needed:  the descendants of these families
% already had the correct genotypes.  For the Les20 version of family 1816,
%
% 1816 -> [2929-[3297-[4055]],
%          2930-[3053-[3316-[3654]]],
%          2931,
%          2932-[3298-[3467]]
%         ]
%
% This family 1816 changed to family 4055!
%
% Note that now three genotypes were once assigned to family 1816 . . . (ugh):
%
%      Les2, K0202
%      Les9, K0707
%      Les20-N2457, K7110
%
% Mis-assignments of genotypes may continue to arise due to scanning of old barcodes with
% erroneous family numbers.
%
% Kazic, 18.12.2012
%
% genotype(4055,400,'06R400:M00I6105',71,'06R0071:0007110','M14','M14','(W23/L317)','+/Les20-N2457',['Les20-N2457'],'K7110').
%
%
%
% oops, the Les20-N2457, K7110 that I made family 4055 for was already assigned to family 1129! 
% All cross, harvest, and packed_packet facts amended to use 06N1129 for 06N1816:00231* and 06N4055:00231*.
%
% Note that this change DOES NOT ALTER the Les20-N2457 pedigree, 
% since pedigrees are calculated using crop and rowplant.
% 
% Kazic, 21.4.2013
%
% nope, at that point pedigrees were calculated using unification, oops.
%
% Kazic, 25.5.2018
    

genotype(2929,201,'06N201:S0011309',1129,'06N1129:0023107','Mo20W','Mo20W','M14/(W23/L317)','+/Les20-N2457',['Les20-N2457'],'K7110').
genotype(2930,301,'06N301:W0036606',1129,'06N1129:0023107','W23','W23','M14/(W23/L317)','+/Les20-N2457',['Les20-N2457'],'K7110').
genotype(2931,401,'06N401:M0011201',1129,'06N1129:0023107','M14','M14','M14/(W23/L317)','+/Les20-N2457',['Les20-N2457'],'K7110').
genotype(2932,401,'06N401:M0024306',1129,'06N1129:0023102','M14','M14','M14/(W23/L317)','+/Les20-N2457',['Les20-N2457'],'K7110').




genotype(2936,201,'06N201:S0013711',1159,'06N1159:0019212','Mo20W','Mo20W','W23','{+|Les*-N2397}/{+|Les*-N2397}',['Les*-N2397'],'K8414').
genotype(2937,301,'06N301:W0010811',1159,'06N1159:0019212','W23','W23','W23','{+|Les*-N2397}/{+|Les*-N2397}',['Les*-N2397'],'K8414').
genotype(2938,401,'06N401:M0011806',1159,'06N1159:0019212','M14','M14','W23','{+|Les*-N2397}/{+|Les*-N2397}',['Les*-N2397'],'K8414').
genotype(2939,201,'06N201:S0007701',1159,'06N1159:0019209','Mo20W','Mo20W','W23','{+|Les*-N2397}/{+|Les*-N2397}',['Les*-N2397'],'K8414').
genotype(2940,301,'06N301:W0010806',1159,'06N1159:0019209','W23','W23','W23','{+|Les*-N2397}/{+|Les*-N2397}',['Les*-N2397'],'K8414').
genotype(2941,201,'06N201:S0013804',1159,'06N1159:0019207','Mo20W','Mo20W','W23','{+|Les*-N2397}/{+|Les*-N2397}',['Les*-N2397'],'K8414').
genotype(2942,301,'06N301:W0010509',1159,'06N1159:0019207','W23','W23','W23','{+|Les*-N2397}/{+|Les*-N2397}',['Les*-N2397'],'K8414').
genotype(2943,301,'06N301:W0009904',1159,'06N1159:0019207','W23','W23','W23','{+|Les*-N2397}/{+|Les*-N2397}',['Les*-N2397'],'K8414').
genotype(2944,401,'06N401:M0011909',1159,'06N1159:0019207','M14','M14','W23','{+|Les*-N2397}/{+|Les*-N2397}',['Les*-N2397'],'K8414').
genotype(2945,201,'06N201:S0013807',1159,'06N1159:0019206','Mo20W','Mo20W','W23','{+|Les*-N2397}/{+|Les*-N2397}',['Les*-N2397'],'K8414').
genotype(2946,301,'06N301:W0010804',1159,'06N1159:0019206','W23','W23','W23','{+|Les*-N2397}/{+|Les*-N2397}',['Les*-N2397'],'K8414').
genotype(2947,401,'06N401:M0012201',1159,'06N1159:0019206','M14','M14','W23','{+|Les*-N2397}/{+|Les*-N2397}',['Les*-N2397'],'K8414').
genotype(2948,301,'06N301:W0010802',1159,'06N1159:0019205','W23','W23','W23','{+|Les*-N2397}/{+|Les*-N2397}',['Les*-N2397'],'K8414').
genotype(2949,401,'06N401:M0012202',1159,'06N1159:0019205','M14','M14','W23','{+|Les*-N2397}/{+|Les*-N2397}',['Les*-N2397'],'K8414').
genotype(2950,201,'06N201:S0013808',1159,'06N1159:0019204','Mo20W','Mo20W','W23','{+|Les*-N2397}/{+|Les*-N2397}',['Les*-N2397'],'K8414').
genotype(2951,301,'06N301:W0036307',1159,'06N1159:0019204','W23','W23','W23','{+|Les*-N2397}/{+|Les*-N2397}',['Les*-N2397'],'K8414').
genotype(2952,301,'06N301:W0010501',1159,'06N1159:0019204','W23','W23','W23','{+|Les*-N2397}/{+|Les*-N2397}',['Les*-N2397'],'K8414').
genotype(2953,401,'06N401:M0012306',1159,'06N1159:0019204','M14','M14','W23','{+|Les*-N2397}/{+|Les*-N2397}',['Les*-N2397'],'K8414').
genotype(2954,301,'06N301:W0010203',1159,'06N1159:0019203','W23','W23','W23','{+|Les*-N2397}/{+|Les*-N2397}',['Les*-N2397'],'K8414').
genotype(2955,201,'06N201:S0014305',1159,'06N1159:0019201','Mo20W','Mo20W','W23','{+|Les*-N2397}/{+|Les*-N2397}',['Les*-N2397'],'K8414').
genotype(2956,301,'06N301:W0009312',1159,'06N1159:0019201','W23','W23','W23','{+|Les*-N2397}/{+|Les*-N2397}',['Les*-N2397'],'K8414').
genotype(2957,301,'06N301:W0010503',1159,'06N1159:0019201','W23','W23','W23','{+|Les*-N2397}/{+|Les*-N2397}',['Les*-N2397'],'K8414').
genotype(2958,301,'06N301:W0036508',1159,'06N1159:0019201','W23','W23','W23','{+|Les*-N2397}/{+|Les*-N2397}',['Les*-N2397'],'K8414').
genotype(2959,401,'06N401:M0013005',1159,'06N1159:0019201','M14','M14','W23','{+|Les*-N2397}/{+|Les*-N2397}',['Les*-N2397'],'K8414').
genotype(2960,301,'06N301:W0007206',1431,'06N1431:0019112','W23','W23','(B73/AG32)/Ht1','+/Les*-N2418',['Les*-N2418'],'K8501').
genotype(2961,201,'06N201:S0014204',1431,'06N1431:0019111','Mo20W','Mo20W','W23/((B73/AG32)/Ht1)','W23(+/Les*-N2418)',['Les*-N2418'],'K8501').
genotype(2962,301,'06N301:W0009309',1431,'06N1431:0019111','W23','W23','W23/((B73/AG32)/Ht1)','W23/(+/Les*-N2418)',['Les*-N2418'],'K8501').
genotype(2963,301,'06N301:W0009612',1431,'06N1431:0019111','W23','W23','W23/((B73/AG32)/Ht1)','W23/(+/Les*-N2418)',['Les*-N2418'],'K8501').
genotype(2964,401,'06N401:M0012403',1431,'06N1431:0019111','M14','M14','W23/((B73/AG32)/Ht1)','W23/(+/Les*-N2418)',['Les*-N2418'],'K8501').
genotype(2965,301,'06N301:W0024805',1431,'06N1431:0019108','W23','W23','W23/((B73/AG32)/Ht1)','W23/(+/Les*-N2418)',['Les*-N2418'],'K8501').
genotype(2966,201,'06N201:S0014105',1431,'06N1431:0019103','Mo20W','Mo20W','W23/((B73/AG32)/Ht1)','W23/(+/Les*-N2418)',['Les*-N2418'],'K8501').
genotype(2967,301,'06N301:W0009306',1431,'06N1431:0019103','W23','W23','W23/((B73/AG32)/Ht1)','W23/(+/Les*-N2418)',['Les*-N2418'],'K8501').
genotype(2968,301,'06N301:W0009611',1431,'06N1431:0019103','W23','W23','W23/((B73/AG32)/Ht1)','W23/(+/Les*-N2418)',['Les*-N2418'],'K8501').
genotype(2969,401,'06N401:M0012603',1431,'06N1431:0019103','M14','M14','W23/((B73/AG32)/Ht1)','W23/(+/Les*-N2418)',['Les*-N2418'],'K8501').
genotype(2970,301,'06N301:W0033804',1430,'06N1430:0019006','W23','W23','W23/((B73/AG32)/Ht1)','W23/(+/Les*-N2418)',['Les*-N2418'],'K8510').
genotype(2971,201,'06N201:S0007404',1430,'06N1430:0019002','Mo20W','Mo20W','W23/((B73/AG32)/Ht1)','W23/(+/Les*-N2418)',['Les*-N2418'],'K8510').
genotype(2972,301,'06N301:W0024505',1430,'06N1430:0019002','W23','W23','W23/((B73/AG32)/Ht1)','W23/(+/Les*-N2418)',['Les*-N2418'],'K8510').
genotype(2973,301,'06N301:W0033207',1430,'06N1430:0019002','W23','W23','W23/((B73/AG32)/Ht1)','W23/(+/Les*-N2418)',['Les*-N2418'],'K8510').
genotype(2974,201,'06N201:S0008004',1435,'06N1435:0019304','Mo20W','Mo20W','W23/(B73/Ht1)','W23/(+/Les*-NA7145)',['Les*-NA7145'],'K9113').
genotype(2975,301,'06N301:W0011105',1435,'06N1435:0019304','W23','W23','W23/(B73/Ht1)','W23/(+/Les*-NA7145)',['Les*-NA7145'],'K9113').
genotype(2976,301,'06N301:W0033809',1435,'06N1435:0019304','W23','W23','W23/(B73/Ht1)','W23/(+/Les*-NA7145)',['Les*-NA7145'],'K9113').
genotype(2977,401,'06N401:M0009105',1616,'06N1616:0020707','M14','M14','M14/Mo20W','Les11',['Les11'],'K0904').
genotype(2978,301,'06N301:W0032603',1362,'06N1362:0015910','W23','W23','W23/+','Les18',['Les18'],'K3105').
genotype(2206,201,'06N201:S0007407',1034,'06N1034:0001601','Mo20W','Mo20W','Mo20W/+','Mo20W/Les15',['Les15'],'K0208').
%
% 2207, 2208 removed per duped_geno
%
% Kazic, 30.4.2010
%

genotype(2210,301,'06N301:W0026901',1042,'06N1042:0002302','W23','W23','Mo20W/+','Mo20W/Les19',['Les19'],'K1506').
genotype(2211,301,'06N301:W0031705',1007,'06N1007:0003701','W23','W23','Mo20W','Mo20W/Les9',['Les9'],'K0707').


% 07g

genotype(2212,119,'07G0119:0001402',119,'07G0119:0001402','+','Les3-GJ','+','Les3-GJ',['Les3-GJ'],'K11902').
genotype(2213,119,'07G0119:0001403',119,'07G0119:0001403','+','Les3-GJ','+','Les3-GJ',['Les3-GJ'],'K11903').
genotype(2214,119,'07G0119:0001404',119,'07G0119:0001404','+','Les3-GJ','+','Les3-GJ',['Les3-GJ'],'K11904').
genotype(2215,119,'07G0119:0001405',119,'07G0119:0001405','+','Les3-GJ','+','Les3-GJ',['Les3-GJ'],'K11905').
genotype(2216,119,'07G0119:0001406',119,'07G0119:0001406','+','Les3-GJ','+','Les3-GJ',['Les3-GJ'],'K11906').
genotype(2217,119,'07G0119:0001407',119,'07G0119:0001407','+','Les3-GJ','+','Les3-GJ',['Les3-GJ'],'K11907').
genotype(2218,119,'07G0119:0001408',119,'07G0119:0001408','+','Les3-GJ','+','Les3-GJ',['Les3-GJ'],'K11908').
genotype(2219,119,'07G0119:0001409',119,'07G0119:0001409','+','Les3-GJ','+','Les3-GJ',['Les3-GJ'],'K11909').
genotype(2220,119,'07G0119:0001410',119,'07G0119:0001410','+','Les3-GJ','+','Les3-GJ',['Les3-GJ'],'K11910').
genotype(2221,201,'07G201:S0000109',1012,'07G1012:0001001','Mo20W','Mo20W','Mo20W/+','Mo20W/Les2',['Les2'],'K0207').
genotype(2222,201,'07G201:S0000110',1012,'07G1012:0001005','Mo20W','Mo20W','Mo20W/+','Mo20W/Les2',['Les2'],'K0207').
genotype(2223,301,'07G301:W0000202',1012,'07G1012:0001005','W23','W23','Mo20W/+','Mo20W/Les2',['Les2'],'K0207').
genotype(2224,301,'07G301:W0000807',1012,'07G1012:0001001','W23','W23','Mo20W/+','Mo20W/Les2',['Les2'],'K0207').
genotype(2225,401,'07G401:M0000305',1012,'07G1012:0001001','M14','M14','Mo20W/+','Mo20W/Les2',['Les2'],'K0207').
genotype(2226,401,'07G401:M0000307',1012,'07G1012:0001005','M14','M14','Mo20W/+','Mo20W/Les2',['Les2'],'K0207').
genotype(2227,401,'07G401:M0000603',1012,'07G1012:0001006','M14','M14','Mo20W/+','Mo20W/Les2',['Les2'],'K0207').
genotype(2228,201,'07G201:S0000404',1705,'07G1705:0001101','Mo20W','Mo20W','M14/W23','W23/Les4',['Les4'],'K2101').












%%%%%%%%%%%%%%%%%%%%%%%%%%% popcorn %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

genotype(992,992,'07R992:P0mawhyl',992,'07R992:P0mawhyl','open-pollinated','yellow/white',pointed,'strawberry popcorn',[],'K99200').
genotype(993,993,'07R993:P0madkpu',993,'07R993:P0madkpu','open-pollinated','dark purple/blue-black',pointed,'strawberry popcorn',[],'K99300').
genotype(994,994,'07R994:P0modkpi',994,'07R994:P0modkpi','open-pollinated','slightly darker light pink',flat,'strawberry popcorn',[],'K99400').
genotype(995,995,'07R995:P0moltpi',995,'07R995:P0moltpi','open-pollinated','very light pink',flat,'strawberry popcorn',[],'K99500').
genotype(996,996,'07R996:P0moclwh',996,'07R996:P0moclwh','open-pollinated','nearly clearish white',flat,'strawberry popcorn',[],'K99600').
genotype(997,997,'07R997:P0molryl',997,'07R997:P0molryl','open-pollinated','light red/yellow',flat,'strawberry popcorn',[],'K99700').
genotype(998,998,'07R998:P0momdpu',998,'07R998:P0momdpu','open-pollinated',purple,flat,'strawberry popcorn',[],'K99800').
genotype(999,999,'07R999:P0molrpi',999,'07R999:P0molrpi','open-pollinated','light red/pinkish kernel',flat,'strawberry popcorn',[],'K99900').




% new popcorn lines will run between 900 and 989, omitting 990, 991 (sweet corn)
%
% Kazic, 28.4.2010
%
% I will run out, so then count down from 900.
%
% Kazic, 20.5.2012


% Bill''s 09R popcorn lines planted in 10R

genotype(900,992,'09R992:P0029304',992,'09R992:P0xxxxxx','open-pollinated','yellow','medium kernel','smooth top',[],'K90000').
genotype(901,992,'09R992:P0029304',992,'09R992:P0xxxxxx','open-pollinated','white','medium kernel','smooth top',[],'K90100').
genotype(902,999,'09R999:P0029202',999,'09R999:P0xxxxxx','open-pollinated','dark purple/black','medium kernel','smooth top',[],'K90200').
genotype(903,998,'09R998:P0020908',998,'09R998:P0xxxxxx','open-pollinated','mixed dark silver and green/yellow silver','medium kernel','smooth top',[],'K90300').
genotype(904,999,'09R999:P0029201',999,'09R999:P0xxxxxx','open-pollinated','light pink w/ some yellowish cast','medium kernel','smooth top',[],'K90400').
genotype(905,999,'09R999:P0029202',999,'09R999:P0xxxxxx','open-pollinated','white','medium kernel','smooth top',[],'K90500').
genotype(906,999,'09R999:P0029202',999,'09R999:P0xxxxxx','open-pollinated','red pink','medium kernel','smooth top',[],'K90600').
genotype(907,992,'09R992:P0029305',992,'09R992:P0xxxxxx','open-pollinated','medium-dark red','oblong kernel','some silk scars, some smooth',[],'K90700').
genotype(908,998,'09R998:P0020808',998,'09R998:P0xxxxxx','open-pollinated','dark silver','medium kernel','some silk scars, some smooth',[],'K90800').
genotype(909,993,'09R993:P0000110',993,'09R993:P0xxxxxx','open-pollinated','dark red','long kernel','pointed top',[],'K90900').
genotype(910,993,'09R993:P0000110',993,'09R993:P0xxxxxx','open-pollinated','lighter red-brown','medium kernel','smooth top',[],'K91000').
genotype(911,911,'10R911:P0000000',911,'10R911:P0000000','Weiler 1','ufo','oblong kernel','smooth top',[],'K91100').
genotype(912,912,'10R912:P0000000',912,'10R912:P0000000','Weiler 1','black','oblong kernel','smooth top',[],'K91200').
genotype(913,913,'10R913:P0000000',913,'10R913:P0000000','Weiler 2','ufo','small kernel','smooth top',[],'K91300').
genotype(914,914,'10R914:P0000000',914,'10R914:P0000000','Weiler 3','yellow','oblong kernel','smooth top',[],'K91400').



% phenotypes deduced from planting sequence and phenotypes in packing_plan.pl.  Popcorn
% was planted in successive rows.  No guarantees of correctness within a parental set!
%
% Kazic, 23.7.2011


genotype(915,908,'10R908:P0040105',908,'10R908:P0040105','split purple-yellow cl','smooth cl','small ear','',[],'').
genotype(916,908,'10R908:P0040105',908,'10R908:P0040105','purple with silver spot cl','smooth cl','small ear','',[],'').
genotype(917,908,'10R908:P0040105',908,'10R908:P0040105','dark purple cl','smooth cl','small ear','',[],'').
genotype(918,908,'10R908:P0040105',908,'10R908:P0040105','medium purple cl','smooth cl','small ear','',[],'').
genotype(919,908,'10R908:P0040105',908,'10R908:P0040105','light purple cl','smooth cl','small ear','',[],'').
%
% omitted? light yellow cl; smooth cl; small ear

genotype(920,904,'10R904:P0039709',904,'10R904:P0039709','red w/yellow speckle cl','mooth cl','long ear','',[],'').
genotype(921,904,'10R904:P0039709',904,'10R904:P0039709','yellow w/ light purple speckle cl','smooth cl','long ear','',[],'').
genotype(922,904,'10R904:P0039709',904,'10R904:P0039709','dark red-purple cl','smooth cl','long ear','',[],'').
genotype(923,904,'10R904:P0039709',904,'10R904:P0039709','red cl','smooth cl','long ear','',[],'').
genotype(924,904,'10R904:P0039709',904,'10R904:P0039709','light red cl','smooth cl','long ear','',[],'').
genotype(925,904,'10R904:P0039709',904,'10R904:P0039709','yellow cl','smooth cl','long ear','',[],'').
%
% omitted? light yellow cl','smooth cl','long ear


genotype(926,999,'09R999:P0029205',999,'09R999:P0029205','split ear, pink and purple cl','smooth cl','long ear','',[],'').
genotype(927,999,'09R999:P0029205',999,'09R999:P0029205','split ear, yellow and white cl','smooth cl','long ear','',[],'').


genotype(928,911,'10R911:P0040402',911,'10R911:P0040402','dark red cl','pointed cl','small ear','ear glumes',[],'').
genotype(929,911,'10R911:P0040402',911,'10R911:P0040402','dark purple-black cl','pointed cl','small ear','ear glumes',[],'').

genotype(930,912,'10R912:P0040504',912,'10R912:P0040504','dark purple-black cl','pointed cl','small ear','ear glumes',[],'').
genotype(931,912,'10R912:P0040504',912,'10R912:P0040504','lighter purple-brown-orange cl','pointed cl','small ear','ear glumes',[],'').
genotype(932,912,'10R912:P0040504',912,'10R912:P0040504','mostly orange sectoring ufo cl','pointed cl','small ear','ear glumes',[],'').
genotype(933,912,'10R912:P0040504',912,'10R912:P0040504','mostly yellow sectoring ufo cl','pointed cl','small ear','ear glumes',[],'').
genotype(934,912,'10R912:P0040504',912,'10R912:P0040504','orange cl','pointed cl','small ear','ear glumes',[],'').
genotype(935,912,'10R912:P0040504',912,'10R912:P0040504','light pink-white cl','pointed cl','small ear','ear glumes',[],'').
genotype(936,912,'10R912:P0040504',912,'10R912:P0040504','yellow cl','pointed cl','small ear','ear glumes',[],'').
%
% omitted?  light yellow cl; pointed cl; small ear; ear glumes


genotype(937,914,'10R914:P0040706',914,'10R914:P0040706','light yellow uniform cl','pointed cl','small ear','ear glumes',[],'').
genotype(938,914,'10R914:P0040706',914,'10R914:P0040706','yellow uniform cl','pointed cl','small ear','ear glumes',[],'').
genotype(939,914,'10R914:P0040706',914,'10R914:P0040706','yellow with orange splotches on top cl','pointed cl','small ear','ear glumes',[],'').
genotype(940,914,'10R914:P0040706',914,'10R914:P0040706','yellow with purple-brown splotches on top cl','pointed cl','small ear','ear glumes',[],'').
genotype(941,914,'10R914:P0040706',914,'10R914:P0040706','yellow with dark purple-black splotches on top cl','pointed cl','small ear','ear glumes',[],'').
%
% omitted?  orange uniform cl; pointed cl; small ear; ear glumes




% made in response to warnings from identify_row/3, but I think these are duplicates and packing facts
% or plan facts not correct. . . ugh
%
% Kazic, 23.7.2011
%

genotype(942,992,'09R992:P0029306',992,'09R992:P0xxxxxx','','','','',[],'').
genotype(943,992,'09R992:P0029307',992,'09R992:P0xxxxxx','','','','',[],'').
genotype(944,900,'10R900:P0000000',900,'10R900:P0000000','','','','',[],'').
genotype(945,908,'10R908:P0000000',908,'10R908:P0000000','','','','',[],'').
genotype(946,915,'10R915:P0000000',915,'10R915:P0000000','','','','',[],'').
genotype(947,916,'10R916:P0000000',916,'10R916:P0000000','','','','',[],'').
genotype(948,917,'10R917:P0000000',917,'10R917:P0000000','','','','',[],'').
genotype(949,918,'10R918:P0000000',918,'10R918:P0000000','','','','',[],'').
genotype(950,919,'10R919:P0000000',919,'10R919:P0000000','','','','',[],'').
genotype(951,920,'10R920:P0000000',920,'10R920:P0000000','','','','',[],'').
genotype(952,921,'10R921:P0000000',921,'10R921:P0000000','','','','',[],'').
genotype(953,922,'10R922:P0000000',922,'10R922:P0000000','','','','',[],'').
genotype(954,923,'10R923:P0000000',923,'10R923:P0000000','','','','',[],'').
genotype(955,924,'10R924:P0000000',924,'10R924:P0000000','','','','',[],'').
genotype(956,925,'10R925:P0000000',925,'10R925:P0000000','','','','',[],'').
genotype(957,926,'09R926:P0000000',926,'09R926:P0000000','','','','',[],'').
genotype(958,927,'09R927:P0000000',927,'09R927:P0000000','','','','',[],'').
genotype(959,909,'10R909:P0040307',909,'10R909:P0040307','','','','',[],'').
genotype(960,928,'10R928:P0000000',928,'10R928:P0000000','','','','',[],'').
genotype(961,929,'10R929:P0000000',929,'10R929:P0000000','','','','',[],'').
genotype(962,911,'10R911:P0040407',911,'10R911:P0040407','','','','',[],'').
genotype(963,912,'10R912:P0040501',912,'10R912:P0040501','','','','',[],'').
genotype(964,930,'10R930:P0000000',930,'10R930:P0000000','','','','',[],'').
genotype(965,901,'10R901:P0000000',901,'10R901:P0000000','','','','',[],'').
genotype(966,931,'10R931:P0000000',931,'10R931:P0000000','','','','',[],'').
genotype(967,932,'10R932:P0000000',932,'10R932:P0000000','','','','',[],'').
genotype(968,933,'10R933:P0000000',933,'10R933:P0000000','','','','',[],'').
genotype(969,934,'10R934:P0000000',934,'10R934:P0000000','','','','',[],'').
genotype(970,935,'10R935:P0000000',935,'10R935:P0000000','','','','',[],'').
genotype(971,936,'10R936:P0000000',936,'10R936:P0000000','','','','',[],'').
genotype(972,913,'10R913:P0040603',913,'10R913:P0040603','','','','',[],'').
genotype(973,937,'10R937:P0000000',937,'10R937:P0000000','','','','',[],'').
genotype(974,938,'10R938:P0000000',938,'10R938:P0000000','','','','',[],'').
genotype(975,939,'10R939:P0000000',939,'10R939:P0000000','','','','',[],'').
genotype(976,940,'10R940:P0000000',940,'10R940:P0000000','','','','',[],'').
genotype(977,941,'10R941:P0000000',941,'10R941:P0000000','','','','',[],'').
genotype(978,998,'09R998:P0020808',998,'09R998:P0020808','','','','',[],'').



% further subdivision of Weiler 1 line and offspring, for 12r

genotype(979,979,'10R979:P0000000',979,'10R979:P0000000','','','','',['small sector orange, less than 50%, mostly white'],'K97900').
	        		      	      
genotype(980,980,'10R980:P0000000',980,'10R980:P0000000','','','','',['medium sector orange, less than ~75%, mostly orange'],'K98000').
	        		      	      
genotype(981,981,'10R981:P0000000',981,'10R981:P0000000','','','','',['nearly complete sector orange, dark orange, streaks over embryo'],'K98100').
	        		      	      
genotype(982,982,'10R982:P0000000',982,'10R982:P0000000','','','','',['very dark orange/purple, orange streaks over embryo'],'K98200').

genotype(983,983,'10R983:P0000000',983,'10R983:P0000000','','','','',['very few orange sectors, mostly white, less than 25%'],'K98300').

genotype(984,984,'11R984:P0003508',984,'11R984:P0003508','','','','',['medium density orange sectors, ear nearly full of sectored kernels'],'K98408').

genotype(985,985,'11R985:P0003703',985,'11R985:P0003703','','','','',['nearly white kernels with very few orange sectors, ear split nearly evenly between heavily sectored and less sectored kernels'],'K98503').

genotype(986,986,'11R986:P0003703',986,'11R986:P0003703','','','','',['kernels with very few orange sectors, ear split nearly evenly between heavily sectored and less sectored kernels'],'K98603').

genotype(987,987,'11R987:P0003902',987,'11R987:P0003902','','','','',['kernels with half orange sectors, near the ear boundary of zones; probably all have split starch'],'K98702').

genotype(988,988,'11R988:P0003902',988,'11R988:P0003902','','','','',['white kernels with split starch'],'K98802').

genotype(989,989,'11R989:P0004001',989,'11R989:P0004001','','','','',['lightly sectoring kernels from predominantly white ear'],'K98901').




%%%%%%%%%%%%%%%%%%%%%%%%%%%% sweet corn; purchased as needed %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% new sweet corn lines will run between 880 and 891, so no overlapping with the popcorn
% I do not anticipate very many more of these.
%
% Kazic, 23.7.2011

genotype(892,892,'11R892:E0serend',893,'11R892:E0serend','serendipity','','','',[],'').
genotype(893,893,'07R893:E0earsun',893,'07R893:E0earsun','early sunglow','','','',[],'').
genotype(894,894,'07R894:E0goljub',894,'07R894:E0goljub','golden jubilee','','','',[],'').
genotype(895,895,'07R895:E0cogent',895,'07R895:E0cogent','country gentleman','','','',[],'').
genotype(897,896,'07R896:E0kankrn',896,'07R896:E0kankrn','kandy korn','','','',[],'').
genotype(897,897,'07R897:E0silqun',897,'07R897:E0silqun','silver queen','','','',[],'').
genotype(898,898,'07R898:E0bodcus',898,'07R898:E0bodcus',bodacious,'','','',[],'').
genotype(899,899,'07R899:E0bnjour',899,'07R899:E0bnjour','bon jour','','','',[],'').
genotype(990,990,'07R990:E0casino',990,'07R990:E0casino',casino,'','','',[],'').
genotype(991,991,'07R991:E0golban',991,'07R991:E0golban','golden bantam','','','',[],'').




    
%%%%%%%%%%%%%%%%%%%%%% elite lines %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% get these from Matt and Chris, numbers for now are between 890 -- 891 inclusive.
%
% Kazic, 20.4.2018    

genotype(890,890,'16R890:L0xxxxxx',890,'16R890:L0xxxxxx','mfa elite','','','',[],'').    
genotype(891,891,'17R891:L0xxxxxx',891,'17R891:L0xxxxxx','mfa elite','','','',[],'').

















%%%%%%%%% automatically added families for 10R crop; check calculated genotype data! %%%%%%%%%%%%%%
%
% converted fgenotype/11 to genotype/11 manually for now
%
% Kazic, 19.7.2010

% manually checked

genotype(1004,401,'09R401:M0033303',1283,'09R1283:0027504','M14','M14','Mo20W','W23/+/W23/Les19',['Les19'],'K3206').
genotype(2987,1120,'09R1120:0009306',1120,'09R1120:0009306','Mo20W','{+|lls1-N501B}','Mo20W','{+|lls1-N501B}',['lls1-N501B'],'K10502').
genotype(2989,1849,'09R1849:0009206',1849,'09R1849:0009206','M14','{+|lls1-N501B}','M14','{+|lls1-N501B}',['lls1-N501B'],'K10502').
genotype(2990,1849,'09R1849:0009207',1849,'09R1849:0009207','M14','{+|lls1-N501B}','M14','{+|lls1-N501B}',['lls1-N501B'],'K10502').
genotype(2991,1849,'09R1849:0009208',1849,'09R1849:0009208','M14','{+|lls1-N501B}','M14','{+|lls1-N501B}',['lls1-N501B'],'K10502').
genotype(2315,301,'06N301:W0004502',1012,'06N1012:0000208','W23','W23','Mo20W/+','Les2',['Les2'],'K0207').
genotype(2207,201,'09R201:S0041714',2222,'09R2222:0014806','Mo20W','Mo20W','Mo20W','Mo20W/+/Mo20W/Les2',['Les2'],'K0207').
genotype(2995,301,'09R301:W0035911',2294,'09R2294:0014610','W23','W23','W23','Mo20W/+/Les2',['Les2'],'K0203').
genotype(2996,401,'09R401:M0044105',2301,'09R2301:0014711','M14','M14','M14','Mo20W/+/Les2',['Les2'],'K0203').
genotype(2209,201,'09R201:S0042311',1487,'09R1487:0015111','Mo20W','Mo20W','Mo20W','W23/Les2',['Les2'],'K2002').
genotype(2230,401,'09R401:M0044108',2022,'09R2022:0015305','M14','M14','M14','W23/Les2',['Les2'],'K2002').
genotype(2233,401,'09R401:M0042709',2350,'09R2350:0017314','M14','M14','M14','Mo20W/+/Les4',['Les4'],'K0303').
genotype(3000,201,'09R201:S0035502',1278,'09R1278:0016409','Mo20W','Mo20W','W23','Mo20W/Les4',['Les4'],'K0302').
genotype(3001,401,'09R401:M0034607',1278,'09R1278:0016404','M14','M14','W23','Mo20W/Les4',['Les4'],'K0302').
genotype(3002,401,'09R401:M0034902',1278,'09R1278:0016410','M14','M14','W23','Mo20W/Les4',['Les4'],'K0302').
genotype(2135,401,'07R401:M0033910',2328,'07R2328:0040101','M14','M14','M14','(M14/Mo20W)/Les4',['Les4'],'K0302').
genotype(3004,201,'09R201:S0042610',1345,'09R1345:0017809','Mo20W','Mo20W','W23/+','W23/Les4',['Les4'],'K2106').
genotype(2773,301,'06N301:W0005705',1304,'06N1304:0016604','W23','W23','W23','Les4',['Les4'],'K2101').
genotype(2234,401,'09R401:M0045307',2147,'09R2147:0017710','M14','M14','M14','(M14/W23)/Les4',['Les4'],'K2101').
genotype(1108,58,'06R0058:0005812',58,'06R0058:0005804','W23/M14','+','W23/M14','+/Les5-N1449',['Les5-N1449'],'K5804').
genotype(1395,201,'07R201:S0019310',116,'07R0116:0086413','Mo20W','Mo20W','?/Les5','?/Les5',['Les5'],'K11613').
genotype(2236,401,'09R401:M0042407',2106,'09R2106:0018402','M14','M14','M14','(M14/Mo20W)/Les6',['Les6'],'K0403').
genotype(3006,201,'09R201:S0040804',2775,'09R2775:0018515','Mo20W','Mo20W','W23','W23/Les6',['Les6'],'K2202').
genotype(3007,401,'09R401:M0040507',2775,'09R2775:0018502','M14','M14','W23','W23/Les6',['Les6'],'K2202').
genotype(2238,301,'09R301:W0035906',2790,'09R2790:0018908','W23','W23','W23','W23/Les6',['Les6'],'K2212').
genotype(3008,201,'09R201:S0034811',2790,'09R2790:0018902','Mo20W','Mo20W','W23','W23/Les6',['Les6'],'K2212').
genotype(2239,201,'09R201:S0043614',2786,'09R2786:0018608','Mo20W','Mo20W','Mo20W','(M14/W23)/Les6',['Les6'],'K2210').
genotype(3063,301,'09R301:W0041310',1119,'09R1119:0029111','W23','W23','(CM105/Oh43E)/+','((CM105/Oh43E)/+)/Les*-N1378',['Les*-N1378'],'K7408').
genotype(1706,201,'09R201:S0042002',1350,'09R1350:0019303','Mo20W','Mo20W','W23/+','W23/Les7',['Les7'],'K2304').
genotype(3072,401,'09R401:M0042104',1350,'09R1350:0019303','M14','M14','W23/+','W23/Les7',['Les7'],'K2304').
genotype(3073,301,'09R301:W0042811',2793,'09R2793:0019401','W23','W23','W23','(W23/+)/Les7',['Les7'],'K2304').









% corrected per 10R mutant data
%
% Kazic, 24.9.2010
%
% genotype(1003,201,'09R201:S0033102',2719,'09R2719:0007312','Mo20W','Mo20W','Mo20W/+/les23','Mo20W/+/les23',[les23],'K1804').
genotype(1003,201,'09R201:S0033102',2719,'09R2719:0007312','Mo20W','Mo20W','Mo20W/les23','Mo20W/les23',[les23],'K1804').

% corrected per 10R mutant data
%
% Kazic, 24.9.2010
%
% genotype(1008,201,'09R201:S0033106',1368,'09R1368:0007703','Mo20W','Mo20W','W23/+/W23/{+|les23}','W23/+/W23/{+|les23}',[les23],'K3514').
genotype(1008,201,'09R201:S0033106',1368,'09R1368:0007703','Mo20W','Mo20W','W23/les23','W23/les23',[les23],'K3514').
%
% genotype(1009,301,'09R301:W0033208',1368,'09R1368:0007703','W23','W23','W23/+/W23/{+|les23}','W23/+/W23/{+|les23}',[les23],'K3514').
genotype(1009,301,'09R301:W0033208',1368,'09R1368:0007703','W23','W23','W23/les23','W23/les23',[les23],'K3514').
%
genotype(1016,201,'09R201:S0035505',113,'09R0113:0007804','Mo20W','Mo20W','?/?/les23 Slm1','?/?/les23 Slm1',['les23 Slm1'],'K11304').
genotype(1017,301,'09R301:W0035606',113,'09R0113:0007804','W23','W23','?/?/les23 Slm1','?/?/les23 Slm1',['les23 Slm1'],'K11304').
genotype(1019,401,'09R401:M0035701',113,'09R0113:0007804','M14','M14','?/?/les23 Slm1','?/?/les23 Slm1',['les23 Slm1'],'K11304').
genotype(1020,201,'09R201:S0035405',115,'09R0115:0009703','Mo20W','Mo20W','?/csp1/?','?/csp1/?',[csp1],'K11503').
genotype(1021,301,'09R301:W0035310',115,'09R0115:0009703','W23','W23','?/csp1/?','?/csp1/?',[csp1],'K11503').
genotype(1025,401,'09R401:M0033704',115,'09R0115:0009703','M14','M14','?/csp1/?','?/csp1/?',[csp1],'K11503').
genotype(1033,201,'09R201:S0042908',1304,'09R1304:0017512','Mo20W','Mo20W','W23','W23/+/W23/Les4',['Les4'],'K2101').
genotype(1034,301,'09R301:W0042808',1556,'09R1556:0018309','W23','W23','W23','Mo20W/+/Mo20W/Les6',['Les6'],'K0403').
genotype(1035,301,'09R301:W0042810',2427,'09R2427:0019103','W23','W23','W23','Mo20W/Les7',['Les7'],'K0509').
genotype(1038,201,'09R201:S0041103',1348,'09R1348:0019508','Mo20W','Mo20W','W23/+','W23/+/W23/Les7',['Les7'],'K2310').
genotype(1039,201,'09R201:S0043009',1803,'09R1803:0020709','Mo20W','Mo20W','W23','W23/Les7',['Les7'],'K2312').
genotype(1041,401,'09R401:M0045009',1803,'09R1803:0020709','M14','M14','W23','W23/Les7',['Les7'],'K2312').
genotype(1047,301,'09R301:W0040401',1803,'09R1803:0020703','W23','W23','W23','W23/Les7',['Les7'],'K2312').
genotype(1049,201,'09R201:S0042915',2801,'09R2801:0020206','Mo20W','Mo20W','W23','W23/+/Les7',['Les7'],'K2312').
genotype(1275,201,'09R201:S0042317',2799,'09R2799:0020311','Mo20W','Mo20W','W23','W23/+/Les7',['Les7'],'K2312').
genotype(1284,201,'09R201:S0040805',1828,'09R1828:0021410','Mo20W','Mo20W','W23','W23/Les7',['Les7'],'K2312').
genotype(1313,301,'09R301:W0044002',2809,'09R2809:0021903','W23','W23','W23','W23/Les8',['Les8'],'K2405').
genotype(1314,301,'09R301:W0056606',1416,'09R1416:0025906','W23','W23','W23','W23/M14/+/Les15-N2007',['Les15-N2007'],'K6711').
genotype(1321,201,'09R201:S0043609',1259,'09R1259:0031902','Mo20W','Mo20W','Mo20W','W23/+/W23/Les17',['Les17'],'K3007').
genotype(1323,201,'09R201:S0040802',1653,'09R1653:0026902','Mo20W','Mo20W','Mo20W','M14/(M14/W23)/Les19',['Les19'],'K3208').
genotype(1332,201,'09R201:S0032801',1283,'09R1283:0027502','Mo20W','Mo20W','Mo20W','W23/+/W23/Les19',['Les19'],'K3206').
genotype(1335,301,'09R301:W0045205',2927,'09R2927:0028214','W23','W23','W23','W23/Les21',['Les21'],'K3311').
genotype(1522,201,'09R201:S0042602',81,'09R0081:0004914','Mo20W','Mo20W','B73 Ht1/Mo17','+/Les*-N2320',['Les*-N2320'],'K8114').
genotype(1554,301,'09R301:W0051504',81,'09R0081:0004914','W23','W23','B73 Ht1/Mo17','+/Les*-N2320',['Les*-N2320'],'K8114').
genotype(1607,301,'09R301:W0056314',1797,'09R1797:0030003','W23','W23','W23','W23/(W23/((B73/AG32)/Ht1))/(W23/Les*-N2418)',['Les*-N2418'],'K8501').

genotype(1723,401,'09R401:M0047507',1916,'09R1916:0013215','M14','M14','M14','Mo20W/Les1',['Les1'],'K0106').
genotype(1725,301,'09R301:W0041610',2739,'09R2739:0013510','W23','W23','W23','W23/Les1',['Les1'],'K1903').
%
%
% family 2285 is descended from 06N row 3, family 1013, which is Les2 K0202
%
% Kazic, 6.11.2011
%
% genotype(1816,201,'09R201:S0042607',2285,'09R2285:0014109','Mo20W','Mo20W','Mo20W','Mo20W/Mo20W/Les9',['Les9'],'K0709').
%
genotype(1816,201,'09R201:S0042607',2285,'09R2285:0014109','Mo20W','Mo20W','Mo20W','Mo20W/Mo20W/Les2',['Les2'],'K0202').

genotype(2208,201,'09R201:S0043601',1638,'09R1638:0014507','Mo20W','Mo20W','Mo20W','Mo20W/Les2',['Les2'],'K0203').

genotype(2229,301,'09R301:W0044306',1787,'09R1787:0015203','W23','W23','W23','W23/Les2',['Les2'],'K2002').

genotype(2231,201,'09R201:S0042901',1565,'09R1565:0016509','Mo20W','Mo20W','Mo20W','Mo20W/Les4',['Les4'],'K0303').
genotype(2232,301,'09R301:W0041612',2349,'09R2349:0017201','W23','W23','W23','Mo20W/+/Les4',['Les4'],'K0303').


genotype(2235,201,'09R201:S0042304',2380,'09R2380:0018210','Mo20W','Mo20W','Mo20W','Mo20W/Les6',['Les6'],'K0403').

genotype(2237,301,'09R301:W0033206',2775,'09R2775:0018510','W23','W23','W23','W23/+/Les6',['Les6'],'K2202').

genotype(2240,401,'09R401:M0042708',2779,'09R2779:0018802','M14','M14','M14','M14/W23/Les6',['Les6'],'K2210').
genotype(2241,401,'09R401:M0043210',2415,'09R2415:0019201','M14','M14','M14','M14/Mo20W/Les7',['Les7'],'K0509').
genotype(2242,301,'09R301:W0047604',2449,'09R2449:0021603','W23','W23','W23','Mo20W/+/Les8',['Les8'],'K0604').
genotype(2243,401,'09R401:M0041505',2458,'09R2458:0021708','M14','M14','M14','Mo20W/+/Les8',['Les8'],'K0604').
genotype(2244,201,'09R201:S0043605',2498,'09R2498:0022010','Mo20W','Mo20W','Mo20W','Mo20W/Les9',['Les9'],'K0707').
genotype(2245,301,'09R301:W0034712',2499,'09R2499:0022101','W23','W23','W23','Mo20W/Les9',['Les9'],'K0707').
genotype(2246,401,'09R401:M0042111',2501,'09R2501:0022206','M14','M14','M14','Mo20W/Les9',['Les9'],'K0707').
genotype(2247,301,'09R301:W0043701',2811,'09R2811:0022401','W23','W23','W23','W23/Les9',['Les9'],'K2506').
genotype(2248,301,'09R301:W0043403',1569,'09R1569:0022606','W23','W23','W23','Mo20W/+/Mo20W/Les10',['Les10'],'K0801').
genotype(2249,301,'09R301:W0043407',1774,'09R1774:0022804','W23','W23','W23','W23/Les10',['Les10'],'K2606').
genotype(2250,301,'09R301:W0040405',2511,'09R2511:0023007','W23','W23','W23','Mo20W/+/Les11',['Les11'],'K0901').
genotype(2251,201,'09R201:S0056212',1416,'09R1416:0025906','Mo20W','Mo20W','W23','W23/M14/+/Les15-N2007',['Les15-N2007'],'K6711').
genotype(2252,201,'09R201:S0056209',1416,'09R1416:0025907','Mo20W','Mo20W','W23','W23/M14/+/Les15-N2007',['Les15-N2007'],'K6711').
genotype(2253,301,'09R301:W0052102',1416,'09R1416:0025907','W23','W23','W23','W23/M14/+/Les15-N2007',['Les15-N2007'],'K6711').
genotype(2254,401,'09R401:M0040909',1416,'09R1416:0025906','M14','M14','W23','W23/M14/+/Les15-N2007',['Les15-N2007'],'K6711').
genotype(2255,401,'09R401:M0057004',1416,'09R1416:0025907','M14','M14','W23','W23/M14/+/Les15-N2007',['Les15-N2007'],'K6711').
genotype(2256,301,'09R301:W0040409',2578,'09R2578:0026102','W23','W23','W23','Mo20W/+/Les17',['Les17'],'K1309').
genotype(2257,301,'09R301:W0040413',1818,'09R1818:0026314','W23','W23','W23','W23/W23/Les17',['Les17'],'K3007').
genotype(2258,301,'09R301:W0041908',2897,'09R2897:0026803','W23','W23','W23','W23/Les18',['Les18'],'K3106').
genotype(2259,301,'09R301:W0041912',2626,'09R2626:0027003','W23','W23','W23','Mo20W/+/Les19',['Les19'],'K1501').
genotype(2260,301,'09R301:W0042502',2905,'09R2905:0027601','W23','W23','W23','W23/Les19',['Les19'],'K3206').
genotype(2261,301,'09R301:W0045507',2958,'09R2958:0029704','W23','W23','W23','W23/{+|Les*-N2397}/{+|Les*-N2397}',['Les*-N2397'],'K8414').
genotype(2262,401,'09R401:M0045404',1826,'09R1826:0029806','M14','M14','M14','{+|Les*-N2397}',['Les*-N2397'],'K8414').
genotype(2263,201,'09R201:S0040806',1472,'09R1472:0029901','Mo20W','Mo20W','Mo20W','Mo20W/(W23/((B73/AG32)/Ht1))/Mo20W/(W23/Les*-N2418)',['Les*-N2418'],'K8501').
genotype(2264,401,'09R401:M0045406',2092,'09R2092:0030112','M14','M14','M14','M14/(W23/((B73/AG32)/Ht1))/(W23/Les*-N2418)',['Les*-N2418'],'K8501').
genotype(2265,1413,'09R1413:0008001',1413,'09R1413:0008001','Mo20W','Mo20W/lls1','Mo20W','Mo20W/lls1',[lls1],'K1702').
genotype(2266,1413,'09R1413:0008003',1413,'09R1413:0008003','Mo20W','Mo20W/lls1','Mo20W','Mo20W/lls1',[lls1],'K1702').
genotype(2267,1413,'09R1413:0008005',1413,'09R1413:0008005','Mo20W','Mo20W/lls1','Mo20W','Mo20W/lls1',[lls1],'K1702').
genotype(2268,1413,'09R1413:0008013',1413,'09R1413:0008013','Mo20W','Mo20W/lls1','Mo20W','Mo20W/lls1',[lls1],'K1702').
genotype(2269,1993,'09R1993:0008103',1993,'09R1993:0008103','M14','Mo20W/lls1','M14','Mo20W/lls1',[lls1],'K1702').
genotype(2981,1993,'09R1993:0008105',1993,'09R1993:0008105','M14','Mo20W/lls1','M14','Mo20W/lls1',[lls1],'K1702').
genotype(2982,1993,'09R1993:0008108',1993,'09R1993:0008108','M14','Mo20W/lls1','M14','Mo20W/lls1',[lls1],'K1702').
genotype(2983,1993,'09R1993:0008109',1993,'09R1993:0008109','M14','Mo20W/lls1','M14','Mo20W/lls1',[lls1],'K1702').
genotype(2984,1120,'09R1120:0009301',1120,'09R1120:0009301','Mo20W/Mo20W/+','{+|lls1-N501B}','Mo20W/Mo20W/+','{+|lls1-N501B}',['lls1-N501B'],'K10502').
genotype(2985,1120,'09R1120:0009302',1120,'09R1120:0009302','Mo20W/Mo20W/+','{+|lls1-N501B}','Mo20W/Mo20W/+','{+|lls1-N501B}',['lls1-N501B'],'K10502').
genotype(2986,1120,'09R1120:0009305',1120,'09R1120:0009305','Mo20W/Mo20W/+','{+|lls1-N501B}','Mo20W/Mo20W/+','{+|lls1-N501B}',['lls1-N501B'],'K10502').

genotype(2988,1849,'09R1849:0009203',1849,'09R1849:0009203','M14','{+|lls1-N501B}','M14','{+|lls1-N501B}',['lls1-N501B'],'K10502').



genotype(2992,301,'06N301:W0011107',1011,'06N1011:0000111','W23','W23','Mo20W','Mo20W/+/Mo20W/Les4',['Les4'],'K0304').
genotype(2993,201,'09R201:S0041410',1301,'09R1301:0013403','Mo20W','Mo20W','W23','W23/+/W23/Les1',['Les1'],'K1903').
genotype(2994,200,'06R200:S00I0104',55,'06R0055:0005515','Mo20W','Mo20W','Les2-N845A/+','M14/W23',['Les2-N845A'],'K5515').
genotype(2997,201,'09R201:S0041701',119,'09R0119:0015401','Mo20W','Mo20W','+','?/?/Les3-GJ',['Les3-GJ'],'K11901').
genotype(2998,301,'09R301:W0041605',119,'09R0119:0015401','W23','W23','+','?/?/Les3-GJ',['Les3-GJ'],'K11901').
genotype(2999,401,'09R401:M0041801',119,'09R0119:0015401','M14','M14','+','?/?/Les3-GJ',['Les3-GJ'],'K11901').

genotype(3003,201,'06N201:S0004106',1603,'06N1603:0020008','Mo20W','Mo20W','M14','Mo20W/+/Mo20W/Les4',['Les4'],'K0302').

genotype(3005,401,'09R401:M0033308',2790,'09R2790:0018908','M14','M14','W23','W23/+/Les6',['Les6'],'K2212').


genotype(3009,401,'09R401:M0040603',1348,'09R1348:0019508','M14','M14','W23/+','W23/+/W23/Les7',['Les7'],'K2310').
genotype(3010,201,'09R201:S0042904',2798,'09R2798:0020108','Mo20W','Mo20W','W23','W23/+/Les7',['Les7'],'K2312').
genotype(3011,301,'09R301:W0043101',2798,'09R2798:0020108','W23','W23','W23','W23/+/Les7',['Les7'],'K2312').
genotype(3012,401,'09R401:M0045001',2798,'09R2798:0020108','M14','M14','W23','W23/+/Les7',['Les7'],'K2312').
genotype(3013,201,'09R201:S0043004',1707,'09R1707:0020612','Mo20W','Mo20W','W23','W23/Les7',['Les7'],'K2312').
genotype(3014,301,'09R301:W0043113',1707,'09R1707:0020612','W23','W23','W23','W23/Les7',['Les7'],'K2312').
genotype(3015,401,'09R401:M0045008',1707,'09R1707:0020612','M14','M14','W23','W23/Les7',['Les7'],'K2312').
genotype(3016,301,'09R301:W0043709',1707,'09R1707:0020611','W23','W23','W23','W23/Les7',['Les7'],'K2312').
genotype(3017,301,'09R301:W0048513',1707,'09R1707:0020610','W23','W23','W23','W23/Les7',['Les7'],'K2312').
genotype(3018,301,'09R301:W0042507',1707,'09R1707:0020604','W23','W23','W23','W23/Les7',['Les7'],'K2312').
genotype(3019,301,'09R301:W0042512',1707,'09R1707:0020601','W23','W23','W23','W23/Les7',['Les7'],'K2312').
genotype(3020,201,'09R201:S0042312',2800,'09R2800:0020010','Mo20W','Mo20W','W23','W23/+/Les7',['Les7'],'K2312').
genotype(3021,301,'09R301:W0042805',2800,'09R2800:0020010','W23','W23','W23','W23/+/Les7',['Les7'],'K2312').
genotype(3022,401,'09R401:M0044708',2800,'09R2800:0020010','M14','M14','W23','W23/+/Les7',['Les7'],'K2312').
genotype(3023,301,'09R301:W0040701',2800,'09R2800:0020007','W23','W23','W23','W23/+/Les7',['Les7'],'K2312').
genotype(3024,301,'09R301:W0043114',1803,'09R1803:0020709','W23','W23','W23','W23/Les7',['Les7'],'K2312').
genotype(3025,301,'09R301:W0040712',1803,'09R1803:0020701','W23','W23','W23','W23/Les7',['Les7'],'K2312').
genotype(3026,301,'09R301:W0048204',1803,'09R1803:0020701','W23','W23','W23','W23/Les7',['Les7'],'K2312').
genotype(3027,301,'09R301:W0043107',2801,'09R2801:0020206','W23','W23','W23','W23/+/Les7',['Les7'],'K2312').
genotype(3028,401,'09R401:M0045003',2801,'09R2801:0020206','M14','M14','W23','W23/+/Les7',['Les7'],'K2312').
genotype(3029,301,'09R301:W0048505',2801,'09R2801:0020213','W23','W23','W23','W23/+/Les7',['Les7'],'K2312').
genotype(3030,201,'09R201:S0043003',1676,'09R1676:0020409','Mo20W','Mo20W','W23','W23/Les7',['Les7'],'K2312').
genotype(3031,301,'09R301:W0043112',1676,'09R1676:0020409','W23','W23','W23','W23/Les7',['Les7'],'K2312').
genotype(3032,401,'09R401:M0045007',1676,'09R1676:0020409','M14','M14','W23','W23/Les7',['Les7'],'K2312').
genotype(3033,301,'09R301:W0040703',1676,'09R1676:0020412','W23','W23','W23','W23/Les7',['Les7'],'K2312').
genotype(3034,301,'09R301:W0040707',1676,'09R1676:0020414','W23','W23','W23','W23/Les7',['Les7'],'K2312').
genotype(3035,301,'09R301:W0043104',2799,'09R2799:0020311','W23','W23','W23','W23/+/Les7',['Les7'],'K2312').
genotype(3036,401,'09R401:M0045002',2799,'09R2799:0020311','M14','M14','W23','W23/+/Les7',['Les7'],'K2312').
genotype(3037,301,'09R301:W0056311',1692,'09R1692:0020507','W23','W23','W23','W23/Les7',['Les7'],'K2312').
genotype(3038,301,'09R301:W0042506',1692,'09R1692:0020503','W23','W23','W23','W23/Les7',['Les7'],'K2312').
genotype(3039,301,'09R301:W0048507',1692,'09R1692:0020504','W23','W23','W23','W23/Les7',['Les7'],'K2312').
genotype(3040,301,'09R301:W0041012',1828,'09R1828:0021410','W23','W23','W23','W23/Les7',['Les7'],'K2312').
genotype(3041,401,'09R401:M0041204',1828,'09R1828:0021410','M14','M14','W23','W23/Les7',['Les7'],'K2312').
genotype(3042,201,'09R201:S0043010',1828,'09R1828:0021402','Mo20W','Mo20W','W23','W23/Les7',['Les7'],'K2312').
genotype(3043,301,'09R301:W0043401',1828,'09R1828:0021402','W23','W23','W23','W23/Les7',['Les7'],'K2312').
genotype(3044,401,'09R401:M0045010',1828,'09R1828:0021402','M14','M14','W23','W23/Les7',['Les7'],'K2312').
genotype(3045,301,'09R301:W0040404',1828,'09R1828:0021408','W23','W23','W23','W23/Les7',['Les7'],'K2312').
genotype(3046,201,'09R201:S0032814',1349,'09R1349:0019903','Mo20W','Mo20W','W23/+','W23/+/W23/Les7',['Les7'],'K2312').
genotype(3047,201,'09R201:S0042009',1317,'09R1317:0022302','Mo20W','Mo20W','W23','W23/+/W23/Les9',['Les9'],'K2506').
genotype(3048,201,'09R201:S0042014',1024,'09R1024:0022515','Mo20W','Mo20W','Mo20W/+','Mo20W/+/Mo20W/Les10',['Les10'],'K0801').
genotype(3049,301,'09R301:W0045203',1040,'09R1040:0026509','W23','W23','Mo20W/+','Mo20W/+/Mo20W/Les18',['Les18'],'K1411').
genotype(3050,401,'09R401:M0045301',1040,'09R1040:0026510','M14','M14','Mo20W/+','Mo20W/+/Mo20W/Les18',['Les18'],'K1411').
genotype(3051,401,'09R401:M0040503',1329,'09R1329:0026705','M14','M14','W23','W23/+/W23/Les18',['Les18'],'K3106').
genotype(3052,301,'09R301:W0042202',2650,'09R2650:0027307','W23','W23','W23','Mo20W/+/Les19',['Les19'],'K1506').
genotype(3053,301,'09R301:W0043102',2930,'09R2930:0027805','W23','W23','W23','M14/(W23/L317)/+/Les20-N2457',['Les20-N2457'],'K7110').
genotype(3054,201,'09R201:S0040807',118,'09R0118:0028602','Mo20W','Mo20W','I-54/?/?/Les101','Va35',['Les101'],'K11802').
genotype(3055,301,'09R301:W0041001',118,'09R0118:0028602','W23','W23','I-54/?/?/Les101','Va35',['Les101'],'K11802').
genotype(3056,401,'09R401:M0041207',118,'09R0118:0028602','M14','M14','I-54/?/?/Les101','Va35',['Les101'],'K11802').
genotype(3057,201,'09R201:S0040811',74,'09R0074:0029003','Mo20W','Mo20W','CM105/Oh43E','+/Les*-N1378',['Les*-N1378'],'K7403').
genotype(3058,301,'09R301:W0041007',74,'09R0074:0029003','W23','W23','CM105/Oh43E','+/Les*-N1378',['Les*-N1378'],'K7403').
genotype(3059,401,'09R401:M0043201',74,'09R0074:0029003','M14','M14','CM105/Oh43E','+/Les*-N1378',['Les*-N1378'],'K7403').
genotype(3060,401,'09R401:M0042403',81,'09R0081:0004914','M14','M14','B73 Ht1/Mo17','+/Les*-N2320',['Les*-N2320'],'K8114').
genotype(3061,201,'09R201:S0056206',84,'09R0084:0029510','Mo20W','Mo20W','+/Les*-N2397','+/Les*-N2397',['Les*-N2397'],'K8410').
genotype(3062,201,'09R201:S0041407',139,'09R0139:0030202','Mo20W','Mo20W','B73/Mo17','+/Les*-N2420',['Les*-N2420'],'K13902').

genotype(3064,401,'09R401:M0043807',139,'09R0139:0030202','M14','M14','B73/Mo17','+/Les*-N2420',['Les*-N2420'],'K13902').
genotype(3065,201,'09R201:S0056207',1135,'09R1135:0030502','Mo20W','Mo20W','Mo20W','B73 Ht1/Mo17/+/Les*-NA7145',['Les*-NA7145'],'K9113').
genotype(3066,301,'09R301:W0052106',1135,'09R1135:0030502','W23','W23','Mo20W','B73 Ht1/Mo17/+/Les*-NA7145',['Les*-NA7145'],'K9113').
genotype(3067,401,'09R401:M0052303',1135,'09R1135:0030502','M14','M14','Mo20W','B73 Ht1/Mo17/+/Les*-NA7145',['Les*-NA7145'],'K9113').
genotype(3068,201,'09R201:S0041102',122,'09R0122:0009505','Mo20W','Mo20W',mop1,'+/Les*-mi1',['Les*-mi1'],'K12205').
genotype(3069,301,'09R301:W0041301',122,'09R0122:0009505','W23','W23',mop1,'+/Les*-mi1',['Les*-mi1'],'K12205').
genotype(3070,401,'09R401:M0041202',122,'09R0122:0009505','M14','M14',mop1,'+/Les*-mi1',['Les*-mi1'],'K12205').
genotype(3071,401,'09R401:M0033301',1349,'09R1349:0019903','M14','M14','W23/+','W23/+/W23/Les7',['Les7'],'K2312').


genotype(3074,201,'09R201:S0044506',76,'09R0076:0001406','Mo20W','Mo20W','+/Les*-N1450','+/Les*-N1450',['Les*-N1450'],'K7606').
genotype(3075,301,'09R301:W0056910',76,'09R0076:0001406','W23','W23','+/Les*-N1450','+/Les*-N1450',['Les*-N1450'],'K7606').
genotype(3076,401,'09R401:M0050106',76,'09R0076:0001406','M14','M14','+/Les*-N1450','+/Les*-N1450',['Les*-N1450'],'K7606').
genotype(3077,201,'09R201:S0051606',138,'09R0138:0013009','Mo20W','Mo20W','B73','camo/+',[camo],'K13009').
genotype(3078,301,'09R301:W0051508',138,'09R0138:0013009','W23','W23','B73','camo/+',[camo],'K13009').
genotype(3079,201,'09R201:S0044504',77,'09R0077:0002902','Mo20W','Mo20W','+','les*-N2012',['les*-N2012'],'K7702').
genotype(3080,301,'09R301:W0056907',77,'09R0077:0002902','W23','W23','+','les*-N2012',['les*-N2012'],'K7702').
genotype(3081,401,'09R401:M0043207',77,'09R0077:0002902','M14','M14','+','les*-N2012',['les*-N2012'],'K7702').



% new families from 10R offspring; manually added to use track/5 predicate
%
% Kazic, 25.12.2010

% regularized
% Kazic, 3.11.2011
%
% genotype(3082,205,'10R205:S0010004',120,'10R0120:0035408','Mo20W','Mo20W','I-52/Les-102','Va35',['Les102'],'K12008').
% genotype(3083,305,'10R305:W0011107',120,'10R0120:0035408','W23','W23','I-52/Les-102','Va35',['Les102'],'K12008').     
% genotype(3084,205,'10R205:S0010011',120,'10R0120:0035411','Mo20W','Mo20W','I-52/Les-102','Va35',['Les102'],'K12011'). 
% genotype(3085,305,'10R305:W0011101',120,'10R0120:0035411','W23','W23','I-52/Les-102','Va35',['Les102'],'K12011').

genotype(3082,205,'10R205:S0010004',120,'10R0120:0035408','Mo20W','Mo20W','I-52/Les102','Va35',['Les102'],'K12008').
genotype(3083,305,'10R305:W0011107',120,'10R0120:0035408','W23','W23','I-52/Les102','Va35',['Les102'],'K12008').     
genotype(3084,205,'10R205:S0010011',120,'10R0120:0035411','Mo20W','Mo20W','I-52/Les102','Va35',['Les102'],'K12011'). 
genotype(3085,305,'10R305:W0011101',120,'10R0120:0035411','W23','W23','I-52/Les102','Va35',['Les102'],'K12011').     





genotype(3086,205,'10R205:S0001101',3054,'10R3054:0035110','Mo20W','Mo20W','I54/Les101','Va35',['Les101'],'K11802').
genotype(3087,305,'10R305:W0010501',3055,'10R3055:0035206','W23','W23','I54/Les101','Va35',['Les101'],'K11802').
genotype(3088,405,'10R405:M0008108',3056,'10R3056:0035304','M14','M14','I54/Les101','Va35',['Les101'],'K11802').

genotype(3089,201,'09R201:S0041708',137,'09R0137:0031108','Mo20W','Mo20W','+','les*-PI262474',['les*-PI262474'],'K13708').
genotype(3090,301,'09R301:W0041606',137,'09R0137:0031108','W23','W23','+','les*-PI262474',['les*-PI262474'],'K13708').
genotype(3091,401,'09R401:M0044404',137,'09R0137:0031108','M14','M14','+','les*-PI262474',['les*-PI262474'],'K13708').

genotype(3092,201,'09R201:S0041703',137,'09R0137:0031114','Mo20W','Mo20W','+','les*-PI262474',['les*-PI262474'],'K13714').
genotype(3093,301,'09R301:W0041604',137,'09R0137:0031114','W23','W23','+','les*-PI262474',['les*-PI262474'],'K13714').
genotype(3094,401,'09R401:M0044403',137,'09R0137:0031114','M14','M14','+','les*-PI262474',['les*-PI262474'],'K13714').

genotype(3095,301,'09R301:W0057201',149,'09R0149:0055406','W23','W23','B73 Ht1/Mo17','les*-74-1820-6',['les*-74-1820-6'],'K14906').

genotype(3096,305,'10R305:W0011109',174,'10R0174:0038904','W23','W23','?','les*-tilling1',['les*-tilling1'],'K17404').
genotype(3097,405,'10R405:M0007510',174,'10R0174:0038904','M14','M14','?','les*-tilling1',['les*-tilling1'],'K17404').

genotype(3098,205,'10R205:S0010608',173,'10R0173:0035807','Mo20W','Mo20W','LesLA','+',['LesLA'],'K17307').
genotype(3099,305,'10R305:W0010911',173,'10R0173:0035807','W23','W23','LesLA','+',['LesLA'],'K17307').
genotype(3100,405,'10R405:M0007814',173,'10R0173:0035807','M14','M14','LesLA','+',['LesLA'],'K17307').

genotype(3101,201,'09R201:S0042303',80,'09R0080:0004802','Mo20W','Mo20W','Mo20W','les*-N2290A',['les*-N2290A'],'K8002').
genotype(3102,301,'09R301:W0056306',80,'09R0080:0004802','W23','W23','Mo20W','les*-N2290A',['les*-N2290A'],'K8002').
genotype(3103,401,'09R401:M0043205',80,'09R0080:0004802','M14','M14','Mo20W','les*-N2290A',['les*-N2290A'],'K8002').

genotype(3104,95,'09R0095:0001102',95,'09R0095:0001102','B73 Ht1','{+|les*-ats}','B73 Ht1','{+|les*-ats}',['les*-ats'],'K9502').
genotype(3105,95,'09R0095:0001103',95,'09R0095:0001103','B73 Ht1','{+|les*-ats}','B73 Ht1','{+|les*-ats}',['les*-ats'],'K9503').
genotype(3106,95,'09R0095:0001104',95,'09R0095:0001104','B73 Ht1','{+|les*-ats}','B73 Ht1','{+|les*-ats}',['les*-ats'],'K9544').
genotype(3107,95,'09R0095:0001109',95,'09R0095:0001109','B73 Ht1','{+|les*-ats}','B73 Ht1','{+|les*-ats}',['les*-ats'],'K9509').
genotype(3108,95,'09R0095:0001110',95,'09R0095:0001110','B73 Ht1','{+|les*-ats}','B73 Ht1','{+|les*-ats}',['les*-ats'],'K9510').





% additional lines for 11r
%
% Kazic, 19.7.2011

genotype(3109,82,'09R0082:0005004',82,'09R0082:0005004','(B73/AG32)/(Ht1/les*-N2333A)','(B73/AG32)/(Ht1/les*-N2333A)','(B73/AG32)/(Ht1/les*-N2333A)','(B73/AG32)/(Ht1/les*-N2333A)',['les*-N2333A'],'K8204').
genotype(3110,82,'09R0082:0005010',82,'09R0082:0005010','(B73/AG32)/(Ht1/les*-N2333A)','(B73/AG32)/(Ht1/les*-N2333A)','(B73/AG32)/(Ht1/les*-N2333A)','(B73/AG32)/(Ht1/les*-N2333A)',['les*-N2333A'],'K8210').
genotype(3111,96,'09R0096:0009601',96,'09R0096:0009601','+/cpc1-N2284B','+/cpc1-N2284B','+/cpc1-N2284B','+/cpc1-N2284B',['cpc1-N2284B'],'K9601').
genotype(3112,96,'09R0096:0009604',96,'09R0096:0009604','+/cpc1-N2284B','+/cpc1-N2284B','+/cpc1-N2284B','+/cpc1-N2284B',['cpc1-N2284B'],'K9604').
genotype(3113,96,'09R0096:0009606',96,'09R0096:0009606','+/cpc1-N2284B','+/cpc1-N2284B','+/cpc1-N2284B','+/cpc1-N2284B',['cpc1-N2284B'],'K9606').
genotype(3114,1057,'09R1057:0006401',1057,'09R1057:0006401','Mo20W/+','Mo20W/les23','Mo20W/+','Mo20W/les23',[les23],'K1802').
genotype(3115,1057,'09R1057:0006405',1057,'09R1057:0006405','Mo20W/+','Mo20W/les23','Mo20W/+','Mo20W/les23',[les23],'K1802').
genotype(3116,1130,'09R1130:0001201',1130,'09R1130:0001201','Mo20W/les*-N1395C','Mo20W/les*-N1395C','Mo20W/les*-N1395C','Mo20W/les*-N1395C',['les*-N1395C'],'K7501').
genotype(3117,1130,'09R1130:0001205',1130,'09R1130:0001205','Mo20W/les*-N1395C','Mo20W/les*-N1395C','Mo20W/les*-N1395C','Mo20W/les*-N1395C',['les*-N1395C'],'K7501').
genotype(3118,1130,'09R1130:0001214',1130,'09R1130:0001214','Mo20W/les*-N1395C','Mo20W/les*-N1395C','Mo20W/les*-N1395C','Mo20W/les*-N1395C',['les*-N1395C'],'K7501').
genotype(3119,1133,'09R1133:0006201',1133,'09R1133:0006201','Mo20W/les*-NA467','Mo20W/les*-NA467','Mo20W/les*-NA467','Mo20W/les*-NA467',['les*-NA467'],'K9001').
genotype(3120,1133,'09R1133:0006204',1133,'09R1133:0006204','Mo20W/les*-NA467','Mo20W/les*-NA467','Mo20W/les*-NA467','Mo20W/les*-NA467',['les*-NA467'],'K9001').
genotype(3121,1133,'09R1133:0006206',1133,'09R1133:0006206','Mo20W/les*-NA467','Mo20W/les*-NA467','Mo20W/les*-NA467','Mo20W/les*-NA467',['les*-NA467'],'K9001').
genotype(3122,1134,'09R1134:0006301',1134,'09R1134:0006301','Mo20W/les*-NA467','Mo20W/les*-NA467','Mo20W/les*-NA467','Mo20W/les*-NA467',['les*-NA467'],'K9006').
genotype(3123,1134,'09R1134:0006304',1134,'09R1134:0006304','Mo20W/les*-NA467','Mo20W/les*-NA467','Mo20W/les*-NA467','Mo20W/les*-NA467',['les*-NA467'],'K9006').
genotype(3124,1134,'09R1134:0006312',1134,'09R1134:0006312','Mo20W/les*-NA467','Mo20W/les*-NA467','Mo20W/les*-NA467','Mo20W/les*-NA467',['les*-NA467'],'K9006').
genotype(3125,1202,'09R1202:0009802',1202,'09R1202:0009802','Mo20W/{+|lep*-8691}','Mo20W/{+|lep*-8691}','Mo20W/{+|lep*-8691}','Mo20W/{+|lep*-8691}',['lep*-8691'],'K10405').
genotype(3126,1202,'09R1202:0009803',1202,'09R1202:0009803','Mo20W/{+|lep*-8691}','Mo20W/{+|lep*-8691}','Mo20W/{+|lep*-8691}','Mo20W/{+|lep*-8691}',['lep*-8691'],'K10405').
genotype(3127,1202,'09R1202:0009804',1202,'09R1202:0009804','Mo20W/{+|lep*-8691}','Mo20W/{+|lep*-8691}','Mo20W/{+|lep*-8691}','Mo20W/{+|lep*-8691}',['lep*-8691'],'K10405').
genotype(3128,1207,'09R1207:0010909',1207,'09R1207:0010909','Mo20W/{+|nec*-6853}','Mo20W/{+|nec*-6853}','Mo20W/{+|nec*-6853}','Mo20W/{+|nec*-6853}',['nec*-6853'],'K10712').
genotype(3129,1207,'09R1207:0010910',1207,'09R1207:0010910','Mo20W/{+|nec*-6853}','Mo20W/{+|nec*-6853}','Mo20W/{+|nec*-6853}','Mo20W/{+|nec*-6853}',['nec*-6853'],'K10712').
genotype(3130,1207,'09R1207:0010914',1207,'09R1207:0010914','Mo20W/{+|nec*-6853}','Mo20W/{+|nec*-6853}','Mo20W/{+|nec*-6853}','Mo20W/{+|nec*-6853}',['nec*-6853'],'K10712').
genotype(3131,1442,'09R1442:0005101',1442,'09R1442:0005101','W23/{(B73/AG32)|(Ht1/les*-N2333A)}','W23/{(B73/AG32)|(Ht1/les*-N2333A)}','W23/{(B73/AG32)|(Ht1/les*-N2333A)}','W23/{(B73/AG32)|(Ht1/les*-N2333A)}',['les*-N2333A'],'K8203').
genotype(3132,1442,'09R1442:0005106',1442,'09R1442:0005106','W23/{(B73/AG32)|(Ht1/les*-N2333A)}','W23/{(B73/AG32)|(Ht1/les*-N2333A)}','W23/{(B73/AG32)|(Ht1/les*-N2333A)}','W23/{(B73/AG32)|(Ht1/les*-N2333A)}',['les*-N2333A'],'K8203').
genotype(3133,1442,'09R1442:0005109',1442,'09R1442:0005109','W23/{(B73/AG32)|(Ht1/les*-N2333A)}','W23/{(B73/AG32)|(Ht1/les*-N2333A)}','W23/{(B73/AG32)|(Ht1/les*-N2333A)}','W23/{(B73/AG32)|(Ht1/les*-N2333A)}',['les*-N2333A'],'K8203').
genotype(3134,1445,'09R1445:0005701',1445,'09R1445:0005701','W23/les*-N2502','W23/les*-N2502','W23/les*-N2502','W23/les*-N2502',['les*-N2502'],'K8709').
genotype(3135,1445,'09R1445:0005704',1445,'09R1445:0005704','W23/les*-N2502','W23/les*-N2502','W23/les*-N2502','W23/les*-N2502',['les*-N2502'],'K8709').
genotype(3136,1445,'09R1445:0005701',1445,'09R1445:0005701','W23/les*-N2502','W23/les*-N2502','W23/les*-N2502','W23/les*-N2502',['les*-N2502'],'K8709').
genotype(3137,1511,'09R1511:0009902',1511,'09R1511:0009902','W23/{+|lep*-8691}','W23/{+|lep*-8691}','W23/{+|lep*-8691}','W23/{+|lep*-8691}',['lep*-8691'],'K10405').
genotype(3138,1511,'09R1511:0009904',1511,'09R1511:0009904','W23/{+|lep*-8691}','W23/{+|lep*-8691}','W23/{+|lep*-8691}','W23/{+|lep*-8691}',['lep*-8691'],'K10405').
genotype(3139,1511,'09R1511:0009905',1511,'09R1511:0009905','W23/{+|lep*-8691}','W23/{+|lep*-8691}','W23/{+|lep*-8691}','W23/{+|lep*-8691}',['lep*-8691'],'K10405').
genotype(3140,1514,'09R1514:0011001',1514,'09R1514:0011001','W23/{+|nec*-6853}','W23/{+|nec*-6853}','W23/{+|nec*-6853}','W23/{+|nec*-6853}',['nec*-6853'],'K10712').
genotype(3141,1514,'09R1514:0011002',1514,'09R1514:0011002','W23/{+|nec*-6853}','W23/{+|nec*-6853}','W23/{+|nec*-6853}','W23/{+|nec*-6853}',['nec*-6853'],'K10712').
genotype(3142,1514,'09R1514:0011003',1514,'09R1514:0011003','W23/{+|nec*-6853}','W23/{+|nec*-6853}','W23/{+|nec*-6853}','W23/{+|nec*-6853}',['nec*-6853'],'K10712').
genotype(3143,1829,'09R1829:0001301',1829,'09R1829:0001301','M14/les*-N1395C','M14/les*-N1395C','M14/les*-N1395C','M14/les*-N1395C',['les*-N1395C'],'K7501').
genotype(3144,1829,'09R1829:0001306',1829,'09R1829:0001306','M14/les*-N1395C','M14/les*-N1395C','M14/les*-N1395C','M14/les*-N1395C',['les*-N1395C'],'K7501').
genotype(3145,1829,'09R1829:0001314',1829,'09R1829:0001314','M14/les*-N1395C','M14/les*-N1395C','M14/les*-N1395C','M14/les*-N1395C',['les*-N1395C'],'K7501').
genotype(3146,1837,'09R1837:0005501',1837,'09R1837:0005501','M14/{+|les*-N2363A}','M14/{+|les*-N2363A}','M14/{+|les*-N2363A}','M14/{+|les*-N2363A}',['les*-N2363A'],'K8304').
genotype(3147,1837,'09R1837:0005504',1837,'09R1837:0005504','M14/{+|les*-N2363A}','M14/{+|les*-N2363A}','M14/{+|les*-N2363A}','M14/{+|les*-N2363A}',['les*-N2363A'],'K8304').
genotype(3148,1837,'09R1837:0005514',1837,'09R1837:0005514','M14/{+|les*-N2363A}','M14/{+|les*-N2363A}','M14/{+|les*-N2363A}','M14/{+|les*-N2363A}',['les*-N2363A'],'K8304').
genotype(3149,1845,'09R1845:0012001',1845,'09R1845:0012001','M14/{(W23/L317)|les*-2119}','M14/{(W23/L317)|les*-2119}','M14/{(W23/L317)|les*-2119}','M14/{(W23/L317)|les*-2119}',['les*-2119'],'K9207').
genotype(3150,1913,'09R1913:0010001',1913,'09R1913:0010001','M14/{+|lep*-8691}','M14/{+|lep*-8691}','M14/{+|lep*-8691}','M14/{+|lep*-8691}',['lep*-8691'],'K10405').
genotype(3151,1913,'09R1913:0010002',1913,'09R1913:0010002','M14/{+|lep*-8691}','M14/{+|lep*-8691}','M14/{+|lep*-8691}','M14/{+|lep*-8691}',['lep*-8691'],'K10405').
genotype(3152,1913,'09R1913:0010009',1913,'09R1913:0010009','M14/{+|lep*-8691}','M14/{+|lep*-8691}','M14/{+|lep*-8691}','M14/{+|lep*-8691}',['lep*-8691'],'K10405').
genotype(3153,1003,'10R1003:0011404',1003,'10R1003:0011404','Mo20W/les23','Mo20W/les23','Mo20W/les23','Mo20W/les23',['les23'],'K1804').
genotype(3154,1008,'10R1008:0011702',1008,'10R1008:0011702','Mo20W/(W23/les23)','Mo20W/(W23/les23)','Mo20W/(W23/les23)','Mo20W/(W23/les23)',['les23'],'K3514').
genotype(3155,1008,'10R1008:0011707',1008,'10R1008:0011707','Mo20W/(W23/les23)','Mo20W/(W23/les23)','Mo20W/(W23/les23)','Mo20W/(W23/les23)',['les23'],'K3514').
genotype(3156,1008,'10R1008:0011709',1008,'10R1008:0011709','Mo20W/(W23/les23)','Mo20W/(W23/les23)','Mo20W/(W23/les23)','Mo20W/(W23/les23)',['les23'],'K3514').
genotype(3157,1009,'10R1009:0011802',1009,'10R1009:0011802','W23/les23','W23/les23','W23/les23','W23/les23',['les23'],'K3514').
genotype(3158,1009,'10R1009:0011807',1009,'10R1009:0011807','W23/les23','W23/les23','W23/les23','W23/les23',['les23'],'K3514').
genotype(3159,1016,'10R1016:0012001',1016,'10R1016:0012001','Mo20W/(?/les23 Slm1)','Mo20W/(?/les23 Slm1)','Mo20W/(?/les23 Slm1)','Mo20W/(?/les23 Slm1)',['les23 Slm1'],'K11304').
genotype(3160,1016,'10R1016:0012005',1016,'10R1016:0012005','Mo20W/(?/les23 Slm1)','Mo20W/(?/les23 Slm1)','Mo20W/(?/les23 Slm1)','Mo20W/(?/les23 Slm1)',['les23 Slm1'],'K11304').
genotype(3161,1017,'10R1017:0012101',1017,'10R1017:0012101','W23/(?/les23 Slm1)','W23/(?/les23 Slm1)','W23/(?/les23 Slm1)','W23/(?/les23 Slm1)',['les23 Slm1'],'K11304').
genotype(3162,1017,'10R1017:0012113',1017,'10R1017:0012113','W23/(?/les23 Slm1)','W23/(?/les23 Slm1)','W23/(?/les23 Slm1)','W23/(?/les23 Slm1)',['les23 Slm1'],'K11304').
genotype(3163,1017,'10R1017:0012114',1017,'10R1017:0012114','W23/(?/les23 Slm1)','W23/(?/les23 Slm1)','W23/(?/les23 Slm1)','W23/(?/les23 Slm1)',['les23 Slm1'],'K11304').
genotype(3164,1019,'10R1019:0012211',1019,'10R1019:0012211','M14/(?/les23 Slm1)','M14/(?/les23 Slm1)','M14/(?/les23 Slm1)','M14/(?/les23 Slm1)',['les23 Slm1'],'K11304').
genotype(3165,1019,'10R1019:0012214',1019,'10R1019:0012214','M14/(?/les23 Slm1)','M14/(?/les23 Slm1)','M14/(?/les23 Slm1)','M14/(?/les23 Slm1)',['les23 Slm1'],'K11304').
genotype(3166,3077,'10R3077:0040901',3077,'10R3077:0040901','Mo20W/B73','Mo20W/{camo|+}','Mo20W/B73','Mo20W/{camo|+}',['camo'],'K13009').
genotype(3167,3077,'10R3077:0040914',3077,'10R3077:0040914','Mo20W/B73','Mo20W/{camo|+}','Mo20W/B73','Mo20W/{camo|+}',['camo'],'K13009').
genotype(3168,3077,'10R3077:0040915',3077,'10R3077:0040915','Mo20W/B73','Mo20W/{camo|+}','Mo20W/B73','Mo20W/{camo|+}',['camo'],'K13009').
genotype(3169,3078,'10R3078:0041002',3078,'10R3078:0041002','W23/B73','W23/{camo|+}','W23/B73','W23/{camo|+}',['camo'],'K13009').
genotype(3170,3078,'10R3078:0041006',3078,'10R3078:0041006','W23/B73','W23/{camo|+}','W23/B73','W23/{camo|+}',['camo'],'K13009').
genotype(3171,3078,'10R3078:0041009',3078,'10R3078:0041009','W23/B73','W23/{camo|+}','W23/B73','W23/{camo|+}',['camo'],'K13009').
% 
% regularized
% Kazic, 3.11.2011
%
% genotype(3172,405,'10R405:M0007513',0120,'10R0120:0035408','M14','M14','I-52/Va35','Les-102',['Les-102'],'K12008').
%
genotype(3172,405,'10R405:M0007513',120,'10R0120:0035408','M14','M14','I-52/Va35','Les102',['Les102'],'K12008').
%
genotype(3173,301,'09R301:W0041311',139,'09R0139:0030202','W23','W23','B73/Mo17','Les*-N2420',['Les*-N2420'],'K13902').
genotype(3174,201,'09R201:S0041710',145,'09R0145:0031609','Mo20W','Mo20W','N','D10',['D10'],'K14509').
genotype(3175,201,'09R201:S0041712',145,'09R0145:0031610','Mo20W','Mo20W','N','D10',['D10'],'K14510').
genotype(3176,301,'09R301:W0040710',145,'09R0145:0031609','W23','W23','N','D10',['D10'],'K14509').
genotype(3177,301,'09R301:W0041006',145,'09R0145:0031610','W23','W23','N','D10',['D10'],'K14510').
genotype(3178,401,'09R401:M0040502',145,'09R0145:0031609','M14','M14','N','D10',['D10'],'K14509').
genotype(3179,401,'09R401:M0041208',145,'09R0145:0031610','M14','M14','N','D10',['D10'],'K14510').
genotype(3180,201,'09R201:S0042015',146,'09R0146:0031703','Mo20W','Mo20W','N','Tp1',['Tp1'],'K14603').
genotype(3181,205,'10R205:S0010204',169,'10R0169:0035705','Mo20W','Mo20W','?','LesDS*-1',['LesDS*-1'],'K16905').
genotype(3182,305,'10R305:W0009709',169,'10R0169:0035709','W23','W23','?','LesDS*-1',['LesDS*-1'],'K16910').
genotype(3183,205,'10R205:S0001108',190,'10R0190:0095002','Mo20W','Mo20W','B73/camo cf0-1','B73/camo cf0-1',['camo cf0-1'],'K19002').
genotype(3184,305,'10R305:W0006511',190,'10R0190:0095002','W23','W23','B73/camo cf0-1','B73/camo cf0-1',['camo cf0-1'],'K19002').
genotype(3185,405,'10R405:M0001006',190,'10R0190:0095002','M14','M14','B73/camo cf0-1','B73/camo cf0-1',['camo cf0-1'],'K19002').
genotype(3186,205,'10R205:S0001102',191,'10R0191:0095101','Mo20W','Mo20W','B73/camo cf0-2','B73/camo cf0-2',['camo cf0-2'],'K19101').
genotype(3187,305,'10R305:W0006518',191,'10R0191:0095101','W23','W23','B73/camo cf0-2','B73/camo cf0-2',['camo cf0-2'],'K19101').
genotype(3188,405,'10R405:M0001313',191,'10R0191:0095101','M14','M14','B73/camo cf0-2','B73/camo cf0-2',['camo cf0-2'],'K19101').
genotype(3189,205,'10R205:S0006102',1014,'10R1014:0030401','Mo20W','Mo20W','Mo20W','Les12',['Les12'],'K1001').
genotype(3190,205,'10R205:S0007903',1033,'10R1033:0020002','Mo20W','Mo20W','W23','Les4',['Les4'],'K2101').
genotype(3191,305,'10R305:W0004503',1034,'10R1034:0020806','W23','W23','W23/Mo20W','Les6',['Les6'],'K0403').
genotype(3192,305,'10R305:W0001502',1035,'10R1035:0021906','W23','W23','W23/Mo20W','Les7',['Les7'],'K0509').
genotype(3193,301,'09R301:W0045202',1040,'09R1040:0026504','W23','W23','Mo20W/+','Les18',['Les18'],'K1411').
genotype(3194,205,'10R205:S0010209',1055,'10R1055:0033915','Mo20W','Mo20W','Mo20W','Les19',['Les19'],'K1506').
genotype(3195,205,'10R205:S0010406',1108,'10R1108:0020309','Mo20W','Mo20W','W23/M14','Les5-N1449',['Les5-N1449'],'K5804').
genotype(3196,305,'10R305:W0009503',1108,'10R1108:0020309','W23','W23','W23/M14','Les5-N1449',['Les5-N1449'],'K5804').
genotype(3197,205,'10R205:S0001114',1118,'10R1118:0035008','Mo20W','Mo20W','B73 Ht1/+','Les21-N1442',['Les21-N1442'],'K7205').
genotype(3198,305,'10R305:W0005105',1118,'10R1118:0035008','W23','W23','B73 Ht1/+','Les21-N1442',['Les21-N1442'],'K7205').
genotype(3199,405,'10R405:M0000402',1118,'10R1118:0035008','M14','M14','B73 Ht1/+','Les21-N1442',['Les21-N1442'],'K7205').
genotype(3200,305,'10R305:W0004802',1227,'10R1227:0016313','W23','W23','M14/W23','Les2-N845A',['Les2-N845A'],'K5515').
genotype(3201,205,'10R205:S0000810',1258,'10R1258:0038815','Mo20W','Mo20W','W23','Les13',['Les13'],'K2805').
genotype(3202,405,'10R405:M0006912',1290,'10R1290:0034406','M14','M14','W23','Les19',['Les19'],'K3206').
genotype(3203,305,'10R305:W0004508',1313,'10R1313:0028603','W23','W23','W23','Les8',['Les8'],'K2405').
genotype(3204,201,'09R201:S0042010',1317,'09R1317:0022305','Mo20W','Mo20W','W23','Les9',['Les9'],'K2506').
genotype(3205,405,'10R405:M0007806',1317,'10R1317:0029307','M14','M14','W23','Les9',['Les9'],'K2506').
genotype(3206,205,'10R205:S0003106',1321,'10R1321:0032509','Mo20W','Mo20W','Mo20W/W23','Les17',['Les17'],'K3007').
genotype(3207,205,'10R205:S0010601',1328,'10R1328:0028506','Mo20W','Mo20W','W23','Les8',['Les8'],'K2405').
genotype(3208,405,'10R405:M0008407',1328,'10R1328:0028506','M14','M14','W23','Les8',['Les8'],'K2405').
genotype(3209,205,'10R205:S0006103',1329,'10R1329:0033105','Mo20W','Mo20W','W23','Les18',['Les18'],'K3106').
genotype(3210,205,'10R205:S0001410',1332,'10R1332:0034210','Mo20W','Mo20W','Mo20W/W23','Les19',['Les19'],'K3206').
genotype(3211,305,'10R305:W0004513',1335,'10R1335:0034905','W23','W23','W23','Les21',['Les21'],'K3311').
genotype(3212,205,'10R205:S0007001',1349,'10R1349:0040809','Mo20W','Mo20W','W23','Les7',['Les7'],'K2312').
genotype(3213,305,'10R305:W0010107',1349,'10R1349:0040809','W23','W23','W23','Les7',['Les7'],'K2312').
genotype(3214,405,'10R405:M0007509',1349,'10R1349:0040809','M14','M14','W23','Les7',['Les7'],'K2312').
genotype(3215,205,'10R205:S0006706',1364,'10R1364:0034803','Mo20W','Mo20W','W23','Les21',['Les21'],'K3311').
genotype(3216,405,'10R405:M0007208',1364,'10R1364:0034803','M14','M14','W23','Les21',['Les21'],'K3311').
genotype(3217,401,'09R401:M0033013',1368,'09R1368:0007709','M14','M14','W23','les23',['les23'],'K3514').
genotype(3218,205,'10R205:S0001415',1395,'10R1395:0020411','Mo20W','Mo20W','Mo20W/?','Les5',['Les5'],'K11613').
genotype(3219,205,'10R205:S0003107',1428,'10R1428:0015607','Mo20W','Mo20W','Mo20W','Les1',['Les1'],'K0106').
genotype(3220,305,'10R305:W0003003',1428,'10R1428:0015607','W23','W23','Mo20W','Les1',['Les1'],'K0106').
genotype(3221,205,'10R205:S0010006',1539,'10R1539:0031202','Mo20W','Mo20W','Mo20W','Les13',['Les13'],'K1109').
genotype(3222,205,'10R205:S0007009',1540,'10R1540:0032202','Mo20W','Mo20W','Mo20W','Les17',['Les17'],'K1309').
genotype(3223,305,'10R305:W0005908',1571,'10R1571:0030511','W23','W23','Mo20W/+','Les12',['Les12'],'K1001').
genotype(3224,205,'10R205:S0002606',1580,'10R1580:0032802','Mo20W','Mo20W','Mo20W','Les18',['Les18'],'K1411').
genotype(3225,205,'10R205:S0003101',1619,'10R1619:0028202','Mo20W','Mo20W','Mo20W','Les8',['Les8'],'K0604').
genotype(3226,205,'10R205:S0002308',1645,'10R1645:0021806','Mo20W','Mo20W','Mo20W','Les7',['Les7'],'K0509').
genotype(3227,301,'09R301:W0040711',1707,'09R1707:0020604','W23','W23','W23','Les7',['Les7'],'K2312').
genotype(3228,405,'10R405:M0006611',1723,'10R1723:0015710','M14','M14','M14/Mo20W','Les1',['Les1'],'K0106').
genotype(3229,305,'10R305:W0004515',1725,'10R1725:0015802','W23','W23','W23','Les1',['Les1'],'K1903').
genotype(3230,301,'09R301:W0056603',1797,'09R1797:0030004','W23','W23','(W23/((B73/AG32)/Ht1))','Les*-N2418',['Les*-N2418'],'K8501').
genotype(3231,405,'10R405:M0007808',1805,'10R1805:0016410','M14','M14','M14/W23','Les2-N845A',['Les2-N845A'],'K5525').
%
% corrected per notes re family 1816
%
% genotype(3232,205,'10R205:S0007303',1816,'10R1816:0016807','Mo20W','Mo20W','Mo20W','Les9',['Les9'],'K0709').
%
genotype(3232,205,'10R205:S0007303',1816,'10R1816:0016807','Mo20W','Mo20W','Mo20W','Les2',['Les2'],'K0202').
%
% Kazic, 18.12.2012


genotype(3233,401,'09R401:M0045405',1826,'09R1826:0029807','M14','M14','M14/+','Les*-N2397',['Les*-N2397'],'K8414').
genotype(3234,301,'09R301:W0042501',1851,'09R1851:0018706','W23','W23','W23/M14','Les6',['Les6'],'K2210').
genotype(3235,205,'10R205:S0010405',1951,'10R1951:0030304','Mo20W','Mo20W','W23/M14','Les11-N1438',['Les11-N1438'],'K6408').
genotype(3236,305,'10R305:W0009704',1951,'10R1951:0030304','W23','W23','W23/M14','Les11-N1438',['Les11-N1438'],'K6408').
genotype(3237,201,'09R201:S0051301',1966,'09R1966:0003904','Mo20W','Mo20W','les*-N2013','les*-N2013',['les*-N2013'],'K7807').
genotype(3238,301,'09R301:W0051201',1966,'09R1966:0003904','W23','W23','les*-N2013','les*-N2013',['les*-N2013'],'K7807').
genotype(3239,401,'09R401:M0051102',1966,'09R1966:0003904','M14','M14','les*-N2013','les*-N2013',['les*-N2013'],'K7807').
genotype(3240,405,'10R405:M0008401',2051,'10R2051:0031110','M14','M14','M14/W23','Les12',['Les12'],'K2711').
genotype(3241,405,'10R405:M0006909',2135,'10R2135:0019707','M14','M14','M14','Les4',['Les4'],'K0302').
genotype(3242,405,'10R405:M0006312',2140,'10R2140:0032706','M14','M14','M14','Les17',['Les17'],'K3007').
genotype(3243,201,'09R201:S0035401',2161,'09R2161:0000811','Mo20W','Mo20W','Mo20W/les*-74-1873-9','Mo20W/les*-74-1873-9',['les*-74-1873-9'],'K9304').
genotype(3244,301,'09R301:W0032914',2172,'09R2172:0006509','W23','W23','W23/Mo20W','les23',['les23'],'K1802').
genotype(3245,401,'09R401:M0033407',2175,'09R2175:0007012','M14','M14','M14/Mo20W','les23',['les23'],'K1802').
genotype(3246,205,'10R205:S0007304',2207,'10R2207:0017303','Mo20W','Mo20W','Mo20W','Les2',['Les2'],'K0207').
genotype(3247,205,'10R205:S0001706',2208,'10R2208:0017408','Mo20W','Mo20W','Mo20W','Les2',['Les2'],'K0203').
%
% really is Les2, not Les18 K3106
%
% Kazic, 6.11.2011
%
genotype(3248,205,'10R205:S0001701',2209,'10R2209:0017703','Mo20W','Mo20W','W23','Les2',['Les2'],'K2002').
genotype(3249,305,'10R305:W0006204',2229,'10R2229:0017801','W23','W23','W23','Les2',['Les2'],'K2002').
genotype(3250,405,'10R405:M0000411',2230,'10R2230:0017902','M14','M14','M14/W23','Les2',['Les2'],'K2002').
genotype(3251,205,'10R205:S0001703',2231,'10R2231:0018402','Mo20W','Mo20W','Mo20W','Les4',['Les4'],'K0303').
genotype(3252,305,'10R305:W0003603',2232,'10R2232:0018504','W23','W23','W23/Mo20W','Les4',['Les4'],'K0303').
genotype(3253,405,'10R405:M0005010',2233,'10R2233:0018604','M14','M14','M14/Mo20W','Les4',['Les4'],'K0303').
genotype(3254,205,'10R205:S0002008',2235,'10R2235:0020704','Mo20W','Mo20W','Mo20W','Les6',['Les6'],'K0403').
genotype(3255,405,'10R405:M0006608',2236,'10R2236:0020906','M14','M14','M14/Mo20W','Les6',['Les6'],'K0403').
genotype(3256,305,'10R305:W0001207',2237,'10R2237:0021106','W23','W23','W23','Les6',['Les6'],'K2202').
genotype(3257,305,'10R305:W0001517',2238,'10R2238:0021305','W23','W23','W23','Les6',['Les6'],'K2212').
genotype(3258,205,'10R205:S0007318',2239,'10R2239:0021509','Mo20W','Mo20W','Mo20W','Les6',['Les6'],'K2210').
genotype(3259,405,'10R405:M0006906',2240,'10R2240:0021707','M14','M14','M14','Les6',['Les6'],'K2210').
genotype(3260,405,'10R405:M0007204',2241,'10R2241:0022011','M14','M14','M14/Mo20W','Les7',['Les7'],'K0509').
genotype(3261,305,'10R305:W0005109',2242,'10R2242:0028312','W23','W23','W23/Mo20W','Les8',['Les8'],'K0604').
genotype(3262,405,'10R405:M0007801',2243,'10R2243:0028413','M14','M14','M14/Mo20W','Les8',['Les8'],'K0604').
genotype(3263,205,'10R205:S0007605',2244,'10R2244:0028706','Mo20W','Mo20W','Mo20W','Les9',['Les9'],'K0707').
genotype(3264,305,'10R305:W0005405',2245,'10R2245:0028810','W23','W23','W23/Mo20W','Les9',['Les9'],'K0707').
genotype(3265,405,'10R405:M0007804',2246,'10R2246:0028906','M14','M14','M14/Mo20W','Les9',['Les9'],'K0707').
genotype(3266,305,'10R305:W0005411',2247,'10R2247:0029107','W23','W23','W23','Les9',['Les9'],'K2506').
genotype(3267,305,'10R305:W0001513',2248,'10R2248:0029210','W23','W23','W23/Mo20W','Les10',['Les10'],'K0801').
genotype(3268,305,'10R305:W0003902',2249,'10R2249:0029503','W23','W23','W23','Les10',['Les10'],'K2606').
genotype(3269,305,'10R305:W0005415',2250,'10R2250:0029806','W23','W23','W23','Les11',['Les11'],'K0901').
genotype(3270,205,'10R205:S0002302',2252,'10R2252:0031702','Mo20W','Mo20W','W23','Les15-N2007',['Les15-N2007'],'K6711').
genotype(3271,305,'10R305:W0010502',2254,'10R2254:0032002','W23','W23','W23/M14','Les15-N2007',['Les15-N2007'],'K6711').
genotype(3272,405,'10R405:M0006612',2255,'10R2255:0032106','M14','M14','W23/M14','Les15-N2007',['Les15-N2007'],'K6711').
genotype(3273,305,'10R305:W0010506',2256,'10R2256:0032301','W23','W23','W23/Mo20W','Les17',['Les17'],'K1309').
genotype(3274,305,'10R305:W0004511',2257,'10R2257:0032605','W23','W23','W23','Les17',['Les17'],'K3007').
genotype(3275,305,'10R305:W0004211',2258,'10R2258:0033209','W23','W23','W23','Les18',['Les18'],'K3106').
genotype(3276,305,'10R305:W0010513',2260,'10R2260:0034308','W23','W23','W23','Les19',['Les19'],'K3206').
genotype(3277,305,'10R305:W0005416',2261,'10R2261:0036707','W23','W23','W23','Les*-N2397',['Les*-N2397'],'K8414').
genotype(3278,205,'10R205:S0010606',2263,'10R2263:0036908','Mo20W','Mo20W','Mo20W/W23','Les*-N2418',['Les*-N2418'],'K8501').
genotype(3279,405,'10R405:M0001909',2264,'10R2264:0037103','M14','M14','M14/W23','Les*-N2418',['Les*-N2418'],'K8501').
genotype(3280,205,'10R205:S0001412',2265,'10R2265:0013305','Mo20W','Mo20W','Mo20W','lls1',[lls1],'K1702').
genotype(3281,405,'10R405:M0005313',2269,'10R2269:0013714','M14','lls1','M14','lls1',[lls1],'K1702').
genotype(3282,405,'10R405:M0003804',2289,'10R2289:0017005','M14','M14','Mo20W','Les2',['Les2'],'K0202').
genotype(3283,305,'10R305:W0003609',2292,'10R2292:0016904','W23','W23','Mo20W','Les2',['Les2'],'K0202').
genotype(3284,305,'10R305:W0006505',2315,'10R2315:0017105','W23','W23','Mo20W','Les2',['Les2'],'K0207').
genotype(3285,405,'10R405:M0005003',2326,'10R2326:0017209','M14','M14','Mo20W','Les2',['Les2'],'K0207').
genotype(3286,205,'10R205:S0010007',2510,'10R2510:0030010','Mo20W','Mo20W','Mo20W','Les11',['Les11'],'K0901').
genotype(3287,405,'10R405:M0007201',2512,'10R2512:0030103','M14','M14','M14/Mo20W','Les11',['Les11'],'K0901').
genotype(3288,405,'10R405:M0007803',2528,'10R2528:0030605','M14','M14','M14/Mo20W','Les12',['Les12'],'K1001').
genotype(3289,405,'10R405:M0001609',2536,'10R2536:0038715','M14','M14','M14/Mo20W','Les13',['Les13'],'K1109').
genotype(3290,405,'10R405:M0006602',2651,'10R2651:0034104','M14','M14','M14/Mo20W','Les19',['Les19'],'K1506').
genotype(3291,301,'09R301:W0033207',2719,'09R2719:0007312','W23','W23','Mo20W/les23',les23,[les23],'K1804').
genotype(3292,401,'09R401:M0033001',2719,'09R2719:0007304','M14','M14','Mo20W/les23',les23,[les23],'K1804').
genotype(3293,405,'10R405:M0003801',2736,'10R2736:0016014','M14','M14','M14','Les1',['Les1'],'K1903').
genotype(3294,305,'10R305:W0005911',2859,'10R2859:0031010','W23','W23','W23','Les12',['Les12'],'K2711').
genotype(3295,405,'10R405:M0000409',2868,'10R2868:0031504','M14','M14','M14','Les13',['Les13'],'K2805').
genotype(3296,305,'10R305:W0004801',2870,'10R2870:0031403','W23','W23','W23','Les13',['Les13'],'K2805').
genotype(3297,205,'10R205:S0001406',2929,'10R2929:0034507','Mo20W','Mo20W','Mo20W/(M14/(W23/L317))','+/Les20-N2457',['Les20-N2457'],'K7110').
genotype(3298,405,'10R405:M0008103',2932,'10R2932:0034703','M14','M14','M14','+/Les20-N2457',['Les20-N2457'],'K7110').
genotype(3299,205,'10R205:S0003415',2993,'10R2993:0015912','Mo20W','Mo20W','Mo20W/W23','Les1',['Les1'],'K1903').
genotype(3300,205,'10R205:S0010019',2994,'10R2994:0016202','Mo20W','Mo20W','Mo20W/(M14/W23)','Les2-N845A',['Les2-N845A'],'K5515').
genotype(3301,305,'10R305:W0006210',2995,'10R2995:0017501','W23','W23','W23/Mo20W','Les2',['Les2'],'K0203').
genotype(3302,405,'10R405:M0006006',2996,'10R2996:0017611','M14','M14','M14/Mo20W','Les2',['Les2'],'K0203').
genotype(3303,205,'10R205:S0001704',3000,'10R3000:0018902','Mo20W','Mo20W','Mo20W/W23','Les4',['Les4'],'K0302').
genotype(3304,305,'10R305:W0006207',3001,'10R3001:0019012','W23','W23','M14/(W23/Mo20W)','Les4',['Les4'],'K0302').
genotype(3305,205,'10R205:S0001111',3004,'10R3004:0019804','Mo20W','Mo20W','Mo20W/W23','Les4',['Les4'],'K2106').
genotype(3306,305,'10R305:W0010519',3004,'10R3004:0019804','W23','W23','Mo20W/W23','Les4',['Les4'],'K2106').
genotype(3307,405,'10R405:M0001008',3004,'10R3004:0019804','M14','M14','Mo20W/W23','Les4',['Les4'],'K2106').
genotype(3308,405,'10R405:M0006601',3005,'10R3005:0020107','M14','M14','M14/W23','Les6',['Les6'],'K2212').
genotype(3309,205,'10R205:S0002011',3006,'10R3006:0021008','Mo20W','Mo20W','Mo20W/W23','Les6',['Les6'],'K2202').
genotype(3310,405,'10R405:M0005312',3007,'10R3007:0021203','M14','M14','M14/W23','Les6',['Les6'],'K2202').
genotype(3311,205,'10R205:S0002309',3008,'10R3008:0021414','Mo20W','Mo20W','Mo20W/W23','Les6',['Les6'],'K2212').
genotype(3312,205,'10R205:S0010208',3048,'10R3048:0029406','Mo20W','Mo20W','Mo20W','Les10',['Les10'],'K0801').
genotype(3313,405,'10R405:M0006309',3050,'10R3050:0033010','M14','M14','Mo20W','Les18',['Les18'],'K1411').
genotype(3314,405,'10R405:M0006308',3051,'10R3051:0033301','M14','M14','W23','Les18',['Les18'],'K3106').
genotype(3315,305,'10R305:W0005917',3052,'10R3052:0034003','W23','W23','W23/Mo20W','Les19',['Les19'],'K1506').
genotype(3316,305,'10R305:W0010509',3053,'10R3053:0034610','W23','W23','W23/M14','Les20-N2457',['Les20-N2457'],'K7110').
genotype(3317,205,'10R205:S0009817',3057,'10R3057:0035907','Mo20W','Mo20W','Mo20W/(CM105/Oh43E)','Les*-N1378',['Les*-N1378'],'K7403').
genotype(3318,305,'10R305:W0009102',3058,'10R3058:0036015','W23','W23','W23/(CM105/Oh43E)','Les*-N1378',['Les*-N1378'],'K7403').
genotype(3319,405,'10R405:M0006305',3059,'10R3059:0036107','M14','M14','M14/(CM105/Oh43E)','Les*-N1378',['Les*-N1378'],'K7403').
genotype(3320,405,'10R405:M0008110',3064,'10R3064:0037402','M14','M14','M14/(B73/Mo17)','Les*-N2420',['Les*-N2420'],'K13902').
genotype(3321,205,'10R205:S0006101',3065,'10R3065:0037509','Mo20W','Mo20W','Mo20W/(B73 Ht1/Mo17)','Les*-NA7145',['Les*-NA7145'],'K9113').
genotype(3322,305,'10R305:W0005915',3066,'10R3066:0037605','W23','W23','Mo20W/(B73 Ht1/Mo17)','Les*-NA7145',['Les*-NA7145'],'K9113').
genotype(3323,405,'10R405:M0006913',3067,'10R3067:0037702','M14','M14','Mo20W/(B73 Ht1/Mo17)','Les*-NA7145',['Les*-NA7145'],'K9113').
genotype(3324,205,'10R205:S0009803',3068,'10R3068:0037802','Mo20W','Mo20W','Mo20W/mop1','Les*-mi1',['Les*-mi1'],'K12205').
genotype(3325,305,'10R305:W0003007',3069,'10R3069:0037908','W23','W23','W23/mop1','Les*-mi1',['Les*-mi1'],'K12205').
genotype(3326,405,'10R405:M0001605',3070,'10R3070:0038007','M14','M14','M14/mop1','Les*-mi1',['Les*-mi1'],'K12205').

genotype(3327,305,'10R305:W0004517',1335,'10R1335:0034907','W23','W23','W23','Les21',['Les21'],'K3311').
genotype(3328,405,'10R405:M0006005',2051,'10R2051:0031106','M14','M14','M14','Les12',['Les12'],'K2711').
genotype(3329,1133,'09R1133:0006205',1133,'09R1133:0006205','Mo20W','les*-NA467','Mo20W','les*-NA467',['les*-NA467'],'K9001').
genotype(3330,1134,'09R1134:0006305',1134,'09R1134:0006305','Mo20W','les*-NA467','Mo20W','les*-NA467',['les*-NA467'],'K9006').
genotype(3331,1057,'09R1057:0006408',1057,'09R1057:0006408','Mo20W','les23','Mo20W','les23',['les23'],'K1802').



% 11n

% these are from Gerry.  I don''t know the genotypes, mostly, but need family numbers for them in
% order to generate plant tags.  Since they aren''t entering my collection, I''m not using numbers in the
% founders range for them.  The row numbers in the numerical genotypes are the 11N rows.
%
% Kazic, 15.12.2011
%
%
% Since Gerry''s families are mostly nondescript, and the numbers are re-used from crop to crop, I have 
% simply commented out, and rewritten, genotype facts for families to make them neutral, for the benefit
% of find_mutant_row_plans.  This may create some havoc with pedigree construction for Les-2657.
%
% Kazic, 30.12.2012


genotype(3332,3332,'11N3332:0000100',3332,'11N3332:0000100','','','','',[''],'').
genotype(3333,3333,'11N3333:0000200',3333,'11N3333:0000200','','','','',[''],'').
genotype(3334,3334,'11N3334:0000300',3334,'11N3334:0000300','','','','',[''],'').
genotype(3335,3335,'11N3335:0000400',3335,'11N3335:0000400','','','','',[''],'').
genotype(3336,3336,'11N3336:0000500',3336,'11N3336:0000500','','','','',[''],'').
genotype(3337,3337,'11N3337:0000600',3337,'11N3337:0000600','','','','',[''],'').
%
% actual genotypes in 11n
%
% genotype(3338,3338,'11N3338:0000700',3338,'11N3338:0000700','Mo20W','Mo20W','Les-2657','Les-2657',['Les-2657'],'').
% genotype(3339,3339,'11N3339:0000800',3339,'11N3339:0000800','W23','W23','Les-2657','Les-2657',['Les-2657'],'').
% genotype(3340,3340,'11N3340:0000900',3340,'11N3340:0000900','B73','B73','Les-2657','Les-2657',['Les-2657'],'').
% genotype(3341,3341,'11N3341:0001000',3341,'11N3341:0001000','Les-2657','Les-2657','+','+',['Les-2657'],'').
% 
%
genotype(3338,3338,'11N3338:0000700',3338,'11N3338:0000700','','','','',[''],'').
genotype(3339,3339,'11N3339:0000800',3339,'11N3339:0000800','','','','',[''],'').
genotype(3340,3340,'11N3340:0000900',3340,'11N3340:0000900','','','','',[''],'').
genotype(3341,3341,'11N3341:0001000',3341,'11N3341:0001000','','','','',[''],'').
%
%
genotype(3342,3342,'11N3342:0001100',3342,'11N3342:0001100','','','','',[''],'').
genotype(3343,3343,'11N3343:0001200',3343,'11N3343:0001200','','','','',[''],'').
genotype(3344,3344,'11N3344:0001300',3344,'11N3344:0001300','','','','',[''],'').
%
% supposed genotypes in 11n, but there were issues with identifying rows due to spreadsheet
% misunderstanding
%
% genotype(3345,3345,'11N3345:0001400',3345,'11N3345:0001400','Mo20W','Mo20W','B73','B73',[''],'').
% genotype(3346,3346,'11N3346:0001500',3346,'11N3346:0001500','W23','W23','B73','B73',[''],'').
% genotype(3347,3347,'11N3347:0001600',3347,'11N3347:0001600','W23','W23','Mo20W','Mo20W',[''],'').
% genotype(3348,3348,'11N3348:0001700',3348,'11N3348:0001700','W23','W23','W23','W23',[''],'').
% genotype(3349,3349,'11N3349:0001800',3349,'11N3349:0001800','Mo20W','Mo20W','Mo20W','Mo20W',[''],'').
%
%
genotype(3345,3345,'11N3345:0001400',3345,'11N3345:0001400','','','','',[''],'').
genotype(3346,3346,'11N3346:0001500',3346,'11N3346:0001500','','','','',[''],'').
genotype(3347,3347,'11N3347:0001600',3347,'11N3347:0001600','','','','',[''],'').
genotype(3348,3348,'11N3348:0001700',3348,'11N3348:0001700','','','','',[''],'').
genotype(3349,3349,'11N3349:0001800',3349,'11N3349:0001800','','','','',[''],'').
%
%
genotype(3350,3350,'11N3350:0001900',3350,'11N3350:0001900','','','','',[''],'').
genotype(3351,3351,'11N3351:0002000',3351,'11N3351:0002000','','','','',[''],'').
genotype(3352,3352,'11N3352:0002100',3352,'11N3352:0002100','','','','',[''],'').
genotype(3353,3353,'11N3353:0002200',3353,'11N3353:0002200','','','','',[''],'').
genotype(3354,3354,'11N3354:0002300',3354,'11N3354:0002300','','','','',[''],'').
genotype(3355,3355,'11N3355:0002400',3355,'11N3355:0002400','','','','',[''],'').
genotype(3356,3356,'11N3356:0002500',3356,'11N3356:0002500','','','','',[''],'').
genotype(3357,3357,'11N3357:0002600',3357,'11N3357:0002600','','','','',[''],'').
genotype(3358,3358,'11N3358:0002700',3358,'11N3358:0002700','','','','',[''],'').
genotype(3359,3359,'11N3359:0002800',3359,'11N3359:0002800','','','','',[''],'').
genotype(3340,3340,'11N3340:0002900',3340,'11N3340:0002900','','','','',[''],'').
genotype(3361,3361,'11N3361:0003000',3361,'11N3361:0003000','','','','',[''],'').
genotype(3362,3362,'11N3362:0003100',3362,'11N3362:0003100','','','','',[''],'').
genotype(3363,3363,'11N3363:0003200',3363,'11N3363:0003200','','','','',[''],'').
genotype(3364,3364,'11N3364:0003300',3364,'11N3364:0003300','','','','',[''],'').
genotype(3365,3365,'11N3365:0003400',3365,'11N3365:0003400','','','','',[''],'').
genotype(3366,3366,'11N3366:0003500',3366,'11N3366:0003500','','','','',[''],'').
genotype(3367,3367,'11N3367:0003600',3367,'11N3367:0003600','','','','',[''],'').
genotype(3368,3368,'11N3368:0003700',3368,'11N3368:0003700','','','','',[''],'').
genotype(3369,3369,'11N3369:0003800',3369,'11N3369:0003800','','','','',[''],'').
genotype(3370,3370,'11N3370:0003900',3370,'11N3370:0003900','','','','',[''],'').
genotype(3371,3371,'11N3371:0004000',3371,'11N3371:0004000','','','','',[''],'').
genotype(3372,3372,'11N3372:0004100',3372,'11N3372:0004100','','','','',[''],'').
genotype(3373,3373,'11N3373:0004200',3373,'11N3373:0004200','','','','',[''],'').
genotype(3374,3374,'11N3374:0004300',3374,'11N3374:0004300','','','','',[''],'').
genotype(3375,3375,'11N3375:0004400',3375,'11N3375:0004400','','','','',[''],'').
genotype(3376,3376,'11N3376:0004500',3376,'11N3376:0004500','','','','',[''],'').
genotype(3377,3377,'11N3377:0004600',3377,'11N3377:0004600','','','','',[''],'').
genotype(3378,3378,'11N3378:0004700',3378,'11N3378:0004700','','','','',[''],'').
genotype(3379,3379,'11N3379:0004800',3379,'11N3379:0004800','','','','',[''],'').
genotype(3380,3380,'11N3380:0004900',3380,'11N3380:0004900','','','','',[''],'').
genotype(3381,3381,'11N3381:0005000',3381,'11N3381:0005000','','','','',[''],'').
genotype(3382,3382,'11N3382:0005100',3382,'11N3382:0005100','','','','',[''],'').
genotype(3383,3383,'11N3383:0005200',3383,'11N3383:0005200','','','','',[''],'').
genotype(3384,3384,'11N3384:0005300',3384,'11N3384:0005300','','','','',[''],'').
genotype(3385,3385,'11N3385:0005400',3385,'11N3385:0005400','','','','',[''],'').
genotype(3386,3386,'11N3386:0005500',3386,'11N3386:0005500','','','','',[''],'').
genotype(3387,3387,'11N3387:0005600',3387,'11N3387:0005600','','','','',[''],'').
genotype(3388,3388,'11N3388:0005700',3388,'11N3388:0005700','','','','',[''],'').
genotype(3389,3389,'11N3389:0005800',3389,'11N3389:0005800','','','','',[''],'').
genotype(3390,3390,'11N3390:0005900',3390,'11N3390:0005900','','','','',[''],'').
genotype(3391,3391,'11N3391:0006000',3391,'11N3391:0006000','','','','',[''],'').
genotype(3392,3392,'11N3392:0006100',3392,'11N3392:0006100','','','','',[''],'').
genotype(3393,3393,'11N3393:0006200',3393,'11N3393:0006200','','','','',[''],'').






%%%%%%%%% automatically added families for 11N crop; check calculated genotype data! %%%%%%%%%%%%%%
%
% checked and confirmed
%
% Kazic, 15.12.2011

genotype(3360,205,'10R205:S0007007',1428,'10R1428:0015605','Mo20W','Mo20W','Mo20W','Mo20W/Les1',['Les1'],'K0106').
genotype(3394,305,'10R305:W0004509',1428,'10R1428:0015605','W23','W23','Mo20W','Mo20W/Les1',['Les1'],'K0106').
genotype(3395,405,'10R405:M0000410',1723,'10R1723:0015704','M14','M14','M14','M14/(Mo20W/Les1)',['Les1'],'K0106').
genotype(3396,205,'10R205:S0007011',2993,'10R2993:0015907','Mo20W','Mo20W','Mo20W','W23/Les1',['Les1'],'K1903').
genotype(3397,305,'11R305:W0051504',3229,'11R3229:0052711','W23','W23','W23','W23/Les1',['Les1'],'K1903').
genotype(3398,405,'11R405:M0050306',3293,'11R3293:0052908','M14','M14','M14','M14/Les1',['Les1'],'K1903').
genotype(3399,205,'10R205:S0005508',1236,'10R1236:0016506','Mo20W','Mo20W','Mo20W/+','Mo20W/(+/Les2)',['Les2'],'K0202').
genotype(3400,305,'10R305:W0004512',1236,'10R1236:0016506','W23','W23','Mo20W/+','Mo20W/(+/Les2)',['Les2'],'K0202').
genotype(3401,405,'10R405:M0005004',1236,'10R1236:0016506','M14','M14','Mo20W/+','Mo20W/(+/Les2)',['Les2'],'K0202').
genotype(3402,205,'11R205:S0052004',3247,'11R3247:0053608','Mo20W','Mo20W','Mo20W','Les2',['Les2'],'K0203').
genotype(3403,305,'11R305:W0052103',3301,'11R3301:0053710','W23','W23','W23','W23/(Mo20W/Les2)',['Les2'],'K0203').
genotype(3404,205,'11R205:S0051806',3246,'11R3246:0053906','Mo20W','Mo20W','Mo20W','Les2',['Les2'],'K0207').
genotype(3405,305,'11R305:W0051918',3284,'11R3284:0054005','W23','W23','W23','Mo20W/Les2',['Les2'],'K0207').
genotype(3406,405,'11R405:M0051312',3285,'11R3285:0054108','M14','M14','M14','Mo20W/Les2',['Les2'],'K0207').
genotype(3407,205,'10R205:S0001705',2209,'10R2209:0017706','Mo20W','Mo20W','Mo20W','Mo20W/(W23/Les2)',['Les2'],'K2002').
genotype(3408,305,'11R305:W0052105',3249,'11R3249:0054802','W23','W23','W23','W23/Les2',['Les2'],'K2002').
genotype(3409,405,'11R405:M0051309',3250,'11R3250:0054904','M14','M14','M14','M14/(W23/Les2)',['Les2'],'K2002').
genotype(3410,305,'11R305:W0048512',3200,'11R3200:0017008','W23','W23','W23','(M14/W23)/Les2-N845A',['Les2-N845A'],'K5515').
genotype(3411,405,'11R405:M0050714',3231,'11R3231:0017104','M14','M14','M14','(M14/W23)/Les2-N845A',['Les2-N845A'],'K5525').
genotype(3412,305,'11R305:W0043510',3304,'11R3304:0017303','W23','W23','W23','(M14/(W23/Mo20W))/Les4',['Les4'],'K0302').
genotype(3413,405,'11R405:M0051304',3241,'11R3241:0017406','M14','M14','M14','M14/Les4',['Les4'],'K0302').
genotype(3414,201,'09R201:S0043618',1565,'09R1565:0016510','Mo20W','Mo20W','Mo20W','Mo20W/Les4',['Les4'],'K0303').
genotype(3415,305,'11R305:W0050403',3252,'11R3252:0017606','W23','W23','W23','(W23/Mo20W)/Les4',['Les4'],'K0303').
genotype(3416,405,'11R405:M0050304',3253,'11R3253:0017702','M14','M14','M14','(M14/Mo20W)/Les4',['Les4'],'K0303').
genotype(3417,205,'11R205:S0050106',3190,'11R3190:0017801','Mo20W','Mo20W','Mo20W','W23/Les4',['Les4'],'K2101').
genotype(3418,305,'11R305:W0050408',1735,'11R1735:0018103','W23','W23','W23','(W23/(M14/W23))/Les4',['Les4'],'K2101').
genotype(3419,405,'11R405:M0051007',2234,'11R2234:0017909','M14','M14','M14','(M14/(M14/W23))/Les4',['Les4'],'K2101').
genotype(3420,205,'11R205:S0052007',3305,'11R3305:0018210','Mo20W','Mo20W','Mo20W','(Mo20W/W23)/Les4',['Les4'],'K2106').
genotype(3421,305,'11R305:W0051913',3306,'11R3306:0018306','W23','W23','W23','(Mo20W/W23)/Les4',['Les4'],'K2106').
genotype(3422,405,'11R405:M0051310',3307,'11R3307:0018406','M14','M14','M14','(Mo20W/W23)/Les4',['Les4'],'K2106').
genotype(3423,205,'11R205:S0044303',1898,'11R1898:0013304','Mo20W','Mo20W','M14','?/Les5',['Les5'],'K11603').
genotype(3424,305,'11R305:W0050907',1898,'11R1898:0013304','W23','W23','M14','?/Les5',['Les5'],'K11603').
genotype(3425,305,'11R305:W0048212',1898,'11R1898:0013305','W23','W23','M14','?/Les5',['Les5'],'K11603').
genotype(3426,305,'11R305:W0048208',1898,'11R1898:0013309','W23','W23','M14','?/Les5',['Les5'],'K11603').
genotype(3427,405,'11R405:M0044212',1898,'11R1898:0013304','M14','M14','M14','?/Les5',['Les5'],'K11603').
genotype(3428,305,'11R305:W0048204',1731,'11R1731:0013206','W23','W23','W23','?/Les5',['Les5'],'K11613').
genotype(3429,305,'11R305:W0048205',1731,'11R1731:0013207','W23','W23','W23','?/Les5',['Les5'],'K11613').
genotype(3430,205,'11R205:S0044020',160,'11R0160:0013409','Mo20W','Mo20W','Mo20W','?/Les5-GJ',['Les5-GJ'],'K16009').
genotype(3431,305,'11R305:W0050911',160,'11R0160:0013409','W23','W23','Mo20W','?/Les5-GJ',['Les5-GJ'],'K16009').
genotype(3432,405,'11R405:M0050705',160,'11R0160:0013409','M14','M14','Mo20W','?/Les5-GJ',['Les5-GJ'],'K16009').
genotype(3433,205,'11R205:S0052006',3254,'11R3254:0018505','Mo20W','Mo20W','Mo20W','Les6',['Les6'],'K0403').
genotype(3434,305,'11R305:W0043511',3191,'11R3191:0018608','W23','W23','W23','(W23/Mo20W)/Les6',['Les6'],'K0403').
genotype(3435,205,'11R205:S0052014',3309,'11R3309:0018801','Mo20W','Mo20W','Mo20W','(Mo20W/W23)/Les6',['Les6'],'K2202').
genotype(3436,305,'11R305:W0052109',3256,'11R3256:0018907','W23','W23','W23','W23/Les6',['Les6'],'K2202').
genotype(3437,405,'11R405:M0051005',3310,'11R3310:0019006','M14','M14','M14','(M14/W23)/Les6',['Les6'],'K2202').
genotype(3438,205,'11R205:S0051811',3311,'11R3311:0019405','Mo20W','Mo20W','Mo20W','(Mo20W/W23)/Les6',['Les6'],'K2212').
genotype(3439,405,'11R405:M0051306',3308,'11R3308:0019606','M14','M14','M14','(M14/W23)/Les6',['Les6'],'K2212').
genotype(3440,205,'10R205:S0007006',1349,'10R1349:0040808','Mo20W','Mo20W','W23/+','W23/Les7',['Les7'],'K2312').
genotype(3441,205,'10R205:S0007601',1349,'10R1349:0040813','Mo20W','Mo20W','W23/+','W23/Les7',['Les7'],'K2312').
genotype(3442,205,'11R205:S0051813',3225,'11R3225:0020601','Mo20W','Mo20W','Mo20W','Les8',['Les8'],'K0604').
genotype(3443,305,'11R305:W0043813',3261,'11R3261:0020701','W23','W23','W23','(W23/Mo20W)/Les8',['Les8'],'K0604').
genotype(3444,405,'11R405:M0051013',3208,'11R3208:0021112','M14','M14','M14','M14/(W23/Les8)',['Les8'],'K2405').
genotype(3445,205,'11R205:S0052002',3263,'11R3263:0021202','Mo20W','Mo20W','Mo20W','Les9',['Les9'],'K0707').
genotype(3446,305,'11R305:W0043802',3264,'11R3264:0021306','W23','W23','W23','(W23/Mo20W)/Les9',['Les9'],'K0707').
%
% corrected per note re family 1816
%
% genotype(3447,205,'11R205:S0051805',3232,'11R3232:0053105','Mo20W','Mo20W','Mo20W','Les9',['Les9'],'K0709').
%
genotype(3447,205,'11R205:S0051805',3232,'11R3232:0053105','Mo20W','Mo20W','Mo20W','Les2',['Les2'],'K0202').
%
% Kazic, 18.12.2012
%
genotype(3448,405,'11R405:M0050302',3205,'11R3205:0021707','M14','M14','M14','(M14/W23)/Les9',['Les9'],'K2506').
genotype(3449,205,'11R205:S0051813',3225,'11R3225:0020601','Mo20W','Mo20W','Mo20W','Les8',['Les8'],'K0604').
genotype(3450,305,'11R305:W0051204',3267,'11R3267:0021903','W23','W23','W23','(W23/Mo20W)/Les10',['Les10'],'K0801').
genotype(3451,405,'11R405:M0044503',1354,'11R1354:0022210','M14','M14','W23/+','W23/Les10',['Les10'],'K2606').
genotype(3452,305,'11R305:W0052114',3269,'11R3269:0022402','W23','W23','W23','Les11',['Les11'],'K0901').
genotype(3453,305,'11R305:W0050613',3223,'11R3223:0022910','W23','W23','W23','(Mo20W/+)/Les12',['Les12'],'K1001').
genotype(3454,205,'11R205:S0050111',1255,'11R1255:0023108','Mo20W','Mo20W','Mo20W','(W23/+)/Les12',['Les12'],'K2711').
genotype(3455,305,'11R305:W0046601',3294,'11R3294:0023209','W23','W23','W23','W23/Les12',['Les12'],'K2711').
genotype(3456,305,'11R305:W0052115',3271,'11R3271:0024506','W23','W23','W23','(W23/M14)/Les15-N2007',['Les15-N2007'],'K6711').
genotype(3457,205,'11R205:S0051609',3222,'11R3222:0024713','Mo20W','Mo20W','Mo20W','Les17',['Les17'],'K1309').
genotype(3458,405,'11R405:M0051001',2064,'11R2064:0024906','M14','M14','M14','Les17',['Les17'],'K1309').
genotype(3459,205,'11R205:S0051615',3206,'11R3206:0025006','Mo20W','Mo20W','Mo20W','(Mo20W/W23)/Les17',['Les17'],'K3007').
genotype(3460,305,'11R305:W0052104',3274,'11R3274:0054302','W23','W23','W23','Les17',['Les17'],'K3007').
genotype(3461,305,'11R305:W0050615',3193,'11R3193:0025414','W23','W23','W23','(Mo20W/+)/Les18',['Les18'],'K1411').
genotype(3462,405,'10R405:M0006311',3050,'10R3050:0033003','M14','M14','M14','(Mo20W/+)/Les18',['Les18'],'K1411').
genotype(3463,205,'11R205:S0051613',3209,'11R3209:0025615','Mo20W','Mo20W','Mo20W','W23/Les18',['Les18'],'K3106').
genotype(3464,305,'11R305:W0051906',3275,'11R3275:0025705','W23','W23','W23','Les18',['Les18'],'K3106').
genotype(3465,305,'11R305:W0052117',3315,'11R3315:0026009','W23','W23','W23','(W23/Mo20W)/Les19',['Les19'],'K1506').
genotype(3466,405,'11R405:M0050713',3290,'11R3290:0026101','M14','M14','M14','(M14/Mo20W)/Les19',['Les19'],'K1506').
genotype(3467,405,'11R405:M0050307',3298,'11R3298:0026705','M14','M14','M14','(M14/+)/Les20-N2457',['Les20-N2457'],'K7110').
genotype(3468,305,'11R305:W0050617',3211,'11R3211:0027004','W23','W23','W23','Les21',['Les21'],'K3311').
genotype(3469,405,'11R405:M0050712',3216,'11R3216:0027110','M14','M14','M14','W23/Les21',['Les21'],'K3311').
genotype(3470,305,'11R305:W0049801',3198,'11R3198:0027304','W23','W23','W23','(B73 Ht1/+)/Les21-N1442',['Les21-N1442'],'K7205').
genotype(3471,405,'11R405:M0051014',3199,'11R3199:0027405','M14','M14','M14','(B73 Ht1/+)/Les21-N1442',['Les21-N1442'],'K7205').
genotype(3472,205,'11R205:S0049003',164,'11R0164:0027606','Mo20W','Mo20W','?','?/Les28',['Les28'],'K16400').
genotype(3473,305,'11R305:W0049106',164,'11R0164:0027606','W23','W23','?','?/Les28',['Les28'],'K16400').
genotype(3474,405,'11R405:M0044614',164,'11R0164:0027606','M14','M14','?','?/Les28',['Les28'],'K16400').
genotype(3475,205,'11R205:S0044008',184,'11R0184:0028804','Mo20W','Mo20W','H95/CML228','?/Rp1-D21',['Rp1-D21'],'K18404').
genotype(3476,305,'11R305:W0044704',184,'11R0184:0028804','W23','W23','H95/CML228','?/Rp1-D21',['Rp1-D21'],'K18404').
genotype(3477,405,'11R405:M0044205',184,'11R0184:0028804','M14','M14','H95/CML228','?/Rp1-D21',['Rp1-D21'],'K18404').
genotype(3478,305,'11R305:W0050909',3325,'11R3325:0029504','W23','W23','W23','Les*-mi1',['Les*-mi1'],'K12205').
genotype(3479,405,'11R405:M0050703',3326,'11R3326:0029601','M14','M14','M14','Les*-mi1',['Les*-mi1'],'K12205').
genotype(3480,305,'11R305:W0047412',2078,'11R2078:0029804','W23','W23','M14','((C-13/AG32)/?))/Les-EC91',['Les-EC91'],'K11703').
genotype(3481,405,'11R405:M0049911',2078,'11R2078:0029804','M14','M14','M14','((C-13/AG32)/?))/Les-EC91',['Les-EC91'],'K11703').
genotype(3482,305,'11R305:W0044403',3318,'11R3318:0030005','W23','W23','W23','(W23/(CM105/Oh43E))/Les*-N1378',['Les*-N1378'],'K7403').
genotype(3483,405,'11R405:M0050702',3319,'11R3319:0030104','M14','M14','M14','(M14/(CM105/Oh43E))/Les*-N1378',['Les*-N1378'],'K7403').
genotype(3484,205,'11R205:S0050201',1522,'11R1522:0030204','Mo20W','Mo20W','Mo20W','(B73 Ht1/Mo17)/Les*-N2320',['Les*-N2320'],'K8114').
genotype(3485,305,'11R305:W0045019',1554,'11R1554:0030303','W23','W23','W23','(B73 Ht1/Mo17)/Les*-N2320',['Les*-N2320'],'K8114').
%
% don''t know why I identified this as Les2:  06N row 192 is Les*-N2397 in the spreadsheet.  The family is really
% 2955.
%
% Kazic, 31.12.2011
%
% genotype(3486,201,'06N201:S0014305',1434,'06N1434:0019201','Mo20W','Mo20W','Mo20W','W23/Les2',['Les2'],'K2002').
genotype(3487,205,'11R205:S0049014',3233,'11R3233:0030704','Mo20W','Mo20W','M14','(M14/+)/Les*-N2397',['Les*-N2397'],'K8414').
genotype(3488,305,'11R305:W0049403',3277,'11R3277:0030610','W23','W23','W23','Les*-N2397',['Les*-N2397'],'K8414').
genotype(3489,405,'11R405:M0044608',3233,'11R3233:0030704','M14','M14','M14','(M14/+)/Les*-N2397',['Les*-N2397'],'K8414').
genotype(3490,205,'11R205:S0051808',3278,'11R3278:0055203','Mo20W','Mo20W','Mo20W','Les*-N2418',['Les*-N2418'],'K8501').
genotype(3491,305,'11R305:W0045917',3173,'11R3173:0031405','W23','W23','W23','(B73/Mo17)/Les*-N2420',['Les*-N2420'],'K13902').
genotype(3492,305,'11R305:W0043515',3322,'11R3322:0031709','W23','W23','W23','(Mo20W/(B73 Ht1/Mo17))/Les*-NA7145',['Les*-NA7145'],'K9113').
genotype(3493,305,'11R305:W0045918',3099,'11R3099:0032207','W23','W23','W23','LesLA/+',['LesLA'],'K17307').
genotype(3494,205,'11R205:S0049711',3175,'11R3175:0033104','Mo20W','Mo20W','Mo20W','N/D10',['D10'],'K14510').
genotype(3495,305,'11R305:W0049116',3177,'11R3177:0033209','W23','W23','W23','N/D10',['D10'],'K14510').
genotype(3496,305,'11R305:W0050902',3179,'11R3179:0033303','W23','W23','M14','N/D10',['D10'],'K14510').
genotype(3497,1057,'09R1057:0006404',1057,'09R1057:0006404','Mo20W','Mo20W/{+|les23}','Mo20W','Mo20W/{+|les23}',[les23],'K1802').
genotype(3498,3244,'11R3244:0007302',3244,'11R3244:0007302','W23','W23/{Mo20W|les23}','W23','W23/{Mo20W|les23}',[les23],'K1802').
genotype(3499,3244,'11R3244:0007303',3244,'11R3244:0007303','W23','W23/{Mo20W|les23}','W23','W23/{Mo20W|les23}',[les23],'K1802').
genotype(3500,3245,'11R3245:0007602',3245,'11R3245:0007602','M14','M14/{Mo20W|les23}','M14','M14/{Mo20W|les23}',[les23],'K1802').
genotype(3501,3245,'11R3245:0007603',3245,'11R3245:0007603','M14','M14/les23','M14','M14/les23',[les23],'K1802').
genotype(3502,3245,'11R3245:0007605',3245,'11R3245:0007605','M14','M14/{Mo20W|les23}','M14','M14/{Mo20W|les23}',[les23],'K1802').
genotype(3503,3291,'11R3291:0007513',3291,'11R3291:0007513','W23','{+|les23}','W23','{+|les23}',[les23],'K1804').
genotype(3504,3291,'11R3291:0007514',3291,'11R3291:0007514','W23','{+|les23}','W23','{+|les23}',[les23],'K1804').
genotype(3505,3292,'11R3292:0007401',3292,'11R3292:0007401','M14','{+|les23}','M14','{+|les23}',[les23],'K1804').
genotype(3506,3292,'11R3292:0007403',3292,'11R3292:0007403','M14','{+|les23}','M14','{+|les23}',[les23],'K1804').
genotype(3507,3292,'11R3292:0007408',3292,'11R3292:0007408','M14','{+|les23}','M14','{+|les23}',[les23],'K1804').
genotype(3508,3217,'11R3217:0007703',3217,'11R3217:0007703','M14','{+|les23}','M14','{+|les23}',[les23],'K3514').
genotype(3509,3217,'11R3217:0007704',3217,'11R3217:0007704','M14','{+|les23}','M14','{+|les23}',[les23],'K3514').
genotype(3510,3217,'11R3217:0007707',3217,'11R3217:0007707','M14','{+|les23}','M14','{+|les23}',[les23],'K3514').
genotype(3511,405,'11R405:M0049509',3145,'11R3145:0034802','M14','M14','les*-N1395C','les*-N1395C',['les*-N1395C'],'K7501').
genotype(3512,405,'11R405:M0048601',3145,'11R3145:0034803','M14','M14','les*-N1395C','les*-N1395C',['les*-N1395C'],'K7501').
%
% This is the original fact:  David Braun''s numerical genotype has the field designator, in this
% case C.  But of course, this doesn''t work for computing the indices.  So I have morphed this into
% 11r row 900 --- which didn''t exist --- with corresponding packet and index facts, so that the pedigree
% will be correctly calculated.
%
% Kazic, 3.5.2012
%
% genotype(3513,205,'11R205:S0051802',628,'11R0628:0C54605','Mo20W','Mo20W','B73','?/les*-B1',['les*-B1'],'K62805').
%
%
genotype(3513,205,'11R205:S0051802',628,'11R0628:0090005','Mo20W','Mo20W','B73','?/les*-B1',['les*-B1'],'K62805').
%
%
genotype(3514,205,'11R205:S0049610',106,'11R0106:0038802','Mo20W','Mo20W','+/lls1','+/lls1',[lls1],'K10602').
genotype(3515,305,'11R305:W0044109',106,'11R0106:0038802','W23','W23','+/lls1','+/lls1',[lls1],'K10602').
genotype(3516,305,'11R305:W0052113',3158,'11R3158:0037912','W23','W23','{+|les23}','{+|les23}',[les23],'K3514').
genotype(3517,205,'11R205:S0043414',163,'11R0163:0037006','Mo20W','Mo20W',les23,les23,[les23],'K16306').
genotype(3518,305,'11R305:W0046906',163,'11R0163:0037006','W23','W23',les23,les23,[les23],'K16306').
genotype(3519,405,'11R405:M0046510',163,'11R0163:0037006','M14','M14',les23,les23,[les23],'K16306').


% somehow this was missed before, so inserted manually
%
% Kazic, 31.12.2011

genotype(3520,405,'11R405:M0051305',3302,'11R3302:0053805','M14','M14','M14','Les2',['Les2'],'K0203').
genotype(3521,205,'11R205:S0051815',3312,'11R3312:0021806','Mo20W','Mo20W','Mo20W','Les10',['Les10'],'K0801').






% 12r


genotype(3486,405,'10R405:M0000715',2254,'10R2254:0032002','M14','M14','M14','(W23/M14)/(+/Les15-N2007)',['Les15-N2007'],'K6711').
genotype(3522,405,'10R405:M0000715',2254,'10R2254:0032002','M14','M14','M14','(W23/M14)/(+/Les15-N2007)',['Les15-N2007'],'K6711').
genotype(3523,192,'11R0192:0008802',205,'11R205:S0052001','Idf B Pl/W22','Idf B Pl/W22','Mo20W','Mo20W',['Mo20W'],'K19202').
genotype(3524,192,'11R0192:0008809',405,'11R405:M0051003','Idf B Pl/W22','Idf B Pl/W22','M14','M14',['M14'],'K19208').
genotype(3525,305,'11N305:W0041007',3503,'11N3503:0026412','W23','W23','W23/les23','W23/les23',[les23],'K1804').
genotype(3526,305,'11N305:W0041008',3503,'11N3503:0026410','W23','W23','W23/les23','W23/les23',[les23],'K1804').
genotype(3527,305,'11N305:W0039201',3498,'11N3498:0025811','W23','W23','W23/les23','W23/les23',[les23],'K1802').
genotype(3528,305,'11N305:W0039209',3498,'11N3498:0025812','W23','W23','W23/les23','W23/les23',[les23],'K1802').
genotype(3529,305,'11N305:W0039509',3498,'11N3498:0025805','W23','W23','W23/les23','W23/les23',[les23],'K1802').
genotype(3530,305,'11N305:W0035307',1932,'11N1932:0027601','W23','W23','lls1 121D','lls1 121D',['lls1 121D'],'K5302').
genotype(3531,405,'11N405:M0032104',1932,'11N1932:0027607','M14','M14','lls1 121D','lls1 121D',['lls1 121D'],'K5302').
genotype(3532,205,'11N205:S0031011',178,'11N0178:0027906','Mo20W','Mo20W','?/lls1-nk','?/lls1-nk',['lls1-nk'],'K17800').
genotype(3533,305,'11N305:W0041001',2167,'11N2167:0028204','W23','W23','W23/les*-N1395C','W23/les*-N1395C',['les*-N1395C'],'K7501').
genotype(3534,205,'11N205:S0030704',3148,'11N3148:0028703','Mo20W','Mo20W','les*-N2363A','les*-N2363A',['les*-N2363A'],'K8304').
genotype(3535,205,'11N205:S0030705',3148,'11N3148:0028707','Mo20W','Mo20W','les*-N2363A','les*-N2363A',['les*-N2363A'],'K8304').
genotype(3536,305,'11N305:W0031712',3148,'11N3148:0028707','W23','W23','les*-N2363A','les*-N2363A',['les*-N2363A'],'K8304').
genotype(3537,305,'11N305:W0032004',3148,'11N3148:0028703','W23','W23','les*-N2363A','les*-N2363A',['les*-N2363A'],'K8304').
genotype(3538,405,'11N405:M0031204',3148,'11N3148:0028703','M14','M14','les*-N2363A','les*-N2363A',['les*-N2363A'],'K8304').
genotype(3539,405,'11N405:M0031205',3148,'11N3148:0028707','M14','M14','les*-N2363A','les*-N2363A',['les*-N2363A'],'K8304').
genotype(3540,305,'11N305:W0039504',3134,'11N3134:0028805','W23','W23','les*-N2502','les*-N2502',['les*-N2502'],'K8709').
genotype(3541,305,'11N305:W0039505',3134,'11N3134:0028805','W23','W23','les*-N2502','les*-N2502',['les*-N2502'],'K8709').
genotype(3542,205,'11N205:S0031010',3110,'11N3110:0028502','Mo20W','Mo20W','(B73/AG32)/(Ht1/les*-N2333A)','(B73/AG32)/(Ht1/les*-N2333A)',['les*-N2333A'],'K8210').
genotype(3543,405,'11N405:M0032405',3110,'11N3110:0028502','M14','M14','(B73/AG32)/(Ht1/les*-N2333A)','(B73/AG32)/(Ht1/les*-N2333A)',['les*-N2333A'],'K8210').
genotype(3544,305,'11R305:W0047417',153,'11R0153:0041805','W23','W23','+/nec2-8147','+/nec2-8147',['nec2-8147'],'K15300').
genotype(3545,405,'11R405:M0044204',153,'11R0153:0041805','M14','M14','+/nec2-8147','+/nec2-8147',['nec2-8147'],'K15300').
genotype(3546,305,'11N305:W0040101',3129,'11N3129:0029304','W23','W23','nec*-6853','nec*-6853',['nec*-6853'],'K10712').
genotype(3547,305,'11N305:W0040102',3129,'11N3129:0029304','W23','W23','nec*-6853','nec*-6853',['nec*-6853'],'K10712').
genotype(3548,405,'11N405:M0035702',3129,'11N3129:0029304','M14','M14','nec*-6853','nec*-6853',['nec*-6853'],'K10712').
genotype(3549,405,'11N405:M0035703',3129,'11N3129:0029304','M14','M14','nec*-6853','nec*-6853',['nec*-6853'],'K10712').
genotype(3550,205,'11N205:S0036707',1010,'11N1010:0006302','Mo20W','Mo20W','Mo20W','Mo20W/Les1',['Les1'],'K0104').
genotype(3551,305,'11N305:W0036202',1279,'11N1279:0006403','W23','W23','W23','Mo20W/Les1',['Les1'],'K0104').
genotype(3552,405,'11N405:M0037206',1601,'11N1601:0006504','M14','M14','M14','Mo20W/Les1',['Les1'],'K0104').
genotype(3553,205,'11N205:S0036610',3360,'11N3360:0006704','Mo20W','Mo20W','Mo20W','Les1',['Les1'],'K0106').
genotype(3554,305,'11N305:W0036201',3394,'11N3394:0006905','W23','W23','W23','Mo20W/Les1',['Les1'],'K0106').
genotype(3555,205,'11N205:S0036701',3396,'11N3396:0007301','Mo20W','Mo20W','Mo20W','(Mo20W/W23)/Les1',['Les1'],'K1903').
genotype(3556,305,'11N305:W0031406',3397,'11N3397:0007404','W23','W23','W23','Les1',['Les1'],'K1903').
genotype(3557,405,'11N405:M0034805',3398,'11N3398:0007503','M14','M14','M14','Les1',['Les1'],'K1903').
genotype(3558,205,'11N205:S0038208',3399,'11N3399:0007708','Mo20W','Mo20W','Mo20W','Mo20W/Les2)',['Les2'],'K0202').
genotype(3559,305,'11N305:W0031410',3400,'11N3400:0007805','W23','W23','W23','Mo20W/Les2)',['Les2'],'K0202').
genotype(3560,405,'11N405:M0038406',3401,'11N3401:0007903','M14','M14','M14','Mo20W/Les2)',['Les2'],'K0202').
genotype(3561,205,'11N205:S0037906',3402,'11N3402:0008110','Mo20W','Mo20W','Mo20W','Les2',['Les2'],'K0203').
genotype(3562,501,'11N501:B0030601',3402,'11N3402:0008110','B73','B73','Mo20W','Les2',['Les2'],'K0203').
genotype(3563,3402,'11N3402:0008109',3402,'11N3402:0008109','Mo20W','Les2','Mo20W','Les2',['Les2'],'K0203').
genotype(3564,3402,'11N3402:0008110',3402,'11N3402:0008110','Mo20W','Les2','Mo20W','Les2',['Les2'],'K0203').
genotype(3565,3402,'11N3402:0008111',3402,'11N3402:0008111','Mo20W','Les2','Mo20W','Les2',['Les2'],'K0203').
genotype(3566,305,'11N305:W0031411',3403,'11N3403:0008209','W23','W23','W23','Les2',['Les2'],'K0203').
genotype(3567,205,'11N205:S0031905',1631,'11N1631:0008603','Mo20W','Mo20W','Mo20W','Les2',['Les2'],'K0207').
genotype(3568,305,'11N305:W0038002',3405,'11N3405:0008710','W23','W23','W23','(W23/Mo20W)/Les2',['Les2'],'K0207').
genotype(3569,405,'11N405:M0038502',3406,'11N3406:0008801','M14','M14','M14','Mo20W/Les2',['Les2'],'K0207').
genotype(3570,205,'11N205:S0037001',3407,'11N3407:0008906','Mo20W','Mo20W','Mo20W','Les2',['Les2'],'K2002').
genotype(3571,305,'11N305:W0031109',3408,'11N3408:0009003','W23','W23','W23','Les2',['Les2'],'K2002').
genotype(3572,3408,'11N3408:0009003',3408,'11N3408:0009003','W23','Les2','W23','Les2',['Les2'],'K2002').
genotype(3573,3408,'11N3408:0009005',3408,'11N3408:0009005','W23','Les2','W23','Les2',['Les2'],'K2002').
genotype(3574,3408,'11N3408:0009009',3408,'11N3408:0009009','W23','Les2','W23','Les2',['Les2'],'K2002').
genotype(3575,405,'11N405:M0031306',3250,'11N3250:0009103','M14','M14','M14','Les2',['Les2'],'K2002').
genotype(3576,205,'11N205:S0039013',3300,'11N3300:0009312','Mo20W','Mo20W','Mo20W','Les2-N845A',['Les2-N845A'],'K5515').
genotype(3577,305,'11N305:W0033501',3410,'11N3410:0009409','W23','W23','W23','Les2-N845A',['Les2-N845A'],'K5515').
genotype(3578,405,'11N405:M0039302',1229,'11N1229:0009501','M14','M14','M14','Les2-N845A',['Les2-N845A'],'K5515').
genotype(3579,201,'09R201:S0040801',2213,'09R2213:0015603','Mo20W','Mo20W','+/Les3-GJ','+/Les3-GJ',['Les3-GJ'],'K11903').
genotype(3580,301,'09R301:W0041613',2213,'09R2213:0015603','W23','W23','+/Les3-GJ','+/Les3-GJ',['Les3-GJ'],'K11903').
genotype(3581,401,'09R401:M0040504',2213,'09R2213:0015603','M14','M14','+/Les3-GJ','+/Les3-GJ',['Les3-GJ'],'K11903').
genotype(3582,205,'11N205:S0039001',3303,'11N3303:0009708','Mo20W','Mo20W','Mo20W','Les4',['Les4'],'K0302').
genotype(3583,305,'11N305:W0038601',3412,'11N3412:0009809','W23','W23','W23','Les4',['Les4'],'K0302').
genotype(3584,405,'11N405:M0034004',3413,'11N3413:0009901','M14','M14','M14','Les4',['Les4'],'K0302').
genotype(3585,205,'11N205:S0037805',3251,'11N3251:0010201','Mo20W','Mo20W','Mo20W','Les4',['Les4'],'K0303').
genotype(3586,305,'11N305:W0038309',3415,'11N3415:0010308','W23','W23','W23','Les4',['Les4'],'K0303').
genotype(3587,405,'11N405:M0037307',3416,'11N3416:0010410','M14','M14','M14','Les4',['Les4'],'K0303').
genotype(3588,205,'11N205:S0031807',3417,'11N3417:0010510','Mo20W','Mo20W','Mo20W','Les4',['Les4'],'K2101').
genotype(3589,305,'11N305:W0031107',3418,'11N3418:0010608','W23','W23','W23','Les4',['Les4'],'K2101').
%
% this has a flip in the last two digits of the male''s family, so corrected.
%
% Kazic, 14.7.2013
%
% genotype(3590,405,'11N405:M0032808',3491,'11N3491:0010704','M14','M14','M14','Les4',['Les4'],'K2101').
%
genotype(3590,405,'11N405:M0032808',3419,'11N3419:0010704','M14','M14','M14','Les4',['Les4'],'K2101').
genotype(3591,205,'11N205:S0037811',3420,'11N3420:0010807','Mo20W','Mo20W','Mo20W','Les4',['Les4'],'K2106').
genotype(3592,305,'11N305:W0034711',3421,'11N3421:0010904','W23','W23','W23','Les4',['Les4'],'K2106').
genotype(3593,405,'11N405:M0035707',3422,'11N3422:0011002','M14','M14','M14','Les4',['Les4'],'K2106').
genotype(3594,305,'11N305:W0040406',3423,'11N3423:0011510','W23','W23','Mo20W','M14/(?/Les5)',['Les5'],'K11603').
genotype(3595,405,'11N405:M0039601',3423,'11N3423:0011510','M14','M14','Mo20W','M14/(?/Les5)',['Les5'],'K11603').
genotype(3596,205,'11N205:S0034210',3430,'11N3430:0012501','Mo20W','Mo20W','Mo20W','Mo20W/(?/Les5-GJ)',['Les5-GJ'],'K16009').
genotype(3597,305,'11N305:W0041304',3430,'11N3430:0012501','W23','W23','Mo20W','Mo20W/(?/Les5-GJ)',['Les5-GJ'],'K16009').
genotype(3598,405,'11N405:M0037607',3430,'11N3430:0012501','M14','M14','Mo20W','Mo20W/(?/Les5-GJ)',['Les5-GJ'],'K16009').
genotype(3599,205,'11N205:S0038704',3433,'11N3433:0012802','Mo20W','Mo20W','Mo20W','Les6',['Les6'],'K0403').
genotype(3600,305,'11N305:W0031105',3434,'11N3434:0012906','W23','W23','W23','Les6',['Les6'],'K0403').
genotype(3601,205,'11N205:S0032702',3435,'11N3435:0013101','Mo20W','Mo20W','Mo20W','Les6',['Les6'],'K2202').
genotype(3602,305,'11N305:W0030804',3436,'11N3436:0013209','W23','W23','W23','Les6',['Les6'],'K2202').
genotype(3603,405,'11N405:M0035705',3437,'11N3437:0013304','M14','M14','M14','Les6',['Les6'],'K2202').
genotype(3604,205,'11N205:S0038707',3438,'11N3438:0013407','Mo20W','Mo20W','Mo20W','Les6',['Les6'],'K2212').
genotype(3605,305,'11N305:W0037108',3257,'11N3257:0013507','W23','W23','W23','Les6',['Les6'],'K2212').
genotype(3606,205,'11N205:S0035511',3226,'11N3226:0013712','Mo20W','Mo20W','Mo20W','Les7',['Les7'],'K0509').
genotype(3607,305,'11N305:W0030810',3192,'11N3192:0013803','W23','W23','W23','Les7',['Les7'],'K0509').
genotype(3608,405,'11N405:M0036102',3260,'11N3260:0013903','M14','M14','M14','Les7',['Les7'],'K0509').
genotype(3609,205,'11N205:S0032703',3441,'11N3441:0014209','Mo20W','Mo20W','Mo20W','W23/Les7',['Les7'],'K2312').
genotype(3610,405,'11N405:M0032801',3214,'11N3214:0014406','M14','M14','M14','Les7',['Les7'],'K2312').
genotype(3611,205,'11N205:S0033108',3442,'11N3442:0014507','Mo20W','Mo20W','Mo20W','Les8',['Les8'],'K0604').
genotype(3612,305,'11N305:W0031104',3443,'11N3443:0014607','W23','W23','W23','Les8',['Les8'],'K0604').
genotype(3613,205,'11N205:S0036702',3207,'11N3207:0014807','Mo20W','Mo20W','Mo20W','W23/Les8',['Les8'],'K2405').
genotype(3614,305,'11N305:W0033807',3203,'11N3203:0014901','W23','W23','W23','Les8',['Les8'],'K2405').
genotype(3615,405,'11N405:M0032803',3444,'11N3444:0015007','M14','M14','M14','Les8',['Les8'],'K2405').
genotype(3616,205,'11N205:S0036710',3445,'11N3445:0015105','Mo20W','Mo20W','Mo20W','Les9',['Les9'],'K0707').
genotype(3618,405,'11N405:M0032804',3265,'11N3265:0015305','M14','M14','M14','Les9',['Les9'],'K0707').
genotype(3619,205,'11N205:S0033004',3204,'11N3204:0015610','Mo20W','Mo20W','Mo20W','W23/Les9',['Les9'],'K2506').
genotype(3620,305,'11N305:W0031103',3266,'11N3266:0015709','W23','W23','W23','Les9',['Les9'],'K2506').
genotype(3621,405,'11N405:M0036002',3448,'11N3448:0015805','M14','M14','M14','Les9',['Les9'],'K2506').
genotype(3622,205,'11R205:S0051607',3312,'11R3312:0021808','Mo20W','Mo20W','Mo20W','Les10',['Les10'],'K0801').
genotype(3623,305,'11N305:W0031102',3450,'11N3450:0016009','W23','W23','W23','Les10',['Les10'],'K0801').
genotype(3624,405,'10R405:M0006301',1024,'10R1024:0029701','M14','M14','Mo20W/+','Mo20W/Les10',['Les10'],'K0801').
genotype(3625,305,'11N305:W0036206',3268,'11N3268:0016306','W23','W23','W23','Les10',['Les10'],'K2606').
genotype(3626,205,'11N205:S0033105',3286,'11N3286:0016502','Mo20W','Mo20W','Mo20W','Les11',['Les11'],'K0901').
genotype(3627,305,'11N305:W0032306',3452,'11N3452:0016609','W23','W23','W23','Les11',['Les11'],'K0901').
genotype(3628,405,'11N405:M0033301',3287,'11N3287:0016706','M14','M14','M14','Les11',['Les11'],'K0901').
genotype(3629,205,'11N205:S0034308',3189,'11N3189:0016809','Mo20W','Mo20W','Mo20W','Les12',['Les12'],'K1001').
genotype(3630,305,'11N305:W0032003',3453,'11N3453:0016911','W23','W23','W23','(W23/Mo20W)/Les12',['Les12'],'K1001').
genotype(3631,405,'11N405:M0032807',3288,'11N3288:0017001','M14','M14','M14','Les12',['Les12'],'K1001').
genotype(3632,305,'11N305:W0032005',3455,'11N3455:0017207','W23','W23','W23','Les12',['Les12'],'K2711').
genotype(3633,405,'11N405:M0033302',3328,'11N3328:0017301','M14','M14','M14','Les12',['Les12'],'K2711').
genotype(3634,205,'11N205:S0033106',3221,'11N3221:0017405','Mo20W','Mo20W','Mo20W','Les13',['Les13'],'K1109').
genotype(3635,305,'11N305:W0031706',2532,'11N2532:0017513','W23','W23','W23','Mo20W/Les13',['Les13'],'K1109').
genotype(3636,405,'11N405:M0031304',3289,'11N3289:0017601','M14','M14','M14','Les13',['Les13'],'K1109').
genotype(3637,205,'11N205:S0035510',3201,'11N3201:0017710','Mo20W','Mo20W','Mo20W','W23/Les13',['Les13'],'K2805').
genotype(3638,305,'11N305:W0036205',3296,'11N3296:0017808','W23','W23','W23','Les13',['Les13'],'K2805').
genotype(3639,305,'11N305:W0031403',3273,'11N3273:0018408','W23','W23','W23','Les17',['Les17'],'K1309').
genotype(3640,405,'11N405:M0031203',3458,'11N3458:0018509','M14','M14','M14','Les17',['Les17'],'K1309').
genotype(3641,205,'11N205:S0035401',3459,'11N3459:0018610','Mo20W','Mo20W','Mo20W','Les17',['Les17'],'K3007').
genotype(3642,305,'11N305:W0037102',3460,'11N3460:0018704','W23','W23','W23','Les17',['Les17'],'K3007').
genotype(3643,205,'11N205:S0035504',3224,'11N3224:0018911','Mo20W','Mo20W','Mo20W','Les18',['Les18'],'K1411').
genotype(3644,305,'11N305:W0032301',3461,'11N3461:0019006','W23','W23','W23','(W23/Mo20W)/Les18',['Les18'],'K1411').
genotype(3645,405,'11N405:M0033708',3462,'11N3462:0019208','M14','M14','M14','(M14/Mo20W)/Les18',['Les18'],'K1411').
genotype(3646,205,'11N205:S0033101',3463,'11N3463:0019304','Mo20W','Mo20W','Mo20W','(Mo20W/W23)/Les18',['Les18'],'K3106').
genotype(3647,305,'11N305:W0031405',3464,'11N3464:0019405','W23','W23','W23','Les18',['Les18'],'K3106').
genotype(3648,405,'11N405:M0037605',3314,'11N3314:0019505','M14','M14','M14','W23/Les18',['Les18'],'K3106').
genotype(3649,205,'11N205:S0033110',3194,'11N3194:0019611','Mo20W','Mo20W','Mo20W','Les19',['Les19'],'K1506').
genotype(3650,305,'11N305:W0035907',3465,'11N3465:0019709','W23','W23','W23','Les19',['Les19'],'K1506').
genotype(3651,405,'11N405:M0033303',3466,'11N3466:0019807','M14','M14','M14','Les19',['Les19'],'K1506').
genotype(3652,205,'11N205:S0034204',3210,'11N3210:0019909','Mo20W','Mo20W','Mo20W','Les19',['Les19'],'K3206').
genotype(3653,305,'11N305:W0032602',3276,'11N3276:0020005','W23','W23','W23','Les19',['Les19'],'K3206').
genotype(3654,305,'11N305:W0032902',3316,'11N3316:0020303','W23','W23','W23','Les20-N2457',['Les20-N2457'],'K7110').
genotype(3655,205,'11N205:S0031809',3215,'11N3215:0020511','Mo20W','Mo20W','Mo20W','W23/Les21',['Les21'],'K3311').
genotype(3656,305,'11N305:W0034102',3468,'11N3468:0020608','W23','W23','W23','Les21',['Les21'],'K3311').
genotype(3657,205,'11N205:S0031909',3197,'11N3197:0020806','Mo20W','Mo20W','Mo20W','(B73 Ht1/+)/Les21-N1442',['Les21-N1442'],'K7205').
genotype(3658,305,'11N305:W0032302',3470,'11N3470:0020907','W23','W23','W23','(W23/B73 Ht1)/Les21-N1442',['Les21-N1442'],'K7205').
genotype(3659,405,'11N405:M0037202',3471,'11N3471:0021006','M14','M14','M14','(M14/B73 Ht1)/Les21-N1442',['Les21-N1442'],'K7205').
genotype(3660,3472,'11N3472:0021101',3472,'11N3472:0021101','Mo20W','(?/?)/Les28','Mo20W','(?/?)/Les28',['Les28'],'K16400').
genotype(3661,3472,'11N3472:0021106',3472,'11N3472:0021106','Mo20W','(?/?)/Les28','Mo20W','(?/?)/Les28',['Les28'],'K16400').
genotype(3662,3472,'11N3472:0021107',3472,'11N3472:0021107','Mo20W','(?/?)/Les28','Mo20W','(?/?)/Les28',['Les28'],'K16400').
genotype(3663,3472,'11N3472:0021111',3472,'11N3472:0021111','Mo20W','(?/?)/Les28','Mo20W','(?/?)/Les28',['Les28'],'K16400').
genotype(3664,3473,'11N3473:0021201',3473,'11N3473:0021201','W23','(?/?)/Les28','W23','(?/?)/Les28',['Les28'],'K16400').
genotype(3665,3473,'11N3473:0021202',3473,'11N3473:0021202','W23','(?/?)/Les28','W23','(?/?)/Les28',['Les28'],'K16400').
genotype(3666,3473,'11N3473:0021206',3473,'11N3473:0021206','W23','(?/?)/Les28','W23','(?/?)/Les28',['Les28'],'K16400').
genotype(3667,3474,'11N3474:0021306',3474,'11N3474:0021306','M14','(?/?)/Les28','M14','(?/?)/Les28',['Les28'],'K16400').
genotype(3668,3474,'11N3474:0021308',3474,'11N3474:0021308','M14','(?/?)/Les28','M14','(?/?)/Les28',['Les28'],'K16400').
genotype(3669,3474,'11N3474:0021311',3474,'11N3474:0021311','M14','(?/?)/Les28','M14','(?/?)/Les28',['Les28'],'K16400').
genotype(3670,3474,'11N3474:0021312',3474,'11N3474:0021312','M14','(?/?)/Les28','M14','(?/?)/Les28',['Les28'],'K16400').
genotype(3671,205,'11N205:S0031506',3086,'11N3086:0021405','Mo20W','Mo20W','Mo20W','(I54/Va35)/Les101',['Les101'],'K11802').
genotype(3672,305,'11N305:W0032605',3087,'11N3087:0021503','W23','W23','W23','(I54/Va35)/Les101',['Les101'],'K11802').
genotype(3673,405,'11N405:M0030910',3088,'11N3088:0021601','M14','M14','M14','(I54/Va35)/Les101',['Les101'],'K11802').
genotype(3674,205,'11N205:S0031510',3083,'11N3083:0021705','Mo20W','Mo20W','W23','(I-52/Va35)/Les102',['Les102'],'K12008').
genotype(3675,305,'11N305:W0040703',3083,'11N3083:0021706','W23','W23','W23','(I-52/Va35)/Les102',['Les102'],'K12008').
genotype(3676,405,'11N405:M0031307',3172,'11N3172:0021805','M14','M14','M14','(I-52/Va35)/Les102',['Les102'],'K12008').
genotype(3677,205,'11N205:S0033008',3317,'11N3317:0022808','Mo20W','Mo20W','Mo20W','Les*-N1378',['Les*-N1378'],'K7403').
genotype(3678,305,'11N305:W0032607',3482,'11N3482:0022907','W23','W23','W23','Les*-N1378',['Les*-N1378'],'K7403').
genotype(3679,405,'11N405:M0031210',3483,'11N3483:0023007','M14','M14','M14','Les*-N1378',['Les*-N1378'],'K7403').
genotype(3680,1154,'09R1154:0001501',1154,'09R1154:0001501','Mo20W','{+|Les*-N1450}','Mo20W','{+|Les*-N1450}',['Les*-N1450'],'K7601').
genotype(3681,1145,'09R1145:0001704',1145,'09R1145:0001704','Mo20W','{+|Les*-N1450}','Mo20W','{+|Les*-N1450}',['Les*-N1450'],'K7604').
genotype(3682,3074,'10R3074:0039001',3074,'10R3074:0039001','Mo20W','+/Les*-N1450','Mo20W','+/Les*-N1450',['Les*-N1450'],'K7606').
genotype(3683,1147,'09R1147:0002004',1147,'09R1147:0002004','Mo20W','{+|Les*-N1450}','Mo20W','{+|Les*-N1450}',['Les*-N1450'],'K7613').
genotype(3684,1151,'09R1151:0002102',1151,'09R1151:0002102','Mo20W','{+|Les*-N1450}','Mo20W','{+|Les*-N1450}',['Les*-N1450'],'K7614').
genotype(3685,1155,'09R1155:0002503',1155,'09R1155:0002503','Mo20W','{+|Les*-N1450}','Mo20W','{+|Les*-N1450}',['Les*-N1450'],'K7616').
genotype(3686,3075,'10R3075:0039107',3075,'10R3075:0039107','W23','+/Les*-N1450','W23','+/Les*-N1450',['Les*-N1450'],'K7606').
genotype(3687,1156,'09R1156:0002201',1156,'09R1156:0002201','W23','{+|Les*-N1450}','W23','{+|Les*-N1450}',['Les*-N1450'],'K7614').
genotype(3688,1160,'09R1160:0002603',1160,'09R1160:0002603','W23','{+|Les*-N1450}','W23','{+|Les*-N1450}',['Les*-N1450'],'K7616').
genotype(3689,1164,'09R1164:0001601',1164,'09R1164:0001601','M14','{+|Les*-N1450}','M14','{+|Les*-N1450}',['Les*-N1450'],'K7601').
genotype(3690,3076,'10R3076:0039205',3076,'10R3076:0039205','M14','+/Les*-N1450','M14','+/Les*-N1450',['Les*-N1450'],'K7606').
genotype(3691,1188,'09R1188:0001802',1188,'09R1188:0001802','M14','{+|Les*-N1450}','M14','{+|Les*-N1450}',['Les*-N1450'],'K7608').
genotype(3692,1176,'09R1176:0001902',1176,'09R1176:0001902','M14','{+|Les*-N1450}','M14','{+|Les*-N1450}',['Les*-N1450'],'K7611').
genotype(3693,1178,'09R1178:0002303',1178,'09R1178:0002303','M14','{+|Les*-N1450}','M14','{+|Les*-N1450}',['Les*-N1450'],'K7614').
genotype(3694,1186,'09R1186:0002702',1186,'09R1186:0002702','M14','{+|Les*-N1450}','M14','{+|Les*-N1450}',['Les*-N1450'],'K7616').
genotype(3695,205,'11N205:S0030712',3484,'11N3484:0023105','Mo20W','Mo20W','Mo20W','Les*-N2320',['Les*-N2320'],'K8114').
genotype(3696,305,'11N305:W0035901',3485,'11N3485:0023203','W23','W23','W23','Les*-N2320',['Les*-N2320'],'K8114').
genotype(3697,405,'11N405:M0030905',3060,'11N3060:0023309','M14','M14','M14','(B73 Ht1/Mo17)/Les*-N2320',['Les*-N2320'],'K8114').
genotype(3698,205,'11N205:S0030703',3487,'11N3487:0023502','Mo20W','Mo20W','Mo20W','M14/Les*-N2397',['Les*-N2397'],'K8414').
genotype(3699,305,'11N305:W0030805',3488,'11N3488:0023602','W23','W23','W23','Les*-N2397',['Les*-N2397'],'K8414').
genotype(3700,405,'11N405:M0037303',3489,'11N3489:0023703','M14','M14','M14','Les*-N2397',['Les*-N2397'],'K8414').
genotype(3701,205,'11N205:S0031513',3490,'11N3490:0023809','Mo20W','Mo20W','Mo20W','Les*-N2418',['Les*-N2418'],'K8501').
genotype(3702,305,'11N305:W0030801',3230,'11N3230:0023909','W23','W23','W23','Les*-N2418',['Les*-N2418'],'K8501').
genotype(3703,305,'11N305:W0034409',3491,'11N3491:0024111','W23','W23','W23','(W23/(B73/Mo17))/Les*-N2420',['Les*-N2420'],'K13902').
genotype(3704,305,'11N305:W0033202',3492,'11N3492:0024403','W23','W23','W23','(W23/Mo20W)/Les*-NA7145',['Les*-NA7145'],'K9113').
genotype(3705,3182,'11N3182:0024603',3182,'11N3182:0024603','W23','?/LesDS*-1','W23','?/LesDS*-1',['LesDS*-1'],'K16910').
genotype(3706,3182,'11N3182:0024606',3182,'11N3182:0024606','W23','?/LesDS*-1','W23','?/LesDS*-1',['LesDS*-1'],'K16910').
genotype(3707,3182,'11N3182:0024610',3182,'11N3182:0024610','W23','?/LesDS*-1','W23','?/LesDS*-1',['LesDS*-1'],'K16910').
genotype(3708,305,'11N305:W0038909',3480,'11N3480:0022603','W23','W23','W23','M14/((C-13/AG32)/?))/Les-EC91',['Les-EC91'],'K11703').
genotype(3709,405,'11N405:M0038403',3481,'11N3481:0022702','M14','M14','M14','M14/((C-13/AG32)/?))/Les-EC91',['Les-EC91'],'K11703').
genotype(3710,621,'11R0621:0009003',205,'11R205:S0052013','GRMZM2G157354_T03','GRMZM2G157354_T03','Mo20W','Mo20W',['Mo20W'],'K62103').
genotype(3711,621,'11R0621:0009005',205,'11R205:S0052002','GRMZM2G157354_T03','GRMZM2G157354_T03','Mo20W','Mo20W',['Mo20W'],'K62105').
genotype(3712,3098,'11N3098:0024702',3098,'11N3098:0024702','Mo20W','LesLA/+','Mo20W','LesLA/+',['LesLA'],'K17307').
genotype(3713,3098,'11N3098:0024703',3098,'11N3098:0024703','Mo20W','LesLA/+','Mo20W','LesLA/+',['LesLA'],'K17307').
genotype(3714,3098,'11N3098:0024704',3098,'11N3098:0024704','Mo20W','LesLA/+','Mo20W','LesLA/+',['LesLA'],'K17307').
genotype(3715,305,'11N305:W0032911',3446,'11N3446:0015213','W23','W23','W23','Les9',['Les9'],'K0707').
genotype(3716,3493,'11N3493:0024801',3493,'11N3493:0024801','W23','W23/(LesLA/+)','W23','W23/(LesLA/+)',['LesLA'],'K17307').
genotype(3717,3493,'11N3493:0024803',3493,'11N3493:0024803','W23','W23/(LesLA/+)','W23','W23/(LesLA/+)',['LesLA'],'K17307').
genotype(3718,3493,'11N3493:0024808',3493,'11N3493:0024808','W23','W23/(LesLA/+)','W23','W23/(LesLA/+)',['LesLA'],'K17307').
genotype(3719,3100,'11N3100:0024904',3100,'11N3100:0024904','M14','LesLA/+','M14','LesLA/+',['LesLA'],'K17307').
genotype(3720,3100,'11N3100:0024909',3100,'11N3100:0024909','M14','LesLA/+','M14','LesLA/+',['LesLA'],'K17307').
genotype(3721,3100,'11N3100:0024910',3100,'11N3100:0024910','M14','LesLA/+','M14','LesLA/+',['LesLA'],'K17307').
genotype(3722,205,'11N205:S0033007',3324,'11N3324:0022204','Mo20W','Mo20W','Mo20W','Les*-mi1',['Les*-mi1'],'K12205').
genotype(3723,305,'11N305:W0035908',3478,'11N3478:0022306','W23','W23','W23','Les*-mi1',['Les*-mi1'],'K12205').
genotype(3724,405,'11N405:M0031302',3479,'11N3479:0022401','M14','M14','M14','Les*-mi1',['Les*-mi1'],'K12205').
genotype(3725,305,'11N305:W0038906',3476,'11N3476:0022001','W23','W23','W23','(H95/CML228)/(?/Rp1-D21)',['Rp1-D21'],'K18404').
genotype(3726,405,'11N405:M0036007',3477,'11N3477:0022106','M14','M14','M14','(H95/CML228)/(?/Rp1-D21)',['Rp1-D21'],'K18404').
genotype(3727,305,'11N305:W0031702',3495,'11N3495:0025101','W23','W23','W23','D10',['D10'],'K14510').
genotype(3728,3516,'11N3516:0030204',3516,'11N3516:0030204','W23','W23/les23','W23','W23/les23',[les23],'K3514').
genotype(3729,3517,'11N3517:0030301',3517,'11N3517:0030301','Mo20W','Mo20W/les23','Mo20W','Mo20W/les23',[les23],'K16306').
genotype(3730,3517,'11N3517:0030304',3517,'11N3517:0030304','Mo20W','Mo20W/les23','Mo20W','Mo20W/les23',[les23],'K16306').
genotype(3731,3517,'11N3517:0030306',3517,'11N3517:0030306','Mo20W','Mo20W/les23','Mo20W','Mo20W/les23',[les23],'K16306').
genotype(3732,3518,'11N3518:0030401',3518,'11N3518:0030401','W23','W23/les23','W23','W23/les23',[les23],'K16306').
genotype(3733,3518,'11N3518:0030407',3518,'11N3518:0030407','W23','W23/les23','W23','W23/les23',[les23],'K16306').
genotype(3734,3518,'11N3518:0030410',3518,'11N3518:0030410','W23','W23/les23','W23','W23/les23',[les23],'K16306').
genotype(3735,3519,'11N3519:0030501',3519,'11N3519:0030501','M14','M14/les23','M14','M14/les23',[les23],'K16306').
genotype(3736,3519,'11N3519:0030502',3519,'11N3519:0030502','M14','M14/les23','M14','M14/les23',[les23],'K16306').
genotype(3737,3519,'11N3519:0030503',3519,'11N3519:0030503','M14','M14/les23','M14','M14/les23',[les23],'K16306').
genotype(3738,3280,'11N3280:0029704',3280,'11N3280:0029704','Mo20W','Mo20W/lls1','Mo20W','Mo20W/lls1',[lls1],'K1702').
genotype(3739,2686,'11N2686:0029803',2686,'11N2686:0029803','W23','Mo20W/lls1','W23','Mo20W/lls1',[lls1],'K1702').
genotype(3740,2686,'11N2686:0029805',2686,'11N2686:0029805','W23','Mo20W/lls1','W23','Mo20W/lls1',[lls1],'K1702').
genotype(3741,2686,'11N2686:0029806',2686,'11N2686:0029806','W23','Mo20W/lls1','W23','Mo20W/lls1',[lls1],'K1702').
genotype(3742,3281,'11N3281:0029902',3281,'11N3281:0029902','M14/lls1','M14/lls1','M14/lls1','M14/lls1',[lls1],'K1702').
genotype(3743,3281,'11N3281:0029903',3281,'11N3281:0029903','M14/lls1','M14/lls1','M14/lls1','M14/lls1',[lls1],'K1702').
genotype(3744,3281,'11N3281:0029904',3281,'11N3281:0029904','M14/lls1','M14/lls1','M14/lls1','M14/lls1',[lls1],'K1702').
genotype(3745,3514,'11N3514:0030001',3514,'11N3514:0030001','Mo20W','Mo20W/lls1','Mo20W','Mo20W/lls1',[lls1],'K10602').
genotype(3746,3514,'11N3514:0030002',3514,'11N3514:0030002','Mo20W','Mo20W/lls1','Mo20W','Mo20W/lls1',[lls1],'K10602').
genotype(3747,3514,'11N3514:0030004',3514,'11N3514:0030004','Mo20W','Mo20W/lls1','Mo20W','Mo20W/lls1',[lls1],'K10602').
genotype(3748,3515,'11N3515:0030104',3515,'11N3515:0030104','W23','W23/lls1','W23','W23/lls1',[lls1],'K10602').
genotype(3749,3515,'11N3515:0030106',3515,'11N3515:0030106','W23','W23/lls1','W23','W23/lls1',[lls1],'K10602').
genotype(3750,3515,'11N3515:0030108',3515,'11N3515:0030108','W23','W23/lls1','W23','W23/lls1',[lls1],'K10602').
genotype(3751,205,'11N205:S0030709',1370,'11N1370:0027510','Mo20W','Mo20W','W23/lls1 121D','W23/lls1 121D',['lls1 121D'],'K3402').
genotype(3752,205,'11N205:S0039002',1370,'11N1370:0027512','Mo20W','Mo20W','W23/lls1 121D','W23/lls1 121D',['lls1 121D'],'K3402').
genotype(3753,205,'11N205:S0039004',1370,'11N1370:0027511','Mo20W','Mo20W','W23/lls1 121D','W23/lls1 121D',['lls1 121D'],'K3402').
genotype(3754,305,'11N305:W0030803',1370,'11N1370:0027510','W23','W23','W23/lls1 121D','W23/lls1 121D',['lls1 121D'],'K3402').
genotype(3755,305,'11N305:W0038604',1370,'11N1370:0027512','W23','W23','W23/lls1 121D','W23/lls1 121D',['lls1 121D'],'K3402').
genotype(3756,305,'11N305:W0039206',1370,'11N1370:0027511','W23','W23','W23/lls1 121D','W23/lls1 121D',['lls1 121D'],'K3402').
genotype(3757,405,'11N405:M0032509',1370,'11N1370:0027511','M14','M14','W23/lls1 121D','W23/lls1 121D',['lls1 121D'],'K3402').
genotype(3758,405,'11N405:M0036109',1370,'11N1370:0027510','M14','M14','W23/lls1 121D','W23/lls1 121D',['lls1 121D'],'K3402').
genotype(3759,405,'11N405:M0036401',1370,'11N1370:0027512','M14','M14','W23/lls1 121D','W23/lls1 121D',['lls1 121D'],'K3402').
genotype(3760,3095,'11R3095:0005201',3095,'11R3095:0005201','W23','(B73 Ht1/Mo17)/les*-74-1820-6','W23','(B73 Ht1/Mo17)/les*-74-1820-6',['les*-74-1820-6'],'K14906').
genotype(3761,3095,'11R3095:0005203',3095,'11R3095:0005203','W23','(B73 Ht1/Mo17)/les*-74-1820-6','W23','(B73 Ht1/Mo17)/les*-74-1820-6',['les*-74-1820-6'],'K14906').
genotype(3762,3095,'11R3095:0005207',3095,'11R3095:0005207','W23','(B73 Ht1/Mo17)/les*-74-1820-6','W23','(B73 Ht1/Mo17)/les*-74-1820-6',['les*-74-1820-6'],'K14906').
genotype(3763,3243,'11R3243:0005303',3243,'11R3243:0005303','Mo20W','Mo20W/les*-74-1873-9','Mo20W','Mo20W/les*-74-1873-9',['les*-74-1873-9'],'K9304').
genotype(3764,3243,'11R3243:0005304',3243,'11R3243:0005304','Mo20W','Mo20W/les*-74-1873-9','Mo20W','Mo20W/les*-74-1873-9',['les*-74-1873-9'],'K9304').
genotype(3765,3243,'11R3243:0005305',3243,'11R3243:0005305','Mo20W','Mo20W/les*-74-1873-9','Mo20W','Mo20W/les*-74-1873-9',['les*-74-1873-9'],'K9304').
genotype(3766,1450,'09R1450:0000901',1450,'09R1450:0000901','W23','W23/les*-74-1873-9','W23','W23/les*-74-1873-9',['les*-74-1873-9'],'K9304').
genotype(3767,1450,'09R1450:0000903',1450,'09R1450:0000903','W23','W23/les*-74-1873-9','W23','W23/les*-74-1873-9',['les*-74-1873-9'],'K9304').
genotype(3768,1450,'09R1450:0000905',1450,'09R1450:0000905','W23','W23/les*-74-1873-9','W23','W23/les*-74-1873-9',['les*-74-1873-9'],'K9304').
genotype(3769,1848,'09R1848:0000403',1848,'09R1848:0000403','M14','M14/les*-74-1873-9','M14','M14/les*-74-1873-9',['les*-74-1873-9'],'K9304').
genotype(3770,1848,'09R1848:0000404',1848,'09R1848:0000404','M14','M14/les*-74-1873-9','M14','M14/les*-74-1873-9',['les*-74-1873-9'],'K9304').
genotype(3771,1848,'09R1848:0000408',1848,'09R1848:0000408','M14','M14/les*-74-1873-9','M14','M14/les*-74-1873-9',['les*-74-1873-9'],'K9304').
genotype(3772,3513,'11N3513:0029601',3513,'11N3513:0029601','Mo20W','(B73/?)/les*-B1','Mo20W','(B73/?)/les*-B1',['les*-B1'],'K62805').
genotype(3773,3513,'11N3513:0029603',3513,'11N3513:0029603','Mo20W','(B73/?)/les*-B1','Mo20W','(B73/?)/les*-B1',['les*-B1'],'K62805').
genotype(3774,3513,'11N3513:0029605',3513,'11N3513:0029605','Mo20W','(B73/?)/les*-B1','Mo20W','(B73/?)/les*-B1',['les*-B1'],'K62805').
genotype(3775,205,'11N205:S0031813',3118,'11N3118:0028101','Mo20W','Mo20W','Mo20W/les*-N1395C','Mo20W/les*-N1395C',['les*-N1395C'],'K7501').
genotype(3776,205,'11N205:S0037006',3118,'11N3118:0028113','Mo20W','Mo20W','Mo20W/les*-N1395C','Mo20W/les*-N1395C',['les*-N1395C'],'K7501').
genotype(3777,3512,'11N3512:0028402',3512,'11N3512:0028402','M14','M14/les*-N1395C','M14','M14/les*-N1395C',['les*-N1395C'],'K7501').
genotype(3778,3512,'11N3512:0028406',3512,'11N3512:0028406','M14','M14/les*-N1395C','M14','M14/les*-N1395C',['les*-N1395C'],'K7501').
genotype(3779,3079,'11R3079:0005403',3079,'11R3079:0005403','Mo20W','Mo20W/les*-N2012','Mo20W','Mo20W/les*-N2012',['les*-N2012'],'K7702').
genotype(3780,3080,'11R3080:0005503',3080,'11R3080:0005503','W23','W23/les*-N2012','W23','W23/les*-N2012',['les*-N2012'],'K7702').
genotype(3781,3080,'11R3080:0005504',3080,'11R3080:0005504','W23','W23/les*-N2012','W23','W23/les*-N2012',['les*-N2012'],'K7702').
genotype(3782,3080,'11R3080:0005508',3080,'11R3080:0005508','W23','W23/les*-N2012','W23','W23/les*-N2012',['les*-N2012'],'K7702').
genotype(3783,3081,'11R3081:0005604',3081,'11R3081:0005604','M14','M14/les*-N2012','M14','M14/les*-N2012',['les*-N2012'],'K7702').
genotype(3784,3081,'11R3081:0005605',3081,'11R3081:0005605','M14','M14/les*-N2012','M14','M14/les*-N2012',['les*-N2012'],'K7702').
genotype(3785,3081,'11R3081:0005607',3081,'11R3081:0005607','M14','M14/les*-N2012','M14','M14/les*-N2012',['les*-N2012'],'K7702').
genotype(3786,3237,'11R3237:0005707',3237,'11R3237:0005707','Mo20W','Mo20W/les*-N2013','Mo20W','Mo20W/les*-N2013',['les*-N2013'],'K7807').
genotype(3787,3237,'11R3237:0005708',3237,'11R3237:0005708','Mo20W','Mo20W/les*-N2013','Mo20W','Mo20W/les*-N2013',['les*-N2013'],'K7807').
genotype(3788,3237,'11R3237:0005710',3237,'11R3237:0005710','Mo20W','Mo20W/les*-N2013','Mo20W','Mo20W/les*-N2013',['les*-N2013'],'K7807').
genotype(3789,3238,'11R3238:0005801',3238,'11R3238:0005801','W23','W23/les*-N2013','W23','W23/les*-N2013',['les*-N2013'],'K7807').
genotype(3790,3238,'11R3238:0005803',3238,'11R3238:0005803','W23','W23/les*-N2013','W23','W23/les*-N2013',['les*-N2013'],'K7807').
genotype(3791,3238,'11R3238:0005806',3238,'11R3238:0005806','W23','W23/les*-N2013','W23','W23/les*-N2013',['les*-N2013'],'K7807').
genotype(3792,3239,'11R3239:0005901',3239,'11R3239:0005901','M14','M14/les*-N2013','M14','M14/les*-N2013',['les*-N2013'],'K7807').
genotype(3793,3239,'11R3239:0005906',3239,'11R3239:0005906','M14','M14/les*-N2013','M14','M14/les*-N2013',['les*-N2013'],'K7807').
genotype(3794,3239,'11R3239:0005907',3239,'11R3239:0005907','M14','M14/les*-N2013','M14','M14/les*-N2013',['les*-N2013'],'K7807').
genotype(3795,3101,'11R3101:0006001',3101,'11R3101:0006001','Mo20W','Mo20W/les*-N2290A','Mo20W','Mo20W/les*-N2290A',['les*-N2290A'],'K8002').
genotype(3796,3101,'11R3101:0006002',3101,'11R3101:0006002','Mo20W','Mo20W/les*-N2290A','Mo20W','Mo20W/les*-N2290A',['les*-N2290A'],'K8002').
genotype(3797,3102,'11R3102:0006101',3102,'11R3102:0006101','W23','(W23/Mo20W)/les*-N2290A','W23','(W23/Mo20W)/les*-N2290A',['les*-N2290A'],'K8002').
genotype(3798,3102,'11R3102:0006104',3102,'11R3102:0006104','W23','(W23/Mo20W)/les*-N2290A','W23','(W23/Mo20W)/les*-N2290A',['les*-N2290A'],'K8002').
genotype(3799,3102,'11R3102:0006105',3102,'11R3102:0006105','W23','(W23/Mo20W)/les*-N2290A','W23','(W23/Mo20W)/les*-N2290A',['les*-N2290A'],'K8002').
genotype(3800,3103,'11R3103:0006201',3103,'11R3103:0006201','M14','(M14/Mo20W)/les*-N2290A','M14','(M14/Mo20W)/les*-N2290A',['les*-N2290A'],'K8002').
genotype(3801,3103,'11R3103:0006204',3103,'11R3103:0006204','M14','(M14/Mo20W)/les*-N2290A','M14','(M14/Mo20W)/les*-N2290A',['les*-N2290A'],'K8002').
genotype(3802,3103,'11R3103:0006205',3103,'11R3103:0006205','M14','(M14/Mo20W)/les*-N2290A','M14','(M14/Mo20W)/les*-N2290A',['les*-N2290A'],'K8002').
genotype(3803,1223,'11R1223:0006305',1223,'11R1223:0006305','Mo20W','Mo20W/les*-N2502','Mo20W','Mo20W/les*-N2502',['les*-N2502'],'K8709').
genotype(3804,1223,'11R1223:0006306',1223,'11R1223:0006306','Mo20W','Mo20W/les*-N2502','Mo20W','Mo20W/les*-N2502',['les*-N2502'],'K8709').
genotype(3805,205,'11N205:S0030711',3120,'11N3120:0029008','Mo20W','Mo20W','les*-NA467','les*-NA467',['les*-NA467'],'K9001').
genotype(3806,305,'11N305:W0031708',3120,'11N3120:0029008','W23','W23','les*-NA467','les*-NA467',['les*-NA467'],'K9001').
genotype(3807,305,'11N305:W0036807',3120,'11N3120:0029006','W23','W23','les*-NA467','les*-NA467',['les*-NA467'],'K9001').
genotype(3808,305,'11N305:W0038607',3120,'11N3120:0029003','W23','W23','les*-NA467','les*-NA467',['les*-NA467'],'K9001').
genotype(3809,1226,'11R1226:0006401',1226,'11R1226:0006401','M14','M14/les*-NA467','M14','M14/les*-NA467',['les*-NA467'],'K9001').
genotype(3810,405,'11N405:M0032410',3120,'11N3120:0029006','M14','M14','les*-NA467','les*-NA467',['les*-NA467'],'K9001').
genotype(3811,405,'11N405:M0033605',3120,'11N3120:0029003','M14','M14','les*-NA467','les*-NA467',['les*-NA467'],'K9001').
genotype(3812,3089,'11R3089:0006501',3089,'11R3089:0006501','Mo20W','+/les*-PI262474','Mo20W','+/les*-PI262474',['les*-PI262474'],'K13708').
genotype(3813,3089,'11R3089:0006502',3089,'11R3089:0006502','Mo20W','+/les*-PI262474','Mo20W','+/les*-PI262474',['les*-PI262474'],'K13708').
genotype(3814,3089,'11R3089:0006503',3089,'11R3089:0006503','Mo20W','+/les*-PI262474','Mo20W','+/les*-PI262474',['les*-PI262474'],'K13708').
genotype(3815,3090,'11R3090:0006604',3090,'11R3090:0006604','W23','+/les*-PI262474','W23','+/les*-PI262474',['les*-PI262474'],'K13708').
genotype(3816,3090,'11R3090:0006607',3090,'11R3090:0006607','W23','+/les*-PI262474','W23','+/les*-PI262474',['les*-PI262474'],'K13708').
genotype(3817,3090,'11R3090:0006609',3090,'11R3090:0006609','W23','+/les*-PI262474','W23','+/les*-PI262474',['les*-PI262474'],'K13708').
genotype(3818,3093,'11R3093:0006901',3093,'11R3093:0006901','W23','+/les*-PI262474','W23','+/les*-PI262474',['les*-PI262474'],'K13714').
genotype(3819,3093,'11R3093:0006903',3093,'11R3093:0006903','W23','+/les*-PI262474','W23','+/les*-PI262474',['les*-PI262474'],'K13714').
genotype(3820,3091,'11R3091:0006702',3091,'11R3091:0006702','M14','+/les*-PI262474','M14','+/les*-PI262474',['les*-PI262474'],'K13708').
genotype(3821,3091,'11R3091:0006703',3091,'11R3091:0006703','M14','+/les*-PI262474','M14','+/les*-PI262474',['les*-PI262474'],'K13708').
genotype(3822,3091,'11R3091:0006707',3091,'11R3091:0006707','M14','+/les*-PI262474','M14','+/les*-PI262474',['les*-PI262474'],'K13708').
genotype(3823,3094,'11R3094:0007003',3094,'11R3094:0007003','M14','+/les*-PI262474','M14','+/les*-PI262474',['les*-PI262474'],'K13714').
genotype(3824,3094,'11R3094:0007005',3094,'11R3094:0007005','M14','+/les*-PI262474','M14','+/les*-PI262474',['les*-PI262474'],'K13714').
genotype(3825,3094,'11R3094:0007006',3094,'11R3094:0007006','M14','+/les*-PI262474','M14','+/les*-PI262474',['les*-PI262474'],'K13714').
genotype(3826,3096,'11R3096:0007107',3096,'11R3096:0007107','W23','?/les*-tilling1','W23','?/les*-tilling1',['les*-tilling1'],'K17404').
genotype(3827,3096,'11R3096:0007108',3096,'11R3096:0007108','W23','?/les*-tilling1','W23','?/les*-tilling1',['les*-tilling1'],'K17404').
genotype(3828,3096,'11R3096:0007110',3096,'11R3096:0007110','W23','?/les*-tilling1','W23','?/les*-tilling1',['les*-tilling1'],'K17404').
genotype(3829,3097,'11R3097:0007205',3097,'11R3097:0007205','M14','?/les*-tilling1','M14','?/les*-tilling1',['les*-tilling1'],'K17404').
genotype(3830,3097,'11R3097:0007206',3097,'11R3097:0007206','M14','?/les*-tilling1','M14','?/les*-tilling1',['les*-tilling1'],'K17404').
genotype(3831,3097,'11R3097:0007212',3097,'11R3097:0007212','M14','?/les*-tilling1','M14','?/les*-tilling1',['les*-tilling1'],'K17404').
genotype(3832,1442,'09R1442:0005102',1442,'09R1442:0005102','W23','{(B73/AG32)|(Ht1/les*-N2333A)}','W23','{(B73/AG32)|(Ht1/les*-N2333A)}',['les*-N2333A'],'K8203').
genotype(3833,1442,'09R1442:0005103',1442,'09R1442:0005103','W23','{(B73/AG32)|(Ht1/les*-N2333A)}','W23','{(B73/AG32)|(Ht1/les*-N2333A)}',['les*-N2333A'],'K8203').
genotype(3834,622,'11R0622:0009101',622,'11R0622:0009101','L522-10','new necrotic','L522-10','new necrotic',['new necrotic'],'K62200').
genotype(3835,622,'11R0622:0009103',622,'11R0622:0009103','L522-10','new necrotic','L522-10','new necrotic',['new necrotic'],'K62200').
genotype(3836,622,'11R0622:0009105',622,'11R0622:0009105','L522-10','new necrotic','L522-10','new necrotic',['new necrotic'],'K62200').
genotype(3837,3183,'11R3183:0007911',3183,'11R3183:0007911','Mo20W','B73/camo cf0-1','Mo20W','B73/camo cf0-1',['camo cf0-1'],'K19002').
genotype(3838,3183,'11R3183:0007913',3183,'11R3183:0007913','Mo20W','B73/camo cf0-1','Mo20W','B73/camo cf0-1',['camo cf0-1'],'K19002').
genotype(3839,3183,'11R3183:0007912',3183,'11R3183:0007912','Mo20W','B73/camo cf0-1','Mo20W','B73/camo cf0-1',['camo cf0-1'],'K19002').
genotype(3840,3184,'11R3184:0008004',3184,'11R3184:0008004','W23','B73/camo cf0-1','W23','B73/camo cf0-1',['camo cf0-1'],'K19002').
genotype(3841,3184,'11R3184:0008007',3184,'11R3184:0008007','W23','B73/camo cf0-1','W23','B73/camo cf0-1',['camo cf0-1'],'K19002').
genotype(3842,3184,'11R3184:0008009',3184,'11R3184:0008009','W23','B73/camo cf0-1','W23','B73/camo cf0-1',['camo cf0-1'],'K19002').
genotype(3843,3185,'11R3185:0008104',3185,'11R3185:0008104','M14','B73/camo cf0-1','M14','B73/camo cf0-1',['camo cf0-1'],'K19002').
genotype(3844,3185,'11R3185:0008107',3185,'11R3185:0008107','M14','B73/camo cf0-1','M14','B73/camo cf0-1',['camo cf0-1'],'K19002').
genotype(3845,3186,'11R3186:0008202',3186,'11R3186:0008202','Mo20W','B73/camo cf0-2','Mo20W','B73/camo cf0-2',['camo cf0-2'],'K19101').
genotype(3846,3186,'11R3186:0008203',3186,'11R3186:0008203','Mo20W','B73/camo cf0-2','Mo20W','B73/camo cf0-2',['camo cf0-2'],'K19101').
genotype(3847,3186,'11R3186:0008207',3186,'11R3186:0008207','Mo20W','B73/camo cf0-2','Mo20W','B73/camo cf0-2',['camo cf0-2'],'K19101').
genotype(3848,3187,'11R3187:0008302',3187,'11R3187:0008302','W23','B73/camo cf0-2','W23','B73/camo cf0-2',['camo cf0-2'],'K19101').
genotype(3849,3187,'11R3187:0008304',3187,'11R3187:0008304','W23','B73/camo cf0-2','W23','B73/camo cf0-2',['camo cf0-2'],'K19101').
genotype(3850,3187,'11R3187:0008307',3187,'11R3187:0008307','W23','B73/camo cf0-2','W23','B73/camo cf0-2',['camo cf0-2'],'K19101').
genotype(3851,3188,'11R3188:0008403',3188,'11R3188:0008403','M14','B73/camo cf0-2','M14','B73/camo cf0-2',['camo cf0-2'],'K19101').
genotype(3852,3188,'11R3188:0008408',3188,'11R3188:0008408','M14','B73/camo cf0-2','M14','B73/camo cf0-2',['camo cf0-2'],'K19101').
genotype(3853,3188,'11R3188:0008408',3188,'11R3188:0008408','M14','B73/camo cf0-2','M14','B73/camo cf0-2',['camo cf0-2'],'K19101').
genotype(3854,3111,'11R3111:0008502',3111,'11R3111:0008502','+/cpc1-N2284B','+/cpc1-N2284B','+/cpc1-N2284B','+/cpc1-N2284B',['cpc1-N2284B'],'K9601').
genotype(3855,3111,'11R3111:0008503',3111,'11R3111:0008503','+/cpc1-N2284B','+/cpc1-N2284B','+/cpc1-N2284B','+/cpc1-N2284B',['cpc1-N2284B'],'K9601').
genotype(3856,3111,'11R3111:0008506',3111,'11R3111:0008506','+/cpc1-N2284B','+/cpc1-N2284B','+/cpc1-N2284B','+/cpc1-N2284B',['cpc1-N2284B'],'K9601').
genotype(3857,3113,'11R3113:0008703',3113,'11R3113:0008703','+/cpc1-N2284B','+/cpc1-N2284B','+/cpc1-N2284B','+/cpc1-N2284B',['cpc1-N2284B'],'K9606').
genotype(3858,3113,'11R3113:0008704',3113,'11R3113:0008704','+/cpc1-N2284B','+/cpc1-N2284B','+/cpc1-N2284B','+/cpc1-N2284B',['cpc1-N2284B'],'K9606').
genotype(3859,1020,'10R1020:0012501',1020,'10R1020:0012501','Mo20W','?/csp1','Mo20W','?/csp1',[csp1],'K11503').
genotype(3860,1020,'10R1020:0012508',1020,'10R1020:0012508','Mo20W','?/csp1','Mo20W','?/csp1',[csp1],'K11503').
genotype(3861,1020,'10R1020:0012511',1020,'10R1020:0012511','Mo20W','?/csp1','Mo20W','?/csp1',[csp1],'K11503').
genotype(3862,1021,'10R1021:0012604',1021,'10R1021:0012604','W23','?/csp1','W23','?/csp1',[csp1],'K11503').
genotype(3863,1021,'10R1021:0012612',1021,'10R1021:0012612','W23','?/csp1','W23','?/csp1',[csp1],'K11503').
genotype(3864,1021,'10R1021:0012613',1021,'10R1021:0012613','W23','?/csp1','W23','?/csp1',[csp1],'K11503').
genotype(3865,1025,'10R1025:0012703',1025,'10R1025:0012703','M14','?/csp1','M14','?/csp1',[csp1],'K11503').
genotype(3866,1025,'10R1025:0012704',1025,'10R1025:0012704','M14','?/csp1','M14','?/csp1',[csp1],'K11503').
genotype(3867,1025,'10R1025:0012708',1025,'10R1025:0012708','M14','?/csp1','M14','?/csp1',[csp1],'K11503').


% manually added these per pack_corn/1
%
% Kazic, 9.6.2012

genotype(3868,3098,'11N3098:0024707',3098,'11N3098:0024707','Mo20W','+/LesLA','Mo20W','+/LesLA',['LesLA'],'K17307').
genotype(3869,501,'11N501:B0030601',3402,'11N3402:0008110','B73','B73','Mo20W','Les2',['Les2'],'K0203').
genotype(3870,3079,'11R3079:0005401',3079,'11R3079:0005401','Mo20W','Mo20W/les*-N2012','Mo20W','Mo20W/les*-N2012',['les*-N2012'],'K7702').
genotype(3871,3183,'11R3183:0007910',3183,'11R3183:0007910','Mo20W','(Mo20W/B73)/camo cf0-1','Mo20W','(Mo20W/B73)/camo cf0-1',['camo cf0-1'],'K19002').
genotype(3872,3188,'11R3188:0008413',3188,'11R3188:0008413','M14','(M14/B73)/camo cf0-2','M14','(M14/B73)/camo cf0-2',['camo cf0-2'],'K19101').


% added manually as family 630 is most definitely not a Mo20W sib (tall plants with Mo20W body
% plan) and no such ear in inventory.
%
% Kazic, 14.7.2012

genotype(3873,205,'11N205:S0039102',1370,'11N1370:0027510','Mo20W','Mo20W','W23/{+|lls1 121D}','W23/{+|lls1 121D}',['lls1 121D'],'K3402').



% new mutants from David Braun''s field 19, 12r, not planted in 12n; so families must be
% added for 13r.
%
% Kazic, 18.12.2012









%%%%%%%%% automatically added families for 12N crop; checked calculated genotype data %%%%%%%%%%%%%%
%
% note that the predicate should keep track of ears visited; otherwise rows with the same family are
% assigned different family numbers!
%
% Kazic, 18.12.2012

% checked and confirmed

genotype(3617,3751,'12R3751:0044806',3751,'12R3751:0044806','Mo20W','W23/lls1 121D','Mo20W','W23/lls1 121D',['lls1 121D'],'K3402').
genotype(3874,3753,'12R3753:0045006',3753,'12R3753:0045006','Mo20W','W23/lls1 121D','Mo20W','W23/lls1 121D',['lls1 121D'],'K3402').
genotype(3875,3754,'12R3754:0045104',3754,'12R3754:0045104','W23','lls1 121D','W23','lls1 121D',['lls1 121D'],'K3402').
genotype(3876,3755,'12R3755:0045208',3755,'12R3755:0045208','W23','lls1 121D','W23','lls1 121D',['lls1 121D'],'K3402').
genotype(3877,3757,'12R3757:0045401',3757,'12R3757:0045401','M14','W23/lls1 121D','M14','W23/lls1 121D',['lls1 121D'],'K3402').
genotype(3878,3758,'12R3758:0045503',3758,'12R3758:0045503','M14','W23/lls1 121D','M14','W23/lls1 121D',['lls1 121D'],'K3402').
genotype(3879,3530,'12R3530:0015606',3530,'12R3530:0015606','W23','lls1 121D','W23','lls1 121D',['lls1 121D'],'K5302').
genotype(3880,3530,'12R3530:0015607',3530,'12R3530:0015607','W23','lls1 121D','W23','lls1 121D',['lls1 121D'],'K5302').
genotype(3881,3531,'12R3531:0015702',3531,'12R3531:0015702','M14','W23/lls1 121D','M14','W23/lls1 121D',['lls1 121D'],'K5302').
genotype(3882,3531,'12R3531:0015703',3531,'12R3531:0015703','M14','W23/lls1 121D','M14','W23/lls1 121D',['lls1 121D'],'K5302').

genotype(3883,205,'12R205:S0003416',3532,'12R3532:0015807','Mo20W','Mo20W','Mo20W','?/lls1-nk',['lls1-nk'],'K17800').
genotype(3884,305,'12R305:W0011611',3532,'12R3532:0015807','W23','W23','Mo20W','?/lls1-nk',['lls1-nk'],'K17800').
genotype(3885,405,'12R405:M0010812',3532,'12R3532:0015811','M14','M14','Mo20W','?/lls1-nk',['lls1-nk'],'K17800').

genotype(3886,3527,'12R3527:0015304',3527,'12R3527:0015304','W23','les23','W23','les23',[les23],'K1802').
genotype(3887,3527,'12R3527:0015306',3527,'12R3527:0015306','W23','les23','W23','les23',[les23],'K1802').
genotype(3888,3526,'12R3526:0015210',3526,'12R3526:0015210','W23','les23','W23','les23',[les23],'K1804').
genotype(3889,3526,'12R3526:0015213',3526,'12R3526:0015213','W23','les23','W23','les23',[les23],'K1804').

genotype(3890,205,'12R205:S0003413',3747,'12R3747:0044405','Mo20W','Mo20W','Mo20W','lls1',[lls1],'K10602').
genotype(3891,205,'12R205:S0008513',3747,'12R3747:0044405','Mo20W','Mo20W','Mo20W','lls1',[lls1],'K10602').
genotype(3892,305,'12R305:W0007107',3750,'12R3750:0044706','W23','W23','lls1','lls1',[lls1],'K10602').
genotype(3893,305,'12R305:W0007115',3750,'12R3750:0044702','W23','W23','lls1','lls1',[lls1],'K10602').

genotype(3894,405,'12R405:M0011702',3501,'12R3501:0041711','M14','M14','les23','les23',[les23],'K1802').
genotype(3895,205,'12R205:S0011209',3156,'12R3156:0042105','Mo20W','Mo20W','Mo20W','les23',[les23],'K3514').
genotype(3896,305,'12R305:W0011311',3728,'12R3728:0042212','W23','W23','W23','les23',[les23],'K3514').
genotype(3897,305,'12R305:W0003804',3733,'12R3733:0043004','W23','W23','W23','les23',[les23],'K16306').
genotype(3898,305,'12R305:W0003805',3733,'12R3733:0043005','W23','W23','W23','les23',[les23],'K16306').


genotype(3899,205,'12R205:S0001911',3550,'12R3550:0017804','Mo20W','Mo20W','Mo20W','Les1',['Les1'],'K0104').
genotype(3900,305,'12R305:W0001416',3551,'12R3551:0017902','W23','W23','W23','Les1',['Les1'],'K0104').
genotype(3901,405,'12R405:M0011112',3552,'12R3552:0018003','M14','M14','M14','Les1',['Les1'],'K0104').
genotype(3902,205,'12R205:S0004004',3553,'12R3553:0018108','Mo20W','Mo20W','Mo20W','Les1',['Les1'],'K0106').
genotype(3903,305,'12R305:W0000508',3554,'12R3554:0018206','W23','W23','W23','Les1',['Les1'],'K0106').
genotype(3904,205,'12R205:S0003406',3555,'12R3555:0018410','Mo20W','Mo20W','Mo20W','Les1',['Les1'],'K1903').
genotype(3905,3556,'12R3556:0018505',3556,'12R3556:0018505','W23','{W23|Les1}','W23','Les1',['Les1'],'K1903').
genotype(3906,3556,'12R3556:0018507',3556,'12R3556:0018507','W23','{W23|Les1}','W23','Les1',['Les1'],'K1903').
genotype(3907,3556,'12R3556:0018510',3556,'12R3556:0018510','W23','{W23|Les1}','W23','Les1',['Les1'],'K1903').
genotype(3908,405,'12R405:M0003306',3557,'12R3557:0018607','M14','M14','M14','Les1',['Les1'],'K1903').
genotype(3909,3557,'12R3557:0018606',3557,'12R3557:0018606','M14','{M14|Les1}','M14','Les1',['Les1'],'K1903').
genotype(3910,3557,'12R3557:0018607',3557,'12R3557:0018607','M14','{M14|Les1}','M14','Les1',['Les1'],'K1903').
genotype(3911,3557,'12R3557:0018608',3557,'12R3557:0018608','M14','{M14|Les1}','M14','Les1',['Les1'],'K1903').




% corrected per note re family 1816
%
% genotype(3912,205,'11N205:S0034206',3447,'11N3447:0015407','Mo20W','Mo20W','Mo20W','Les9',['Les9'],'K0709').
%
genotype(3912,205,'11N205:S0034206',3447,'11N3447:0015407','Mo20W','Mo20W','Mo20W','Les2',['Les2'],'K0202').
%
genotype(3913,405,'11R405:M0051002',3282,'11R3282:0053506','M14','M14','M14','Les2',['Les2'],'K0202').
genotype(3914,501,'11N501:B0030608',3402,'11N3402:0008109','B73','B73','Mo20W','Mo20W/Les2',['Les2'],'K0203').
genotype(3915,305,'12R305:W0000211',3566,'12R3566:0019512','W23','W23','W23','Les2',['Les2'],'K0203').
genotype(3916,3566,'12R3566:0019502',3566,'12R3566:0019502','W23','{W23|Les2}','W23','Les2',['Les2'],'K0203').
genotype(3917,3566,'12R3566:0019506',3566,'12R3566:0019506','W23','{W23|Les2}','W23','Les2',['Les2'],'K0203').
genotype(3918,3566,'12R3566:0019512',3566,'12R3566:0019512','W23','{W23|Les2}','W23','Les2',['Les2'],'K0203').
genotype(3919,503,'12R503:B0012706',3566,'12R3566:0019512','B73','B73','W23','Les2',['Les2'],'K0203').
genotype(3920,205,'11N205:S0037505',3404,'11N3404:0008504','Mo20W','Mo20W','Mo20W','Les2',['Les2'],'K0207').
genotype(3921,205,'12R205:S0002203',3570,'12R3570:0020009','Mo20W','Mo20W','Mo20W','Les2',['Les2'],'K2002').
genotype(3922,3570,'12R3570:0020008',3570,'12R3570:0020008','Mo20W','{Mo20W|Les2}','Mo20W','Les2',['Les2'],'K2002').
genotype(4056,3570,'12R3570:0020009',3570,'12R3570:0020009','Mo20W','{Mo20W|Les2}','Mo20W','Les2',['Les2'],'K2002').
genotype(3923,503,'12R503:B0012201',3570,'12R3570:0020009','B73','B73','Mo20W','Les2',['Les2'],'K2002').
genotype(3924,503,'12R503:B0012703',3570,'12R3570:0020008','B73','B73','Mo20W','Les2',['Les2'],'K2002').
genotype(3925,3571,'12R3571:0020102',3571,'12R3571:0020102','W23','{W23|Les2}','W23','Les2',['Les2'],'K2002').
genotype(3926,405,'12R405:M0007001',3575,'12R3575:0020504','M14','M14','M14','M14/Les2',['Les2'],'K2002').
genotype(3927,3575,'12R3575:0020504',3575,'12R3575:0020504','M14','{M14|Les2}','M14','Les2',['Les2'],'K2002').
genotype(3928,3575,'12R3575:0020505',3575,'12R3575:0020505','M14','{M14|Les2}','M14','Les2',['Les2'],'K2002').
genotype(3929,3575,'12R3575:0020507',3575,'12R3575:0020507','M14','{M14|Les2}','M14','Les2',['Les2'],'K2002').
	 
	 
         
	 
genotype(3930,205,'12R205:S0001913',3576,'12R3576:0020605','Mo20W','Mo20W','Mo20W','Les2-N845A',['Les2-N845A'],'K5515').
genotype(3931,305,'12R305:W0000203',3577,'12R3577:0020712','W23','W23','W23','Les2-N845A',['Les2-N845A'],'K5515').
genotype(3932,3577,'12R3577:0020708',3577,'12R3577:0020708','W23','{W23|Les2-N845A}','W23','Les2-N845A',['Les2-N845A'],'K5515').
genotype(3933,3577,'12R3577:0020710',3577,'12R3577:0020710','W23','{W23|Les2-N845A}','W23','Les2-N845A',['Les2-N845A'],'K5515').
genotype(3934,3577,'12R3577:0020712',3577,'12R3577:0020712','W23','{W23|Les2-N845A}','W23','Les2-N845A',['Les2-N845A'],'K5515').
genotype(3935,405,'12R405:M0003910',3578,'12R3578:0020803','M14','M14','M14','Les2-N845A',['Les2-N845A'],'K5515').
genotype(3936,205,'12R205:S0001902',3411,'12R3411:0020901','Mo20W','Mo20W','M14','Les2-N845A',['Les2-N845A'],'K5525').
genotype(3937,305,'12R305:W0011603',3411,'12R3411:0020901','W23','W23','M14','Les2-N845A',['Les2-N845A'],'K5525').
genotype(3938,405,'12R405:M0009316',3411,'12R3411:0020901','M14','M14','M14','Les2-N845A',['Les2-N845A'],'K5525').



	 
	 
genotype(3939,205,'12R205:S0010919',3582,'12R3582:0022608','Mo20W','Mo20W','Mo20W','Les4',['Les4'],'K0302').
genotype(3940,305,'12R305:W0000512',3583,'12R3583:0022709','W23','W23','W23','Les4',['Les4'],'K0302').
genotype(3941,503,'12R503:B0012603',3584,'12R3584:0022802','B73','B73','M14','Les4',['Les4'],'K0302').
genotype(3942,503,'12R503:B0012605',3584,'12R3584:0022806','B73','B73','M14','Les4',['Les4'],'K0302').
genotype(3943,305,'12R305:W0000210',3586,'12R3586:0023008','W23','W23','W23','Les4',['Les4'],'K0303').
genotype(3944,3586,'12R3586:0023002',3586,'12R3586:0023002','W23','{W23|Les4}','W23','Les4',['Les4'],'K0303').
genotype(3945,3586,'12R3586:0023008',3586,'12R3586:0023008','W23','{W23|Les4}','W23','Les4',['Les4'],'K0303').
genotype(3946,405,'12R405:M0000310',3587,'12R3587:0023110','M14','M14','M14','Les4',['Les4'],'K0303').
genotype(3947,503,'12R503:B0012702',3587,'12R3587:0023110','B73','B73','M14','Les4',['Les4'],'K0303').
genotype(3948,205,'12R205:S0003702',3588,'12R3588:0023201','Mo20W','Mo20W','Mo20W','Les4',['Les4'],'K2101').
genotype(3949,305,'12R305:W0001406',3589,'12R3589:0023301','W23','W23','W23','Les4',['Les4'],'K2101').
genotype(3950,503,'12R503:B0012506',3590,'12R3590:0023405','B73','B73','M14','Les4',['Les4'],'K2101').
genotype(3951,503,'12R503:B0012507',3590,'12R3590:0023401','B73','B73','M14','Les4',['Les4'],'K2101').
genotype(3952,205,'12R205:S0010608',3591,'12R3591:0023604','Mo20W','Mo20W','Mo20W','Les4',['Les4'],'K2106').
genotype(3953,3591,'12R3591:0023604',3591,'12R3591:0023604','Mo20W','{Mo20W|Les4}','Mo20W','Les4',['Les4'],'K2106').
genotype(3954,3591,'12R3591:0023606',3591,'12R3591:0023606','Mo20W','{Mo20W|Les4}','Mo20W','Les4',['Les4'],'K2106').
genotype(3955,3591,'12R3591:0023612',3591,'12R3591:0023612','Mo20W','{Mo20W|Les4}','Mo20W','Les4',['Les4'],'K2106').
genotype(3956,503,'12R503:B0011909',3591,'12R3591:0023604','B73','B73','Mo20W','Les4',['Les4'],'K2106').
genotype(3957,503,'12R503:B0012501',3591,'12R3591:0023606','B73','B73','Mo20W','Les4',['Les4'],'K2106').
genotype(3958,305,'12R305:W0000503',3592,'12R3592:0023701','W23','W23','W23','Les4',['Les4'],'K2106').
genotype(3959,405,'12R405:M0008205',3593,'12R3593:0023811','M14','M14','M14','Les4',['Les4'],'K2106').
	 
	 
	 
	 
	 
	 
	 
	 
genotype(3960,599,'12R599:B0131104',116,'12R0116:0051501','B73','B73','?/Les5','?/Les5',['Les5'],'K11601').
genotype(3961,599,'12R599:B0131106',116,'12R0116:0051505','B73','B73','?/Les5','?/Les5',['Les5'],'K11605').


genotype(3962,305,'12R305:W0011316',3600,'12R3600:0024913','W23','W23','W23','Les6',['Les6'],'K0403').
genotype(3963,3600,'12R3600:0024902',3600,'12R3600:0024902','W23','{W23|Les6}','W23','Les6',['Les6'],'K0403').
genotype(3964,3600,'12R3600:0024907',3600,'12R3600:0024907','W23','{W23|Les6}','W23','Les6',['Les6'],'K0403').
genotype(3965,205,'12R205:S0003409',3601,'12R3601:0025112','Mo20W','Mo20W','Mo20W','Les6',['Les6'],'K2202').
genotype(3966,305,'12R305:W0000208',3602,'12R3602:0025213','W23','W23','W23','Les6',['Les6'],'K2202').
genotype(3967,3602,'12R3602:0025206',3602,'12R3602:0025206','W23','{W23|Les6}','W23','Les6',['Les6'],'K2202').
genotype(3968,3602,'12R3602:0025213',3602,'12R3602:0025213','W23','{W23|Les6}','W23','Les6',['Les6'],'K2202').
genotype(3969,405,'12R405:M0001802',3603,'12R3603:0025310','M14','M14','M14','Les6',['Les6'],'K2202').
genotype(3970,205,'12R205:S0001915',3604,'12R3604:0025403','Mo20W','Mo20W','Mo20W','Les6',['Les6'],'K2212').
genotype(3971,305,'12R305:W0000511',3605,'12R3605:0025504','W23','W23','W23','Les6',['Les6'],'K2212').
genotype(3972,405,'12R405:M0001512',3439,'12R3439:0025603','M14','M14','M14','Les6',['Les6'],'K2212').


genotype(3973,205,'11N205:S0036601',3226,'11N3226:0013704','Mo20W','Mo20W','Mo20W','Les7',['Les7'],'K0509').
genotype(3974,305,'11N305:W0039501',3192,'11N3192:0013810','W23','W23','W23','Les7',['Les7'],'K0509').
genotype(3975,405,'12R405:M0000601',3608,'12R3608:0025901','M14','M14','M14','Les7',['Les7'],'K0509').
genotype(3976,3608,'12R3608:0025901',3608,'12R3608:0025901','M14','{M14|Les7}','M14','Les7',['Les7'],'K0509').
genotype(3977,205,'11N205:S0033001',3441,'11N3441:0014202','Mo20W','Mo20W','Mo20W','W23/Les7',['Les7'],'K2312').
genotype(3978,305,'12R305:W0001104',3227,'12R3227:0026108','W23','W23','W23','Les7',['Les7'],'K2312').
genotype(3979,405,'12R405:M0001509',3610,'12R3610:0026210','M14','M14','M14','Les7',['Les7'],'K2312').



genotype(3980,205,'12R205:S0002812',3611,'12R3611:0026307','Mo20W','Mo20W','Mo20W','Les8',['Les8'],'K0604').
genotype(3981,3611,'12R3611:0026306',3611,'12R3611:0026306','Mo20W','{Mo20W|Les8}','Mo20W','Les8',['Les8'],'K0604').
genotype(3982,3611,'12R3611:0026307',3611,'12R3611:0026307','Mo20W','{Mo20W|Les8}','Mo20W','Les8',['Les8'],'K0604').
genotype(3983,305,'12R305:W0000202',3612,'12R3612:0026412','W23','W23','W23','Les8',['Les8'],'K0604').
genotype(3984,3612,'12R3612:0026403',3612,'12R3612:0026403','W23','{W23|Les8}','W23','Les8',['Les8'],'K0604').
genotype(3985,3612,'12R3612:0026412',3612,'12R3612:0026412','W23','{W23|Les8}','W23','Les8',['Les8'],'K0604').
genotype(3986,405,'10R405:M0000714',2243,'10R2243:0028403','M14','M14','M14','(M14/Mo20W)/Les8',['Les8'],'K0604').
genotype(3987,405,'10R405:M0001004',2243,'10R2243:0028412','M14','M14','M14','(M14/Mo20W)/Les8',['Les8'],'K0604').
genotype(3988,205,'12R205:S0000706',3613,'12R3613:0026613','Mo20W','Mo20W','Mo20W','(Mo20W/W23)/Les8',['Les8'],'K2405').
genotype(3989,3614,'12R3614:0026701',3614,'12R3614:0026701','W23','{W23|Les8}','W23','Les8',['Les8'],'K2405').


genotype(3990,205,'12R205:S0008515',3616,'12R3616:0026908','Mo20W','Mo20W','Mo20W','Les9',['Les9'],'K0707').
genotype(3991,305,'12R305:W0003817',3715,'12R3715:0027012','W23','W23','W23','Les9',['Les9'],'K0707').
genotype(3992,3715,'12R3715:0027014',3715,'12R3715:0027014','W23','{W23|Les9}','W23','Les9',['Les9'],'K0707').
genotype(3993,405,'12R405:M0008209',3618,'12R3618:0027109','M14','M14','M14','Les9',['Les9'],'K0707').
genotype(3994,205,'11N205:S0033009',3204,'11N3204:0015605','Mo20W','Mo20W','Mo20W','W23/Les9',['Les9'],'K2506').
genotype(3995,305,'12R305:W0002901',3620,'12R3620:0027307','W23','W23','W23','Les9',['Les9'],'K2506').



genotype(3996,205,'12R205:S0010917',3622,'12R3622:0027501','Mo20W','Mo20W','Mo20W','Les10',['Les10'],'K0801').
genotype(3997,305,'12R305:W0003202',3623,'12R3623:0027609','W23','W23','W23','Les10',['Les10'],'K0801').
genotype(3998,405,'12R405:M0008212',3624,'12R3624:0027701','M14','M14','M14','Mo20W/Les10',['Les10'],'K0801').
genotype(3999,205,'12R205:S0002801',1354,'12R1354:0027813','Mo20W','Mo20W','W23/+','W23/Les10',['Les10'],'K2606').
genotype(4000,305,'12R305:W0002609',3625,'12R3625:0027904','W23','W23','W23','Les10',['Les10'],'K2606').
genotype(4001,405,'12R405:M0001507',3451,'12R3451:0028014','M14','M14','M14','W23/Les10',['Les10'],'K2606').




genotype(4002,305,'12R305:W0002602',3627,'12R3627:0028208','W23','W23','W23','Les11',['Les11'],'K0901').
genotype(4003,3627,'12R3627:0028201',3627,'12R3627:0028201','W23','{W23|Les11}','W23','Les11',['Les11'],'K0901').
genotype(4004,3627,'12R3627:0028208',3627,'12R3627:0028208','W23','{W23|Les11}','W23','Les11',['Les11'],'K0901').
genotype(4005,3627,'12R3627:0028210',3627,'12R3627:0028210','W23','{W23|Les11}','W23','Les11',['Les11'],'K0901').
genotype(4006,405,'11N405:M0034006',3287,'11N3287:0016701','M14','M14','M14','(M14/Mo20W)/Les11',['Les11'],'K0901').




genotype(4007,205,'12R205:S0002216',3629,'12R3629:0028403','Mo20W','Mo20W','Mo20W','Les12',['Les12'],'K1001').
genotype(4008,305,'12R305:W0002912',3630,'12R3630:0028505','W23','W23','W23','Les12',['Les12'],'K1001').
genotype(4009,3630,'12R3630:0028505',3630,'12R3630:0028505','W23','{W23|Les12}','W23','Les12',['Les12'],'K1001').
genotype(4010,405,'12R405:M0008210',3631,'12R3631:0028608','M14','M14','M14','Les12',['Les12'],'K1001').
genotype(4011,205,'12R205:S0002217',3454,'12R3454:0028708','Mo20W','Mo20W','Mo20W','(Mo20W/W23)/Les12',['Les12'],'K2711').
genotype(4012,305,'12R305:W0011317',3632,'12R3632:0028810','W23','W23','W23','Les12',['Les12'],'K2711').
genotype(4013,405,'12R405:M0003302',3633,'12R3633:0028909','M14','M14','M14','Les12',['Les12'],'K2711').
genotype(4014,3633,'12R3633:0028901',3633,'12R3633:0028901','M14','{M14|Les12}','M14','Les12',['Les12'],'K2711').
genotype(4015,3633,'12R3633:0028905',3633,'12R3633:0028905','M14','{M14|Les12}','M14','Les12',['Les12'],'K2711').
genotype(4016,3633,'12R3633:0028909',3633,'12R3633:0028909','M14','{M14|Les12}','M14','Les12',['Les12'],'K2711').



genotype(4017,205,'12R205:S0004008',3634,'12R3634:0029002','Mo20W','Mo20W','Mo20W','Les13',['Les13'],'K1109').
genotype(4018,305,'11N305:W0031711',2532,'11N2532:0017513','W23','W23','W23','(Mo20W/W23)/Les13',['Les13'],'K1109').
genotype(4019,205,'12R205:S0001908',3637,'12R3637:0029310','Mo20W','Mo20W','Mo20W','(Mo20W/W23)/Les13',['Les13'],'K2805').
genotype(4020,305,'12R305:W0009506',3638,'12R3638:0029407','W23','W23','W23','Les13',['Les13'],'K2805').



genotype(4021,205,'12R205:S0001910',3457,'12R3457:0029611','Mo20W','Mo20W','Mo20W','Les17',['Les17'],'K1309').
genotype(4022,305,'12R305:W0000808',3639,'12R3639:0029706','W23','W23','W23','Les17',['Les17'],'K1309').
genotype(4023,205,'12R205:S0003703',3641,'12R3641:0029901','Mo20W','Mo20W','Mo20W','Les17',['Les17'],'K3007').
genotype(4024,3641,'12R3641:0029901',3641,'12R3641:0029901','Mo20W','{Mo20W|Les17}','Mo20W','Les17',['Les17'],'K3007').
genotype(4025,3460,'12R3460:0030008',3460,'12R3460:0030008','W23','{W23|Les17}','W23','Les17',['Les17'],'K3007').
genotype(4026,3460,'12R3460:0030011',3460,'12R3460:0030011','W23','{W23|Les17}','W23','Les17',['Les17'],'K3007').
genotype(4027,405,'12R405:M0009910',3242,'12R3242:0030202','M14','M14','M14','Les17',['Les17'],'K3007').



genotype(4028,205,'12R205:S0010601',3643,'12R3643:0030310','Mo20W','Mo20W','Mo20W','Les18',['Les18'],'K1411').
genotype(4029,305,'12R305:W0002601',3644,'12R3644:0030415','W23','W23','W23','Les18',['Les18'],'K1411').
genotype(4030,405,'12R405:M0009611',3645,'12R3645:0030510','M14','M14','M14','Les18',['Les18'],'K1411').
genotype(4031,205,'12R205:S0002805',3646,'12R3646:0030601','Mo20W','Mo20W','Mo20W','Les18',['Les18'],'K3106').
genotype(4032,3647,'12R3647:0030705',3647,'12R3647:0030705','W23','{W23|Les18}','W23','Les18',['Les18'],'K3106').
genotype(4033,3647,'12R3647:0030707',3647,'12R3647:0030707','W23','{W23|Les18}','W23','Les18',['Les18'],'K3106').
genotype(4034,405,'12R405:M0011103',3648,'12R3648:0030807','M14','M14','M14','(M14/W23)/Les18',['Les18'],'K3106').



genotype(4035,205,'12R205:S0008505',3649,'12R3649:0030908','Mo20W','Mo20W','Mo20W','Les19',['Les19'],'K1506').
genotype(4036,305,'12R305:W0010714',3650,'12R3650:0031010','W23','W23','W23','Les19',['Les19'],'K1506').
genotype(4037,405,'12R405:M0009311',3651,'12R3651:0031113','M14','M14','M14','Les19',['Les19'],'K1506').
genotype(4038,305,'12R305:W0010711',3653,'12R3653:0031303','W23','W23','W23','Les19',['Les19'],'K3206').
genotype(4039,3653,'12R3653:0031303',3653,'12R3653:0031303','W23','{W23|Les19}','W23','Les19',['Les19'],'K3206').
genotype(4040,3653,'12R3653:0031313',3653,'12R3653:0031313','W23','{W23|Les19}','W23','Les19',['Les19'],'K3206').
genotype(4041,3653,'12R3653:0031314',3653,'12R3653:0031314','W23','{W23|Les19}','W23','Les19',['Les19'],'K3206').
genotype(4042,405,'10R405:M0006902',1290,'10R1290:0034404','M14','M14','M14','(M14/W23)/Les19',['Les19'],'K3206').



genotype(4043,205,'12R205:S0002510',3297,'12R3297:0031504','Mo20W','Mo20W','Mo20W','Les20-N2457',['Les20-N2457'],'K7110').
genotype(4044,305,'12R305:W0002614',3297,'12R3297:0031504','W23','W23','Mo20W','Les20-N2457',['Les20-N2457'],'K7110').
genotype(4045,305,'11N305:W0032904',3316,'11N3316:0020302','W23','W23','W23','Les20-N2457',['Les20-N2457'],'K7110').
genotype(4046,405,'12R405:M0001812',3297,'12R3297:0031504','M14','M14','Mo20W','Les20-N2457',['Les20-N2457'],'K7110').



genotype(4047,205,'12R205:S0002211',3655,'12R3655:0031810','Mo20W','Mo20W','Mo20W','(Mo20W/W23)/Les21',['Les21'],'K3311').
genotype(4048,405,'12R405:M0011109',3469,'12R3469:0032006','M14','M14','M14','(M14/W23)/Les21',['Les21'],'K3311').
	 
genotype(4049,205,'12R205:S0000704',3657,'12R3657:0032107','Mo20W','Mo20W','Mo20W','(Mo20W/B73 Ht1)/Les21-N1442',['Les21-N1442'],'K7205').
genotype(4050,305,'12R305:W0000802',3658,'12R3658:0032208','W23','W23','W23','Les21-N1442',['Les21-N1442'],'K7205').
genotype(4051,405,'12R405:M0009608',3659,'12R3659:0032304','M14','M14','M14','Les21-N1442',['Les21-N1442'],'K7205').



% 4073 -- 4088 misassigned to B73, should be family 504; had B0000000 instead of B0xxxxxx
% in genotype fact, now fixed
%
% fgenotype(4073,502,'11N502:B0xxxxxx',502,'11N502:B0xxxxxx','B73','B73','B73','B73',['B73'],'').
%
% so, reassigned the family numbers to these lines; note the next family number after this block 
% is not 4055 (used for the forebear of the rewritten family 1816), but 4056.
%
% Kazic, 18.12.2012


genotype(4052,205,'12R205:S0009104',3270,'12R3270:0014314','Mo20W','Mo20W','Mo20W','W23/Les15-N2007',['Les15-N2007'],'K6711').
genotype(4053,305,'12R305:W0011614',3456,'12R3456:0014501','W23','W23','W23','Les15-N2007',['Les15-N2007'],'K6711').
genotype(4054,405,'12R405:M0009302',3486,'12R3486:0014708','M14','M14','M14','Les15-N2007',['Les15-N2007'],'K6711').



% a csp-like (per Gerry) in Lisa Coffey''s 12N field; tried to cross by rolling the anther
% between my fingers; her row 422, I think plant 12; have placed it in an
% imaginary row 600.  
%
% Kazic, 22.1.2013
%
% cross was unsuccessful
%
% Kazic, 21.4.2013

genotype(4055,4055,'12N4055:0060012',4055,'12N4055:0060012','?','?','?','csp-like',['csp-like'],'K6711').




% 13r


genotype(4057,205,'12N205:S0041304',3738,'12N3738:0000801','Mo20W','Mo20W','Mo20W/lls1','Mo20W/lls1',[lls1],'K1702').
genotype(4058,305,'12N305:W0041401',3739,'12N3739:0000912','W23','W23','W23/(Mo20W/lls1)','W23/(Mo20W/lls1)',[lls1],'K1702').
genotype(4059,405,'12N405:M0039007',3746,'12N3746:0001405','M14','M14','Mo20W/lls1','Mo20W/lls1',[lls1],'K10602').
genotype(4060,305,'12N305:W0041402',3876,'12N3876:0002008','W23','W23','W23/lls1 121D','W23/lls1 121D',['lls1 121D'],'K3402').
genotype(4061,305,'12N305:W0041706',3876,'12N3876:0002007','W23','W23','W23/lls1 121D','W23/lls1 121D',['lls1 121D'],'K3402').
genotype(4062,205,'12N205:S0035801',1932,'12N1932:0002303','Mo20W','Mo20W','lls1 121D','lls1 121D',['lls1 121D'],'K5302').
genotype(4063,305,'12N305:W0043204',3880,'12N3880:0002601','W23','W23','W23/lls1 121D','W23/lls1 121D',['lls1 121D'],'K5302').
genotype(4064,405,'12N405:M0042605',3881,'12N3881:0002707','M14','M14','M14/(W23/lls1 121D)','M14/(W23/lls1 121D)',['lls1 121D'],'K5302').
genotype(4065,205,'12N205:S0036410',3115,'12N3115:0003309','Mo20W','Mo20W','Mo20W/les23','Mo20W/les23',[les23],'K1802').
genotype(4066,305,'12N305:W0036505',3887,'12N3887:0003606','W23','W23','W23/les23','W23/les23',[les23],'K1802').
genotype(4067,205,'12N205:S0041902',3153,'12N3153:0003802','Mo20W','Mo20W','Mo20W/les23','Mo20W/les23',[les23],'K1804').
genotype(4068,305,'12N305:W0035903',3889,'12N3889:0004008','W23','W23','W23/les23','W23/les23',[les23],'K1804').
genotype(4069,405,'12N405:M0036010',3506,'12N3506:0004113','M14','M14','M14/les23','M14/les23',[les23],'K1804').
genotype(4070,405,'12N405:M0036603',3509,'12N3509:0004302','M14','M14','M14/les23','M14/les23',[les23],'K3514').
genotype(4071,205,'12N205:S0036406',3729,'12N3729:0004505','Mo20W','Mo20W','Mo20W/les23','Mo20W/les23',[les23],'K16306').
genotype(4072,405,'12N405:M0038104',3737,'12N3737:0004706','M14','M14','M14/les23','M14/les23',[les23],'K16306').
genotype(4073,205,'12N205:S0038804',3902,'12N3902:0006508','Mo20W','Mo20W','Mo20W','Mo20W/Les1',['Les1'],'K0106').
genotype(4074,205,'12N205:S0036112',3912,'12N3912:0008310','Mo20W','Mo20W','Mo20W','Mo20W/Les2',['Les2'],'K0202').
genotype(4075,305,'12N305:W0035909',3559,'12N3559:0008501','W23','W23','W23','Les2',['Les2'],'K0202').
genotype(4076,405,'12N405:M0039308',3913,'12N3913:0009003','M14','M14','M14','Les2',['Les2'],'K0202').
genotype(4077,405,'12N405:M0037501',3520,'12N3520:0010910','M14','M14','M14','Les2',['Les2'],'K0203').
genotype(4078,205,'12N205:S0036412',3920,'12N3920:0011307','Mo20W','Mo20W','Mo20W','Les2',['Les2'],'K0207').
genotype(4079,405,'12N405:M0037212',3569,'12N3569:0011705','M14','M14','M14','Les2',['Les2'],'K0207').
genotype(4080,205,'12N205:S0038508',3921,'12N3921:0011908','Mo20W','Mo20W','Mo20W','Les2',['Les2'],'K2002').
genotype(4081,405,'12R405:M0007010',3575,'12R3575:0020505','M14','M14','M14','Les2',['Les2'],'K2002').
genotype(4082,205,'12N205:S0035506',3939,'12N3939:0015204','Mo20W','Mo20W','Mo20W','Les4',['Les4'],'K0302').
genotype(4083,305,'12N305:W0038309',3940,'12N3940:0015409','W23','W23','W23','Les4',['Les4'],'K0302').
genotype(4084,205,'10R205:S0007307',2231,'10R2231:0018405','Mo20W','Mo20W','Mo20W','Les4',['Les4'],'K0303').
genotype(4085,205,'12N205:S0036705',3948,'12N3948:0017506','Mo20W','Mo20W','Mo20W','Les4',['Les4'],'K2101').
genotype(4086,305,'12N305:W0038310',3949,'12N3949:0017706','W23','W23','W23','Les4',['Les4'],'K2101').
%
% oops! this is the same as family 3590.  Looks like each time a family is replanted, a new
% family number is issued.  This shouldn''t happen.
%
% Don''t have time to figure this out now . . . let the duplicated families alone for 13r.
%
% Kazic, 26.5.2013
%
% I think what happens is that when a new family is planted multiple times in the same crop, then each 
% row is given a new family number.  I am not sure what the best way is to fix this, since it is important
% to check the fgenotypes by hand.  The main thing is to be aware this happens.  I have sorted and incremented
% the family numbers manually from here below, since that''s where the problem began.
%
% Kazic, 14.7.2013
%
%
%
% Hmm, this first one was created due to the flip in the last two digits of the male''s family.  Have
% therefore commented it out for now.
%
% Kazic, 13.7.2013
%
% genotype(4087,405,'11N405:M0032808',3419,'11N3419:0010704','M14','M14','M14','Les4',['Les4'],'K2101').
%
% these are nonsensical, as ears already used!  a back-tracking error?
%
% Kazic, 14.7.2013
%
% genotype(4088,305,'12R305:W0011316',305,'12R305:W0011316','W23','W23','W23','W23',['W23'],'').
% genotype(4094,305,'12R305:W0000202',305,'12R305:W0000202','W23','W23','W23','W23',['W23'],'').
%
%
genotype(4087,405,'12N405:M0042504',3255,'12N3255:0020508','M14','M14','M14','Les6',['Les6'],'K0403').
genotype(4088,205,'12N205:S0038208',3965,'12N3965:0020603','Mo20W','Mo20W','Mo20W','Les6',['Les6'],'K2202').
genotype(4089,205,'12N205:S0041602',3970,'12N3970:0021101','Mo20W','Mo20W','Mo20W','Les6',['Les6'],'K2212').
genotype(4090,305,'12N305:W0037407',3971,'12N3971:0021212','W23','W23','W23','Les6',['Les6'],'K2212').
genotype(4091,205,'12N205:S0037911',3973,'12N3973:0021509','Mo20W','Mo20W','Mo20W','Les7',['Les7'],'K0509').
genotype(4092,305,'12N305:W0039207',3614,'12N3614:0024110','W23','W23','W23','Les8',['Les8'],'K2405').
genotype(4093,305,'12R305:W0003814',3715,'12R3715:0027004','W23','W23','W23','Les9',['Les9'],'K0707').
genotype(4094,405,'12N405:M0035703',3993,'12N3993:0024910','M14','M14','M14','Les9',['Les9'],'K0707').
genotype(4095,305,'12N305:W0038909',4008,'12N4008:0027205','W23','W23','W23','Les12',['Les12'],'K1001').
genotype(4096,205,'12N205:S0041303',4017,'12N4017:0028305','Mo20W','Mo20W','Mo20W','Les13',['Les13'],'K1109').
genotype(4097,305,'12N305:W0039204',4020,'12N4020:0028912','W23','W23','W23','Les13',['Les13'],'K2805').
genotype(4098,205,'12N205:S0035808',4021,'12N4021:0029112','Mo20W','Mo20W','Mo20W','Les17',['Les17'],'K1309').
genotype(4099,305,'12N305:W0038903',4022,'12N4022:0029201','W23','W23','W23','Les17',['Les17'],'K1309').
genotype(4100,205,'12N205:S0038205',4028,'12N4028:0030308','Mo20W','Mo20W','Mo20W','Les18',['Les18'],'K1411').
genotype(4101,405,'12N405:M0039507',4037,'12N4037:0031510','M14','M14','M14','Les19',['Les19'],'K1506').
genotype(4102,305,'12R305:W0011604',3702,'12R3702:0036901','W23','W23','W23','Les*-N2418',['Les*-N2418'],'K8501').
genotype(4103,3980,'12N3980:0022805',3980,'12N3980:0022801','Mo20W','Mo20W/Les8','Mo20W','Mo20W/Les8',['Les8'],'K0604').
genotype(4104,3616,'12N3616:0024405',3616,'12N3616:0024412','Mo20W','Mo20W/Les9','Mo20W','Mo20W/Les9',['Les9'],'K0707').
genotype(4105,3915,'12N3915:0010201',3915,'12N3915:0010105','W23','W23/Les2','W23','W23/Les2',['Les2'],'K0203').
genotype(4106,3962,'12N3962:0020204',3962,'12N3962:0020211','W23','W23/Les6','W23','W23/Les6',['Les6'],'K0403').
genotype(4107,3983,'12N3983:0023201',3983,'12N3983:0023202','W23','W23/Les8','W23','W23/Les8',['Les8'],'K0604').
genotype(4108,4036,'12N4036:0031204',4036,'12N4036:0031206','W23','W23/Les19','W23','W23/Les19',['Les19'],'K1506').
genotype(4109,3556,'12N3556:0007110',3556,'12N3556:0007101','W23','W23/Les1','W23','W23/Les1',['Les1'],'K1903').
genotype(4110,3571,'12N3571:0012501',3571,'12N3571:0012502','W23','W23/Les2','W23','W23/Les2',['Les2'],'K2002').
genotype(4111,3966,'12N3966:0020703',3966,'12N3966:0020707','W23','W23/Les6','W23','W23/Les6',['Les6'],'K2202').
genotype(4112,3460,'12N3460:0029708',3460,'12N3460:0029706','W23','W23/Les17','W23','W23/Les17',['Les17'],'K3007').
genotype(4113,4038,'12N4038:0031805',4038,'12N4038:0031803','W23','W23/Les19','W23','W23/Les19',['Les19'],'K3206').
genotype(4114,3584,'12N3584:0015602',3584,'12N3584:0015604','M14','M14/Les4','M14','M14/Les4',['Les4'],'K0302').
genotype(4115,3946,'12N3946:0017106',3946,'12N3946:0017107','M14','M14/Les4','M14','M14/Les4',['Les4'],'K0303').
genotype(4116,664,'12N664:B0034711',663,'12N663:B0034804','B73','B73','B73','B73',['B73'],'K50407').
genotype(4117,664,'12N664:B0034702',664,'12N664:B0034711','B73','B73','B73','B73',['B73'],'K50403').
genotype(4118,656,'12N656:S0035003',655,'12N655:S0034902','Mo20W','Mo20W','Mo20W','Mo20W',['Mo20W'],'K20506').
genotype(4119,655,'12N655:S0034904',656,'12N656:S0035003','Mo20W','Mo20W','Mo20W','Mo20W',['Mo20W'],'K20501').
genotype(4120,657,'12N657:W0035108',657,'12N657:W0035111','W23','W23','W23','W23',['W23'],'K30506').
genotype(4121,657,'12N657:W0035104',657,'12N657:W0035108','W23','W23','W23','W23',['W23'],'K30506').
genotype(4122,661,'12N661:M0035307',661,'12N661:M0035306','M14','M14','M14','M14',['M14'],'K40506').
genotype(4123,661,'12N661:M0035304',661,'12N661:M0035307','M14','M14','M14','M14',['M14'],'K40506').
genotype(4124,3894,'12N3894:0005303',3894,'12N3894:0005303','M14',les23,'M14',les23,[les23],'K1802').
genotype(4125,3894,'12N3894:0005306',3894,'12N3894:0005306','M14',les23,'M14',les23,[les23],'K1802').
genotype(4126,3895,'12N3895:0005406',3895,'12N3895:0005406','Mo20W','les23','Mo20W','les23',[les23],'K3514').
genotype(4127,3895,'12N3895:0005409',3895,'12N3895:0005409','Mo20W','les23','Mo20W','les23',[les23],'K3514').
genotype(4128,205,'12N205:S0037312',2216,'12N2216:0014913','Mo20W','Mo20W','+/Les3-GJ','+/Les3-GJ',['Les3-GJ'],'K11906').
genotype(4129,305,'12N305:W0043205',2216,'12N2216:0014913','W23','W23','+/Les3-GJ','+/Les3-GJ',['Les3-GJ'],'K11906').
genotype(4130,405,'12N405:M0037801',2216,'12N2216:0014913','M14','M14','+/Les3-GJ','+/Les3-GJ',['Les3-GJ'],'K11906').
genotype(4131,3960,'12N3960:0019701',3960,'12N3960:0019701','B73','?/Les5','B73','?/Les5',['Les5'],'K11601').
genotype(4132,3960,'12N3960:0019703',3960,'12N3960:0019703','B73','?/Les5','B73','?/Les5',['Les5'],'K11601').
genotype(4133,3960,'12N3960:0019706',3960,'12N3960:0019706','B73','?/Les5','B73','?/Les5',['Les5'],'K11601').
genotype(4134,3961,'12N3961:0019903',3961,'12N3961:0019903','B73','?/Les5','B73','?/Les5',['Les5'],'K11605').
genotype(4135,3961,'12N3961:0019911',3961,'12N3961:0019911','B73','?/Les5','B73','?/Les5',['Les5'],'K11605').
genotype(4136,3961,'12N3961:0019913',3961,'12N3961:0019913','B73','?/Les5','B73','?/Les5',['Les5'],'K11605').
genotype(4137,305,'12N305:W0042006',4053,'12N4053:0000301','W23','W23','W23','Les15-N2007',['Les15-N2007'],'K6711').
genotype(4138,3890,'12N3890:0004902',3890,'12N3890:0004902','Mo20W','Mo20W/lls1','Mo20W','Mo20W/lls1',[lls1],'K10602').
genotype(4139,3890,'12N3890:0004903',3890,'12N3890:0004903','Mo20W','Mo20W/lls1','Mo20W','Mo20W/lls1',[lls1],'K10602').
genotype(4140,3892,'12N3892:0005106',3892,'12N3892:0005106','W23',lls1,'W23',lls1,[lls1],'K10602').
genotype(4141,3892,'12N3892:0005111',3892,'12N3892:0005111','W23',lls1,'W23',lls1,[lls1],'K10602').
genotype(4142,405,'12N405:M0039511',3884,'12N3884:0003008','M14','M14','W23','Mo20W/(?/lls1-nk)',['lls1-nk'],'K17800').
genotype(4143,305,'12N305:W0037109',3903,'12N3903:0006703','W23','W23','W23','Les1',['Les1'],'K0106').
genotype(4144,205,'12N205:S0036106',3904,'12N3904:0007013','Mo20W','Mo20W','Mo20W','Les1',['Les1'],'K1903').
genotype(4145,205,'12N205:S0036706',3930,'12N3930:0013608','Mo20W','Mo20W','Mo20W','Mo20W/Les2-N845A',['Les2-N845A'],'K5515').
genotype(4146,305,'12R305:W0000204',3577,'12R3577:0020710','W23','W23','W23','W23/Les2-N845A',['Les2-N845A'],'K5515').
genotype(4147,305,'12N305:W0036804',3577,'12N3577:0013711','W23','W23','W23','W23/Les2-N845A',['Les2-N845A'],'K5515').
genotype(4148,405,'12N405:M0037505',3935,'12N3935:0014302','M14','M14','M14','M14/Les2-N845A',['Les2-N845A'],'K5515').
genotype(4149,205,'12N205:S0035508',3936,'12N3936:0014403','Mo20W','Mo20W','Mo20W','M14/Les2-N845A',['Les2-N845A'],'K5525').
genotype(4150,405,'12N405:M0038705',3938,'12N3938:0014702','M14','M14','M14','M14/Les2-N845A',['Les2-N845A'],'K5525').
genotype(4151,401,'09R401:M0041201',2106,'09R2106:0018411','M14','M14','M14','Les6',['Les6'],'K0403').
genotype(4152,205,'12N205:S0037906',3977,'12N3977:0022302','Mo20W','Mo20W','Mo20W','Les7',['Les7'],'K2312').
genotype(4153,305,'12R305:W0001105',3227,'12R3227:0026106','W23','W23','W23','W23/Les7',['Les7'],'K2312').
genotype(4154,305,'12R305:W0001112',3227,'12R3227:0026101','W23','W23','W23','W23/Les7',['Les7'],'K2312').
genotype(4155,405,'12N405:M0037806',3979,'12N3979:0022608','M14','M14','M14','M14/Les7',['Les7'],'K2312').
genotype(4156,405,'12N405:M0039504',3986,'12N3986:0023511','M14','M14','M14','Les8',['Les8'],'K0604').
genotype(4157,205,'12N205:S0037604',3988,'12N3988:0024009','Mo20W','Mo20W','Mo20W','Les8',['Les8'],'K2405').
genotype(4158,405,'12N405:M0042703',3615,'12N3615:0024302','M14','M14','M14','Les8',['Les8'],'K2405').
genotype(4159,205,'12N205:S0035809',3994,'12N3994:0025205','Mo20W','Mo20W','Mo20W','Les9',['Les9'],'K2506').
genotype(4160,205,'12N205:S0037606',3996,'12N3996:0025606','Mo20W','Mo20W','Mo20W','Les10',['Les10'],'K0801').
genotype(4161,205,'12N205:S0036105',3626,'12N3626:0026306','Mo20W','Mo20W','Mo20W','Les11',['Les11'],'K0901').
genotype(4162,405,'12N405:M0039605',3628,'12N3628:0026805','M14','M14','M14','Les11',['Les11'],'K0901').
genotype(4163,205,'12N205:S0037904',3454,'12N3454:0027603','Mo20W','Mo20W','Mo20W','Les12',['Les12'],'K2711').
genotype(4164,305,'12N305:W0041407',4017,'12N4017:0028305','W23','W23','Mo20W','Les13',['Les13'],'K1109').
genotype(4165,305,'11N305:W0040103',3221,'11N3221:0017411','W23','W23','Mo20W','Les13',['Les13'],'K1109').
genotype(4166,405,'12N405:M0042501',3636,'12N3636:0028706','M14','M14','M14','Les13',['Les13'],'K1109').
genotype(4167,205,'12N205:S0037307',4019,'12N4019:0028802','Mo20W','Mo20W','Mo20W','Les13',['Les13'],'K2805').
genotype(4168,405,'11R405:M0051003',2064,'11R2064:0024908','M14','M14','M14','Les17',['Les17'],'K1309').
genotype(4169,405,'12R405:M0009903',3242,'12R3242:0030201','M14','M14','M14','Les17',['Les17'],'K3007').
genotype(4170,405,'12R405:M0011105',3242,'12R3242:0030209','M14','M14','M14','Les17',['Les17'],'K3007').
genotype(4171,305,'12N305:W0039205',4029,'12N4029:0030413','W23','W23','W23','Les18',['Les18'],'K1411').
genotype(4172,405,'12N405:M0039611',4030,'12N4030:0030508','M14','M14','M14','Les18',['Les18'],'K1411').
genotype(4173,205,'12N205:S0036107',4031,'12N4031:0030601','Mo20W','Mo20W','Mo20W','Les18',['Les18'],'K3106').
genotype(4174,405,'12N405:M0036904',4034,'12N4034:0031001','M14','M14','M14','Les18',['Les18'],'K3106').
genotype(4175,205,'12N205:S0035505',4035,'12N4035:0031107','Mo20W','Mo20W','Mo20W','Les19',['Les19'],'K1506').
genotype(4176,205,'12N205:S0036108',3652,'12N3652:0031708','Mo20W','Mo20W','Mo20W','Les19',['Les19'],'K3206').
genotype(4177,301,'09R301:W0043105',2930,'09R2930:0027813','W23','W23','W23','Les20-N2457',['Les20-N2457'],'K7110').
genotype(4178,305,'10R305:W0010718',3053,'10R3053:0034607','W23','W23','W23','Les20-N2457',['Les20-N2457'],'K7110').
genotype(4179,405,'12N405:M0038407',3467,'12N3467:0033608','M14','M14','M14','Les20-N2457',['Les20-N2457'],'K7110').
genotype(4180,405,'12N405:M0038708',3467,'12N3467:0033602','M14','M14','M14','Les20-N2457',['Les20-N2457'],'K7110').
genotype(4181,205,'12N205:S0037311',4047,'12N4047:0033806','Mo20W','Mo20W','Mo20W','Mo20W/(Mo20W/W23)/Les21',['Les21'],'K3311').
genotype(4182,405,'12N405:M0039612',4048,'12N4048:0034110','M14','M14','M14','Les21',['Les21'],'K3311').
genotype(4183,205,'12N205:S0035510',4049,'12N4049:0034204','Mo20W','Mo20W','Mo20W','Les21-N1442',['Les21-N1442'],'K7205').
genotype(4184,405,'12N405:M0038402',4051,'12N4051:0034602','M14','M14','M14','Les21-N1442',['Les21-N1442'],'K7205').
genotype(4185,205,'11N205:S0031511',3486,'11N3486:0023407','Mo20W','Mo20W','M14','Les15-N2007',['Les15-N2007'],'K6711').
genotype(4186,305,'12R305:W0002610',3723,'12R3723:0040009','W23','W23','W23','Les*-mi1',['Les*-mi1'],'K12205').
genotype(4187,205,'12R205:S0010910',3677,'12R3677:0034407','Mo20W','Mo20W','Mo20W','Les*-N1378',['Les*-N1378'],'K7403').
genotype(4188,305,'12R305:W0009204',3678,'12R3678:0034502','W23','W23','W23','Les*-N1378',['Les*-N1378'],'K7403').
genotype(4189,205,'12R205:S0010302',3679,'12R3679:0034605','Mo20W','Mo20W','M14','Les*-N1378',['Les*-N1378'],'K7403').
genotype(4190,205,'12R205:S0011208',3321,'12R3321:0037407','Mo20W','Mo20W','Mo20W','Les*-NA7145',['Les*-NA7145'],'K9113').
genotype(4191,305,'12R305:W0011005',3704,'12R3704:0037515','W23','W23','W23','Les*-NA7145',['Les*-NA7145'],'K9113').
genotype(4192,405,'12R405:M0009304',3323,'12R3323:0037602','M14','M14','M14','Les*-NA7145',['Les*-NA7145'],'K9113').
genotype(4193,205,'12R205:S0010906',3671,'12R3671:0033801','Mo20W','Mo20W','Mo20W','Les101',['Les101'],'K11802').
genotype(4194,405,'12R405:M0011401',3673,'12R3673:0034012','M14','M14','M14','Les101',['Les101'],'K11802').
genotype(4195,205,'12N205:S0037610',3953,'12N3953:0018803','Mo20W','Mo20W','Mo20W','Les4',['Les4'],'K2106').
genotype(4196,3975,'12N3975:0022003',3975,'12N3975:0022001','M14','M14/Les7','M14','M14/Les7',['Les7'],'K0509').




%%%%%%%%% automatically added families for 14R crop; check calculated genotype data! %%%%%%%%%%%%%%
%
% manually checked, correct
%
% Kazic, 20.6.2014



genotype(4197,205,'13R205:S0002208',3617,'13R3617:0017901','Mo20W','Mo20W','Mo20W/lls1 121D','Mo20W/lls1 121D',['lls1 121D'],'K3402').
genotype(4198,205,'12N205:S0042201',3874,'12N3874:0001802','Mo20W','Mo20W','Mo20W/lls1 121D','Mo20W/lls1 121D',['lls1 121D'],'K3402').
genotype(4199,205,'12R205:S0003107',3682,'12R3682:0034913','Mo20W','Mo20W','Mo20W/+/Les*-N1450','Mo20W/+/Les*-N1450',['Les*-N1450'],'K7606').
genotype(4200,305,'12R305:W0002915',3682,'12R3682:0034913','W23','W23','Mo20W/+/Les*-N1450','Mo20W/+/Les*-N1450',['Les*-N1450'],'K7606').
genotype(4201,405,'12R405:M0003005',3682,'12R3682:0034913','M14','M14','Mo20W/+/Les*-N1450','Mo20W/+/Les*-N1450',['Les*-N1450'],'K7606').
genotype(4202,4057,'13R4057:0013901',4057,'13R4057:0013901','Mo20W','{Mo20W|lls1}','Mo20W','{Mo20W|lls1}',[lls1],'K1702').
genotype(4203,4057,'13R4057:0013903',4057,'13R4057:0013903','Mo20W','{Mo20W|lls1}','Mo20W','{Mo20W|lls1}',[lls1],'K1702').
genotype(4204,4058,'13R4058:0014005',4058,'13R4058:0014005','W23','W23/{Mo20W|lls1}','W23','W23/{Mo20W|lls1}',[lls1],'K1702').
genotype(4205,4058,'13R4058:0014012',4058,'13R4058:0014012','W23','W23/{Mo20W|lls1}','W23','W23/{Mo20W|lls1}',[lls1],'K1702').
genotype(4206,4060,'13R4060:0014202',4060,'13R4060:0014202','W23','{W23|lls1 121D}','W23','{W23|lls1 121D}',['lls1 121D'],'K3402').
genotype(4207,4061,'13R4061:0014301',4061,'13R4061:0014301','W23','{W23|lls1 121D}','W23','{W23|lls1 121D}',['lls1 121D'],'K3402').
genotype(4208,3759,'12R3759:0045609',3759,'12R3759:0045609','M14','{W23|lls1 121D}','M14','{W23|lls1 121D}',['lls1 121D'],'K3402').
genotype(4209,4062,'13R4062:0014403',4062,'13R4062:0014403','Mo20W','{Mo20W|lls1 121D}','Mo20W','{Mo20W|lls1 121D}',['lls1 121D'],'K5302').
genotype(4210,4062,'13R4062:0014406',4062,'13R4062:0014406','Mo20W','{Mo20W|lls1 121D}','Mo20W','{Mo20W|lls1 121D}',['lls1 121D'],'K5302').
genotype(4211,4063,'13R4063:0014502',4063,'13R4063:0014502','W23','{W23|lls1 121D}','W23','{W23|lls1 121D}',['lls1 121D'],'K5302').
genotype(4212,4063,'13R4063:0014506',4063,'13R4063:0014506','W23','{W23|lls1 121D}','W23','{W23|lls1 121D}',['lls1 121D'],'K5302').
genotype(4213,4064,'13R4064:0014604',4064,'13R4064:0014604','M14','M14/({W23|lls1 121D})','M14','M14/({W23|lls1 121D})',['lls1 121D'],'K5302').
genotype(4214,4064,'13R4064:0014606',4064,'13R4064:0014606','M14','M14/({W23|lls1 121D})','M14','M14/({W23|lls1 121D})',['lls1 121D'],'K5302').
genotype(4215,3890,'12N3890:0004911',3890,'12N3890:0004911','Mo20W','{Mo20W|lls1}','Mo20W','{Mo20W|lls1}',[lls1],'K10602').
genotype(4216,3891,'12N3891:0005005',3891,'12N3891:0005005','Mo20W','{Mo20W|lls1}','Mo20W','{Mo20W|lls1}',[lls1],'K10602').
genotype(4217,3893,'12N3893:0005201',3893,'12N3893:0005201','W23','lls1','W23','lls1',[lls1],'K10602').
genotype(4218,4059,'13R4059:0014102',4059,'13R4059:0014102','M14','{Mo20W|lls1}','M14','{Mo20W|lls1}',[lls1],'K10602').
genotype(4219,4059,'13R4059:0014105',4059,'13R4059:0014105','M14','{Mo20W|lls1}','M14','{Mo20W|lls1}',[lls1],'K10602').
genotype(4220,305,'12N305:W0035906',3559,'12N3559:0008505','W23','W23','W23','Les2',['Les2'],'K0202').
genotype(4221,305,'12N305:W0035905',3559,'12N3559:0008511','W23','W23','W23','Les2',['Les2'],'K0202').
genotype(4222,405,'13R405:M0002608',4076,'13R4076:0004202','M14','M14','M14','Les2',['Les2'],'K0202').
genotype(4223,305,'11N305:W0038303',3405,'11N3405:0008710','W23','W23','W23','Les2',['Les2'],'K0207').
genotype(4224,305,'11N305:W0038004',3405,'11N3405:0008710','W23','W23','W23','Les2',['Les2'],'K0207').
genotype(4225,405,'13R405:M0002504',4079,'13R4079:0004909','M14','M14','M14','Les2',['Les2'],'K0207').
genotype(4226,405,'13R405:M0002602',4081,'13R4081:0005403','M14','M14','M14','Les2',['Les2'],'K2002').
genotype(4227,205,'13R205:S0002205',4082,'13R4082:0005502','Mo20W','Mo20W','Mo20W','Les4',['Les4'],'K0302').
genotype(4228,305,'13R305:W0000702',4083,'13R4083:0005603','W23','W23','W23','Les4',['Les4'],'K0302').
genotype(4229,205,'13R205:S0002204',4084,'13R4084:0005813','Mo20W','Mo20W','Mo20W','Les4',['Les4'],'K0303').
genotype(4230,4065,'13R4065:0014705',4065,'13R4065:0014705','Mo20W','{Mo20W|les23}','Mo20W','{Mo20W|les23}',[les23],'K1802').
genotype(4231,4065,'13R4065:0014707',4065,'13R4065:0014707','Mo20W','{Mo20W|les23}','Mo20W','{Mo20W|les23}',[les23],'K1802').
genotype(4232,4066,'13R4066:0014804',4066,'13R4066:0014804','W23','{W23|les23}','W23','{W23|les23}',[les23],'K1802').
genotype(4233,4066,'13R4066:0014812',4066,'13R4066:0014812','W23','{W23|les23}','W23','{W23|les23}',[les23],'K1802').
genotype(4234,3894,'12N3894:0005313',3894,'12N3894:0005313','M14','{M14|les23}','M14','{M14|les23}',[les23],'K1802').
genotype(4235,4067,'13R4067:0014910',4067,'13R4067:0014910','Mo20W','{Mo20W|les23}','Mo20W','{Mo20W|les23}',[les23],'K1804').
genotype(4236,4067,'13R4067:0014912',4067,'13R4067:0014912','Mo20W','{Mo20W|les23}','Mo20W','{Mo20W|les23}',[les23],'K1804').
genotype(4237,4068,'13R4068:0015001',4068,'13R4068:0015001','W23','{W23|les23}','W23','{W23|les23}',[les23],'K1804').
genotype(4238,4068,'13R4068:0015008',4068,'13R4068:0015008','W23','{W23|les23}','W23','{W23|les23}',[les23],'K1804').
genotype(4239,4069,'13R4069:0015109',4069,'13R4069:0015109','M14','{M14|les23}','M14','{M14|les23}',[les23],'K1804').
genotype(4240,4069,'13R4069:0015112',4069,'13R4069:0015112','M14','{M14|les23}','M14','{M14|les23}',[les23],'K1804').
genotype(4241,3895,'12N3895:0005412',3895,'12N3895:0005412','Mo20W','{Mo20W|les23}','Mo20W','{Mo20W|les23}',[les23],'K3514').
genotype(4242,3896,'13R3896:0015201',3896,'13R3896:0015201','W23','{W23|les23}','W23','{W23|les23}',[les23],'K3514').
genotype(4243,3896,'13R3896:0015202',3896,'13R3896:0015202','W23','{W23|les23}','W23','{W23|les23}',[les23],'K3514').
genotype(4244,4070,'13R4070:0015306',4070,'13R4070:0015306','M14','{M14|les23}','M14','{M14|les23}',[les23],'K3514').
genotype(4245,4070,'13R4070:0015308',4070,'13R4070:0015308','M14','{M14|les23}','M14','{M14|les23}',[les23],'K3514').
genotype(4246,4071,'13R4071:0015401',4071,'13R4071:0015401','Mo20W','{Mo20W|les23}','Mo20W','{Mo20W|les23}',[les23],'K16306').
genotype(4247,4071,'13R4071:0015405',4071,'13R4071:0015405','Mo20W','{Mo20W|les23}','Mo20W','{Mo20W|les23}',[les23],'K16306').
genotype(4248,3897,'13R3897:0015503',3897,'13R3897:0015503','W23','{W23|les23}','W23','{W23|les23}',[les23],'K16306').
genotype(4249,3897,'13R3897:0015507',3897,'13R3897:0015507','W23','{W23|les23}','W23','{W23|les23}',[les23],'K16306').
genotype(4250,4072,'13R4072:0015601',4072,'13R4072:0015601','M14','{M14|les23}','M14','{M14|les23}',[les23],'K16306').
genotype(4251,4072,'13R4072:0015604',4072,'13R4072:0015604','M14','{M14|les23}','M14','{M14|les23}',[les23],'K16306').
genotype(4252,4128,'13R4128:0016101',4128,'13R4128:0016101','Mo20W','{+|Les3-GJ}','Mo20W','{+|Les3-GJ}',['Les3-GJ'],'K11906').
genotype(4253,4128,'13R4128:0016106',4128,'13R4128:0016106','Mo20W','{+|Les3-GJ}','Mo20W','{+|Les3-GJ}',['Les3-GJ'],'K11906').
genotype(4254,4129,'13R4129:0016205',4129,'13R4129:0016205','W23','{+|Les3-GJ}','W23','{+|Les3-GJ}',['Les3-GJ'],'K11906').
genotype(4255,4130,'13R4130:0016302',4130,'13R4130:0016302','M14','{+|Les3-GJ}','M14','{+|Les3-GJ}',['Les3-GJ'],'K11906').
genotype(4256,4130,'13R4130:0016303',4130,'13R4130:0016303','M14','{+|Les3-GJ}','M14','{+|Les3-GJ}',['Les3-GJ'],'K11906').
genotype(4257,205,'12N205:S0036113',3902,'12N3902:0006503','Mo20W','Mo20W','Mo20W','Mo20W/Les1',['Les1'],'K0106').
genotype(4258,205,'13R205:S0000507',4145,'13R4145:0018815','Mo20W','Mo20W','Mo20W','Mo20W/Les2-N845A',['Les2-N845A'],'K5515').
genotype(4259,405,'13R405:M0002101',4150,'13R4150:0019405','M14','M14','M14','M14/Les2-N845A',['Les2-N845A'],'K5525').
genotype(4260,205,'11N205:S0037004',3433,'11N3433:0012810','Mo20W','Mo20W','Mo20W','Mo20W/Les6',['Les6'],'K0403').
genotype(4261,205,'11N205:S0036711',3445,'11N3445:0015107','Mo20W','Mo20W','Mo20W','Mo20W/Les9',['Les9'],'K0707').
genotype(4262,4093,'13R4093:0008004',4093,'13R4093:0008006','W23','W23/Les9','W23','W23/Les9',['Les9'],'K0707').
genotype(4263,305,'13R305:W0000706',3623,'13R3623:0024902','W23','W23','W23','W23/Les10',['Les10'],'K0801').
genotype(4264,405,'13R405:M0032901',4010,'13R4010:0025802','M14','M14','M14','M14/Les12',['Les12'],'K1001').
genotype(4265,205,'13R205:S0003402',4167,'13R4167:0026602','Mo20W','Mo20W','Mo20W','Mo20W/Les13',['Les13'],'K2805').
genotype(4266,405,'12N405:M0039404',4037,'12N4037:0031509','M14','M14','M14','M14/Les19',['Les19'],'K1506').
genotype(4267,205,'13R205:S0003403',4176,'13R4176:0028502','Mo20W','Mo20W','Mo20W','Mo20W/Les19',['Les19'],'K3206').
genotype(4268,405,'13R405:M0003608',4184,'13R4184:0030002','M14','M14','M14','M14/Les21-N1442',['Les21-N1442'],'K7205').
genotype(4269,305,'13R305:W0003502',4188,'13R4188:0030801','W23','W23','W23','W23/Les*-N1378',['Les*-N1378'],'K7403').
genotype(4270,305,'11N305:W0039211',3488,'11N3488:0023605','W23','W23','W23','W23/Les*-N2397',['Les*-N2397'],'K8414').
genotype(4271,305,'13R305:W0000904',4143,'13R4143:0018509','W23','W23','W23','W23/Les1',['Les1'],'K0106').
genotype(4272,305,'12R305:W0000205',3577,'12R3577:0020708','W23','W23','W23','W23/Les2-N845A',['Les2-N845A'],'K5515').
genotype(4273,305,'12N305:W0042004',3577,'12N3577:0013705','W23','W23','W23','W23/Les2-N845A',['Les2-N845A'],'K5515').
genotype(4274,405,'13R405:M0002601',4148,'13R4148:0019102','M14','M14','M14','M14/Les2-N845A',['Les2-N845A'],'K5515').
genotype(4275,205,'13R205:S0000408',4149,'13R4149:0019212','Mo20W','Mo20W','Mo20W','Mo20W/M14/Les2-N845A',['Les2-N845A'],'K5525').
genotype(4276,305,'12R305:W0011605',3411,'12R3411:0020908','W23','W23','M14','M14/(M14/W23)/Les2-N845A',['Les2-N845A'],'K5525').
genotype(4277,405,'12R405:M0011111',3603,'12R3603:0025303','M14','M14','M14','M14/Les6',['Les6'],'K2202').
genotype(4278,405,'12R405:M0008706',3439,'12R3439:0025605','M14','M14','M14','M14/Les6',['Les6'],'K2212').
genotype(4279,305,'13R305:W0000803',3974,'13R3974:0021303','W23','W23','W23','W23/Les7',['Les7'],'K0509').
genotype(4280,205,'13R205:S0000406',4152,'13R4152:0022407','Mo20W','Mo20W','Mo20W','Mo20W/Les7',['Les7'],'K2312').
genotype(4281,305,'13R305:W0000704',3978,'13R3978:0023002','W23','W23','W23','W23/Les7',['Les7'],'K2312').
genotype(4282,405,'13R405:M0001901',4155,'13R4155:0024010','M14','M14','M14','M14/Les7',['Les7'],'K2312').
genotype(4283,405,'13R405:M0001301',4156,'13R4156:0024208','M14','M14','M14','M14/Les8',['Les8'],'K0604').
genotype(4284,205,'13R205:S0000204',4157,'13R4157:0024305','Mo20W','Mo20W','Mo20W','Mo20W/Les8',['Les8'],'K2405').
genotype(4285,405,'13R405:M0003603',4158,'13R4158:0024402','M14','M14','M14','M14/Les8',['Les8'],'K2405').
genotype(4286,405,'13R405:M0003601',3448,'13R3448:0024704','M14','M14','M14','M14/Les9',['Les9'],'K2506').
genotype(4287,205,'12N205:S0036104',3996,'12N3996:0025603','Mo20W','Mo20W','Mo20W','Mo20W/Les10',['Les10'],'K0801').
genotype(4288,405,'12R405:M0009006',3624,'12R3624:0027703','M14','M14','M14','Mo20W/+/Mo20W/Les10',['Les10'],'K0801').
genotype(4289,205,'13R205:S0000409',3999,'13R3999:0025106','Mo20W','Mo20W','Mo20W','W23/Les10',['Les10'],'K2606').
genotype(4290,405,'13R405:M0001302',4001,'13R4001:0025201','M14','M14','M14','M14/W23/Les10',['Les10'],'K2606').
genotype(4291,205,'13R205:S0000102',4161,'13R4161:0025303','Mo20W','Mo20W','Mo20W','Mo20W/Les11',['Les11'],'K0901').
genotype(4292,205,'12N205:S0038802',4002,'12N4002:0026405','Mo20W','Mo20W','W23','W23/Les11',['Les11'],'K0901').
genotype(4293,405,'12N405:M0039603',4002,'12N4002:0026411','M14','M14','W23','W23/Les11',['Les11'],'K0901').
genotype(4294,305,'11N305:W0040105',3221,'11N3221:0017405','W23','W23','Mo20W','Mo20W/Les13',['Les13'],'K1109').
genotype(4295,405,'13R405:M0003613',3295,'13R3295:0026801','M14','M14','M14','M14/Les13',['Les13'],'K2805').
genotype(4296,405,'13R405:M0032902',4168,'13R4168:0027001','M14','M14','M14','M14/Les17',['Les17'],'K1309').
genotype(4297,405,'12R405:M0010820',3242,'12R3242:0030209','M14','M14','M14','M14/Les17',['Les17'],'K3007').
genotype(4298,405,'12R405:M0011110',3242,'12R3242:0030203','M14','M14','M14','M14/Les17',['Les17'],'K3007').
genotype(4299,305,'12N305:W0039210',4029,'12N4029:0030412','W23','W23','W23','W23/Les18',['Les18'],'K1411').
genotype(4300,405,'12N405:M0038707',4030,'12N4030:0030504','M14','M14','M14','M14/Les18',['Les18'],'K1411').
genotype(4301,205,'12N205:S0035509',4031,'12N4031:0030601','Mo20W','Mo20W','Mo20W','Mo20W/Les18',['Les18'],'K3106').
genotype(4302,405,'12N405:M0036906',4034,'12N4034:0031004','M14','M14','M14','M14/Les18',['Les18'],'K3106').
genotype(4303,205,'12N205:S0035507',4035,'12N4035:0031108','Mo20W','Mo20W','Mo20W','Mo20W/Les19',['Les19'],'K1506').
genotype(4304,405,'13R405:M0033005',4042,'13R4042:0028602','M14','M14','M14','M14/Les19',['Les19'],'K3206').
genotype(4305,405,'11N405:M0033606',3202,'11N3202:0020101','M14','M14','M14','W23/Les19',['Les19'],'K3206').
genotype(4306,405,'12N405:M0036902',3202,'12N3202:0032407','M14','M14','M14','W23/Les19',['Les19'],'K3206').
genotype(4307,405,'12N405:M0038704',3202,'12N3202:0032409','M14','M14','M14','W23/Les19',['Les19'],'K3206').
genotype(4308,205,'13R205:S0000202',4181,'13R4181:0029502','Mo20W','Mo20W','Mo20W','Mo20W/Les21',['Les21'],'K3311').
genotype(4309,205,'12N205:S0035503',4049,'12N4049:0034212','Mo20W','Mo20W','Mo20W','Mo20W/Les21-N1442',['Les21-N1442'],'K7205').
genotype(4310,305,'12R305:W0000807',3658,'12R3658:0032202','W23','W23','W23','W23/Les21-N1442',['Les21-N1442'],'K7205').
genotype(4311,305,'13R305:W0000808',3884,'13R3884:0018201','W23','W23','W23','Mo20W/?/lls1-nk',['lls1-nk'],'K17806').
genotype(4312,405,'13R405:M0002610',4142,'13R4142:0018308','M14','M14','M14','W23/Mo20W/(?/lls1-nk)',['lls1-nk'],'K17806').
genotype(4313,405,'13R405:M0003607',3724,'13R3724:0030603','M14','M14','M14','M14/Les*-mi1',['Les*-mi1'],'K12205').
genotype(4314,205,'13R205:S0000201',4187,'13R4187:0030701','Mo20W','Mo20W','Mo20W','Mo20W/Les*-N1378',['Les*-N1378'],'K7403').
genotype(4315,405,'12R405:M0011113',3679,'12R3679:0034602','M14','M14','M14','M14/Les*-N1378',['Les*-N1378'],'K7403').
genotype(4316,205,'11N205:S0031805',3487,'11N3487:0023511','Mo20W','Mo20W','Mo20W','M14/(M14/+)/Les*-N2397',['Les*-N2397'],'K8414').
genotype(4317,405,'11N405:M0037603',3489,'11N3489:0023703','M14','M14','M14','M14/Les*-N2397',['Les*-N2397'],'K8414').
genotype(4318,205,'12R205:S0009109',3270,'12R3270:0014314','Mo20W','Mo20W','Mo20W','W23/Les15-N2007',['Les15-N2007'],'K6711').




% manually added in case this was packed; it appears in crops/14r/planning/sequenced.packing_plan.pl
%
% Kazic, 6.8.2014

genotype(4319,4129,'13R4129:0016213',4129,'13R4129:0016213','W23','{+|Les3-GJ}','W23','{+|Les3-GJ}',['Les3-GJ'],'K11906').




% double mutants: not sure what convention should be for the K number
%
% fix Ks!
%
% Kazic, 17.7.2016

genotype(4320,4105,'13R4105:0010503',4106,'13R4106:0010704','W23','W23/Les2','W23','W23/Les6',['Les2/Les6'],'K').
genotype(4321,4107,'13R4107:0010914',4106,'13R4106:0010813','W23','W23/Les8','W23','W23/Les6',['Les8/Les6'],'K').
genotype(4322,4105,'13R4105:0010612',4107,'13R4107:0010906','W23','W23/Les2','W23','W23/Les8',['Les2/Les8'],'K').
genotype(4323,4110,'13R4110:0011606',4111,'13R4111:0011915','W23','W23/Les2','W23','W23/Les6',['Les2/Les6'],'K').
genotype(4324,4110,'13R4110:0011810',4112,'13R4112:0012401','W23','W23/Les2','W23','W23/Les17',['Les2/Les17'],'K').
genotype(4325,4109,'13R4109:0011304',4110,'13R4110:0011603','W23','W23/Les1','W23','W23/Les2',['Les1/Les2'],'K').
genotype(4326,4109,'13R4109:0011306',4111,'13R4111:0011911','W23','W23/Les1','W23','W23/Les6',['Les1/Les6'],'K').
genotype(4327,4109,'13R4109:0011412',4112,'13R4112:0012209','W23','W23/Les1','W23','W23/Les17',['Les1/Les17'],'K').








%%%%%%%%% automatically added families for 15R crop; check calculated genotype data! %%%%%%%%%%%%%%
%
% checked and corrected
%
% Kazic, 4.8.2015

genotype(4328,4197,'14R4197:0015402',4197,'14R4197:0015402','Mo20W','Mo20W/{+|lls1 121D}','Mo20W','Mo20W/{+|lls1 121D}',['lls1 121D'],'K3402').
genotype(4329,4198,'14R4198:0015503',4198,'14R4198:0015503','Mo20W','Mo20W/{+|lls1 121D}','Mo20W','Mo20W/{+|lls1 121D}',['lls1 121D'],'K3402').
genotype(4330,4060,'13R4060:0014214',4060,'13R4060:0014214','W23','W23/{+|lls1 121D}','W23','W23/{+|lls1 121D}',['lls1 121D'],'K3402').
genotype(4331,4061,'13R4061:0014308',4061,'13R4061:0014308','W23','W23/{+|lls1 121D}','W23','W23/{+|lls1 121D}',['lls1 121D'],'K3402').
genotype(4332,3757,'12R3757:0045402',3757,'12R3757:0045402','M14','W23/{+|lls1 121D}','M14','W23/{+|lls1 121D}',['lls1 121D'],'K3402').
genotype(4333,3758,'12R3758:0045504',3758,'12R3758:0045504','M14','W23/{+|lls1 121D}','M14','W23/{+|lls1 121D}',['lls1 121D'],'K3402').
genotype(4334,3759,'12R3759:0045612',3759,'12R3759:0045612','M14','W23/lls1 121D','M14','W23/lls1 121D',['lls1 121D'],'K3402').
genotype(4335,305,'14R305:W0000805',4204,'14R4204:0004614','W23','W23','W23/{Mo20W|lls1}','W23/{Mo20W|lls1}',[lls1],'K1702').
genotype(4336,405,'14R405:M0004006',3742,'14R3742:0004917','M14','M14','M14/{+|lls1}','M14/{+|lls1}',[lls1],'K1702').
genotype(4337,205,'14R205:S0000305',4209,'14R4209:0005418','Mo20W','Mo20W','{+|lls1 121D}','{+|lls1 121D}',['lls1 121D'],'K5302').
genotype(4338,205,'14R205:S0000507',4209,'14R4209:0005425','Mo20W','Mo20W','{+|lls1 121D}','{+|lls1 121D}',['lls1 121D'],'K5302').
genotype(4339,305,'14R305:W0000806',4232,'14R4232:0016701','W23','W23','{+|les23}','{+|les23}',[les23],'K1802').
genotype(4340,405,'14R405:M0001301',4124,'14R4124:0016906','M14','M14','M14/les23','M14/les23',[les23],'K1802').
genotype(4341,305,'14R305:W0000807',4237,'14R4237:0017306','W23','W23','W23/{W23|les23}','W23/{W23|les23}',[les23],'K1804').
genotype(4342,205,'14R205:S0000614',4126,'14R4126:0017701','Mo20W','Mo20W','Mo20W/les23','Mo20W/les23',[les23],'K3514').
genotype(4343,305,'14R305:W0003118',4243,'14R4243:0018003','W23','W23','W23/{W23|les23}','W23/{W23|les23}',[les23],'K3514').
genotype(4344,305,'14R305:W0000902',4249,'14R4249:0018605','W23','W23','W23/{W23|les23}','W23/{W23|les23}',[les23],'K16306').
genotype(4345,205,'14R205:S0000411',4253,'14R4253:0019006','Mo20W','Mo20W','Mo20W/Les3-GJ','Mo20W/Les3-GJ',['Les3-GJ'],'K11906').
genotype(4346,305,'14R305:W0000917',4254,'14R4254:0019108','W23','W23','W23/Les3-GJ','W23/Les3-GJ',['Les3-GJ'],'K11906').
genotype(4347,305,'12R305:W0003802',3766,'12R3766:0046602','W23','W23','W23/les*-74-1873-9','W23/les*-74-1873-9',['les*-74-1873-9'],'K9304').
genotype(4348,305,'12R305:W0004115',3766,'12R3766:0046613','W23','W23','W23/les*-74-1873-9','W23/les*-74-1873-9',['les*-74-1873-9'],'K9304').
genotype(4349,305,'12R305:W0011006',3781,'12R3781:0048708','W23','W23','W23/les*-N2012','W23/les*-N2012',['les*-N2012'],'K7702').
genotype(4350,305,'14R305:W0000704',4220,'14R4220:0006819','W23','W23','W23','W23/Les2',['Les2'],'K0202').
genotype(4351,305,'14R305:W0001012',1012,'14R1012:0007612','W23','W23','Mo20W/+','Mo20W/Les2',['Les2'],'K0207').
genotype(4352,305,'14R305:W0001001',3958,'14R3958:0010412','W23','W23','W23','W23/Les4',['Les4'],'K2106').
genotype(4353,405,'14R405:M0001404',3959,'14R3959:0010509','M14','M14','M14','M14/Les4',['Les4'],'K2106').
genotype(4354,405,'12R405:M0008708',3603,'12R3603:0025312','M14','M14','M14','M14/Les6',['Les6'],'K2202').
genotype(4355,405,'12R405:M0008709',3603,'12R3603:0025309','M14','M14','M14','M14/Les6',['Les6'],'K2202').
genotype(4356,405,'14R405:M0001101',4278,'14R4278:0020905','M14','M14','M14','M14/Les6',['Les6'],'K2212').
genotype(4357,305,'10R305:W0001511',1035,'10R1035:0021903','W23','W23','W23','W23/(Mo20W/Les7)',['Les7'],'K0509').
genotype(4358,305,'13R305:W0000703',3978,'13R3978:0022805','W23','W23','W23','W23/Les7',['Les7'],'K2312').
genotype(4359,305,'13R305:W0000705',3978,'13R3978:0023013','W23','W23','W23','W23/Les7',['Les7'],'K2312').
genotype(4360,305,'13R305:W0000801',3978,'13R3978:0022905','W23','W23','W23','W23/Les7',['Les7'],'K2312').
genotype(4361,405,'14R405:M0001304',4162,'14R4162:0022908','M14','M14','M14','M14/Les11',['Les11'],'K0901').
genotype(4362,405,'14R405:M0001803',4166,'14R4166:0023701','M14','M14','M14','M14/Les13',['Les13'],'K1109').
genotype(4363,305,'14R305:W0000706',4310,'14R4310:0026401','W23','W23','W23','W23/Les21-N1442',['Les21-N1442'],'K7205').
genotype(4364,405,'13R405:M0002611',4142,'13R4142:0018305','M14','M14','M14','W23/(Mo20W/(?/lls1-nk))',['lls1-nk'],'K17800').
genotype(4365,405,'14R405:M0001107',3279,'14R3279:0027501','M14','M14','M14','M14/(W23/Les*-N2418)',['Les*-N2418'],'K8501').
genotype(4366,205,'10R205:S0006107',3065,'10R3065:0037509','Mo20W','Mo20W','Mo20W','Mo20W/((B73 Ht1/Mo17)/Les*-NA7145)',['Les*-NA7145'],'K9113').
genotype(4367,401,'09R401:M0056405',1135,'09R1135:0030501','M14','M14','Mo20W','((B73 Ht1/Mo17)/Les*-NA7145)',['Les*-NA7145'],'K9113').
genotype(4368,401,'09R401:M0057301',1135,'09R1135:0030511','M14','M14','Mo20W','((B73 Ht1/Mo17)/Les*-NA7145)',['Les*-NA7145'],'K9113').
genotype(4369,4057,'13R4057:0013913',4057,'13R4057:0013913','Mo20W','Mo20W/lls1','Mo20W','Mo20W/lls1',[lls1],'K1702').
genotype(4370,205,'14R205:S0002703',4236,'14R4236:0017206','Mo20W','Mo20W','Mo20W/les23','Mo20W/les23',[les23],'K1804').
genotype(4371,405,'14R405:M0001406',4240,'14R4240:0017606','M14','M14','M14/les23','M14/les23',[les23],'K1804').
genotype(4372,405,'14R405:M0001310',4245,'14R4245:0018210','M14','M14','M14/les23','M14/les23',[les23],'K3514').
genotype(4373,405,'14R405:M0001302',4251,'14R4251:0018805','M14','M14','M14/les23','M14/les23',[les23],'K16306').
genotype(4374,205,'14R205:S0000302',4253,'14R4253:0019009','Mo20W','Mo20W','Mo20W/Les3-GJ','Mo20W/Les3-GJ',['Les3-GJ'],'K11906').
genotype(4375,305,'14R305:W0000911',4254,'14R4254:0019102','W23','W23','W23/Les3-GJ','W23/Les3-GJ',['Les3-GJ'],'K11906').
genotype(4376,405,'14R405:M0001111',4256,'14R4256:0019402','M14','M14','M14/Les3-GJ','M14/Les3-GJ',['Les3-GJ'],'K11906').


genotype(4377,405,'14R405:M0001205',4256,'14R4256:0019413','M14','M14','M14/Les3-GJ','M14/Les3-GJ',['Les3-GJ'],'K11906').

genotype(4378,205,'12R205:S0010602',3763,'12R3763:0046302','Mo20W','Mo20W','Mo20W/les*-74-1873-9','Mo20W/les*-74-1873-9',['les*-74-1873-9'],'K9304').
genotype(4379,205,'12R205:S0010603',3764,'12R3764:0046401','Mo20W','Mo20W','Mo20W/les*-74-1873-9','Mo20W/les*-74-1873-9',['les*-74-1873-9'],'K9304').
genotype(4380,405,'12R405:M0009911',3769,'12R3769:0046902','M14','M14','M14/les*-74-1873-9','M14/les*-74-1873-9',['les*-74-1873-9'],'K9304').
genotype(4381,405,'12R405:M0010809',3769,'12R3769:0046903','M14','M14','M14/les*-74-1873-9','M14/les*-74-1873-9',['les*-74-1873-9'],'K9304').
genotype(4382,405,'12R405:M0011703',3784,'12R3784:0049001','M14','M14','M14/les*-N2012','M14/les*-N2012',['les*-N2012'],'K7702').
genotype(4383,405,'12R405:M0010216',3793,'12R3793:0049902','M14','M14','M14/les*-N2013','M14/les*-N2013',['les*-N2013'],'K7807').
genotype(4384,405,'14R405:M0001802',4271,'14R4271:0019507','M14','M14','W23','W23/Les1',['Les1'],'K0106').
genotype(4385,405,'14R405:M0001705',4271,'14R4271:0019512','M14','M14','W23','W23/Les1',['Les1'],'K0106').
genotype(4386,405,'14R405:M0001704',4271,'14R4271:0019513','M14','M14','W23','W23/Les1',['Les1'],'K0106').
genotype(4387,305,'14R305:W0000804',1012,'14R1012:0007613','W23','W23','Mo20W/+','Mo20W/Les2',['Les2'],'K0207').
genotype(4388,305,'14R305:W0000709',1012,'14R1012:0007616','W23','W23','Mo20W/+','Mo20W/Les2',['Les2'],'K0207').
genotype(4389,305,'14R305:W0003701',1012,'14R1012:0007707','W23','W23','Mo20W/+','Mo20W/Les2',['Les2'],'K0207').
genotype(4390,205,'14R205:S0000109',4280,'14R4280:0021111','Mo20W','Mo20W','Mo20W','Mo20W/Les7',['Les7'],'K2312').
genotype(4391,205,'14R205:S0000401',4159,'14R4159:0021808','Mo20W','Mo20W','Mo20W','Mo20W/Les9',['Les9'],'K2506').
genotype(4392,405,'14R405:M0001308',4286,'14R4286:0021905','M14','M14','M14','M14/Les9',['Les9'],'K2506').
genotype(4393,305,'14R305:W0000808',3937,'14R3937:0020415','W23','W23','W23','M14/Les2-N845A',['Les2-N845A'],'K5525').
genotype(4394,305,'14R305:W0001004',4276,'14R4276:0020505','W23','W23','W23','(M14/M14/(M14/W23))/Les2-N845A',['Les2-N845A'],'K5525').
genotype(4395,205,'14R205:S0000316',4289,'14R4289:0022506','Mo20W','Mo20W','Mo20W','Mo20W/(W23/Les10)',['Les10'],'K2606').
genotype(4396,205,'11N205:S0033402',3189,'11N3189:0016807','Mo20W','Mo20W','Mo20W','Mo20W/Les12',['Les12'],'K1001').
genotype(4397,205,'11N205:S0034309',3189,'11N3189:0016803','Mo20W','Mo20W','Mo20W','Mo20W/Les12',['Les12'],'K1001').
genotype(4398,405,'12R405:M0001502',3451,'12R3451:0028012','M14','M14','M14','W23/(W23/Les10)',['Les10'],'K2606').
genotype(4399,405,'12R405:M0008203',3645,'12R3645:0030503','M14','M14','M14','M14/((M14/Mo20W)/Les18)',['Les18'],'K1411').
genotype(4400,405,'12N405:M0039407',4030,'12N4030:0030501','M14','M14','M14','M14/Les18',['Les18'],'K1411').
genotype(4401,405,'14R405:M0001603',4304,'14R4304:0025007','M14','M14','M14','M14/Les19',['Les19'],'K3206').
genotype(4402,305,'14R305:W0000904',4294,'14R4294:0023515','W23','W23','W23','Mo20W/Les13',['Les13'],'K1109').
genotype(4403,205,'10R205:S0001407',2929,'10R2929:0034506','Mo20W','Mo20W','Mo20W','M14/((W23/L317)/Les20-N2457)',['Les20-N2457'],'K7110').
genotype(4404,205,'10R205:S0009812',2929,'10R2929:0034509','Mo20W','Mo20W','Mo20W','M14/((W23/L317)/Les20-N2457)',['Les20-N2457'],'K7110').
genotype(4405,301,'09R301:W0045206',2930,'09R2930:0027810','W23','W23','W23','M14/((W23/L317)/Les20-N2457)',['Les20-N2457'],'K7110').
genotype(4406,405,'10R405:M0007807',2932,'10R2932:0034702','M14','M14','M14','M14/((W23/L317)/Les20-N2457)',['Les20-N2457'],'K7110').
genotype(4407,405,'10R405:M0008104',2932,'10R2932:0034704','M14','M14','M14','M14/((W23/L317)/Les20-N2457)',['Les20-N2457'],'K7110').
genotype(4408,405,'14R405:M0001610',4048,'14R4048:0026106','M14','M14','M14','M14/((M14/W23)/Les21)',['Les21'],'K3311').
genotype(4409,205,'14R205:S0000516',4309,'14R4309:0026303','Mo20W','Mo20W','Mo20W','Mo20W/Les21-N1442',['Les21-N1442'],'K7205').
genotype(4410,205,'12R205:S0004002',3532,'12R3532:0015801','Mo20W','Mo20W','Mo20W','?/lls1-nk',['lls1-nk'],'K17800').
genotype(4411,205,'12R205:S0010303',3532,'12R3532:0015810','Mo20W','Mo20W','Mo20W','?/lls1-nk',['lls1-nk'],'K17800').
genotype(4412,205,'14R205:S0000506',3722,'14R3722:0026809','Mo20W','Mo20W','Mo20W','Mo20W/Les*-mi1',['Les*-mi1'],'K12205').
genotype(4413,205,'12R205:S0010306',3532,'12R3532:0015810','Mo20W','Mo20W','Mo20W','?/lls1-nk',['lls1-nk'],'K17800').
genotype(4414,305,'14R305:W0003105',4311,'14R4311:0026603','W23','W23','W23','W23/(Mo20W/lls1-nk)',['lls1-nk'],'K17806').
genotype(4415,205,'11R205:S0049013',3277,'11R3277:0030610','Mo20W','Mo20W','W23','W23/Les*-N2397',['Les*-N2397'],'K8414').
genotype(4416,205,'11N205:S0030707',3487,'11N3487:0023509','Mo20W','Mo20W','Mo20W','M14/Les*-N2397',['Les*-N2397'],'K8414').
genotype(4417,205,'10R205:S0006112',3065,'10R3065:0037509','Mo20W','Mo20W','Mo20W','Mo20W/((B73 Ht1/Mo17)/Les*-NA7145)',['Les*-NA7145'],'K9113').
genotype(4418,205,'11N205:S0033012',3486,'11N3486:0023408','Mo20W','Mo20W','M14','M14/((W23/M14)/Les15-N2007))',['Les15-N2007'],'K6711').








%%%%%%%%%%%%%%%%%%%% added families for seed packed for 15r but not planted %%%%%%%%%%%%%%%%%%%%%
%
% normally, these would not be issued numbers, but since the seed was
% packed, at some point it is likely to be planted.  Therefore, issue the
% numbers now to prevent any confusion.
%
% Kazic, 18.7.2016


genotype(4419,201,'09R201:S0040305',1416,'09R1416:0025907','Mo20W','Mo20W','W23/M14','+/Les15-N2007',['Les15-N2007'],'K6711').
genotype(4420,401,'09R401:M0051104',1416,'09R1416:0025907','M14','M14','W23/M14','+/Les15-N2007',['Les15-N2007'],'K6711').
genotype(4421,401,'09R401:M0056406',1416,'09R1416:0025906','M14','M14','W23/M14','+/Les15-N2007',['Les15-N2007'],'K6711').
genotype(4422,205,'10R205:S0000809',2251,'10R2251:0031606','Mo20W','Mo20W','Mo20W/W23','W23/M14/+/Les15-N2007',['Les15-N2007'],'K6711').
genotype(4423,205,'10R205:S0002303',2252,'10R2252:0031708','Mo20W','Mo20W','Mo20W/W23','W23/M14/+/Les15-N2007',['Les15-N2007'],'K6711').
genotype(4424,405,'11N405:M0035706',3437,'11N3437:0013304','M14','M14','M14','(M14/W23)/Les6',['Les6'],'K2202').
genotype(4425,305,'12N305:W0042007',4053,'12N4053:0000301','W23','W23','W23','Les15-N2007',['Les15-N2007'],'K6711').
genotype(4426,405,'12N405:M0039407',4030,'12N4030:0030501','M14','M14','M14','Les18',['Les18'],'K1411').
genotype(4427,205,'12R205:S0008815',3270,'12R3270:0014314','Mo20W','Mo20W','Mo20W','W23/Les15-N2007',['Les15-N2007'],'K6711').
genotype(4428,305,'12R305:W0009213',3456,'12R3456:0014504','W23','W23','M14','Les6',['Les6'],'K0403').
genotype(4429,4087,'13R4087:0006905',4087,'13R4087:0006903','M14','M14','M14','Les6',['Les6'],'K0403').
genotype(4430,193,'14R0193:0027905',193,'14R0193:0027905','Idf B Pl','W22','Idf B Pl','W22',['Idf B Pl sib'],'K19305').
genotype(4431,4012,'14R4012:0013304',4012,'14R4012:0013317','W23','W23','W23','Les12',['Les12'],'K2711').
genotype(4432,4013,'14R4013:0013414',4013,'14R4013:0013402','M14','M14','M14','Les12',['Les12'],'K2711').
genotype(4433,4102,'14R4102:0015303',4102,'14R4102:0015305','W23','W23','W23','Les*-N2418',['Les*-N2418'],'K8501').
genotype(4434,4262,'14R4262:0012501',4262,'14R4262:0012509','W23','W23','{W23 or Les9}','{W23 or Les9}',['Les9'],'K0707').
genotype(4435,4264,'14R4264:0013207',4264,'14R4264:0013209','M14','M14','M14','Les12',['Les12'],'K1001').
genotype(4436,205,'14R205:S0000101',4314,'14R4314:0027101','Mo20W','Mo20W','Mo20W','Les*-N1378',['Les*-N1378'],'K7403').
genotype(4437,205,'14R205:S0000105',4284,'14R4284:0021512','Mo20W','Mo20W','Mo20W','Les8',['Les8'],'K2405').
genotype(4438,205,'14R205:S0000204',4301,'14R4301:0024705','Mo20W','Mo20W','Mo20W','Les18',['Les18'],'K3106').
genotype(4439,205,'14R205:S0000208',4308,'14R4308:0026010','Mo20W','Mo20W','Mo20W','Les21',['Les21'],'K3311').
genotype(4440,205,'14R205:S0000212',4144,'14R4144:0019801','Mo20W','Mo20W','Mo20W','Les1',['Les1'],'K1903').
genotype(4441,205,'14R205:S0000215',4229,'14R4229:0009701','Mo20W','Mo20W','Mo20W','Les4',['Les4'],'K0303').
genotype(4442,205,'14R205:S0000405',4303,'14R4303:0024904','Mo20W','Mo20W','Mo20W','Les19',['Les19'],'K1506').
genotype(4443,205,'14R205:S0000415',4291,'14R4291:0022711','Mo20W','Mo20W','Mo20W','Les11',['Les11'],'K0901').
genotype(4444,205,'14R205:S0000508',4287,'14R4287:0022003','Mo20W','Mo20W','Mo20W','Les10',['Les10'],'K0801').
genotype(4445,205,'14R205:S0000607',4275,'14R4275:0020306','Mo20W','Mo20W','Mo20W','Les2-N845A',['Les2-N845A'],'K5525').
genotype(4446,305,'14R305:W0000705',4137,'14R4137:0004215','W23','W23','W23','Les15-N2007',['Les15-N2007'],'K6711').
genotype(4447,305,'14R305:W0000714',4186,'14R4186:0026904','W23','W23','W23','Les*-mi1',['Les*-mi1'],'K12205').
genotype(4448,305,'14R305:W0000905',4273,'14R4273:0020102','W23','W23','W23','Les2-N845A',['Les2-N845A'],'K5515').
genotype(4449,305,'14R305:W0001006',4299,'14R4299:0024502','W23','W23','W23','Les18',['Les18'],'K1411').
genotype(4450,305,'14R305:W0001016',4271,'14R4271:0019503','W23','W23','W23','Les*-N2397',['Les*-N2397'],'K8414').
genotype(4451,305,'14R305:W0002901',4191,'14R4191:0027703','W23','W23','W23','Les*-NA7145',['Les*-NA7145'],'K9113').
genotype(4452,405,'14R405:M0001103',4285,'14R4285:0021603','M14','M14','M14','Les8',['Les8'],'K2405').
genotype(4453,405,'14R405:M0001105',4283,'14R4283:0021405','M14','M14','M14','Les8',['Les8'],'K0604').
genotype(4454,405,'14R405:M0001209',4302,'14R4302:0024808','M14','M14','M14','Les18',['Les18'],'K3106').
genotype(4455,405,'14R405:M0001211',4282,'14R4282:0021308','M14','M14','M14','Les7',['Les7'],'K2312').
genotype(4456,405,'14R405:M0001512',4315,'14R4315:0027205','M14','M14','M14','Les*-N1378',['Les*-N1378'],'K7403').
genotype(4457,405,'14R405:M0001806',4077,'14R4077:0007406','M14','M14','M14','Les2',['Les2'],'K0203').
genotype(4458,405,'14R405:M0001808',4296,'14R4296:0024014','M14','M14','M14','Les17',['Les17'],'K1309').
genotype(4459,405,'14R405:M0001815',4313,'14R4313:0027007','M14','M14','M14','Les*-mi1',['Les*-mi1'],'K12205').














%%%%%%%% family numbers from here on must be issued and genotypes included



% lines planted in 16r; manually added families; used org to generate
% family numbers
%
% Kazic, 18.7.2016



genotype(4460,205,'12N205:S0041906',3738,'12N3738:0000804','Mo20W','Mo20W','Mo20W/lls1','Mo20W/lls1',[lls1],'K1702').
genotype(4461,305,'15R305:W0003009',4331,'15R4331:0004904','W23','W23','lls1 121D','lls1 121D',['lls1 121D'],'K3402').
genotype(4462,405,'15R405:M0003904',3877,'15R3877:0005004','M14','M14','lls1 121D','lls1 121D',['lls1 121D'],'K3402').
genotype(4463,305,'15R305:W0002701',4211,'15R4211:0005516','W23','W23','lls1 121D','lls1 121D',['lls1 121D'],'K5302').
genotype(4464,405,'15R405:M0003710',4213,'15R4213:0005618','M14','M14','lls1 121D','lls1 121D',['lls1 121D'],'K5302').
genotype(4465,205,'15R205:S0000501',4231,'15R4231:0009207','Mo20W','Mo20W','les23','les23',['les23'],'K1802').
genotype(4466,205,'15R205:S0002605',4247,'15R4247:0009302','Mo20W','Mo20W','les23','les23',['les23'],'K16306').
genotype(4467,4339,'15R4339:0006503',4339,'15R4339:0006503','W23','les23','W23','les23',['les23'],'K1802').
genotype(4468,4340,'15R4340:0006601',4340,'15R4340:0006601','M14','les23','M14','les23',['les23'],'K1802').
genotype(4469,4370,'15R4370:0006703',4370,'15R4370:0006703','Mo20W','les23','Mo20W','les23',['les23'],'K1804').
genotype(4470,4341,'15R4341:0006805',4341,'15R4341:0006805','W23','les23','W23','les23',['les23'],'K1804').
genotype(4471,4371,'15R4371:0006904',4371,'15R4371:0006904','M14','les23','M14','les23',['les23'],'K1804').
genotype(4472,4342,'15R4342:0007002',4342,'15R4342:0007002','Mo20W','les23','Mo20W','les23',['les23'],'K3514').
genotype(4473,4343,'15R4343:0007101',4343,'15R4343:0007101','W23','les23','W23','les23',['les23'],'K3514').
genotype(4474,4372,'15R4372:0007201',4372,'15R4372:0007201','M14','les23','M14','les23',['les23'],'K3514').
genotype(4475,4344,'15R4344:0007301',4344,'15R4344:0007301','W23','les23','W23','les23',['les23'],'K16306').
genotype(4476,4373,'15R4373:0007403',4373,'15R4373:0007403','M14','les23','M14','les23',['les23'],'K16306').
% genotype(4477,305,'15R305:W0000908',4373,'15R4373:0007409','W23','W23','M14','les23',['les23'],'K16306').
genotype(4478,4374,'15R4374:0007503',4374,'15R4374:0007503','Mo20W','Les3-GJ','Mo20W','Les3-GJ',['Les3-GJ'],'K11906').
genotype(4479,4345,'15R4345:0007602',4345,'15R4345:0007602','Mo20W','Les3-GJ','Mo20W','Les3-GJ',['Les3-GJ'],'K11906').
genotype(4480,4375,'15R4375:0007701',4375,'15R4375:0007701','W23','Les3-GJ','W23','Les3-GJ',['Les3-GJ'],'K11906').
genotype(4481,4346,'15R4346:0007801',4346,'15R4346:0007801','W23','Les3-GJ','W23','Les3-GJ',['Les3-GJ'],'K11906').
genotype(4482,4376,'15R4376:0007903',4376,'15R4376:0007903','M14','Les3-GJ','M14','Les3-GJ',['Les3-GJ'],'K11906').
genotype(4483,4377,'15R4377:0008008',4377,'15R4377:0008008','M14','Les3-GJ','M14','Les3-GJ',['Les3-GJ'],'K11906').
genotype(4484,205,'15R205:S0002207',685,'15R0685:0009103','Mo20W','Mo20W','+/les5-N1449','+/les5-N1449',['les5-N1449'],'K68503').
genotype(4485,305,'15R305:W0003209',685,'15R0685:0009103','W23','W23','+/les5-N1449','+/les5-N1449',['les5-N1449'],'K68503').
genotype(4486,405,'15R405:M0003505',685,'15R0685:0009103','M14','M14','+/les5-N1449','+/les5-N1449',['les5-N1449'],'K68503').
genotype(4487,205,'15R205:S0002205',685,'15R0685:0009107','Mo20W','Mo20W','+/les5-N1449','+/les5-N1449',['les5-N1449'],'K68507').
genotype(4488,305,'15R305:W0003115',685,'15R0685:0009107','W23','W23','+/les5-N1449','+/les5-N1449',['les5-N1449'],'K68507').
genotype(4489,405,'15R405:M0003507',685,'15R0685:0009107','M14','M14','+/les5-N1449','+/les5-N1449',['les5-N1449'],'K68507').
genotype(4490,205,'14R205:S0000215',4229,'14R4229:0009701','Mo20W','Mo20W','Mo20W','Les4',['Les4'],'K0303').
genotype(4491,305,'15R305:W0000711',4352,'15R4352:0010904','W23','W23','W23','Les4',['Les4'],'K2106').
genotype(4492,405,'15R405:M0001101',4353,'15R4353:0011002','M14','M14','M14','Les4',['Les4'],'K2106').
genotype(4493,405,'14R405:M0001105',4283,'14R4283:0021405','M14','M14','M14','Les8',['Les8'],'K0604').
genotype(4494,205,'14R205:S0000105',4284,'14R4284:0021512','Mo20W','Mo20W','Mo20W','Les8',['Les8'],'K2405').
genotype(4495,405,'14R405:M0001103',4285,'14R4285:0021603','M14','M14','M14','Les8',['Les8'],'K2405').
genotype(4496,405,'15R405:M0001411',4384,'15R4384:0009402','M14','M14','M14','M14/(W23/Les1)',['Les1'],'K0106').
genotype(4497,305,'14R305:W0000704',4220,'14R4220:0006819','W23','W23','W23','Les2',['Les2'],'K0202').
genotype(4498,305,'15R305:W0000906',4351,'15R4351:0010005','W23','W23','W23/Mo20W','W23/(Mo20W/Les2)',['Les2'],'K0207').
genotype(4499,305,'15R305:W0002901',4389,'15R4389:0010801','W23','W23','W23/Mo20W','W23/(Mo20W/Les2)',['Les2'],'K0207').
genotype(4500,205,'14R205:S0000607',4275,'14R4275:0020306','Mo20W','Mo20W','Mo20W','Les2-N845A',['Les2-N845A'],'K5525').
genotype(4501,305,'14R305:W0000808',3937,'14R3937:0020415','W23','W23','W23/M14','M14/Les2-N845A',['Les2-N845A'],'K5525').
genotype(4502,405,'14R405:M0001101',4278,'14R4278:0020905','M14','M14','M14','Les6',['Les6'],'K2212').
genotype(4503,305,'10R305:W0001511',1035,'10R1035:0021903','W23','W23','W23/Mo20W','Mo20W/Les7',['Les7'],'K0509').
genotype(4504,205,'14R205:S0000109',4280,'14R4280:0021111','Mo20W','Mo20W','Mo20W','Les7',['Les7'],'K2312').
genotype(4505,205,'15R205:S0000401',4391,'15R4391:0012707','Mo20W','Mo20W','Mo20W','Les9',['Les9'],'K2506').
genotype(4506,405,'14R405:M0001308',4286,'14R4286:0021905','M14','M14','M14','Les9',['Les9'],'K2506').
genotype(4507,205,'15R205:S0002501',4395,'15R4395:0013304','Mo20W','Mo20W','Mo20W','Les10',['Les10'],'K2606').
genotype(4508,405,'12R405:M0001501',3451,'12R3451:0028009','M14','M14','M14/W23','W23/Les10',['Les10'],'K2606').
genotype(4509,405,'15R405:M0003909',4398,'15R4398:0013904','M14','M14','M14/W23','W23/Les10',['Les10'],'K2606').
genotype(4510,405,'14R405:M0001304',4162,'14R4162:0022908','M14','M14','M14','Les11',['Les11'],'K0901').
genotype(4511,405,'14R405:M0003903',4162,'14R4162:0022908','M14','M14','M14','Les11',['Les11'],'K0901').
genotype(4512,405,'14R405:M0003906',4162,'14R4162:0022908','M14','M14','M14','Les11',['Les11'],'K0901').
genotype(4513,205,'11N205:S0034309',3189,'11N3189:0016803','Mo20W','Mo20W','Mo20W','Les12',['Les12'],'K1001').
genotype(4514,305,'15R305:W0003003',4402,'15R4402:0015101','W23','W23','W23/Mo20W','Mo20W/Les13',['Les13'],'K1109').
genotype(4515,405,'14R405:M0001803',4166,'14R4166:0023701','M14','M14','M14','Les13',['Les13'],'K1109').
genotype(4516,405,'15R405:M0001619',1715,'15R1715:0015202','M14','M14','M14/W23','W23/Les13',['Les13'],'K2805').
genotype(4517,405,'12R405:M0008203',3645,'12R3645:0030503','M14','M14','M14','Les18',['Les18'],'K1411').
genotype(4518,405,'15R405:M0001310',4401,'15R4401:0014902','M14','M14','M14','Les19',['Les19'],'K3206').
genotype(4519,205,'15R205:S0002505',686,'15R0686:0015302','Mo20W','Mo20W','W23/L317','Les20-N2459',['Les20-N2459'],'K68602').
genotype(4520,305,'15R305:W0002805',686,'15R0686:0015302','W23','W23','W23/L317','Les20-N2459',['Les20-N2459'],'K68602').
genotype(4521,405,'15R405:M0003411',686,'15R0686:0015302','M14','M14','W23/L317','Les20-N2459',['Les20-N2459'],'K68602').
genotype(4522,205,'15R205:S0002411',686,'15R0686:0015307','Mo20W','Mo20W','W23/L317','Les20-N2459',['Les20-N2459'],'K68607').
genotype(4523,305,'15R305:W0003106',686,'15R0686:0015307','W23','W23','W23/L317','Les20-N2459',['Les20-N2459'],'K68607').
genotype(4524,405,'15R405:M0001601',686,'15R0686:0015307','M14','M14','W23/L317','Les20-N2459',['Les20-N2459'],'K68607').
genotype(4525,205,'15R205:S0002306',4403,'15R4403:0015507','Mo20W','Mo20W','Mo20W/(M14/(W23/L317))','Les20-N2457',['Les20-N2457'],'K7110').
genotype(4526,305,'15R305:W0003004',2930,'15R2930:0015905','W23','W23','W23/(M14/(W23/L317))','Les20-N2457',['Les20-N2457'],'K7110').
genotype(4527,305,'15R305:W0003013',4044,'15R4044:0016008','W23','W23','W23/Mo20W','Les20-N2457',['Les20-N2457'],'K7110').
genotype(4528,305,'15R305:W0002903',4177,'15R4177:0016107','W23','W23','W23','Les20-N2457',['Les20-N2457'],'K7110').
genotype(4529,305,'15R305:W0002904',3654,'15R3654:0016401','W23','W23','W23','Les20-N2457',['Les20-N2457'],'K7110').
genotype(4530,405,'15R405:M0003701',1129,'15R1129:0015401','M14','M14','M14/(W23/L317)','Les20-N2457',['Les20-N2457'],'K7110').
genotype(4531,405,'15R405:M0003307',2931,'15R2931:0016704','M14','M14','M14/(W23/L317)','Les20-N2457',['Les20-N2457'],'K7110').
genotype(4532,405,'15R405:M0003804',4406,'15R4406:0016801','M14','M14','M14/(W23/L317)','Les20-N2457',['Les20-N2457'],'K7110').
genotype(4533,405,'14R405:M0001610',4048,'14R4048:0026106','M14','M14','M14/(M14/W23)','Les21',['Les21'],'K3311').
genotype(4534,205,'15R205:S0000101',4183,'15R4183:0017105','Mo20W','Mo20W','Mo20W','Les21-N1442',['Les21-N1442'],'K7205').
genotype(4535,305,'15R305:W0000701',4363,'15R4363:0017408','W23','W23','W23','Les21-N1442',['Les21-N1442'],'K7205').
genotype(4536,305,'15R305:W0000704',4363,'15R4363:0017408','W23','W23','W23','Les21-N1442',['Les21-N1442'],'K7205').
genotype(4537,205,'15R205:S0000510',4412,'15R4412:0018104','Mo20W','Mo20W','Mo20W','Les*-mi1',['Les*-mi1'],'K12205').




    
% 17r lines planted

% this is ../c/maize/demeter/archival/17r_data_reconstructn/new_genotypes.pl

% generated on Friday, May 18, 2018 at 13:48:41 UTC (= 1526651321.815624)
% by fix_missing_data:supply_missing_genotypes/3.
%
% Facts hand-checked in two ways (see ../porting_qui_swi.org) and edited as needed.
%
% Kazic, 19.5.2018


% corrected to
%
genotype(4538,205,'16R205:S0001303',4537,'16R4537:0014611','Mo20W','Mo20W','Mo20W','Les*-mi1',['Les*-mi1'],'K12205').
%
% from
%
% genotype(4538,405,'16R405:M0002212',4496,'16R4496:0009201','M14','M14','M14','M14/(W23/Les1)',['Les1'],'K0106').
%
% using 
%
% possibly_missing_data('17R',4538,r00163,'17R4538:0016301','17R4538:0016311').
% planted(r00163,p00125,10,avi,date(30,05,2017),time(14,58,01),full,'17R').
% packed_packet(p00125,'16R405:M0002212','16R4496:0009201',15,avi,date(23,05,2017),time(14,00,00)).
%
% but don''t trust the offspring!
%
% Kazic, 19.5.2018
%
%
% But rows 108 and 109 planted with family 4538 . . . as Les*-mi1.  So assigned that, but don''t trust the offspring 
% of those or row 163.  Because it''s odd to have the same family in two different parts of the field and that''s not
% what the packing plan shows (108 and 109 mi1, 163 Les1)  Just repeat pollinations, add a 
% family for the Les1, and correct the data and tags.
%
% Kazic, 20.5.2018



genotype(4539,205,'16R205:S0002711',4507,'16R4507:0010903','Mo20W','Mo20W','Mo20W','Les10',['Les10'],'K2606').
genotype(4540,405,'16R405:M0003314',4508,'16R4508:0011011','M14','M14','M14','W23/Les10',['Les10'],'K2606').
genotype(4541,405,'16R405:M0003206',4511,'16R4511:0011304','M14','M14','M14','Les11',['Les11'],'K0901').
genotype(4542,405,'16R405:M0003214',4510,'16R4510:0011204','M14','M14','M14','Les11',['Les11'],'K0901').
genotype(4543,205,'16R205:S0000602',4007,'16R4007:0011605','Mo20W','Mo20W','Mo20W','Les12',['Les12'],'K1001').
genotype(4544,205,'16R205:S0000613',4513,'16R4513:0011501','Mo20W','Mo20W','Mo20W','Les12',['Les12'],'K1001').
genotype(4545,205,'16R205:S0000604',4011,'16R4011:0011703','Mo20W','Mo20W','Mo20W','(Mo20W/W23)/Les12',['Les12'],'K2711').
genotype(4546,305,'16R305:W0001502',4514,'16R4514:0011806','W23','W23','W23','Mo20W/Les13',['Les13'],'K1109').
genotype(4547,405,'16R405:M0002103',4516,'16R4516:0012007','M14','M14','M14','M14/(W23/Les13)',['Les13'],'K2805').
genotype(4548,305,'14R305:W0000703',4137,'14R4137:0004215','W23','W23','W23','Les15-N2007',['Les15-N2007'],'K6711').
genotype(4549,305,'14R305:W0000716',4137,'14R4137:0004215','W23','W23','W23','Les15-N2007',['Les15-N2007'],'K6711').
genotype(4550,405,'10R405:M0001010',2254,'10R2254:0032002','M14','M14','M14','(M14/W23)/(+/Les15-N2007)',['Les15-N2007'],'K6711').
genotype(4551,405,'10R405:M0006607',2254,'10R2254:0032003','M14','M14','M14','(M14/W23)/(+/Les15-N2007)',['Les15-N2007'],'K6711').


% this was planted in row 122 and the generated family was correct.
%
genotype(4552,405,'10R405:M0006610',2254,'10R2254:0032010','M14','M14','M14','(M14/W23)/(+/Les15-N2007)',['Les15-N2007'],'K6711').
%
% Kazic, 20.5.2018



genotype(4553,405,'12R405:M0011707',3486,'12R3486:0014708','M14','M14','M14','M14/(W23/Les15-N2007)',['+/Les15-N2007'],'K6711').

genotype(4554,405,'16R405:M0000808',4298,'16R4298:0012403','M14','M14','M14','Les17',['Les17'],'K3007').
genotype(4555,405,'16R405:M0003312',4027,'16R4027:0012203','M14','M14','M14','Les17',['Les17'],'K3007').
genotype(4556,405,'16R405:M0002208',4300,'16R4300:0012606','M14','M14','M14','Les18',['Les18'],'K1411').
genotype(4557,305,'16R305:W0001406',4498,'16R4498:0009505','W23','W23','W23','W23/(Mo20W/Les2)',['Les2'],'K0207').
genotype(4558,305,'16R305:W0002911',4499,'16R4499:0009614','W23','W23','W23','Les2',['Les2'],'K0207').

genotype(4559,305,'12N305:W0038301',3916,'12N3916:0010408','W23','W23','W23','Les2',['Les2'],'K0203').
    
genotype(4560,405,'16R405:M0003112',4222,'16R4222:0009405','M14','M14','M14','Les2',['Les2'],'K0202').
genotype(4561,405,'16R405:M0001811',4356,'16R4356:0010005','M14','M14','M14','Les6',['Les6'],'K2212').
genotype(4562,205,'16R205:S0002616',4445,'16R4445:0009807','Mo20W','Mo20W','Mo20W','Les2-N845A',['Les2-N845A'],'K5525').
genotype(4563,305,'16R305:W0001411',4393,'16R4393:0009910','W23','W23','W23','Les2-N845A',['Les2-N845A'],'K5525').
genotype(4564,405,'13R405:M0002605',4148,'13R4148:0019101','M14','M14','M14','Les2-N845A',['Les2-N845A'],'K5515').
genotype(4565,205,'16R205:S0002715',4519,'16R4519:0012802','Mo20W','Mo20W','Mo20W','Les20-N2459',['Les20-N2459'],'K68602').
genotype(4566,305,'16R305:W0003006',4520,'16R4520:0012908','W23','W23','W23','Les20-N2459',['Les20-N2459'],'K68602').
genotype(4567,305,'16R305:W0001416',4523,'16R4523:0013207','W23','W23','W23','Les20-N2459',['Les20-N2459'],'K68607').
genotype(4568,305,'16R305:W0003012',4526,'16R4526:0013504','W23','W23','W23','Les20-N2457',['Les20-N2457'],'K7110').
genotype(4569,305,'16R305:W0003016',4528,'16R4528:0013704','W23','W23','W23','Les20-N2457',['Les20-N2457'],'K7110').
genotype(4570,405,'16R405:M0002004',4532,'16R4532:0014101','M14','M14','M14','Les20-N2457',['Les20-N2457'],'K7110').
genotype(4571,405,'16R405:M0003204',4531,'16R4531:0014008','M14','M14','M14','Les20-N2457',['Les20-N2457'],'K7110').
genotype(4572,305,'16R305:W0000702',4481,'16R4481:0005706','W23','W23','W23','Les3-GJ',['Les3-GJ'],'K11906').
genotype(4573,305,'14R305:W0000803',3958,'14R3958:0010412','W23','W23','W23','Les4',['Les4'],'K2106').
genotype(4574,205,'16R205:S0001202',4390,'16R4390:0010609','Mo20W','Mo20W','Mo20W','Mo20W/Les7',['Les7'],'K2312').
genotype(4575,305,'16R305:W0001607',3607,'16R3607:0010403','W23','W23','W23','Les7',['Les7'],'K0509').
genotype(4576,305,'16R305:W0001610',4279,'16R4279:0010511','W23','W23','W23','Les7',['Les7'],'K0509').
genotype(4577,205,'16R205:S0001210',4391,'16R4391:0010710','Mo20W','Mo20W','Mo20W','Les9',['Les9'],'K2506').
genotype(4578,405,'16R405:M0002210',4392,'16R4392:0010801','M14','M14','M14','Les9',['Les9'],'K2506').
genotype(4579,205,'15R205:S0002104',667,'15R0667:0021107','Mo20W','Mo20W','CML333','CML333/(B73 NIL-1002/les*-R1-1)',['les*-R1-1'],'K66700').
genotype(4580,405,'15R405:M0003601',667,'15R0667:0021107','M14','M14','CML333','CML333/(B73 NIL-1002/les*-R1-1)',['les*-R1-1'],'K66700').
genotype(4581,405,'15R405:M0003717',674,'15R0674:0021810','M14','M14','NC350','NC350/(B73 NIL-1004/les*-R8-2)',['les*-R8-2'],'K67400').
genotype(4582,405,'15R405:M0003502',675,'15R0675:0021910','M14','M14','Tzi8','Tzi8/(B73 NIL-1304/les*-R9-2)',['les*-R9-2'],'K67500').
genotype(4583,205,'15R205:S0002309',676,'15R0676:0022002','Mo20W','Mo20W','Tzi8','Tzi8/(B73 NIL-1337/les*-R10-2)',['les*-R10-2'],'K67600').
genotype(4584,405,'15R405:M0003303',676,'15R0676:0022002','M14','M14','Tzi8','Tzi8/(B73 NIL-1337/les*-R10-2)',['les*-R10-2'],'K67600').
genotype(4585,205,'15R205:S0002401',677,'15R0677:0022110','Mo20W','Mo20W','Tzi8','Tzi8/(B73 NIL-1337/les*-R11-2)',['les*-R11-2'],'K67700').
genotype(4586,405,'15R405:M0003611',677,'15R0677:0022110','M14','M14','Tzi8','Tzi8/(B73 NIL-1337/les*-R11-2)',['les*-R11-2'],'K67700').
genotype(4587,405,'15R405:M0003711',678,'15R0678:0022212','M14','M14','NC262','Oh7B F2/les*-R168-1',['les*-R168-1'],'K67800').
genotype(4588,205,'15R205:S0002208',679,'15R0679:0022304','Mo20W','Mo20W','NC262','Oh7B F2/les*-R168-2',['les*-R168-2'],'K67900').
genotype(4589,405,'15R405:M0003807',679,'15R0679:0022304','M14','M14','NC262','Oh7B F2/les*-R168-2',['les*-R168-2'],'K67900').
genotype(4590,205,'15R205:S0002410',680,'15R0680:0022411','Mo20W','Mo20W','NC262','Oh7B F2/les*-R169-1',['les*-R169-1'],'K68000').
genotype(4591,405,'15R405:M0003613',680,'15R0680:0022411','M14','M14','NC262','Oh7B F2/les*-R169-1',['les*-R169-1'],'K68000').
genotype(4592,405,'15R405:M0001213',681,'15R0681:0022505','M14','M14','NC262/Oh7B','les*-R170-1',['les*-R170-1'],'K68100').
genotype(4593,405,'15R405:M0001618',683,'15R0683:0022701','M14','M14','NC262/Oh7B','les*-R171-3',['les*-R171-3'],'K68300').
genotype(4594,405,'15R405:M0001904',684,'15R0684:0022802','M14','M14','NC262/Oh7B','les*-R172-1',['les*-R172-1'],'K68400').
genotype(4595,205,'15R205:S0002310',668,'15R0668:0021201','Mo20W','Mo20W','CML333','CML333/(B73 NIL-1002/les*-R2-1)',['les*-R2-1'],'K66800').
genotype(4596,405,'15R405:M0003501',668,'15R0668:0021201','M14','M14','CML333','CML333/(B73 NIL-1002/les*-R2-1)',['les*-R2-1'],'K66800').
genotype(4597,205,'15R205:S0002601',669,'15R0669:0021307','Mo20W','Mo20W','CML333','CML333/(B73 NIL-1007/les*-R3-1)',['les*-R3-1'],'K66900').
genotype(4598,305,'15R305:W0002804',669,'15R0669:0021307','W23','W23','CML333','CML333/(B73 NIL-1007/les*-R3-1)',['les*-R3-1'],'K66900').
genotype(4599,405,'15R405:M0003407',669,'15R0669:0021307','M14','M14','CML333','CML333/(B73 NIL-1007/les*-R3-1)',['les*-R3-1'],'K66900').
genotype(4600,205,'15R205:S0002511',669,'15R0669:0021311','Mo20W','Mo20W','CML333','CML333/(B73 NIL-1007/les*-R3-1)',['les*-R3-1'],'K66900').
genotype(4601,205,'15R205:S0002403',670,'15R0670:0021405','Mo20W','Mo20W','CML333','CML333/(B73 NIL-1007/les*-R4-1)',['les*-R4-1'],'K67000').
genotype(4602,305,'15R305:W0002905',670,'15R0670:0021405','W23','W23','CML333','CML333/(B73 NIL-1007/les*-R4-1)',['les*-R4-1'],'K67000').
genotype(4603,405,'15R405:M0003408',670,'15R0670:0021405','M14','M14','CML333','CML333/(B73 NIL-1007/les*-R4-1)',['les*-R4-1'],'K67000').
genotype(4604,205,'15R205:S0002404',671,'15R0671:0021502','Mo20W','Mo20W','Ki11','Ki11/(B73 NIL-1103/les*-R5-1)',['les*-R5-1'],'K67100').
genotype(4605,405,'15R405:M0003403',671,'15R0671:0021502','M14','M14','Ki11','Ki11/(B73 NIL-1103/les*-R5-1)',['les*-R5-1'],'K67100').
genotype(4606,205,'15R205:S0002408',672,'15R0672:0021608','Mo20W','Mo20W','Ki11','Ki11/(B73 NIL-1104/les*-R6-1)',['les*-R6-1'],'K67200').
genotype(4607,405,'15R405:M0003504',672,'15R0672:0021608','M14','M14','Ki11','Ki11/(B73 NIL-1104/les*-R6-1)',['les*-R6-1'],'K67200').
genotype(4608,205,'15R205:S0002206',673,'15R0673:0021705','Mo20W','Mo20W','Mo18W','Mo18W/(B73 NIL-1020B/les*-R7-2)',['les*-R7-2'],'K67300').
genotype(4609,405,'15R405:M0003618',673,'15R0673:0021705','M14','M14','Mo18W','Mo18W/(B73 NIL-1020B/les*-R7-2)',['les*-R7-2'],'K67300').
genotype(4610,205,'16R205:S0002604',687,'16R0687:0014708','Mo20W','Mo20W','ALTIPLANO BOV903','PHZ51',['PHZ51'],'K68700').
genotype(4611,205,'16R205:S0000603',691,'16R0691:0015106','Mo20W','Mo20W','CRISTALINO AMAR AR21004','PHB47',['PHB47'],'K69100').
genotype(4612,305,'16R305:W0000711',691,'16R0691:0015106','W23','W23','CRISTALINO AMAR AR21004','PHB47',['PHB47'],'K69100').
genotype(4613,205,'16R205:S0002607',693,'16R0693:0015303','Mo20W','Mo20W','CUZCO CUZ217','PHZ51',['PHZ51'],'K69300').
genotype(4614,205,'16R205:S0001111',698,'16R0698:0015802','Mo20W','Mo20W','Tehua - CHS29','PHB47',['PHB47'],'K69800').
genotype(4615,205,'14R205:S0002812',4236,'14R4236:0017206','Mo20W','Mo20W','les23','les23',['les23'],'K1804').
genotype(4616,205,'16R205:S0001309',4472,'16R4472:0004811','Mo20W','Mo20W',les23,les23,[les23],'K3514').
genotype(4617,305,'16R305:W0000714',4475,'16R4475:0005105','W23','W23',les23,les23,[les23],'K16306').
genotype(4618,305,'16R305:W0001401',4467,'16R4467:0004309','W23','W23',les23,les23,[les23],'K1802').
genotype(4619,305,'16R305:W0001408',4470,'16R4470:0004603','W23','W23',les23,les23,[les23],'K1804').
genotype(4620,305,'16R305:W0001511',4473,'16R4473:0004903','W23','W23',les23,les23,[les23],'K3514').
genotype(4621,405,'16R405:M0003107',4476,'16R4476:0005202','M14','M14',les23,les23,[les23],'K16306').
genotype(4622,405,'16R405:M0001705',4468,'16R4468:0004411','M14','M14',les23,les23,[les23],'K1802').
genotype(4623,405,'16R405:M0001707',4471,'16R4471:0004707','M14','M14',les23,les23,[les23],'K1804').
genotype(4624,405,'16R405:M0003103',4474,'16R4474:0005001','M14','M14',les23,les23,[les23],'K3514').
genotype(4625,4466,'16R4466:0004206',4466,'16R4466:0004206','Mo20W','{Mo20W|les23}','Mo20W','{Mo20W|les23}',[les23],'K16306').
genotype(4626,4465,'16R4465:0004111',4465,'16R4465:0004111','Mo20W','{Mo20W|les23}','Mo20W','{Mo20W|les23}',[les23],'K1802').
genotype(4627,205,'16R205:S0001112',4478,'16R4478:0005404','Mo20W','Mo20W','Les3-GJ','Les3-GJ',['Les3-GJ'],'K11906').
genotype(4628,405,'16R405:M0002211',4482,'16R4482:0005809','M14','M14','Les3-GJ','Les3-GJ',['Les3-GJ'],'K11906').
genotype(4629,4484,'16R4484:0006001',4484,'16R4484:0006001','Mo20W','les5-N1449','Mo20W','les5-N1449',['les5-N1449'],'K68503').
genotype(4630,4485,'16R4485:0006103',4485,'16R4485:0006103','W23','les5-N1449','W23','les5-N1449',['les5-N1449'],'K68503').
genotype(4631,4486,'16R4486:0006204',4486,'16R4486:0006204','M14','{+|les5-N1449}','M14','{+|les5-N1449}',['+/les5-N1449'],'K68503').
genotype(4632,4487,'16R4487:0006309',4487,'16R4487:0006309','Mo20W','{+|les5-N1449}','Mo20W','{+|les5-N1449}',['les5-N1449'],'K68507').
genotype(4633,4488,'16R4488:0006409',4488,'16R4488:0006409','W23','{+|les5-N1449}','W23','{+|les5-N1449}',['les5-N1449'],'K68507').
genotype(4634,4489,'16R4489:0006503',4489,'16R4489:0006503','M14','{+|les5-N1449}','M14','{+|les5-N1449}',['les5-N1449'],'K68507').
genotype(4635,4461,'16R4461:0003713',4461,'16R4461:0003713','W23','{W23|lls1 121D}','W23','{W23|lls1 121D}',['lls1 121D'],'K3402').
genotype(4636,4462,'16R4462:0003808',4462,'16R4462:0003808','M14','{M14|lls1 121D}','M14','{M14|lls1 121D|',['lls1 121D'],'K3402').
genotype(4637,4460,'16R4460:0003602',4460,'16R4460:0003602','Mo20W','{Mo20W|lls1}','Mo20W','{Mo20W|lls1}',['lls1'],'K1702').
genotype(4638,4463,'16R4463:0003902',4463,'16R4463:0003902','W23','{W23|lls1 121D}','W23','{W23|lls1 121D}',['lls1 121D'],'K5302').
genotype(4639,4464,'16R4464:0004010',4464,'16R4464:0004010','M14','{M14|lls1 121D}','M14','{M14|lls1 121D}',['lls1 121D'],'K5302').
    


% tucked this one in to relabel offspring of row 163 

genotype(4640,405,'16R405:M0002212',4496,'16R4496:0009201','M14','M14','M14','M14/(W23/Les1)',['Les1'],'K0106').


% added this family as the same family was manually assigned to 
% rows 122 and 134.  This is what was planted in row 134.
%
% This appeared in a les23 line and may be a dominant les23, but
% there is no direct evidence for that.  So for now, it is denoted
% Les*-tk1.
%
% Kazic, 20.5.2018

genotype(4641,305,'16R305:W0001612',703,'16R0703:0005303','W23','W23','W23','(M14/Les*-tk1)',['Les*-tk1'],'K70309').



% added to fix families that were assigned to two different sets of parents!
%
% Kazic, 20.5.2018

% migrated male parent in 4642--4644 to track possible dominant les23
%
% Kazic, 4.6.2018

genotype(4642,305,'16R305:W0001618',703,'16R0703:0005311','W23','W23','W23','Les*-tk1',['Les*-tk1'],'K70309').
genotype(4643,405,'16R405:M0001704',703,'16R0703:0005305','M14','M14','M14','Les*-tk1',['Les*-tk1'],'K70309').
genotype(4644,405,'16R405:M0001708',703,'16R0703:0005303','M14','M14','M14','Les*-tk1',['Les*-tk1'],'K70309').

genotype(4645,405,'15R405:M0001305',682,'15R0682:0022603','M14','M14','+','bk*-19',['bk*-19'],'K68203').
genotype(4646,688,'16R0688:0014805',688,'16R0688:0014805','+','+','cg*-5','cg*-5',['cg*-5'],'K68805').
genotype(4647,689,'16R0689:0014903',689,'16R0689:0014903','+','+','cg*-6','cg*-6',['cg*-6'],'K68903').






% added per results of genetic_utilities:find_descendants_of_lines_wo_genotypes/2
%
% Kazic, 31.5.2018


genotype(4648,4377,'15R4377:0008003',4377,'15R4377:0008003','M14','Les3-GJ','M14','Les3-GJ',['Les3-GJ'],'K11906').








%%%%%%%%% automatically added families for 18R crop; check calculated genotype data! %%%%%%%%%%%%%%
%
% genotypes checked and confirmed
%
% Kazic, 24.7.2018


genotype(4649,405,'17R405:M0002113',4564,'17R4564:0016707','M14','M14','M14','Les2-N845A',['Les2-N845A'],'K5515').
genotype(4650,405,'15R405:M0001302',4354,'15R4354:0011306','M14','M14','M14','Les6',['Les6'],'K2202').
genotype(4651,405,'15R405:M0001205',4355,'15R4355:0011403','M14','M14','M14','Les6',['Les6'],'K2202').
genotype(4652,405,'15R405:M0001313',4277,'15R4277:0011507','M14','M14','M14','Les6',['Les6'],'K2202').
genotype(4653,305,'16R305:W0002914',4279,'16R4279:0010511','W23','W23','W23','Les7',['Les7'],'K0509').
genotype(4654,205,'16R205:S0001301',4390,'16R4390:0010611','Mo20W','Mo20W','Mo20W','Les7',['Les7'],'K2312').
genotype(4655,305,'15R305:W0000601',4359,'15R4359:0012512','W23','W23','W23','Les7',['Les7'],'K2312').
genotype(4656,305,'15R305:W0000707',4360,'15R4360:0012608','W23','W23','W23','Les7',['Les7'],'K2312').
genotype(4657,405,'14R405:M0001212',4282,'14R4282:0021303','M14','M14','M14','Les7',['Les7'],'K2312').
genotype(4658,205,'14R205:S0000107',4284,'14R4284:0021509','Mo20W','Mo20W','Mo20W','Les8',['Les8'],'K2405').
genotype(4659,405,'17R405:M0002306',4578,'17R4578:0017406','M14','M14','M14','Les9',['Les9'],'K2506').
genotype(4660,205,'14R205:S0000307',4160,'14R4160:0022114','Mo20W','Mo20W','Mo20W','Les10',['Les10'],'K0801').
genotype(4661,205,'17R205:S0001307',4539,'17R4539:0017501','Mo20W','Mo20W','Mo20W','Les10',['Les10'],'K2606').
genotype(4662,305,'12R305:W0002602',3627,'12R3627:0028207','W23','W23','W23','Les11',['Les11'],'K0901').
genotype(4663,205,'17R205:S0001112',4543,'17R4543:0017914','Mo20W','Mo20W','Mo20W','Les12',['Les12'],'K1001').
genotype(4664,205,'17R205:S0001117',4543,'17R4543:0017901','Mo20W','Mo20W','Mo20W','Les12',['Les12'],'K1001').
genotype(4665,305,'17R305:W0004012',4548,'17R4548:0011508','W23','W23','W23','Les15-N2007',['Les15-N2007'],'K6711').
genotype(4666,305,'17R305:W0004016',4548,'17R4548:0011508','W23','W23','W23','Les15-N2007',['Les15-N2007'],'K6711').
genotype(4667,405,'12N405:M0039608',4037,'12N4037:0031503','M14','M14','M14','Les19',['Les19'],'K1506').
genotype(4668,405,'17R405:M0004413',4518,'17R4518:0018408','M14','M14','M14','Les19',['Les19'],'K3206').
genotype(4669,405,'17R405:M0004416',4570,'17R4570:0019003','M14','M14','M14','Les20-N2457',['Les20-N2457'],'K7110').
genotype(4670,4618,'17R4618:0012502',4618,'17R4618:0012502','W23','{W23|les23}','W23','{W23|les23}',[les23],'K1802').
genotype(4671,305,'14R305:W0001007',4186,'14R4186:0026908','W23','W23','W23','Les*-mi1',['Les*-mi1'],'K12205').
genotype(4672,405,'14R405:M0001509',4313,'14R4313:0027007','M14','M14','M14','Les*-mi1',['Les*-mi1'],'K12205').
genotype(4673,405,'15R405:M0001414',4365,'15R4365:0019903','M14','M14','M14','Les*-N2418',['Les*-N2418'],'K8501').
genotype(4674,205,'17R205:S0003715',4548,'17R4548:0011508','Mo20W','Mo20W','W23','Les15-N2007',['Les15-N2007'],'K6711').
genotype(4675,205,'17R205:S0001502',2252,'17R2252:0011020','Mo20W','Mo20W','Mo20W','Les15-N2007',['Les15-N2007'],'K6711').
genotype(4676,205,'17R205:S0003302',4419,'17R4419:0011134','Mo20W','Mo20W','Mo20W','Les15-N2007',['Les15-N2007'],'K6711').
genotype(4677,205,'17R205:S0003317',4419,'17R4419:0011132','Mo20W','Mo20W','Mo20W','Les15-N2007',['Les15-N2007'],'K6711').
genotype(4678,205,'17R205:S0003505',4419,'17R4419:0011108','Mo20W','Mo20W','Mo20W','Les15-N2007',['Les15-N2007'],'K6711').
genotype(4679,405,'17R405:M0004208',4548,'17R4548:0011508','M14','M14','W23','Les15-N2007',['Les15-N2007'],'K6711').
genotype(4680,405,'17R405:M0004414',4550,'17R4550:0012019','M14','M14','M14','Les15-N2007',['Les15-N2007'],'K6711').
genotype(4681,405,'17R405:M0004706',4552,'17R4552:0012208','M14','M14','M14','Les15-N2007',['Les15-N2007'],'K6711').
genotype(4682,4460,'16R4460:0003604',4460,'16R4460:0003604','Mo20W','{Mo20W|lls1}','Mo20W','{Mo20W|lls1}',[lls1],'K1702').
genotype(4683,4335,'15R4335:0006104',4335,'15R4335:0006104','W23','{W23|lls1}','W23','{W23|lls1}',[lls1],'K1702').
genotype(4684,4336,'15R4336:0006204',4336,'15R4336:0006204','M14','{M14|lls1}','M14','{M14|lls1}',[lls1],'K1702').
genotype(4685,205,'17R205:S0001102',4626,'17R4626:0015704','Mo20W','Mo20W','les23','les23',[les23],'K1802').
genotype(4686,205,'17R205:S0001212',4625,'17R4625:0015804','Mo20W','Mo20W','les23','les23',[les23],'K16306').
genotype(4687,205,'17R205:S0003704',4625,'17R4625:0015808','Mo20W','Mo20W','les23','les23',[les23],'K16306').
genotype(4688,205,'17R205:S0001210',4625,'17R4625:0015809','Mo20W','Mo20W','les23','les23',[les23],'K16306').
genotype(4689,405,'17R405:M0002216',4474,'17R4474:0016104','M14','M14','les23','les23',[les23],'K3514').
genotype(4690,205,'17R205:S0001317',703,'17R0703:0016203','Mo20W','Mo20W','W23','M14/Les*-tk1',['Les*-tk1'],'K70309').
genotype(4691,305,'17R305:W0003903',703,'17R0703:0016203','W23','W23','W23','M14/Les*-tk1',['Les*-tk1'],'K70309').
genotype(4692,205,'17R205:S0001217',703,'17R0703:0016204','Mo20W','Mo20W','W23','M14/Les*-tk1',['Les*-tk1'],'K70309').
genotype(4693,305,'17R305:W0003910',703,'17R0703:0016204','W23','W23','W23','M14/Les*-tk1',['Les*-tk1'],'K70309').
genotype(4694,305,'17R305:W0003807',703,'17R0703:0016208','W23','W23','W23','M14/Les*-tk1',['Les*-tk1'],'K70309').
%
% this next is not found in the Les15 pedigrees, but is in les23 K16300
%
% Kazic, 1.8.2018
%
% genotype(4695,305,'17R305:W0001813',4552,'17R4552:0013415','W23','W23','M14','M14/Les15-N2007',['Les15-N2007'],'K6711').

genotype(4695,305,'17R305:W0001813',4552,'17R4552:0013415','W23','W23','M14','M14/les23',['les23'],'K16306').


%
% this next is not found in the Les15 pedigrees, but is in les23 K16300
%
% Kazic, 1.8.2018
%
% genotype(4696,305,'17R305:W0001708',4553,'17R4553:0013510','W23','W23','M14','M14/Les15-N2007',['+/Les15-N2007'],'K6711').

genotype(4696,305,'17R305:W0001708',4553,'17R4553:0013510','W23','W23','M14','M14/les23',['les23'],'K16306').

%
% this next is not found in the Les17 pedigrees, but is in les23 K16300
%
% Kazic, 1.8.2018
%
% genotype(4697,405,'17R405:M0002201',4554,'17R4554:0013613','M14','M14','M14','Les17',['Les17'],'K3007').

genotype(4697,405,'17R405:M0002201',4554,'17R4554:0013613','M14','M14','M14','les23',['les23'],'K16306').

%
% this next is not found in the Les17 pedigrees, but is in les23 K16300
%
% Kazic, 1.8.2018
%
% genotype(4698,405,'17R405:M0002509',4555,'17R4555:0013708','M14','M14','M14','Les17',['Les17'],'K3007').

genotype(4698,405,'17R405:M0002509',4555,'17R4555:0013708','M14','M14','M14','les23',['les23'],'K16306').



genotype(4699,305,'15R305:W0003016',4217,'15R4217:0005818','W23','W23','lls1','lls1',[lls1],'K10602').
genotype(4700,405,'15R405:M0003510',4334,'15R4334:0005405','M14','M14','M14/(W23/lls1 121D)','M14/(W23/lls1 121D)',['lls1 121D'],'K3402').
genotype(4701,205,'15R205:S0002412',674,'15R0674:0021810','Mo20W','Mo20W','NC350','B73 NIL-1004/les*-R8-2',['les*-R8-2'],'K67400').
genotype(4702,205,'15R205:S0002402',678,'15R0678:0022212','Mo20W','Mo20W','NC262','Oh7B F2/les*-R168-1',['les*-R168-1'],'K67800').
genotype(4703,3899,'12N3899:0005901',3899,'12N3899:0005901','Mo20W','{Mo20W|Les1}','Mo20W','{Mo20W|Les1}',['Les1'],'K0104').
genotype(4704,205,'12N205:S0036411',3899,'12N3899:0005903','Mo20W','Mo20W','Mo20W','{Mo20W|Les1}',['Les1'],'K0104').
genotype(4705,205,'11N205:S0039107',3399,'11N3399:0007703','Mo20W','Mo20W','Mo20W','Les2',['Les2'],'K0202').
genotype(4706,305,'14R305:W0001009',4220,'14R4220:0006811','W23','W23','W23','Les2',['Les2'],'K0202').
genotype(4707,405,'11N405:M0038409',3401,'11N3401:0007903','M14','M14','M14','M14/(Mo20W/Les2)',['Les2'],'K0202').
genotype(4708,305,'17R305:W0002003',4557,'17R4557:0016502','W23','W23','W23','Les2',['Les2'],'K0207').
genotype(4709,305,'17R305:W0003906',4558,'17R4558:0016602','W23','W23','W23','Les2',['Les2'],'K0207').
genotype(4710,405,'13R405:M0003605',4151,'13R4151:0019601','M14','M14','M14','Les6',['Les6'],'K0403').
genotype(4711,405,'17R405:M0002203',4540,'17R4540:0017604','M14','M14','M14','Les10',['Les10'],'K2606').
genotype(4712,405,'17R405:M0002111',4509,'17R4509:0017712','M14','M14','M14','Les10',['Les10'],'K2606').
genotype(4713,205,'17R205:S0001204',4545,'17R4545:0018105','Mo20W','Mo20W','Mo20W','Les12',['Les12'],'K2711').
genotype(4714,305,'17R305:W0001902',4546,'17R4546:0018201','W23','W23','W23','Les13',['Les13'],'K1109').
genotype(4715,405,'14R405:M0001412',4166,'14R4166:0023701','M14','M14','M14','Les13',['Les13'],'K1109').
genotype(4716,405,'16R405:M0001804',4516,'16R4516:0012008','M14','M14','M14','Les13',['Les13'],'K2805').
genotype(4717,305,'15R305:W0003206',4044,'15R4044:0016008','W23','W23','W23','Mo20W/Les20-N2457',['Les20-N2457'],'K7110').
genotype(4718,305,'17R305:W0003817',4569,'17R4569:0018711','W23','W23','W23','Les20-N2457',['Les20-N2457'],'K7110').
genotype(4719,305,'17R305:W0005401',4569,'17R4569:0018709','W23','W23','W23','Les20-N2457',['Les20-N2457'],'K7110').
genotype(4720,4627,'17R4627:0013801',4627,'17R4627:0013801','Mo20W','{Mo20W|Les3-GJ}','Mo20W','{Mo20W|Les3-GJ}',['Les3-GJ'],'K11906').
genotype(4721,4627,'17R4627:0013802',4627,'17R4627:0013802','Mo20W','{Mo20W|Les3-GJ}','Mo20W','{Mo20W|Les3-GJ}',['Les3-GJ'],'K11906').
genotype(4722,4572,'17R4572:0013901',4572,'17R4572:0013901','W23','{W23|Les3-GJ}','W23','{W23|Les3-GJ}',['Les3-GJ'],'K11906').
genotype(4723,4572,'17R4572:0013904',4572,'17R4572:0013904','W23','{W23|Les3-GJ}','W23','{W23|Les3-GJ}',['Les3-GJ'],'K11906').
genotype(4724,4628,'17R4628:0014002',4628,'17R4628:0014002','M14','{M14|Les3-GJ}','M14','{M14|Les3-GJ}',['Les3-GJ'],'K11906').
genotype(4725,4628,'17R4628:0014005',4628,'17R4628:0014005','M14','{M14|Les3-GJ}','M14','{M14|Les3-GJ}',['Les3-GJ'],'K11906').
genotype(4726,4619,'17R4619:0012702',4619,'17R4619:0012702','W23','{W23|les23}','W23','{W23|les23}',[les23],'K1804').
genotype(4727,4623,'17R4623:0012802',4623,'17R4623:0012802','M14','{M14|les23}','M14','{M14|les23}',[les23],'K1804').
genotype(4728,4622,'17R4622:0012610',4622,'17R4622:0012610','M14','{M14|les23}','M14','{M14|les23}',[les23],'K1802').
genotype(4729,4616,'17R4616:0012904',4616,'17R4616:0012904','Mo20W','{Mo20W|les23}','Mo20W','{Mo20W|les23}',[les23],'K3514').
genotype(4730,4620,'17R4620:0013009',4620,'17R4620:0013009','W23','{W23|les23}','W23','{W23|les23}',[les23],'K3514').
genotype(4731,4624,'17R4624:0013104',4624,'17R4624:0013104','M14','{M14|les23}','M14','{M14|les23}',[les23],'K3514').
genotype(4732,4617,'17R4617:0013208',4617,'17R4617:0013208','W23','{W23|les23}','W23','{W23|les23}',[les23],'K16306').
genotype(4733,4621,'17R4621:0013302',4621,'17R4621:0013302','M14','{M14|les23}','M14','{M14|les23}',[les23],'K16306').
genotype(4734,3891,'12N3891:0005011',3891,'12N3891:0005011','Mo20W','{Mo20W|lls1}','Mo20W','{Mo20W|lls1}',[lls1],'K10602').
genotype(4735,4461,'16R4461:0003709',4461,'16R4461:0003709','W23','{W23|lls1 121D}','W23','{W23|lls1 121D}',['lls1 121D'],'K3402').
genotype(4736,4462,'16R4462:0003803',4462,'16R4462:0003803','M14','{M14|lls1 121D}','M14','{M14|lls1 121D}',['lls1 121D'],'K3402').
genotype(4737,4337,'15R4337:0006301',4337,'15R4337:0006301','Mo20W','{Mo20W|lls1 121D}','Mo20W','{Mo20W|lls1 121D}',['lls1 121D'],'K5302').
genotype(4738,301,'06N301:W0006009',1241,'06N1241:0000909','W23','W23','Mo20W','{+|csp1}',[csp1],'K11503').
genotype(4739,405,'17R405:M0002206',4546,'17R4546:0018201','M14','M14','W23','Les13',['Les13'],'K1109').
genotype(4740,305,'11N305:W0040104',3201,'11N3201:0017703','W23','W23','Mo20W','W23/Les13',['Les13'],'K2805').
genotype(4741,4131,'13R4131:0016409',4131,'13R4131:0016409','B73','{B73|Les5}','B73','{B73|Les5}',['Les5'],'K11601').
genotype(4742,4131,'13R4131:0016412',4131,'13R4131:0016412','B73','{B73|Les5}','B73','{B73|Les5}',['Les5'],'K11601').
genotype(4743,4132,'13R4132:0016503',4132,'13R4132:0016503','B73','{B73|Les5}','B73','{B73|Les5}',['Les5'],'K11601').
genotype(4744,4133,'13R4133:0016601',4133,'13R4133:0016601','B73','{B73|Les5}','B73','{B73|Les5}',['Les5'],'K11601').
genotype(4745,4134,'13R4134:0016701',4134,'13R4134:0016701','B73','{B73|Les5}','B73','{B73|Les5}',['Les5'],'K11605').
genotype(4746,4135,'13R4135:0016804',4135,'13R4135:0016804','B73','{B73|Les5}','B73','{B73|Les5}',['Les5'],'K11605').
genotype(4747,4135,'13R4135:0016805',4135,'13R4135:0016805','B73','{B73|Les5}','B73','{B73|Les5}',['Les5'],'K11605').
genotype(4748,4135,'13R4135:0016807',4135,'13R4135:0016807','B73','{B73|Les5}','B73','{B73|Les5}',['Les5'],'K11605').
genotype(4749,4135,'13R4135:0016809',4135,'13R4135:0016809','B73','{B73|Les5}','B73','{B73|Les5}',['Les5'],'K11605').
genotype(4750,4136,'13R4136:0016901',4136,'13R4136:0016901','B73','{B73|Les5}','B73','{B73|Les5}',['Les5'],'K11605').
genotype(4751,4136,'13R4136:0016907',4136,'13R4136:0016907','B73','{B73|Les5}','B73','{B73|Les5}',['Les5'],'K11605').
genotype(4752,4464,'16R4464:0004002',4464,'16R4464:0004002','M14','{M14|lls1 121D}','M14','{M14|lls1 121D}',['lls1 121D'],'K5302').
