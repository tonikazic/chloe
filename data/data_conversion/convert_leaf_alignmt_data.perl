#!/usr/bin/perl

# this is maize/data/data_conversion/convert_leaf_alignmt_data.perl

# a quick script to convert the leaf alignment menu's data to leaf_alignmt/6


# for now I have stuffed all the subroutines in the Typesetting subdirectory.  The 
# first line ("lib") references that easily

# modified for ipad data collection; tested and ready to go
#
# Kazic, 26.2.2013


# called from convert_data.perl, so input and output files are passed on the command line


use lib qw(../../label_making/);
use Typesetting::DefaultOrgztn;
use Typesetting::MaizeRegEx;
use Typesetting::NoteExpsn;
use Typesetting::ConvertPalmData;



$input_file = $ARGV[0];
$out_file = $ARGV[1];




# read the file into an array so it's easy to check the first line's self-identification

open(IN,"<$input_file") || die "sorry, can't open input file $input_file\n";
(@lines) = <IN>;
close(IN);


$now = `date`;
chomp($now);


if ( $lines[0] =~ /leaf_alignmt/ ) {

        open(OUT,">>$out_file");
        $input_file =~ s/\.\.//;
        print OUT "\n\n\n\n% data added from ../../data$input_file on $now\n% by data/data_conversion/convert_leaf_alignmt_data.perl\n% called from data/data_conversion/convert_data.perl\n\n";


# strangely, Perl reads the first line of the file into $array[0], but then the last line is
# placed in $array[1].   This can be demonstrated by looking at the array's contents:
#
# for ( $j = 0 ; $j <= $#lines; $j++ ) { print "$j: $lines[$j]\n"; }
#
# So work backwards through the array to get the data in their input
# order.
#
# Kazic, 6.9.09

# probably eliminate marker_leaf in data collection
#
# Kazic, 3.5.2018
	

        for ( $i = $#lines; $i >= 1;  $i-- ) {
                ($plant,$b0_leaf,$datetime,$observer,$marker_leaf) = $lines[$i] =~ /\"?(${num_gtype_re})\"?,\"?(${rel_leaf_num_re})\"?,\"?(${datetime_re})\"?,\"?(${observer_re})\"?,\"?(${rel_leaf_num_re})\"?,*/;



#                print "$plant,$b0_leaf,$marker_leaf,$observer,$datetime\n";




                ($date,$time) = &convert_datetime($datetime);


#                print "leaf_alignmt('$plant',b0_leaf('$b0_leaf'),marker_leaf('$marker_leaf'),$observer,$date,$time).\n";

                print OUT "leaf_alignmt('$plant',b0_leaf('$b0_leaf'),marker_leaf('$marker_leaf'),$observer,$date,$time).\n";

                }

        close(OUT);

        }