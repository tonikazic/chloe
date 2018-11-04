#!/opt/perl5/perls/perl-5.26.1/bin/perl


# this is ../c/maize/data/data_conversion/convert_cross_prep_data.perl

# a quick script to convert the cross_prep menu's data to cross_prep/5
#
# initially designed for the old cross_prep menu, which included checkboxes for 
# shoot bagging and silking ear 1; these are now converted to popped tassel and cut
# tassel, so I must amend the script after converting the old data.
#
# Kazic, 31.7.2010
#
#
# Modified for ipad data collection:  tested and ready to go.
#
# Kazic, 7.4.2012


# converted to run in perl 5.26
#
# Kazic, 22.4.2018



use strict;
use warnings;



# for now I have stuffed all the subroutines in the Typesetting subdirectory.  The 
# first line ("lib") references that easily


# called from convert_data.perl, so input and output files are passed on the command line


use lib '../../label_making/Typesetting/';
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



# beware!  cross_prep menus prior to 31.7.2010 were:
#    "plantID","tassel bagged","shoot bagged","ear 1 silking","cut silks ear 1","cut silks ear 2","observer","datetime","cross_prep"
#
# after that date, they were:
#    "plantID","tassel bagged","popped tassel","cut tassel","cut silks ear 1","cut silks ear 2","observer","datetime","cross_prep"
#
# The semantics of the third and fourth fields ($shoot_bagged, $ear1_silking) changed to reflect what really goes on in the field.
#
# The old variables were ($plantID,$tassel_bagged,$shoot_bagged,$ear1_silking,$ear1_cut,$ear2_cut,$observer,$datetime);
# the new are ($plantID,$tassel_bagged,$popped_tassel,$cut_tassel,$ear1_cut,$ear2_cut,$observer,$datetime).  That is,
# $shoot_bagged,$ear1_silking  --> $popped_tassel,$cut_tassel.
#
# I have changed the variable names here and in &assemble_action_list.
#
# Kazic, 21.9.2010




if ( $lines[0] =~ /cross_prep/ ) {

        if ( $flag eq 'go' ) {
                open $out, '>>', $out_file or die "can't open $out_file\n";
                print $out "\n\n\n\n% data added from ../../$input_file on $now\n% by data/data_conversion/convert_cross_prep_data.perl\n% called from data/data_conversion/convert_data.perl\n\n";
	        }

	
        for ( my $i = 1; $i <= $#lines; $i++ ) {

	        if ( ( $lines[$i] !~ /^,/ ) && ( $lines[$i] !~ /^#/ ) ) {
	    
# modified regular expression to reflect data collection on iphone
#
# Kazic, 19.5.2017	    

	    
#                ($plantID,$tassel_bagged,$popped_tassel,$cut_tassel,$ear1_cut,$ear2_cut,$observer,$datetime) = $lines[$i] =~ /\"?(${num_gtype_re})\"?,\"?(${num_tf_re})\"?,\"?(${num_tf_re})\"?,\"?(${num_tf_re})\"?,\"?(${num_tfxtra_re})\"?,\"?(${num_tf_re})\"?,\"?(${observer_re})\"?,\"?(${datetime_re})\"?,/;



#                ($plantID,$tassel_bagged,$ear1_cut,$datetime,$popped_tassel,$cut_tassel,$ear2_cut,$observer) = $lines[$i] =~ /\"?(${num_gtype_re})\"?,\"?(${num_tf_re})\"?,\"?(${num_tf_re})\"?,\"?(${datetime_re})\"?,\"?(${num_tf_re})\"?,\"?(${num_tfxtra_re})\"?,\"?(${num_tf_re})\"?,\"?(${observer_re})\"?,/;	    



# iphone variants
	    
                        my ($plantID,$datetime,$tassel_bagged,$ear1_cut,$observer,$popped_tassel,$cut_tassel,$ear2_cut) = $lines[$i] =~ /\"?(${num_gtype_re})\"?,\"?(${datetime_re})\"?,\"?(${num_tf_re})\"?,\"?(${num_tf_re})\"?,\"?(${observer_re})\"?,\"?(${num_tf_re})\"?,\"?(${num_tfxtra_re})\"?,\"?(${num_tf_re})\"?,*/;	    

		
#                print "$plantID,$tassel_bagged,$popped_tassel,$cut_tassel,$ear1_cut,$ear2_cut,$observer,$datetime\n";


		        ($tassel_bagged,$popped_tassel,$cut_tassel,$ear1_cut,$ear2_cut) = &convert_num_tfs($tassel_bagged,$popped_tassel,$cut_tassel,$ear1_cut,$ear2_cut);

#                print "($tassel_bagged,$ear1_cut,$popped_tassel,$cut_tassel,$ear2_cut)\n";

                        ($tassel_bagged) = &check_false($tassel_bagged);
                        ($popped_tassel) = &check_false($popped_tassel);
                        ($cut_tassel) = &check_false($cut_tassel);


                        ($ear1_cut) = &check_false($ear1_cut);
                        ($ear2_cut) = &check_false($ear2_cut);


                        my ($action_list) = &assemble_action_list($tassel_bagged,$popped_tassel,$cut_tassel,$ear1_cut,$ear2_cut);


                        my ($date,$time) = &convert_datetime($datetime);


                        if ( $flag eq 'test' ) { print "cross_prep('$plantID',[$action_list],$observer,$date,$time).\n"; }
                        elsif ( $flag eq 'q' ) { }  # do nothing
		        elsif ( $flag eq 'go' ) { print $out "cross_prep('$plantID',[$action_list],$observer,$date,$time).\n"; }
	                }
	        }
		

# thanks, Gabor!
# https://perlmaven.com/how-to-exit-from-perl-script

	if ( ( $flag eq 'test' ) || ( $flag eq 'q' ) ) { exit 42; }
        }