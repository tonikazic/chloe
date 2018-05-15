#!/opt/perl5/perls/perl-5.26.1/bin/perl

# this is ../c/maize/crops/make_penult_inventory.perl
#
# given a file of the harvest facts for successful, un-discarded ears from
# a given crop, whether or not they have been manually sorted
# into their filing order, generate the initial versions of the inventory
# facts.  The sleeve numbers are then manually filled in.
#
# Before filling in the sleeve numbers, the file MUST be manually sorted
# into inventory order.  This warning is included in the comments to the
# file.
#
# The input file is assumed to be  CROP/management/proto_inventory, and 
# the output file is assumed to be CROP/management/penult_inventory.
#
# Kazic, 26.10.2012
#
#
# these two files now generated by the script
#
# Kazic, 10.3.2015
#
#
# make the output file group-writable
#
# Kazic, 24.3.2015


# fix lingering ' cl' and removal of '\d0 cl'
#
# Kazic, 24.3.2015



# call is perl ./make_penult_inventory.perl CROP


# port to 5.26 untested
#
# Kazic, 17.4.2018



use strict;
use warnings;


use lib './Typesetting/';

use DefaultOrgztn;
use MaizeRegEx;



my $crop = $ARGV[0];
my $today = `date`;
my $foo = `date "+%Y.%m.%d.%H.%M.%S"`;
chomp($foo);
my ($year,$month,$day,$hour,$min,$sec) = split(/\./,$foo);
chomp($today);



# I'm too lazy to parse! ;-)  But now I'm too lazy to struggle with modules.
#
# use Date::Calc qw(Today_and_Now) ;
# ($year,$month,$day,$hour,$min,$sec) = Today_and_Now();




# added generation of proto_inventory_file
#
# Kazic, 10.3.2015

my $proto_inventory_file = $input_dir . "proto_inventory_file";
$proto_inventory_file =~ s/\.\.\/crops\///g;
my $penult_inventory_file =~ s/proto/penult/;
my $harvest_file = $demeter_dir . "harvest.pl";
$harvest_file =~ s/\.\.\///;


my $grep_crop = uc($crop);

if ( ! -e $proto_inventory_file ) {
        my $cmd = "grep $grep_crop $harvest_file | grep -v '0 cl' | grep -v failed | grep -v discarded > $proto_inventory_file";
        print "now executing $cmd\n";
        system($cmd);
        }




open $in, '<', $proto_inventory_file or die "can't open $proto_inventory_file\n";
open $out, '>', $penult_inventory_file or die "can't open $enult_inventory_file\n";


print $out "% this is ../crops/$penult_inventory_file 
%
% generated on $today by ../crops/make_penult_inventory.perl
% from the input file of retained ears or kernels:
% ../crops/$proto_inventory_file.
%
% Packets from pollinations that failed have been retained if they have a few kernels.
% However, these are very suspect and should only be used in dire emergency.
%
% Data must still be manually sorted into inventory order.
% 
% Sleeve numbers must still be manually inserted, and the completed file appended to
% ../demeter/data/inventory.pl!\n\n
% inventory(MaPlantID,PaPlantID,NumKernels,Observer,Date,Time,v00).\n\n\n";




# harvest('12R0629:0012806','12R0629:0012805',succeeded,'half',derek,date(03,09,2012),time(13,16,43)).
# inventory('06R200:S000I104','06R0055:0005515',num_kernels(11),dylan,date(11,1,2008),time(13,55,43),v00001).
#
# Fri Oct 26 20:10:07 CDT 2012


while (<$in>) {

        if ( $_ !~ /^harvest/ ) { print $out $_; }

        else {


# we're now including failed ears with a few kernels, even though these are
# very suspect.
#
# Kazic, 10.3.2015
#
#                ($ma,$pa,$comment,$observer) = $_ =~ /\'(${num_gtype_re})\',\'(${num_gtype_re})\',succeeded,\'?(${notes_re})\'?,(${observer_re})/;

                my ($ma,$pa,$comment,$observer) = $_ =~ /\'(${num_gtype_re})\',\'(${num_gtype_re})\',\w{6,9},\'?(${notes_re})\'?,(${observer_re})/;

#                print "$ma,$pa,$comment,$observer\n";

                if ( ( $comment eq "_" ) || ( $comment eq "whole" ) )  { $num_cl = whole; }
                elsif ( $comment =~ /${word_cl_re}/ ) { ($num_cl) = $comment =~ /(${word_cl_re})/; }
                else { my ($num_cl) = $comment =~ /(\d+ cl)/; }

#                print "$ma :$comment: $num_cl\n";

                print $out "inventory(\'$ma\',\'$pa\',num_kernels($num_cl),$observer,date($day,$month,$year),time($hour,$min,$sec),v00).\n";

                }       
        }








chmod 0664, $penult_inventory_file; 
