#!/opt/perl5/perls/perl-5.26.1/bin/perl

# this is ../c/maize/label_making/make_plant_tags.perl


# This script is revised from safe.make_plant_tags.perl to lay out each
# row's tags in columns over the sheets, rather than in rows across a
# sheet.
#
#
# The basic approach is to generate the array; remove from it plants that
# have been kicked down for light or sacrificed; split the array into eight
# arrays, one for each column; and then compose the printing array from the
# eight columnar arrays.  The right-most column (column seven) will be cut
# first by the machinist.  Large holes will be drilled out on a drill press
# and the columns cut by a band saw, threading the tags onto #9 galvanized
# wire stopped with wooden blocks.
#
#
# The prolog predicate relies on an organized fact of rows in order of
# priority (priority_rows/2).  Enough usable barcodes have been
# incorporated into the tag layout to obviate the need for many additional
# tags for the mutants.
#
#
# The last few seasons, the tags have been printed at Fedex on their
# cardboard stock, which they perforate using a knife with approximately
# 1mm spacing between the teeth for the tear-off tags after printing.  The
# paper is CC4 matte cardstock (100 lb), 11 x 17 inches, and then cut to
# legal size so that all edges of each tag are visible.  Printing, cutting,
# and perforating take about three days.  Each perforation must be manually
# cut, which is the slow step.
#
# DO NOT LET FEDEX USE MICRO-PERFORATIONS!  These separate far too easily in any
# sort of wind.  The spacing between perforations should be about 1 mm.
#
# This is much cheaper, simpler, and more robust than finding the right
# stock, having Printing Services perforate it, and then printing in the
# lab on the pre-perforated stock, fixing endless paper jams, and jittering
# the scale to maximize registration with the perforations and minimize
# loss of material at the edges.
#
#
# Kazic, 24.7.2018



# call is ./make_plant_tags CROP FLAG
#
# where CROP's suffix is lower case, e.g., 11r, and
# FLAG is one of {go,q,test}.
#
# Kazic, 24.7.2018




use strict;
use warnings;


use Cwd 'getcwd';


use lib './Typesetting/';
use DefaultOrgztn;
use MaizeRegEx;
use AuxiliaryFiles;
use OrganizeData;
use TypesetGenetics;
use TypesettingMisc;
use GenerateOutput;



# our $crop = $ARGV[0]; in DefaultOrgztn


my $flag = $ARGV[1];
my $local_dir = getcwd;
my ($dir,$input_dir,$barcodes,$tags_dir) = &adjust_paths($crop,$local_dir);




$demeter_dir =~ s/^\.\.\///;


my $input_stem = "plant_list";
my $tags_stem = "prioritized_tags";
my $input_file = $input_dir . $input_stem . $csv_suffix;
my $output_file = $tags_dir . $tags_stem . $tex_suffix;
my $plant_fate_file = $demeter_dir . "plant_fate.pl";


# print "b: $barcodes\nif: $input_file\nof: $output_file\npf: $plant_fate_file\n";


my @tags;
my @pruned;
my %gone;
my @columnar;


my $uc_crop = uc($crop);


