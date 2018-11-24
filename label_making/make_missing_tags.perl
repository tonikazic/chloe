#!/usr/bin/perl

# this is maize/label_making/make_missing_tags.perl

# generate the equivalent of tear-off tags for those that are missing
# from pollination bags
# over 30-up labels
#
# Kazic, 23.10.07

# call is ./make_missing_tags.perl CROP



use Typesetting::DefaultOrgztn;
use Typesetting::OrganizeData;
use Typesetting::TypesetGenetics;
use Typesetting::TypesettingMisc;
use Typesetting::GenerateOutput;



 


# $input_file = "row_list.csv";
# $input_file = "tags_needed";
$input_file = "tags_needed";
$file_stem = "tags_needed";



$input = $input_dir . $input_file;
$output = $output_dir . $file_stem . $tex_suffix;


$num_gtype_re = qr/[\w\:\.\-\s\;\?]{15}/;
$in_btwn_re = qr/[\w\*\-\+\.\/\s\{\}\|\;\(\)\?\^\,]*/;

$crop =~ tr/[a-z]/[A-Z]/;





open(IN,"<$input") || die "can't open input $input\n";


while (<IN>) {

        chomp($_);
        $_ =~ s/\"//g;	        
        $_ =~ s/,,/,/g;

#        ($ma_num_gtype,$pa_num_gtype) = $_ =~ /(${num_gtype_re}),(${num_gtype_re}),/;




        if ( ( $_ =~ /$crop/ ) && ( $_ !~ /\%/ ) ) { 
		($needed_num_gtype) = $_ =~ /^(${num_gtype_re})/;
                $barcode_out = &make_barcodes($barcodes,$needed_num_gtype,$esuffix);

#        $record = $barcode_out  . "::" . $needed_num_gtype  . "::" . $pa_num_gtype;
                $record = $barcode_out  . "::" . $needed_num_gtype;

#                print "$record\n";

                push(@labels,$record);
	        }
        }

close(IN);








# now have to make the latex files for the labels, moving over @labels

# print "out is $output\n\n **************************** \n\n";

open(TAG,">$output");


&begin_latex_file(\*TAG);

for ( $i = 0; $i <= $#labels; $i++ ) {
#        ($barcode_out,$needed_num_gtype,$pa_num_gtype) = split(/::/,$labels[$i]);
        ($barcode_out,$needed_num_gtype) = split(/::/,$labels[$i]);
        &print_tear_off_tag(\*TAG,$barcode_out,$needed_num_gtype,$i,$#labels);
        }

&end_latex_file(\*TAG);

close(TAG);


&generate_pdf($output_dir,$file_stem,$ps_suffix,$pdf_suffix);

