#!/opt/perl5/perls/perl-5.26.1/bin/perl

# this is ../c/maize/data/data_conversion/convert_inbred_pool_data.perl

# a quick script to convert the inbred_pool menu's data to inbred_pool.pl
#
# Bear in mind that the next family numbers in DefaultOrgztn.pm must be kept up to date,
# and the genotype information inserted into genotype.pl!
#
# Kazic, 29.10.09




# converted to run in perl 5.26, restructuring the code
#
# Kazic, 20.4.2018


# use strict;
# use warnings;



# called from convert_data.perl, so input and output files and 
# flag are passed on the command line

use lib '../../label_making/Typesetting/';

use DefaultOrgztn;
use OrganizeData;
use MaizeRegEx;
use NoteExpsn;
use ConvertPalmData;


my $input_file = $ARGV[0];
my $out_file = $ARGV[1];
my $flag = $ARGV[2];




my $array_name;
my $out;
my @lines;



open my $in, '<', $input_file or die "sorry, can't open input file $input_file\n";
(@lines) = <$in>;


my $now = `date`;
chomp($now);


if ( $lines[0] =~ /inbred_pool/ ) {
	
        for ( my $i = 1; $i <= $#lines; $i++ ) {	

	        if ( ( $lines[$i] !~ /^,/ ) && ( $lines[$i] !~ /^#/ ) ) {
                        my ($ma_plant,$pa_plant,$datetime,$observer) = $lines[$i] =~ /\"?(${num_gtype_re})\"?,\"?(${num_gtype_re})\"?,\"?(${datetime_re})\"?,\"?(${observer_re})\"?,*/;

#			print $lines[$i];

#                        print "($ma_plant,$pa_plant,$datetime,$observer)\n";
			
                        my ($date,$time) = &convert_datetime($datetime);
			
			my ($family) = &assign_inbred($ma_plant,$pa_plant);
                        my $record = $ma_plant . "::" . $pa_plant . "::" . $observer . "::" . $date  . "::" . $time;
			
                        $array_name = "f" . $family;

#                        print "f: $array_name r: $record\n";

                        push(@{"$array_name"},$record);
                        }
	        }
        }





my $output_str;



foreach my $inbred_type ( keys ( %next_inbred_families ) ) {
	my $family_num = $next_inbred_families{$inbred_type};

        my $array_num = "f" . $family_num;

	
        if ( defined(@$array_num) ) { 
		my $size = @$array_num;
                my ($ma,$pa,$obs,$da,$ti);
		
                print "the array for family $family_num defined and has $size ears\n"; 

                $output_str .= "inbred_pool($family_num,[\n";
		for ( my $i = 0 ; $i <= $size - 2 ; $i++ ) {
                        ($ma,$pa,$obs,$da,$ti) = split(/::/,@{$array_num}[$i]);
                        $output_str .=  "\t'$ma'-('$pa',$obs,$da,$ti),\n";
		        }
		
                ($ma,$pa,$obs,$da,$ti) = split(/::/,@{$array_num}[$size-1]);
                $output_str .= "\t'$ma'-('$pa',$obs,$da,$ti)]).\n\n\n";
	        }
        }





if ( $flag eq 'test' ) { print $output_str; }
elsif ( $flag eq 'q' ) { }  # do nothing
elsif ( $flag eq 'go' ) { 
        open $out, '>>', $out_file or die "can't open $out_file\n";
        print $out "\n\n\n\n% data added from ../../$input_file on $now\n% by data/data_conversion/convert_inbred_pool_data.perl\n% called from data/data_conversion/convert_data.perl\n\n";
        print $out $output_str;
        }



print "\nMake sure genotype.pl includes these families and\nthat DefaultOrgztn.pm increments the family numbers\nfor the next inbred nursery!\n\n";


# thanks, Gabor!
# https://perlmaven.com/how-to-exit-from-perl-script
	
if ( ( $flag eq 'test' ) || ( $flag eq 'q' ) ) { exit 42; }






sub assign_inbred {
        my ($ma_plant,$pa_plant) = @_;

	my ($type,$line,$key,$family);
	
        if ( $ma_plant eq $pa_plant ) { $type = 'self'; }
        else { $type = 'sib'; }

        if ( $ma_plant =~ /S/ ) { $line = "S"; }
        elsif  ( $ma_plant =~ /W/ ) { $line = "W"; }
        elsif  ( $ma_plant =~ /M/ ) { $line = "M"; }
        elsif  ( $ma_plant =~ /B/ ) { $line = "B"; }	

        $key = $line . "_" . $type;
        $family = $next_inbred_families{$key};

#	print "k: $key f: $family\n";
        return $family;
        }
