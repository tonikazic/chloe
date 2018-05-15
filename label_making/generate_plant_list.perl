#!/usr/bin/perl

# this is generate_plant_list.perl
#
# Kazic, 26.6.07


# This script takes two comma-delimited files dumped from a spreadsheet (one of the
# full inventory, and the other the row list for a planting) and generates 
# a csv file of information for use in generating leaf emergence and plant tags.
#
# The next version will use a list of excluded plant ids to minimize waste, and have a 
# switch to print a duplicate line for the mutant tags.
#
# Kazic, 26.6.07


use typesetting_misc;



$dir = "../crops/07r";
$inventory = "$dir/known_inventory.csv";
$row_list = "$dir/row_list.csv";
$output = "$dir/plant_list.csv";

$crop = &make_crop($dir);

$family_re = qr/\d*/;
$num_gtype_re = qr/[\w\:\.\-\s\;\?]*/;
$gtype_re = qr/[\w\*\-\+\.\/\s\{\}\|\;\(\)\?\^]*/;
$quasi_re = qr/\-?\w{0,6}/;





# this is the inventory of all seed, with genotypes and families assigned.  The data are
# from ../data/spreadsheets/full_inventory.ods, the first page.
#
# Not all 06R genotypes are complete and there are several lines with a red background that
# must be checked.
#
# Kazic, 26.6.07



###### clear variables after each pass! genotypes are getting garbled.  Ensure that 
# all columns of spreadsheet filled in.
#
# Kazic, 1.7.07


open(IN,"<$inventory") || die "can't open $inventory\n";

while (<IN>) {
        $_ =~ s/\"//g;


# maybe squeeze the plan onto the plant tag?  likely to be very crowded!


        if ( ($family,$ma_family,$ma_num_gtype,$pa_family,$pa_num_gtype,$pma_ma_gma_gtype,$pma_ma_gpa_gtype,$pma_pa_gma_gtype,$pma_pa_mutant,$ppa_ma_gma_gtype,$ppa_ma_gpa_gtype,$ppa_pa_gma_gtype,$ppa_pa_mutant,$quasi_allele) = $_ =~ /\w{3},(${family_re}),(${family_re}),(${num_gtype_re}),(${family_re}),(${num_gtype_re}),(${gtype_re}),(${gtype_re}),(${gtype_re}),(${gtype_re}),[\w\-]{0,6},(${gtype_re}),(${gtype_re}),(${gtype_re}),(${gtype_re}),\d*,\d*,(${quasi_re})/ ) {
#                print "$family $ma_family $ma_num_gtype $pa_family $pa_num_gtype $pma_ma_gma_gtype $pma_ma_gpa_gtype $pma_pa_gma_gtype $pma_pa_mutant $ppa_ma_gma_gtype $ppa_ma_gpa_gtype $ppa_pa_gma_gtype $ppa_pa_mutant $quasi_allele\n";

	        }

#	else { print $_; }


        $key = $ma_num_gtype . ";;" . $pa_num_gtype;


        $record = $family . "::" . $ma_family . "::" . $pa_family . "::" . $pma_ma_gma_gtype . "::" . $pma_ma_gpa_gtype . "::" . $pma_pa_gma_gtype . "::" . $pma_pa_mutant . "::" . $ppa_ma_gma_gtype . "::" . $ppa_ma_gpa_gtype . "::" . $ppa_pa_gma_gtype . "::" . $ppa_pa_mutant . "::" . $quasi_allele;

        $inventory{$key} = $record;
        }

close(IN);


&clear_variables;




# field, row, packet,family, ma, pa


open(IN,"<$row_list") || die "can't open $row_list\n";

