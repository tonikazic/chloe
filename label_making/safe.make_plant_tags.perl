#!/usr/local/bin/perl

# this is maize/label_making/make_plant_tags.perl


# This script takes a comma-delimited file dumped from a spreadsheet and 
# generates the barcode labels for the plants.  A LaTeX file with the label
# information is generated and processed to produce a PDF.  Since 
# ImageMagick's convert cannot convert PostScript to PNG at adequate
# resolution, we use latex/dvips/ps2pdf, which does quite well and preserves 
# the resolution of the barcode for scanning.
#
# Kazic, 5.1.07.
#
#
# changed to command-line switches
#
# Kazic, 26.3.08





# call is ./make_plant_tags CROP [NUM_EXTRA_MUTANT_TAGS JUST_THESE FILTRATN VERIFICATN]
#
# (the first argument is mandatory, the remaining three are optional)
#
# where NUM_MUTANT_TAGS is an integer from 0 to n (the default is one tag/plant, whether mutant
# or inbred, so this lets one print additional tags for each mutant plant);
# JUST_THESE is one of i (inbreds) or m (mutants) if desired,
# FILTRATN is f if desired, and VERIFICATN is v if desired, in that order.  If any of the
# arguments are omitted the rest are interpreted.



# new idea is print the tags for a row in columns to simplify manufacture
#
# Kazic, 26.9.09



# several changes needed apart from different layout:
#   load list of irrelevant plants and remove these from array of tags
#   shrink barcodes and re-arrange tag layout slightly
#
# Kazic. 17.7.2010



use Typesetting::DefaultOrgztn;
use Typesetting::MaizeRegEx;
use Typesetting::AuxiliaryFiles;
use Typesetting::OrganizeData;
use Typesetting::TypesetGenetics;
use Typesetting::TypesettingMisc;
use Typesetting::GenerateOutput;





$input_stem = "plant_list";
$tags_stem = "prioritized_tags";
$input_file = $input_dir . $input_stem . $csv_suffix;
$output_file = $output_dir . $tags_stem . $tex_suffix;





$num_extra_mutant_tags = $ARGV[1];
if ( $num_extra_mutant_tags !~ /\d+/ ) { $num_extra_mutant_tags = 0; }
($just_these,$filtratn,$verificatn) = &organize_plant_tag_switches($ARGV[2],$ARGV[3],$ARGV[4]);


print "For the $crop crop, you've requested $num_extra_mutant_tags extra tag(s) for each mutant.\n";

if ( $just_these eq "i" ) { print "You've requested tags for just the inbreds.\n"; }
elsif ( $just_these eq "m" ) { print "You've requested tags for just the mutants.\n"; }
elsif ( $just_these eq "b" ) { print "You've requested tags for both the mutants and inbreds.\n"; }

if ( $filtratn eq "true" ) { print "You've requested that extraneous tags and mutant and dead plants be filtered out.\n"; }
if ( $verificatn eq "true" ) { print "You've requested verificatn of the family numbers using verify_families.perl.\n"; }
print "\n\n"; 











# can run from here or as a separate process
#
# Kazic, 5.1.07

if ( $verificatn eq "true" ) { system("verify_families.perl"); }





# For large numbers of tags, on our Linux machine running Gentoo it's best to 
# comment out &make_tags and make the barcodes from a terminal that one watches.  
# For reasons we don't understand, GNU barcode hangs (randomly? who knows) 
# on certain barcodes. The barcode file is made, but the barcode process 
# doesn't stop -- so control never returns to the Perl process and the barcode
# chews cycles.  Control-C twice stops the barcode, returns control to the Perl
# process, and lets the latter go forward (until the next hangup).  For this 
# reason, we print something to the screen so we know when to ^-c ^-c.
# After that, of course, we reverse the commenting and let the latex run.
#
# Interestingly, this doesn't happen on my MacBook Pro under 10.4.x, so
# this may just be a Gentoo quirk --- I haven't tried it under RedHat.
#
# Once the barcode file is made there's no need to re-make it:  so we routinely
# comment out the calls to barcode in subsequent passes when we're twiddling 
# with layout.
#
# Kazic, 5.1.07

