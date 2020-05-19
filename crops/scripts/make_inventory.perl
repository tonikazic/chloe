#!/usr/local/bin/perl

# this is . . ./maize/crops/make_inventory.perl
#
# given a file of inventory facts obtained by physically inventorying the seed in the seed
# room, convert these sequentially to inventory/7 facts.
#
# The input file is assumed to be  ../data/palm/raw_data_from_palms/CROP/reinventory/inventory.csv
# the output file is assumed to be ../data/palm/raw_data_from_palms/13r/reinventory/inventory.pl.
#
# Kazic, 28.3.2014

# call is perl ./make_inventory.perl CROP


use Date::Calc qw(Today_and_Now) ;

use lib qw(../label_making/);
use Typesetting::MaizeRegEx;
use Typesetting::ConvertPalmData;
use Typesetting::NoteExpsn;



$crop = $ARGV[0];
$today = `date`;
chomp($today);


$proto_inventory_file = "../data/palm/raw_data_from_palms/" . $crop . "/reinventory/inventory.csv";
$inventory_file = "../data/palm/raw_data_from_palms/" . $crop . "/reinventory/inventory.pl";


open(IN,"<$proto_inventory_file") || die "can't open $proto_inventory_file";
open(OUT,">$inventory_file");


print OUT "% this is ../crops/$inventory_file 
%
% generated on $today by ../crops/make_inventory.perl
% from the input file of manually sorted, successful, retained ears:
% ../crops/$proto_inventory_file.
%
% inventory(MaPlantID,PaPlantID,NumKernels,Observer,Date,Time,Sleeve).\n\n\n";




# "06R0001:0000108","06R0001:0000106","we",,"v00001","wade","01/14/2014 9:06:54"
# inventory('06R200:S000I104','06R0055:0005515',num_kernels(11),dylan,date(11,1,2008),time(13,55,43),v00001).



while (<IN>) {

        if ( $_ !~ /^\"/ ) { print OUT $_; }

        else {

                my ($ma,$pa,$fuzzy_cl,$num_cl,$sleeve,$observer,$datetime) = $_ =~ /\"?(${num_gtype_re})\"?,\"?(${num_gtype_re})\"?,\"?(${est_kernel_re})\"?,\"?(${cnted_kernel_re})\"?,\"?(${sleeve_re})\"?,\"?(${observer_re})\"?,\"?(${datetime_re})\"?/;

#                print "($ma,$pa,$fuzzy_cl,$num_cl,$sleeve,$observer,$datetime)\n";





                ($final_num_cl) = &convert_cl($fuzzy_cl,$num_cl);
                if ( $final_num_cl !~ /\d+/ ) { ($final_num_cl) = &expand_note($final_num_cl); }


		($date,$time) = &convert_datetime($datetime);

#                print "$num_cl\n";

                print  "inventory(\'$ma\',\'$pa\',num_kernels($final_num_cl),$observer,$date,$time,$sleeve).\n";

                }       
        }



close(IN);
close(OUT);
