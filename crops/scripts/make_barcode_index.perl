#!/usr/local/bin/perl

# this is ../c/maize/crops/scripts/make_barcode_index.perl

# a lot is borrowed from ../c/maize/crops/scripts/make_possibly_missing_data.perl
#
# this constructs the ../c/maize/demeter/data/barcode_index.pl file.
#
# It can be called either by 
# ../c/maize/demeter/code/genetic_utilities.pl:make_barcode_index/1
# or directly from the command line.
#
# it is too frustrating to debug funky barcode filenames in prolog, 
# and native perl will be much faster in the regex.  So there.
#
# Kazic, 30.5.2018





# call is: ./make_barcode_index.perl RELATIVE_OUTFILE
#
# where RELATIVE_OUTFILE's path is relative to the directory from which the script
# is called.  
#
# So for example, in this directory,
#
# ./make_barcode_index.perl ../../demeter/data/foo.pl
#
# and from ../c/maize/demeter/code/genetic_utilities.pl 
# (which is where the prolog predicate executes),
#
# ../../crops/scripts/make_barcode_index.perl ../data/foo.pl 
#
# Kazic, 30.5.2018





use strict;
use warnings;



# because this script can be called from this directory or from
# ../../demeter/code/genetic_utilities.pl:make_barcode_index/1,
# directory handling is a bit different here:  we don't use 
# Cwd::getcwd for the paths.
#
# Kazic, 11.7.2018



use lib '../../label_making/Typesetting/';
use DefaultOrgztn;
use MaizeRegEx;



my $out = $ARGV[0];
my $barcodes = $barcode_rel_dir . "barcodes/";
my @barcodes;

# print "$barcodes\n";








opendir my $bdh, $barcodes or die "can't open the barcode directory $barcodes\n";
my @crops = grep { $_ =~ /\d\d[rng]/i } readdir $bdh;
closedir $bdh;


foreach my $crop (@crops) { 
         my $crop_dir = $barcodes . $crop;
         opendir my $cdh, $crop_dir or die "can't open the barcode subdirectory $crop_dir\n"; 

         my @tmp = grep { $_ =~ /${num_gtype_re}/ && $_ !~ /${nonfun_particle_re}/ && $_ !~ /${row_re}/ && $_ !~ /${packet_re}/ && $_ =~ s/\.eps//g } readdir $cdh;
	 closedir $cdh;
         push @barcodes, @tmp;
         }











open my $outfh, '>', $out or die "sorry, can't open output file $out\n";

my $now = `date`;
chomp($now);


my $pretty_fn = $out;
$pretty_fn =~ s/\.\.//;


print $outfh "% this is ../c/maize/demeter$pretty_fn\n
% generated on $now 
% by ../c/maize/crops/scripts/make_barcode_index.perl
% using the data in ../c/maize/barcodes/[0123][rng]/*.eps with additional
% filtering.
%
% Note the 06r inbred rows begin with I, so these are atoms.


% barcode_index(RowNumOrAtom,Crop,RowPlant,Plant,Family,PostColon,Barcode).\n\n";








# now pick it apart
#
# added letters for Addie Thompson's lines here and in the MaizeRegEx
#
# 4.8.2023

foreach my $barcode (@barcodes) { 

        if ( length($barcode) == 16 ) { $barcode =~ s/(:\w?)0(\d+)/$1$2/; }

    
        if ( ( length($barcode) == 15 ) && ( $barcode =~ /${num_gtype_re}/ ) ) {
    	        my ($crop,$family) = $barcode =~ /(${crop_re})(${family_re}):/;
                $family =~ s/^0//;
                my ($suffix) = $barcode =~ /(:.+)$/;
                my ($rowplant) = $suffix =~ /:[SWMBFGHXYZ]?(.+)$/;
                my ($prow,$plant) = $rowplant =~ /(.+)((\d{2}|xx|yy|xy|yx))$/;
                my ($row) = $prow;
                $row =~ s/^0{1,4}//;

#               print "$barcode $crop $family $suffix $rowplant $prow $row $plant\n";

	 
         	if ( $row =~ /I/ ) {	 
	                 print $outfh "barcode_index('$row','$crop','$rowplant','$plant',$family,'$suffix','$barcode').\n";
	                 } 
	          
	        else {
	                 print $outfh "barcode_index($row,'$crop','$rowplant','$plant',$family,'$suffix','$barcode').\n";
	                 } 
                }

	
        else { print "bad barcode: $barcode\n"; }
        }










1;
