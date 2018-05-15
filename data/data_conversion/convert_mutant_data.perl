#!/opt/perl5/perls/perl-5.26.1/bin/perl

# this is ../c/maize/data/data_conversion/convert_mutant_data.perl
# this was maize/data/data_conversion/convert_mutanta_data.perl
# (that is, the abbreviated mutant menus, shrunk to fit the un-Pro PT+ palms)
#
# renamed to reflect the transition to ever-expanding mutanta menus
# 
# Kazic, 22.9.2014

# a quick script to convert the mutant(a) menu's data to mutant/8



# add subroutine for "additional examinations", e.g. dna and leaf sample collection 
# for sequencing and microscopy, respectively:  &convert_further_examinations.  Include
# an "ask gerry" option.
#
# Kazic, 27.10.2012


# converted to run in perl 5.26
#
# Kazic, 22.4.2018





# for now I have stuffed all the subroutines in the Typesetting subdirectory.  The 
# first line ("lib") references that easily


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

$out_file =~ s/mutanta/mutant/;
my $out;
my @lines;








# read the file into an array so it's easy to check the first line's self-identification

open my $in, '<', $input_file or die "sorry, can't open input file $input_file\n";
(@lines) = <$in>;


my $now = `date`;
chomp($now);


if ( $lines[0] =~ /mutanta*/ ) {

	if ( $flag eq 'go' ) {
                open $out, '>>', $out_file or die "can't open $out_file\n";
                print $out "\n\n\n\n% data added from ../../$input_file on $now\n% by data/data_conversion/convert_mutanta_data.perl\n% called from data/data_conversion/convert_data.perl\n\n";
	        }



        for ( my $i = 1; $i <= $#lines; $i++ ) {

               if ( ( $lines[$i] !~ /^,/ ) && ( $lines[$i] !~ /^#/ ) ) { 
	    

#                print $lines[$i];

# added stature, ear, tassel, sample with blank_res!
#
# Kazic, 13.1.2013

#                ($plant,$wild_type,$lesion,$dwarf,$other_phe,$cross,$cross_maybe,$photograph,$observer,$datetime) = $lines[$i] =~ /\"(${num_gtype_re})\",\"(${num_tf_re})\","(${num_tf_re})\",\"(${num_tf_re})\",\"(${note_re})\",\"(${num_tf_re})\",\"(${num_tf_re})\",\"(${num_tf_re})\",\"(${observer_re})\",\"(${datetime_re})\",/;


# added re for bug score, important in 14r but not always
#
# Kazic, 22.9.2014


#                ($plant,$wild_type,$lesion,$cross,$photograph,$sample,$stature,$tassel,$ear,$bug,$other_phe,$observer,$datetime) = $lines[$i] =~ /\"?(${num_gtype_re})\"?,\"?(${num_tf_re})\"?,\"?(${num_tf_re})\"?,\"?(${num_tf_re})\"?,\"?(${num_tf_re})\"?,\"?(${num_tf_re})\"?,\"?(${note_re})\"?,\"?(${note_re})\"?,\"?(${note_re})\"?,\"?(${bug_re})\"?,\"?(${note_re})\"?,\"?(${observer_re})\"?,\"?(${datetime_re})\"?,/;

                        

                        my ($plant,$wild_type,$lesion,$cross,$photograph,$sample,$stature,$tassel,$ear,$other_phe,$datetime,$observer) = $lines[$i] =~ /\"?(${num_gtype_re})\"?,\"?(${num_tf_re})\"?,\"?(${num_tf_re})\"?,\"?(${num_tf_re})\"?,\"?(${num_tf_re})\"?,\"?(${num_tf_re})\"?,"?(${note_re})\"?,\"?(${note_re})\"?,\"?(${note_re})\"?,\"?(${note_re})\"?,\"?(${datetime_re})\"?,\"?(${observer_re})\"?,*/;

#			print "($plant,$wild_type,$lesion,$cross,$photograph,$sample,$stature,$tassel,$ear,$other_phe,$datetime,$observer)\n";
			

                        ($wild_type,$lesion,$cross,$photograph,$sample) = &convert_num_tfs($wild_type,$lesion,$cross,$photograph,$sample);


			
# spit out any line that doesn't match the regular expression
			
                        if ( $plant !~ /:/ ) { print $lines[$i]; }



			
# old version, without bug score
#                ($full_note,$followup_plan) = &expand_phenotypes($plant,$wild_type,$lesion,$stature,$tassel,$ear,$other_phe,$sample);
#
# new version with bug score
#
# Kazic, 22.9.2014
#
# hardwire bug if bug data not collected, but trap any digits in other_phes as
# the bug score
#
# Kazic, 25.4.2018
			
			my $bug = 0;
                        my ($full_note,$followup_plan) = &expand_phenotypes($plant,$wild_type,$lesion,$stature,$tassel,$ear,$bug,$other_phe,$sample);
                        my ($photo_plan) = &convert_photo_plan($photograph);

                        my ($cross_plan) = &convert_cross_plan($cross);
                        my ($date,$time) = &convert_datetime($datetime);


                        if ( $full_note eq "" ) { print "Warning! unspecified phenotype for $plant!\n"; }


                        if ( $flag eq 'test' ) { print "mutant('$plant',[$full_note],$cross_plan,$photo_plan,$followup_plan,$observer,$date,$time).\n"; }
                        elsif ( $flag eq 'q' ) { }  # do nothing
			elsif ( $flag eq 'go' ) { print $out "mutant('$plant',[$full_note],$cross_plan,$photo_plan,$followup_plan,$observer,$date,$time).\n"; }
                        }
                }



# thanks, Gabor!
# https://perlmaven.com/how-to-exit-from-perl-script

	if ( ( $flag eq 'test' ) || ( $flag eq 'q' ) ) { exit 42; }
        }
