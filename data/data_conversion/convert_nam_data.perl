#!/usr/bin/perl

# this is maize/data/data_conversion/convert_nam_data.perl

# a quick script to convert the nam menu's data to nam/11


# for now I have stuffed all the subroutines in the Typesetting subdirectory.  The 
# first line ("lib") references that easily


# call was perl ./convert_nam_data.perl CROP PALM DUMPDAY
#
# now called from convert_data.perl, so input and output files are passed on the command line


use lib qw(../../label_making/);
use Typesetting::DefaultOrgztn;
use Typesetting::MaizeRegEx;
use Typesetting::NoteExpsn;
use Typesetting::ConvertPalmData;


# $crop = $ARGV[0];
# $palm = $ARGV[1];
# $dump_day = $ARGV[2];
#
# $dump_dir = $raw_data_dir . "/" . $crop . "/" . $palm . "/" . $dump_day;
# $input_file = "$dump_dir/S31_data.txt";
# $out_file = $demeter_dir . "nam.pl";



$input_file = $ARGV[0];
$out_file = $ARGV[1];




# read the file into an array so it's easy to check the first line's self-identification

open(IN,"<$input_file") || die "sorry, can't open input file $input_file\n";
(@lines) = <IN>;
close(IN);


$now = `date`;
chomp($now);


if ( $lines[0] =~ /nam/ ) {

        open(OUT,">>$out_file");
        $input_file =~ s/\.\.//;
        print OUT "\n\n\n\n% data added from ../../data$input_file on $now\n% by data/data_conversion/convert_nam_data.perl\n% called from data/data_conversion/convert_data.perl\n\n";


# strangely, Perl reads the first line of the file into $array[0], but then the last line is
# placed in $array[1].   This can be demonstrated by looking at the array's contents:
#
# for ( $j = 0 ; $j <= $#lines; $j++ ) { print "$j: $lines[$j]\n"; }
#
# So work backwards through the array to get the data in their input
# order.
#
# Kazic, 6.9.09

        for ( $i = $#lines; $i >= 1;  $i-- ) {
                ($nam_row,$plants,$mutants,$note,$photo,$image_range,$camera,$observer,$datetime) = $lines[$i] =~ /\"(\d{7})\",\"(\d{1,2})\",\"(\d{1,2})\",\"(${note_re})\",\"(\d*)\",\"(\d*\s*\d*)\",\"(${camera_re})\",\"(${observer_re})\",\"(${datetime_re})\",/;

#                print "($nam_row,$plants,$mutants,$note,$photo,$image_range,$camera,$observer,$datetime)\n";


                ($full_note) = &expand_note($note);
                ($photo_plant) = &convert_photo_plant($photo);
                ($image_start,$image_end) = &convert_image_range($image_range);
                ($date,$time) = &convert_datetime($datetime);


                print OUT "nam(row($nam_row),num_plants($plants),num_les($mutants),$full_note,$photo_plant,$image_start,$image_end,$camera,$observer,$date,$time).\n";

                }

        close(OUT);

        }