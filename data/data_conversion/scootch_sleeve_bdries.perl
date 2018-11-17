#!/opt/perl5/perls/perl-5.26.1/bin/perl

# this is ../c/maize/data/data_conversion/scootch_sleeve_bdries.perl
#
# given a file of current sleeve boundaries (first and last mas of each sleeve)
# and the inventory.pl, find the most recent inventory fact for each ma from all
# crops and rewrite the fact with the new correct sleeve.
#
#
# The code relies on ../../demeter/data/sleeve_bdry.pl, generated from
# ../palm/raw_data_from_palms/*/*eta/*/sleeve_bdry.csv by
# ./convert_sleeve_bdry_data.perl.  The data should contain the first and
# last ma of each sleeve, and of any other groups of packets not represented
# by the first and last ma.
#
# Kazic, 21.7.2018




# call is perl ./update_inventory.perl FLAG
#
# where FLAG is one of {go,q,test}.




use strict;
# use warnings;



use Cwd 'getcwd';
use Date::Calc 'Today_and_Now';
use Data::Dumper 'Dumper';
use List::MoreUtils 'first_index';
use Time::Local 'timelocal';
use autovivification;

use lib '../../label_making/Typesetting/';
use DefaultOrgztn;
use MaizeRegEx;



my $local_dir = getcwd;
my ($dir,$input_dir) = &adjust_paths($crop,$local_dir);



my $flag = $ARGV[0];



my $inventory_file = $demeter_dir . "inventory.pl";
my $sleeve_file = $demeter_dir . "sleeve_bdry.pl";

# print "invntry: $inventory_file\nslev_bd: $sleeve_file\n";





my $today = `date`;
chomp($today);
my ($year,$month,$day,$hour,$min,$sec) = Today_and_Now();

my %current_inventory;
my %inventory;
my $out;
my %sleeves;







# filter out irrelevant lines and write into an array

open my $inv_fh, '<', $inventory_file or die "sorry, can't open the inventory file $inventory_file\n"; 
my @grep_array = grep { $_ !~ /\%/ && $_ =~ /^inventory/ } <$inv_fh> ;

# foreach my $elt (@grep_array) { print "$elt"; } 







# grab the sleeve boundary data and stuff into a similar hash
# read from that hash when sorting and outputting the inventory


open my $slv_fh, '<', $sleeve_file or die "sorry, can't open the sleeve_bdry file $sleeve_file\n"; 

