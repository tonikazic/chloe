#!/usr/bin/perl

# this is make_harvest_tags.perl
#
# Kazic, 9.9.06


# This script takes a comma-delimited file dumped from a spreadsheet or
# database, generates a 128 bit bar code for each female using the GNU
# barcode library, puts the bar code in an encapsulated PostScript file,
# and then generates a harvest tag with genotypic information and
# harvesting instructions for each pollinated ear in the database.  A LaTeX
# file with the tag information is generated and processed to produce a
# PostScript file.  This file can be printed directly or converted into PDF
# with any suitable viewer and printed from there.


# call is ./make_harvest_tags.perl CROP
#
# can use i for CROP to access the inventory directory tree per usual

use Typesetting::DefaultOrgztn;
use Typesetting::MaizeRegEx;
use Typesetting::Utilities;
use Typesetting::OrganizeData;
use Typesetting::TypesetGenetics;
use Typesetting::GenerateOutput;



# note these are in the 06r subdirectory!

$cross_stem = "big_crosses.csv";
# $input_stem = "full_inventory.csv";
# $tags_stem = "harvest_tags";

# these are in inventory:  there was no cross_file for these replacement tags

$input_stem = "new_tags_for_06r.csv";
$tags_stem = "new_06r_harvest_tags";

$cross_file = $input_dir . $cross_stem;
$input_file = $input_dir . $input_stem;
$output_file = $output_dir . $tags_stem . $tex_suffix;


# if no cross file exists, then comment out the blocks and lines marked with
#
#   # begin toggle
#   # end toggle
#
# and run the file as usual.  The default is that such a cross file exists, so I have
# left the lines uncommented.
#
# Kazic, 1.1.08


# begin toggle

open(CROSS,"<$cross_file") || die "can't open $cross_file\n";

while (<CROSS>) {
        ($cdate,$old_ma_num_gtype,$old_ma_gtype,$ear,$old_pa_num_gtype,$old_pa_gtype) = $_ =~ /(${date_re}),\"?(${old_num_gtype_re})\"?,\"?(${gtype_re})\"?,(${ear_re}),\"?(${old_num_gtype_re})\"?,\"?(${gtype_re})\"?/;

        $old_ma_num_gtype =~ s/\d{2}(.+)/\1/;
        $old_pa_num_gtype =~ s/\d{2}(.+)/\1/;
        $attempted_crosses{$old_ma_num_gtype} = $old_pa_num_gtype . "::" . $old_ma_gtype . "::" . $old_pa_gtype . "::" . $ear . "::" . $cdate;
        }

close(CROSS);

$num_crosses_attempted = keys (%attempted_crosses);
$j = 0;
$k = 0;

# end toggle

open(IN,"<$input_file") || die "can't open $input_file\n";

while (<IN>) {

        ($ear_crop) = $_ =~ /^\"?(${crop_re})\"?,/;
        $ear_crop =~ tr/[A-Z]/[a-z]/;
       

# begin toggle

        if ( $ear_crop eq $crop ) {

# end toggle
                $j++;

                ($ma_num_gtype,$pa_num_gtype,$rest) = $_ =~ /\"?(${num_gtype_re})\"?,\"?\d*\"?,\"?(${num_gtype_re})\"?,(.+)$/;

# begin toggle
                ($ma_gtype,$pa_gtype) = $rest =~ /(${full_gtype_re}),${quasi_re},(${full_gtype_re})/;

# end toggle


# begin toggle -- this line is commented IN if no cross file; it grabs the cross date from the previous inventory record
#
#        	($ma_gtype,$pa_gtype,$cdate) = $rest =~ /(${full_gtype_re}),\"?${quasi_re}\"?,(${full_gtype_re}),\d*,\d*,\"?${quasi_re}\"?,\"?(${date_re})\"?/;
#
# end toggle

# since the original 06r barcodes were 10 characters with a single inbred
# prefix and decimal points, a little conversion between the barcodes
# recorded in the crosses and those in the inventory (which are corrected
# to the current 15-character standard) is needed in order to use the cross
# data to fetch $ear and $cdate.

                ($abbrv_ma_num_gtype,$abbrv_pa_num_gtype) = &abbreviate_num_gtypes($ma_num_gtype,$pa_num_gtype);


# now check against cross record


# begin toggle
                if ( $cross_record = $attempted_crosses{$abbrv_ma_num_gtype} ) {
 
                        $k++;

                        ($old_pa_num_gtype,$old_ma_gtype,$old_pa_gtype,$ear,$cdate) = split(/::/,$cross_record);
                        if ( $old_pa_num_gtype !~ $abbrv_pa_num_gtype) { 
                                print "Warning!  mismatch between paternal num gtype in cross record and inventory: ma: $old_ma_num_gtype cr: $old_pa_num_gtype inv: $abbrv_pa_num_gtype\n"; 
                                }
# end toggle
	                ($month,$day,$year) = $cdate =~ /(${month_re})\/(${day_re})\/(${year_re})/;
	                $date = $day . "." . $month . "." . $year;
# begin toggle
	                }
# end toggle





# now screen out the inbred selfs and sibs, since they're already
# shelled and in their respective seed bags; such offspring will not
# have a mutant father, since all my introgressions and backcrosses are
# done as inbred x mutant

		($ma_family) = $ma_num_gtype =~ /${crop_re}(${family_re})\:/;
		($pa_family) = $pa_num_gtype =~ /${crop_re}(${family_re})\:/;

                if ( length($pa_family) == 4 ) {

                        $female_out = $barcodes . $ma_num_gtype . $esuffix;
	                $male_out = $barcodes . $pa_num_gtype . $esuffix;

                        system("/usr/local/bin/barcode -c -E -b $ma_num_gtype -u in -g \"2x1+0.2+0.2\" -e 128 -o $female_out");
	                system("/usr/local/bin/barcode -c -E -b $pa_num_gtype -u in -g \"2x1+0.2+0.2\" -e 128 -o $male_out");

                        $ear = 1;

                        $record = $female_out . "::" . $male_out . "::" . $ma_num_gtype . "::" . $pa_num_gtype . "::" . $ma_gtype . "::" . $pa_gtype  . "::" . $ear . "::" . $date;
           
                        $inventoried_crosses{$abbrv_ma_num_gtype} = $record;
		        }
# begin toggle
                }
# end toggle
        }

close(IN);

print "\n\n***********\ntotal crosses: $num_crosses_attempted  num $crop crosses in inventory: $j num $crop crosses found in crosses hash: $k\n";


# sort the %inventoried_crosses by the abbreviated mommies, then shove the records into 
# an indexed array; the idea is to make finding the ears during relabelling a little easier

foreach $elt ( sort (keys(%inventoried_crosses) ) ) { push(@crosses,$inventoried_crosses{$elt}); }

print "num: " . $#crosses . "\n\n***********\n";





# now have to make the latex files for the tags, moving over @cross

&make_harvest_tags($output_file,$#crosses,\@crosses);
&generate_pdf($output_dir,$tags_stem,$ps_suffix,$pdf_suffix);


