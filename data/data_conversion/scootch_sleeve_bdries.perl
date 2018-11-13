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
                my ($first_ma,$last_ma,$sleeve) = $_ =~ /sleeve_bdry\(\'(${num_gtype_re})\',\'(${num_gtype_re})\',(${sleeve_re})/;

		
                my ($fcrop,$ffam,$frp) = $first_ma =~ /(${crop_re})(${family_re}):[SWMBEPL]?(${old_rowplant_re})$/;
                my ($lcrop,$lfam,$lrp) = $last_ma =~ /(${crop_re})(${family_re}):[SWMBEPL]?(${old_rowplant_re})$/;

                my ($fcropyr,$fcroppart) = $fcrop =~ /(\d{2})(\w)/;
                my ($lcropyr,$lcroppart) = $lcrop =~ /(\d{2})(\w)/;

		my ($fkey, $lkey);
                if ( length($ffam) == 3 ) { $fkey = $ffam; } else { $fkey = 0; }
                if ( length($lfam) == 3 ) { $lkey = $lfam; } else { $lkey = 0; }
		

		$sleeves{$fcropyr}{$fcroppart}{$fkey}{$frp} = $sleeve . "::" . $first_ma;
                $sleeves{$lcropyr}{$lcroppart}{$lkey}{$lrp} = $sleeve . "::" . $last_ma;
	        }
        }



# if ( $flag eq 'q' ) { print Dumper \%sleeves; }









# %inventory now structured differently so find the most 
# recent datum.  This will include packets with 0 kernels.


foreach my $elt (@grep_array) { 

    
        my ($ma,$pa,$kernels,$date,$time,$sleeve) = $elt =~ /\'(${num_gtype_re})\',\'(${num_gtype_re})\',num_kernels\(([\w\_]+)\),${observer_re},date\((${prolog_date_innards_re})\),time\((${prolog_time_innards_re})\),(${sleeve_re})/;




# convert date and time to timestamp, compare timestamps for each ma
# as it comes through, update %current_inventory
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
			$current_inventory{$ma} = join("::",$inv_timestamp,$kernels,$sleeve,$pa,$date,$time);
#			print "revising $ma x $pa, $pkernels now $kernels\n";
		        }
	        }
        }











# stopped here

# for %current_inventory,
#
# write records to 4d hash for sorting into inventory order:  
# {cropyr}{crop_particle}{key}{rowplant} = record
#
# substituting new sleeve for old sleeve in the record

		
        # my ($inv_crop,$inv_fam,$inv_rowplant) = $ma =~ /(${crop_re})(${family_re}):\w?(${rowplant_re})/;
        # my ($inv_cropyr,$inv_croppart) = $inv_crop =~ /(\d{2})(\w)/;

	# my $key;
        # if ( length($inv_fam) == 3 ) { $key = $inv_fam; } else { $key = 0; }
        # $inventory{$inv_cropyr}{$inv_croppart}{$key}{$inv_rowplant} = $elt;





# rest is to be cribbed from update_inventory.perl
