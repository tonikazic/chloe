#!/usr/local/bin/perl

# this is /athe/c/maize/crops/add_reinventoried_corn_if_absent.perl
#
# We now have a modified inventory and a new list of inventory_amendmts.
# The new inventory_amendmts contains brand-new corn and corn that somehow
# wasn't put in the inventory.
#
# We also have the file of manually reinventoried corn that Avi collected when the tags 
# were replaced.  Some of these were migrated incorrectly, however.
#
#
# So now we want to make sure the amended corn makes it in correctly.
#
# How?
#
# Pass through all existing comments and newlines.
#
#
# Look at each pair of parents in the current file of inventoried corn,
# whether the parents are current or have been fixed and commented out.
#
# cases:
#
#     if the parents are current and in reinventoried, and absent from
#     amendmts: 
#            compare current inventory sleeve and amount to reinventoried:
#                   if matched, remove from reinventoried;
#                   if not matched, print both to puzzles and remove from reinventoried.
# WRITTEN
#
#
#
#     if they are present in current inventory facts but not in genotype.pl or amendmts or reinventoried:
#            do nothing to inventory, they are already in but no genotype fact has yet been issued;
#            remove from reinventoried or amendmts, or both.
#
# WRITTEN
#
#
#     if they are present in commented-out inventory facts:
#            do nothing to inventory, we fixed it already;
#            remove from reinventoried or amendmts, or both.
#
# WRITTEN
#
#
#
#     if the parents are absent in inventory but present in reinventoried and amendmts:
#            add to inventory and remove from reinventoried and amendmts.
#
#            they might not be in genotype because we can have new corn.
# 
# WRITTEN
#
#
#     if they are present in amendmts, but  absent in genotype and current inventory facts:
#            print to puzzles to think about.
#     
#     if they are absent in genotype and current inventory facts and amendmts:
#            print to puzzles to think about.
#
#
# When we find matching corn already in inventory, check for identity of sleeve and amount:
#
#     if the same, replace facts.
#     if different, print to screen to decide.


# call is perl ./add_reinventoried_corn_if_absent.perl REPLCMT_DIR_DATE OUTPUT_DIR_DATE
#
# Kelly and Kazic, 3.6.2014



use autovivification;


use lib qw(../label_making/);
use Typesetting::MaizeRegEx;
use Typesetting::DefaultOrgztn;


$repl_date = $ARGV[0];
$output_date = $ARGV[1];


$reinventoried_file = "../data/reinventory/seed_tag_replacemt/" . $repl_date . "/partial.inventory.pl";
$inventory_amendmts_file = "../data/reinventory/seed_tag_replacemt/" . $repl_date . "/inventory_amendmts";


# the new inventory file
#
$demeter_dir =~ s/\.\.\///;
$inventory_file = $demeter_dir . "safe.inventory.pl";
$genotype_file = $demeter_dir . "genotype.pl";

$out =  "../data/reinventory/seed_tag_replacemt/" . $output_date . "/possible_replaced_inventory.pl";
$leftovers = "../data/reinventory/seed_tag_replacemt/" . $output_date . "/leftovers";
$puzzles = "../data/reinventory/seed_tag_replacemt/" . $output_date . "/puzzles";

$today = `date`;
chomp($today);





open(GEN,"$genotype_file") or die "can't open genotype file $genotype_file\n";

