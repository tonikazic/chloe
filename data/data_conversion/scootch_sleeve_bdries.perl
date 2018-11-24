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




# Now that I've written it, this script and update_inventory.perl should be
# refactored together!  Maybe someday.
#
# Kazic, 24.11.2018






# call is perl ./update_inventory.perl FLAG
#
# where FLAG is one of {go,q,test}.




use strict;
use warnings;



use Cwd 'getcwd';
use Date::Calc 'Today_and_Now';
use Data::Dumper 'Dumper';
use List::Util 'all';
use List::MoreUtils qw( first_index minmax);
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
my %sleeves;
my %scootchies;
my %new_inventory;









# write the original data into an array without filtration

open my $inv_fh, '<', $inventory_file or die "sorry, can't open the inventory file $inventory_file\n"; 
my @originals =  <$inv_fh> ;

# foreach my $elt (@originals) { print "$elt"; } 







# grab the sleeve boundary data and stuff into a hash of arrays, %sleeves.
# read from that hash when sorting and outputting the inventory
#
# make a parallel hash, %scootchies, for the scootching dates:  saves pawing through
# all arrays for those data in the arrays of %sleeves.


open my $slv_fh, '<', $sleeve_file or die "sorry, can't open the sleeve_bdry file $sleeve_file\n"; 

