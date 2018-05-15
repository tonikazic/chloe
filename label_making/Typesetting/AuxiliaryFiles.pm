# this is ../c/maize/label_making/Typesetting/AuxiliaryFiles.pm

# specifies auxiliary files used to screen out plants in various states
# during tag manufacture.  This avoids generating and printing large numbers
# of useless tags, but a well-run crop will not have very many of these anyway.
# The one helpful thing is to generate extra tags for individual plants that 
# exhibit mutant phenotypes, rather than all plants in that family.
#
# That said, all these special lists and subroutines should simply be replaced
# by calls to the experiment's database.  We plan to do this soon.  So I have 
# squirreled away this material in its own module so that it will have an easy
# path to obsolescence.
#
# Kazic, 8.11.2007


# a more officially Perl way, but not intended for upload to CPAN
#
# despite the good advice, I use @EXPORT instead of @EXPORT_OK for now to
# simplify refactoring; otherwise all the variable names must be included in the
# import statement of the calling script (see http://perldoc.perl.org/Exporter.html)
#
# Kazic, 5.11.2007


package AuxiliaryFiles;

use DefaultOrgztn;
use TypesettingMisc;
use MaizeRegEx;




use Exporter;

our @ISA = qw(Exporter);
our @EXPORT = qw(
             get_auxiliary_data
             check_inbred_tag
             check_mutant_tag
            );








# auxiliary input files for screening out various types of plants;
# these and their corresponding code will be replaced by database
# calls eventually.
#
# I haven't checked this code after I placed it in this module, so 
# there may be bugs in passing the hashes back up to the call in main.
#
# Kazic, 8.11.07

$mutant_stem = "tmp.mutant_list.csv";
$first_extra_tag_stem = "first_extra_tag.csv";
# $first_extra_tag_stem = "first_extra_additional_inbred_tag.csv";
$dead_plant_stem = "tmp.dead_plants.csv";
$missing_stem = "plants_not_matching_re.csv";
$parsed_stem = "parsed_tags.csv";


$parsed = $input_dir . $parsed_stem;
$missing = $input_dir . $missing_stem;
$mutants_file = $input_dir . $mutant_stem;
$first_extra_file = $input_dir . $first_extra_tag_stem;
$dead_file = $input_dir . $dead_plant_stem;






###### subroutines


# data collection

sub get_auxiliary_data {
        ($mutants_hash) = &get_mutants;
        ($first_extra_hash) = &get_first_extra;
        ($dead_hash) = &get_dead;
        return($mutants_hash,$first_extra_hash,$dead_hash);
        }




# obviously these next three could be further modularized, but there's no
# point in it except vanity:  better to spend the effort on the database!
#
# probably the calls to clean_line aren't needed
#
# Kazic, 8.11.07

sub get_mutants {

        open(MUTANTS,"<$mutants_file") || die "can't open $mutants_file\n";

        while (<MUTANTS>) {
                clean_line($_);
	        ($mutant) = $_ =~ /^(${num_gtype_re})/;
                $mutants_hash{$mutant} = 1;
                }

        close(MUTANTS);
        return(\%mutants_hash);
        }



sub get_first_extra {

        open(FIRST_EXTRA,"<$first_extra_file") || die "can't open $first_extra_file\n";

        while (<FIRST_EXTRA>) {
                clean_line($_);
	        ($first_extra) = $_ =~ /^(${num_gtype_re}),/;
                ($row,$fe_plant) = $first_extra =~ /(${prow_re})(${pplant_re})$/;
                $first_extra_hash{$row} = $first_extra . "::" . $fe_plant;
                }

        close(FIRST_EXTRA);
        return(\%first_extra_hash);
        }




sub get_dead {
        open(DEAD,"<$dead_file") || die "can't open $dead_file\n";

        while (<DEAD>) {
                clean_line($_);
        	($dead) = $_ =~ /^(${num_gtype_re})/;
                $dead_hash{$dead} = 1;
                }

        close(DEAD);
        return(\%dead_hash);
        }





###### checking



sub check_inbred_tag { 
        ($barcode_elts,$prow,$pplant) = @_;

        if ( exists $first_extra_hash{$prow} ) { ($first_extra,$max_plant) = split(/::/,$first_extra_hash{$prow}); }
        else { $max_plant = 21; }
        

# there should be an additional condition:  if the plant is not dead then $flag = 1.  But I can't find the 
# right piece of perl logic for this, or my tmp.dead_plants.csv is off.
#
# Kazic, 10.7.07

        if ( $pplant < $max_plant ) { $flag = 1; }
        else {$flag = 0; }

#        print "inb: b $barcode_elts pr $prow pp $pplant fe $first_extra mp $max_plant f $flag\n";

        return $flag;
        }









# if plant is not dead and plant is a mutant and plant is less than the max per row
# print tag

sub check_mutant_tag { 
        ($barcode_elts,$prow,$pplant) = @_;

        if ( exists $first_extra_hash{$prow} ) { $max_plant = $first_extra_hash{$prow}; }
        else { $max_plant = 16; }

        if ( defined $dead_hash{$barcode_elts} ) { $value = 1; }
        else { $value = 0; }


#  && ( 1 == $mutants_hash{$barcode_elts} )

        if ( ( $pplant < $max_plant ) && ( $value == 0 ) ) { $flag = 1; }
        return $flag;
        }








1;
