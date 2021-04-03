#!/usr/local/bin/perl

# this is ../c/maize/data/data_conversion/convert_harvest_data.perl




# script now adds datetime information from row_harvested.pl to the
# the harvest menu's data (shouldn't be there any more)
# to generate harvest/7.
#
# These data are collected during shelling and filing the corn in the seed
# room, not during harvest in the field.  The script assumes that a crop's
# harvest facts are filed in the directory for that crop, NOT in the crop
# when the corn was shelled.  The significance of this is that the
# directory is used to get the crop particle for grepping.
#
# Thus, the harvest data for the 17r crop were mis-filed into the 18r
# directory.  I haven't gone back to correct this, since I've changed the
# script in between.
#
#
# Tested with dummy data (../palm/raw_data_from_palms/18r/eta/11.11/dummy.harvest.csv), correct.
#
# Kazic, 11.11.2018





# check notes in output file carefully.  Some regular expressions collide
# and generate silly notes; double quotes may linger.
#
# Kazic, 10.3.2015



# converted to run in perl 5.26
#
# Kazic, 24.4.2018


# added condition to exclude blank lines
#
# Kazic, 21.5.2019



use strict;
use warnings;
use feature 'say';



use lib '../../label_making/Typesetting/';
use DefaultOrgztn;
use OrganizeData;
use MaizeRegEx;
use NoteExpsn;
use ConvertPalmData;




my $input_file = $ARGV[0];
my $out_file = $ARGV[1];
my $flag = $ARGV[2];

my $cross_file = $demeter_dir . "cross.pl";
my $row_harvested_file = $demeter_dir . "row_harvested.pl";
my $out;
my %cross;
my %rowh;
my @lines;









# form the hash of pollinations to correct males with incomplete tags;
# by harvest, all numerical genotypes in the cross.pl should be complete

my ($crop) = &grab_crop_from_file($input_file);



