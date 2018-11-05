% this is ../c/maize/demeter/data/crop.pl

% crop(CropID,Location,FieldID,Planting,PlantingDate,HarvestStartDate,HarvestEndDate).


% 18r

% harvest dates guessed
    
crop('18R',missouri,field34,1,date(06,06,2018),date(30,9,2018),date(12,10,2018)).
crop('18R',missouri,field34,2,date(11,06,2018),date(30,9,2018),date(12,10,2018)).
crop('18R',missouri,field34,3,date(19,06,2018),date(30,9,2018),date(12,10,2018)).








% 17r

crop('17R',missouri,field33,1,date(30,05,2017),date(24,9,2017),date(25,10,2017)).
crop('17R',missouri,field33,2,date(5,06,2017),date(24,9,2017),date(25,10,2017)).
crop('17R',missouri,field33,3,date(21,06,2017),date(24,9,2017),date(25,10,2017)).








    
% 16r

crop('16R',missouri,field32,1,date(24,05,2016),date(23,9,2016),date(23,9,2016)).
crop('16R',missouri,field32,2,date(29,05,2016),date(23,9,2016),date(23,9,2016)).
crop('16R',missouri,field32,3,date(3,06,2016),date(23,9,2016),date(23,9,2016)).








% 15r

crop('15R',missouri,field30,1,date(11,06,2015),date(30,9,2015),date(22,10,2015)).
crop('15R',missouri,field30,2,date(23,06,2015),date(30,9,2015),date(22,10,2015)).


    





% 14r
%
% intended second and third plantings combined; the four Saturday rows are now the second planting
%
% Kazic, 25.6.2014

crop('14R',missouri,field34,1,date(16,06,2014),date(30,8,2014),date(22,9,2014)).
crop('14R',missouri,field34,2,date(21,06,2014),date(30,8,2014),date(22,9,2014)).
crop('14R',missouri,field34,3,date(25,06,2014),date(30,8,2014),date(22,9,2014)).








% 13r
%
% faked for now to get the planting_index.pl computed correctly so that the pedigrees
% are computed correctly!
%
% Kazic, 30.4.2014

crop('13R',missouri,field33,1,date(14,05,2013),date(30,8,2013),date(22,9,2013)).
crop('13R',missouri,field33,2,date(28,05,2013),date(30,8,2013),date(22,9,2013)).
crop('13R',missouri,field33,3,date(04,06,2013),date(30,8,2013),date(22,9,2013)).







% 12n

crop('12N',molokaii,olaola,1,date(20,11,2012),date(13,3,2013),date(13,3,2013)).
crop('12N',molokaii,olaola,2,date(28,11,2012),date(13,3,2013),date(13,3,2013)).







% 12r
%
% we had a little corn in field32 but it didn''t amount to
% much.  Derek, Avi, and Wade planted it while I was away (or
% was Wade on another internship? don''t remember).
%
% Kazic, 28.3.2018

crop('12R',missouri,field34,1,date(14,05,2012),date(25,08,2012),date(16,09,2012)).
crop('12R',missouri,field34,2,date(21,05,2012),date(25,08,2012),date(16,09,2012)).


% these are the transplants of the Les15 lines started at home in the laundry room
%
crop('12R',missouri,field34,3,date(18,05,2012),date(25,08,2012),date(16,09,2012)).  


% these are the fill-ins for the rows that had zero stand counts
%
crop('12R',missouri,field34,4,date(10,06,2012),date(25,08,2012),date(16,09,2012)).


% sherry''s demo corn
%
crop('12R',missouri,demo,5,date(25,05,2012),date(25,08,2012),date(16,09,2012)).










% 11n

crop('11N',molokaii,olaola,1,date(23,11,2011),date(14,3,2012),date(14,3,2012)).
crop('11N',molokaii,olaola,2,date(1,12,2011),date(14,3,2012),date(14,3,2012)).







% 11r

crop('11R',missouri,field30,1,date(10,5,2011),date(5,9,2011),date(20,10,2011)).
crop('11R',missouri,field30,2,date(7,6,2011),date(5,9,2011),date(20,10,2011)).
crop('11R',missouri,field30,3,date(8,6,2011),date(5,9,2011),date(20,10,2011)).









% 10r
%
% not sure if "genetics_pond_n" is field33, but think so
%
% Kazic, 28.3.2018
    
crop('10R',missouri,field33,1,date(29,5,2010),date(3,9,2010),date(9,9,2010)).
crop('10R',missouri,field33,2,date(30,5,2010),date(3,9,2010),date(9,9,2010)).
crop('10R',missouri,field33,3,date(6,6,2010),date(7,9,2010),date(17,9,2010)).







% 09r

