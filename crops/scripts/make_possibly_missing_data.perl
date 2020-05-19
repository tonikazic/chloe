#!/usr/local/bin/perl

# this is ../c/maize/crops/scrips/make_possibly_missing_data.perl



# from the barcodes generated for use in a crop's plant tags, make
# possibly_missing_data/5 facts and append these to 
# ../../demeter/data/possibly_missing_facts.pl, for searching for
# contemporaneously unrecorded data.
#
#
# call is make_possibly_missing_data CROP
#
# Kazic, 16.5.2018




use strict;
use warnings;

use Cwd 'getcwd';



use lib '../../label_making/Typesetting/';
use DefaultOrgztn;
use OrganizeData;
use MaizeRegEx;



my $local_dir = getcwd;
my ($dir) = &adjust_paths($crop,$local_dir);


my $output_file = $demeter_dir . "possibly_missing_data.pl";

# $barcodes is defined in DefaultOrgztn
# print "b: $barcodes\no: $output_file\n";






my @barcodes;
my %rows;
my $cur_row = 0;
my $cur_plant = 0;
my $out;








opendir my $bdh, $barcodes or die "can't open the barcode directory $barcodes\n";


# get just the mutants, not inbreds, landraces, or fun corn, since
# these are easily produced by hand

@barcodes = grep { $_ =~ /$crop/i && $_ !~ /${nonmutant_particle_re}/ && $_ =~ s/\.eps//g } readdir $bdh;

closedir $bdh;











# build a hash of arrays containing the data


foreach my $barcode (@barcodes) { 
        my ($num_gtype_stem,$plant) = $barcode =~ /^([\w\:]+)(\d{2})$/;
        my ($pcrop,$family,$padded_row) = $num_gtype_stem =~ /(${crop_re})(${family_re}):(${padded_row_re})/;

        $family =~ s/^0//g;
	
#        print "$barcode $pcrop $num_gtype_stem $plant $family $padded_row\n"; 


        if ( exists $rows{$padded_row} ) {

                $rows{$padded_row}[4] = $plant;
	        $cur_row = $padded_row;
                $cur_plant = $plant;
              
#                print "    $cur_plant\n";      
                }



	
# at a new row, start its hash entry and insert the last plant of the
# prior row; 
# then set the value of the last plant from the prior row; 
# then switch to the row and plant we just parsed from the directory entry
	
	
        else {

	        $rows{$padded_row} = [$pcrop, $family, $barcode, $num_gtype_stem, $plant];
                $rows{$cur_row}[4] = $cur_plant;


#		print "\nn: $padded_row $pcrop $family $barcode $num_gtype_stem $plant\n";
#		print "p: $cur_row $rows{$cur_row}[4] \n";
		
	        $cur_row = $padded_row;
                $cur_plant = $plant;
#               print "s: $cur_row $cur_plant\n\n";
	        }
        }












open $out, '>>', $output_file or die "can't open $output_file\n";
my $today = `date`;
chomp($today);
my $dc_crop = lc($crop);


print $out "\n\n\n\n\n% $dc_crop\n\n
% data added by ../c/maize/crops/scripts/make_possibly_missing_data.perl
% using barcode filenames from $barcodes as input on $today.\n\n\n";


foreach my $key ( sort { $a <=> $b } ( keys %rows ) ) {
#        print "h: $key @{ $rows{$key} } \n";


# can't figure out how to keep these data out of the array in the first    
# place!    
#
# Kazic, 16.5.2018
    
        if ( $key ne '0' ) { 
		my $prow = 'r' . $key;
		my $last_plant = $rows{$key}[3] . $rows{$key}[4];
                print $out "possibly_missing_data('$rows{$key}[0]',$rows{$key}[1],$prow,'$rows{$key}[2]','$last_plant').\n";
                }  
        }









