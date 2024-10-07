#!/usr/local/bin/perl



# this is ../c/maize/crops/scripts/rewrite_rowplants_as_full_ids.perl
#
# Turns out we DON'T NEED THIS FOR 21r, SO I HAVE ABANDONED THIS FOR NOW.
#
# Kazic, 25.1.2022
#
#
#
# If we don't have plant tags, we just write down the rowplants as we collect data.
# For those files, rewrite the rowplants as the full plantIDs.
#
# This script presumes we have already generated the barcodes for all the plants, which
# reside in the ../../barcodes/CROP/ directory as .eps files.
#
# 
# call is: ./rewrite_rowplants_as_full_ids.perl CROP RELATIVE_PATH_TO_FILE
#
# where RELATIVE_PATH_TO_FILE
# is something like ../../data/palm/raw_data_from_palms/21r/zeta/22.8/22.8_tissue_collectn_FINAL.csv
#
# Kazic, 25.1.2022


# this part to the =pod works
#
# Kazic, 25.1.2022


use strict;
use warnings;

use Cwd 'getcwd';


use lib '../../label_making/Typesetting/';
use DefaultOrgztn;
use MaizeRegEx;



# our $crop = $ARGV[0]; in DefaultOrgztn
my $crop_str = uc($crop);

my $file = $ARGV[1];

my $local_dir = getcwd;
my @dummy = &adjust_paths($crop,$local_dir);
my $barcodes_dir = $dummy[2];



print " cs: $crop_str\n ld: $local_dir\n bd: $barcodes_dir\n f: $file\n\n";

opendir my $bdh, $barcodes_dir or die "can't open the barcode directory $barcodes_dir\n";
my @plantIDs = grep { $_ =~ /$crop_str/ && $_ =~ /\:/ && $_ =~ s/\.eps//g } readdir $bdh;
closedir $bdh;


foreach my $plantID (@plantIDs) { print "$plantID\n"; }



=pod

my %num_plants;



my $today = `date`;
chomp($today);




open my $plant_fh, '<', $plants or die "can't open $plants\n";


while (<$plant_fh>) {

        if ( ( $_ =~ /$crop/i ) && ( $_ !~ /\%/ ) )  {
                my ($prefix,$row,$plants) = $_ =~ /^(.{10}),(\d{1,3}),(\d{1,2}),/;


		
                if ( length($row) < 3 ) { $prefix .= "000" . $row; }
		else { $prefix .= "00" . $row; }
                $prefix =~ s/\'//g;
#		print "($prefix,$plants)\n";		

		$num_plants{$prefix} = $plants;
	        }
        }








open my $mutants_fh, '<', $file or die "can't open $file\n";
open my $out_fh, '>', $out or die "can't open $out\n";




while (<$mutants_fh>) {
        if ( $_ =~ /$crop/i ) {
		my ($plant) = $_ =~ /^([\w\:]{15}),/;
		my ($stem,$plant_num) = $plant =~ /^([\w\:]{13})(\d{2})$/;


# numerical comparison ok even though $plant_num is a string with a leading 0
		
#		print "($stem,$plant_num)\n";


                if ( exists($num_plants{$stem}) ) {
		
		        my $max_plants = $num_plants{$stem};

        	        if ( $plant_num <= $max_plants ) { print $out_fh $_; }		
		        }
	       }
        }



=cut
