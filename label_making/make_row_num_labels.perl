#!/usr/local/bin/perl

# this is . . . /maize/label_making/make_row_num_labels.perl

# generate labels for the row numbers to go on the seed packets; 
# derived from make_seed_packet_labels.perl
#
# This assumes all rows are represented in the packet_label_list.csv, mutants
# AND inbreds (but not sweet corn, which is no longer planted in assigned
# row numbers).  Rows are numbered from 1, not 0.
#
# Two output files are generated because the row labels are printed on yellow
# stickers, and the delay labels (for the sham packets) are printed on a different
# color sticker.
#
# Kazic, 8.11.2011

# call is make_seed_packet_labels.perl CROP PREFIX DELAY_INCREMT
#
# PREFIX doesn't need to be quoted, just the raw letter is fine.


# Since the packet_label_list now has the row numbers and the sequence numbers the
# same, this has been modified to eliminate the extra variable and use the packet_label_list.csv
# directly.  Call is still the same.
#
# Kazic, 4.11.2012


use Typesetting::DefaultOrgztn;
use Typesetting::MaizeRegEx;
use Typesetting::OrganizeData;
use Typesetting::TypesetGenetics;
use Typesetting::TypesettingMisc;
use Typesetting::GenerateOutput;


# $input_file = "packet_label_list.csv";
$input_file = "packing_plan.pl";

$file_stem = "row_num_labels";
$delay_file_stem = "row_num_delay_labels";

$input = $input_dir . $input_file;
$output = $output_dir . $file_stem . $tex_suffix;
$delay_output = $output_dir . $delay_file_stem . $tex_suffix;

$prefix = $ARGV[1];
$delay_incremt = $ARGV[2];


$name = "Kazic";
$institutn = "University of Missouri";


$i = 1;
$j = 0;







open(IN,"<$input") || die "can't open input $input\n";


while (<IN>) {
        chomp($_);
        $_ =~ s/\"//g;	        

        if ( $_ =~ /^packing_plan/ ) {

#	       ($rownum,$line,$rowseqnum,$plntg) = $_ =~ /^(\d+),([\w\d\s\:\.]+),([\w\d]+),(\d+)/;



#		($line,$rowseqnum,$plntg) = $_ =~ /,(${num_gtype_re}),${num_gtype_re},\d+,\d+,\w+,\d+,(\d+),(\d+)$/;


# regular expression still not right --- bowdlerized the input file for now
#
# Kazic, 11.11.2012

		($rowseqnum,$line,$plntg) = $_ =~ /(\d+),\d,(${num_gtype_re}),(\d+),.+$/;


               print "($line,$rowseqnum,$plntg)\n";


               $labels[$rowseqnum] = $rowseqnum . "::" . $plntg;
               if ( $plntg > 1 ) { $delays{$rowseqnum} =  $plntg; }
	       }
        }

close(IN);






# now have to make the latex files for the labels, moving over @labels

open(TAG,">$output");

&begin_latex_file(\*TAG);


for ( $i = 0; $i <= $#labels; $i++ ) {
        ($rowseqnum,$plntg) = split(/::/,$labels[$i]);

        if ( $plntg > 2 ) { $days_delay = $delay_incremt * ( $plntg - 1 ); }
        else { $days_delay = $delay_incremt; }



 #       print "$i,$rowseqnum,$plntg,$prefix,$delay_incremt,$name,$institutn,$i,$#labels\n";

        &print_row_num_label(\*TAG,all,$rowseqnum,$plntg,$prefix,$days_delay,$name,$institutn,$i,$#labels);
        }

&end_latex_file(\*TAG);

close(TAG);











open(DELAY,">$delay_output");

&begin_latex_file(\*DELAY);

$size = keys(%delays);



for $rowseqnum ( sort {$a<=>$b} keys %delays ) {

        $plntg = $delays{$rowseqnum};

        if ( $plntg > 2 ) { $days_delay = $delay_incremt * ( $plntg - 1 ); }
        else { $days_delay = $delay_incremt; }


#        print "$rowseqnum,$plntg,$days_delay,$j\n";

        &print_row_num_label(\*DELAY,delay,$rowseqnum,$plntg,$prefix,$days_delay,$name,$institutn,$j,$size);

        $j++;

        }


&end_latex_file(\*DELAY);

close(DELAY);







print "($output_dir,$file_stem,$ps_suffix,$pdf_suffix)\n";

&generate_pdf($output_dir,$file_stem,$ps_suffix,$pdf_suffix);
&generate_pdf($output_dir,$delay_file_stem,$ps_suffix,$pdf_suffix);




