#!/usr/local/bin/perl



# this is ../c/maize/crops/scripts/count_lines.perl
#
# a script to compute the lines in the different categories for
# pollinations and output the results to computable tables in an org file
#
# the org file generated should be substituted back into packing_plan.org, under strategy; 
# the tables prettified; others' rows inserted; and the new values calculated.
#
# note the over-planting factors and third planting inbreds are hard-wired 
# and may need to change with different inbreds!
#
# Data::Dumper is included to easily print the final %dest for debugging purposes
#
# help with multidimensional hashes from Gabor Szabo: http://perlmaven.com/multi-dimensional-hashes
#
#
# call is: ./count_lines.perl CROP
#
#
# Kazic, 5.6.2018



# hmmm, this may need revision, getting a lot of uninstantiated variables
#
# Kazic, 25.5.2020


use strict;
use warnings;

use Cwd 'getcwd';
use Lingua::EN::Words2Nums;
# use Data::Dumper 'Dumper';


use lib '../../label_making/Typesetting/';
use DefaultOrgztn;
use MaizeRegEx;



# our $crop = $ARGV[0]; in DefaultOrgztn


my $local_dir = getcwd;
my ($dir) = &adjust_paths($crop,$local_dir);





my $file = $dir . $planning_root . "packing_plan.org";
my $out = $dir . $planning_root . "line_counts.org";





my $today = `date`;
chomp($today);



my $lines = 0;
my $first = 0;
my $second = 0;
my $third = 0;
my $full = 0;
my $half = 0;
my $k = 0;
my $n = 0;
my $picks = 0;
my %dest;
my %pick;
my $flag = "off";





open my $in, '<', $file or die "can't open $file\n";
my $i = 0;

