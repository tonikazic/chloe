#!/opt/perl5/perls/perl-5.26.1/bin/perl

# this is ../c/maize/data/data_conversion/patch_num_gtypes.perl

# a quick script to patch numerical genotypes in any raw data file,
# assuming that the first and perhaps the second column contain the data.
#
#
# Most critically, right now the script assumes that A RAW DATA FILE
# CONTAINS DATA FOR A SINGLE CROP.  This might not always be the case.
# For example, re-inventorying a collection might put ears from different
# crops in the same spreadsheet, causing dangerous mis-assignment when the
# numerical genotypes are patched.
#
# For now, I have not implemented any checks for this issue.  If both
# barcodes are absent, one can only rely on the context around the bad
# entry and any available physical evidence.
#
#
#
# The script assumes that the rowplant identifier is given if a barcode
# can't be scanned or we didn't have a tag for a fecund male, which for us
# is the last 5 digits of the numerical genotype.  Usually, leading zeroes
# are not entered or preserved in numerical data in spreadsheet apps.  If a
# floating point number is given --- for example, the family of an inbred
# as the characteristic and the rowplant identifier as the mantissa ---
# only the mantissa is used, since every rowplant is unique in our crops.
# Other schemes for numerical genotypes may not share this property.
#
#
# If an untagged plant is used, just create a dummy .eps file of the correct
# name in the appropriate directory.  I include a comment in the file so that
# eps display should crash and we can remember why.
#
#
# one-liner to remove ^Ms from input file:
# https://www.perlmonks.org/?node_id=872630
# perl -pi -e 'tr[\r][]d' file
#
#
# there are two modes:  one to prepare the hash for storing ("prep") and
# the other to patch the data ("patch").
#
# call is ./patch_num_types.perl CROP MODE RELPATH_TO_DATA_FILE
#
# where CROP is the crop from which the data are drawn, not when the data
# were collected.
#
# Kazic, 17.5.2018



use strict;
use warnings;

use Storable qw( nstore retrieve );



use lib '../../label_making/Typesetting/';
use DefaultOrgztn;
use MaizeRegEx;
use TypesettingMisc;



my $crop = $ARGV[0];
my $flag = $ARGV[1];
my $input_data_file = $ARGV[2];



my $barcodes_dir = $dir_step . $barcodes;
my $out = $barcodes_dir . "barcodes_hash";
my %barcode_hash;


my $patch_file = $input_data_file;
$patch_file =~ s/raw\./patched\./;
# print "i: $input_data_file p: $patch_file\n";

my $fixes_file = $dir_step . "../crops/inventory/management/needed_". lc($crop) . "_harvest_tags.csv"; 



# storing regexs:
# http://www.perlmonks.org/bare/?node_id=341017

my $grab_regex;
my $test_regex;
my $num_cols;









# make a hash of all the numerical genotypes in a barcode directory, and
# store it there.  Since this is used to generate the plant tags, should
# only need to do this once/crop.
#
# http://www.perlmonks.org/?node_id=510202 and links therein for Storable
#
# errrrrr, and:
#
# perlbrew use 5.26.1
# su
# cpan Storable
#
# to get the module into the right perl for all users



if ( $flag eq "prep" ) {

        opendir my $bdh, $barcodes_dir or die "can't open the barcode directory $barcodes_dir\n";
        my @barcodes = grep { $_ =~ /$crop/i && $_ =~ s/\.eps//g } readdir $bdh;
        closedir $bdh;

        foreach my $barcode (@barcodes) { 
                my ($rowplant) = $barcode =~ /(\d{5})$/;
                $barcode_hash{$rowplant} = $barcode;
	        }

	
#        foreach my $key ( sort keys %barcode_hash ) { print "$key $barcode_hash{$key}\n"; }
	
        nstore \%barcode_hash, $out;
        }








# now use the prepped hash to patch the numerical genotypes in the file
# directly get the hash re-assigned to its variable, rather than the reference
# to the hash

if ( $flag eq "patch" ) {

        %barcode_hash = %{retrieve($out)};

	
        open my $in, '<', $input_data_file or die "sorry, can't open input file $input_data_file\n";
        my @lines = <$in>;


	my ($first_col,$secnd_col,$rest) = split(/,/,$lines[0],3);
        if ( $rest =~ /[plant|ma|pa][\s\_]?ID/i ) { print "Warning! numerical genotypes may be in other columns.\n"; }

	
	if ( ( $first_col =~ /[plant|ma|pa][\s\_]?ID/i ) 
             && ( $secnd_col =~ /[plant|ma|pa][\s\_]?ID/i ) ) { 
                $grab_regex = qr/\"?([\w\:]+)\"?,\"?([\w\:]+)\"?,(.+)$/; 
                $test_regex = qr/^${num_gtype_re}\"?,\"?${num_gtype_re}\"?,/;
                $num_cols = 1;
                }

	elsif ( $first_col =~ /[plant|ma|pa][\s\_]?ID/i ) { 
                $grab_regex = qr/([\w\:]+),(.+)$/; 
                $test_regex = qr/^${num_gtype_re}\"?,/;
                $num_cols = 0;
                }

	else { print "Warning! no plant ids found.\n"; }
	



	
        open my $fixesfh, '>', $fixes_file or die "sorry, can't open the file of fixed barcodes $fixes_file\n";	
        open my $pfh, '>', $patch_file or die "sorry, can't open the patched output file $patch_file\n";

        my $now = `date`;
	chomp($now);
	
	print $fixesfh "# this is ../c/maize/data/$fixes_file
#
# generated on $now
# by ../c/maize/data/data_conversion/patch_num_gtypes.perl using
# ../c/maize/data/$input_data_file as source.\n\n\n";


	print $pfh "# this is ../c/maize/data/$patch_file
#
# generated on $now
# by ../c/maize/data/data_conversion/patch_num_gtypes.perl using
# ../c/maize/data/$input_data_file as source.\n\n\n";

	print $pfh $lines[0];
	
        foreach my $i ( 1 .. $#lines ) {
	        if ( $lines[$i] =~ $test_regex ) { print $pfh $lines[$i]; }

                else { 
                       my (@data) = $lines[$i] =~ $grab_regex;
#                       print "$i: \t" . join(" | ",@data) . "\n";

		       
                       my $out_string;

                       foreach my $j ( 0 .. $num_cols ) { 

  			       if ( $data[$j] =~ $num_gtype_re ) { $out_string .= "$data[$j],"; }

                               else {
			               my $pkey = pad_row($data[$j],5);
                                       my $patch = $barcode_hash{$pkey};
				       $out_string .= "$patch";
				       }				    
                               }

                       my ($ma) = $out_string =~ /^(${num_gtype_re})/;		       
                       my $fixes_string = "$out_string$ma,";
                       print $fixesfh "$fixes_string\n";



# why I can't say 
# print "$i: $out_string $data[$#data]\n";		       
# completely escapes me.  So an intermediate variable.
#
#
# there is also something funky:  without the preceeding print
# we get ^Ms in the file, even after the one-liner.  So something is
# not robust.
#
#
# Kazic 17.5.2018
#
		       print "$i: $out_string\n";
#		       print "$i: $data[$#data]\n";
		       my $foo = $out_string . $data[$#data];
                       print $pfh "$foo\n";
                       }
                }
        }

