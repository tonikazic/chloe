#!/opt/perl5/perls/perl-5.26.1/bin/perl


# this is ../c/maize/label_making/make_seed_packet_labels.perl

# generate labels to go on the seed packets; this is the template for moving
# over 30-up labels
#
# Kazic, 6.1.2007



# this now includes packet number barcodes; ma and pa numerical genotypes;
# sleeve number for the ear; num cl; ft.  Omitted symbolic genotypes for
# now.
#
# Kazic, 17.10.2007



# modified to use output generated by pack_corn.pl, which exploits the new
# all-in-one packing_plan/10 fact.  This fact carries the row sequence number,
# number of packets needed, alternative parents, cross instructions, other instructions 
# or notes, number of cl and ft (since planting density now varies!), planting
# number, K number, and crop.  The goal is to simplify planting and avoid struggling
# with last-minute packet ordering and sham interpolation.  Packets are still generated
# in inventory order, but now the big number is either the family (for the inbreds) or the
# mutant row sequence number.  Of course, absolute row numbers depend on the field's layout, which
# is determined on planting day.
#
#
# Kazic, 24.4.2011


# port to 5.26 untested --- fix directory management, warnings, etc.
#
# works, but with a little kludging in Typesetting/TypesetGenetics.pm:print_seed_packet_label
#
# main thing is to fix the directory handling so the latex works correctly
#
# Kazic, 2.6.2019



# use strict;
# use warnings;


use lib './Typesetting/';


use DefaultOrgztn;
use MaizeRegEx;
use OrganizeData;
use TypesetGenetics;
use TypesettingMisc;
use GenerateOutput;



my $input_file = "../crops/19r/management/seed_packet_labels";

# $input_file = "resorted_guys_packet_label_list.csv";
# $input_file = "second_packet_label_list.csv";
# $input_file = "popcorn_packet_label_list.csv";
# $input_file = "sweet_corn_packet_label_list.csv";

my $file_stem = "../crops/19r/tags/packet_labels";
# $file_stem = "second_seed_packet_labels";


my $input = $input_dir . $input_file;
#my $output = $output_dir . $file_stem . $tex_suffix;
$output = "../crops/19r/tags/packet_labels.tex";
my $output_dir = "../crops/19r/tags/";
my $barcodes = "../barcodes/19r/";

# print "i: $input\no: $output\nb: $barcodes\n";

my $num_gtype_re = qr/[\w\:\.\-\s\;\?]*/;
my $in_btwn_re = qr/[\w\*\-\+\.\/\s\{\}\|\;\(\)\?\^\,]*/;







# packet num not in spreadsheet, though it could be; calculated here
#
# Kazic, 18.10.07
#
# previous comment obsolete!
# pack_corn/1 now generates the packet number, and skips the first 9 numbers to 
# leave those numbers for inbred lines.  So as needed, generate the input csv file
# for the inbred lines by hand (pretty easy!) and then use that as input here.
#
# for 11r only, B73 is treated as a mutant line since it is buried with the NAM founders
#
# Kazic, 24.4.2011
#
# pack_corn/1 now inserts the correct packet numbers for the inbred lines
#
# Kazic, 9.6.2014



open my $in, '<', $input_file  or die "can't open $input_file\n";

$i = 1;

