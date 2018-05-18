#!/usr/bin/perl

# this is maize/data/data_conversion/convert_inbred_pool_data.perl

# a quick script to convert the inbred_pool menu's data to inbred_pool.pl
#
# Bear in mind that the next family numbers in DefaultOrgztn.pm must be kept up to date,
# and the genotype information inserted into genotype.pl!
#
# Kazic, 29.10.09



# for now I have stuffed all the subroutines in the Typesetting subdirectory.  The 
# first line ("lib") references that easily


use lib qw(../../label_making/);
use Typesetting::DefaultOrgztn;
use Typesetting::OrganizeData;
use Typesetting::MaizeRegEx;
use Typesetting::NoteExpsn;
use Typesetting::ConvertPalmData;




$input_file = $ARGV[0];
$out_file = $ARGV[1];





# read the file into an array so it's easy to check the first line's self-identification

open(IN,"<$input_file") || die "sorry, can't open input file $input_file\n";
(@lines) = <IN>;
close(IN);


$now = `date`;
chomp($now);


if ( $lines[0] =~ /inbred_pool/ ) {

        open(OUT,">>$out_file");
        $input_file =~ s/\.\.//;
        print OUT "\n\n\n\n% data added from ../../data$input_file on $now\n% by data/data_conversion/convert_inbred_pool_data.perl\n% called from data/data_conversion/convert_data.perl\n\n";


# strangely, Perl reads the first line of the file into $array[0], but then the last line is
# placed in $array[1].   This can be demonstrated by looking at the array's contents:
#
# for ( $j = 0 ; $j <= $#lines; $j++ ) { print "$j: $lines[$j]\n"; }
#
# So work backwards through the array to get the data in their input
# order.
#
# Kazic, 6.9.09

        for ( $i = $#lines; $i >= 1;  $i-- ) {
                ($ma_plant,$pa_plant,$observer,$datetime) = $lines[$i] =~ /\"(${num_gtype_re})\",\"(${num_gtype_re})\",\"(${observer_re})\",\"(${datetime_re})\",/;

                ($date,$time) = &convert_datetime($datetime);

		($family) = &assign_inbred($ma_plant,$pa_plant);
                $record = $ma_plant . "::" . $pa_plant . "::" . $observer . "::" . $date  . "::" . $time;

                $array_name = "f" . $family;

#                print "f: $array_name r: $record\n";

                push(@{"$array_name"},$record);

                }


        }




foreach $inbred_type ( keys ( %next_inbred_families ) ) {
	$family_num = $next_inbred_families{$inbred_type};

        $array_num = "f" . $family_num;

        if ( defined(@$array_num) ) { 
		$size = @$array_num;
                print "the array for family $family_num defined and has $size ears\n"; 

                print OUT "inbred_pool($family_num,[\n";
		for ( $i = 0 ; $i <= $size - 2 ; $i++ ) {
                        ($ma,$pa,$obs,$da,$ti) = split(/::/,@{$array_num}[$i]);
                        print OUT "\t'$ma'-('$pa',$obs,$da,$ti),\n";
                        }    


                        ($ma,$pa,$obs,$da,$ti) = split(/::/,@{$array_num}[$size-1]);
                        print OUT "\t'$ma'-('$pa',$obs,$da,$ti)]).\n\n\n";

		}

        }



 close(OUT);



print "\nMake sure genotype.pl includes these families and that DefaultOrgztn.pm increments the family numbers for the next inbred nursery!\n\n";




sub assign_inbred {
        ($ma_plant,$pa_plant) = @_;

        if ( $ma_plant eq $pa_plant ) { $type = self; }
        else { $type = sib; }

        if ( $ma_plant =~ /S/ ) { $line = "s"; }
        elsif  ( $ma_plant =~ /W/ ) { $line = "w"; }
        elsif  ( $ma_plant =~ /M/ ) { $line = "m"; }

        $key = $line . "_" . $type;
        $family = $next_inbred_families{$key};

        return $family;
        }
