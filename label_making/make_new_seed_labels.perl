#!/opt/perl5/perls/perl-5.26.1/bin/perl

# this is ../c/maize/label_making/make_new_seed_labels.perl
#
# Kazic, 21.5.2014


# Given a comma-delimited file of correct ma plantID, correct pa plantID, and
# previous ma plantID, generate a new ``harvest'' tag to replace the old one.
#
# This is to correctly identify seed envelopes whose female or male, or both, barcodes 
# have changed due to migration of family numbers, mis-edited rowplants, etc.  These
# problems appeared after the re-inventory of our corn.


# More generally, the barcodes can decay over time, even in the seed room.  So
# this script allows us to replace them, even when there is no misidentification.
#
# source file should not have column headers --- or if it does, that line should begin
# with a # or , .
#
# Kazic, 27.4.2018


# call is ./make_new_seed_labels.perl i
#
# use i as the first argument to supply the inventory directory tree
# from DefaultOrgztn per usual



# converted to run in perl 5.26
#
# Kazic, 27.4.2018


use strict;
use warnings;



use Date::Calc qw(Today);

use lib './Typesetting/';
use DefaultOrgztn;
use MaizeRegEx;
use Utilities;
use OrganizeData;
use TypesetGenetics;
use GenerateOutput;


my ($todayyear,$todaymonth,$todayday) = &Today;
my $today = $todayday . "." . $todaymonth . "." . $todayyear;



my $input_stem = "still_more_18r_tags";
# my $input_stem = "final_tags_for_18r";
my $tags_stem = "still_more_18r_tags";

# $input_stem = "new_seed_labels.csv";
# $tags_stem = "new_seed_labels";


my $input_file = $input_dir . $input_stem;
my $output_file = $output_dir . $tags_stem . $tex_suffix;
my @labels;



open my $in, '<', $input_file or die "can't open $input_file\n";

while (<$in>) {

   	if ( ( $_ !~ /^,/ ) && ( $_ !~ /^\#/ ) ) {
    
                my ($correct_ma,$correct_pa,$old_ma) = $_ =~ /^\"?(${num_gtype_re})\"?,\"?(${num_gtype_re})\"?,\"?(${num_gtype_re})\"?,*/;

#               print "($correct_ma,$correct_pa,$old_ma)\n";
                my $ma_barcode_out = &make_barcodes($barcodes,$correct_ma,$esuffix);
                my $pa_barcode_out = &make_barcodes($barcodes,$correct_pa,$esuffix);


                my $record = $correct_ma . "::" . $ma_barcode_out . "::" . $correct_pa  . "::" . $pa_barcode_out . "::" . $old_ma;
#	        print "$record\n";
                push(@labels,$record);           
                }

        }








# now have to make the latex files for the tags, moving over @cross

&make_new_seed_labels($output_file,$today,$#labels,\@labels);
&generate_pdf($output_dir,$tags_stem,$ps_suffix,$pdf_suffix);


