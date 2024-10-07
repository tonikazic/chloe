#!/usr/local/bin/perl

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


# modified call to take a crop label and a list of paper types, to improve
# tracking of stake longevity and plastic ``paper'' materials
#
# nb:  the CROP_MARKER is NOT the same as the CROP, which is i.  It is the crop
# in which the stakes are made.
#
# Kazic, 14.5.2020


# call is ./make_vertical_row_stake_labels.perl i r CROP_MARKER DOUBLE_COLON_SEPARATED_LIST_PAPER_TYPES
#
# e.g., ./make_vertical_row_stake_labels.perl i r 20r 'foo::bar'
# ./make_vertical_row_stake_labels.perl i r 20r 'polyes'


# polyes ==> MtM polyester sheet for 20r, see
# ../equipmt/row_stakes/materials/mtm_polyester_super_tuff.txt
#
# still need to handle the case of multiple materials
#
# Kazic, 15.5.2020



# We're consistently disappointed with the longevity of the polyester, so
# back to paper and laminating it!
#
# so call is ./make_vertical_row_stake_labels.perl i r 24r 'lampap'
#
# Kazic, 15.5.2024


use strict;
use warnings;


use Cwd 'getcwd';


use lib './Typesetting/';
use DefaultOrgztn;
use OrganizeData;
use TypesetGenetics;
use TypesettingMisc;
use GenerateOutput;


my $crop = $ARGV[0];
my $num_rows = $ARGV[1];
my $num_cutting = $ARGV[2];
my $material_list = $ARGV[3];

my @materials = split(/::/,$material_list);
my $num_materials = scalar @materials;
# for ( my $j = 0; $j <= $#materials ; $j++) { print "$materials[$j] \n"; }



# print "($crop,$num_rows,$num_cutting,$material_list)\n";





# array of labels needed now in $input_file, which lives in
# ../crops/inventory/management.  Each row on a single line, terminated
# with a carriage return: no commas or r00 or array machinery.
#
# Watch out for hidden characters leading each line in the input file!
# These don't appear in emacs whitespace-mode, but since I'm taking in the
# line raw, they bollix the string length, and therefore the padding.
#
# Kazic, 13.5.2018



# convert to DefaultOrgtzn::adjust_paths
#
# Kazic, 24.11.2018
#
# done
#
# Kazic, 14.5.2020

my $local_dir = getcwd;
my ($dir,$input_dir,$barcodes,$tags_dir) = &adjust_paths($crop,$local_dir);

# my $input_stem = $num_cutting . "_stakes_needed";
#
# for 24r
my $input_stem = $num_cutting . "_stakes_needed_merged";
my $input_file = $input_dir . $input_stem;

my $output_file = $tags_dir . $input_stem;


# print "($input_file,$dir,$input_dir,$barcodes,$tags_dir,$output_file)\n";



my @labels_needed;
my @labels;







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


open TAG, '>', $output_file or die "can't open $output_file\n";


&begin_row_stake_latex_file(\*TAG);





# vertical-specific calls

my ($i,$barcode_out,$row_num,$material);




# need to count number of sheets and divide by number of materials,
# then loop through the materials for blocks for each sheets.
# but right now this is fine for 20r and I need to get on to the
# pedigrees.
#
# Kazic, 15.5.2020

if ( $num_materials == 1 ) { $material = $materials[0]; }
else {}



# replacement stakes


if ( $num_rows =~ /^r$/ ) {

        for ( $i = 0; $i <= $#labels; $i++ ) {
	        ($barcode_out,$row_num) = split(/::/,$labels[$i]);
#	        print "($barcode_out,$row_num)\n";


#                &print_vertical_row_stake_label(\*TAG,$barcode_out,$row_num,$i,$#labels);
		
                &print_vertical_row_stake_label(\*TAG,$barcode_out,$row_num,$num_cutting,$material,$i,$#labels);

		

                }
        }


# de novo stakes

else {

        for ( $i = 0; $i <= $num_rows - 1; $i++ ) {
                ($barcode_out,$row_num) = split(/::/,$labels[$i]);
                &print_vertical_row_stake_label(\*TAG,$barcode_out,$row_num,$num_cutting,$material,$i,$num_rows);
                }
        }



&end_latex_file(\*TAG);










# latex whines about a use of \raise in vertical mode, just push
# r at the latex prompt to enter \nonstopmode
#
# ! You can't use `\raise' in vertical mode.
# \put  (#1,#2)#3->\@killglue \raise 
#                                   #2\unitlength \hb@xt@ \z@ {\kern #1\unitl...
# l.273 ...90}{\scalebox{1.2}{\Huge{\textbf{248}}}}}
#                                                  
# ? r


&generate_pdf($tags_dir,$input_stem,$ps_suffix,$pdf_suffix);