while (<$in>) {

        if ( $_ =~ /begin_src prolog\s+\:tangle yes/ ) { $flag = "on"; }
        elsif ($_ =~ /end_src/ ) { $flag = "off"; }


	$i++;
	
        my $planting;

        if ( ( $flag eq "on" ) && ( $_ =~ /^packing_plan/ ) && ( $_ !~ /\[inbred\]/ ) 
                               && ( $_ !~ /\[elite\]/ ) ) {

	    
	        my ($ma,$planting,$destinatn,$instructns,$ft) = $_ =~ /\[\'?(${num_gtype_re})\'?,\'?${num_gtype_re}\'?\],(\d),\[(.+)\],\'(${instructns_re})\',\'${knum_re}\',${ft_re},(${ft_re})/;

#  	        print "($ma,$planting,$destinatn,$instructns,$ft)\n";


                $lines++;
                if ( $planting eq "1" ) { $first++; }
                elsif ( $planting eq "2" ) { $second++; }
                elsif ( $planting eq "3" ) { $third++; }

                if ( $ft eq "20" ) { $full++; }
                elsif ( $ft eq "10" ) { $half++; }

#               print "($ma,$planting,$destinatn,$instructns,$ft) $lines  $first  $second $third $full $half\n";		
#  	        print "first: $first sec: $second third: $third full: $full half: $half\n";



# now increment the tally of lines for each destination, for each line 
# of the file.
#		
# Since there may be multiple destinations, test for each individually
# and increment its entry in the hash of hashes that maintains the tallies.
#
# tallies will be incremented for each destination of the current line;
# adjustments due to picking will occur in &picks below.
#
# $destinatn passed only for debugging purposes.
#
# Kazic, 14.5.2015


		
                if ( $destinatn =~ /\[self\]/ ) { &count_mutants("self",$planting,$destinatn,$instructns); }
                if ( $destinatn =~ /inc/ )      { &count_mutants("inc",$planting,$destinatn,$instructns); }
                if ( $destinatn =~ /\'B\'/ )    { &count_mutants("b",$planting,$destinatn,$instructns); }
                if ( $destinatn =~ /\'S\'/ )    { &count_mutants("s",$planting,$destinatn,$instructns); }
                if ( $destinatn =~ /\'W\'/ )    { &count_mutants("w",$planting,$destinatn,$instructns); }
                if ( $destinatn =~ /\'M\'/ )    { &count_mutants("m",$planting,$destinatn,$instructns); }
                if ( $destinatn =~ /out-cros/ ) { &count_mutants("ox",$planting,$destinatn,$instructns); }
	        }
        }








# print Dumper \%dest;



open my $outfh, '>', $out or die "can't open output file $out\n";


print $outfh "# this is $out\n# the count of mutant lines in different categories,\n# generated on $today by ../c/maize/crops/scripts/count_lines.perl.\n#\n# Input file is $file.\n\n\n";



print $outfh "*** TODO line counts\n

+ if no lines in a planting need an inbred, there is no entry: 
  include any zeroes needed for calculations

+ revise table and formulae as needed to reflect your intentions!

+ this has more advanced table editing and formulae

+ calculate the complete table twice!



#+NAME:inbreds
|                                           |       S |     W |       M |      B | total rows by plntg |
|-------------------------------------------+---------+-------+---------+--------+---------------------|
| over-planting factors                     |     1.5 |   1.5 |       2 |    1.5 |                 0.5 |
|-------------------------------------------+---------+-------+---------+--------+---------------------|
| 1st plntg lines                           |" . $dest{"1"}{"s"} . " | " . $dest{"1"}{"w"} . "|" .  $dest{"1"}{"m"} . "|" .  $dest{"1"}{"b"} . " | |
| 2nd plntg lines                           |" . $dest{"2"}{"s"} . " | " . $dest{"2"}{"w"} . "|" .  $dest{"2"}{"m"} . "|" .  $dest{"2"}{"b"} . " | |
|-------------------------------------------+---------+-------+---------+--------+---------------------|
| 1st plntg ears                            |    |   |  | |                     |
| 2nd plntg ears                            |    |   |  |  |                     |
|-------------------------------------------+---------+-------+---------+--------+---------------------|
| 1st plntg rows, inc losses                | | | |  |  |
| 2nd plntg rows, inc losses                | | | |  |  |
| true 1st plntg rows + some 2nd plntg rows | | | |  |  |
| actual 3rd plntg rows                     |2 |2 |2 | 0 |  |
| rows by inbreds, all plantings            | | | |  |  |
|-------------------------------------------+---------+-------+---------+--------+---------------------|
| rounded 1st plntg rows                    |  | |  | |  |
| rounded 2nd plntg rows                    |  | |  | |  |
| rounded 3rd plntg rows                    |  | |  | |  |
| total rounded rows                        |  | |  | |  |
|                                           |  | |  | |  |\n" .
'#+TBLFM: @5$2=@-2*3::@5$3=@-2*3::@5$4=@-2*3::@5$5=@-2*3::@6$2=@-2*3::@6$3=@-2*3::@6$4=@-2*3::@6$5=@-2*3::@7$2=(@-2/20)*@-5::@7$3=(@-2/20)*@-5::@7$4=(@-2/20)*@-5::@7$5=(@-2/20)*@-5::@8$2=(@-2/20)*@-6::@8$3=(@-2/20)*@-6::@8$4=(@-2/20)*@-6::@8$5=(@-2/20)*@-6::@8$6=vsum($2..$5)::@9$2=@-2+(@-1*@2$6)::@9$3=@-2+(@-1*@2$6)::@9$4=@-2+(@-1*@2$6)::@9$5=@-2+(@-1*@2$6)::@9$6=vsum($2..$5)::@10$6=vsum($2..$5)::@11$2=vsum(@8..@10)::@11$3=vsum(@8..@10)::@11$4=vsum(@8..@10)::@11$5=vsum(@8..@10)::@12$2=round(@-3)::@12$3=round(@-3)::@12$4=round(@-3)::@12$5=round(@-3)::@12$6=vsum($2..$5)::@13$6=vsum($2..$5)::@14$6=vsum($2..$5)::@15$6=vsum($2..$5)::@13$2=round(@-5)::@13$3=round(@-5)::@13$4=round(@-5)::@13$5=round(@-5)::@14$2=round(@-4)::@14$3=round(@-4)::@14$4=round(@-4)::@14$5=round(@-4)::@15$2=vsum(@12..@14)::@15$3=vsum(@12..@14)::@15$4=vsum(@12..@14)::@15$5=vsum(@12..@14)' . 
"\n\n";



print $outfh "*** TODO physical rows\n

+ add in others' corn manually

+ calculate the complete table twice!



#+NAME:rows
|----------------------------------------+-------|
| full rows mutants                      |   $full |
| half rows mutants                      |   $half |
| full rows inbreds                      |  |
| total stakes                           |  |
| total physical rows                    |  |
| gerry's rows                           |  |
| total rows needed, exclusive of border | |
|                                        | |\n" .
'#+TBLFM: @3$2=remote(inbreds,@15$6)::@4$2=@1 + @2 + @3::@5$2=@1 + @3 + @2/2::@7$2=@5+@6' . "\n\n";








# subroutines


sub count_mutants {
        my ($type,$planting,$destinatn,$instructns) = @_;


        if ( ( exists($dest{$planting}) ) && ( exists($dest{$planting}{$type}) ) ) {
	
                my $value = $dest{$planting}{$type}; 
                $value++; 
                if ( $instructns =~ /pick/ ) { &picks($instructns,$type,$planting,$value); }
                else { $dest{$planting}{$type} = $value; }
	        }


	 else { $dest{$planting}{$type} = 0; }


	

#        foreach my $pln ( sort keys %dest) {
#                foreach $type ( keys %{ $dest{$pln} } ) { print "planting: $pln $type: $dest{$pln}{$type}\n"; }
#	        }
        }









# pass in the value incremented for the current line, then check to see if it
# should be adjusted because we've accounted for all the lines in the pick set
#
# $destination passed only for debugging purposes.
#
# Kazic, 14.5.2015


sub picks {

        my ($instructns,$type,$planting,$value) = @_;

#        print "\n\npassed v: $value\n";

        my ($kword,$nword) = $instructns =~ /pick (\w+) of (\w+)/;
        my $k = words2nums($kword);
        my $n = words2nums($nword);
        $picks++;

        if ( $picks < $n ) { $dest{$planting}{$type} = $value; }

        elsif ( $picks eq $n ) { 

                my $new_value = $value - $n + $k;
                $dest{$planting}{$type} = $new_value;
 #               print "hit limit picks at $picks, nv is $new_value, resetting\n";
                $picks = 0;
                }

 #       print "$instructns k: $k n: $n p: $picks\n";

        }
