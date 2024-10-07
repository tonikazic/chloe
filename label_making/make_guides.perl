#!/usr/local/bin/perl

# this is make_guides.perl

# a little script for printing out the guide boxes in Typesetting/Guides.pm
#
# Kazic, 2.12.06.

# note that the \topmargin in barcode_margins.sty must be toggled depending on 
# whether latex or pdflatex is used to process the file
#
# Kazic, 1.7.07


# call is ./make_guides.perl CROP
#
# This is a bit silly in the sense that the guide boxes are the same, no matter the crop.
# But this has the virtues of re-using the default directory organization and dumping the
# guides output in the vicinity of the tags one's trying to make.
#
# Kazic, 6.11.07


# huh?
#
# Kazic, 8.7.2022


use Typesetting::DefaultOrgztn;
use Typesetting::PrintGuides;
use Typesetting::GenerateOutput;


$file_stem = "guides_o";
$tags = $output_dir . $file_stem . $tex_suffix;




# choices for the first argument are:
#
#     seed_packet             1 x 2 5/8 inch 30-up
#     big_label               2 x 4 inch 10-up
#     little_label            1 x 4 inch 20-up
#     business_card           2 x 3.5 inch 10-up???
#     partial_business_card   2 x 3.5 inch 20-up
#     plant_tag               27mm x 14 inch 8-up
#     leaf_tag                3.5cm x 10.5cm 16-up


# &print_guides("seed_packet",$tags);
&print_leaf_label_guide_lines($tags);
&generate_pdf($output_dir,$file_stem,$ps_suffix,$pdf_suffix);

