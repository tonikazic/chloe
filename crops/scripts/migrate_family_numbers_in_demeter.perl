#!/usr/local/bin/perl


# this is ../c/maize/crops/scripts/migrate_family_numbers_in_demeter.perl


# tabled for now
#
# Kazic, 3.9.2022



use strict;
use warnings;

use Cwd 'getcwd';



# current as of 30.1.2022, but I don't think I understand the family numbers correctly!
#
# Kazic, 30.1.2022

my %migrants = ('1109' => '1155',
		'1434' => '1159',
		'4477' => '703',
		'4231' => '704',
               );




for my $old (keys %migrants) { print "old is $old and new is $migrants{$old}\n"; }




# use List::Regexp qw(:all);
