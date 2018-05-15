#!/opt/perl5/perls/perl-5.26.1/bin/perl

# this is ../c/maize/crops/scrips/make_possibly_missing_data.perl



# from the barcodes generated for use in a crop's plant tags, make
# possibly_missing_data/5 facts and append these to 
# ../../demeter/data/possibly_missing_facts.pl
#
#
# call is make_possibly_missing_data CROP
#
# Kazic, 14.5.2018
#



use strict;
use warnings;


use lib '../../label_making/Typesetting/';

use DefaultOrgztn;
use OrganizeData;



my $crop = $ARGV[0];
my $barcodes = $dir_step . $barcodes;
my $output_file = $demeter_dir . "possibly_missing_data.pl";

# print "b: $barcodes\n";
# print "o: $output_file\n";

my @barcodes;
my $out;
my @facts;





opendir my $bdh, $barcodes or die "can't open the barcode directory $barcodes\n";

# gets just the mutants, not inbreds, landraces, or fun corn, since
# these are easily produced by hand

@barcodes = grep { $_ =~ /$crop/i && $_ !~ /[SWMBLE]/ && $_ =~ s/\.eps//g } readdir $bdh;
foreach my $barcode (@barcodes) { print "$barcode\n"; }
closedir $bdh;



# ok, now honk through the names






# open my $out, '>>', $output_file or die "can't open $output_file\n";
