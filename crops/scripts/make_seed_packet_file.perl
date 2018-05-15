#!/usr/bin/perl

# this is . . ./maize/crops/make_seed_packet_file.perl 

# If we don't have any prolog, we still need to generate the seed_packed_labels
# file from sequenced.packing_plan.pl.  So this script does that.
#
# 
# call is perl ./make_seed_packet_file.perl CROP
#
# Kazic, 23.5.2017


use lib qw(../label_making/);
use Typesetting::DefaultOrgztn;
use Typesetting::MaizeRegEx;

$crop = $ARGV[0];
$uccrop = uc($crop);

print `pwd`;

$today = `date`;
chomp($today);


$in_file = "$crop/planning/sequenced.packing_plan.pl";
$out_file = "$crop/management/seed_packet_labels";



$demeter_dir =~ s/^\.\.\///;
$inbred_file = $demeter_dir .  "current_inbred.pl";





# get the family numbers for the current inbreds.

open(INBRED,"<$inbred_file") or die "can't open $inbred_file\n";

while (<INBRED>) {
        if ( $_ =~ /$uccrop/ ) { 
	        ($ima,$cur,$packet) = $_ =~ /\',(\d{3}),\d{3},(\d{3}),(p\d{5})\).$/;
#                print "($ima,$cur,$packet)\n";
                $inbred{$ima} = $cur . "::" . $packet;
                }
        }

close(INBRED);







open(IN,"<$in_file") or die "can't open $in_file\n";
open(OUT,">$out_file") or die "can't open $out_file\n";

print OUT "% this is $out_file
% generated by ../maize/crops/make_seed_packet_file.perl
% on $today for crop $crop.
%
% This file does not have the packets in inventory order!
% Re-ordering must be done manually before generating the labels!
% \n\n\n";





$p = 10;

while (<IN>) {

       if ( $_ =~ /^packing_plan/ ) {
                if ( $_ =~ /elite/ ) { 
		        ($row,$num_packets,$elite,$planting,$rest) = $_ =~ /^packing_plan\((\d+),(\d+),\[(elite)\],(${planting_re}),(.*)/; 

		        $ma = $elite;
		        $pa = $ma;
                        ($cl,$ft) = $rest =~ /(${cl_re}),(${ft_re})\)\.$/;
                        }

                else {
                        ($row,$num_packets,$ma,$pa,$planting,$rest) = $_ =~ /^packing_plan\((\d+),(\d+),\[\'(${num_gtype_re})\'?[,x\s\']+(${num_gtype_re})\'\],(${planting_re}),(.*)/; 

                        ($cl,$ft) = $rest =~ /(${cl_re}),(${ft_re})\)\.$/;
		        }


		
# family and packet assignment

		if ( $ma !~ /xxxx/ ) { 
                        $family = '0000'; 
                        $pnum = length($p);
			$padding = 5 - $pnum;
			$packet = "p" . "0" x $padding . $p;
			$p++;
		        }
		
                else { 
		        ($ma_ifam) = $ma =~ /\d{2}[NRG](\d{3})\:/;
                        $record = $inbred{$ma_ifam};
                        ($family,$packet) = split(/::/,$record);
                        }
		
#                print "($row,$num_packets,$ma,$pa,$planting,$cl,$ft,$family,$packet)\n";


# now after all this, print the re-arranged line to the output file
# stopped here

		print OUT "$packet,$family,$ma,$pa,$cl,$ft,v00,$num_packets,$row,$planting\n";

	        }
	}

close(IN);
close(OUT);


