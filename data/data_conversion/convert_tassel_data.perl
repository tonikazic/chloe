#!/opt/perl5/perls/perl-5.26.1/bin/perl

# this is ../c/maize/data/data_conversion/convert_tassel_data.perl

# a quick script to convert the tassel menu's data to tassel/5


# for now I have stuffed all the subroutines in the Typesetting subdirectory.  The 
# first line ("lib") references that easily

# modified for ipad data collection; tested and ready to go
#
# Kazic, 8.4.2012



# converted to run in perl 5.26
#
# Kazic, 29.4.2018


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


if ( $lines[0] =~ /tassel/ ) {

	if ( $flag eq 'go' ) {
                open $out, '>>', $out_file or die "can't open $out_file\n";
                print $out "\n\n\n\n% data added from ../../data$input_file on $now\n% by data/data_conversion/convert_cross_data.perl\n% called from data/data_conversion/convert_data.perl\n\n";

	        }

        for ( my $i = 1; $i <= $#lines; $i++ ) {    

	        if ( ( $lines[$i] !~ /^,/ ) && ( $lines[$i] !~ /^#/ ) ) {
                        my ($plant,$center_spike,$base_branches,$mid_branches,$do_now,$exhausted,$poor,$datetime,$observer) = $lines[$i] =~ /\"?(${num_gtype_re})\"?,\"?(${num_tf_re})\"?,\"?(${num_tf_re})\"?,\"?(${num_tf_re})\"?,\"?(${num_tf_re})\"?,\"?(${num_tf_re})\"?,\"?(${num_tf_re})\"?,\"?(${datetime_re})\"?,\"?(${observer_re})\"?,/;

		        ($center_spike,$base_branches,$mid_branches,$do_now,$exhausted,$poor) = &convert_num_tfs($center_spike,$base_branches,$mid_branches,$do_now,$exhausted,$poor);

#                print "$plant,$center_spike,$base_branches,$mid_branches,$do_now,$exhausted,$poor,$observer,$datetime\n";


                        ($center_spike) = &check_false($center_spike);
                        ($base_branches) = &check_false($base_branches);
                        ($mid_branches) = &check_false($mid_branches);
                        ($do_now) = &check_false($do_now);
                        ($exhausted) = &check_false($exhausted);
                        ($poor) = &check_false($poor);
			
			
			my $state;
			
                        if ( ( $center_spike !~ /\"\"/ ) 
                             && ( $base_branches =~ /\"\"/ )
                             && ( $mid_branches =~ /\"\"/ )
                             && ( $do_now =~ /\"\"/ )
                             && ( $exhausted =~ /\"\"/ )
                             && ( $poor =~ /\"\"/ ) ) { $state = "center_spike"; }
			
                        elsif ( ( $center_spike =~ /\"\"/ ) 
                             && ( $base_branches !~ /\"\"/ )
                             && ( $mid_branches =~ /\"\"/ )
                             && ( $do_now =~ /\"\"/ )
                             && ( $exhausted =~ /\"\"/ ) 
                             && ( $poor =~ /\"\"/ ) ) { $state = "base_branches"; }
			
			
                        elsif ( ( $center_spike =~ /\"\"/ ) 
                             && ( $base_branches =~ /\"\"/ )
                             && ( $mid_branches !~ /\"\"/ )
                             && ( $do_now =~ /\"\"/ )
                             && ( $exhausted =~ /\"\"/ )
                             && ( $poor =~ /\"\"/ ) ) { $state = "mid_branches"; }
			
			
                        elsif ( ( $center_spike =~ /\"\"/ ) 
                             && ( $base_branches =~ /\"\"/ )
                             && ( $mid_branches =~ /\"\"/ )
                             && ( $do_now !~ /\"\"/ )
                             && ( $exhausted =~ /\"\"/ )
                             && ( $poor =~ /\"\"/ ) ) { $state = "do_now"; }
			
			
                        elsif ( ( $center_spike =~ /\"\"/ ) 
                             && ( $base_branches =~ /\"\"/ )
                             && ( $mid_branches =~ /\"\"/ )
                             && ( $do_now =~ /\"\"/ )
                             && ( $exhausted !~ /\"\"/ )
                             && ( $poor =~ /\"\"/ ) ) { $state = "exhausted"; }
			
                        elsif ( ( $center_spike =~ /\"\"/ ) 
                             && ( $base_branches =~ /\"\"/ )
                             && ( $mid_branches =~ /\"\"/ )
                             && ( $do_now =~ /\"\"/ )
                             && ( $exhausted =~ /\"\"/ )
                             && ( $poor !~ /\"\"/ ) ) { $state = "poor"; }
			
			
			
                        my ($date,$time) = &convert_datetime($datetime);

                        if ( $flag eq 'test' ) { print "tassel('$plant',[$state],$observer,$date,$time).\n"; }
                        elsif ( $flag eq 'q' ) { }  # do nothing
			elsif ( $flag eq 'go' ) { print $out "tassel('$plant',[$state],$observer,$date,$time).\n"; }
	                }
                }

	
# thanks, Gabor!
# https://perlmaven.com/how-to-exit-from-perl-script
	
	if ( ( $flag eq 'test' ) || ( $flag eq 'q' ) ) { exit 42; }
        }