while (<$slv_fh>) {

        if ( $_ =~ /^sleeve_bdry/ ) {

		
                my ($first_ma,$last_ma,$sleeve,$observer,$date,$time) = $_ =~ /sleeve_bdry\(\'(${num_gtype_re})\',\'(${num_gtype_re})\',(${sleeve_re}),(${observer_re}),(${prolog_date_re}),(${prolog_time_re})/;


#                print "($first_ma,$last_ma,$sleeve,$observer,$date,$time)\n";
		
                my ($fcropyr,$fcroppart,$fkey,$frp) = &explode_num_gtype($first_ma);


# to finesse the 06R inbred problem, turn them into simple numbers
		
                $frp =~ s/I/0/;
		
#                my @last_ma = ($date,$time,$first_ma,$last_ma);
                my @last_ma = ($first_ma,$last_ma);
		
		unshift @last_ma, $sleeve;
		$sleeves{$fcropyr}{$fcroppart}{$fkey}{$frp} = [ @last_ma ];
		$scootchies{$sleeve} = [ ($date,$time,$observer) ];
	        }
        }



# if ( $flag eq 'q' ) { print Dumper \%sleeves; }
# if ( $flag eq 'q' ) { print Dumper \%scootchies; }











# inventory.pl is a running inventory, so find the most recent datum for each
# seed packet.  This will include packets with 0 kernels, which are
# eliminated in this step.


foreach my $elt (@originals) { 

        if ( ( $elt !~ /\%/ ) && ( $elt =~ /^inventory/ ) ) {
	
                my ($ma,$pa,$kernels,$date,$time,$sleeve) = $elt =~ /\'(${num_gtype_re})\',\'(${num_gtype_re})\',num_kernels\(([\w\_]+)\),${observer_re},date\((${prolog_date_innards_re})\),time\((${prolog_time_innards_re})\),(${sleeve_re})/;


# convert date and time to timestamp, compare timestamps for each ma
# as it comes through, update %current_inventory.  For timelocal, see
#
# https://www.perlmonks.org/?node_id=319934

                my ($mday,$mon,$year) = $date =~ /(\d{1,2}),(\d{1,2}),(\d{4})/;
                my ($hour,$min,$sec) = $time =~ /(\d{1,2}),(\d{1,2}),(\d{1,2})/;
		
		my $inv_timestamp = timelocal($sec,$min,$hour,$mday,$mon,$year);
#               print "$ma,$pa,$kernels,$date,$time,$sleeve     $inv_timestamp\n";



                if ( !exists $current_inventory{$ma} ) {
                    
		        if ( $kernels =~ /[a-z_]+/ ) { 	
			        $current_inventory{$ma} = join("::",$inv_timestamp,$kernels,$sleeve,$pa,$date,$time);
			        }
                        elsif ( ( $kernels =~ /\d+/ ) && ( $kernels != 0 ) ) {
			        $current_inventory{$ma} = join("::",$inv_timestamp,$kernels,$sleeve,$pa,$date,$time);
			        }
                        else {}       

		        }
		
                else {
                        my ($pinv_timestamp,$pkernels) = split(/::/,$current_inventory{$ma});    
#			print "$ma:  $pinv_timestamp $pkernels\n";
			if ( ( defined($pinv_timestamp) )
			     && ( $inv_timestamp > $pinv_timestamp ) ) {


# a little lazy type-testing is needed to avoid Perl's coercing
# the strings to numbers in the context of the numerical equality test.
# Regex is the simplest and probably the fastest, and skips the equality test
# altogether.  For more sophisticated type-testing in Perl, see
#
# https://stackoverflow.com/questions/12686335/how-to-tell-apart-numeric-scalars-and-string-scalars-in-perl

                                if ( $kernels =~ /\b0\b/ ) {
				        delete $current_inventory{$ma};				
#				        print "DELETING $ma x $pa, $pkernels now $kernels\n";
				        }
			        
				else {
				        $current_inventory{$ma} = join("::",$inv_timestamp,$kernels,$sleeve,$pa,$date,$time);
#				        print "revising $ma x $pa, $pkernels now $kernels\n";
				        }
			        }
			else {}
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
#     separate into the keys of the 4d hash;
#     find beginning of sleeves that match {$inv_cropyr}{$inv_croppart}{$key}
#     find sleeve that begins with closest rowplant below the ear
#
# finesse the 06R inbred problem (I in numerical genotypes, so a numerical
# comparison won't work) by searching with the substituted marp string (s/I/0/).
#
#
#
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
# ceiling of current ear.  See below.



foreach my $ma ( sort ( keys %current_inventory ) ) {
        my ($macropyr,$macroppart,$makey,$marp) = &explode_num_gtype($ma);

        my $sarp = $marp;
	$sarp =~ s/I/0/;

	my $sleeve = &ear_floor($macropyr,$macroppart,$makey,$sarp);
        my ($sc_date,$sc_time,$observer) = @{$scootchies{$sleeve}};

	my ($inv_timestamp,$kernels,$old_sleeve,$pa,$inv_date,$inv_time) = split("::",$current_inventory{$ma});


        $new_inventory{$macropyr}{$macroppart}{$makey}{$sarp} = [ ($ma,$pa,$kernels,$sc_date,$sc_time,$observer,$sleeve) ];

#	print "$ma $pa $kernels $sc_date $sc_time $observer $sleeve $old_sleeve \n";
        }


# if ( $flag eq 'q' ) { print Dumper \%new_inventory; }













# aliasing of STDOUT to file handle from
# https://stackoverflow.com/questions/16060919/alias-file-handle-to-stdout-in-perl

my $outfh;
if ( $flag eq 'test' ) { $outfh = *STDOUT; }
elsif ( $flag eq 'go' ) {
	open $outfh, '>', $inventory_file or die "sorry, can't open the output file $inventory_file\n";
        }






# Previous data are commented out with double %s so they can be easily
# found.  New data are appended to the end of the file so that subsequent
# inventory increments are adjacent.
#
# First seven lines of the file are fixed.  Some extraneous blank lines are
# skipped.


if ( $flag ne 'q' ) {

        for my $i (0..6) { print $outfh $originals[$i]; }
        print $outfh "% previous inventory data and their accompanying comments are\n% commented out with %% .\n% The most recent data are at the bottom of the file (search for 'newest data').\n% The most recent scootching was done on $today.\n\n\n\n\n";
        for my $i (22..$#originals) { print $outfh "%% $originals[$i]"; }


        print $outfh "\n\n\n\n\n\n%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% newest data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n\n\n\n% these are the scootched inventory facts computed by\n% ../../data/data_conversion/scootch_sleeve_bdries.perl\n% on $today\n% using the current version of the\n% $sleeve_file data.\n% nb:  06R inbreds with decimal rowplants may not be in the indicated sleeve.\n\n";







# sort the scootched into inventory order before output
# output fact rewritten with sleeve and inventory date, time; append to inventory.pl	
#
# cropyrs sort correctly
# print join("\n",sort qw [13 14 15 06 07 08 09 10 11 12 16 17 18]) . "\n";
#
# crop particles do not, unless reversed, hence $b cmp $a
# print join("\n",reverse sort qw [R N G]) . "\n"
#
# the 06R inbreds with decimal rowplants may not be in the correct places
#
# direct crib from update_inventory.perl!


        foreach my $macropyr ( sort keys %new_inventory ) {
    
                foreach my $macroppart ( sort { $b cmp $a } keys %{ $new_inventory{$macropyr} } ) {
                        foreach my $makey ( sort keys %{ $new_inventory{$macropyr}{$macroppart} } ) {
                                foreach my $sarp ( sort keys %{ $new_inventory{$macropyr}{$macroppart}{$makey} } ) {
			
                                        my ($ma,$pa,$kernels,$sc_date,$sc_time,$observer,$sleeve) = @{$new_inventory{$macropyr}{$macroppart}{$makey}{$sarp}};
	
					my $fact = "inventory('" . $ma . "','" . $pa . "',num_kernels(" . $kernels . ")," . $observer . "," . $sc_date . "," . $sc_time . "," . $sleeve . ").";
			
                                        if ( $flag eq 'q' ) { }  # do nothing
                                        elsif ( ( $flag eq 'test' ) || ( $flag eq 'go' ) ) { print $outfh "$fact\n"}
				        }
			        }
                        }
                }



        print $outfh "\n\n\n\n";
        }










############################# subroutines ###############################


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
# note that the $marp here is really the $sarp in the caller;
# I've retained $marp as it's more descriptive and only my 06R
# numerical genotypes are substituted into, anyway.


# autovivification help from
# https://www.perlmonks.org/?node_id=800779
#
# however, it pays not to be too picky:  specifying
# "no autovivification 'exists'"
# introduces a 1 into the @famkeys on the second and later calls!
# spooky!  so just shut it off altogether.
#
#
#
# numerical tests on strings should (and do) succeed:
# https://perlmaven.com/scalar-variables
#
# https://stackoverflow.com/questions/3700069/how-can-i-check-if-a-key-exists-in-a-deep-perl-hash
#
#
#
# map trick for subtracting scalar from vector:
# https://stackoverflow.com/questions/23869082/how-to-subtract-1-from-all-array-elements-in-perl





sub ear_floor {
        my ($macropyr,$macroppart,$makey,$marp) = @_;

	my $sleeve;
	
	no autovivification;


#	print "\n\ninput: ($macropyr,$macroppart,$makey,$marp)\n";
        if ( $marp eq "0000000" ) {
		$sleeve = "v00000";
#		print "founder\n";
	        }
        else {

                my ($cropyr,$croppart,$key,$rp,$sleeve,$croppart_idx,$macroppart_idx);
                my @rps;
		my @famkeys;
		
		if ( $sleeve = $sleeves{$macropyr}{$macroppart}{$makey}{$marp}[0] ) {
			return $sleeve;
#			print "all: $sleeve\n";
		        }
	
	
                elsif ( ( exists $sleeves{$macropyr}{$macroppart}{$makey} )
			&& ( @rps = keys %{$sleeves{$macropyr}{$macroppart}{$makey}} )
		 	&& ( $sleeve = &find_rp_starting_sleeve($macropyr,$macroppart,$makey,$marp,\@rps) ) ) {
     	                return $sleeve;
#			print "lower rp: $sleeve\n";
		        }
	

	
		elsif ( ( exists $sleeves{$macropyr}{$macroppart} )
			&& ( @famkeys = keys %{$sleeves{$macropyr}{$macroppart}} )
		        && ( $sleeve = &find_famkey_starting_sleeve($macropyr,$macroppart,$makey,$marp,\@famkeys) ) ) {			
     	                return $sleeve;
#			print "lower famkey: $sleeve\n";
		        }
	


# catch anything else!
	
                else {
                        $sleeve = 'v99999';
                        print "\n\ninput: ($macropyr,$macroppart,$makey,$marp)\n";	  		     
 			print "case missing in find_rp_starting_sleeve\n";
     	                return $sleeve;
		        }	
	        }
        }













# different cases for famkey (this description is modified a bit in the code below):
#
# in the first two, 0 is present in the subtracted vector, and that's the index we want.
#
# input: (06,N,0,0000308)
# fba:   0  0000308
# bar:  0, 201, 301, 401
# foo:  0, 201, 301, 401
# baz:   0
#
# input: (12,N,504,0043008)
# fba:   504  0043008
# bar:  0, 205, 305, 405, 504, 661
# foo:  -504, -299, -199, -99, 0, 157
# baz:   4
#
#
#
#
#
# in the third, no zero, need to look for sign flip
#
# input: (12,N,655,0034904)
# fba:   655  0034904
# bar:  0, 205, 305, 405, 504, 661
# foo:  -655, -450, -350, -250, -151, 6
# baz:   5
#
# in the fourth case, the crop particle is different, so it's not
# in this subroutine
#
# fourth case in &find_famkey_starting_sleeve is actually this next one,
# because crop particle is now changed;
#
# no, that's incorrect; we have a 07G sleeve start, it's just with a different family, so
# the case belongs here.
#		
# in the fourth, there is a zero, so belongs with first and second; no sign flip, crop mismatch
#
# input: (07,G,0,0001402)
# fba:   0  0001402
# bar:  401
# foo:  401
# baz:   0
#
#
#
# in the fifth, no zeroes, no positives, need largest negative number
# 
# input: (10,R,902,0039501)
# fba:   902  0039501
# bar:  0, 205, 305, 405
# foo:  -902, -697, -597, -497
# baz:   -1



sub find_famkey_starting_sleeve {
        my ($macropyr,$macroppart,$makey,$marp,$famkey_ref) = @_;

	my $sleeve;
	
        my @sorted = sort @{$famkey_ref};	
	my @subtracted = map { $_ - $makey } @sorted;
	my $baz = first_index { $_ == 0 } @subtracted;

	
#	 print "fba:  $makey  $marp\n";
#        print "bar:  " . join(", ",@sorted) . "\n";
#        print "foo:  " . join(", ",map { $_ - $makey } sort @{$famkey_ref}) . "\n";
#        print "baz:  $baz\n";



        if ( $baz != -1 ) {
                my $famkey = $sorted[$baz];
                my @rps = sort ( keys %{$sleeves{$macropyr}{$macroppart}{$famkey}} );
#                print "fmk:  $famkey\n";
#                print "rps:  " . join(", ",@rps) . "\n";

		
# if first rp greater than marp, back up one sleeve
# if last rp less than marp, go up one sleeve
# if last rp doesn't exist and first rp less than marp, go up one sleeve
		
                my $first_rp = shift @rps;
                my $last_rp = pop @rps;

		
                my $neighbor_sleeve;
                if ( $first_rp > $marp ) {
                        $neighbor_sleeve = $sleeves{$macropyr}{$macroppart}{$famkey}{$first_rp}[0];
			$sleeve = &adjust_sleeve($neighbor_sleeve,'dec');
		        }
                elsif ( ( defined($last_rp) ) && ( $last_rp < $marp ) ) {
                        $neighbor_sleeve = $sleeves{$macropyr}{$macroppart}{$famkey}{$last_rp}[0];
			$sleeve = &adjust_sleeve($neighbor_sleeve,'inc');
		        }
                elsif ( ( !defined($last_rp) ) && ( $first_rp < $marp ) ) {
                        $neighbor_sleeve = $sleeves{$macropyr}{$macroppart}{$famkey}{$first_rp}[0];
			$sleeve = &adjust_sleeve($neighbor_sleeve,'inc');
		        }

		else { return; }
  	        }


	else {
		my $key;
                my $rp;
		my @rps;
		my $fub;

		
                if ( all { $makey < $_ } @sorted ) {
                        $key = shift @{$famkey_ref};
			@rps = sort ( keys %{$sleeves{$macropyr}{$macroppart}{$key}} );
			$rp = shift @rps;
                        my $neighbor_sleeve = $sleeves{$macropyr}{$macroppart}{$key}{$rp}[0];
			$sleeve = &adjust_sleeve($neighbor_sleeve,'dec');
#                        print "all smaller\n";
#                        print "key: $key\n";
#                        print "nsv:  $neighbor_sleeve\n";
#			 print "slv:  $sleeve\n";
		        }

                elsif ( all { $makey > $_ } @sorted ) {
                        $key = pop @{$famkey_ref};
			@rps = sort ( keys %{$sleeves{$macropyr}{$macroppart}{$key}} );
			$rp = pop @rps;
                        $sleeve = $sleeves{$macropyr}{$macroppart}{$key}{$rp}[0];
#                        print "all bigger\n";
#                        print "key: $key\n";
#			 print "slv:  $sleeve\n";
		        }



# one more case:  famkeys in sleeves bracket the makey.  e.g.,
#
# input: (12,R,504,0014007) -- 0014106
# input: (13,R,405,0001301) -- 0033005
		
                elsif ( ( $fub = first_index { $_ > $makey } @sorted )
                        && ( $sorted[$fub-1] < $makey ) ) {

                        $key = $sorted[$fub-1];
			@rps = sort ( keys %{$sleeves{$macropyr}{$macroppart}{$key}} );
			$rp = pop @rps;
			
                        $sleeve = $sleeves{$macropyr}{$macroppart}{$key}{$rp}[0];

#	 	         print "\n\ninput: ($macropyr,$macroppart,$makey,$marp)\n";			
#			 print "bracketing\n";
#                        print "bar:  " . join(", ",@sorted) . "\n";
#                        print "foo:  " . join(", ",@subtracted) . "\n";
#                        print "key:  $key\n";
#                        print "rp :  $rp\n";			
#                        print "slv:  $sleeve\n";
		        }



# looks like no more cases!
#
# Kazic, 22.11.2018
		
		else {
                        print "\n\ninput: ($macropyr,$macroppart,$makey,$marp)\n";	  		     
 			print "case missing in find_famkey_starting_sleeve\n";
			return;
		        }
	        }
        return $sleeve;
        }













# returns the bounding rp, not the sleeve itself, to suit call to
# hash in ear_floor
#
# fails if no sign flip, therefore lower bounding sleeve, is found
#
#
# for discussion of Perl Booleans, see
# https://stackoverflow.com/questions/39541833/what-values-should-a-boolean-function-in-perl-return


sub find_rp_starting_sleeve {
        my ($macropyr,$macroppart,$makey,$marp,$rps_ref) = @_;

        my $sleeve;

	my $rp;
        my @sorted = sort @{$rps_ref};
	my @subtracted = map { $_ - $marp } @sorted;
	my $baz = first_index { $_ !~ /\-/ } @subtracted;
	
#        print "rar:  " . join(", ",@sorted) . "\n";
#        print "foo:  " . join(", ",map { $_ - $marp } @sorted) . "\n";
#        print "baz:  $baz\n";

	
	if ( $baz > 0 ) {
		$rp = $sorted[$baz-1];
                $sleeve = $sleeves{$macropyr}{$macroppart}{$makey}{$rp}[0];                
	        }



	elsif ( $baz < 0 ) {
		my ($min,$max) = minmax(@subtracted);
                my $rp_idx = first_index { $_ eq $max } @subtracted;
                $rp = $sorted[$rp_idx];
# 		 print "mms:  $min   $max\n";
#                print "rpi:  $rp_idx\n";
                $sleeve = $sleeves{$macropyr}{$macroppart}{$makey}{$rp}[0];
	        }

# equivalent to false in Perl
	
	else { return; }
        }












sub adjust_sleeve {
	my ($neighbor_sleeve,$dir) = @_;

        my ($prefix,$zeroes,$num) = $neighbor_sleeve =~ /(v)(0{0,5})(\d{0,5})/;
        my $change;

#	print "pre:  $neighbor_sleeve  $dir  $prefix  $zeroes  $num\n";
	
	if ( $dir eq 'dec' ) { $change = $num - 1; }
	else { $change = $num + 1; }

	if ( length($change) > length($num) ) { chop($zeroes); }
	elsif ( length($change) < length($num) ) { $zeroes .= '0'; }
        my $sleeve = $prefix . $zeroes . $change;
	return $sleeve;
        }


