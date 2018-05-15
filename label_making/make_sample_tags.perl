#!/usr/local/bin/perl

# this is ../maize/label_making/make_sample_tags.perl

# generate tags for tissue samples, to be stapled onto shoot
# bags with leaf sections inside
#
# call is make_sample_tags.perl i MAX_NUM
#
# Kazic, 27.12.2012



# use the 1 x 2 5/8 inch Avery tags; 30-up


use Typesetting::DefaultOrgztn;
use Typesetting::OrganizeData;
use Typesetting::TypesetGenetics;
use Typesetting::TypesettingMisc;
use Typesetting::GenerateOutput;


$crop = $ARGV[0];
$num = $ARGV[1];



$file_stem = "sample_tags"; 
$output = $output_dir . $file_stem . $tex_suffix;



(@labels) = &make_sample_tags($num);




open(TAG,">$output");

&begin_latex_file(\*TAG);

for ( $i = 0; $i <= $num - 1; $i++ ) {
        ($barcode_out_upper,$row_upper) = split(/::/,$labels[$i]);
        &print_sample_tag(\*TAG,$barcode_out_upper,$row_upper,$i,$num);
        }


&end_latex_file(\*TAG);

close(TAG);










&generate_pdf($output_dir,$file_stem,$ps_suffix,$pdf_suffix);