while (<$slv_fh>) {

        if ( $_ =~ /^sleeve_bdry/ ) {

		
                my ($first_ma,$last_ma,$sleeve,$date,$time) = $_ =~ /sleeve_bdry\(\'(${num_gtype_re})\',\'(${num_gtype_re})\',(${sleeve_re}),\w+,(${prolog_date_re}),(${prolog_time_re})/;


#                print "($first_ma,$last_ma,$sleeve,$date,$time)\n";
		
                my ($fcropyr,$fcroppart,$fkey,$frp) = &explode_num_gtype($first_ma);
                my ($lcropyr,$lcroppart,$lkey,$lrp) = &explode_num_gtype($last_ma);
                my @last_ma = ($lcropyr,$lcroppart,$lkey,$lrp,$date,$time,$first_ma,$last_ma);

		unshift @last_ma, $sleeve;
		$sleeves{$fcropyr}{$fcroppart}{$fkey}{$frp} = [ @last_ma ];
	        }
        }



# if ( $flag eq 'q' ) { print Dumper \%sleeves; }









# %inventory now structured differently so find the most 
# recent datum.  This will include packets with 0 kernels, which
# are eliminated in this step.


foreach my $elt (@grep_array) { 

    
        my ($ma,$pa,$kernels,$date,$time,$sleeve) = $elt =~ /\'(${num_gtype_re})\',\'(${num_gtype_re})\',num_kernels\(([\w\_]+)\),${observer_re},date\((${prolog_date_innards_re})\),time\((${prolog_time_innards_re})\),(${sleeve_re})/;


# convert date and time to timestamp, compare timestamps for each ma
# as it comes through, update %current_inventory.  For timelocal, see
#
# https://www.perlmonks.org/?node_id=319934

        my ($mday,$mon,$year) = $date =~ /(\d{1,2}),(\d{1,2}),(\d{4})/;
        my ($hour,$min,$sec) = $time =~ /(\d{1,2}),(\d{1,2}),(\d{1,2})/;
	
	my $inv_timestamp = timelocal($sec,$min,$hour,$mday,$mon,$year);
#        print "$ma,$pa,$kernels,$date,$time,$sleeve     $inv_timestamp\n";


        if ( !exists $current_inventory{$ma} ) {
		$current_inventory{$ma} = join("::",$inv_timestamp,$kernels,$sleeve,$pa,$date,$time);
	        }
	
        else {
                my ($pinv_timestamp,$pkernels) = split(/::/,$current_inventory{$ma});    

		if ( $inv_timestamp > $pinv_timestamp) {


# a little lazy type-testing is needed to avoid Perl's coercing
# the strings to numbers in the context of the numerical equality test.
# Regex is the simplest and probably the fastest, and skips the equality test
# altogether.  For more sophisticated type-testing in Perl, see
#
# https://stackoverflow.com/questions/12686335/how-to-tell-apart-numeric-scalars-and-string-scalars-in-perl

                        if ( $kernels =~ /\b0\b/ ) {
			        delete $current_inventory{$ma};				
#			        print "DELETING $ma x $pa, $pkernels now $kernels\n";
			        }

			else {
			        $current_inventory{$ma} = join("::",$inv_timestamp,$kernels,$sleeve,$pa,$date,$time);
#			        print "revising $ma x $pa, $pkernels now $kernels\n";
			        }
		        }
	        }
        }




# my $i=1;
# foreach my $ma ( sort ( keys %current_inventory ) ) {
#         my ($macropyr,$macroppart,$makey,$marp) = &explode_num_gtype($ma);
#         print "$ma: $i             $macropyr,$macroppart,$makey,$marp\n";
#   	  $i++;
#         }












# for each ear in %current_inventory:
#
#     separate into the elements of the 5d hash;
#     find beginning of sleeves that match {$inv_cropyr}{$inv_croppart}{$key}
#     find sleeve that begins with closest rowplant to ear
#     check that ear is less than final ear of sleeve

# 


# want to use datetime of scootching for final revised inventory, and print
# appropriate header message in inventory file




# a tree of cases
#
# either 1.  current ear is greater than or equal to first ear in sleeve, matching by crop and family; or
#        2.  current ear is inside a mixed sleeve and its crop is greater than a first ear and less than the last ear
#
# if 1: check rowplant of current ear; should be > first ear rowplant and < last ear rowplant; or
#                                                = first ear rowplant; or
#                                                                         = last ear rowplant.
#
#
# if 2: find sleeve that begins with crop that is floor of current ear and ends with crop that is
# ceiling of current ear.  How best to do this?
#
# watch out for autovivification!
#
# $sleeves{$fcropyr}{$fcroppart}{$fkey}{$frp}{$sleeve} = ($lcropyr,$lcroppart,$lkey,$lrp,$date,$time,$first_ma,$last_ma);



# cropyrs sort correctly
# print join("\n",sort qw [13 14 15 06 07 08 09 10 11 12 16 17 18]) . "\n";
#
# crop particles do not, unless reversed
# print join("\n",reverse sort qw [R N G]) . "\n";


my @crop_order = qw [R N G];

foreach my $ma ( sort ( keys %current_inventory ) ) {
        my ($macropyr,$macroppart,$makey,$marp) = &explode_num_gtype($ma);
#        print "$ma:         $macropyr,$macroppart,$makey,$marp\n";

        my $sleeve = &ear_floor($macropyr,$macroppart,$makey,$marp);






        }




















############# subroutines; migrate to Typesetting ############


sub explode_num_gtype {
        my ($num_gtype) = @_;

	my ($crop,$fam,$rp) = $num_gtype =~ /(${crop_re})(${family_re}):[SWMBEPL]?(${old_rowplant_re})$/;
	my ($cropyr,$croppart) = $crop =~ /(\d{2})(\w)/;
	my $famkey;
        if ( length($fam) == 3 ) { $famkey = $fam; } else { $famkey = 0; }

        return($cropyr,$croppart,$famkey,$rp);
        }













# kinda like a back-off tagger ;-)
#
# right idea, implementation incorrect

# autovivification help from
# https://www.perlmonks.org/?node_id=800779
#
# numerical tests on strings should succeed:
# https://perlmaven.com/scalar-variables
#
# https://stackoverflow.com/questions/3700069/how-can-i-check-if-a-key-exists-in-a-deep-perl-hash



sub ear_floor {
        my ($macropyr,$macroppart,$makey,$marp) = @_;

	no autovivification 'exists';


	print "\n\n input: ($macropyr,$macroppart,$makey,$marp)\n";

        my ($cropyr,$croppart,$key,$rp,$sleeve,$croppart_idx,$macroppart_idx);
        my @rps;
	
	if ( $sleeves{$macropyr}{$macroppart}{$makey}{$marp} ) { print "\nall: $sleeves{$macropyr}{$macroppart}{$makey}{$marp}[0]\n"; }


        elsif (  ( exists $sleeves{$macropyr}{$macroppart}{$makey} )
		 && ( @rps = keys %{$sleeves{$macropyr}{$macroppart}{$makey}} )
	 	 && ( $rp = &find_sleeve_starting_rp($marp,\@rps) ) ) { print "lower rp $rp: $sleeves{$macropyr}{$macroppart}{$makey}{$rp}[0]\n"; }
#                 ) { print "\nrp: " . join(',',sort @rps); }

	# elsif (  ( exists $sleeves{$macropyr}{$macroppart}{$key}{$rp}{$sleeve} )
	# 	 && ( $key < $makey ) ) { print "lower key: $sleeve\n"; }
        # elsif (  ( exists $sleeves{$macropyr}{$croppart}{$key}{$rp}{$sleeve} )
	# 	 && ( $croppart_idx = first_index { $_ eq $croppart} @crop_order )
	# 	 && ( $macroppart_idx  = first_index { $_ eq $macroppart} @crop_order ) 
	# 	 && ( $croppart_idx < $macroppart_idx ) ) { print "lower particle: $sleeve\n"; }
        # elsif (  ( exists $sleeves{$cropyr}{$croppart}{$key}{$rp}{$sleeve} )
	# 	 && ( $cropyr < $macropyr ) ) { print "lower year: $sleeve\n"; }

	
	return $sleeve;
        }





# for discussion of Perl Booleans, see
# https://stackoverflow.com/questions/39541833/what-values-should-a-boolean-function-in-perl-return


sub find_sleeve_starting_rp {
        my ($marp,$rps_ref) = @_;

#        print "sorted: $marp            " . join(',',sort @{$rps_ref}) . "\n";

        my $lowest = shift @{$rps_ref};
	if ( $marp > $lowest ) {
		my $highest = pop @{$rps_ref};

# stopped here

		if ( $marp < $highest ) { print "inside: $marp            " . join(',',sort @{$rps_ref}) . "\n"; }
	        
		else { return; }
	        }
	else { return; }

        }
