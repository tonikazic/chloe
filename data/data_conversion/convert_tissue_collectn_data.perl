#!/usr/local/bin/perl

# this is ../c/maize/data/data_conversion/convert_tissue_sampling_data.perl

# a quick script to convert the tissue_sampling menu's data to sample/7


# for now I have stuffed all the subroutines in the Typesetting subdirectory.  The 
# first line ("lib") references that easily

# modified for ipad data collection; tested and ready to go
#
# Kazic, 26.2.2013


# converted to run in perl 5.26
#
# Kazic, 22.4.2018




# called from convert_data.perl, so input and output files are passed on the command line



use strict;
use warnings;


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


if ( $lines[0] =~ /tissue/ ) {
	
	if ( $flag eq 'go' ) {
                open $out, '>>', $out_file or die "can't open $out_file\n";
                print $out "\n\n\n\n% data added from ../../$input_file on $now\n% by data/data_conversion/convert_tissue_collectn_data.perl\n% called from data/data_conversion/convert_data.perl\n\n";
	        }

	
        for ( my $i = 1; $i <= $#lines; $i++ ) {
	    
	        if ( ( $lines[$i] !~ /^,/ ) && ( $lines[$i] !~ /^#/ ) ) { 
	    

		    
                        my ($plant,$sample,$datetime,$observer) = $lines[$i] =~ /\"?(${num_gtype_re})\"?,\"?(${sample_re})\"?,\"?(${datetime_re})\"?,\"?(${observer_re})\"?,*/;
			
			
                        $sample =~ s/E/e/g;

#                print "$plant,$sample,$observer,$datetime\n";


                        my ($date,$time) = &convert_datetime($datetime);


                        if ( $flag eq 'test' ) { print "sample('$plant',$sample,any_leaf,tissue,$observer,$date,$time).\n"; }
                        elsif ( $flag eq 'q' ) { }  # do nothing
			elsif ( $flag eq 'go' ) { print $out "sample('$plant',$sample,any_leaf,tissue,$observer,$date,$time).\n"; }
                        }
                }

			
# thanks, Gabor!
# https://perlmaven.com/how-to-exit-from-perl-script

	if ( ( $flag eq 'test' ) || ( $flag eq 'q' ) ) { exit 42; }
        }
