#!/usr/local/bin/perl

# this is maize/label_making/make_hydro_plant_labels.perl
#
# modelled on maize/label_making/make_leaf_tags.perl

# generate the labels to go on the styrofoam in front of each plant
#
# Kazic, 21.10.08


# call is make_hyrdo_plant_labels.perl CROP



use Typesetting::DefaultOrgztn;
use Typesetting::MaizeRegEx;
use Typesetting::OrganizeData;
use Typesetting::TypesetGenetics;
use Typesetting::TypesettingMisc;
use Typesetting::GenerateOutput;




$input_file = "plant_list.csv";
$file_stem = "hydro_plant_labels";




# likely to be local to each script, so just leave them here

$input = $input_dir . $input_file;
$output = $output_dir . $file_stem . $tex_suffix;




open(IN,"<$input") || die "can't open input file $input\n";


while (<IN>) {
        chomp($_);
        $_ =~ s/\"//g;	        
        $_ =~ s/\'//g;	        
        $_ =~ s/,,/,/g;

        ($barcode_elts,$prow,$max_plants,$family,$ma_family,$ma_num_gtype,$pa_family,$pa_num_gtype,$pma_ma_gma_gtype,$pma_ma_gpa_gtype,$pma_pa_gma_gtype,$pma_pa_mutant,$ppa_ma_gma_gtype,$ppa_ma_gpa_gtype,$ppa_pa_gma_gtype,$ppa_pa_mutant,$quasi_allele) = $_ =~ /^(${num_gtype_re}),(\d+),(\d+),(${family_re}),(${family_re}),(${num_gtype_re}),(${family_re}),(${num_gtype_re}),(${gtype_re}),(${gtype_re}),(${gtype_re}),(${gtype_re}),(${gtype_re}),(${gtype_re}),(${gtype_re}),(${gtype_re}),(${quasi_re})/;


        ($prow) = &pad_row($prow,5);
        ($prefix) = &get_family_prefix($family);
        ($pre_row) = &easy_row($prow,$prefix);

        for ( $plant = 1 ; $plant <= $max_plants ; $plant++ ) {
                ($pplant) = &pad_plant($plant);
                ($barcode_elts) = &make_plant_id($barcode_elts,$prow,$pplant);
                ($barcode_out) = &make_barcodes($barcodes,$barcode_elts,$esuffix); 


                $record = $barcode_out . "::" . $pre_row . "::" . $pplant . "::" . $family  . "::" .  $ma_num_gtype . "::" . $pa_family . "::" . $pa_num_gtype . "::" . $pma_ma_gma_gtype . "::" . $pma_ma_gpa_gtype . "::" . $pma_pa_gma_gtype . "::" . $pma_pa_mutant . "::" . $ppa_ma_gma_gtype . "::" . $ppa_ma_gpa_gtype . "::" . $ppa_pa_gma_gtype . "::" . $ppa_pa_mutant . "::" . $quasi_allele;

                push(@labels,$record);
	        }
        }

close(IN);








# now have to make the latex files for the labels, moving over @labels

&make_hydro_labels($output,$#labels,\@labels);
&generate_hydro_labels($output_dir,$file_stem);
