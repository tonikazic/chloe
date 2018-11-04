#!/opt/perl5/perls/perl-5.26.1/bin/perl

# this is ../c/maize/data/data_conversion/convert_row_harvested_data.perl

# a quick script to convert the row_harvested menu's data to row_harvested/5



# called from convert_data.perl, so input and output files are passed on the command line
#
# Kazic, 19.9.2018



use strict;
use warnings;


use lib '../../label_making/Typesetting';
use DefaultOrgztn;
use MaizeRegEx;
use ConvertPalmData;



my $input_file = $ARGV[0];
my $out_file = $ARGV[1];
my $flag = $ARGV[2];

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


if ( $lines[0] =~ /row_harvested/ ) {

	if ( $flag eq 'go' ) {
                open $out, '>>', $out_file or die "can't open $out_file\n";
                print $out "\n\n\n\n% data added from ../../$input_file on $now\n% by data/data_conversion/convert_row_harvested_data.perl\n% called from data/data_conversion/convert_data.perl\n\n";
	        }

	
        for ( my $i = 1; $i <= $#lines; $i++ ) {


                my ($row,$datetime,$observer) = $lines[$i] =~ /\"?(${row_re})\"?,\"?(${datetime_re})\"?,\"?(${observer_re})\"?,*/;		


#                if ( $flag eq 'test' ) { print "$row,$datetime,$observer\n"; }

		
                my ($crop) = &grab_crop_from_file($input_file);
                my ($date,$time) = &convert_datetime($datetime);
		
		
                if ( $flag eq 'test' ) { print "row_harvested($row,$observer,$date,$time,'$crop').\n"; }
                elsif ( $flag eq 'q' ) { }  # do nothing
                elsif ( $flag eq 'go' ) {print $out "row_harvested($row,$observer,$date,$time,'$crop').\n"; }
	        }

	
# thanks, Gabor!
# https://perlmaven.com/how-to-exit-from-perl-script

        if ( ( $flag eq 'test' ) || ( $flag eq 'q' ) ) { exit 42; }
        }
