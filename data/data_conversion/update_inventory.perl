#!/usr/local/bin/perl

# this is ../c/maize/data/data_conversion/update_inventory.perl
#
# given a file of the harvest facts for successful, un-discarded ears from
# a given crop, whether or not they have been manually sorted
# into their filing order, generate the increment to the inventory.pl file
# without passing through intermediate files.
#
#
# The code presumes it is run after each harvest is dried, shelled, and filed.
# It's not meant for re-inventorying the entire collection (see
# scootch_sleeve_bdries.perl for that).
#
#
# Ears that have failed completely or been tossed are filtered out by grep
# (' cl' and removal of '0 cl' and 'discarded').
#
#
# The code relies on ../../demeter/data/sleeve_bdry.pl, generated from
# ../palm/raw_data_from_palms/*/*eta/*/sleeve_bdry.csv by
# ./convert_sleeve_bdry_data.perl.  The data should contain the first and
# last ma of each sleeve, and of any other groups of packets not represented
# by the first and last ma.
#
# Kazic, 19.7.2018


# Now that I've written scootch_sleeve_bdries.perl, this script and
# that should be refactored together!  Maybe someday.
#
# Kazic, 23.11.2018




# call is perl ./update_inventory.perl CROP FLAG
#
# where CROP is the crop for which we need the inventory facts and
# FLAG is one of {go,q,test}.





use strict;
use warnings;



use Cwd 'getcwd';
use Date::Calc 'Today_and_Now';
use Data::Dumper 'Dumper';
use List::MoreUtils 'first_index';



use lib '../../label_making/Typesetting/';
use DefaultOrgztn;
use MaizeRegEx;



my $local_dir = getcwd;
my ($dir,$input_dir) = &adjust_paths($crop,$local_dir);



my $flag = $ARGV[1];



my $harvest_file = $demeter_dir . "harvest.pl";
my $inventory_file = $demeter_dir . "inventory.pl";
my $sleeve_file = $demeter_dir . "sleeve_bdry.pl";

# print "harvest: $harvest_file\ninvntry: $inventory_file\nslev_bd: $sleeve_file\n";





my $today = `date`;
chomp($today);
my ($year,$month,$day,$hour,$min,$sec) = Today_and_Now();

my %inventory;
my $out;
my %sleeves;












# filter out irrelevant lines and write into an array
#
# the best help is this grep/map/sort tutorial:
#
# http://www.hidemail.de/blog/perl_tutor.shtml


my $grep_crop = uc($crop);


# how come no whining here about scalars?  or did I just ignore it?
#
# Kazic, 2.9.2018

open my $har_fh, '<', $harvest_file or die "sorry, can't open the harvest file $harvest_file\n"; 
my @grep_array = grep { $_ =~  /${grep_crop}/ && $_ !~ /\%/ && $_ !~ /\d{0}0 cl/ && $_ !~ /discarded/ } <$har_fh> ;

# foreach my $elt (@grep_array) { print "$elt"; } 













# grab the sleeve boundary data and stuff into a similar hash
# read from that hash when sorting and outputting the inventory


# this assumes that each sleeve's fact is unique in the file, requiring one
# comment out prior data.  It would be better to collect each fact's date
# and then take the most recent fact for each sleeve, issuing a warning to
# comment out obsolete facts.
#
# Kazic, 14.5.2020



# ah.  If a family is not represented in the sleeve boundary data, then it won't
# appear in the hash and the key will be undef.
#
# In 19r, this happens with families
#        205 --- completely contained in sleeve v00225
#        405 --- completely contained in sleeve v00226
#
# here is the relevant portion of %sleeves:
#
          # '19' => {
          #           'R' => {
          #                    '0' => {
          #                             '0002308' => 'v00220::19R4753:0002308',
          #                             '0010912' => 'v00224::19R4671:0010912',
          #                             '0007607' => 'v00223::19R4766:0007607',
          #                             '0003403' => 'v00220::19R4225:0003403',
          #                             '0007603' => 'v00222::19R4766:0007603',
          #                             '0005408' => 'v00222::19R4656:0005408',
          #                             '0003405' => 'v00221::19R4225:0003405',
          #                             '0009814' => 'v00224::19R4267:0009814',
          #                             '0010914' => 'v00225::19R4671:0010914',
          #                             '0005407' => 'v00221::19R4656:0005407',
          #                             '0009810' => 'v00223::19R4267:0009810'
          #                           },
          #                    '505' => {
          #                               '0002012' => 'v00226::19R505:B0002012',
          #                               '0002207' => 'v00227::19R505:B0002207',
          #                               '0002014' => 'v00227::19R505:B0002014'
          #                             },
          #                    '305' => {
          #                               '0000604' => 'v00225::19R305:W0000604',
          #                               '0000606' => 'v00226::19R305:W0000606'
          #                             }
          #                  }
          #         },
