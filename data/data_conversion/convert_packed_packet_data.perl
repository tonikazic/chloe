#!/opt/perl5/perls/perl-5.26.1/bin/perl

# this is ../c/maize/data/data_conversion/convert_packed_packet_data.perl

# a quick script to convert the packed_packet menu data to packed_packet/7
#
# Kazic, 5.6.2010


# for now I have stuffed all the subroutines in the Typesetting subdirectory.  The 
# first line ("lib") references that easily

# modified for iphone data collection; tested
#
# Terrana and Kazic, 3.7.2017


# converted to run in perl 5.26
#
# Kazic, 20.4.2018


use strict;
use warnings;


use lib '../../label_making/Typesetting/';
use DefaultOrgztn;
use OrganizeData;
use MaizeRegEx;
use NoteExpsn;
use ConvertPalmData;




my $input_file = $ARGV[0];
my $out_file = $ARGV[1];
my $flag = $ARGV[2];

my $file = $demeter_dir . "packed_packet.pl";
my @lines;







# read the file into an array so it's easy to check the first line's self-identification

open my $in, '<', $input_file or die "sorry, can't open input file $input_file\n";
(@lines) = <$in>;



my $now = `date`;
chomp($now);


if ( $lines[0] =~ /packed_packet/ ) {


	if ( $flag eq 'go' ) {    
                open my $out, '>>', $out_file or die "can't open $out_file\n";
		print $out "\n\n\n\n% data added from ../../data$input_file on $now\n% by data/data_conversion/convert_packed_packet_data.perl\n% called from data/data_conversion/convert_data.perl\n\n";
	        }


        for ( my $i = 1; $i <= $#lines; $i++ ) {

	        if ( $_ !~ /^,/ ) {


# revised to reflect order of fields on iphone
#
# Kazic, 2.6.2017	
		
                        my ($packet,$ma_plant,$pa_plant,$num_cl,$datetime,$observer) = $lines[$i] =~ /\"?(${packet_re})\"?,\"?(${num_gtype_re})\"?,\"?(${num_gtype_re})\"?,\"?(${cl_re})\"?,\"?(${datetime_re})\"?,\"?(${observer_re})\"?,*/;
			
#               #        print "($packet,$ma_plant,$pa_plant,$num_cl,$datetime,$observer)\n";
			
                        
			
			
                        my ($date,$time) = &convert_datetime($datetime);
			
#		#	print "$datetime::$date::$time\n";
			
                        if ( $flag eq 'test' ) { print "packed_packet($packet,'$ma_plant','$pa_plant',$num_cl,$observer,$date,$time).\n"; }
                        elsif ( $flag eq 'q' ) { }  # do nothing
                        elsif ( $flag eq 'go' ) { print $out "packed_packet($packet,'$ma_plant','$pa_plant',$num_cl,$observer,$date,$time).\n"; }
			
                        }
	        }

	
# thanks, Gabor!
# https://perlmaven.com/how-to-exit-from-perl-script
	
	if ( ( $flag eq 'test' ) || ( $flag eq 'q' ) ) { exit 42; }

        }