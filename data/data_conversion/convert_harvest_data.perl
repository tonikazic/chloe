#!/opt/perl5/perls/perl-5.26.1/bin/perl

# this is ..c/maize/data/data_conversion/convert_harvest_data.perl

# a quick script to convert the harvest menu's data to harvest/7


# for now I have stuffed all the subroutines in the Typesetting subdirectory.  The 
# first line ("lib") references that easily

# further revised to accommodate ipad data collection; tested and ready to go
#
# Kazic, 28.8.2012


# check notes in output file carefully.  Some regular expressions collide
# and generate silly notes; double quotes may linger.
#
# Kazic, 10.3.2015



# converted to run in perl 5.26
#
# Kazic, 24.4.2018


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

my $cross_file = $demeter_dir . "cross.pl";
my $out;
my %cross;
my @lines;




# form the hash of pollinations to correct males with incomplete tags

open my $crossfh, '<', $cross_file or die "sorry, can't open cross file $cross_file\n";

while (<$crossfh>) {
        if ( my ($ma,$pa) = $_ =~ /^cross\(\'(${num_gtype_re})\',\'(${num_gtype_re})\',/ ) { $cross{$ma} = $pa; }
        }






# read the file into an array so it's easy to check the first line's self-identification

open my $in, '<', $input_file or die "sorry, can't open input file $input_file\n";
(@lines) = <$in>;



my $now = `date`;
chomp($now);


if ( $lines[0] =~ /harvest/ ) {

	if ( $flag eq 'go' ) {
                open $out, '>>', $out_file or die "can't open $out_file\n";
                print $out "\n\n\n\n% data added from ../../data$input_file on $now\n% by data/data_conversion/convert_harvest_data.perl\n% called from data/data_conversion/convert_data.perl\n\n";
	        }

	
        for ( my $i = 1; $i <= $#lines; $i++ ) {

              if ( ( $lines[$i] !~ /^,/ ) && ( $lines[$i] !~ /^#/ ) ) { 
	    
# clean up here, rather than burdening data entry in field

                      $lines[$i] =~ s/,,,,/,,0,0,/g;
                      $lines[$i] =~ s/,,,/,0,0,/g;
                      $lines[$i] =~ s/,,/,0,/g;
#                      $lines[$i] =~ s/,fuzzy_cl,/,,/g;



# we simplified the menu so that $ok is now either 1 for success or 0 for failure.
# should have done it a long time ago!
#
# Kazic, 12.9.2013
#
#                ($ma_plant,$pa_plant,$ok,$failed,$fuzzy_cl,$num_cl,$fungus,$polltn_note,$observer,$datetime) = $lines[$i] =~ /\"?(${num_gtype_re})\"?,\"?(${num_gtype_re})\"?,\"?(${num_tf_re})\"?,\"?(${num_tf_re})\"?,\"?(${fuzzy_cl_re})\"?,\"?(${cl_re})\"?,\"?(${num_tf_re})\"?,\"?(${note_re})\"?,\"?(${observer_re})\"?,\"?(${datetime_re})\"?,/;
#
#                 ($ok,$failed) = &convert_num_tfs($ok,$failed);


                      my ($ma_plant,$pa_plant,$ok,$fuzzy_cl,$num_cl,$fungus,$polltn_note,$datetime,$observer) = $lines[$i] =~ /\"?(${num_gtype_re})\"?,\"?(${num_gtype_re})\"?,\"?(${num_tf_re})\"?,\"?(${fuzzy_cl_re})\"?,\"?(${cl_re})\"?,\"?(${num_tf_re})\"?,\"?(${note_re})\"?,\"?(${datetime_re})\"?,\"?(${observer_re})\"?,*/;
	

#                        print "($ma_plant,$pa_plant,$ok,$fuzzy_cl,$num_cl,$fungus,$polltn_note,$datetime,$observer)\n";
	        
                      ($ok) = &convert_num_tfs($ok);
		        

                      my ($final_num_cl) = &convert_cl($ma_plant,$fuzzy_cl,$num_cl);
                      my ($cl) = &string_cl($final_num_cl);
		        
                      ($fungus) = &convert_num_tfs($fungus);
                      ($fungus) = &convert_fungus($fungus);
 
#                print "($ma_plant,$pa_plant,$ok,$fuzzy_cl,$num_cl,$fungus,$polltn_note,$observer,$datetime)\n";

                
                      if ( $pa_plant =~ /0000:/ ) { ($pa_plant) = &fill_out_daddy($ma_plant,$pa_plant,\%cross); }

		        
                      my ($int_note) = &expand_note($polltn_note);
                      my ($full_note) = &concat_notes($int_note,$cl,$fungus);

#                ($success) = &convert_pollination_results($ok,$failed);
                      my ($success) = &convert_pollination_results2($ok);
		        
                      my ($date,$time) = &convert_datetime($datetime);
		        

                      if ( $flag eq 'test' ) { print "harvest('$ma_plant','$pa_plant',$success,$full_note,$observer,$date,$time).\n"; }
                      elsif ( $flag eq 'q' ) { }  # do nothing
		      elsif ( $flag eq 'go' ) { print $out "harvest('$ma_plant','$pa_plant',$success,$full_note,$observer,$date,$time).\n"; }
                      }
	      }


# thanks, Gabor!
# https://perlmaven.com/how-to-exit-from-perl-script

	if ( ( $flag eq 'test' ) || ( $flag eq 'q' ) ) { exit 42; }
        }
