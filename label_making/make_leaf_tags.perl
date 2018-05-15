#!/usr/bin/perl

# this is maize/label_making/make_leaf_tags.perl

# generate leaf emergence tag labels to go on the small shipping tags
#
# Kazic, 1.7.07

# We didn't get the Avery tags in time, so I improvised what turned out to be a 
# superior tag.
#
# tags can be constructed as follows:
#
#  1.  buy reams of 110 lb cardstock (ivory is nice)
#  2.  using a 1/4" augur 6" long bit, drill two holes near the top of each tag.
#      The local Staples takes 3 -- 5 days to drill the holes because they must 
#      send these out.  It would be nicest to use a drill press for
#      this step:  talk with Rex Gish.
#  3.  tags are laid out 1 3/8" wide x 4" long, 16 up, so that pair of holes is 
#      centered; have cardboard template for this, a 3/16" thick plywood template
#      would be better.
#  4.  have Staples cut the tags; they can do this in 24 hours.  They claim they 
#      can preserve order, so next time I will try printing directly onto the tags
#      to save attaching the printed Avery labels; this more room for the leaf 
#      emergence table.  Thread dowels or wires through each stack to 
#      keep them in order during transport.
#  5.  fold tag between holes (can do this ~6 at a time)
#  6.  thread 9" red twist-tie through holes, match ends, pull flat, squeeze 
#      together, spreading slightly into a V (this also finishes folding the tag), 
#      twist several times
#  7.  attach printed label
#  8.  bundle into families using recycled white twist ties.  Some prefer to bundle
#      first, then label; others vice-versa
#  9.  hang family bundles on metal clothes hanger in order, hang hangers in order
#       on rod for transport to field
#
# Inquire with printing services how fast and at what cost they could do 1 -- 4, and 
# whether they could do the printing quickly enough.


# in the next version, grab the $cl and use that to set the plant number
#
# Kazic, 8.7.07



# It turns out the table is worthless and the Avery tag goes nicely around the fifth-leaf twist tie, 
# lasting for most of the summer.  So no need for cardstock!
#
# Kazic, 1.9.08



# call is make_leaf_tags.perl CROP



use Typesetting::DefaultOrgztn;
use Typesetting::MaizeRegEx;
use Typesetting::TypesetGenetics;
use Typesetting::TypesettingMisc;
use Typesetting::GenerateOutput;




# $input_file = "plant_list.csv";
# $input_file = "reprint_list.csv";
# $input_file = "first_inbred_plant.csv";
$input_file = "first_plant_third_planting.csv";

# $file_stem = "leaf_tags";
# $file_stem = "reprint_leaf_tags";
# $file_stem = "first_inbred_leaf_tags";
# $file_stem = "first_plant_third_planting_tags";
$file_stem = "test";



# likely to be local to each script, so just leave them here

$input = $input_dir . $input_file;
$output = $output_dir . $file_stem . $tex_suffix;


# local redefinitions

$family_re = qr/\d*/;
$num_gtype_re = qr/[\w\:\.\-\s\;\?]*/;




open(IN,"<$input") || die "can't open input file $input\n";


while (<IN>) {
        chomp($_);
        $_ =~ s/\"//g;	        
        $_ =~ s/,,/,/g;

        ($barcode_elts,$prow,$pplant,$family,$ma_family,$ma_num_gtype,$pa_family,$pa_num_gtype,$pma_ma_gma_gtype,$pma_ma_gpa_gtype,$pma_pa_gma_gtype,$pma_pa_mutant,$ppa_ma_gma_gtype,$ppa_ma_gpa_gtype,$ppa_pa_gma_gtype,$ppa_pa_mutant,$quasi_allele) = $_ =~ /^(${num_gtype_re}),(\d{5}),(\d{2}),(${family_re}),(${family_re}),(${num_gtype_re}),(${family_re}),(${num_gtype_re}),(${gtype_re}),(${gtype_re}),(${gtype_re}),(${gtype_re}),(${gtype_re}),(${gtype_re}),(${gtype_re}),(${gtype_re}),(${quasi_re})/;


# for mutants

#        if ( $family =~ /\d{4}/ ) {

# for first inbred plant; quickie inventory to minimize unnecessary printing, manufacture, and placement 
# of plant tags

        if ( $family =~ /\d{3}/ ) {

                $barcode_out = $barcodes . $barcode_elts . $esuffix;
                system("/usr/local/bin/barcode -c -E -b $barcode_elts -u in -g \"2.25x0.75\" -e 128 -o $barcode_out");
                ($row) = $prow =~ /\d(\d{4})/;
		$record = $barcode_out  . "::" . $row . "::" . $pplant;
                push(@labels,$record);
	        }
        }

close(IN);








# now have to make the latex files for the labels, moving over @labels

open(TAG,">$output") || die "can't open output file $output\n";;

&begin_latex_file(\*TAG);

for ( $i = 0; $i <= $#labels; $i++ ) {
        ($barcode_out,$row,$pplant) = split(/::/,$labels[$i]);
        &print_leaf_tag_label(\*TAG,$barcode_out,$row,$pplant,$i,$#labels);
        }

&end_latex_file(\*TAG);

close(TAG);




&generate_pdf($output_dir,$file_stem,$ps_suffix,$pdf_suffix);









