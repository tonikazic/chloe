#!/usr/local/bin/perl



# this is ../c/maize/crops/scripts/rm_extraneous_plants.perl
#
# I goofed in pre-populsting the mutant table by not using the stand count data.  So in the
# block we've scored so far, there are dummy plants.  This script removes them by looking at
# the plant_list.csv file.
#
# I will rewrite the table population script so we don't have this problem again.
#
# call is: ./rm_extraneous_plants.perl CROP
#
#
# Kazic, 13.9.2020





use strict;
use warnings;

use Cwd 'getcwd';


use lib '../../label_making/Typesetting/';
use DefaultOrgztn;
use MaizeRegEx;



# our $crop = $ARGV[0]; in DefaultOrgztn


my $local_dir = getcwd;
my ($dir) = &adjust_paths($crop,$local_dir);





my $file = $input_dir . "mutants_n_extras.csv";
my $plants = $input_dir . "plant_list.csv";
my $out = $input_dir . "mutant.csv";

# print "$file\n$plants\n$out\n";


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