crop('09R',missouri,field18,1,date(20,5,2009),date(19,9,2009),date(10,10,2009)).
crop('09R',missouri,field18,14,date(21,5,2009),date(19,9,2009),date(10,10,2009)).
crop('09R',missouri,field18,2,date(1,6,2009),date(19,9,2009),date(10,10,2009)).
crop('09R',missouri,field18,3,date(9,6,2009),date(19,9,2009),date(10,10,2009)).
crop('09R',missouri,field18,10,date(19,6,2009),date(19,9,2009),date(10,10,2009)).
crop('09R',missouri,field18,13,date(1,7,2009),date(19,9,2009),date(10,10,2009)).



% gh stuff, just for transplanting

crop('09R',missouri,sears_107_n,0,date(20,5,2009),_,_).
crop('09R',missouri,sears_107_n,4,date(10,6,2009),_,_).
crop('09R',missouri,sears_107_n,5,date(14,6,2009),_,_).
crop('09R',missouri,sears_107_n,6,date(15,6,2009),_,_).
crop('09R',missouri,sears_107_n,7,date(16,6,2009),_,_).
crop('09R',missouri,sears_107_n,8,date(17,6,2009),_,_).
crop('09R',missouri,sears_107_n,9,date(18,6,2009),_,_).
crop('09R',missouri,sears_107_n,11,date(20,6,2009),_,_).
crop('09R',missouri,sears_107_n,12,date(22,6,2009),_,_).









% 08g

crop('08G',missouri,sears_107_n,1,date(2,12,2008),date(6,1,2009),date(6,1,2009)).
crop('08G',missouri,sears_107_n,2,date(30,1,2009),date(1,1,2009),date(1,1,2009)).
crop('08G',missouri,sears_107_n,3,date(31,1,2009),date(1,1,2009),date(1,1,2009)).
crop('08G',missouri,sears_107_n,4,date(13,2,2009),date(1,1,2009),date(1,1,2009)).
crop('08G',missouri,sears_107_n,5,date(13,2,2009),date(1,1,2009),date(1,1,2009)).





% 08r

% check palm records to fix planting date
%
% "genetics_tree" was the south side of field24, shared that year
% with Karen and Gerry
%
% that was the year it rained forever and we had to plant far too late
% to be worthwhile
%
% Kazic, 28.3.2018

crop('08R',missouri,field24,1,date(14,6,2008),date(19,10,2008),date(20,10,2008)).











% 07g

% check records to fix planting and harvest dates; there were multiple plantings
% data are on palms
%
crop('07G',missouri,sears_107_n,1,date(13,11,2007),'','').
% crop('07G',missouri,sears_107_n,1,date(14,1,2008),date(18,5,2008),date(18,5,2008)).
%
% have to look up the planting dates in my notebook!
%
% Kazic, 25.11.09
%
crop('07G',missouri,sears_107_n,2,date(14,1,2008),date(18,5,2008),date(18,5,2008)).
crop('07G',missouri,sears_107_n,3,date(14,1,2008),date(18,5,2008),date(18,5,2008)).
crop('07G',missouri,sears_107_n,4,date(14,1,2008),date(18,5,2008),date(18,5,2008)).
crop('07G',missouri,sears_107_n,5,date(14,1,2008),date(18,5,2008),date(18,5,2008)).









% 07r

crop('07R',missouri,field18,1,date(14,5,2007),date(14,9,2007),date(19,9,2007)).
crop('07R',missouri,field18,2,date(21,5,2007),date(14,9,2007),date(19,9,2007)).
crop('07R',missouri,field18,3,date(29,5,2007),date(14,9,2007),date(19,9,2007)).
crop('07R',missouri,field25,3,date(29,5,2007),date(14,9,2007),date(19,9,2007)).









% 06g

% commented these out as packed_packet, planted, etc. records must 
% be reconstructed from old spreadsheet data.
%
% Kazic, 22.5.2018

    
% crop('06G',missouri,sears_108_s,1,date(13,11,2006),'','').
% crop('06G',missouri,sears_108_s,2,date(28,11,2006),'','').
% crop('06G',missouri,sears_108_s,3,date(30,11,2006),'','').
% crop('06G',missouri,sears_108_s,4,date(4,12,2006),'','').
% crop('06G',missouri,sears_108_s,5,date(12,12,2006),'','').








% 06n

crop('06N',molokaii,kapua,1,date(25,11,2006),date(9,3,2007),date(9,3,2007)).  % 1 - 143
crop('06N',molokaii,kapua,2,date(2,12,2006),date(9,3,2007),date(9,3,2007)).   % 144 - 374









% 06r
%
% planted in the center of field26, next to the old shed; shared
% with Ed and Georgia (and Georgia had me manage it!)
%
% Kazic, 28.3.2018

crop('06R',missouri,field26,1,date(8,5,2006),date(11,9,2006),date(15,9,2006)).  % Mo1, W1, M1, and mutants
crop('06R',missouri,field26,2,date(15,5,2006),date(11,9,2006),date(15,9,2006)).  % Mo2, W2, M2; notebook and calendar vague on dates
crop('06R',missouri,field26,3,date(15,5,2006),date(11,9,2006),date(15,9,2006)).  % Mots started 9.5.06 and planted then; notebook and calendar vague on dates
 






