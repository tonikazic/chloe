#!/usr/local/bin/perl

# this is /athe/c/maize/crops/count_contingency_lines.perl
#
# modified from /athe/c/maize/crops/count_lines.perl
#
# a script to compute the lines in a file tangled from the contingency_planting.org file 
# in the different categories and output the results to
# computable tables in an org file
#
# the org file generated should be substituted back into packing_plan.org, under strategy;
# the corresponding inbred blocks marked; 
# the tables prettified; and the new values calculated.
#
#
# help with multidimensional hashes from Gabor Szabo: http://perlmaven.com/multi-dimensional-hashes
#
#
# call is: perl count_contingency_lines.perl CROP
#
# Kazic, 6.6.2015



use lib qw(../label_making/);
use Typesetting::MaizeRegEx;
use Typesetting::DefaultOrgztn;
#
# this next just for laieikawai
#
# use lib qw(/opt/local/lib/perl5/site_perl/5.8.9/);
use Lingua::EN::Words2Nums;



# toggle the input files



$input = "bcs_no_bulks";
# $input = "yes";
# $input = "maybe";
# $input = "unlikely";
$file = $crop . "/planning/" . $input;
$out = $crop . "/planning/" . $input . "_line_counts.org";

$today = `date`;
chomp($today);



$lines = 0;
$first = 0;
$second = 0;
$third = 0;
$full = 0;
$half = 0;
%dest = undef;
%pick = undef;
$k = 0;
$n = 0;
$picks = 0;



open(IN,"$file") or die "can't open input file $file\n";

while (<IN>) {

        if ( ( $_ =~ /^packing_plan/ ) && ( $_ !~ /\[inbred\]/ ) ) {
                ($ma,$planting,$destinatn,$instructns,$ft) = $_ =~ /\[\'([\w\:]+)\s.+,(\d),(\[[\w\'\,\s\-]+\]),\'(.+)\',\'K\d+\',\d{1,2},(\d+)\)\./;

#		print "($ma,$planting,$destinatn,$instructns,$ft)\n";

                $lines++;
                if ( $planting eq "1" ) { $first++; }
                elsif ( $planting eq "2" ) { $second++; }
                elsif ( $planting eq "3" ) { $third++; }

                if ( $ft eq "20" ) { $full++; }
                elsif ( $ft eq "10" ) { $half++; }



# there may be multiple destinations; so test for each one individually
# and increment as found.
#
# use a hash of hashes to maintain the tallies.
#
# tallies will be incremented for each destination of the current line;
# adjustments due to picking will occur in &picks below.
#
# verified by manually tracing about half of the 15r picks.
# 
# $destination passed only for debugging purposes.
#
# Kazic, 14.5.2015

                if ( $destinatn =~ /\[self\]/ ) { $type = "self"; &count_mutants($type,$planting,$destinatn,$instructns); }
                if ( $destinatn =~ /inc/ )      { $type = "inc";  &count_mutants($type,$planting,$destinatn,$instructns); }
                if ( $destinatn =~ /\'B\'/ )    { $type = "b";    &count_mutants($type,$planting,$destinatn,$instructns); }
                if ( $destinatn =~ /\'S\'/ )    { $type = "s";    &count_mutants($type,$planting,$destinatn,$instructns); }
                if ( $destinatn =~ /\'W\'/ )    { $type = "w";    &count_mutants($type,$planting,$destinatn,$instructns); }
                if ( $destinatn =~ /\'M\'/ )    { $type = "m";    &count_mutants($type,$planting,$destinatn,$instructns); }
                if ( $destinatn =~ /out-cros/ ) { $type = "ox";   &count_mutants($type,$planting,$destinatn,$instructns); }
	        }

        }


close(IN);



open(OUT,">$out") or die "can't open output file $out\n";
print OUT "this is $out\nthe count of mutant lines in different categories,\ngenerated on $today by ../maize/crops/count_lines.perl.\n\nInput file is $file.\n\n\n";



print OUT "*** TODO line counts\n

+ with more advanced table editing and formulae

+ calculate the complete table twice!



#+NAME:" . $input . "_contingency_inbreds
|                                           |       S |     W |       M |      B | total rows by plntg |
|-------------------------------------------+---------+-------+---------+--------+---------------------|
| over-planting factors                     |     1.3 |   1.3 |     1.7 |    1.3 |                 0.5 |
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



print OUT "*** TODO physical rows\n

+ add in gerry's corn manually

+ calculate the complete table twice!



#+NAME:" . $input . "_contingency_rows
|----------------------------------------+-------|
| full rows mutants                      |   $full |
| half rows mutants                      |   $half |
| full rows inbreds                      |  |
| total stakes                           |  |
| total physical rows                    |  |
| gerry's rows                           |  |
| total rows needed, exclusive of border | |
|                                        | |\n" .
'#+TBLFM: @3$2=remote(' . $input . '_contingency_inbreds,@15$6)::@4$2=@1 + @2 + @3::@5$2=@1 + @3 + @2/2::@7$2=@5+@6' . "\n\n";



close(OUT);




# subroutines


sub count_mutants {
        ($type,$planting,$destinatn,$instructns) = @_;

        $value = $dest{$planting}{$type}; 
        $value++; 
        if ( $instructns =~ /pick/ ) { &picks($instructns,$type,$planting,$value); }
        else { $dest{$planting}{$type} = $value; }


#        print "($ma,$planting,$destinatn,$instructns,$ft) $lines  $first  $second $third $full $half\n";
#        foreach $pln ( sort keys %dest) {
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

        ($instructns,$type,$planting,$value) = @_;

#        print "\n\npassed v: $value\n";

        ($kword,$nword) = $instructns =~ /pick (\w+) of (\w+)/;
        $k = words2nums($kword);
        $n = words2nums($nword);
        $picks++;

        if ( $picks < $n ) { $dest{$planting}{$type} = $value; }

        elsif ( $picks eq $n ) { 

                $new_value = $value - $n + $k;
                $dest{$planting}{$type} = $new_value;
 #               print "hit limit picks at $picks, nv is $new_value, resetting\n";
                $picks = 0;
                }

 #       print "$instructns k: $k n: $n p: $picks\n";

        }
