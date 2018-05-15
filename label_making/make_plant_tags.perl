#!/opt/perl5/perls/perl-5.26.1/bin/perl

# this is ../c/maize/label_making/make_plant_tags.perl


# This script is revised from safe.make_plant_tags.perl to lay out each row's
# tags in columns over the sheets, rather than in rows across a sheet.
#
# The basic approach is to generate the array as before; remove from it plants
# that have been kicked down or sacrificed; split the array into eight arrays, 
# one for each column; and then compose the printing array from the eight columnar
# arrays.  The right-most column is cut first (column seven).  Large holes will be drilled
# out on a drill press and the columns cut by a Dremel, threading the tags onto #9 galvanized
# wire stopped with wooden blocks.
#
# Switches in the original have been eliminated, since the prolog predicate now relies
# on a manually organized fact of rows in order of priority (priority_rows/2).  Enough usable
# barcodes have been incorporated into the (slightly rearranged) new tag layout to obviate the
# need for additional tags for the mutants.
#
# The remaining comments are the same as safe.make_plant_tags.perl unless otherwise 
# indicated.
#
# Kazic, 20.7.2010


# call is ./make_plant_tags CROP 
#
# where CROP's suffix is lower case, e.g., 11r


# port to 5.26 untested
#
# Kazic, 17.4.2018



use strict;
use warnings;


use lib './Typesetting/';

use DefaultOrgztn;
use MaizeRegEx;
use AuxiliaryFiles;
use OrganizeData;
use TypesetGenetics;
use TypesettingMisc;
use GenerateOutput;






my $input_stem = "plant_list";
# $input_stem = "short_plant_list";
# $input_stem = "test_list";
# $input_stem = "kristen";
# $input_stem = "tmp";
my $tags_stem = "prioritized_tags";
# $tags_stem = "test_tags";
# $tags_stem = "kristen_tags";
my $input_file = $input_dir . $input_stem . $csv_suffix;
my $output_file = $output_dir . $tags_stem . $tex_suffix;
my $demeter_dir =~ s/^..\///;
my $plant_fate_file = $demeter_dir . "plant_fate.pl";
my $crop = $ARGV[0];
$crop =~ tr/gnr/GNR/;

my @tags;
my @pruned;
my %gone;
my @columnar;



open my $in, '<', $input_file  or die "can't open $input_file\n";


while (<$in>) {

# probably obsolete given the progressive refinement of the regular expressions
#
# Kazic, 8.11.2007

        clean_line($_);


# the original 06r families will not match $family_re for the male parent, only
# $original_family_re.  Toggle this condition as needed.
#
# Kazic, 19.7.2007


        if ( $_ !~ /^\#/ ) {





# for 09R and subsequently, based on the data in demeter, including stand counts ($max_plants = stand count + 1
#
# $barcode_elts are of the form:  Crop . Family . : . Prefix
#

# kristen!
# $barcode_elts == the prefix for your barcode
# $prow == the row
# $max_plants == the stand count for the row
# $family == the line number
# $ma_family, $pa_family are the families of the parent of the corn in the planted row
# $ma_num_gtype, and $pa_num_gtype are the numerical genotypes of the parents
# $marker == gene of interest
# $quasi_allele == could be allele for you
#
# make a comma-delimited file of this information, however you like it, try to keep it
# in this order



                my ($barcode_elts,$prow,$max_plants,$family,$ma_family,$ma_num_gtype,$pa_family,$pa_num_gtype,$ma_gma_gtype,$marker,$quasi_allele) = $_ =~ /^(${num_gtype_re}),(${plain_row_re}),(${ft_re}),(${family_re}),(${family_re}),(${num_gtype_re}),(${family_re}),(${num_gtype_re}),(${gtype_re}),(${marker_re}),(${quasi_re}),*/;
#
# gerry's fractional families; modify regular expression and tag layout to handle his genetic information
#
# Kazic, 3.1.2011
#
#                ($barcode_elts,$prow,$max_plants,$family,$ma_family,$ma_num_gtype,$pa_family,$pa_num_gtype,$ma_gma_gtype,$marker,$quasi_allele) = $_ =~ /^(${num_gtype_re}),(${wierd_gtype_re}),(${ft_re}),(${family_re}),(${family_re}),(${num_gtype_re}),(${family_re}),(${num_gtype_re}),(${gtype_re}),(${marker_re}),(${quasi_re}),*/;

 
# kristen's
#
#                ($barcode_elts,$prow,$max_plants,$family,$marker) = $_ =~ /^(\w+),(\w+),(${ft_re}),(\w+),([\w\d\*\/]*)/;




#               print "$barcode_elts,$prow,$max_plants,$family,$ma_family,$ma_num_gtype,$pa_family,$pa_num_gtype,$ma_gma_gtype,$marker,$quasi_allele\n";


		

# in case the row was not padded in the spreadsheet or the Prolog is used

                $prow =~ s/r//;

# for kristen, who doesn''t want padded rows
#
                ($prow) = &pad_row($prow,5);

		
                my ($prefix) = &get_family_prefix($family);


# this makes an easily read row number for the tag; we just want
# the nonzero suffix, not the fully padded row number, with the inbred
# prefix added in
#
# Kazic, 27.3.08

                my ($pre_row) = &easy_row($prow,$prefix);

#		print "prerow: " . $pre_row . " prow: " . $prow . " prefix: " . $prefix . "\n";


# overload $pplant with the pot number if we're in the greenhouse (G)
#
# Kazic, 27.3.08
#
#                if ( $pot =~ /\d+/ ) { $pplant = "t" . $pot; }


# new for 08R:  just give the number of plants in each row; stick that in the "pot" place in the 
# spreadsheet.
#
#		$max_plants = $pot;

                for ( my $plant = 1 ; $plant <= $max_plants ; $plant++ ) {
                        my ($pplant) = &pad_plant($plant);
#                        print "pplant: $pplant\n";


# 09R and subsequently

# kristen's
#
#			$pplant = "-" . $pplant;
#                        print "$pplant \n";




                        my ($new_barcode_elts) = &make_plant_id($barcode_elts,$prow,$pplant);

# kristen
#
#                        ($new_barcode_elts) = &make_kristen_plant_id($barcode_elts,$prow,$pplant,$marker);


                         my ($barcode_out) = &make_barcodes($barcodes,$new_barcode_elts,$esuffix); 

#                          print "$barcode_out,$barcode_elts,$prow,$pplant,$marker\n";


# 10R and subsequently
#
                       my $record = $new_barcode_elts . "::" . $barcode_out . "::" . $pre_row . "::" . $pplant . "::" . $crop . "::" . $family  . "::" .  $ma_num_gtype . "::" . $pa_family . "::" . $pa_num_gtype . "::" . $ma_gma_gtype . "::" . $marker . "::" . $quasi_allele;



# kristen
#
#                       $record = $new_barcode_elts . "::" . $barcode_out . "::" . $prow . "::" . $pplant . "::" . $marker;



#                       print "main: $record\n";

                       push(@tags,$record); 
                       }


# clear the variables!

		$barcode_elt = "";
		$barcode_elts = "";
		$barcode_out = "";
		$family = "";
		$flag = "";
		$ma_family = "";
		$ma_num_gtype = "";
		$ma_gma_gtype = "";
		$marker = "";
		$max_plants = "";
		$new_barcode_elts = "";
		$pa_family = "";
		$pa_num_gtype = "";
		$plant = "";
		$pplant = "";
		$prow = "";
		$pre_row = "";
		$prefix = "";
		$prow = "";
		$quasi_allele = "";
		$record = "";
	        }
        }







