#!/usr/local/bin/perl

# this is ../c/maize/crops/scripts/make_prolog_packet_facts.perl

# convert the csv file of seed packet labels into prolog facts to see if
# everything was packed as planned.  See
# ../../demeter/code/pack_corn:planned_vs_packed/2 for the companion prolog
# predicate.
#
# Kazic, 2.6.2024



# call is ./make_prolog_packet_facts.perl CROP FLAG
#
# where CROP is the lowercased crop being planned, e.g., 24r,
#
# and FLAG is one of {go,q,test}.
#
# Can be called either from the command line or from
# ../../demeter/code/pack_corn:planned_vs_packed/2, but if from the command
# line, the paths here must be adjusted.
#
# Kazic, 2.6.2024


use strict;
use warnings;


use lib '../../label_making/Typesetting/';
use MaizeRegEx;


my $crop = $ARGV[0];
my $flag = $ARGV[1];


# if calling from this directory, path is ../$crop/management/seed_packet_labels.csv
#
# Kazic, 2.6.2024

=pod
my $input_file = "../../crops/$crop/management/seed_packet_labels.csv";
my $output_file = "../../crops/$crop/management/seed_packet_labels.pl";
=cut

my $input_file = "../$crop/management/seed_packet_labels.csv";
my $output_file = "../$crop/management/seed_packet_labels.pl";



open my $input_fh, '<', $input_file or die "sorry, can't open input file $input_file\n";
open my $output_fh, '>', $output_file or die "sorry, can't open output file $output_file\n";
my @foo = <$input_fh>;



# exclude inbreds, comments, and empty lines

my @planned = grep { /^${packet_re}/ && !/xxxxxx/ && !/\# / && !/^\n/ } @foo; 





foreach my $planned ( @planned ) {

#	print "$planned";

        my ($packet,$ma,$pa) = $planned =~ /^(${packet_re}),\d{4},(${num_gtype_re}),(${num_gtype_re})/;

#	print "($packet,'$ma','$pa')\n";

        if ( $flag eq 'test' ) { print "planned_packet($packet,'$ma','$pa').\n"; }	
        elsif ( $flag eq 'go' ) { print $output_fh "planned_packet($packet,'$ma','$pa').\n"; }
	elsif ( $flag eq 'q' ) { }
        }




close $input_fh;
close $output_fh;	



# thanks, Gabor!
# https://perlmaven.com/how-to-exit-from-perl-script

if ( ( $flag eq 'test' ) || ( $flag eq 'q' )  || ( $flag eq 'go' ) ) { exit 42; }
