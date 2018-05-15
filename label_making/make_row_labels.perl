#!/usr/bin/perl

# this is maize/label_making/make_row_labels.perl

# generate labels to go on the shipping tags that go on the first plant
# of each row, and eventually onto the harvest bag for that row; for the winter
# crop.
#
# Kazic, 6.1.07


# call is ./make_row_labels CROP LOCATION YEAR


use Typesetting::DefaultOrgztn;
use Typesetting::TypesetGenetics;
use Typesetting::TypesettingMisc;
use Typesetting::GenerateOutput;


$crop = $ARGV[0];
$location = $ARGV[1];
$year = $ARGV[2];
 

$input_file = "harvest_rows.csv";
$input = "$input_dir/$input_file";

$file_stem = "row_labels";
$output = $output_dir . $file_stem . $tex_suffix;




open(IN,"<$input");

while (<IN>) {
        ($row,$family) = $_ =~ /^\"?(\d+)\"?,\"?(\d*)\"?/;
        push(@labels,$row . "::" . $family);
        }

close(IN);




# now have to make the latex files for the labels, moving over @labels

open(TAG,">$output");

&begin_latex_file(\*TAG);

for ( $i = 0; $i <= $#labels; $i++ ) {
        ($row,$family) = split(/::/,$labels[$i]);
        &print_row_label(\*TAG,$location,$year,$row,$family,$i,$#labels);
        }


&end_latex_file(\*TAG);

close(TAG);


# pdflatex does fine here; no barcodes to worry about!

&generate_pdfl($output_dir,$file_stem);



