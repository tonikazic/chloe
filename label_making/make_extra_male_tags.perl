#!/usr/local/bin/perl

# this is ../c/maize/label_making/make_extra_male_tags.perl

# generate the equivalent of tear-off tags for the field for those plants
# that we don't expect to have enough tags for, either because they are
# crossed or photographed before the plant tags have been produced, or
# because that plant was crossed more than thrice and we know that on other
# grounds.
#
# input file is full plantIds, one per line, sorted by rowplant for convenience
#
# over 30-up labels
#
# Kazic and Ngo, 15.10.2014
#
# revised and simplified: just make the tags and don't bother to count how
# many extras we might need
#
# Kazic, 30.7.2018


# call is ./make_extra_male_tags.perl CROP NUM_EXTRA_TAGS FLAG



use strict;
use warnings;


use Cwd 'getcwd';


use lib './Typesetting/';
use DefaultOrgztn;
use MaizeRegEx;
use OrganizeData;
use TypesetGenetics;
use TypesettingMisc;
use GenerateOutput;


my $num_extras = $ARGV[1];
my $flag = $ARGV[2];
my $local_dir = getcwd;
my ($dir,$input_dir,$barcodes,$tags_dir) = &adjust_paths($crop,$local_dir);



 



my $input_stem = "lab_lls_males";
my $tags_stem = "lab_lls_males_tags";


my $input_file = $input_dir . $input_stem;
my $output_file  = $tags_dir . $tags_stem . $tex_suffix;

# print "b: $barcodes\nif: $input_file\nof: $output_file\n";


my @labels;









open my $in, '<', $input_file  or die "can't open $input_file\n";
my (@lines) = grep { $_ !~ /%/ && $_ !~ /^\n/ && $_ !~ /\#/ } <$in>;




# multiplicative operator trick and syntax from
# https://www.perlmonks.org/?node_id=110603

for ( my $i = 0; $i <= $#lines; $i++ ) {

	my ($plant) = $lines[$i] =~ /^\'?(${num_gtype_re})\'?,?/;
#        print "$plant\n";

        my $barcode_out = &make_barcodes($barcodes,$plant,$esuffix);
	my $record = $barcode_out  . "::" . $plant;
        push @labels, ( $record ) x $num_extras;
        }


# foreach my $label (@labels) { print "$label\n"; }










# now have to make the latex files for the labels, moving over @labels

open my $tag, '>', $output_file or die "can't open $output_file\n";





&begin_latex_file($tag);

for ( my $i = 0; $i <= $#labels; $i++ ) {
        my ($barcode_out,$needed_num_gtype) = split(/::/,$labels[$i]);
        &print_tear_off_tag($tag,$barcode_out,$needed_num_gtype,$i,$#labels);
        }

&end_latex_file($tag);








if ( ( $flag eq 'q' ) || ( $flag eq 'test' ) ) { }
elsif ( $flag eq 'go' ) { &generate_pdf($tags_dir,$tags_stem,$ps_suffix,$pdf_suffix); }



