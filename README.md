# Chloe and Demeter are the code components of our crop management system for our maize research.  

   + *Chloe*:  a set of Perl scripts to process raw data; generate tags, labels, 
   and barcodes; and miscellaneous crop management tasks.  These files have a .perl
   suffix.  
   
   + *Demeter*: a declarative, Prolog database for crop, genetic, and phenotype data; 
   associated data provenance; and code for pedigree generation, crop planning, and 
   management of field work.    These files have a .pl suffix, since I started writing
   Prolog before Perl.
   
   Both rely entirely on open-source tools.  Mobile device-specific tools (free or very cheap) are used for data capture.  *Chloe* applies to both the whole system and the Perl component (a little operator overloading).


There are three forms of documentation:
   + [chloe.org](./docs/chloe/chloe.org) is the most extensive documentation and user guide;
   + [a poster at the 2019 Maize Genetics Conference](./docs/chloe/poster.pdf); and
   + [a bioRxiv preprint](https://doi.org/10.1101/2020.01.28.923763).

The preprint has been submitted to a journal.  For now, please cite this work as:

Chloe: Flexible, Efficient Data Provenance and Management
Toni Kazic
bioRxiv 2020.01.28.923763; doi: https://doi.org/10.1101/2020.01.28.923763

BioRxiv has the nifty citation tools to generate this citation in your favorite reference manager's format.


Comments and pull requests are welcome, *especially for the documentation*.  
Please use the Github issue machinery for reporting issues, rather than 
emailing me.  I can guide you in adapting the code for your work: you don't 
need to know much about writing code to get started.

Note that dates are in the form day.month.year.

Kazic, 30.1.2020

