#!/usr/local/bin/perl

# this is ../c/maize/data/data_conversion/convert_planted_data.perl

# a quick script to convert the planted menu data to planted/8
#
# Kazic, 5.6.2010



# modified for iphone data collection
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


my $file = $demeter_dir . "planted.pl";
my @lines;
my $out;


# fix header for output file!
#
# Kazic, 21.7.2018

print "fix output file header: ../../data$input_file\n";




# read the file into an array so it's easy to check the first line's self-identification

open my $in, '<', $input_file or die "sorry, can't open input file $input_file\n";
(@lines) = grep { $_ !~ /^,/ } <$in>;



my $now = `date`;
chomp($now);


if ( $lines[0] =~ /planted/ ) {


	if ( $flag eq 'go' ) {
                open $out, '>>', $out_file or die "can't open $out_file\n";
		print $out "\n\n\n\n% data added from ../../data$input_file on $now\n% by data/data_conversion/convert_planted_data.perl\n% called from data/data_conversion/convert_data.perl\n\n";
	        }


        for ( my $i = 1; $i <= $#lines; $i++ ) {


                my ($packet,$row,$datetime,$ft,$observer) = $lines[$i] =~ /\"?(${packet_re})\"?,\"?(${row_re})\"?,\"?(${datetime_re})\"?,\"?(${ft_re})\"?,\"?(${observer_re})\"?,*/;
		
#                print "($packet,$row,$ft,$observer,$datetime)\n";
		
                
		
		
                my ($date,$time) = &convert_datetime($datetime);
		
		
                my ($crop) = &grab_crop_from_file($input_file);
			
			
# for now, assume all soil levels are `full', 
# since I'm not doing anything in the greenhouse
#
# Kazic, 13.5.2011
			
                if ( $flag eq 'test' ) { print "planted($row,$packet,$ft,$observer,$date,$time,full,'$crop').\n"; }
                elsif ( $flag eq 'q' ) { }  # do nothing
                elsif ( $flag eq 'go' ) { print $out "planted($row,$packet,$ft,$observer,$date,$time,full,'$crop').\n"; }

	        }


# thanks, Gabor!
# https://perlmaven.com/how-to-exit-from-perl-script
	
	if ( ( $flag eq 'test' ) || ( $flag eq 'q' ) ) { exit 42; }
        }
