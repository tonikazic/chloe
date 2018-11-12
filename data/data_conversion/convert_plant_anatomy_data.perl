#!/opt/perl5/perls/perl-5.26.1/bin/perl

# this is ../c/maize/data/data_conversion/convert_plant_anatomy_data.perl

# convert the plant_anatomy menu's data to plant_anatomy/8
#
# Not all data will be collected, depending on their purpose.  Mainly plant
# heights are taken, measuring from the ground vertically to the top of the
# tassel.  That location is preferable to the node at the base of the
# tassel, which will be much harder to discern in the 3D reconstructions.
# The flag leaf would be good if not ripped off and not tiny.
#
# Kazic, 12.11.2018



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



if ( $lines[0] =~ /plant_anatomy/ ) {

	if ( $flag eq 'go' ) {
                open $out, '>>', $out_file or die "can't open $out_file\n";
                print $out "\n\n\n\n% data added from ../../$input_file on $now\n% by data/data_conversion/convert_plant_anatomy_data.perl\n% called from data/data_conversion/convert_data.perl\n\n";
	        }


        for ( my $i = 1; $i <= $#lines; $i++ ) {

                if ( ( $lines[$i] !~ /^,/ ) && ( $lines[$i] !~ /^#/ ) ) { 


# warning! field semantics can vary with purpose, so regular expression may need alteration!
#
# Kazic, 15.9.2010

	    
# modified to use for height msemnts in cm
# really should modify this to tell it what's in each field 
# and populate anonymous variables accordingly
# can get that information from reading the header line
#
# Kazic, 25.9.2015

#                ($plant,$first_ear,$addntl_leaves,$observer,$datetime) = $lines[$i] =~ /\"?(${num_gtype_re})\"?,\"?(${abs_leaf_num_re})\"?,\"?(${abs_leaf_num_re})\"?,\"?(${observer_re})\"?,\"?(${datetime_re})\"?,/;


# 17r and later, menu is now
# ($plant,$height,$datetime,$observer,$num_leaves,$first_ear_leaf,$num_tillers)
#
# Kazic, 3.5.2018
		    
                        my ($plant,$height,$datetime,$observer) = $lines[$i] =~ /\"?(${num_gtype_re})\"?,\"?(${height_re})\"?,\"?(${datetime_re})\"?,\"?(${observer_re})\"?,*/;


#			print "($plant,$height,$datetime,$observer)\n";


			
# hmmm, tape measures usually are in inches, not centimeters, so
# convert here
#
# Kazic, 26.4.2018

			$height = $height * 2.54;
			

#                print "$plant,$first_ear,$addntl_leaves,$observer,$datetime\n";

#		$num_leaves = $first_ear + $addntl_leaves;

                        my ($date,$time) = &convert_datetime($datetime);


                        if ( $flag eq 'test' ) { print "plant_anatomy('$plant',cm($height),_,_,_,$observer,$date,$time).\n"; }
                        elsif ( $flag eq 'q' ) { }  # do nothing
			elsif ( $flag eq 'go' ) { print $out "plant_anatomy('$plant',cm($height),_,_,_,$observer,$date,$time).\n"; }
		        }
	        }


# thanks, Gabor!
# https://perlmaven.com/how-to-exit-from-perl-script

	if ( ( $flag eq 'test' ) || ( $flag eq 'q' ) ) { exit 42; }
        }
