#!/usr/bin/perl

# this is /athe/c/maize/data/data_conversion/cp_images_by_rowplant.perl

# a script to take a crop, list of rows, and a date, and copy all images to /athe/c/maize/experiments/time_course_13r/images_by_row_num,
# putting each image in its row directory and date subdirectory, and in the
# eheu_dump subdirectory, and renaming the images so that when they are 
# dumped into eheu, they will sort by rowplant.


# for the list of rows, get the subdirectories that have numbers in this directory

# for the image data, use demeter/data/image.pl


# call:  perl ./convert_data CROP DUMPDAY


use lib qw(../../label_making/);
use Typesetting::DefaultOrgztn;



$crop = $ARGV[0];
$dump_day = $ARGV[1];

$crop =~ tr/A-Z/a-z/;

open img_data, "/athe/c/maize/data/palm/raw_data_from_palms/$crop/zeta/$dump_day/done.image.csv";

$crop_upper = $crop;
$crop_upper =~ tr/a-z/A-Z/; # used as part of the regular expression, while $crop is used for directory calls

while ($line = <img_data>) {

	($rowplant,$image,$camera,$month,$day) = $line =~ /$crop_upper\d{4}\:0{2,3}(\d{4,5}),(\d{4}),[\w\",-\s]+,(bet|aleph),[\w\",-\s]+,0?(\d{1,2})\/0?(\d{1,2})\/\d{4}/;

	system("/athe/c/maize/image_processing/code/conversion/dcraw/dcraw -e -c -w /athe/c/maize/images/$crop/$camera/$day.$month/DSC_$image.NEF > '/athe/c/maize/experiments/time_course_13r/eheu_dump/$rowplant\_$day\.$month\_$image.jpg'");
} 