while (<$in>) {
        chomp($_);
        $_ =~ s/\"//g;	        


# often data don't have sleeve locations, so we omit the (${sleeve_bag_re}) for now
#
# added
# Kazic, 19.4.08
#
#        ($row,$packet,$ma_num_gtype,$pa_num_gtype,$rest) = $_ =~ /^(\d*),?(${packet_re}),\d{0,4},\d{0,4},(${num_gtype_re}),(${num_gtype_re}),(.+$)/;
#        ($cl,$ft,$sleeve) = $rest =~ /(${cl_re}),(${ft_re}),(${sleeve_bag_re}),*$/;
#
#
# regular expression modified to accommodate packet lists generated by demeter/code/choose_lines:choose_lines/2
#
# Kazic, 16.5.09
#
# now modified to fit output of pack_corn:pack_corn/1
#
# Kazic, 24.4.2011

        if ( $_ !~ /^[\#\%\n]/ ) {

	       ($packet,$family,$ma_num_gtype,$pa_num_gtype,$cl,$ft,$sleeve,$num_packets_needed,$rowseqnum,$plntg) = $_ =~ /^,*(${packet_num_re}),(${family_re}),(${wierd_gtype_re}),(${wierd_gtype_re}),(${cl_re}),(${ft_re}),(${locatn_re}),(${cl_re}),(${family_re}),(${ft_re})$/;


#               print "($packet,$family,$ma_num_gtype,$pa_num_gtype,$cl,$ft,$sleeve,$num_packets_needed,$rowseqnum,$plntg)\n";
#               print "($packet,$sleeve,$rowseqnum)\n";


# if one needs to generate the packet numbers automatically, with different types of automation!
#
# Kazic, 16.5.09
#
#
# modified cases to conform more closely with likely output from choose_lines:choose_lines/2.
# I don't think these cases are disjoint or exhaustive, but I suspect there are too many cases considering
# the current predicate.
#
# Kazic, 2.6.2010
#
# have retained cases for now, despite switch to pack_corn:pack_corn/1
#
# Kazic, 24.4.2011

                if ( ( $packet !~ /p\d{0,5}/ ) && ( $packet !~ /^999/ ) && ( $packet !~ /^\d+/) ) {
#
# oops!  need to increment the packet num so that inbreds' and mutants' packet numbers don't overlap!
# This assumes that packet numbers for inbreds are separately generated, which they are; for inbreds,
# packet numbers are supplied and the penultimate clause applies.
#
# Kazic, 25.5.09
#
#
# incrementing now occurs in pack_corn.pl, so can use the packet numbers it generates
#
# Kazic, 24.4.2011
#
#
#                        $packet_num += 10;
                        $packet_num = &pad_row($i,5);
                        $packet_num = 'p' . $packet_num;
		        }
		
                elsif ( ( $packet =~ /^\d+/ ) && ( $packet !~ /^999/ ) ) {
#                        $packet_num += 10;
                        $packet_num = &pad_row($packet,5);
                        $packet_num = 'p' . $packet_num;
		        }


# packet numbers now accommodate addition of B73 to the set of inbred lines; the other
# NAM founders are treated as mutants for genotypic and planting purposes
#
# Kazic, 24.4.2011

		
                elsif ( $packet =~ /p0000[1234]/ ) { $packet_num = $packet; }

#        	elsif ( ( $packet !~ /^p/ ) && ( $packet =~ /^\d{0,5} ) ) { $packet_num = 'p' . $packet; }

		else { $packet_num = $packet; }
		
		
		
                ($barcode_out) = &make_barcodes($barcodes,$packet_num,$esuffix);
		
#               $record = $barcode_out  . "::" . $row  . "::" . $ma_num_gtype  . "::" . $pa_num_gtype . "::" . $sleeve . "::" . $cl . "::" . $ft;
                $record = $barcode_out  . "::" . $family . "::" . $ma_num_gtype  . "::" . $pa_num_gtype . "::" . $sleeve . "::" . $cl . "::" . $ft . "::" . $rowseqnum . "::" . $plntg;
#                 print "$record\n";
		
                for ( $j = 1; $j <= $num_packets_needed; $j++ ) { push(@labels,$record); }
                      
                $i++;
	        }
        }








# now have to make the latex files for the labels, moving over @labels
#
# shamelessly using global variables
#
# Kazic, 17.4.2018

open TAG, '>', $output  or die "can't open $output\n";


&begin_latex_file(\*TAG);


for ( $i = 0; $i <= $#labels; $i++ ) {
        ($barcode_out,$family,$ma_num_gtype,$pa_num_gtype,$sleeve,$cl,$ft,$rowseqnum,$plntg) = split(/::/,$labels[$i]);

        &print_seed_packet_label(\*TAG,$barcode_out,$family,$ma_num_gtype,$pa_num_gtype,$sleeve,$cl,$ft,$rowseqnum,$plntg,$i,$#labels);
        }

&end_latex_file(\*TAG);







print "($output_dir,$file_stem,$ps_suffix,$pdf_suffix)\n";

&generate_pdf($output_dir,$file_stem,$ps_suffix,$pdf_suffix);
