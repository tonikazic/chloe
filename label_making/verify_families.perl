#!/usr/local/bin/perl

# this is /mnemosyne/a/maize/label_making/verify_families.perl


# This script takes a comma-delimited file dumped from a database and tests
# to be sure the symbolic and numerical genotypes from the left half of the
# spreadsheet match those on the right half; the family numbers were used in
# a cut and paste operation.  It then outputs a file with each plant in the family
# so that all plants can have tags.
#
# Kazic, 5.1.07



$input = "../data/wcf.csv";
# $input = "../data/test.csv";
$output = "../data/plant_tags.csv";

$num_plants = 13;


open(IN,"<$input") || die "can't open $input\n";
open(OUT,">$output") || die "can't open $output\n";

while (<IN>) {
        $_ =~ s/\"//g;
        $_ =~ s/\s//g;


        ($loctn_code,$year,$compact_gtype,$compact_num_gtype,$row_prefix,$row,$family,$ma_gma_gtype,$ma_gpa_gtype,$pa_gma_gtype,$pa_mutant,$ma_num,$pa_num) = $_ =~ /^(\w),(\d+),(.+),(.+),(.),(\d+),(\d+),(.+),(.+),(.+),(.+),(\w+),(\w+)$/;


#	print "locatn: $loctn_code yr: $year compactg: $compact_gtype compactn $compact_num_gtype rowprefix $row_prefix row: $row  fam $family ma $ma_gma_gtype magp $ma_gpa_gtype pa $pa_gma_gtype pamu $pa_mutant ma_num: $ma_num pa_numn $pa_num \n";


#        $sym_flag = &verify_sym_gtype($compact_gtype,$ma_gma_gtype,$pa_mutant);
#        $num_flag = &verify_num_gtype($compact_num_gtype,$ma_num,$pa_num);

        $sym_flag = 1;
        $num_flag = 1;


        if ( ( $sym_flag eq 1 ) && ( $num_flag eq 1 ) ) { &print_plants($num_plants,$loctn_code,$year,$row_prefix,$row,$family,$ma_gma_gtype,$ma_gpa_gtype,$pa_gma_gtype,$pa_mutant,$ma_num,$pa_num); } 

        else { &warn($sym_flag,$num_flag,$compact_gtype,$compact_num_gtype); }
        }



close(IN);
close(OUT);



sub verify_sym_gtype {
        ($compact_gtype,$ma_gma_gtype,$pa_mutant) = @_;

        $sym_flag = 0;

        if ( ( $compact_gtype  =~ /$ma_gma_gtype/ )
             && ( $compact_gtype =~ /$pa_mutant/ ) ) { $sym_flag = 1; }


        return $sym_flag;
        }



sub verify_num_gtype {
        ($compact_num_gtype,$ma_num,$pa_num) = @_;

        $num_flag = 0;

        if ( ( $compact_num_gtype =~ /$ma_num/ )
             && ( $compact_num_gtype  =~ /$pa_num/ ) ) { $num_flag =+ 1; }


        elsif  ( ( $ma_num =~ /\d0\d/ )
                 && ( $pa_num =~ /\d0\d/ )
                 && ( ( $compact_num_gtype  =~ /Mo20W/ )
                      || ( $compact_num_gtype  =~ /W23/ )
                      || ( $compact_num_gtype  =~ /M14/ ) ) ) { $num_flag =+ 1; }

        return $num_flag;
        }



sub print_plants {
        ($num_plants,$loctn_code,$year,$row_prefix,$row,$family,$ma_gma_gtype,$ma_gpa_gtype,$pa_gma_gtype,$pa_mutant,$ma_num,$pa_num) = @_;

        for ( $i = 1 ; $i <= $num_plants ; $i++ ) {
                print OUT "$loctn_code,$year,$row_prefix,$row,$i,$family,$ma_gma_gtype,$ma_gpa_gtype,$pa_gma_gtype,$pa_mutant,$ma_num,$pa_num\n";
                }
        }





sub warn {
        ($sym_flag,$num_flag,$compact_gtype,$compact_num_gtype) = @_;

        if ( $sym_flag ne 1 ) { print "Warning!  symbolic genotype mismatch for $compact_gtype\n"; }
        if ( $num_flag ne 1 ) { print "Warning!  numeric genotype mismatch for $compact_num_gtype\n"; }
        }
