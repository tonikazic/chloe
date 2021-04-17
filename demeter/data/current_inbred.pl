% this is ../c/maize/demeter/data/current_inbred.pl

% file of the inbred lines that are currently planted, because so many inbred lines
% come from the same founding parents
%
% indexing not the most efficient, but it works
%
% Kazic, 27.11.2009

% current_inbred(Crop,MaFamily,PaFamily,InbredFamily,StdPacketNum).


% 21r

current_inbred('20R',201,201,205,p00001).
current_inbred('20R',301,301,305,p00002).
current_inbred('20R',401,401,405,p00003).
current_inbred('20R',504,504,505,p00004).
current_inbred('20R',889,889,889,p00005).
current_inbred('20R',000,000,000,p00000).




% 20r

current_inbred('20R',201,201,205,p00001).
current_inbred('20R',301,301,305,p00002).
current_inbred('20R',401,401,405,p00003).
current_inbred('20R',504,504,505,p00004).
current_inbred('20R',889,889,889,p00005).
current_inbred('20R',000,000,000,p00000).







% 19r

% added in the skipped corn, today putting in full digits to make the perl
% regular expression match
%
% Kazic, 8.9.2019

current_inbred('19R',201,201,205,p00001).
current_inbred('19R',301,301,305,p00002).
current_inbred('19R',401,401,405,p00003).
current_inbred('19R',504,504,505,p00004).
current_inbred('19R',891,891,891,p00005).
current_inbred('19R',000,000,000,p00000).



% 18r

current_inbred('18R',201,201,205,p00001).
current_inbred('18R',301,301,305,p00002).
current_inbred('18R',401,401,405,p00003).
current_inbred('18R',504,504,505,p00004).
current_inbred('18R',891,891,891,p00005).    




% 17r

current_inbred('17R',201,201,205,p00001).
current_inbred('17R',301,301,305,p00002).
current_inbred('17R',401,401,405,p00003).
current_inbred('17R',504,504,505,p00004).




% 16r

current_inbred('16R',201,201,205,p00001).
current_inbred('16R',301,301,305,p00002).
current_inbred('16R',401,401,405,p00003).
current_inbred('16R',504,504,505,p00004).
    



% 15r

current_inbred('15R',201,201,205,p00001).
current_inbred('15R',301,301,305,p00002).
current_inbred('15R',401,401,405,p00003).
current_inbred('15R',504,504,505,p00004).





% 14r


current_inbred('14R',201,201,205,p00001).
current_inbred('14R',301,301,305,p00002).
current_inbred('14R',401,401,405,p00003).
current_inbred('14R',504,504,505,p00004).




% 13r

current_inbred('13R',201,201,205,p00001).
current_inbred('13R',301,301,305,p00002).
current_inbred('13R',401,401,405,p00003).
current_inbred('13R',502,502,504,p00004).



    
% 12n

current_inbred('12N',201,201,205,p00001).
current_inbred('12N',301,301,305,p00002).
current_inbred('12N',401,401,405,p00003).
current_inbred('12N',502,502,504,p00004).




% 12r

current_inbred('12R',201,201,205,p00001).
current_inbred('12R',301,301,305,p00002).
current_inbred('12R',401,401,405,p00003).
current_inbred('12R',500,500,501,p00004).
%
% when constructing mutant row plans, we want to build the plan for
% these rows, even though they are inbreds with designated packet numbers,
% because these rows are really part of the selection for inbreds that grow
% well in both summer and winter nursery.  So they''re not really inbreds in
% the usual sense of the recurrent parent for the backcrosses.  In fact, they
% shouldn''t even have a designated packet; instead, they should just be treated
% as mutants.
%
% Kazic, 25.4.2012
%
% current_inbred('12R',501,501,502,p00005).



    

    
% 11n

current_inbred('11N',201,201,205,p00001).
current_inbred('11N',301,301,305,p00002).
current_inbred('11N',401,401,405,p00003).
current_inbred('11N',500,500,501,p00004).





    
% 11r

current_inbred('11R',201,201,205,p00001).
current_inbred('11R',301,301,305,p00002).
current_inbred('11R',401,401,405,p00003).
% current_inbred('11R',500,500,500,p00004).


    



% 10r

current_inbred('10R',201,201,205,p00001).
current_inbred('10R',301,301,305,p00002).
current_inbred('10R',401,401,405,p00003).


    
    
    

% 09r

current_inbred('09R',200,200,201,p00001).
current_inbred('09R',300,300,301,p00002).
current_inbred('09R',400,400,401,p00003).





% 08g

current_inbred('08G',200,200,201,p00001).
current_inbred('08G',300,300,301,p00002).
current_inbred('08G',401,401,403,p00003).
    



% 08r

current_inbred('08R',200,200,201,p00001).
current_inbred('08R',300,300,301,p00002).
current_inbred('08R',401,401,403,p00003).




% 07g

current_inbred('07G',200,200,201,p00001).
current_inbred('07G',300,300,301,p00002).
current_inbred('07G',400,400,401,p00003).




% 07r

current_inbred('07R',200,200,201,p00001).
current_inbred('07R',300,300,301,p00002).
current_inbred('07R',400,400,401,p00003).
    


% 06g

current_inbred('06G',200,200,201,p00001).
current_inbred('06G',300,300,301,p00002).
current_inbred('06G',400,400,401,p00003).




% 06n

current_inbred('06N',200,200,201,p00001).
current_inbred('06N',300,300,301,p00002).
current_inbred('06N',400,400,401,p00003).



    
   
% 06r

current_inbred('06R',200,200,200,p00001).
current_inbred('06R',300,300,300,p00002).
current_inbred('06R',400,400,400,p00003).
