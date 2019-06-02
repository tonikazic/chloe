#!/opt/perl5/perls/perl-5.26.1/bin/perl



# this is ../c/maize/crops/scripts/make_seed_packet_file.perl 

# If we don't have any prolog, we still need to generate the seed_packet_labels
# file from sequenced.packing_plan.pl.  So this script does that.
#
# 
# call is perl ./make_seed_packet_file.perl CROP
#
# Kazic, 23.5.2017



# converted to run in perl 5.26
#
# Kazic, 13.6.2018



# toggled off warnings to track down how uninitialized value is inserted
# into %inventory
#
# Kazic, 2.6.2019

use strict;
# use warnings;

use Cwd 'getcwd';
use Time::Local 'timelocal';



use lib '../../label_making/Typesetting/';
use DefaultOrgztn;
use MaizeRegEx;




# our $crop = $ARGV[0]; in DefaultOrgztn


my $local_dir = getcwd;
my ($dir) = &adjust_paths($crop,$local_dir);

my $uccrop = uc($crop);



my $today = `date`;
chomp($today);


my %inbred;
my %inventory;



my $input_file = $dir . $planning_root . "sequenced.packing_plan.pl";
my $out_file = $input_dir . "seed_packet_labels";
my $inbred_file = $demeter_dir . "current_inbred.pl";
my $inventory_file = $demeter_dir . "inventory.pl";

# print "i: $input_file\no: $out_file\nd: $inbred_file\nv: $inventory_file\n";







# get the family numbers for the current inbreds and elite corn

open my $inbred_fh, '<', $inbred_file or die "sorry, can't open input file $inbred_file\n";

while (<$inbred_fh>) {
        if ( $_ =~ /$uccrop/ ) { 
	        my ($ima,$cur,$packet) = $_ =~ /\',(\d{3}),\d{3},(\d{3}),(p\d{5})\).$/;
#                print "($ima,$cur,$packet)\n";
                $inbred{$ima} = $cur . "::" . $packet;
                }
        }











# read the inventory file and get the current sleeves for the final output
#
# hmmm, I am still missing a condition that prevents putting uninitialized values in the hash
# error is thrown when generating final output
#
# Kazic, 2.6.2019


open my $inventory_fh, '<', $inventory_file or die "sorry, can't open input file $inventory_file\n";

while (<$inventory_fh>) {
        if ( ( $_ =~ /inventory/ ) && ( $_ !~ /%/ ) ) {
	        my ($vma,$vpa,$date,$time,$sleeve) = $_ =~ /inventory\(\'(${num_gtype_re})\',\'(${num_gtype_re})\',.+,date\((${prolog_date_innards_re})\),time\((${prolog_time_innards_re})\),(${sleeve_re})/;

                my ($mday,$mon,$year) = $date =~ /(\d+),(\d+),(\d+)/;
		my ($hour,$min,$sec) = $time =~ /(\d+),(\d+),(\d+)/;
		my $timestamp = timelocal($sec,$min,$hour,$mday,$mon,$year);
#		print "($vma,$vpa,$mday,$mon,$year,$hour,$min,$sec,$sleeve) $timestamp\n";

                if ( !exists $inventory{$vma} ) { $inventory{$vma} = join("::",$timestamp,$vpa,$sleeve); }
		else {
                        my ($ptimestamp,$pvpa,$psleeve) = split(/::/,$inventory{$vma});
                        if ( ( defined($ptimestamp) ) && ( $timestamp > $ptimestamp ) && ( $pvpa eq $vpa ) ) {
                                $inventory{$vma} = join("::",$timestamp,$vpa,$sleeve);
#				print "substituting $sleeve for old $psleeve for ma $vma\n";
			        }
		        }
                }
        }









open my $in, '<', $input_file or die "sorry, can't open input file $input_file\n";
open my $out, '>', $out_file or die "can't open $out_file\n";



print $out "% this is $out_file
% generated by ../maize/crops/make_seed_packet_file.perl
% on $today for crop $crop.
%
% This file does not have the packets in inventory order!
% Re-ordering must be done manually before generating the labels!
% \n\n\n";





my $p = 10;

while (<$in>) {

        if ( $_ =~ /^packing_plan/ ) {
	        my ($row,$num_packets,$elite,$planting,$rest,$ma,$pa,$cl,$ft,$family,$pnum,$padding,$packet,$ma_ifam,$record);

#		print $_;
		
                if ( $_ =~ /elite/ ) { 
		        ($row,$num_packets,$elite,$planting,$rest) = $_ =~ /^packing_plan\((\d+),(\d+),\[(elite)\],(${planting_re}),(.*)/; 
		        $ma = $elite;
		        $pa = $ma;
                        }

		
                else {
                        ($row,$num_packets,$ma,$pa,$planting,$rest) = $_ =~ /^packing_plan\((\d+),(\d+),\[\'(${num_gtype_re})\'?[,x\s\']+(${num_gtype_re})\'\],(${planting_re}),(.*)/; 
		        }



                ($cl,$ft) = $rest =~ /(${cl_re}),(${ft_re})\)\.$/;



		
		
# family and packet assignment

# included condition to prevent individual numbering of elite corn packets
#
# Kazic, 2.6.2019

		if ( ( $ma !~ /xxxx/ ) && ( $ma !~ /elite/ ) ) { 
                        $family = '0000'; 
                        $pnum = length($p);
			$padding = 5 - $pnum;
			$packet = "p" . "0" x $padding . $p;
			$p++;
		        }
		
                elsif ( $ma =~ /\d{2}[NRG](\d{3})\:/ ) {
			($ma_ifam) = $ma =~ /\d{2}[NRG](\d{3})\:/;
			$record = $inbred{$ma_ifam};
		        ($family,$packet) = split(/::/,$record);
		        }


		
# ugly hard-wired kludge for the elite corn for now
#
# Kazic, 1.6.2019
			
		else {
			$record = $inbred{891};
		        ($family,$packet) = split(/::/,$record);
		        }

                
		
#                print "($row,$num_packets,$ma,$pa,$planting,$cl,$ft,$family,$packet)\n";



		
# now after all this, print the re-arranged line with the current sleeve to the output file
#
# Kazic, 2.6.2019


                my ($ts,$vpa,$sleeve) = split(/::/,$inventory{$ma});

                if ( ( $ma =~ /xxxx/ ) || ( $ma =~ /elite/ ) ) { $sleeve = "x00020"; }
		elsif ( $pa eq $vpa ) { }
		else { print "Warning! planned pa $pa does not match inventory pa $vpa for ma $ma!\n"; }

		print $out "$packet,$family,$ma,$pa,$cl,$ft,$sleeve,$num_packets,$row,$planting\n";
	        }
	}


