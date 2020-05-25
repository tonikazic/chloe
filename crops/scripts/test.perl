#!/usr/local/bin/perl



# this is ../c/maize/crops/scripts/test.perl
#
# testing subroutine for setting directories
#
#
# call is: ./test.perl CROP
#
#
# Kazic, 19.6.2018



use strict;
use warnings;

use Cwd 'getcwd';


use lib '../../label_making/Typesetting/';
use DefaultOrgztn;




# our $crop = $ARGV[0]; in DefaultOrgztn


my $local_dir = getcwd;
# print "ld: $local_dir\n";
my ($dir,$input_dir,$barcodes) = &adjust_paths($crop,$local_dir);

print "d: $dir\ni: $input_dir\nb: $barcodes\n";
