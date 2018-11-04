#!/opt/perl5/perls/perl-5.26.1/bin/perl

# this is ../c/maize/data/data_conversion/convert_sleeve_bdry_data.perl

# a script to convert the current corrected sleeve_bdry data to sleeve_bdry/6
#
# Kazic, 14.7.2018




# directory management fine here already
#
# Kazic, 14.7.2018



use strict;
use warnings;


use lib '../../label_making/Typesetting/';
use DefaultOrgztn;
use ConvertPalmData;
use MaizeRegEx;




my $input_file = $ARGV[0];
my $out_file = $ARGV[1];
my $flag = $ARGV[2];
my $file = $demeter_dir . "sleeve_bdry.pl";


my $out;
my @lines;
my %sorting_hash;






# read the file into an array so it's easy to check the first line's self-identification

open my $in, '<', $input_file or die "sorry, can't open input file $input_file\n";
(@lines) = <$in>;


my $now = `date`;
chomp($now);








if ( $lines[0] =~ /sleeve_bdry/ ) {

	if ( $flag eq 'go' ) {
                open $out, '>>', $out_file or die "can't open $out_file\n";
                print $out "\n\n\n\n% data added from ../../data$input_file on $now\n% by data/data_conversion/convert_sleeve_bdry_data.perl\n% called from data/data_conversion/convert_data.perl\n\n";
	        }

    
        for ( my $i = 1; $i <= $#lines; $i++ ) {

	        if ( ( $lines[$i] !~ /^,/ ) && ( $lines[$i] !~ /^#/ ) ) {

		    
                        my ($first_ma,$last_ma,$sleeve,$datetime,$observer) = $lines[$i] =~ /\"?(${num_gtype_re})\"?,\"?(${num_gtype_re})\"?,\"?(${locatn_re})\"?,\"?(${datetime_re})\"?,\"?(${observer_re})\"?,*/;

#                       print "($first_ma,$last_ma,$sleeve,$observer,$datetime)\n";

                

			if ( $sleeve !~ /${sleeve_re}/ ) { $sleeve = &convert_sleeve($sleeve); }
                        my ($date,$time) = &convert_datetime($datetime);

                        $sorting_hash{$sleeve} = "sleeve_bdry('$first_ma','$last_ma',$sleeve,$observer,$date,$time).";
	                }
                }
        }









foreach my $key ( sort keys %sorting_hash ) {

        my $record = $sorting_hash{$key};

        if ( $flag eq 'test' ) { print $record . "\n"; }
        elsif ( $flag eq 'q' ) { }  # do nothing
	elsif ( $flag eq 'go' ) { print $out $record . "\n"; }
        }






# thanks, Gabor!
# https://perlmaven.com/how-to-exit-from-perl-script
	
if ( ( $flag eq 'test' ) || ( $flag eq 'q' ) ) { exit 42; }
