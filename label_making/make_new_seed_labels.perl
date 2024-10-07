#!/usr/local/bin/perl

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


# fixed bug in call to generate_pdf and excluded blank lines 
#
# Kazic, 21.5.2019





# call is ./make_new_seed_labels.perl i FLAG
#
# use i as the first argument to supply the inventory directory tree
# from DefaultOrgztn per usual
#
# and where FLAG is one of {q,test,go}



# converted to run in perl 5.26
#
# Kazic, 27.4.2018


# use strict;
# use warnings;


use Cwd 'getcwd';
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


my $local_dir = getcwd;
my $crop = $ARGV[0];
my $flag = $ARGV[1];
my ($dir,$input_dir,$barcodes,$tags_dir) = &adjust_paths($crop,$local_dir);
# print "d: $dir\nid: $input_dir\nb: $barcodes\nt:$tags_dir\n";



my $input_stem = "22r_tags_needed";
my $tags_stem = $input_stem;

# print "is: $input_stem\nts: $tags_stem\n";




my $input_file = $input_dir . $input_stem;
my $output_file = $tags_dir . $tags_stem . $tex_suffix;
my @labels;

# print "tsuff: $tex_suffix\nof: $output_file\n";


open my $in, '<', $input_file or die "can't open $input_file\n";

while (<$in>) {

   	if ( ( $_ !~ /^,/ ) && ( $_ !~ /^\#/ ) && ( $_ !~ /^\n/ ) ) {

		
# simplified regex, since we usually don't have any bogus plantIDs any more
#
# Kazic, 17.4.2021
#		
#                my ($correct_ma,$correct_pa,$old_ma) = $_ =~ /^\"?(${num_gtype_re})\"?,\"?(${num_gtype_re})\"?,\"?(${num_gtype_re})\"?,*/;
#
#                my ($correct_ma,$correct_pa,$old_ma) = $_ =~ /^[\'\"]?(${num_gtype_re})[\'\"]?,[\'\"]?(${num_gtype_re})[\'\"]?,?[\'\"]?(.*)[\'\"]?,*/;


		
# shifted to pre-cleaning the line, rather than in the refex
#
# Kazic, 14.11.2021		

		
		$_ =~ s/[\'\"]//g;
                my ($correct_ma,$correct_pa,$old_ma) = $_ =~ /^(${num_gtype_re}),(${num_gtype_re}),?(.*),*/;		
		
#               print "($correct_ma,$correct_pa,$old_ma)\n";
                my $ma_barcode_out = &make_barcodes($barcodes,$correct_ma,$esuffix);
                my $pa_barcode_out = &make_barcodes($barcodes,$correct_pa,$esuffix);


                my $record = $correct_ma . "::" . $ma_barcode_out . "::" . $correct_pa  . "::" . $pa_barcode_out . "::" . $old_ma;
#	        print "$record\n";
                push(@labels,$record);           
                }

        }








# now have to make the latex files for the tags, moving over @cross
#
# use generate_pdf, rather than generate_pdfl, as the barcodes' eps
# files must be incorporated into the final tags
#
# Kazic, 21.5.2019

&make_new_seed_labels($output_file,$today,$#labels,\@labels);
&generate_pdf($tags_dir,$tags_stem,$ps_suffix,$pdf_suffix);




