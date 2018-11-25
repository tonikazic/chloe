# this is ../c/maize/label_making/Typesetting/OrganizeData.pm

# subroutines that grab the needed data and write them into the appropriate 
# arrays 
#
# a more officially Perl way, but not intended for upload to CPAN
#
# despite the good advice, I use @EXPORT instead of @EXPORT_OK for now to
# simplify refactoring; otherwise all the variable names must be included in the
# import statement of the calling script (see http://perldoc.perl.org/Exporter.html)
#
# Kazic, 6.11.2007


package OrganizeData;

use TypesetGenetics;
use TypesettingMisc;
use DefaultOrgztn;




use Exporter;

our @ISA = qw(Exporter);
our @EXPORT = qw(fill_out_daddy
             make_inventory_labels 
             make_row_stake_labels
             make_replacement_row_stake_labels
             make_barcodes
             make_field_plant_tags
             make_hydro_labels
             make_kristen_plant_id
             make_plant_id
             make_plant_tags 
             make_harvest_tags
             make_inbred_seed_bag_labels
             make_sample_tags
             make_new_seed_labels
             organize_plant_tag_switches
            );











############### for box and sleeve inventory labels


sub make_inventory_labels { 

        ($type,$start,$stop,$crop,$boxes) = @_;


        for ( $i = $start; $i <= $stop; $i++ ) {

		my $record;
                if ( $type ne "x" ) {

		        $padded_code = &pad_row($i,5); 
        	        $code = $type . $padded_code;
#                       $barcode_out = $barcodes . $code . $esuffix;
#                       system("/usr/local/bin/barcode -c -E -b $code -u in -g \"2.25x0.75\" -e 128 -o $barcode_out");

                        $barcode_out = &make_barcodes($barcodes,$code,$esuffix);
		        }


# revised for new box labels in ../make_inventory_labels.perl
#
# Kazic, 25.11.2018
		
                if ( $type eq "x" ) {
                        my ($box,$first_crop,$last_crop,$first_sleeve,$last_sleeve,$first_ma,$last_ma,$comment) = split(/::/,$$boxes[$i]);
#			print "sub: ($box,$first_crop,$last_crop,$first_sleeve,$last_sleeve,$first_ma,$last_ma,$comment)\n";

			my ($box_str,$crop_str,$sleeve_str,$trun_first_ma,$trun_last_ma,$rp_str);

                        $box_str = "box " . $box;

			if ( $first_crop eq $last_crop ) { $crop_str = $first_crop; }
			else {$crop_str = $first_crop . "/" . $last_crop; }

                        if ( ( $box eq 0 ) || ( $box eq 20 ) ) { $sleeve_str = $comment; } 
			else { $sleeve_str = $first_sleeve . " -- " . $last_sleeve; }

                        $trun_first_ma = $first_ma;
			$trun_first_ma =~ s/^[\w]+://;
                        $trun_last_ma = $last_ma;
			$trun_last_ma =~ s/^[\w]+://;
			$rp_str = $trun_first_ma . " -- " . $trun_last_ma;
			
#                        print "$crop_str   $sleeve_str   $rp_str\n";

			$record = join("::",($box_str,$crop_str,$sleeve_str,$rp_str));
		        }

		
                elsif ( $type eq "v" ) {
                        $sleeve = $type . $padded_code;
                        $box = "";
                        $comment = "";
		        }


# overload that sleeve variable for bags and pots

                elsif ( $type eq "a" ) {
                        $sleeve = $type . $padded_code;
                        $box = "";
                        $comment = "";
		        }


                elsif ( $type eq "t" ) {
                        $sleeve = $type . $padded_code;
                        $box = "";
                        $comment = "";
		        }


                if ( $type ne "x" ) { $record = $type . "::" . $barcode_out  . "::" . $crop . "::" . $box . "::" . $comment . "::" . $sleeve; }
                
                
#                print "$record\n";
                push(@labels,$record);
	        }

        return @labels;
        }









############## for labelling the stakes that begin each row

# for either vertical or horizontal layouts:  just making the records!

sub make_row_stake_labels { 

        ($num_rows) = @_;

        for ( my $i = 1; $i <= $num_rows; $i++ ) {
    	        ($barcode_out_upper) = &make_row_stake_label($i);
                $record = $barcode_rel_dir . $barcode_out_upper  . "::" . $i;
                push(@labels,$record);
	        }

        return @labels;
        }






