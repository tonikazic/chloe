#!/usr/local/bin/perl

# this is join_06n_data.perl
#
# Kazic, 1.5.07


# This script takes comma-delimited files dumped from a spreadsheet and  generates 
# a table of seed with numerical genotype, symbolic genotype, cross date, and storage location
# for use in generating seed packet labels.  The output data will be inserted into the
# corresponding records_*.ods file by hand.



use typeset_genetics;
use typesetting_misc;




$input_families = "../crops/07r/06r_offspring_families.csv";
$input_crosses = "../crops/07r/06n_crosses.csv";
$input_inventory = "../crops/07r/06n_inventory.csv";
$input_failures = "../crops/07r/06n_failures.csv";

$output = "../crops/07r/full_06n_inventory.csv";

$crop = "06N";




# these are the 06r input families, for looking up the genotypes in the 06n crosses
#
# 06n families I have to assign from scratch by hand


open(IN,"<$input_families") || die "can't open $input_families\n";

while (<IN>) {
        $_ =~ s/\"//g;

        ($family,$ma_gma_gtype,$ma_gpa_gtype,$pa_gma_gtype,$pa_gpa_gtype,$quasi_allele) = $_ =~ /,(\d+),([\w\*\-\+\s]+),([\w\*\-\+\s]+),([\w\*\-\+\s]*),([\w\*\-\+\s]*),[\w\-\.]*,(\w{0,4})/;


#        print "fam $family ma_gma $ma_gma_gtype ma_gpa $ma_gpa_gtype pa_gma $pa_gma_gtype pa_gpa $pa_gpa_gtype quasi $quasi_allele\n";

        $record = $ma_gma_gtype . "::" . $ma_gpa_gtype . "::" . $pa_gma_gtype . "::" . $pa_gpa_gtype . "::" . $quasi_allele;

        $families{$family} = $record;
        }

close(IN);


&clear_variables;







open(IN,"<$input_crosses") || die "can't open $input_crosses\n";

while (<IN>) {
        $_ =~ s/\"//g;

        ($ma_num_gtype,$pa_num_gtype,$date) = $_ =~ /\d*,\d*,([\w\:\.]+),([\w\:\.]+),\w+,\w+,\w+,[A-Za-z\s\,\-]+,([\d\/]+)/;

#        print "ma num gytpe is $ma_num_gtype pa num gtype is $pa_num_gtype date is $date\n";

        if ( $pa_num_gtype eq "" ) { print "Warning!  missing paternal genotype for $ma_num_gtype in crosses!\n"; }

        $record = $pa_num_gtype ."::" . $date;
        $crosses{$ma_num_gtype} = $record;
        }

close(IN);


&clear_variables;


# hmmm. We have seed appearing in the inventory that is not necessarily in the crosses, but the inventory
# has the cross date.  So for seed not in the crosses, we must check the inventory for the cross date.
#
# Kazic, 15.5.07

open(IN,"<$input_inventory") || die "can't open $input_inventory\n";

while (<IN>) {
        $_ =~ s/\"//g;

        chomp($_);


        ($ma_num_gtype,$pa_num_gtype,$ear_whole,$ear_half,$ear_qtr,$ear_few,$ear_failed,$inv_date,$box,$sleeve,$cross_date,$loctn) = $_ =~ /^([\w\:\.]+),([\w\:\.]*),(\w+),(\w+),(\w+),(\w+),(\w+),[\w\s]+,([\d\/]*),[\:\d]*,(\d*),(\d*),\w*,([\d\/]*),[\w\s]*,[\w\s]*,([\w\s\/\.\,\;\:\-\!\?]*)$/;

#       print "ma num gytpe is $ma_num_gtype pa num gtype is $pa_num_gtype ear_wh is $ear_whole ear_half is $ear_half ear_qtr is $ear_qtr ear_few is $ear_few ear_fld is $ear_failed inv date is $inv_date box is $box sleeve is $sleeve cross date is $cross_date loctn is $loctn\n";

        if ( $cross_date ne "" ) { print "Warning!  unrecorded cross for $ma_num_gtype on $cross_date in inventory!\n"; }

        ($ear,$estcl,$packet) = &assign_cl_values($ear_whole,$ear_half,$ear_qtr,$ear_few,$ear_failed);


        $record = $pa_num_gtype ."::" . $ear ."::" . $estcl ."::" . $packet ."::" . $box ."::" . $sleeve  ."::" .  $inv_date ."::" . $cross_date;

        $inventory{$ma_num_gtype} = $record;
        }

close(IN);




&clear_variables;


open(IN,"<$input_failures") || die "can't open $input_failures\n";

while (<IN>) {
        $_ =~ s/\"//g;

        ($failed_ma) = $_ =~ /^(.{15}),/;

#        print "failed is $failed_ma\n";

        $failures{$failed} = "0";
        }

close(IN);




open(OUT,">$output");