open my $crossfh, '<', $cross_file or die "sorry, can't open cross file $cross_file\n";
my @this_crops_ears = grep  { $_ =~ /${crop}/ && $_ =~ /^cross\(\'(${num_gtype_re})\'/ && $_ !~ /\%/ } <$crossfh> ;


foreach my $elt (@this_crops_ears) {
	my ($ma,$pa) = $elt =~ /^cross\(\'(${num_gtype_re})\',\'(${num_gtype_re})\',/;
	$cross{$ma} = $pa;
        } 


# see https://www.perlmonks.org/?node_id=1204680 for discussion; second is more legible
# say "@{[%cross]}";
#
# say join "\n", %cross;








# do the same for the row_harvested.pl file to grab the date and time each row
# was harvested

open my $rowhfh, '<', $row_harvested_file or die "sorry, can't open cross file $row_harvested_file\n";
my @this_crops_rows = grep  { $_ =~ /${crop}/ && $_ =~ /^row_harvested/ && $_ !~ /\%/ } <$rowhfh> ;

# foreach my $elt  (@this_crops_rows) { print "$elt"; }


# tested with new version of prolog_time_re and works
#
# Kazic, 16.11.2018
#
# added re to strip r prefix
#
# Kazic, 2.4.2021

foreach my $elt (@this_crops_rows) {
	my ($row,$date,$time) = $elt =~ /^row_harvested\((${row_re}),\w+,(${prolog_date_re}),(${prolog_time_re}),/;
	$row =~ lc $row;;

        $row =~ s/r//;
	
	$rowh{$row} = $date . "," . $time;
        } 

# say join "\n", %rowh;













# read the file into an array so it's easy to check the first line's self-identification

open my $in, '<', $input_file or die "sorry, can't open input file $input_file\n";
(@lines) = <$in>;



my $now = `date`;
chomp($now);


if ( $lines[0] =~ /harvest/ ) {

	if ( $flag eq 'go' ) {
                open $out, '>>', $out_file or die "can't open $out_file\n";
                print $out "\n\n\n\n% data added from ../../data$input_file on $now\n% by data/data_conversion/convert_harvest_data.perl\n% called from data/data_conversion/convert_data.perl\n\n";
	        }

	
        for ( my $i = 1; $i <= $#lines; $i++ ) {

              if ( ( $lines[$i] !~ /^,/ ) && ( $lines[$i] !~ /^#/ ) && ( $lines[$i] !~ /^[\n\t\r]/ ) ) { 
	    
# clean up here, rather than burdening data entry in field

                      $lines[$i] =~ s/,,,,/,,0,0,/g;
                      $lines[$i] =~ s/,,,/,0,0,/g;
                      $lines[$i] =~ s/,,/,0,/g;
#                      $lines[$i] =~ s/,fuzzy_cl,/,,/g;



# we simplified the menu so that $ok is now either 1 for success or 0 for failure.
# should have done it a long time ago!
#
# Kazic, 12.9.2013
#
#                ($ma_plant,$pa_plant,$ok,$failed,$fuzzy_cl,$num_cl,$fungus,$polltn_note,$observer,$datetime) = $lines[$i] =~ /\"?(${num_gtype_re})\"?,\"?(${num_gtype_re})\"?,\"?(${num_tf_re})\"?,\"?(${num_tf_re})\"?,\"?(${fuzzy_cl_re})\"?,\"?(${cl_re})\"?,\"?(${num_tf_re})\"?,\"?(${note_re})\"?,\"?(${observer_re})\"?,\"?(${datetime_re})\"?,/;
#
#                 ($ok,$failed) = &convert_num_tfs($ok,$failed);


                      my ($ma_plant,$pa_plant,$ok,$fuzzy_cl,$num_cl,$fungus,$polltn_note,$observer) = $lines[$i] =~ /\"?(${num_gtype_re})\"?,\"?(${num_gtype_re})\"?,\"?(${num_tf_re})\"?,\"?(${fuzzy_cl_re})\"?,\"?(${cl_re})\"?,\"?(${num_tf_re})\"?,\"?(${note_re})\"?,\"?(${observer_re})\"?,*/;
	

#                     print "($ma_plant,$pa_plant,$ok,$fuzzy_cl,$num_cl,$fungus,$polltn_note,$observer)\n";


		      
                      ($ok) = &convert_num_tfs($ok);
		        

                      my ($final_num_cl) = &convert_cl($ma_plant,$fuzzy_cl,$num_cl);
                      my ($cl) = &string_cl($final_num_cl);
		        
                      ($fungus) = &convert_num_tfs($fungus);
                      ($fungus) = &convert_fungus($fungus);
 
#                     print "($ma_plant,$pa_plant,$ok,$fuzzy_cl,$num_cl,$fungus,$polltn_note,$observer,$datetime)\n";


		      
# presumes only pa will have an incomplete numerical genotype		      
                
                      if ( $pa_plant =~ /0000:/ ) { ($pa_plant) = &fill_out_daddy($ma_plant,$pa_plant,\%cross); }

		        
                      my ($int_note) = &expand_note($polltn_note);
                      my ($full_note) = &concat_notes($int_note,$cl,$fungus);

#                ($success) = &convert_pollination_results($ok,$failed);
                      my ($success) = &convert_pollination_results2($ok);


		      
# grab the date and time information from the hash made from row_harvested.pl,
# rather than pasting in by hand or re-recording in the seed room
#
# Kazic, 11.11.2018
#		      
#                      my ($date,$time) = &convert_datetime($datetime);

                      my ($ma_row) = $ma_plant =~ /(\d{5})\d{2}$/;
                      my $date_n_time = $rowh{$ma_row};		        
                      if ( !exists $rowh{$ma_row} ) { print "missing: $ma_row\n"; }



		      
		      
                      if ( $flag eq 'test' ) { print "harvest('$ma_plant','$pa_plant',$success,$full_note,$observer,$date_n_time).\n"; }
                      elsif ( $flag eq 'q' ) { }  # do nothing
		      elsif ( $flag eq 'go' ) { print $out "harvest('$ma_plant','$pa_plant',$success,$full_note,$observer,$date_n_time).\n"; }
                      }
	      }


# thanks, Gabor!
# https://perlmaven.com/how-to-exit-from-perl-script

	if ( ( $flag eq 'test' ) || ( $flag eq 'q' ) ) { exit 42; }
        }