# remove records for absent plants: parse demeter/data/plant_fate.pl into a hash
# and write values not in the hash into the new array @pruned.
#
# works
#
# Kazic, 20.7.2010

open my $fate, '<', $plant_fate_file or die "can't open $plant_fate_file\n";





while (<$fate>) {
        if ( my ($goner) = $_ =~ /plant\_fate\(\'($crop.+)\',/ ) { 
                $gone{$goner} = 1; 
                $goner = "";
                }
        }




for ( my $i = 0; $i <= $#tags + 1; $i++ ) {
        my ($plant,$rest) = $tags[$i] =~ /(${num_gtype_re})::(.+)$/;
        if ( $gone{$plant} ) { true; }
        else { push(@pruned,$rest); }
#
# kristen
#
#        push(@pruned,$tags[$i]);
}










# now determine the number of sheets that will be needed:  this determines the
# size of the eight chunks into which @pruned will be cut

{ 
	use integer;
        my $sheets = (($#pruned + 1) / 8);
}




my $rem_columns = ($#pruned + 1) % 8;
if ( $rem_columns > 0 ) { $sheets++; }


# print "sheets: $sheets\n";





# now cut pruned into arrays of length $sheets, writing each chunk to its own array, using slices
#
# the arrays are named after the columns on the sheet, starting at the left edge with @zeroth_array
# and finishing on the right edge with @seventh_array.

my $sixth_end =2*$sheets;
my $fifth_end =3*$sheets;
my $fourth_end =4*$sheets;
my $third_end =5*$sheets;
my $second_end =6*$sheets;
my $first_end =7*$sheets;



my @seventh = @pruned[0..$sheets];
my @sixth = @pruned[$sheets + 1..$sixth_end];
my @fifth = @pruned[$sixth_end + 1..$fifth_end];
my @fourth = @pruned[$fifth_end + 1..$fourth_end];
my @third = @pruned[$fourth_end + 1..$third_end];
my @second = @pruned[$third_end + 1..$second_end];
my @first = @pruned[$second_end + 1..$first_end];
my @zeroth = @pruned[$first_end + 1..$#pruned + 1];



# print "pruned\n"; for ( $j = 0 ; $j <= $#pruned + 1; $j++ ) { print "$pruned[$j]\n"; } print "\n\n";
# print "seventh\n"; for ( $j = 0 ; $j <= $#seventh + 1; $j++ ) { print "$seventh[$j]\n"; } print "\n\n";
#
# etc.




# and now assemble the output array that is passed for laying out sheets

for ( $l = 0; $l <= $#seventh; $l++ ) {  
        push(@columnar,$zeroth[$l]);	  
        push(@columnar,$first[$l]);  
        push(@columnar,$second[$l]); 
        push(@columnar,$third[$l]);  
        push(@columnar,$fourth[$l]); 
        push(@columnar,$fifth[$l]);  
        push(@columnar,$sixth[$l]);  
        push(@columnar,$seventh[$l]);
        }







# print "columnar\n"; for ( $m = 0 ; $m <= $#columnar; $m++ ) { print "$m: $columnar[$m]\n"; } print "\n\n";




# now have to make and process the latex file for the tags, moving over @columnar: from 
# here on it's the same as before!

# Using a reference to the array, rather than directly passing it, should be helpful 
# for large numbers of tags.  I'm passing the number of elements directly because I
# haven't yet deduced how to combine $# with an array reference ***after passing***.
# Up here, it's simply $#{\@columnar}.
#
# Kazic, 8.11.07

&make_plant_tags($output_file,$#columnar,\@columnar);
&generate_plant_tags($output_dir,$tags_stem);



# just for Gerry's tags, which don't have barcodes
#
# Kazic, 31.12.2010


# &generate_pdfl($output_dir,$tags_stem);