while (<GEN>) {
        if ( $_ =~ /^genotype/ ) {
                my ($gma,$gpa) = $_ =~ /^genotype\(\d+,\d+,\'(${num_gtype_re})\',\d+,\'(${num_gtype_re})\',.+/;
                $genes{$gma} = $gpa;
                }


        elsif ( $_ =~ /^\% genotype/) {
                my ($bgma,$bgpa) = $_ =~ /^\% genotype\(\d+,\d+,\'(${num_gtype_re})\',\d+,\'(${num_gtype_re})\',.+/;
                $bogus_genes{$bgma} = $bgpa;
                }



        }

close(GEN);





# the %amends is indexed by the new, correct ma that matches the genotype fact; the pa also
# matches the genotype fact.  These are the parents that should be directly replaced.
#
# put in "brand new" inventory facts from $inventory_amendmts_file before by hand
#

open(AMEND,"<$inventory_amendmts_file") or die  "can't open reinventoried file $inventory_amendmts_file\n";

while (<AMEND>) {
        my ($ama,$apa) = $_ =~ /^new (${num_gtype_re}) x (${num_gtype_re})/;
        $amends{$ama} = $apa;
        }

close(AMEND);






# the partial inventory file is opened and a hash of its parts generated.

open(REINV,"<$reinventoried_file") or die "can't open reinventoried corn file $reinventoried_file\n";

while (<REINV>) {
        if ( $_ =~ /^inventory/ ) {
                my ($reifront,$reima,$reimid,$reipa,$reirest) = $_ =~ /^(inventory\(\')(${num_gtype_re})(\',\')(${num_gtype_re})(.+)/;
                $reinv{$reima} = $reipa . "::" . $reifront . "::" . $reimid . "::" . $reirest;
	        }

# else, ignore
        }

close(REINV);







# the new inventory file gets opened twice: once to build its hashes, and
# once to generate the output inventory file by the logic above.
#
# I inserted an extra space between % and inventory for comments that I don't want to process.
# There were two of these.

open(INV,"<$inventory_file") or die "can't open the current inventory file $inventory_file\n";

while (<INV>) {
        if ( $_ =~ /^inventory/ ) {
                my ($curr_front,$curr_ima,$curr_mid,$curr_ipa,$curr_rest) = $_ =~ /^(inventory\(\')(${num_gtype_re})(\',\')(${num_gtype_re})(.+)/;
                $curr_inv{$curr_ima} = $curr_ipa . "::" . $curr_front . "::" . $curr_mid . "::" . $curr_rest;
	        }

        elsif ( $_ =~ /^% inventory/ ) {
                my ($bogus_front,$bogus_ima,$bogus_mid,$bogus_ipa,$bogus_rest) = $_ =~ /^\% (inventory\(\')(${num_gtype_re})(\',\')(${num_gtype_re})(.+)/;
                $bogus_inv{$bogus_ima} = $bogus_ipa . "::" . $bogus_front . "::" . $bogus_mid . "::" . $bogus_rest;
	        }
        }

close(INV);


# print "genes hash is " . keys( %genes ) . ".\n";
# print "bogus_genes hash is " . keys( %bogus_genes ) . ".\n";
print "amends hash is " . keys( %amends ) . ".\n";
print "reinv hash is " . keys( %reinv ) . ".\n";
# print "curr_inv hash is " . keys( %curr_inv ) . ".\n";
# print "bogus_inv hash is " . keys( %bogus_inv ) . ".\n";



open(INV,"<$inventory_file") or die "can't open the current inventory file $inventory_file\n";
open(OUT,">$out") or die "can't open the output inventory file $out\n";
open(PUZ,">$puzzles") or die "can't open the output puzzles file $puzzles\n";




print OUT "% this is $out\n%\n% the file of inventory facts that have been reconciled to\n% reinventoried corn $reinventoried_file\n% and inventory amendments $inventory_amendmts_file.\n%\n% Generated on $today by\n% /athe/c/maize/crops/add_reinventoried_corn_if_absent.perl.\n%\n";
print OUT "% Each replacement is commented out locally with a note about the replacement method.\n%\n% Previous data otherwise copied over directly.\n\n\n\n\n";

print PUZ "% this is $puzzles\n%\n% the file of inventory facts that don't fit any cases\n% and that we have look at manually.\n%\n% Generated on $today by\n% /athe/c/maize/crops/add_reinventoried_corn_if_absent.perl.\n%\n";





# crib sheet of hashes and files
#
# genotype current parents are in %genes{MA} = PA
# genotype old parents are in %bogus_genes{MA} = PA
#
# amendmt parents are in %amends{MA} = PA
#
# reinventoried parents are in %reinv{MA} = PA :: FRONT :: MID :: REST
#
# current inventory parents are in %curr_inv{MA} = PA :: FRONT :: MID :: REST
# bogus inventory parents are in %bogus_inv{MA} = PA :: FRONT :: MID :: REST
#
# OUT is new modified inventory file
# LEFT is remainders of %amends and %reinv after substitutions have been removed
# PUZ is everything else






# in the inventory file, we have comments, current facts, and bogus facts that were replaced.
#
# For each line, look at it and do the right thing.


while (<INV>) {


# want to preserve all comments, etc.

        if ( ( $_ !~ /^inventory/ ) && ( $_ !~ /^\% inventory/ ) ) { print OUT $_; }


# look at current inventory facts

        elsif ( $_ =~ /^inventory/ )  {

                my ($front,$ima,$mid,$ipa,$rest) = $_ =~ /^(inventory\(\')(${num_gtype_re})(\',\')(${num_gtype_re})(.+)/;
#                print "curr inv: $front,$ima,$mid,$ipa,$rest\n";



# first look to see if the inventory ma and pa jibe with current genotype ma and pa

                if ( ( exists $genes{$ima} ) && ( $genes{$ima} eq $ipa ) ) {
                        print OUT $front . $ima . $mid . $ipa . $rest . "\n";

                        if ( exists $reinv{$ima} ) { delete $reinv{$ima}; }
                        if ( exists $amends{$ima} ) { delete $amends{$ima}; }
                        if ( exists $bogus_genes{$ima} ) { delete $bogus_genes{$ima}; }
                        }


# we assume any commented-out genotype ma and pa are incorrect.  However, they could
# still be present in the inventory.  So we test, using the ma to match as that's all we have,
# and comparing pas to see if they differ in either family or plant num.  We print out a 
# message in either case, correct the inventory fact, and if present in either %amends or %reinv, 
# remove both the correct and incorrect pair.

                elsif ( exists $bogus_genes{$ima} ) {
                        if ( exists $genes{$ima} ) {
                                if ( $genes{$ima} ne $bogus_genes{$ima} ) {
                                        ($pcrop,$good_fam,$row,$plant) = $genes{$ima} =~ /(^\d+[NRG])(\d{3,4})(:\w+)(\d{2})$/;
                                        ($bpcrop,$bogus_fam,$brow,$bplant) = $bogus_genes{$ima} =~ /(^\d+[NRG])(\d{3,4})(:\w+)(\d{2})$/;

                                        
                                        if ( ( $pcrop eq $bpcrop ) && ( $row eq $brow ) ) {
                                                if ( ( $good_fam ne $bogus_fam ) && ( $plant eq $bplant ) ) {
                                                        print OUT $front . $ima . $mid . $genes{$ima} . $rest . "\n";
                                                        print "misfam:  $ima x $genes{$ima} $good_fam ne $bogus_fam \n";

                                                        if ( exists $reinv{$ima} ) { delete $reinv{$ima}; }
                                                        if ( exists $amends{$ima} ) { delete $amends{$ima}; }
                                                        if ( exists $bogus_genes{$ima} ) { delete $bogus_genes{$ima}; }
						        }

                                                elsif ( ( $good_fam eq $bogus_fam ) && ( $plant ne $bplant ) ) {
                                                        print OUT $front . $ima . $mid . $genes{$ima} . $rest . "\n";

                                                        print "misplt: $ima x $genes{$ima} good $plant ne $bplant \n";
                                                        if ( exists $reinv{$ima} ) { delete $reinv{$ima}; }
                                                        if ( exists $amends{$ima} ) { delete $amends{$ima}; }
                                                        if ( exists $bogus_genes{$ima} ) { delete $bogus_genes{$ima}; }
						        }

                                                else { print "fam and plant mismatch between good genotype $ima x $genes{$ima} and bogus genotype $ima x $bogus_genes{$ima}\n"; }
					        }

                                        else { print "mismatch between good genotype $ima x $genes{$ima} and bogus genotype $ima x $bogus_genes{$ima}\n"; }
				        }
# otherwise, the pas match, but they shouldn't; so we move on
			        }
# otherwise, we can't match the mas, so we move on
		        }



                elsif ( exists $reinv{$ima} ) {
                        $reinved = $reinv{$ima};
                        ($reinvipa,$reinvfront,$reinvmid,$reinvrest) = split("::",$reinved);

                        if ( $ipa eq $reinvipa ) {
                                my $use_or_no = &decide_curr_vs_reinv(\*OUT,$ima,$ipa,$front,$mid,$rest,$reinvrest);
#                                print "first reinv for $ima x $reinv{$ima}\n";

                                if ( $use_or_no == 0 ) { print PUZ "$ima,$ipa,$rest,$reinvrest\n"; }


                                delete $reinv{$ima};
                         	if ( exists $amends{$ima} ) { delete $amends{$ima}; } # print "second amends for $ima x $amends{$ima}\n"; 
                                if ( exists $bogus_genes{$ima} ) { delete $bogus_genes{$ima}; }
			        }
		        
                        else { print "mismatch bwtn current inventory $ima x $ipa and reinventoried $ima x $reinvipa!\n"; }
		        }


# if current genotype, or current inventory and not in reinventoried and amendmts, then it's ok!

		else { 
                        print OUT $front . $ima . $mid . $ipa . $rest . "\n"; 
                        if ( exists $reinv{$ima} ) { delete $reinv{$ima}; }
                        if ( exists $amends{$ima} ) { delete $amends{$ima}; }
                        if ( exists $bogus_genes{$ima} ) { delete $bogus_genes{$ima}; }
                        }
	        }
                
	elsif ( $_ =~ /^% inventory / ) {

                my ($bogus_front,$bogus_ima,$bogus_mid,$bogus_ipa,$bogus_rest) = $_ =~ /^(inventory\(\')(${num_gtype_re})(\',\')(${num_gtype_re})(.+)/;

                if ( exists $reinv{$bogus_ima} ) { delete $reinv{$bogus_ima}; } # print "third reinv bogus $bogus_ima $reinv{$bogus_ima}\n"; 
                if ( exists $amends{$bogus_ima} ) { delete $amends{$bogus_ima}; } # print "fourth amends bogus $bogus_ima x $amends{$bogus_ima}\n";
                if ( exists $bogus_genes{$bogus_ima} ) { delete $bogus_genes{$bogus_ima}; }
	        }
        }

close(INV);







# now we search for real facts that haven't made it into inventory yet.

print OUT "\n\n\n% facts found in reinventoried and amendments, but not yet in inventory.\n% inserted by /athe/c/maize/crops/add_reinventoried_corn_if_absent.perl.\n% on $today.\n\n\n";

foreach $rema ( sort ( keys %reinv ) ) {

        $rereinved = $reinv{$rema};
        ($rereinvipa,$rereinvfront,$rereinvmid,$rereinvrest) = split("::",$rereinved);



# a brand-new inventory fact that happens to match something in genotype

        if ( ( exists $genes{$rema} ) && ( $genes{$rema} eq $rereinvipa ) && ( !exists $bogus_genes{$rema} ) ) {
                print OUT $rereinvfront . $rema . $rereinvmid . $rereinvipa . $rereinvrest . "\n";
                if ( exists $reinv{$rema} ) { delete $reinv{$rema}; }
                if ( exists $amends{$rema} ) { delete $amends{$rema}; }
                if ( exists $bogus_genes{$rema} ) { delete $bogus_genes{$rema}; }
                }


# if mismatch between genotype and reinventory, then we're puzzled

        elsif ( ( exists $genes{$rema} ) && ( $genes{$rema} ne $rereinvipa ) ) {
                print PUZ $rereinvfront . $rema . $rereinvmid . $rereinvipa . $rereinvrest . "\n";
                if ( exists $reinv{$rema} ) { delete $reinv{$rema}; }
                if ( exists $amends{$rema} ) { delete $amends{$rema}; }
                if ( exists $bogus_genes{$rema} ) { delete $bogus_genes{$rema}; }
                }


# a brand-new inventory fact that hasn't made it into genotype yet, but we found it this time

        elsif ( ( !exists $bogus_genes{$rema} ) && ( !exists $bogus_inv{$rema} ) ) {
                print OUT $rereinvfront . $rema . $rereinvmid . $rereinvipa . $rereinvrest . "\n";
                if ( exists $reinv{$rema} ) { delete $reinv{$rema}; }
                if ( exists $amends{$rema} ) { delete $amends{$rema}; }
                if ( exists $bogus_genes{$rema} ) { delete $bogus_genes{$rema}; }
                }



        elsif ( exists $bogus_inv{$rema} ) {
                my ($bogus_pa,$bogus_front,$bogus_mid,$bogus_rest) = split("::",$bogus_inv{$rema});

                if ( $bogus_pa eq $rereinvipa ) { delete $reinv{$rema}; }

# otherwise, we will print it to leftovers later
	        }


        elsif ( ( exists $amends{$rema} ) && ( $rereinvipa eq $amends{$rema} ) ) { 
                 print OUT $rereinvfront . $rema . $rereinvmid . $rereinvipa . $rereinvrest . "\n";
                 delete $reinv{$rema}; # print "fifth for reinv rere $rema x $reinv{$rema}\n"; 
                 delete $amends{$rema}; # print "sixth for amends rere $rema x $amends{$rema}\n"; 
                 delete $bogus_genes{$rema}; # print "sixth for amends rere $rema x $amends{$rema}\n"; 
                 }
        }


# now it's safe to close OUT

close(OUT);






# now we deal with leftover reinv and puzzles


# print the remainder of the reinventory to LEFT

open(LEFT,">$leftovers") or die "can't open the output leftovers file $leftovers\n";
print LEFT "% this is $leftovers\n%\n% the file of inventory facts that were not reconciled to\n% between reinventoried corn $reinventoried_file\n% and inventory amendments $inventory_amendmts_file and\n% inventory file $inventory_file.\n%\n% Generated on $today by\n% /athe/c/maize/crops/add_reinventoried_corn_if_absent.perl.\n%\n\n\n";

foreach $lema ( sort ( keys %reinv ) ) {

        $leinved = $reinv{$lema};
        ($leinvipa,$leinvfront,$leinvmid,$leinvrest) = split("::",$leinved);
        print LEFT $leinvfront . $lema . $leinvmid . $leinvipa . $leinvrest . "\n";
        }

close(LEFT);







# print any leftover amendments to puzzles

print PUZ "% here are the remaining puzzles from leftover amends\n\n\n";

foreach $ama ( sort ( keys %amends ) ) {

        $apa = $amends{$ama};
        ($leinvipa,$leinvfront,$leinvmid,$leinvrest) = split("::",$leinved);
        print PUZ "$ama x $apa\n";
        }

close(PUZ);





# print "now genes hash is " . keys( %genes ) . ".\n";
# print "now bogus_genes hash is " . keys( %bogus_genes ) . ".\n";
print "now amends hash is " . keys( %amends ) . ".\n";
print "now reinv hash is " . keys( %reinv ) . ".\n";
# print "now curr_inv hash is " . keys( %curr_inv ) . ".\n";
# print "now bogus_inv hash is " . keys( %bogus_inv ) . ".\n";







sub decide_curr_vs_reinv {

        ($filehandle,$ima,$ipa,$front,$mid,$rest,$reinvrest) = @_;

        if ( $rest eq $reinvrest ) { 
                print $filehandle $front . $ima . $mid . $ipa . $rest . "\n"; 
                $use_or_no = 1;
                }

        else { 

                ($num_cl,$middle,$sleeve,$end) = $rest =~ /(,num_kernels\([\w_]+\))(.+)(${sleeve_re})(.+)$/;
                ($renum_cl,$remiddle,$resleeve,$reend) = $reinvrest =~ /(,num_kernels\([\w_]+\))(.+)(${sleeve_re})(.+)$/;

                print "$num_cl,$middle,$sleeve,$end\n";

                if ( $sleeve eq $resleeve ) {

                        if ( $num_cl eq $renum_cl) { print $filehandle $front . $ima . $mid . $ipa . $num_cl . $remiddle . $sleeve . $reend . "\n";}
                        else { print $filehandle $front . $ima . $mid . $ipa . $renum_cl . $remiddle . $sleeve . $reend . "\n";}
                        $use_or_no = 1;
                        }


                elsif ( $sleeve ne $resleeve ) {

                        if ( $num_cl eq $renum_cl ) { print $filehandle $front . $ima . $mid . $ipa . $num_cl . $remiddle . $resleeve . $reend . "\n";}
                        else { print $filehandle $front . $ima . $mid . $ipa . $renum_cl . $remiddle . $resleeve . $reend . "\n";}
                        $use_or_no = 1;
                        }


                else { $use_or_no = 0; }
	        }
       


# if ok to print to OUT, the $use_or_no = 1
# otherwise set to 0
# in either case return

        return $use_or_no;
        }