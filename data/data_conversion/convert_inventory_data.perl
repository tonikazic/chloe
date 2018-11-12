#!/opt/perl5/perls/perl-5.26.1/bin/perl

# this is ../c/maize/data/data_conversion/convert_inventory_data.perl

# convert the inventory menu data to inventory/7
#
# Kazic, 13.5.2011





# converted to run in perl 5.26
#
# Kazic, 3.5.2018




use strict;
use warnings;


use lib '../../label_making/Typesetting/';
use DefaultOrgztn;
use OrganizeData;
use MaizeRegEx;
use NoteExpsn;
use ConvertPalmData;




my $input_file = $ARGV[0];
my $out_file = $ARGV[1];
my $flag = $ARGV[2];
my $file = $demeter_dir . "inventory.pl";

my $out;
my @lines;







# read the file into an array so it's easy to check the first line's self-identification

open my $in, '<', $input_file or die "sorry, can't open input file $input_file\n";
(@lines) = <$in>;



my $now = `date`;
chomp($now);


if ( $lines[0] =~ /inventory/ ) {

	if ( $flag eq 'go' ) {
                open $out, '>>', $out_file or die "can't open $out_file\n";
                print $out "\n\n\n\n% data added from ../../data$input_file on $now\n% by data/data_conversion/convert_inventory_data.perl\n% called from data/data_conversion/convert_data.perl\n\n";
	        }

    
        for ( my $i = 1; $i <= $#lines; $i++ ) {

	        if ( ( $lines[$i] !~ /^,/ ) && ( $lines[$i] !~ /^#/ ) ) {

                        my ($ma_plant,$pa_plant,$sleeve,$fuzzy_cl,$num_cl,$datetime,$observer) = $lines[$i] =~ /\"?(${num_gtype_re})\"?,\"?(${num_gtype_re})\"?,\"?(${locatn_re})\"?,\"?(${fuzzy_cl_re})\"?,\"?(${cl_re})\"?,\"?(${datetime_re})\"?,\"?(${observer_re})\"?,*/;



#                       print "($ma_plant,$pa_plant,$sleeve,$fuzzy_cl,$num_cl,$observer,$datetime)\n";

                
                        my ($final_num_cl) = &convert_cl($ma_plant,$fuzzy_cl,$num_cl);
                        if ( $final_num_cl !~ /\d+/ ) { ($final_num_cl) = &expand_note($final_num_cl); }

			if ( $sleeve !~ /${sleeve_re}/ ) { $sleeve = &convert_sleeve($sleeve); }

                        my ($date,$time) = &convert_datetime($datetime);

			
                        if ( $flag eq 'test' ) { print "inventory('$ma_plant','$pa_plant',num_kernels($final_num_cl),$observer,$date,$time,$sleeve).\n"; }
                        elsif ( $flag eq 'q' ) { }  # do nothing
			elsif ( $flag eq 'go' ) { print $out "inventory('$ma_plant','$pa_plant',num_kernels($final_num_cl),$observer,$date,$time,$sleeve).\n"; }
	                }
                }


# thanks, Gabor!
# https://perlmaven.com/how-to-exit-from-perl-script
	
	if ( ( $flag eq 'test' ) || ( $flag eq 'q' ) ) { exit 42; }
        }
