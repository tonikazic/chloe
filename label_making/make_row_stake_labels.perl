#!/usr/local/bin/perl

# this is ../c/maize/label_making/make_row_stake_labels.perl

# generate labels to go on the row stakes.  
#
# Warning!  We haven't tested these labels in the field yet, so we
# can't advise on the best methods for their production.
# 
# call is make_row_stake_tags.perl i NUM_ROWS NUM_CUTTING_TEMPLATES
#
# Kazic, 13.11.2007
#
# for replacement vertical labels, call is make_row_stake_tags.perl i r
# have to rewrite the array of replacement labels as needed
#
# Kazic, 5.5.2011



# shift to the 1 x 2 5/8 inch Avery tags; 30-up
#
# Kazic, 29.4.2008


# wooden stakes with vertical layout now extensively tested
#
# Kazic, 1.11.2009


# switched to horizontal layout for the new wire row stakes; previous subroutines
# had "vertical" instead of "horizontal"
#
# Kazic, 23.3.2010



use Typesetting::DefaultOrgztn;
use Typesetting::OrganizeData;
use Typesetting::TypesetGenetics;
use Typesetting::TypesettingMisc;
use Typesetting::GenerateOutput;


$crop = $ARGV[0];
$num_rows = $ARGV[1];
$num_cutting = $ARGV[2];

@labels_needed = (1,2,3,5,6,9,12,15,20);


$file_stem = "row_stake_labels"; 
$output = $output_dir . $file_stem . $tex_suffix;




if ( $num_rows =~ /\d+/ ) { (@labels) = &make_row_stake_labels($num_rows); }

elsif ( $num_rows =~ /^r$/ ) { (@labels) = &make_replacement_row_stake_labels($#labels_needed,\@labels_needed); }









open(TAG,">$output");

&begin_row_stake_latex_file(\*TAG);


if ( $num_rows =~ /^r$/ ) { 
        for ( $i = 0; $i <= $#labels; $i++ ) {
                ($barcode_out,$row_num) = split(/::/,$labels[$i]);
                &print_vertical_row_stake_label(\*TAG,$barcode_out,$row_num,$i,$#labels);
                }
        }

else {

        for ( $i = 0; $i <= $num_rows - 1; $i++ ) {
                ($barcode_out,$row_num) = split(/::/,$labels[$i]);
                &print_horizontal_row_stake_label(\*TAG,$barcode_out,$row_num,$i,$num_rows);
                }
        }





# need lines for the laminate and centered boxes for the labels

# &print_horizontal_row_stake_cutting_templates(\*TAG,$num_cutting);


&end_latex_file(\*TAG);

close(TAG);










&generate_pdf($output_dir,$file_stem,$ps_suffix,$pdf_suffix);
