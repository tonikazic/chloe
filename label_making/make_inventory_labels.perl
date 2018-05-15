#!/opt/perl5/perls/perl-5.26.1/bin/perl

# this is ../c/maize/label_making/make_inventory_labels.perl

# beats me why, but call with the perl on the command line, thus:
#
# /opt/perl5/perls/perl-5.26.1/bin/perl make_inventory_labels.perl i v 1 510
#
# there must be a hidden character someplace I've not removed.
#
# Kazic, 27.4.2018



# generate labels to go on the boxes and the sleeves.  The boxes are
# 10-up labels, the sleeves 30-up labels.  Each one is a separate set of
# routines, activated by a call from the command line.
#
# call for boxes is make_inventory_labels.perl i x STARTBOX ENDBOX 
#
# call for sleeves is make_inventory_labels.perl i v STARTSLEEVE ENDSLEEVE
#
# call for bags is make_inventory_labels.perl i a STARTBAG ENDBAG
#
# call for pots is make_inventory_labels.perl i t STARTPOT ENDPOT
#
# Kazic, 26.9.07
#
# added pots to prevent future greenhouse confusion
#
# Kazic, 14.1.2008




# converted to run in perl 5.26
#
# Kazic, 27.4.2018


use strict;
use warnings;


use lib './Typesetting/';
use DefaultOrgztn;
use OrganizeData;
use TypesetGenetics;
use TypesettingMisc;
use GenerateOutput;



my $type = $ARGV[1];
my $start = $ARGV[2];
my $stop = $ARGV[3];

my $file_stem;


if ( $type eq "x" ) { $file_stem = "box_labels"; }
elsif ( $type eq "v" ) { $file_stem = "sleeve_labels"; }
elsif ( $type eq "a" ) { $file_stem = "bag_labels"; }
elsif ( $type eq "t" ) { $file_stem = "pot_labels"; }


my $output = $output_dir . $file_stem . $tex_suffix;






# master list of boxes, their crops, maternal lines, and comments
# check this against actual boxes and correct as needed
#
# I'm NOT worrying about the year 2100 problem ;-)!


# revise this list and shift to DefaultOrgztn, or
# remove altogether
#
# Kazic, 27.4.2018

my %boxes = (   0 => 'fdtnl::seed gifts,;;06R, 06N inbreds;;bags 1--8',
             1 => '06R::Mo20W mutants,;; inbreds;;sleeves 1--7',
             2 => '06R::Mo20W, W23;;mutants, inbreds;;sleeves 8--14',
             3 => '06R::W23, M14 mutants,;; inbreds;;sleeves 15--21',
             4 => '06R::M14 mutants,;;inbreds, Gerry hets,;;MGCSC sibs;;sleeves 22--28',
             5 => '06N::Mo20W lines;;sleeves 29--35',
             6 => '06N::Mo20W lines;;sleeves 36--42',
             7 => '06N::Mo20W lines;;sleeves 43--48',
             8 => '06N::W23 lines;;sleeves 49--55',
             9 => '06N::W23 lines;;sleeves 56--62',
            10 => '06N::W23 lines;;sleeves 63--69',
            11 => '06N::W23, M14 lines;;sleeves 70--76',
            12 => '06N::M14 lines;;sleeves 77--83',
            13 => '07R::Mo20W lines;;sleeves 84--90',
            14 => '07R::Mo20W lines;;sleeves 91--97',
            15 => '07R::Mo20W, W23 lines;;sleeves 98--104',
            16 => '07R::W23 lines;;sleeves 105--111',
            17 => '07R::W23, M14 lines;;sleeves 112--118',
            18 => '07R::M14 lines;;sleeves 119--125',
            19 => '07R::M14 lines, selfs;;sleeves 126--132',
            20 => 'next box!',
         99998 => '50r::W;;sleeves --',
         99999 => '99n::S;;sleeves --' ); 



my (@labels) = &make_inventory_labels($type,$start,$stop,$crop,\%boxes);




open(TAG,">$output");

&begin_small_label_latex_file(\*TAG);


# nb:  picture not closed properly, but file runs ok
#
# Kazic, 17.6.2009

for ( my $i = 0; $i <= $#labels; $i++ ) {
        my ($type,$barcode_out,$crop,$box,$comment,$sleeve) = split(/::/,$labels[$i]);
        if ( $type eq "x" ) { &print_box_label(\*TAG,$barcode_out,$box,$crop,$comment,$i,$#labels); }
        elsif ( $type eq "v" ) { &print_sleeve_label(\*TAG,$barcode_out,$sleeve,$i,$#labels); }
        elsif ( $type eq "a" ) { &print_sleeve_label(\*TAG,$barcode_out,$sleeve,$i,$#labels); }
        elsif ( $type eq "t" ) { &print_pot_label(\*TAG,$barcode_out,$sleeve,$i,$#labels); }
        }

&end_latex_file(\*TAG);


close(TAG);


&generate_pdf($output_dir,$file_stem,$ps_suffix,$pdf_suffix);





