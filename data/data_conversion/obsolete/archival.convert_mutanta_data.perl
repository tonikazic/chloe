#!/usr/bin/perl

# this is maize/data/data_conversion/convert_mutant_data.perl
# this was maize/data/data_conversion/convert_mutanta_data.perl
# (that is, the abbreviated mutant menus, shrunk to fit the un-Pro PT+ palms)
#
# renamed to reflect the transition to ever-expanding mutanta menus
# 
# Kazic, 22.9.2014

# a quick script to convert the mutanta menu's data to mutant/8


# need to finish revisions to accommodate ipad data collection
#
# add subroutine for "additional examinations", e.g. dna and leaf sample collection 
# for sequencing and microscopy, respectively:  &convert_further_examinations.  Include
# an "ask gerry" option.
#
# Kazic, 27.10.2012



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
$out_file =~ s/mutanta/mutant/;

# print "$out_file\n";







# read the file into an array so it's easy to check the first line's self-identification

open(IN,"<$input_file") || die "sorry, can't open input file $input_file\n";
(@lines) = <IN>;
close(IN);


$now = `date`;
chomp($now);


if ( $lines[0] =~ /mutanta/ ) {

        open(OUT,">>$out_file");
        $input_file =~ s/\.\.//;
        print OUT "\n\n\n\n% data added from ../../data$input_file on $now\n% by data/data_conversion/convert_mutanta_data.perl\n% called from data/data_conversion/convert_data.perl\n\n";


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

#                print $lines[$i];

# added stature, ear, tassel, sample with blank_res!
#
# Kazic, 13.1.2013

#                ($plant,$wild_type,$lesion,$dwarf,$other_phe,$cross,$cross_maybe,$photograph,$observer,$datetime) = $lines[$i] =~ /\"(${num_gtype_re})\",\"(${num_tf_re})\","(${num_tf_re})\",\"(${num_tf_re})\",\"(${note_re})\",\"(${num_tf_re})\",\"(${num_tf_re})\",\"(${num_tf_re})\",\"(${observer_re})\",\"(${datetime_re})\",/;

# added re for bug score, important in 14r
#
# Kazic, 22.9.2014

#                ($plant,$wild_type,$lesion,$cross,$photograph,$sample,$stature,$tassel,$ear,$other_phe,$observer,$datetime) = $lines[$i] =~ /\"?(${num_gtype_re})\"?,\"?(${num_tf_re})\"?,\"?(${num_tf_re})\"?,\"?(${num_tf_re})\"?,\"?(${num_tf_re})\"?,\"?(${num_tf_re})\"?,\"?(${note_re})\"?,\"?(${note_re})\"?,\"?(${note_re})\"?,\"?(${note_re})\"?,\"?(${observer_re})\"?,\"?(${datetime_re})\"?,/;

                ($plant,$wild_type,$lesion,$cross,$photograph,$sample,$stature,$tassel,$ear,$bug,$other_phe,$observer,$datetime) = $lines[$i] =~ /\"?(${num_gtype_re})\"?,\"?(${num_tf_re})\"?,\"?(${num_tf_re})\"?,\"?(${num_tf_re})\"?,\"?(${num_tf_re})\"?,\"?(${num_tf_re})\"?,\"?(${note_re})\"?,\"?(${note_re})\"?,\"?(${note_re})\"?,\"?(${bug_re})\"?,\"?(${note_re})\"?,\"?(${observer_re})\"?,\"?(${datetime_re})\"?,/;



                print "($plant,$wild_type,$lesion,$cross,$photograph,$sample,$stature,$tassel,$ear,$bug,$other_phe,$observer,$datetime)\n";


                ($wild_type,$lesion,$cross,$photograph,$sample) = &convert_num_tfs($wild_type,$lesion,$cross,$photograph,$sample);


                if ( $plant eq "" ) { print $lines[$i]; }


                ($full_note,$followup_plan) = &expand_phenotypes($plant,$wild_type,$lesion,$stature,$tassel,$ear,$other_phe,$sample);
                ($photo_plan) = &convert_photo_plan($photograph);

                ($cross_plan) = &convert_cross_plan($cross);
                ($date,$time) = &convert_datetime($datetime);


                if ( $full_note eq "" ) { print "Warning! unspecified phenotype for $plant!\n"; }


#                print  "mutant('$plant',[$full_note],$cross_plan,$photo_plan,$followup_plan,toni,$date,$time).\n";
#                print OUT "mutant('$plant',[$full_note],$cross_plan,$photo_plan,$followup_plan,toni,$date,$time).\n";

                }

        close(OUT);

        }
