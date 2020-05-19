#!/usr/local/bin/perl

# this is maize/label_making/make_leaf_photo_tags.perl
#
# adapted from maize/label_making/make_missing_tags.perl

# generate the equivalent of tear-off tags for photographing leaves; the
# Avery 1 x 2 5/8 inch 30-up labels are the same size as the tear-off tags
# from the plant tags.  Output goes into inventory.
#
# Kazic, 18.8.09

# call is ./make_leaf_photo_tags.perl i



use Typesetting::DefaultOrgztn;
use Typesetting::TypesetGenetics;
use Typesetting::TypesettingMisc;
use Typesetting::GenerateOutput;



 



$input_file = "leaf_list.csv";
$file_stem = "leaf_photo_tags";



$input = $input_dir . $input_file;
$output = $output_dir . $file_stem . $tex_suffix;



open(IN,"<$input") || die "can't open input $input\n";





while (<IN>) {
        chomp($_);

        ($radix,$sign,$subscript) = $_ =~ /(\w),([\-\+\']+),(\d+)/;


        $record = $radix  . "::" . $sign  . "::" . $subscript;

#        print "$record\n";

        push(@labels,$record);
        }

close(IN);








# now have to make the latex files for the labels, moving over @labels

# print "out is $output\n\n **************************** \n\n";

open(TAG,">$output");


&begin_latex_file(\*TAG);

for ( $i = 0; $i <= $#labels; $i++ ) {
        ($radix,$sign,$subscript) = split(/::/,$labels[$i]);
        &print_leaf_photo_tags(\*TAG,$radix,$sign,$subscript,$i,$#labels);
        }

&end_latex_file(\*TAG);

close(TAG);


&generate_pdf($output_dir,$file_stem,$ps_suffix,$pdf_suffix);

