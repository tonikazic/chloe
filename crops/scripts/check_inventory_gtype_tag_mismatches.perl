#!/usr/bin/perl

# this is ../data/reinventory/check_inventory_gtype_tag_mismatches_copy.perl

# ../maize/crops/check_inventory_gtype_tag_mismatches.perl was copied due to permissions issues
# so that it could be edited and tested
#
# Kelly 3.6.2014

# We have the new inventory.pl that has scans of the old tags.
#
# We have the file of tags that were generated to replace the bogus ones
# in the seed room, /athe/c/maize/data/reinventory/generate_these_tags
# by ../label_making/make_new_seed_labels.perl.
#
#
#
# We have the file of tags that were replaced,
# /athe/c/maize/data/reinventory/seed_tag_replacemt/28.5/seed_tag_replacemt.csv.
# This is the concatenation of the {24,25,26}.5/seed_tag_replacemt-Table 1.csv.
#
# In that file are multiple cases.
#
# 1. oldma,oldpa = newma, newpa:                                                                 tag replaced for legibility.
# a variety of lines in this category, but also the start of the 11N crop improvement
#
# 2. oldma,nopa  newma,newpa, where oldma = newma:                                               pa supplied
#
# 3. crummy ma, no pa  newma, newpa, where crummy ma is a substring of new ma:                   ma, pa supplied
# crummy ma may be due to scan or manual transcription errors, either way
#
# 4. oldma, oldpa  newma, newpa, where all is the same except family numbers:                    ma, pa replaced with correct families
#
# 5. oldma, oldpa  newma, newpa where mutant newpa still contains inbred letter despite reprint:  don't replace, reprint tags
# these have a string in the last field, "really male XXX"
# 
# 6. oldma, oldpa  newma, newpa where mutant newpa has an inbred family:                         don't replace, reprint tags
# these have a string in the last field, "really male XXX"
# 
# 7. oldma, oldpa  newma, newpa where oldpa is NOT a substring of newpa and mas identical:       don't replace, reprint tags
# these have a string in the last field, "really male XXX" ???
#
# 8. oldma, nopa   newma, newpa where newpa has wrong family:                                    don't replace, reprint tags
# these have a string in the last field, "really male XXX"
#
# 9. oldma, olpa   newma, newpa where newpa completely different due to missing tags:            replace
#
# 10. oldma, oldpa newma, newpa where oldma and newma incorrect:                                 don't replace, reprint tags
# these have a string in the last field, "female really XXX"
#
# 11. oldma, oldpa newma, newpa where newma has correct inbred family:                           replace
# these have a string in the last field, "S/M switch"
#
# 12. all matches but a note in the last field, "no genotype fact":                              replace
#
# 13. oldma, oldpa newma, newpa where oldma is correct and newma false:                          do not replace if correct in new inventory.pl
# extra field says "S/M switch [S,M] correct"
# amend cross, harvest records:  11N row 346 is certainly S, not M
# amend cross, harvest records:  11N row 345 is certainly M, not S
# 
#
#
#
#
#  stopped here fixing baker/braun
#
# check pairs against genotype.pl, old.inventory.pl, harvest.pl, inventory.pl???
#
#
#
# But what all of these cases lead me to think is that we still have a lot to sort out
# in the inventory, that isn't very important right now for building the pedigrees.
# We do have to finish it up, but for example the Baker/Braun corn can wait another year.
#
# So after talking it over, we decided to simply check that each pair of parents in the genotype 
# is present in the replacement file, and if not to spit that out and sort through the output by hand.
#
# This way, if we do see enough consistent cases --- like family shifts --- then we can spit those to
# a file of inventory amendments.
#
# Kazic and Kelly, 29.5.2014


# logic looks correct in early checking.  There are some errors that were introduced in
# replacing the tags that end up in weirdos.
#
# next step after logic verification is to put outputs in a nice form to correct inventory.pl
#
# then to automate the grepping maybe, for the weirdos?  Hand-resolved weirdos can be appended to 
# the file of facts for automated inventory correction.
#
# Kazic, 29.5.2014


# We manually checked and resolved the weirdos.  However, the original version did not print new
# inventory parents to the amendments file, and so these were lost to modification.
#
# It may be that there will be new inventory facts in the reinventoried data Avi collected when the
# packets were re-labelled that still must be included.  We'll see when we look at this list.
#
# Modified call to take in output subdirectory.
#
# call is ./check_inventory_gtype_tag_mismatches.perl DIR
#
# Kazic, 3.6.2014



use autovivification;


