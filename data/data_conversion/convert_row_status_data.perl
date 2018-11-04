#!/opt/perl5/perls/perl-5.26.1/bin/perl

# this is ../c/maize/data/data_conversion/convert_row_status_data.perl

# a quick script to convert the row_status menu's data to row_status/7


# for now I have stuffed all the subroutines in the Typesetting subdirectory.  The 
# first line ("lib") references that easily


# called from convert_data.perl, so input and output files are passed on the command line



# converted to run in perl 5.26
#
# Kazic, 21.4.2018


use strict;
use warnings;


use lib '../../label_making/Typesetting';
use DefaultOrgztn;
use MaizeRegEx;
use NoteExpsn;
use ConvertPalmData;



my $input_file = $ARGV[0];
my $out_file = $ARGV[1];
my $flag = $ARGV[2];

my $out;
my @lines;




# read the file into an array so it's easy to check the first line's self-identification

open my $in, '<', $input_file or die "sorry, can't open input file $input_file\n";
(@lines) = <$in>;



my $now = `date`;
chomp($now);


if ( $lines[0] =~ /row_status/ ) {

	if ( $flag eq 'go' ) {
                open $out, '>>', $out_file or die "can't open $out_file\n";
                print $out "\n\n\n\n% data added from ../../$input_file on $now\n% by data/data_conversion/convert_cross_data.perl\n% called from data/data_conversion/convert_data.perl\n\n";
	        }

	
        for ( my $i = 1; $i <= $#lines; $i++ ) {

#                ($row,$num_emerged,$ave_leaf_num,$num_wild_type,$num_mutant,$health,$int_phenotype_list,$observer,$datetime) = $lines[$i] =~ /\"?(${row_re})\"?,\"?(${state_or_cl_re})\"?,\"?(${abs_leaf_num_re})\"?,\"?(${cl_re})\"?,\"?(${cl_re})\"?,\"?(${num_tf_re})\"?,\"?(${note_re})\"?,\"?(${observer_re})\"?,\"?(${datetime_re})\"?,/;

# 		($health) = &convert_num_tfs($health);


# health now a number!
#
# Kazic, 9.6.2012

#                ($row,$num_emerged,$ave_leaf_num,$num_wild_type,$num_mutant,$health,$int_phenotype_list,$observer,$datetime) = $lines[$i] =~ /\"?(${row_re})\"?,\"?(${state_or_cl_re})\"?,\"?(${abs_leaf_num_re})\"?,\"?(${cl_re})\"?,\"?(${cl_re})\"?,\"?(${cl_re})\"?,\"?(${note_re})\"?,\"?(${observer_re})\"?,\"?(${datetime_re})\"?,/;


# modified for iphone data collection and tested
#
# Terrana and Kazic, 3.7.2017

                if ( $_ !~ /^,/ ) {

                        my ($row,$num_emerged,$num_wild_type,$num_mutant,$ave_leaf_num,$health,$datetime,$int_phenotype_list,$observer) = $lines[$i] =~ /\"?(${row_re})\"?,\"?(${state_or_cl_re})\"?,\"?(${cl_re})\"?,\"?(${cl_re})\"?,\"?(${abs_leaf_num_re})\"?,\"?(${cl_re})\"?,\"?(${datetime_re})\"?,\"?(${note_re})\"?,\"?(${observer_re})\"?,*/;		




# revise this and menu to simplify menu to 
# ($row,$num_emerged,$num_wild_type,$num_mutant,$num_dead,$ave_leaf_num,$datetime,$int_phenotype_list,$observer)
# and subtract $health = $num_emerged - $num_dead
# leaving $int_phenotype_list for other things
#
# Kazic, 21.4.2018

		

#                        print "$row,$num_emerged,$num_wild_type,$num_mutant,$ave_leaf_num,$health,$datetime,$int_phenotype_list,$observer\n";



# need to parse and pool data, along the lines of NoteExpsn.pm

                        my ($tnum_emerged) = &check_null($num_emerged);
                        if ( $tnum_emerged =~ /\"\"/ ) { $num_emerged = "_"; }
                        elsif ( $tnum_emerged =~ /\D+/ ) { $num_emerged = &expand_note($tnum_emerged); }
                        else { $num_emerged = $tnum_emerged; }
		
		
		
		
                        ($ave_leaf_num) = &check_null($ave_leaf_num);
                        ($num_wild_type) = &check_null($num_wild_type);
                        ($num_mutant) = &check_null($num_mutant);
                        ($health) = &check_null($health);

		
# check for production of uninstantiated variables in other phenotypes
#
# Terrana and Kazic, 3.7.2017
		
                        ($int_phenotype_list) = &check_null($int_phenotype_list);
                        my ($phenotype_list) = &assemble_phenotype_list($ave_leaf_num,$num_wild_type,$num_mutant,$health,$int_phenotype_list);
			
			
                        my ($crop) = &grab_crop_from_file($input_file);
                        my ($date,$time) = &convert_datetime($datetime);
			
			
                        if ( $flag eq 'test' ) { print "row_status($row,num_emerged($num_emerged),[$phenotype_list],$observer,$date,$time,'$crop').\n"; }
                        elsif ( $flag eq 'q' ) { }  # do nothing
                        elsif ( $flag eq 'go' ) {print $out "row_status($row,num_emerged($num_emerged),[$phenotype_list],$observer,$date,$time,'$crop').\n"; }
			
			
			
			$row = "";
			$ave_leaf_num = "";
			$num_wild_type = "";
			$num_mutant = "";
			$health = "";
			$int_phenotype_list = "";
			$observer = "";
			$datetime = "";
			
			$tnum_emerged = "";
			
			$num_emerged = "";
			$phenotype_list = "";
			$observer = "";
			$date = "";
			$time = "";
			$crop = "";
		        }
	        }
	
# thanks, Gabor!
# https://perlmaven.com/how-to-exit-from-perl-script

        if ( ( $flag eq 'test' ) || ( $flag eq 'q' ) ) { exit 42; }
        }