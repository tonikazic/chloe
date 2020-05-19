#!/usr/local/bin/perl

# this is . . . /maize/demeter/data/make_zero_inventory_facts.perl
#
# We wrote this because when we re-inventoried the corn in the winter of 2014, we discarded corn
# without recording inventory facts.
#
# On May 24--26, 2014, we went back and looked for that corn.  We now have a file of barcodes
# of corn that were not found.  We want to insert a fact for that corn in the inventory, if
# such a fact is not already present.
#
# call is perl ./make_zero_inventory_facts.perl ZERO_TAGS_FILE OUTPUT_FILE
# where the FILES have paths relative to this directory.  
#
# The ZERO_TAGS_FILE is the file of scanned tags for which no corn was found in May 23--26, 2014.
#
# I have hard-wired:
#
# the location of the zero_kernels file (file with all old num_kernels(0) facts);
# the sleeve of the empty packets (v00000);
# and the time of the inventory.  
#
# The date of the inventory fact is the date this script is run.
#
# call is ./make_zero_inventory_facts.perl NO_CORN_FILE OUTPUT_FILE
#
# where both files have paths relative to here.
#
# Kazic, 27.5.2014


# coding notes:
#
# http://perldoc.perl.org/perlsyn.html for !open, !defined, so hope it holds for !exists
# http://www.perlmonks.org/?node_id=1018739 for no autovivification when checking for non-existent hash key
# installed autovivification, see /athe/b/artistry/lab_systems/software/perl_modules.org





use Date::Calc qw(Delta_Days Add_Delta_Days Today Day_of_Year);
use autovivification;


use lib qw(../label_making/);
use Typesetting::MaizeRegEx;
use Typesetting::DefaultOrgztn;

$old_zeroes_file = '/athe/c/maize/data/reinventory/zero_kernels';


$input = $ARGV[0];
$output = $ARGV[1];


$today = `date`;
chomp($today);
($todayyear,$todaymonth,$todayday) = &Today;







# For each packet not found in May, 2014 (%zeroes), if we already have a fact for
# it (%old_zeroes), then don't do anything.  Otherwise, generate a new inventory
# fact with today's date and hard-wired sleeve and time.


open(IN,"<$input") or die "can't open input file $input\n";;

while (<IN>) {
        my ($zma,$zpa) = $_ =~ /\'?(${num_gtype_re})\'?,\'?(${num_gtype_re})\'?/;
        $zeroes{$zma} = $zpa;
        }


close(IN);








open(Z,"<$old_zeroes_file") or die "can't open zeroes file $zeroes_file\n";

while (<Z>) {

        my ($nma,$npa) = $_ =~ /inventory\(\'?(${num_gtype_re})\'?,\'?(${num_gtype_re})\'?,/;
        $old_zeroes{$nma} = $npa;
        } 

close(Z);


# while( my ( $key, $value ) = each %old_zeroes ) { print "$key: $value\n"; }




open(OUT,">$output") or die "can't open output file $output\n";;;

print OUT "% this is $output generated on $today by \n% /athe/c/maize/crops/make_zero_inventory_facts.perl\n% using $input as the source file.\n%\n";
print OUT "% this file lists novel inventory facts for offspring that had no corn as of today.\n\n\n";



no autovivification;

foreach $ma ( sort (keys %zeroes ) ) {

         if ( exists $old_zeroes{$ma} ) {  
                 if ( $old_zeroes{$ma} == $zeroes{$ma} ) { print "have same corn old_zeros $ma x $old_zeroes{$ma}\n"; }
                 
                 else { print "Warning! old zeroed corn, $ma x $old_zeroes{$ma}, and new, $ma x $zeroes{$ma}, do not match!\n";  }
	         }

#         else { print "inventory('" . $ma . "','" . $zeroes{$ma} . "',num_kernels(0),derek,date(" . $todayday . "," . $todaymonth . "," . $todayyear . "),time(12,00,00),v00000).\n"; }

         else { print OUT "inventory('" . $ma . "','" . $zeroes{$ma} . "',num_kernels(0),derek,date(" . $todayday . "," . $todaymonth . "," . $todayyear . "),time(12,00,00),v00000).\n"; }


        }
