#!/usr/local/bin/perl

# this is . . ./maize/crops/make_proto_inventory.perl
#
# this is a slightly altered version of make_inventory.perl; due to permissions issues,
# inventory.csv cannot be altered, and so a copy was made as proto_inventory.csv 
#
# given a file of inventory facts obtained by physically inventorying the seed in the seed
# room, convert these sequentially to inventory/7 facts.
#
# The input file is assumed to be  ../data/palm/raw_data_from_palms/CROP/reinventory/proto_inventory.csv
# the output file is assumed to be ../data/palm/raw_data_from_palms/13r/reinventory/proto_inventory.pl.
#
# 
#
# Kazic, 28.3.2014

# call is perl ./make_proto_inventory.perl


use Date::Calc qw(Today_and_Now) ;

use lib qw(../label_making/);
use Typesetting::MaizeRegEx;
use Typesetting::ConvertPalmData;
use Typesetting::NoteExpsn;




$today = `date`;
chomp($today);



# commented these out as they really should not be these files!
#
# Usually the output goes to a proto_inventory.pl file.
#
# Kazic, 3.6.2014

# $proto_inventory_file = "../data/palm/raw_data_from_palms/14r/zeta/3.6/inventory.csv";
# $inventory_file = "../demeter/data/inventory.pl";


open(IN,"<$proto_inventory_file") or die "can't open $proto_inventory_file";
open(OUT,">$inventory_file") or die "can't open output file $inventory_file";


print OUT "% this is ../crops/$inventory_file 
%
% generated on $today by ../crops/make_proto_inventory.perl
% from the input file of manually sorted, successful, retained ears:
% ../crops/$proto_inventory_file.
%
% inventory(MaPlantID,PaPlantID,NumKernels,Observer,Date,Time,Sleeve).\n\n\n";




# "06R0001:0000108","06R0001:0000106","we",,"v00001","wade","01/14/2014 9:06:54"
# inventory('06R200:S000I104','06R0055:0005515',num_kernels(11),dylan,date(11,1,2008),time(13,55,43),v00001).



while (<IN>) {

#        if ( $_ !~ /^\"/ ) { print OUT $_; }

        if ( $_ =~ /^[\n%]/ ) { print OUT $_; }

        else {

                my ($ma,$pa,$fuzzy_cl,$num_cl,$sleeve,$observer,$datetime) = $_ =~ /\"?(${num_gtype_re})\"?,\"?(${num_gtype_re})\"?,\"?(${est_kernel_re})\"?,\"?(${cnted_kernel_re})\"?,\"?(${sleeve_re})\"?,\"?(${observer_re})\"?,\"?(${datetime_re})\"?/;

#                print "($ma,$pa,$fuzzy_cl,$num_cl,$sleeve,$observer,$datetime)\n";





                ($final_num_cl) = &convert_cl($fuzzy_cl,$num_cl);
                if ( $final_num_cl !~ /\d+/ ) { ($final_num_cl) = &expand_note($final_num_cl); }


		($date,$time) = &convert_datetime($datetime);

#                print "$num_cl\n";

                print OUT  "inventory(\'$ma\',\'$pa\',num_kernels($final_num_cl),$observer,$date,$time,$sleeve).\n";

                }       
        }



close(IN);
close(OUT);
