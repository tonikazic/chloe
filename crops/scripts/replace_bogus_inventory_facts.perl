#!/usr/local/bin/perl

# this is /athe/c/maize/crops/replace_bogus_inventory_facts.perl
#
# Now that we have a list of inventory facts we can safely replace
# (from check_inventory_gtype_tag_mismatches.perl), go ahead and replace them
#
# the list of intended amendments is in /athe/c/maize/data/reinventory/seed_tag_replacemt/DATE/inventory_amendmts.
#
#
# call is perl ./replace_bogus_inventory_facts.perl REPLCMT_DIR_DATE OUTPUT_DIR_DATE
#
# Kazic. 30.5.2014



use autovivification;


use lib qw(../label_making/);
use Typesetting::MaizeRegEx;
use Typesetting::DefaultOrgztn;


$repl_date = $ARGV[0];
$output_date = $ARGV[1];


$replcmts_file = '../data/reinventory/seed_tag_replacemt/28.5/seed_tag_replacemt.csv';
$inventory_amendmts_file = "../data/reinventory/seed_tag_replacemt/" . $repl_date . "/inventory_amendmts";


# the new inventory file
#
$demeter_dir =~ s/\.\.\///;
$inventory_file = $demeter_dir . "inventory.pl";


$out =  "../data/reinventory/seed_tag_replacemt/" . $output_date . "/possible_replaced_inventory.pl";

$today = `date`;
chomp($today);




# the %amends is indexed by the new, correct ma that matches the genotype fact; the pa also
# matches the genotype fact.  These are the parents that should be directly replaced.

open(AMEND,"<$inventory_amendmts_file") or die  "can't open replcmts file $inventory_amendmts_file\n";

while (<AMEND>) {
        ($ama,$apa) = $_ =~ /^new (${num_gtype_re}) x (${num_gtype_re})/;
        $amends{$ama} = $apa;

        print "$ama x $amends{$ama}\n";
        }

close(AMEND);







# in the replacmts_file, the old parents are the original ones on the tag that was on the packet,
# put there after harvest but before the genotype.pl data were corrected.  These old tags were scanned
# in the new inventory, and so don't necessarily match the genotype parents.
#
# The new parents are the ones from the genotype facts, and were on the tag that replaced the 
# original tag.
#
# The %replcmts is indexed by the old incorrect ma that does not match the ma in the genotype fact.
#
# Kelly and Kazic, 3.5.2014


open(REPLCMTS,"<$replcmts_file") or die "can't open replcmts file $replcmts_file\n";


while (<REPLCMTS>) {
        if ( $_ !~ /^\%/ ) {
                ($oma,$opa,$nma,$npa,$cmt) = $_ =~ /^(${num_gtype_re}),(${num_gtype_re}),(${num_gtype_re}),(${num_gtype_re}),.+,(.+)$/;
                $replcmts{$oma} = $opa . "::" . $nma . "::" . $npa;
	        }
        }       


close(REPLCMTS);














open(INV,"<$inventory_file") or die "can't open inventory file $inventory_file\n";
open(OUT,">$out")  or die "can't open output inventory file $out\n";
print OUT "% this is $out\n%\n% the file of inventory facts that have had bogus parents replaced\n% following extensive manual and automated checks.\n%\n% Generated on $today by\n% /athe/c/maize/crops/replace_bogus_inventory_facts.perl.\n%\n";
print OUT "% Each replacement is commented out locally with a note about the replacement method.\n%\n% Old data otherwise copied over directly.\n\n\n\n\n";








# the key to %amends is the new ma that matches the genotype
# the key to %replcmts is the old ma, which matches the ma in the new inventory.pl
# fact.


while (<INV>) {


# want to preserve all comments, etc.

        if ( $_ !~ /^inventory/ ) { print OUT $_; }

        else {

                ($front,$ima,$mid,$ipa,$rest) = $_ =~ /^(inventory\(\')(${num_gtype_re})(\',\')(${num_gtype_re})(.+)/;
#                print "$front,$ima,$mid,$ipa,$rest\n";

                if ( exists $replcmts{$ima} ) {
                        $replacmt = $replcmts{$ima};
                        ($opa,$nma,$npa) = split("::",$replacmt);

                        if ( ( exists $amends{$nma} ) && ( $ipa eq $opa ) && ($npa eq $amends{$nma} ) ) {
                                print OUT "%\n% /athe/c/maize/crops/replace_bogus_inventory_facts.perl\n% replaced the following fact on $today\n%\n% ". $front . $ima . $mid . $ipa . $rest . "\n%\n";
                                print OUT $front . $nma . $mid . $amends{$nma} . $rest . "\n%\n%\n";
			        }

                        else { print "mismatch bwtn amendment $nma x $amends{$nma} and other data, check manually!\n"; }
		        }

		else { print OUT $front . $ima . $mid . $ipa . $rest . "\n"; }
	        }
        }



close(INV);
close(OUT);