# modified to use regular expressions and data from make_leaf_tags.perl
#
# Kazic, 8.7.07

# these have been tuned to the 07R barcodes!  Will need to relax constraints for barcodes of 06r crop
# and for lines received from others.
#
# Kazic, 10.7.07




# See comments in Typesetting/AuxiliaryFiles.pm for caveats.

if ( $filtratn eq "true" ) { ($mutants_hash,$first_extra_hash,$dead_hash) = &get_auxiliary_data; }






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





# for 09R and subsequently, based on the data in demeter, including stand counts ($max_plants = stand count + 1
#
# $barcode_elts are of the form:  Crop . Family . : . Prefix
#

                ($barcode_elts,$prow,$max_plants,$family,$ma_family,$ma_num_gtype,$pa_family,$pa_num_gtype,$ma_gma_gtype,$marker,$quasi_allele) = $_ =~ /^(${num_gtype_re}),(${plain_row_re}),(${ft_re}),(${family_re}),(${family_re}),(${num_gtype_re}),(${family_re}),(${num_gtype_re}),(${gtype_re}),(${marker_re}),(${quasi_re}),*/;






# whew! it's nice to print the thing to make sure we got everything:  data are often idiosyncratic!
#
#                print "$barcode_elts,$prow,$max_plants,$family,$ma_family,$ma_num_gtype,$pa_family,$pa_num_gtype,$ma_gma_gtype,$marker,$quasi_allele\n";



# in case the row was not padded in the spreadsheet or the Prolog is used

                $prow =~ s/r//;
                ($prow) = &pad_row($prow,5);

		
                ($prefix) = &get_family_prefix($family);


# this makes an easily read row number for the tag; we just want
# the nonzero suffix, not the fully padded row number, with the inbred
# prefix added in
#
# Kazic, 27.3.08

                ($pre_row) = &easy_row($prow,$prefix);





# overload $pplant with the pot number if we're in the greenhouse (G)
#
# Kazic, 27.3.08
#
#                if ( $pot =~ /\d+/ ) { $pplant = "t" . $pot; }


# new for 08R:  just give the number of plants in each row; stick that in the "pot" place in the 
# spreadsheet.
#
#		$max_plants = $pot;

                for ( $plant = 1 ; $plant <= $max_plants ; $plant++ ) {
                        ($pplant) = &pad_plant($plant);
#                        print "pplant: $pplant\n";



# logic here terribly redundant and command-line switches are probably not
# sufficiently exploited; fix
#
# Kazic, 27.3.08
#
# see Typesetting/AuxiliaryFiles.pm for caveats
#
#		        if ( $just_these !~ /b/ ) {
#
#                                if ( $prefix =~ /[SWM]/ ) { $flag = &check_inbred_tag($barcode_elts,$prow,$pplant); }
#                                else { $flag = &check_mutant_tag($barcode_elts,$prow,$pplant); }
#
#
## just the inbreds!
#
#                                if ( ( $just_these =~ /i/ ) && ( $flag == 1 ) && ($barcode_elts ne "" ) && ( $prefix =~ /[SWM]/ ) ) {
#                                        ($barcode_elts) = &make_plant_id($barcode_elts,$prow,$pplant);
#			                ($barcode_out) = &make_barcodes($barcodes,$barcode_elts,$esuffix); 
#			                }
#
#
#
## now just the mutants!
#
#                                elsif ( ( $just_these =~ /m/ ) && ( $flag == 1 ) && ($barcode_elts ne "" ) && ( $prefix !~ /[SWM]/ ) ) {
#                                        ($barcode_elts) = &make_plant_id($barcode_elts,$prow,$pplant);
#                    	                ($barcode_out) = &make_barcodes($barcodes,$barcode_elts,$esuffix); 
#   			                }
#			        }
#
#
## 09R and subsequently

                        if ( $just_these =~ /b/ ) { 

                                ($new_barcode_elts) = &make_plant_id($barcode_elts,$prow,$pplant);
                                ($barcode_out) = &make_barcodes($barcodes,$new_barcode_elts,$esuffix); 

#                                 print "$barcode_out,$barcode_elts,$prow,$pplant\n";
                                }


# 09R and subsequently
#
                       $record = $barcode_out . "::" . $pre_row . "::" . $pplant . "::" . $family  . "::" .  $ma_num_gtype . "::" . $pa_family . "::" . $pa_num_gtype . "::" . $ma_gma_gtype . "::" . $marker . "::" . $quasi_allele;


#                       print "$record\n";

                        push(@tags,$record); 
		        for ( $i = 1 ; $i <= $num_extra_mutant_tags ; $i++ ) { push(@tags,$record); }
                        }


