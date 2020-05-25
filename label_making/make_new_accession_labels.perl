#!/usr/local/bin/perl

# this is make_new_accession_labels.perl
#
# Kazic, 25.5.09

# A script to generate the labels that go on the packets of corn sent by others.
#
# The crop in which the seed is first planted is used as the crop; family numbers
# and the numerical genotypes of others are from genotype.pl; and my numerical
# genotypes are of the form (crop)(family):0000000, where family is a four digit number.
#
#
# The input data file lives in the crops/inventory subdirectory; it is a copy of 
# demeter/data/source.pl, edited to remove lines that don't need labels and to insert the crops.
#
#
# This script takes a comma-delimited file dumped from a spreadsheet or
# database, generates a 128 bit bar code for each female and male using the GNU
# barcode library, puts the bar code in an encapsulated PostScript file,
# and then generates a label for the bag of inbred seed with genotypic information and
# harvesting instructions for each pollinated ear in the database.  A LaTeX
# file with the tag information is generated and processed to produce a
# PostScript file.  This file can be printed directly or converted into PDF
# with any suitable viewer and printed from there.


# call is ./make_new_accession_labels.perl i


use Typesetting::DefaultOrgztn;
use Typesetting::MaizeRegEx;
use Typesetting::Utilities;
use Typesetting::OrganizeData;
use Typesetting::TypesetGenetics;
use Typesetting::TypesettingMisc;
use Typesetting::GenerateOutput;




# $input_stem = "new_accessions.pl";
# $input_stem = "popcorn_accessions.pl";
$input_stem = "new_11r_accessions.pl";
# $tags_stem = "new_accessions_labels";
# $tags_stem = "popcorn_accessions_labels";
$tags_stem = "new_11r_accessions_labels";




$input_file = $input_dir . $input_stem;
$output_file = $output_dir . $tags_stem . $tex_suffix;


open(IN,"<$input_file") || die "can't open $input_file\n";

while (<IN>) {

        if ( $_ !~ /^[#%\n]/ ) {

                ($family,$num_gtype,$crop) = $_ =~ /new\_accession\((\d+),\'?(${wierd_gtype_re})\'?,\'?${wierd_gtype_re}\'?,\'?(${crop_re})\'?/;


# kludge for necessarily too-general regular expression

                $num_gtype =~ s/\'$//;


                if ( $num_gtype !~ /${num_gtype_re}/ ) { $my_num_gtype = &make_num_gtype($family,$crop); }
                else { $my_num_gtype = $num_gtype; }


                $barcode_file = &make_barcodes($barcodes,$my_num_gtype,$esuffix);

                $record = $family . "::" . $barcode_file . "::" . $num_gtype . "::" . $crop;

#                print "$record\n";

                push(@lines,$record);

                $num_gtype = "";
                $my_num_gtype = "";
                $record = "";
                $family = "";
                $crop = "";
                $barcode_stem = ""; 
                $barcode_file = ""; 
	        }
        }

close(IN);









# now have to make the latex files for the labels, moving over @lines

open(TAG,">$output_file");

&begin_latex_file(\*TAG);




for ( $i = 0; $i <= $#lines; $i++ ) {
        ($family,$barcode_file,$num_gtype,$crop) = split(/::/,$lines[$i]);
        &print_accession_packet_label(\*TAG,$barcode_file,$family,$num_gtype,$crop,$i,$#lines);
        }

&end_latex_file(\*TAG);

close(TAG);





&generate_pdf($output_dir,$tags_stem,$ps_suffix,$pdf_suffix);


















