#!/usr/local/bin/perl

# this is ../c/maize/data/data_conversion/convert_leaf_alignmt_data.perl

# convert the leaf alignment menu's data to leaf_alignmt/6
#
# assumes these data are collected after reproductive organs have emerged,
# so that we know the identity of the b0_leaf (marked with a blue twist tie
# before ear and tassel have emerged).
#
# Kazic, 12.11.2018


# converted to run in perl 5.26
#
# Kazic, 12.11.2018


use strict;
use warnings;




# called from convert_data.perl, so input and output files and 
# flag are passed on the command line

use lib '../../label_making/Typesetting/';
use DefaultOrgztn;
use MaizeRegEx;
use NoteExpsn;
use ConvertPalmData;



my $input_file = $ARGV[0];
my $out_file = $ARGV[1];
my $flag = $ARGV[2];

my $out;
my @lines;




# read the file into an array so it's easy to check the first line's self-identification

open my $in, '<', $input_file or die "sorry, can't open input file $input_file\n";
(@lines) = <$in>;




my $now = `date`;
chomp($now);


if ( $lines[0] =~ /leaf_alignmt/ ) {

	if ( $flag eq 'go' ) {
                open $out, '>>', $out_file or die "can't open $out_file\n";
                print $out "\n\n\n\n% data added from ../../data$input_file on $now\n% by data/data_conversion/convert_leaf_alignmt_data.perl\n% called from data/data_conversion/convert_data.perl\n\n";
	        }

	



# eliminated marker_leaf in data collection in 15r, since we read the plant
# after reproductive organs have emerged.  If the b0_leaf is expressed
# in ear, then the marker is e0; otherwise, marker is the tassel t0.
#	
# Kazic, 12.11.2018
	

        for ( my $i = 1; $i <= $#lines;  $i++ ) {
#                my ($plant,$b0_leaf,$datetime,$observer,$marker_leaf) = $lines[$i] =~ /\"?(${num_gtype_re})\"?,\"?(${rel_leaf_num_re})\"?,\"?(${datetime_re})\"?,\"?(${observer_re})\"?,\"?(${rel_leaf_num_re})\"?,*/;


                my ($plant,$b0_leaf,$datetime,$observer) = $lines[$i] =~ /\"?(${num_gtype_re})\"?,\"?(${rel_leaf_num_re})\"?,\"?(${datetime_re})\"?,\"?(${observer_re})\"?,*/;
		
#                print "$plant,$b0_leaf,$observer,$datetime\n";

                my $marker_leaf = $b0_leaf;
		$marker_leaf =~ s/-?\d+/0/;
                my ($date,$time) = &convert_datetime($datetime);


		

                if ( $flag eq 'test' ) { print "leaf_alignmt('$plant',b0_leaf('$b0_leaf'),marker_leaf('$marker_leaf'),$observer,$date,$time).\n"; }
                elsif ( $flag eq 'q' ) { }  # do nothing
		elsif ( $flag eq 'go' ) { print $out "leaf_alignmt('$plant',b0_leaf('$b0_leaf'),marker_leaf('$marker_leaf'),$observer,$date,$time).\n"; }		
	        }





# thanks, Gabor!
# https://perlmaven.com/how-to-exit-from-perl-script
	
	if ( ( $flag eq 'test' ) || ( $flag eq 'q' ) ) { exit 42; }
        }
