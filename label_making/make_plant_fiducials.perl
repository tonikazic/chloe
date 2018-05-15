#!/usr/bin/perl

# this is make_plant_fiducials.perl

# generate labels to go on the plant as fiducial markers for 3D photography
# over 30-up labels
#
# Kazic, 25.5.09



# call has changed to make_seed_packet_labels.perl CROP
# Kazic, 17.10.07



use Typesetting::DefaultOrgztn;
use Typesetting::MaizeRegEx;
use Typesetting::OrganizeData;
use Typesetting::TypesetGenetics;
use Typesetting::TypesettingMisc;
use Typesetting::GenerateOutput;

 
$input_file = "~/me/chores/cmtes/karen_sendoff/global/present/fiducials/mod_georgics";
$file_stem = "fiducial_labels";


$input = $input_dir . $input_file;
$output = $output_dir . $file_stem . $tex_suffix;






open(IN,"<$input") || die "can't open input $input\n";


# packet num not in spreadsheet, though it could be; calculated here
#
# Kazic, 18.10.07

$i = 1;

while (<IN>) {
        chomp($_);
        $_ =~ s/\"//g;	        
        $_ =~ s/\'//g;	        


# cut the huge single line into "words" of size n
#
# stopped here


        if ( $_ !~ /^[\#\%\n]/ ) {

		
		
		
		
                ($barcode_out) = &make_barcodes($barcodes,$packet_num,$esuffix);
		

                $record = $barcode_out  . "::" . $family . "::" . $ma_num_gtype  . "::" . $pa_num_gtype . "::" . $sleeve . "::" . $cl . "::" . $ft;
#                 print "$record\n";
		
                for ( $j = 1; $j <= $num_packets_needed; $j++ ) { push(@labels,$record); }
                      
                $i++;
	        }
        }

close(IN);






# now have to make the latex files for the labels, moving over @labels

open(TAG,">$output");

&begin_latex_file(\*TAG);


for ( $i = 0; $i <= $#labels; $i++ ) {
        ($barcode_out,$row,$ma_num_gtype,$pa_num_gtype,$sleeve,$cl,$ft) = split(/::/,$labels[$i]);
        &print_seed_packet_label(\*TAG,$barcode_out,$row,$ma_num_gtype,$pa_num_gtype,$sleeve,$cl,$ft,$i,$#labels);
        }

&end_latex_file(\*TAG);

close(TAG);




&generate_pdf($output_dir,$file_stem,$ps_suffix,$pdf_suffix);