# clear the variables!

		$barcode_elt = "";
		$barcode_elts = "";
		$barcode_out = "";
		$family = "";
		$flag = "";
		$ma_family = "";
		$ma_num_gtype = "";
		$ma_gma_gtype = "";
		$marker = "";
		$max_plants = "";
		$new_barcode_elts = "";
		$pa_family = "";
		$pa_num_gtype = "";
		$plant = "";
		$pplant = "";
		$prow = "";
		$pre_row = "";
		$prefix = "";
		$prow = "";
		$quasi_allele = "";
		$record = "";
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







############ obsolete

# next come different sets of regular expressions for various crops and spreadsheets
# You'll have to modify these to suit your own material.
#
# for 06N and 07R genotypes
#
#                ($barcode_elts,$prow,$pplant,$family,$ma_family,$ma_num_gtype,$pa_family,$pa_num_gtype,$pma_ma_gma_gtype,$pma_ma_gpa_gtype,$pma_pa_gma_gtype,$pma_pa_mutant,$ppa_ma_gma_gtype,$ppa_ma_gpa_gtype,$ppa_pa_gma_gtype,$ppa_pa_mutant,$quasi_allele) = $_ =~ /^(${num_gtype_re}),(${prow_re}),(${pplant_re}),(${family_re}),(${family_re}),(${num_gtype_re}),(${family_re}),(${num_gtype_re}),(${gtype_re}),(${gtype_re}),(${gtype_re}),(${gtype_re}),(${gtype_re}),(${gtype_re}),(${gtype_re}),(${gtype_re}),(${quasi_re})/;
#
#
# for 06R -- 07R genotypes
#
#                ($barcode_elts,$prow,$pplant,$family,$ma_family,$ma_num_gtype,$pa_family,$pa_num_gtype,$pma_ma_gma_gtype,$pma_ma_gpa_gtype,$pma_pa_gma_gtype,$pma_pa_mutant,$ppa_ma_gma_gtype,$ppa_ma_gpa_gtype,$ppa_pa_gma_gtype,$ppa_pa_mutant,$quasi_allele) = $_ =~ /^(${num_gtype_re}),(${prow_re}),(${pplant_re}),(${family_re}),(${original_family_re}),(${num_gtype_re}),(${original_family_re}),(${num_gtype_re}),(${gtype_re}),(${gtype_re}),(${gtype_re}),(${gtype_re}),(${gtype_re}),(${gtype_re}),(${gtype_re}),(${gtype_re}),(${quasi_re})/;
#
#
# for 07G, 08R
#
#                                                                                                   |
#	        ($barcode_elts,$prow,$pot,$family,$ma_family,$ma_num_gtype,$pa_family,$pa_num_gtype,$pma_ma_gma_gtype,$pma_ma_gpa_gtype,$pma_pa_gma_gtype,$pma_pa_mutant,$ppa_ma_gma_gtype,$ppa_ma_gpa_gtype,$ppa_pa_gma_gtype,$ppa_pa_mutant,$quasi_allele) = $_ =~ /^(${num_gtype_re}),(${pot_re}),(${pot_re}),(${family_re}),(${family_re}),(${num_gtype_re}),(${family_re}),(${wierd_gtype_re}),(${gtype_re}),(${gtype_re}),(${gtype_re}),(${gtype_re}),(${gtype_re}),(${gtype_re}),(${gtype_re}),(${gtype_re}),(${quasi_re}),*/;
#
#
#
# for 06N -- 07R and others' funny genotypes! Note alternation of ${num_gtype_re} and ${wierd_gtype_re}
#
#                ($barcode_elts,$prow,$pplant,$family,$ma_family,$ma_num_gtype,$pa_family,$pa_num_gtype,$pma_ma_gma_gtype,$pma_ma_gpa_gtype,$pma_pa_gma_gtype,$pma_pa_mutant,$ppa_ma_gma_gtype,$ppa_ma_gpa_gtype,$ppa_pa_gma_gtype,$ppa_pa_mutant,$quasi_allele) = $_ =~ /^(${num_gtype_re}),(${prow_re}),(${pplant_re}),(${family_re}),(${original_family_re}),(${num_gtype_re}),(${original_family_re}),((${num_gtype_re}|${wierd_gtype_re})),(${gtype_re}),(${gtype_re}),(${gtype_re}),(${gtype_re}),(${gtype_re}),(${gtype_re}),(${gtype_re}),(${gtype_re}),(${quasi_re})/;
#
# original 09R idea
#
#                ($barcode_elts,$prow,$max_plants,$family,$ma_family,$ma_num_gtype,$pa_family,$pa_num_gtype,$ma_gma_gtype,$ma_gpa_gtype,$pa_gma_gtype,$pa_mutant,$marker,$quasi_allele) = $_ =~ /^(${num_gtype_re}),(${row_re}),(${ft_re}),(${family_re}),(${family_re}),(${num_gtype_re}),(${family_re}),(${num_gtype_re}),(${gtype_re}),(${gtype_re}),(${gtype_re}),(${gtype_re}),(${gtype_re}),(${quasi_re}),*/;