#
#
# ok, case handled --- see modifications below to &find_sleeve
#
# Kazic, 19.5.2020



open my $slv_fh, '<', $sleeve_file or die "sorry, can't open the sleeve_bdry file $sleeve_file\n"; 

while (<$slv_fh>) {

        if ( ( $_ =~ /^sleeve_bdry/ ) && ( $_ !~ /^[\%\n\r\t]/ ) ) {      
                my ($first_ma,$last_ma,$sleeve) = $_ =~ /sleeve_bdry\(\'(${num_gtype_re})\',\'(${num_gtype_re})\',(${sleeve_re})/;

#		print "($first_ma,$last_ma,$sleeve)\n";
		
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



# if ( ( $flag eq 'test' ) || ( $flag eq 'q' ) ) { print Dumper \%sleeves; }


















# grab the harvest data, filtering out the most useless entries, and
# store the data in a 3d hash for sorting into inventory order on output


foreach my $elt (@grep_array) { 


        if ( $elt !~ /^harvest/ ) { print $elt; }

        else {


# we're now including failed ears with a few kernels, even though these are
# very suspect.
#
# Kazic, 10.3.2015
#
#                ($ma,$pa,$comment,$observer) = $_ =~ /\'(${num_gtype_re})\',\'(${num_gtype_re})\',succeeded,\'?(${notes_re})\'?,(${observer_re})/;

                my ($ma,$pa,$comment,$observer) = $elt =~ /\'(${num_gtype_re})\',\'(${num_gtype_re})\',\w{6,9},\'?(${notes_re})\'?,(${observer_re})/;

#                print "$ma,$pa,$comment,$observer\n";

		my $num_cl;
                if ( $comment eq "_" ) { $num_cl = 'whole'; }
                elsif ( $comment =~ /${word_cl_re}/ ) { ($num_cl) = $comment =~ /(${word_cl_re})/; }
                else { ($num_cl) = $comment =~ /(\d+ cl)/; }
                $num_cl =~ s/ cl//g;
		
		my $record = "inventory(\'$ma\',\'$pa\',num_kernels($num_cl),$observer,date($day,$month,$year),time($hour,$min,$sec)";




# write records to 4d hash for sorting into inventory order:  
# {cropyr}{crop_particle}{key}{rowplant} = record
		
                my ($inv_crop,$inv_fam,$inv_rowplant) = $ma =~ /(${crop_re})(${family_re}):\w?(${rowplant_re})/;
                my ($inv_cropyr,$inv_croppart) = $inv_crop =~ /(\d{2})(\w)/;

		my $key;
                if ( length($inv_fam) == 3 ) { $key = $inv_fam; } else { $key = 0; }
                $inventory{$inv_cropyr}{$inv_croppart}{$key}{$inv_rowplant} = $record;
	        }
        }








# if ( ( $flag eq 'test' ) || ( $flag eq 'q' ) ) { print Dumper \%inventory; }















# make the header for the inventory update for that crop


if ( $flag eq 'go' ) {

        my $hfn = $harvest_file;
        $hfn =~ s/\.\.\/\.\.\/demeter\/data\//\.\//;

	
        open $out, '>>', $inventory_file or die "can't open output file inventory_file\n";
        print $out "% this is the increment to the inventory for $crop
%
% generated on $today by ../c/maize/crops/scripts/make_inventory_update.perl
% from the filtered harvest file $hfn.
%
% Packets from pollinations that failed have been retained if they have a few kernels.
% However, these are very suspect and should only be used in dire emergency.
%
% Data are sorted into inventory order.
% 
% inventory(MaPlantID,PaPlantID,NumKernels,Observer,Date,Time,v00).\n\n\n";
        }












# sort into inventory order and output

foreach my $inv_cropyr ( sort keys %inventory ) {

    
# reversing sort produces R, N, G if just year is supplied in initial call
#
# Kazic, 16.7.2018
    
        foreach my $inv_croppart ( sort { $b cmp $a } keys %{ $inventory{$inv_cropyr} } ) {
                foreach my $famkey ( my @crop_fams = sort keys %{ $inventory{$inv_cropyr}{$inv_croppart} } ) {
			foreach my $rp ( sort keys %{ $inventory{$inv_cropyr}{$inv_croppart}{$famkey} } ) {
		
                                my $value = $inventory{$inv_cropyr}{$inv_croppart}{$famkey}{$rp};
				my ($ma_plant) = $value =~ /inventory\(\'(${num_gtype_re})/;


#				print "($inv_cropyr,$inv_croppart,$famkey,$rp,$ma_plant)\n";
			        my $inv_sleeve = &find_sleeve($inv_cropyr,$inv_croppart,$famkey,$rp,$ma_plant,@crop_fams);

		
                                if ( $flag eq 'q' ) { }  # do nothing
                                elsif ( $flag eq 'test' )  { print $inventory{$inv_cropyr}{$inv_croppart}{$famkey}{$rp} . "," . $inv_sleeve . ").\n"; }
                                elsif ( $flag eq 'go' ) { print $out $inventory{$inv_cropyr}{$inv_croppart}{$famkey}{$rp} . "," . $inv_sleeve . ").\n"}
			        }
		        }
                }
        }














########## subroutine


# basic idea:  a $ma_plant must be equal or greater than the first ma in 
# a sleeve and less than or equal to the last ma in a sleeve
#
# pure lexigraphic sort won't do, as the same sleeve can contain seed 
# from two different crops, e.g., 06R and 06N
#
#
# So:
#       a sleeve can have packets from multiple crops;
#       a sleeve can have both mutant and inbred families;
#       a sleeve can have more than two groups of families or crops.
#
#
# if a sleeve has two types of families (say mutant and S), then the
# first_ma and last_ma will have both families and the family key of 
# an incoming packet will be in one of those categories of family.
#
# if a sleeve has more than two types of families (say mutant, S, W, M), then
# the family key of an incoming packet will lie between the family keys of
# the first_ma and last_ma of the sleeve.
#
# in either case, the rp of the incoming packet should be greater than or equal to
# the rp of the first_ma.
#
# NOTE ADDED 18.5.2020:  no, not necessarily.  It depends on how the corn was planted.
#
#
# if the sleeve has multiple family keys, and the family key of the incoming packet is the
# same as last ma, then its rp must be less than or equal to last ma's rp.
#
# if the family key of the incoming packet is less than the family key of the last ma, then
# its rp can be anything, since multiple plantings of the same inbred are 
# in nonsequential rows in the field.
#
#
#
# we are searching only in the hash that has the right family key,
# and the hash contains entries for both first_ma and last_ma
#		
# if a packet is the first packet in the sleeve, the index is 0 or positive
# if a packet is in the sleeve, or is the last packet, the index is positive
#
# if the packet is in the sleeve, but the last_ma is in a different family,
# the index is -1, but the sleeve is correct
#
# if a sleeve contains three different groups --- e.g., mutant and two inbreds, or
# three different crops --- the middle group will not be in a hash using our present
# method of scanning just the first and last packet in a sleeve.  In the code, test
# for this condition; and in collecting the data, scan the first and last packet of the 
# middle group(s).
#
#
# NOTE ADDED 18.5.2020:  NO, can't have more than one fact for each sleeve in sleeve_bdry.
# So instead, the code must handle this case.
#
# When a family is wholly subsumed in a sleeve but not found at the
# boundary, an undef key is produced in the %inventory.  This triggers
# hunting through the %sleeves hash to find the bounding seed packets.
#
# Kazic, 19.5.2020



# slicing up hashes:
#
# http://archive.oreilly.com/oreillyschool/courses/Perl3/Perl3-08.html
# http://perldoc.perl.org/perldata.html
#
# https://stackoverflow.com/questions/1781700/how-do-i-get-a-hash-slice-from-a-hash-of-hashes
# https://stackoverflow.com/questions/18133768/slicing-hash-of-hashes-perl
#
#
# perl maven on the meaning of undef:
# https://perlmaven.com/undef-and-defined-in-perl








# $terminal_ma is included for checking only

sub find_sleeve {
        my ($inv_cropyr,$inv_croppart,$famkey,$rp,$ma_plant,@crop_fams) = @_;
	
        my ($inv_sleeve,$terminal_ma);
	


# pull out the part of the inventory hash directly relevant to this ma
#
# @hash_refs is an array of hash references; when traversed by Dumper, 
#         print Dumper \@hash_refs;
# it looks like an array of hashes	

	my @hash_refs = @{ $sleeves{$inv_cropyr}{$inv_croppart} }{$famkey};

#        print Dumper \@hash_refs;
	



	
	
# copy the referenced hash into a new hash and pick it apart the usual way

	foreach my $hash_ref ( @hash_refs ) { 


# if $hash_ref == undef because a family in the inventory is not found in 
# a sleeve_bdry fact, then this fails
#
#   $VAR1 = [
#             undef
#           ];
#
# Kazic, 14.5.2020	

                if ( defined $hash_ref ) {
#			print "$hash_ref\n"; 


	                my %new_hash = %$hash_ref;
                        my @key_array = sort keys %new_hash;
#                        foreach my $key (@key_array) { print "$key\n"; }

		
                        my $upper_idx = first_index { $_ >= $rp } @key_array;
                        ($inv_sleeve,$terminal_ma) = split(/::/,$$hash_ref{$key_array[$upper_idx]});
#                        print "| $upper_idx | $key_array[$upper_idx] | $inv_sleeve | $terminal_ma |\n"; 
		        }





		

# find the sleeve for a packet whose family is not at a sleeve boundary
#
# what is the sleeve for the prior family with the largest rowplant AND
#         the sleeve for the next family with the lowest rowplant?
#
# that is the sleeve we want!		
#		
# Kazic, 19.5.2020
		

		else {
#			print "undef hash_ref!\n";
#                       foreach my $fam (@crop_fams) { print "$fam\n"; } 			
# 	                print "($inv_cropyr,$inv_croppart,$famkey,$rp,$ma_plant)\n";



# this trick and its details depend on how you organize your inventory
			
                        my ($prior_fam,$next_fam);
			if ( $famkey =~ /[34]\d{2}/ ) { $prior_fam = $famkey - 100; $next_fam = $famkey + 100; }
			if ( $famkey =~ /[2]\d{2}/ ) { $prior_fam = 0; $next_fam = $famkey + 100; }
                        if ( $famkey =~ /[5]\d{2}/ ) { $prior_fam = $famkey - 100; $next_fam = $famkey; }
			
#                        print "($famkey,$prior_fam,$next_fam)\n";				


                        my @prior_fam_mas = sort { $b cmp $a } keys %{ $sleeves{$inv_cropyr}{$inv_croppart}{$prior_fam} };
			my @next_fam_mas = sort { $a cmp $b } keys %{ $sleeves{$inv_cropyr}{$inv_croppart}{$next_fam} };

#                        print "\nprior:\n";
#                        print Dumper \@prior_fam_mas;
# 			 print "next:\n";			
#                        print Dumper \@next_fam_mas;			


                        my ($prior_sleeve) = split(/::/,%{ $sleeves{$inv_cropyr}{$inv_croppart}{$prior_fam} }{$prior_fam_mas[0]});
                        my ($next_sleeve) = split(/::/,%{ $sleeves{$inv_cropyr}{$inv_croppart}{$next_fam} }{$next_fam_mas[0]});

#                        print "$prior_sleeve   $next_sleeve\n";

                        if ( $prior_sleeve ne $next_sleeve ) {
				print "Warning! $ma_plant appears to be in two different sleeves, $prior_sleeve and $next_sleeve.  Check sleeve boundary data and inventory filing.\n";
				$inv_sleeve = "vxxxxx";
			        }

			else { $inv_sleeve = $prior_sleeve; }
		        }

	        }


	
        if ( ! defined $inv_sleeve ) { 
#                print "Warning! No sleeve found for $ma_plant\n";
                $inv_sleeve = "vxxxxx";
                }


#        print "| ($inv_cropyr,$inv_croppart,$famkey,$rp,$ma_plant) ";
#        print "| $ma_plant  | $inv_sleeve\n";	


        return $inv_sleeve;
        }


