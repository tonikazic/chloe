#!/usr/local/bin/perl

# this is maize/label_making/make_flags.perl


# This script takes a comma-delimited file dumped from a spreadsheet and 
# generates the stake flags, with the plant tag barcodes, for the pots.
#
# Kazic, 24.2.08.


# call is ./make_flags CROP


use Typesetting::DefaultOrgztn;
use Typesetting::MaizeRegEx;
use Typesetting::AuxiliaryFiles;
use Typesetting::OrganizeData;
use Typesetting::TypesetGenetics;
use Typesetting::TypesettingMisc;
use Typesetting::GenerateOutput;






$input_stem = "plant_list.csv";


$tags_stem = "stake_flags";


$input_file = $input_dir . $input_stem;
$output_file = $output_dir . $tags_stem . $tex_suffix;








open(IN,"<$input_file") || die "can't open $input_file\n";

while (<IN>) {

# probably obsolete given the progressive refinement of the regular expressions
#
# Kazic, 8.11.07

        clean_line($_);


# the original 06r families will not match $family_re for the male parent, only
# $original_family_re.  Toggle this condition as needed.
#
# Kazic, 19.7.07

        if ( $_ !~ /^\#/ ) {



# for 06N -- 07R and others' funny genotypes! Note alternation of ${num_gtype_re} and ${wierd_gtype_re}

                ($barcode_elts,$pot,$family,$ma_num_gtype,$pa_num_gtype,$pma_ma_gma_gtype,$pma_ma_gpa_gtype,$pma_pa_gma_gtype,$pma_pa_mutant,$ppa_ma_gma_gtype,$ppa_ma_gpa_gtype,$ppa_pa_gma_gtype,$ppa_pa_mutant) = $_ =~ /^(${num_gtype_re}),(${pot_re}),(${family_re})(${num_gtype_re}),((${num_gtype_re}|${wierd_gtype_re})),(${gtype_re}),(${gtype_re}),(${gtype_re}),(${gtype_re}),(${gtype_re}),(${gtype_re}),(${gtype_re}),(${gtype_re})/;


# whew! it's nice to print the thing to make sure we got everything:  data are often idiosyncratic!
#
                print "$barcode_elts,$pot,$family,$ma_num_gtype,$pa_num_gtype,$pma_ma_gma_gtype,$pma_ma_gpa_gtype,$pma_pa_gma_gtype,$pma_pa_mutant,$ppa_ma_gma_gtype,$ppa_ma_gpa_gtype,$ppa_pa_gma_gtype,$ppa_pa_mutant\n";



                $barcode_out = $barcodes . $barcode_elts . $esuffix;
                system("/usr/local/bin/barcode -c -E -b $barcode_elts -u in -g \"2.25x0.75\" -e 128 -o $barcode_out");


# this makes an easily read pot number for the tag; we just want
# the minimum number of digits needed to hold all the planted rows, 
# not the full five digits allocated in Typesetting/DefaultOrgztn.pm.


                ($row) = $pot =~ /t\d{2}(\d{3})/;

                $pre_row = $prefix . $row;

                $record = $barcode_out . "::" . $pre_row . "::" . $family  . "::" .  $ma_num_gtype . "::" . $pa_num_gtype . "::" . $pma_ma_gma_gtype . "::" . $pma_ma_gpa_gtype . "::" . $pma_pa_gma_gtype . "::" . $pma_pa_mutant . "::" . $ppa_ma_gma_gtype . "::" . $ppa_ma_gpa_gtype . "::" . $ppa_pa_gma_gtype . "::" . $ppa_pa_mutant;


 
                push(@tags,$record);


# we usually want two tags/mutant plant, but for now we'll make just one while
# we decide whom to cross and how to cross them:  the 07r crop had many plants
# and I was trying to economize on tags (turned out to be a mistake).  Normally 
# these next six lines are commented in and the one above commented out.
#
#                if ( $family !~ /\d{4}/ ) { push(@tags,$record); }
#                else {
#                        push(@tags,$record);
#                        push(@tags,$record);
#                        }
#	        }


# these are the plants that didn't germinate!
#
#        else { print "Warning! empty barcode for $_\n"; }
	        }
         }

close(IN);





# now have to make and process the latex file for the tags, moving over @tags

# Using a reference to the array, rather than directly passing it, should be helpful 
# for large numbers of tags.  I'm passing the number of elements directly because I
# haven't yet deduced how to combine $# with an array reference ***after passing***.
# Up here, it's simply $#{\@tags}.
#
# Kazic, 8.11.07

&make_plant_tags($output_file,$#tags,\@tags);
&generate_plant_tags($output_dir,$tags_stem);


