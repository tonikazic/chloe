#!/usr/bin/perl

# this is maize/data/data_conversion/convert_first_extra_tag_data.perl

# a quick script to convert the first_extra_tag menu data to first_extra_tag/4
#
# Kazic, 5.6.2010


# for now I have stuffed all the subroutines in the Typesetting subdirectory.  The 
# first line ("lib") references that easily

# modified for ipad data collection and altered first_extra_tag/7; tested and ready to go
#
# Kazic, 25.4.2012




use lib qw(../../label_making/);
use Typesetting::DefaultOrgztn;
use Typesetting::OrganizeData;
use Typesetting::MaizeRegEx;
use Typesetting::NoteExpsn;
use Typesetting::ConvertPalmData;




$input_file = $ARGV[0];
$out_file = $ARGV[1];
$file = $demeter_dir . "first_extra_tag.pl";








# read the file into an array so it's easy to check the first line's self-identification

open(IN,"<$input_file") || die "sorry, can't open input file $input_file\n";
(@lines) = <IN>;
close(IN);


$now = `date`;
chomp($now);


if ( $lines[0] =~ /first_extra_tag/ ) {

        open(OUT,">>$out_file");
        $input_file =~ s/\.\.//;
        print OUT "\n\n\n\n% data added from ../../data$input_file on $now\n% by data/data_conversion/convert_first_extra_tag_data.perl\n% called from data/data_conversion/convert_data.perl\n\n";


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
                ($extra_plant,$observer,$datetime) = $lines[$i] =~ /\"?(${num_gtype_re})\"?,\"?(${observer_re})\"?,\"?(${datetime_re})\"?,/;

#                print "($extra_plant,$observer,$datetime)\n";

                
                ($crop,$row,$plant) = $extra_plant =~ /(${crop_re})\d{3,4}\:.{0,1}(${padded_row_re})(${pplant_re})/;

                $row = 'r' . $row;

                ($date,$time) = &convert_datetime($datetime);


#                print "first_extra_tag($row,$plant,'$crop','$extra_plant',$observer,$date,$time).\n";
                print OUT "first_extra_tag($row,$plant,'$crop','$extra_plant',$observer,$date,$time).\n";

                }

        close(OUT);

        }