open my $in, '<', $input_file  or die "can't open $input_file\n";
my (@lines) = grep { $_ !~ /%/ && $_ !~ /^\n/ && $_ !~ /\#/ } <$in>;


for ( my $i = 0; $i <= $#lines; $i++ ) {

        my ($barcode_elts,$row,$max_plants,$family,$ma_family,$ma_num_gtype,$pa_family,$pa_num_gtype,$ma_gma_gtype,$marker,$quasi_allele) = $lines[$i] =~ /^\'?(${barcode_elts_re})\'?,(${plain_row_re}),(${ft_re}),(${family_re}),(${family_re}),\'?(${num_gtype_re})\'?,(${family_re}),\'?(${num_gtype_re})\'?,\'?(${gtype_re})\'?,\[\'?(${marker_re})\'?\],\'?([K\d]*)\'?,*/;

#        print "($barcode_elts,$row,$max_plants,$family,$ma_family,$ma_num_gtype,$pa_family,$pa_num_gtype,$ma_gma_gtype,$marker,$quasi_allele)\n";

	
        my $prow = pad_row($row,5);
        my ($prefix) = &get_family_prefix($family);

	

# this makes an easily read row number for the tag; we just want
# the nonzero suffix, not the fully padded row number, with the inbred
# prefix added in
#
# Kazic, 27.3.08

        my ($pre_row) = &easy_row($row,$prefix);

#	print "prerow: " . $pre_row . " prow: " . $row . " prefix: " . $prefix . "\n";


# overload $pplant with the pot number if we're in the greenhouse (G)
#
# Kazic, 27.3.2008
#
#                if ( $pot =~ /\d+/ ) { $pplant = "t" . $pot; }


# new for 08R:  just give the number of plants in each row; stick that in the "pot" place in the 
# spreadsheet.
#
#		$max_plants = $pot;

        for ( my $plant = 1 ; $plant <= $max_plants ; $plant++ ) {
                my ($pplant) = &pad_plant($plant);
#               print "pplant: $pplant\n";



                my ($new_barcode_elts) = &make_plant_id($barcode_elts,$prow,$pplant);
                my ($barcode_out) = &make_barcodes($barcodes,$new_barcode_elts,$esuffix); 

#               print "$barcode_out,$barcode_elts,$prow,$pplant,$marker\n";

                my $record = $new_barcode_elts . "::" . $barcode_out . "::" . $pre_row . "::" . $pplant . "::" . $crop . "::" . $family  . "::" .  $ma_num_gtype . "::" . $pa_family . "::" . $pa_num_gtype . "::" . $ma_gma_gtype . "::" . $marker . "::" . $quasi_allele;


#               print "main: $record\n";

                push(@tags,$record); 
		}
        }











# grab records for culled plants so their tags can be removed, since
# the corresponding datum is already entered in demeter.  Otherwise
# the tag is retained, and then removed when the plant is culled and entered
# into demeter then.
#
# Kazic, 25.7.2018

open my $fate, '<', $plant_fate_file or die "can't open $plant_fate_file\n";
my (@fates) = grep { $_ =~ /$uc_crop/ && $_ !~ /^[\n\t\r]/ && $_ !~ /\#/ } <$fate>;

if ( scalar @fates > 0 ) {
        for ( my $i = 0; $i <= $#fates; $i++ ) {
	        my ($goner) = $fates[$i] =~ /plant\_fate\(\'($uc_crop.+)\',/;
                $gone{$goner} = 1;
#		print "goner: $goner\n";
                }
        }












# hmmm, think the warning is due to an error of autovivification in if?????
#
# Use of uninitialized value in pattern match (m//) at ./make_plant_tags.perl line 203, <$fate> line 1378.
# Use of uninitialized value $plant in exists at ./make_plant_tags.perl line 204, <$fate> line 1378.
#
# there seems to be disagreement on whether autovivification happens in
# testing the first layer in the HoH
#
# otherwise works fine
#
# stopped here, must return and figure this out
#
# Kazic, 25.7.2018

for ( my $i = 0; $i <= $#tags + 1; $i++ ) {
    #        print "$tags[$i]\n";

        my ($plant,$rest) = $tags[$i] =~ /(${num_gtype_re})::(.+)$/;
        if ( exists $gone{$plant} ) { }
        else { push(@pruned,$rest); }
        }


# foreach my $prune (@pruned) { print "$prune\n"; }





my $sheets;

# now determine the number of sheets that will be needed:  this determines the
# size of the eight chunks into which @pruned will be cut

{ 
	use integer;
        $sheets = (($#pruned + 1) / 8);
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

for ( my $l = 0; $l <= $#seventh; $l++ ) {  
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
# Kazic, 8.11.2007


if ( $flag eq 'q' ) { }
elsif ( ( $flag eq 'test' ) || ( $flag eq 'go' ) ) { &make_plant_tags($output_file,$#columnar,\@columnar); }


if ( ( $flag eq 'q' ) || ( $flag eq 'test' ) { }
elsif ( $flag eq 'go' ) { &generate_plant_tags($tags_dir,$tags_stem); }



# just for Gerry's tags, which don't have barcodes
#
# Kazic, 31.12.2010


# &generate_pdfl($tags_dir,$tags_stem);


