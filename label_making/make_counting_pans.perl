#!/usr/bin/perl

# this is /mnemosyne/a/maize/label_making/make_counting_pans.perl

# the paper inserts with three or four circles that fit inside the
# seed counting pans
#
# Kazic, 27.4.08

# call is perl ./make_counting_pans.perl i NUM_15_SEED_INSERTS NUM_20_SEED_INSERTS


use Typesetting::DefaultOrgztn;
use Typesetting::TypesetGenetics;
use Typesetting::TypesettingMisc;
use Typesetting::GenerateOutput;

 

$num_15 = $ARGV[0];
$num_20 = $ARGV[1];

$file_stem = "counting_pan_inserts";



$output = $output_dir . $file_stem . $tex_suffix;



open(TAG,">$output");

&begin_latex_file(\*TAG);

for ( $i = 0; $i <= $num_15; $i++ ) { &print_counting_insert(15,\*TAG); }
for ( $i = 0; $i <= $num_20; $i++ ) { &print_counting_insert(20,\*TAG); }

&end_latex_file(\*TAG);

close(TAG);


&generate_pdfl($output_dir,$file_stem);




