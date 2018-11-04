#!/opt/perl5/perls/perl-5.26.1/bin/perl


# this is ../c/maize/data/data_conversion/convert_image_data.perl

# a quick script to convert the image menu's data to image/11


# for now I have stuffed all the subroutines in the Typesetting subdirectory.  The 
# first line ("lib") references that easily



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
use TypesettingMisc;



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


if ( $lines[0] =~ /image/ ) {


	if ( $flag eq 'go' ) {
                open $out, '>>', $out_file or die "can't open $out_file\n";
                print $out "\n\n\n\n% data added from ../../$input_file on $now\n% by data/data_conversion/convert_image_data.perl\n% called from data/data_conversion/convert_data.perl\n\n";
	        }


        for ( my $i = 1; $i <= $#lines; $i++ ) {	
#                print $lines[$i];


# made quotes around image number optional to accommodate ipad numbers'
# number format
#
# Kazic, 29.8.2011
#
#
#
# modified image regular expression to 1--4 digits.
#
# Kazic, 22.4.2018

	    
                if ( ( $lines[$i] !~ /^,/ ) && ( $lines[$i] !~ /^#/ ) ) { 

                        my ($plantID,$preimage,$rel_leaf_num,$section,$datetime,$observer,$camera,$conditions,$abs_leaf_num) = $lines[$i] =~ /\"?(${num_gtype_re})\"?,\"?(${image_re})\"?,\"?(${rel_leaf_num_re})\"?,\"?(${section_re})\"?,\"?(${datetime_re})\"?,\"?(${observer_re})\"?,\"?(${camera_re})\"?,\"?(${conditions_re})\"?,\"?(${abs_leaf_num_re})\"?,*/;


#                        print "($plantID,$preimage,$rel_leaf_num,$section,$datetime,$observer,$camera,$conditions,$abs_leaf_num)\n";

                        my ($image) = &pad_row($preimage,4);
                        my ($leaf) = &convert_leaves($abs_leaf_num,$rel_leaf_num);
                        my ($date,$time) = &convert_datetime($datetime);
			
#			print "$plantID,$rel_leaf_num,$abs_leaf_num,$leaf\n";
			
                        if ( $flag eq 'test' ) { print "image('$plantID',$image,$leaf,'$section',$camera,'$conditions',$observer,$date,$time).\n"; }
                        elsif ( $flag eq 'q' ) { }  # do nothing
			elsif ( $flag eq 'go' ) { print $out "image('$plantID',$image,$leaf,'$section',$camera,'$conditions',$observer,$date,$time).\n"; }
                        }
	       }


# thanks, Gabor!
# https://perlmaven.com/how-to-exit-from-perl-script

	if ( ( $flag eq 'test' ) || ( $flag eq 'q' ) ) { exit 42; }
        }