while (<IN>) {
        $_ =~ s/\"//g;


        if ( ($row,$family,$ma_num_gtype,$pa_num_gtype) = $_ =~ /\w+,(\d+),\d*,(${family_re}),(${num_gtype_re}),(${num_gtype_re})/ ) {
#                print "$row $family $ma_num_gtype $pa_num_gtype\n";
	        }

#        else { print $_; }

        if ( ( $row !~ /[silver queen|golden pearl|peaches|popcorn|not planted]+/ ) 
           && ( $row ne "" ) ) {

# oops! lines from Guri Johal have fragmentary numerical genotypes ending in ":".  This confuses the split when 
# going through the row array.  So we separate the two parents by ";;" and then split in two steps below.

                $record = $row . "::" . $family . "::" . $ma_num_gtype . ";;" . $pa_num_gtype;
                push(@rows,$record);
	        }
        }

close(IN);


&clear_variables;


open(OUT,">$output");



# for each row in the rows, grab its corresponding data from the inventory
# and generate a line for the output file
#


$numrows = @rows;

for ( $i = 0 ; $i <= $numrows; $i++ ) {

        $record = $rows[$i];

        ($row,$rfamily,$parents) = split(/::/,$record);
        ($ma_num_gtype,$pa_num_gtype) = split(/;;/,$parents);

        
        ($family,$ma_family,$pa_family,$pma_ma_gma_gtype,$pma_ma_gpa_gtype,$pma_pa_gma_gtype,$pma_pa_mutant,$ppa_ma_gma_gtype,$ppa_ma_gpa_gtype,$ppa_pa_gma_gtype,$ppa_pa_mutant,$quasi_allele) = split(/::/,$inventory{$parents});


#        print "r: $row f: $family mf: $ma_family pf: $pa_family $pma_ma_gma_gtype $pma_ma_gpa_gtype $pma_pa_gma_gtype $pma_pa_mutant $ppa_ma_gma_gtype $ppa_ma_gpa_gtype $ppa_pa_gma_gtype $ppa_pa_mutant q: $quasi_allele\n";



        if ( ( $rfamily ne "" ) && ( $rfamily ne $family ) ) { print "\nWarning! tentative family $rfamily in row list doesn't match that in inventory for row $row $ma_num_gtype $pa_num_gtype!\n"; }

        if ( $family < 200 ) { ($family) = &pad_row($family,4); }

        
        if ( ( $family >= 200 ) && ( $family < 1000 ) ) { $num_plants = 20; }
        else { $num_plants = 15; }


        ($prow) = &pad_row($row,5);

        if ( ( $family =~ /2\d\d/ ) && ( $family !~ /\d{4}/ ) ) { $row_prefix = "S"; }
        elsif ( ( $family =~ /3\d\d/ ) && ( $family !~ /\d{4}/ ) ) { $row_prefix = "W"; }
        elsif ( ( $family =~ /4\d\d/ ) && ( $family !~ /\d{4}/ ) ) { $row_prefix = "M"; }
        else { $row_prefix = ""; }


        for ( $plant = 1; $plant < $num_plants + 1 ; $plant++ ) {
                $pplant = &pad_plant($plant);
                $barcode_elts = $crop . $family . ":" . $row_prefix . $prow . $pplant;






# now output the data

        print OUT "$barcode_elts,$prow,$pplant,$family,$ma_family,$ma_num_gtype,$pa_family,$pa_num_gtype,$pma_ma_gma_gtype,$pma_ma_gpa_gtype,$pma_pa_gma_gtype,$pma_pa_mutant,$ppa_ma_gma_gtype,$ppa_ma_gpa_gtype,$ppa_pa_gma_gtype,$ppa_pa_mutant,$quasi_allele\n";


	        }


        &clear_variables;

        }


close(OUT);


sub clear_variables {
        $record = "";
        $family = "";
        $row = "";
	$ma_gma_gtype = "";
	$ma_gpa_gtype = "";
	$pa_gma_gtype = "";
	$pa_gpa_gtype = "";
	$quasi_allele = "";
	$pa_mutant = "";
	$ma_num_gtype = "";
	$pa_num_gtype = ""; 
	$cpa_num_gtype = ""; 
	$ipa_num_gtype = ""; 
	$ma_pad_row = ""; 
	$pa_pad_row = ""; 
	$ma_pad_plant = ""; 
	$pa_pad_plant = ""; 
	$ma_row = ""; 
	$pa_row = ""; 
        }