sub make_replacement_row_stake_labels { 

        ($#labels_needed,$labels_needed) = @_;


        for ( my $i = 0; $i <= $#labels_needed; $i++ ) {
#	        print "b: " . $$labels_needed[$i] . " ";

    	        ($barcode_out_upper) = &make_row_stake_label($$labels_needed[$i]);
                $record = $barcode_rel_dir . $barcode_out_upper  . "::" . $$labels_needed[$i];
#                print "$barcode_out_upper\n";
                push(@labels,$record);
	        }

        return @labels;
        }







# for either vertical or horizontal labels; just making the barcodes!

sub make_row_stake_label {
        ($i) = @_;
        $padded_code = &pad_row($i,5); 
        $code = "r" . $padded_code;
        $barcode_out = &make_barcodes($barcodes,$code,$esuffix);

	return($barcode_out);
        }






sub old_make_row_stake_labels { 

        ($num_rows) = @_;

        for ( my $i = 1; $i <= $num_rows; $i=$i+2 ) {

	        my $j = $i+1;
    	        ($barcode_out_upper) = &make_row_stake_label($i);
    	        ($barcode_out_lower) = &make_row_stake_label($j);
                $record = $barcode_rel_dir . $barcode_out_upper  . "::" . $i . "::" . $barcode_rel_dir . $barcode_out_lower  . "::" . $j;
                push(@labels,$record);
	        }

        return @labels;
        }








############ for plant tags


sub make_plant_id {
        ($barcode_elts,$prow,$pplant) = @_;

#        ($barcode_prefix) = $barcode_elts =~ /(\w+\:\w)/;

        $new_barcode_elts = $barcode_elts . $prow . $pplant;
        return $new_barcode_elts;
        }





# kristen


sub make_kristen_plant_id {
        ($barcode_elts,$prow,$pplant,$marker) = @_;

#        ($barcode_prefix) = $barcode_elts =~ /(\w+\:\w)/;

        if ( $marker =~ /\// ) { print "kpi: $marker    "; $marker =~ s/\//\-/; print "$marker\n"; }
        $new_barcode_elts = $barcode_elts . $prow . $pplant . "--" . $marker;


        return $new_barcode_elts;
        }






# homebrew installs GNU barcode and inserts the correct link
#
# Kazic, 17.4.2018

sub make_barcodes { 
        ($barcodes,$barcode_elts,$esuffix) = @_;

        $barcode_out = $barcodes . $barcode_elts . $esuffix;


        unless ( -e $barcode_out ) { system("/usr/local/bin/barcode -c -E -b \"$barcode_elts\" -u in -g \"2.25x0.75\" -e 128 -o $barcode_out"); }

        return $barcode_out;
        }







# phooey, can't figure out how to get the number of array elements from a
# dereferenced array: it's neither $#{$$tags} nor $#{$tags}.  So the number
# has simply been passed directly.
#
# Kazic, 10.11.7




sub make_plant_tags {
        ($output_file,$#tags,$tags) =  @_;

        open(TAG,">$output_file");
        &begin_latex_plant_tags_file(\*TAG);

        for ( $i = 0; $i <= $#tags; $i++ ) {
                $record = $$tags[$i];

# earlier seasons
#
#                ($barcode_out,$pre_row,$pplant,$family,$ma_num_gtype,$pa_family,$pa_num_gtype,$pma_ma_gma_gtype,$pma_ma_gpa_gtype,$pma_pa_gma_gtype,$pma_pa_mutant,$ppa_ma_gma_gtype,$ppa_ma_gpa_gtype,$ppa_pa_gma_gtype,$ppa_pa_mutant,$quasi_allele) = split(/::/,$record);
#
# 09R and later
#
#

                ($barcode_out,$pre_row,$pplant,$crop,$family,$ma_num_gtype,$pa_family,$pa_num_gtype,$ma_gma_gtype,$marker,$quasi_allele) = split(/::/,$record);




# kristen
#
#                ($kristen_plant_id,$barcode_out,$pre_row,$pplant,$marker) = split(/::/,$record);

                $barcode_file = $barcode_rel_dir . $barcode_out;


#		print "$barcode_file,$pre_row,$pplant,$crop,$family,$ma_num_gtype,$pa_family,$pa_num_gtype,$ma_gma_gtype,$marker,$quasi_allele,$i\n";

#                &print_plant_tags(\*TAG,$barcode_file,$pre_row,$pplant,$family,$ma_num_gtype,$pa_family,$pa_num_gtype,$pma_ma_gma_gtype,$pma_ma_gpa_gtype,$pma_pa_gma_gtype,$pma_pa_mutant,$ppa_ma_gma_gtype,$ppa_ma_gpa_gtype,$ppa_pa_gma_gtype,$ppa_pa_mutant,$quasi_allele,$i,$#tags);




                &print_plant_tags(\*TAG,$barcode_file,$pre_row,$pplant,$crop,$family,$ma_num_gtype,$pa_family,$pa_num_gtype,$ma_gma_gtype,$marker,$quasi_allele,$i,$#tags);


# kristen
#
#                &print_plant_tags(\*TAG,$kristen_plant_id,$barcode_file,$pre_row,$pplant,$kristen_plant_id,$marker,$i,$#tags);

                }

         &end_latex_file(\*TAG);
         close(TAG);
         }








sub make_hydro_labels {
        ($output_file,$#labels,$labels) =  @_;

        open(LABEL,">$output_file");
        &begin_latex_file(\*LABEL);

        for ( $i = 0; $i <= $#labels; $i++ ) {
                $record = $$labels[$i];

                ($barcode_out,$pre_row,$pplant,$family,$ma_num_gtype,$pa_family,$pa_num_gtype,$pma_ma_gma_gtype,$pma_ma_gpa_gtype,$pma_pa_gma_gtype,$pma_pa_mutant,$ppa_ma_gma_gtype,$ppa_ma_gpa_gtype,$ppa_pa_gma_gtype,$ppa_pa_mutant,$quasi_allele) = split(/::/,$record);

                $barcode_file = $barcode_rel_dir . $barcode_out;

                &print_hydro_labels(\*LABEL,$barcode_file,$pre_row,$pplant,$family,$ma_num_gtype,$pa_family,$pa_num_gtype,$pma_ma_gma_gtype,$pma_ma_gpa_gtype,$pma_pa_gma_gtype,$pma_pa_mutant,$ppa_ma_gma_gtype,$ppa_ma_gpa_gtype,$ppa_pa_gma_gtype,$ppa_pa_mutant,$quasi_allele,$i,$#labels);
                }

         &end_latex_file(\*LABEL);
         close(TAG);
         }











#### for harvest tags, new or old style

sub make_harvest_tags {

        ($output_file,$#crosses,$crosses) = @_;

        open(TAG,">$output_file");
        &begin_latex_file(\*TAG);

        for ( $i = 0; $i <= $#crosses; $i++ ) {
                ($female_out,$male_out,$ma_num_gtype,$pa_num_gtype,$ma_gtype,$pa_gtype,$ear,$date) = split(/::/,$$crosses[$i]);
                $fe_barcode_file = $barcode_rel_dir . $female_out;
                $male_barcode_file = $barcode_rel_dir . $male_out;

                &print_harvest_tag(\*TAG,$fe_barcode_file,$male_barcode_file,$ma_num_gtype,$pa_num_gtype,$ma_gtype,$pa_gtype,$ear,$date,$i,$#crosses);
                }

        &end_latex_file(\*TAG);
        close(TAG);
        }





##### for making the labels that go on the bags of inbred seed

# I would have preferred to pass a reference to the hash, but couldn't puzzle out
# how to use the hash reference correctly with functions like keys, sort, and scalar.
# It may be the procedural version is less robust than the syntactically sugared
# ->; or I'm having an outbreak of stupidity early on a Saturday morning ;-).
#
# Kazic, 29.12.07


# need three indices, i, j, k:  i is the number of elements in the array,
# j is the number of repeated labels, and 
# k is the index for the sheet layout, k = i + j, but must
# be incremented over each iteration of i and j.  So there might be some scoping
# issues, but suspect not.
#
# Would it make sense to switch %inbred_lines to an indexed array?
#
# Kazic, 2.11.09


# new

sub make_inbred_seed_bag_labels {
        ($output_file,$num_extras,%inbred_lines) = @_;


        $j = 0;
        $num_lines = keys(%inbred_lines) + $num_extras;

        open(TAG,">$output_file");
        &begin_latex_file(\*TAG);

        foreach $family ( sort keys %inbred_lines ) {
            
                ($female_out,$male_out,$crop,$ma_num_gtype,$pa_num_gtype,$gtype,$num_extra_tags) = split(/::/,$inbred_lines{$family});
                $fe_barcode_file = $barcode_rel_dir . $female_out;
                $male_barcode_file = $barcode_rel_dir . $male_out;

                for ( $i = 0 ; $i <= $num_extra_tags; $i++ ) {
                        &print_inbred_seed_bag_label(\*TAG,$fe_barcode_file,$male_barcode_file,$family,$crop,$ma_num_gtype,$pa_num_gtype,$gtype,$j,$num_lines);
		        $j++;
		        }
                }

        &end_latex_file(\*TAG);
        close(TAG);
        }









sub organize_plant_tag_switches {
        ($switch2,$switch3,$switch4) = @_;


        if  ( $switch2 eq "" ) {
                $just_these = "b";
	        $filtratn = "false";
	        $verificatn = "false";
                }

        else {
	        if ( $switch2 =~ /[imb]/ ) { 
	                $just_these = $switch2;
                        if ( $switch3 ne "" ) { 
	        	        if ( $switch3 =~ /f/ ) { 
	        		        $filtratn = "true"; 
				        if ( $switch4 =~ /v/ ) { $verificatn = "true"; }
					else { $verificatn = "false"; }
	        		        }

		                elsif ( $switch3 =~ /v/ ) { 
		                        $filtratn = "false"; 
			                $verificatn = "true"; 
			                }
                                else { print "\nWarning! Unconsidered case in organize_plant_tag_switches, else block, $switch3 ne 0.\n\n"; }
			        }

                        else {
			        $filtratn = "false";
			        $verificatn = "false";
			        }
		        }


                elsif ( $switch2 =~ /[vf]/ ) { 
                        $just_these = "b";
	                if ( $switch2 =~ /f/ ) {
			        $filtratn = "true";
                                if ( $switch3 =~ /v/ ) { $verificatn = "true"; }
                                else { $verificatn = "false"; }
	        	        }
	                if ( $switch2 =~ /v/ ) {
			        $filtratn = "false";
  		                $verificatn = "true";
			        }
        	        }

	        
                elsif ( $switch2 =~ /v/ ) { 
                        $just_these = "b";
	                $filtratn = "false"; 
		        $verificatn = "true";
                        }
	        }


        return($just_these,$filtratn,$verificatn);
        }







########### for Tripsacum plant tags


sub make_field_plant_tags { 

        ($num) = @_;


        for ( my $i = 1; $i <= $num; $i++ ) {

    	        ($barcode_out_upper) = &make_field_plant_tag($i);
                $record = $barcode_rel_dir . $barcode_out_upper  . "::" . $i;
                push(@labels,$record);
	        }

        return @labels;
        }




# "f" is for "field plant" -- Tripsacum

sub make_field_plant_tag {
        ($i) = @_;
        $padded_code = &pad_row($i,5); 
        $code = "f" . $padded_code;
        $barcode_out = &make_barcodes($barcodes,$code,$esuffix);

	return($barcode_out);
        }





sub fill_out_daddy {
	($ma_plant,$pa_plant,$cross) = @_;

        $pa = $cross->{$ma_plant};
        ($pa_rowplant) = $pa =~ /(${rowplant_re})$/;
        ($pa_plant_rowplant) = $pa_plant =~ /(${rowplant_re})$/;

        if ( $pa_rowplant eq $pa_plant_rowplant ) { 
                print "substituting $pa for $pa_plant in cross with $ma_plant\n";
                $pa_plant = $pa;
                }

        else { print "Warning! no complete numerical genotype found for $pa_plant in cross with $ma_plant\n"; }

        return $pa_plant;
        }








########### for tissue sample tags


sub make_sample_tags { 

        ($num) = @_;


        for ( my $i = 1; $i <= $num; $i++ ) {

    	        ($barcode_out_upper) = &make_sample_tag($i);
                $record = $barcode_rel_dir . $barcode_out_upper  . "::" . $i;
                push(@labels,$record);
	        }

        return @labels;
        }




# "e" is for "sample"

sub make_sample_tag {
        ($i) = @_;
        $padded_code = &pad_row($i,5); 
        $code = "e" . $padded_code;
        $barcode_out = &make_barcodes($barcodes,$code,$esuffix);

	return($barcode_out);
        }








# for generating corrected seed envelope labels, the need revealed by our
# re-inventory of the seed in the winter of 2014.
#
# Kazic, 21.5.2014


sub make_new_seed_labels {

        ($output_file,$today,$#labels,$labels) = @_;

        open(TAG,">$output_file");
        &begin_latex_file(\*TAG);

        for ( $i = 0; $i <= $#labels; $i++ ) {
                ($ma,$ma_barcode_out,$pa,$pa_barcode_out,$old_ma) = split(/::/,$$labels[$i]);
                $ma_barcode_file = $barcode_rel_dir . $ma_barcode_out;
                $pa_barcode_file = $barcode_rel_dir . $pa_barcode_out;

                &print_new_seed_labels(\*TAG,$ma,$ma_barcode_file,$pa,$pa_barcode_file,$old_ma,$today,$i,$#labels);
                }

        &end_latex_file(\*TAG);
        close(TAG);
        }










1;
