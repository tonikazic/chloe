#!/usr/local/bin/perl

# this is ../c/maize/data/data_conversion/convert_scoring_date_data.perl

# a quick script to convert the scoring dates for each row to scoring_date/5;
# these facts will be used by demeter to pre-populate the mutant table, letting
# us just mark the differences from the defaults
#
# Kazic, 15.8.2020



# for now I have stuffed all the subroutines in the Typesetting subdirectory.  The 
# first line ("lib") references that easily


# called from convert_data.perl, so input and output files are passed on the command line






use strict;
use warnings;


use lib '../../label_making/Typesetting';
use DefaultOrgztn;
use MaizeRegEx;
use NoteExpsn;
use ConvertPalmData;



my $input_file = $ARGV[0];
my $out_file = $ARGV[1];
my $flag = $ARGV[2];

my $local_dir = getcwd;
my ($dir) = &adjust_paths($crop,$local_dir);


my $out;
my @lines;



# fix header for output file!
#
# Kazic, 21.7.2018

print "fix output file header: ../../$input_file\n";



# read the file into an array so it's easy to check the first line's self-identification

open my $in, '<', $input_file or die "sorry, can't open input file $input_file\n";
(@lines) = grep { $_ !~ /^,/ } <$in>;



my $now = `date`;
chomp($now);


if ( $lines[0] =~ /scoring_date/ ) {

	if ( $flag eq 'go' ) {
                open $out, '>>', $out_file or die "can't open $out_file\n";
                print $out "\n\n\n\n% data added from ../../$input_file on $now\n% by data/data_conversion/convert_scoring_date_data.perl\n% called from data/data_conversion/convert_data.perl\n\n";
}

	
        my ($crop) = &grab_crop_from_file($input_file);
	print "$crop\n";

	
	
        for ( my $i = 1; $i <= $#lines; $i++ ) {



                my ($row,$abbrv_date,$phe,$observer) = $lines[$i] =~ /\"?(${row_re})\"?,\"?(${abbrv_date_re})\"?,\"?(${cl_re})\"?,\"?(${observer_re})\"?,*/;		

#                print "($row,$abbrv_date,$phe,$observer)\n";

		$row = lc $row;		
		
                my ($date,$time) = &convert_abbrv_date($abbrv_date,$crop);
		
		
                if ( $flag eq 'test' ) { print "scoring_date($row,$phe,$observer,$date,$time,'$crop').\n"; }
                elsif ( $flag eq 'q' ) { }  # do nothing
                elsif ( $flag eq 'go' ) {print $out "scoring_date($row,$phe,$observer,$date,$time,'$crop').\n"; }
	        }

	
# thanks, Gabor!
# https://perlmaven.com/how-to-exit-from-perl-script

        if ( ( $flag eq 'test' ) || ( $flag eq 'q' ) ) { exit 42; }
        }