# for each item in the inventory, grab its corresponding data, parsing rows as needed,
# and generate a line for the output file
#
# organize search by inventoried seed

print OUT "ma family,ma num gtype,pa family,pa num gtype,pma ma gma gtype,pma ma gpa gtype,pma pa gma gtype,pma pa mutant,ma quasi,ppa ma gma gtype,ppa ma gpa gtype,ppa pa gma gtype,ppa pa mutant,pa quasi,cross date,ear,estcl,packet,box,sleeve,inv date\n";

foreach $ma_num_gtype ( sort keys(%inventory) ) {

        ($pa_num_gtype,$ear,$estcl,$packet,$box,$sleeve,$idate,$cross_date) = split(/::/,$inventory{$ma_num_gtype});
        ($cpa_num_gtype,$cdate) = split(/::/,$crosses{$ma_num_gtype});

#	print "$ma_num_gtype :$ipa_num_gtype: $ear $estcl $packet $box $sleeve $idate :$cross_date: ::::  :$cpa_num_gtype: :$cdate:\n";

# if inventory has a cross that was not recorded in %crosses, use the inventory $cross_date;
# otherwise, use the $cdate in %crosses

        if ( ( $cpa_num_gtype eq "" ) 
             && ( $cdate eq "" )  
             && ( $cross_date ne "" ) ) { $tcross_date = $cross_date; }
        elsif ( ( $cpa_num_gtype ne "" )  
                && ( $cdate ne "" ) 
                && ( $cross_date eq "" ) ) { $tcross_date = $cdate; }

        if ( $failures{$ma_num_gtype} eq 0 ) { print "failed cross with $ma_num_gtype\n"; }


# get genotypes of parents from their families embedded in their barcodes!

        ($ma_family) = $ma_num_gtype =~ /06N(\d{3,4})\:/;
        ($pa_family) = $pa_num_gtype =~ /06N(\d{3,4})\:/;

        ($pma_ma_gma_gtype,$pma_ma_gpa_gtype,$pma_pa_gma_gtype,$pma_pa_mutant,$ma_quasi) = split(/::/,$families{$ma_family});

        ($ppa_ma_gma_gtype,$ppa_ma_gpa_gtype,$ppa_pa_gma_gtype,$ppa_pa_mutant,$pa_quasi) = split(/::/,$families{$pa_family});


        $quasi = "-K" . $pa_quasi;

# now output the data

        print OUT "$ma_family,$ma_num_gtype,$pa_family,$pa_num_gtype,$pma_ma_gma_gtype,$pma_ma_gpa_gtype,$pma_pa_gma_gtype,$pma_pa_mutant,$ma_quasi,$ppa_ma_gma_gtype,$ppa_ma_gpa_gtype,$ppa_pa_gma_gtype,$ppa_pa_mutant,$quasi,$tcross_date,$ear,$estcl,$packet,$box,$sleeve,$idate\n";


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
	$date = ""; 
	$cdate = "";
	$cross_date = "";
 	$idate = ""; 
 	$inv_date = ""; 
	$ma_pad_row = ""; 
	$pa_pad_row = ""; 
	$ma_pad_plant = ""; 
	$pa_pad_plant = ""; 
	$ma_row = ""; 
	$pa_row = ""; 
	$ear_whole = ""; 
	$ear_half = ""; 
	$ear_qtr = ""; 
	$ear_few = ""; 
	$ear_failed = ""; 
	$estcl = ""; 
	$cl = ""; 
	$packet = ""; 
	$box = ""; 
	$sleeve = ""; 
        }




# In the 06n inventory we eyeballed the extent to which the ears were filled with kernels;
# we didn't have time to count the rows and radii.  The ears were between 0.5 and 0.75 the size
# of the 06r ears, and the average number of rows and radii for ALL 06r ears (mutant and inbred)
# was 29.49 and 15.39, respectively.  Multiplying out, this produces an estimate of
#
#                 estimated          used in assignments
#
# ear_whole             227           220
# ear_half              113           110
# ear_qtr                57            55
# ear_few                10            10
# ear_failed              0             0
#
# The rounder numbers were used to make it easier to spot that these are artificial.  They are 
# conservatively estimated deliberately.
#
# Kazic, 16.5.07


sub assign_cl_values {

 	 ($ear_whole,$ear_half,$ear_qtr,$ear_few,$ear_failed) = @_;

         if ( $ear_whole eq "True" ) { $estcl = "220"; }
         elsif ( $ear_half eq "True" ) { $estcl = "110"; }
         elsif ( $ear_qtr eq "True" ) { $estcl = "55"; }
         elsif ( $ear_few eq "True" ) { $estcl = "10"; }
         elsif ( $ear_failed eq "True" ) { $estcl = "0"; }

         if ( $estcl > 10 ) { $ear = "x"; $packet = ""; }
         else { $packet = "x?"; $ear = ""; }

         return ($ear,$estcl,$packet);
         }
