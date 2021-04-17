#!/usr/local/bin/perl

# this is make_inbred_bag_labels.perl
#
# Kazic, 29.12.07

# A script to generate the labels that go on the bags of shelled corn from
# selfed and sibbed inbred lines.  The numerical genotypes are a bit different
# than usual because the ears are pooled.  So a selfed ear becomes ###xxx X ###xxx
# while a sibbed ear is ###xxx X ###yyy.
#
#
# The input data file lives in the crops/inventory subdirectory.
#
# Lines not constructed are listed in the file, but commented out.  The numbering scheme for
# families is:
# 
#        2nn -- Mo20W
#        3nn -- W23
#        4nn -- M14
#
#        nNN -- 00 -- founding seed from USDA, Peoria
#        nNN -- 01 =< NN =< 50 -- selfed seed
#        nNN -- 51 =< NN =< 99 -- sibbed seed
#
# If no inbred seed is produced in a crop, no family numbers are assigned.
# Thus, the inbred background changes relatively slowly compared to the
# mutant background.  The plan is to produce large pools of seed every few
# summers, with smaller pools generated every summer crop for safety in case
# the most recent large pool fails; and to plan as many consecutive
# generations from each large pool as possible.  Unless there is a problem, 
# inbred seed nursery won't occur in the winter and greenhouse crops.
#
# The selfs are used for the backcrosses, with the sibs set aside as a safety pool.
# Sibs are produced each generation from the inbred (selfed) seed planted.
#
# I hope to run out of integers and increment the centuries! It would be extraordinary
# to need to increment the centuries twice:  try for 130!
#
#
# That was the original plan, but I think it overly conservative.  I have retained 200 cl
# of each of families 201, 301, and 401.  In 09R I produced just selfed inbreds (families
# 205, 305, and 405) and will run germination tests on these.  I'll produce a few sibs
# roughly every decade from the current selfed pools.
#
# Kazic, 30.3.2010
#
#
#
#
# This script takes a comma-delimited file dumped from a spreadsheet or
# database, generates a 128 bit bar code for each female and male using the GNU
# barcode library, puts the bar code in an encapsulated PostScript file,
# and then generates a label for the bag of inbred seed with genotypic information and
# harvesting instructions for each pollinated ear in the database.  A LaTeX
# file with the tag information is generated and processed to produce a
# PostScript file.  This file can be printed directly or converted into PDF
# with any suitable viewer and printed from there.
#
# 
# Because the records in the input file are hashed, duplicate tags must be
# manually inserted into the latex file.



# call is ./make_inbred_bag_labels.perl i


# ported to perl 5.26
#
# Kazic, 17.4.2021


use strict;
use warnings;


use Cwd 'getcwd';



use lib './Typesetting/';


use DefaultOrgztn;
use MaizeRegEx;
use Utilities;
use OrganizeData;
use TypesetGenetics;
use GenerateOutput;


my $crop = $ARGV[0];
my $local_dir = getcwd;
my ($dir,$input_dir,$barcodes,$tags_dir) = &adjust_paths($crop,$local_dir);




my $input_stem = "maternal_inbred_lines";
my $tags_stem = "inbred_seed_bag_labels";



my $input_file = $input_dir . $input_stem;
my $output_file = $tags_dir . $tags_stem . $tex_suffix;



# print "($local_dir,$input_file,$dir,$input_dir,$barcodes,$tags_dir,$output_file)\n";




my %inbred_lines;
my $num_extras = 0;





open my $in, '<', $input_file  or die "can't open $input_file\n";

while (<$in>) {

        if ( $_ !~ /^#/ ) {

                my ($crop,$family,$ma_num_gtype,$pa_num_gtype,$gtype,$num_extra_tags) = $_ =~ /\"?(${crop_re})\"?,\"?(${family_re})\"?,\"?(${num_gtype_re})\"?,\"?(${num_gtype_re})\"?,\"?(${gtype_re})\"?,\"?(${abs_leaf_num_re})\"?/;

                my $female_out = &make_barcodes($barcodes,$ma_num_gtype,$esuffix);
	        my $male_out = &make_barcodes($barcodes,$pa_num_gtype,$esuffix);

                my $record = $female_out . "::" . $male_out . "::" . $crop . "::" . $ma_num_gtype . "::" . $pa_num_gtype . "::" . $gtype . "::" . $num_extra_tags;
                $inbred_lines{$family} = $record;
                $num_extras += $num_extra_tags;
	        }
        }







# now have to make the latex files for the labels, moving over %inbred_lines

&make_inbred_seed_bag_labels($output_file,$num_extras,%inbred_lines);
&generate_pdf($tags_dir,$tags_stem,$ps_suffix,$pdf_suffix);