use lib qw(../label_making/);
use Typesetting::MaizeRegEx;
use Typesetting::DefaultOrgztn;


$dir = $ARGV[0];

$replcmts_file = '../data/reinventory/seed_tag_replacemt/28.5/seed_tag_replacemt.csv';
$weirdos_file = "../data/reinventory/seed_tag_replacemt/" . $dir . "/lingering_weirdos";
$inventory_amendmts_file = "../data/reinventory/seed_tag_replacemt/" . $dir . "/inventory_amendmts";

$demeter_dir =~ s/\.\.\///;
$genotype_file = $demeter_dir . "genotype.pl";


# added to fix the bug!
#
# Kelly, 3.6.2014

$inventory_file = $demeter_dir . "inventory.pl";



open(GEN,"<$genotype_file") or die "can't open genotype file $genotype_file\n";

while (<GEN>) {
        ($gma,$gpa) = $_ =~ /^genotype\(\d+,\d+,\'(${num_gtype_re})\',\d+,\'(${num_gtype_re})\',.+/;
        $gpars{$gma} = $gpa;
        }
close(GEN);




open(INV,"<$inventory_file") or die "can't open inventory file $inventory_file\n";

while (<INV>) {
	($ima,$ipa) = $_ =~ /^inventory\(\'(${num_gtype_re})\',\'(${num_gtype_re})\',.+/;
	$ipars{$ima} = $ipa;
        }
close(INV);




# In the case that all oma nma, opa nma match the genotype, the data was not printed to $inventory_amendmts_file
# inventory.pl added to check if the nma x npa is present; if not, is added to $inventory_amendmts_file
#
# Kelly 3.6.2014





open(WEIRD,">$weirdos_file") or die "can't open weirdos file $weirdos_file\n";
open(AMEND,">$inventory_amendmts_file") or die "can't open replcmts file $inventory_amendmts_file\n";


open(REPLCMTS,"<$replcmts_file") or die "can't open replcmts file $replcmts_file\n";

while (<REPLCMTS>) {
        if ( $_ !~ /^\%/ ) {
                ($oma,$opa,$nma,$npa,$cmt) = $_ =~ /^(${num_gtype_re}),(${num_gtype_re}),(${num_gtype_re}),(${num_gtype_re}),.+,(.+)$/;

#                print "$oma x $opa, $nma x $npa :: $cmt\n";

                if ( ( $oma eq $nma ) && ( $opa eq $npa ) && ( exists $gpars{$nma} ) && ( $gpars{$nma} eq $npa ) &&  ( !exists $ipars{$nma} ) ) {



# ouch!  The original version just printed out cool beans to the terminal, so we lost our new facts.
# fixed to print to the amendments file.
#
# Kelly, 3.6.2014
 
			print AMEND "brand new $nma x $npa discovered, cool beans!\n"; }


# here, the inventories match correctly, but the corn has not been entered
# into genotype.pl because it has never been planted.  Because the corn is
# already in new inventory, no further action needs to be taken.
#
# Kazic, 31.5.2014

                elsif ( ( $oma eq $nma ) && ( $opa eq $npa ) && ( !exists $gpars{$nma} ) ) {
                        print WEIRD "new and old $oma x $opa match, but not in genotype.pl\n";
                        }


# here, there is a discrepancy among the three files.  Often, this is due
# to differing placement of the I in the 06R maternal numerical genotypes.
# Sometimes it is due to too enthusiastic, too loose string matching when
# we were looking for mismatches.
#
# Each of these were manually resolved and the data and tags corrected as needed.
#
# Kazic, 31.5.2014

                elsif ( ( ( $oma ne $nma ) || ( $opa ne $npa ) ) && ( ( exists $gpars{$oma} ) && ( $gpars{$oma} eq $opa ) ) ) {
                        print WEIRD "mismatch btw new $nma x $npa and genotype, but old $oma x $opa in genotype.pl\n";
                        }


# Hmmm.  Based on what we see in the second weird case, we'll go back and
# look at these . . .
#
# ok, we've added the check of the parents in the inventory data here too, since
# now we have replaced many facts already.
#
# Kazic, 3.6.2014

                elsif ( ( ( $oma ne $nma ) || ( $opa ne $npa ) ) && ( ( exists $gpars{$nma} ) && ( $gpars{$nma} eq $npa )  &&  ( !exists $ipars{$nma} ) ) ) {
                        print AMEND "new $nma x $npa match genotype.pl, replace in inventory\n";
                        }

	        }
        }
close(REPLCMTS);


close(WEIRD);
close(AMEND);
