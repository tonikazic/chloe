#!/opt/perl5/perls/perl-5.26.1/bin/perl

# this is ../c/maize/data/data_conversion/convert_plant_fate_data.perl

# a quick script to convert the tassel menu's data to plant_fate/5


# for now I have stuffed all the subroutines in the Typesetting subdirectory.  The 
# first line ("lib") references that easily


# called from convert_data.perl, so input and output files are passed on the command line

# modified for ipad data collection; tested and ready to go
#
# Kazic, 8.4.2012



# converted to run in perl 5.26
#
# Kazic, 25.4.2018




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




if ( $lines[0] =~ /plant_fate/ ) {

	if ( $flag eq 'go' ) {
                open $out, '>>', $out_file or die "can't open $out_file\n";
                print $out "\n\n\n\n% data added from ../../data$input_file on $now\n% by data/data_conversion/convert_plant_fate_data.perl\n% called from data/data_conversion/convert_data.perl\n\n";
	        }


	
        for ( my $i = 1; $i <= $#lines; $i++ ) {

	        if ( ( $lines[$i] !~ /^,/ ) && ( $lines[$i] !~ /^#/ ) ) {
	    
                        my ($plant,$datetime,$kicked,$dead,$sacrificed,$too_slow,$observer) = $lines[$i] =~ /\"?(${num_gtype_re})\"?,\"?(${datetime_re})\"?,\"?(${num_tf_re})\"?,\"?(${num_tf_re})\"?,\"?(${num_tf_re})\"?,\"?(${num_tf_re })\"?,\"?(${observer_re})\"?,/;


#                print "$plant,$datetime,$kicked,$dead,$sacrificed,$too_slow,$observer\n";


			($kicked,$sacrificed,$dead,$too_slow) = &convert_num_tfs($kicked,$sacrificed,$dead,$too_slow);
		
                        ($kicked) = &check_false($kicked);
                        ($sacrificed) = &check_false($sacrificed);
                        ($dead) = &check_false($dead);
                        ($too_slow) = &check_false($too_slow);


#                print "$kicked,$sacrificed,$dead,$too_slow\n";

                        my $fate;
			
	                if ( ( $kicked !~ /\"\"/ ) 
	                     && ( $sacrificed =~ /\"\"/ )
                             && ( ( $dead =~ /\"\"/ ) || ( $dead =~ /true/ ) )
                             && ( $too_slow =~ /\"\"/ ) ) { $fate = "kicked_down(light)"; }
        
                        elsif ( ( $kicked =~ /\"\"/ ) 
	                     && ( $sacrificed !~ /\"\"/ )
	                     && ( $dead =~ /\"\"/ )
                             && ( $too_slow =~ /\"\"/ ) ) { $fate = "sacrificed(leaf_geometry)"; }
        
        
                        elsif ( ( $kicked =~ /\"\"/ ) 
	                     && ( $sacrificed =~ /\"\"/ )
	                     && ( $dead !~ /\"\"/ )
                             && ( $too_slow =~ /\"\"/ ) ) { $fate = "dead"; }
        
        
                        elsif ( ( $kicked =~ /\"\"/ ) 
	                     && ( $sacrificed =~ /\"\"/ )
	                     && ( $dead =~ /\"\"/ )
                             && ( $too_slow !~ /\"\"/ ) ) { $fate = "too_slow(cross)"; }
        
        
        
	                my ($date,$time) = &convert_datetime($datetime);
	
        
                        if ( $flag eq 'test' ) { print "plant_fate('$plant',$fate,$observer,$date,$time).\n"; }
                        elsif ( $flag eq 'q' ) { }  # do nothing
			elsif ( $flag eq 'go' ) { print $out "plant_fate('$plant',$fate,$observer,$date,$time).\n"; }
	                }
                }


	
# thanks, Gabor!
# https://perlmaven.com/how-to-exit-from-perl-script
	
	if ( ( $flag eq 'test' ) || ( $flag eq 'q' ) ) { exit 42; }
        }