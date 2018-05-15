#!/opt/perl5/perls/perl-5.26.1/bin/perl

# this is ../c/maize/data/data_conversion/convert_cross_data.perl

# a quick script to convert the cross menu's data to cross/8


# for now I have stuffed all the subroutines in the Typesetting subdirectory.  The 
# first line ("lib") references that easily
#
#
# Modified for ipad data collection; tested and ready to go.
#
# Kazic, 7.4.2012


# converted to run in perl 5.26
#
# Kazic, 20.4.2018


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


if ( ( $lines[0] =~ /cross/ ) && ( $lines[0] !~ /cross\_prep/ ) ) {

	if ( $flag eq 'go' ) {
                open $out, '>>', $out_file or die "can't open $out_file\n";
                print $out "\n\n\n\n% data added from ../../data$input_file on $now\n% by data/data_conversion/convert_cross_data.perl\n% called from data/data_conversion/convert_data.perl\n\n";

	        }

        for ( my $i = 1; $i <= $#lines; $i++ ) {	

#                print $lines[$i];


# modified regular expression to reflect data collection on iphone
#
# Kazic, 19.5.2017	    
	    
#                ($ma,$pa,$datetime,$ear1,$ear2,$repeat,$bee,$pilot) = $lines[$i] =~ /\"?(${num_gtype_re})\"?,\"?(${num_gtype_re})\"?,\"?(${datetime_re})\"?,\"?(${num_tf_re})\"?,\"?(${num_tf_re})\"?,\"?(${num_tf_re})\"?,\"?(${observer_re})\"?,\"?(${observer_re})\"?,\"?(${datetime_re})\"?,/;

	        if ( ( $lines[$i] !~ /^,/ ) && ( $lines[$i] !~ /^#/ ) ) {
                        my ($ma,$pa,$datetime,$ear1,$ear2,$repeat,$bee,$pilot) = $lines[$i] =~ /\"?(${num_gtype_re})\"?,\"?(${num_gtype_re})\"?,\"?(${datetime_re})\"?,\"?(${num_tf_re})\"?,\"?(${num_tf_re})\"?,\"?(${num_tf_re})\"?,\"?(${observer_re})\"?,\"?(${observer_re})\"?,*/;	    
			($ear1,$ear2,$repeat) = &convert_num_tfs($ear1,$ear2,$repeat);
                        my $ear;
			
			
#               #        print "$ma,$pa,$ear1,$ear2,$repeat,$bee,$pilot,$datetime\n";
			
			
                        ($ear1) = &check_false($ear1);
                        ($ear2) = &check_false($ear2);
                        $repeat =~ tr/[A-Z]/[a-z]/;
			
			
                        if ( ( $ear1 !~ /\"\"/ ) && ( $ear2 =~ /\"\"/ ) ) { $ear = "ear(1)"; }
                        elsif ( ( $ear1 =~ /\"\"/ ) && ( $ear2 !~ /\"\"/ ) ) { $ear = "ear(2)"; }
                        else {
                                print "Warning! ambiguous ear for $ma x $pa, assuming ear 1 used!\n";
				$ear = "ear(1)";
			        }
			
			
			
			
                        my ($date,$time) = &convert_datetime($datetime);
			
                        if ( $flag eq 'test' ) { print "cross('$ma','$pa',$ear,$repeat,$bee,$pilot,$date,$time).\n"; }
                        elsif ( $flag eq 'q' ) { }  # do nothing
			elsif ( $flag eq 'go' ) { print $out "cross('$ma','$pa',$ear,$repeat,$bee,$pilot,$date,$time).\n"; }
	                }
	        }

	
# thanks, Gabor!
# https://perlmaven.com/how-to-exit-from-perl-script
	
	if ( ( $flag eq 'test' ) || ( $flag eq 'q' ) ) { exit 42; }
        }
