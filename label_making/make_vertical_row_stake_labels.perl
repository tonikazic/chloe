#!/opt/perl5/perls/perl-5.26.1/bin/perl

# this is ../c/maize/label_making/make_vertical_row_stake_labels.perl

# this was ../c/maize/label_making/make_row_stake_labels.perl, now simplified a bit



# generate labels to go on the row stakes.  
#
#
# Wooden stakes with vertical layout now extensively tested; labels are
# laminated and stapled to stakes with stainless steel, marine-grade
# staples.  We tried caulking and epoxying the labels: caulking was
# permanent, 5' epoxy more so.
#
#
# The plastic sheets the labels are printed on are undivided 8.5 x 11
# inches, and we need 4 ish x 1 inch labels, so we could in principle get
# 22 labels/sheet.  In practice, we allow for print margins all around, so
# that we get 20 labels/sheet, ensuring that nothing is printed within 0.5
# inch of any margin.
#
#
# Stake lifetime is 3 or more years: we insert these about 1 inch into the
# ground to reduce the area of rot.  Stakes are retrieved at the end of the
# season, the soil rinsed off, and dried for a couple of days in a mesh bag
# along with the corn.  The main reason for premature stake retirement is
# stepping on them.
#
#
# Someday, new wire row stakes will use "vertical" instead of "horizontal".
#
#
# Kazic, 15.5.2018





# call is make_vertical_row_stake_tags.perl i NUM_ROWS 0
# (second argument, the NUM_CUTTING_TEMPLATES, is obsolete here but overloaded
# to allow for easy generation of replacement labels).
#
# Kazic, 13.11.2007
#
#
#
# for replacement vertical labels, call is make_vertical_row_stake_labels.perl i r
# have to rewrite the array of replacement labels as needed
#
# Kazic, 5.5.2011





use strict;
use warnings;


use lib './Typesetting/';

use DefaultOrgztn;
use OrganizeData;
use TypesetGenetics;
use TypesettingMisc;
use GenerateOutput;


my $crop = $ARGV[0];
my $num_rows = $ARGV[1];
my $num_cutting = $ARGV[2];






# array of labels needed now in $input_file, which lives in
# ../crops/inventory/management.  Each row on a single line, terminated
# with a carriage return: no commas or r00 or array machinery.
#
# Watch out for hidden characters leading each line in the input file!
# These don't appear in emacs whitespace-mode, but since I'm taking in the
# line raw, they bollix the string length, and therefore the padding.
#
# Kazic, 13.5.2018



# $input_stem = "replacemt_rows";
my $input_stem = "18r_still_more_stakes.csv";
my $input_file = $input_dir . $input_stem;

my @labels_needed;
my @labels;


my $file_stem = "row_stake_labels"; 
my $output = $output_dir . $file_stem . $tex_suffix;



open my $in, '<', $input_file or die "can't open $input_file\n";



while (<$in>) {
        my ($row) = $_ =~ /[rR]?0{0,4}(\d{1,4}),?/;
#        print "r: $row\n";
        push(@labels_needed,$row);
        }









# this part is the same, no matter if the label is vertical or horizontal,
# as we are just generating the record for label layout.
#
# Kazic, 12.5.2014


if ( $num_rows =~ /\d+/ ) { (@labels) = &make_row_stake_labels($num_rows); }

elsif ( $num_rows =~ /^r$/ ) { (@labels) = &make_replacement_row_stake_labels($#labels_needed,\@labels_needed); }







# still prefer global variables!
#
# Kazic, 18.4.2018


open TAG, '>', $output or die "can't open $output\n";


&begin_row_stake_latex_file(\*TAG);





# vertical-specific calls

my ($i,$barcode_out,$row_num);

if ( $num_rows =~ /^r$/ ) {

        for ( $i = 0; $i <= $#labels; $i++ ) {
	        ($barcode_out,$row_num) = split(/::/,$labels[$i]);
#	        print "($barcode_out,$row_num)\n";
                &print_vertical_row_stake_label(\*TAG,$barcode_out,$row_num,$i,$#labels);
                }
        }

else {

        for ( $i = 0; $i <= $num_rows - 1; $i++ ) {
                ($barcode_out,$row_num) = split(/::/,$labels[$i]);
                &print_vertical_row_stake_label(\*TAG,$barcode_out,$row_num,$i,$num_rows);
                }
        }



&end_latex_file(\*TAG);










# latex whines about a use of \raise in vertical mode, just push
# r at the latex prompt to enter \nonstopmode

&generate_pdf($output_dir,$file_stem,$ps_suffix,$pdf_suffix);