#                print "$barcode_elts,$prow,$pplant,$family,$ma_family,$ma_num_gtype,$pa_family,$pa_num_gtype,$pma_ma_gma_gtype,$pma_ma_gpa_gtype,$pma_pa_gma_gtype,$pma_pa_mutant,$ppa_ma_gma_gtype,$ppa_ma_gpa_gtype,$ppa_pa_gma_gtype,$ppa_pa_mutant,$quasi_allele\n";
#
#
# 07G --  the pot numbers are very useful
#
#                print "$barcode_elts,$prow,$pot,$family,$ma_family,$ma_num_gtype,$pa_family,$pa_num_gtype,$pma_ma_gma_gtype,$pma_ma_gpa_gtype,$pma_pa_gma_gtype,$pma_pa_mutant,$ppa_ma_gma_gtype,$ppa_ma_gpa_gtype,$ppa_pa_gma_gtype,$ppa_pa_mutant,$quasi_allele\n";
#


# previous years
#
#                       $record = $barcode_out . "::" . $pre_row . "::" . $pplant . "::" . $family  . "::" .  $ma_num_gtype . "::" . $pa_family . "::" . $pa_num_gtype . "::" . $pma_ma_gma_gtype . "::" . $pma_ma_gpa_gtype . "::" . $pma_pa_gma_gtype . "::" . $pma_pa_mutant . "::" . $ppa_ma_gma_gtype . "::" . $ppa_ma_gpa_gtype . "::" . $ppa_pa_gma_gtype . "::" . $ppa_pa_mutant . "::" . $quasi_allele;
#
