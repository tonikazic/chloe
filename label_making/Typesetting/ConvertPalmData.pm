# this is ../c/maize/label_making/Typesetting/ConvertPalmData.pm

# conversions from Palm menu data --- now Numbers spreadsheets on iphones! (2014)
#  ---  to prolog facts
#
# Kazic, 6.9.2009



package ConvertPalmData;

use MaizeRegEx;
use NoteExpsn;




use Exporter;

our @ISA = qw(Exporter);

our @EXPORT = qw(
             assemble_action_list
             assemble_phenotype_list
             check_false
             check_null
             concat_notes
             convert_cl
             convert_cross_plan
             convert_datetime
             convert_dwarfism
             convert_fungus
             convert_image_range
             convert_leaves
             convert_mutant_scoring
             convert_num_tfs
             convert_photo_plan
             convert_photo_plant
             convert_pollination_results
             convert_pollination_results2
             convert_south_farms_datetime
             convert_sleeve
             expand_phenotypes
             grab_crop_from_file
             string_cl
             tidy_list
             );








# reflects change in menu of 31.7.2010
#
# accommodates ipad data collection menu; tested
#
# Kazic, 7.4.2012


sub assemble_action_list {
#        ($tassel_bagged,$shoot_bagged,$ear1_silking,$ear1_cut,$ear2_cut) = @_;
        ($tassel_bagged,$popped_tassel,$cut_tassel,$ear1_cut,$ear2_cut) = @_;

        $action_list = "";

#	print "($tassel_bagged,$popped_tassel,$cut_tassel,$ear1_cut,$ear2_cut)\n";


        if ( $tassel_bagged !~ /\"\"/ ) { $tassel_bagged = "bag(tassel)"; }
        if ( $popped_tassel !~ /\"\"/ ) { $popped_tassel = "pop(tassel)"; }
        if ( $cut_tassel !~ /\"\"/ ) { $cut_tassel = "cut(tassel)"; }


# accommodate "4" signifying that the shoot has been bagged
#
# Kazic, 7.4.2012

        if ( $ear1_cut !~ /\"\"/ ) { 
                if ( $ear1_cut =~ /true/ ) { $ear1_cut = "cut(1)"; }
                elsif ( $ear1_cut =~ /4/ ) { $ear1_cut = "bag(shoot)"; }
                }

        if ( $ear2_cut !~ /\"\"/ ) { $ear2_cut = "cut(2)"; }



        $action_list = $tassel_bagged . "," . $popped_tassel . "," . $cut_tassel . "," . $ear1_cut . "," . $ear2_cut;
        $action_list = &tidy_list($action_list);

        return $action_list;
        }

















sub assemble_phenotype_list {
        ($ave_leaf_num,$num_wild_type,$num_mutant,$health,$int_phenotype_list) = @_;

        $int_list = "";
        $phenotype_list = "";
        $onum_mutant = "";
        undef @int_phenotype_array;
        undef @phe_array;


        if ( ( $ave_leaf_num !~ /\"\"/ ) && ( $ave_leaf_num ne "" ) ) { $ave_leaf_num = "ave_leaf_num(" . $ave_leaf_num . ")"; }
        else { $ave_leaf_num = ""; }

        if ( ( $num_wild_type !~ /\"\"/ ) && ( $num_wild_type ne "" ) ) { $num_wild_type = "phenotype(wild_type," . $num_wild_type . ")"; }
        else { $num_wild_type = ""; }

        if ( ( $num_mutant !~ /\"\"/ ) && ( $num_mutant ne "" ) ) { $onum_mutant = "phenotype(mutant," . $num_mutant . ")"; }
        else { $num_mutant = ""; }



	
        if ( $health =~ /\d+/ ) { $health = "phenotype(healthy,$health)"; }
        elsif ( ( $health !~ /\"\"/ ) && ( $health ne "" ) ) { $health = "phenotype(healthy,_)"; }
        else { $health = ""; }

        if ( $int_phenotype_list !~ /\"\"/ ) { 
                (@int_phenotype_array) = split(/;/,$int_phenotype_list) ;
                foreach $int_phe (@int_phenotype_array) {
                        ($phenotype) = &parse_phenotype($int_phe);
			push(@phe_array,$phenotype);
		        }
	        }     



        $int_list = $ave_leaf_num . "," . $num_wild_type . "," . $onum_mutant . "," . $health;

#        print "int: $int_list\n";

#        $int_list =~ s/,,//g;
        $int_list =~ s/,,/,/g;
        if ( ( $int_list ne "" ) && ( $int_phenotype_list ne "" ) ) { $int_list .= ","; }                 
        elsif ( ( $int_list ne "" ) && ( $int_phenotype_list eq "" ) ) { $phenotype_list = ""; }          
        elsif ( ( $int_list eq "" ) && ( $int_phenotype_list eq "" ) ) { $phenotype_list = $int_list; }   

        if ( $int_phenotype_list ne "" )  {                                                            


# if $num_mutant > 0 and only one mutant phenotype and that one has an underscore, then
# substitute $num_mutant for underscore

                if ( ( $num_mutant > 0 ) && ( scalar @phe_array == 1 ) && ( $phe_array[0] =~ /\_/ ) ) { 
                        ($mut_phe) = $phe_array[0] =~ /(.+),\_\)/;
                        $phenotype_list = $mut_phe . "," . $num_mutant . ")";
		        }


		
		else {
                        for ( $i = 0; $i < $#phe_array; $i++ ) { $phenotype_list .= $phe_array[$i] . ","; }       
                        $phenotype_list .= $phe_array[$#phe_array];
		        }
	        }




# modified to adjust count of healthy plants by dead or soon-to-be-dead plants in the
# phenotype list.
#	
# From 18r onwards, menu has changed so that dead plants are counted directly
# and healthy plants are computed from that.  So this is a retrofit.
#
# Kazic, 21.4.2018


	$phenotype_list =~ s/phenotype\(_,_\)//g;
	if ( my ($num_dead) = $phenotype_list =~ /phenotype\(_,(\d+)\)/) {
  	        my ($num_healthy) = $health =~ /phenotype\(healthy,(\d+)\)/;
                $num_healthy = $num_healthy - $num_dead;
                $health = "phenotype(healthy," . $num_healthy . ")";
                $phenotype_list =~ s/phenotype\(_,(\d+)\)//g;
                }


	

        $final = $int_list . $phenotype_list;
#        print "final: $final\n";
        $final = &tidy_list($final);

        return $final;
        }











sub parse_phenotype {
        ($string) = @_;

        $converted = "";
        $num = "";
        $phe = "";

        if ( $string !~ /\d+\b/ ) { ($converted) = &expand_note($string) ; }
        else {
                ($num,$phe) = $string =~ /(\d+)\b(.+)/;
                ($converted)  = &expand_note($phe) ; 
	        }
        $phe = "phenotype(" . $converted . ",";

        if ( $num eq "" ) { $num = "_"; }
        

        $phe = $phe . $num . ")";

        return $phe;
        }






# modified to reflect altered ipad data collection menus, including sampling for
# tissue.  Some parts not yet tested as 12n data don't have those conditions.
#
# Kazic, 26.2.2013


# must modify to include new bug score processing
#
# input is now:                 ($full_note,$followup_plan) = &expand_phenotypes($plant,$wild_type,$lesion,$stature,$tassel,$ear,$bug,$other_phe,$sample);
#
# Kazic, 22.9.2014

sub expand_phenotypes {
#        ($plant,$wild_type,$lesion,$stature,$tassel,$ear,$other_phe,$sample) = @_;
        ($plant,$wild_type,$lesion,$stature,$tassel,$ear,$bug,$other_phe,$sample) = @_;

        ($lesion_phenotype) = &convert_mutant_scoring($plant,$wild_type,$lesion);
        ($stature_phe) = &convert_discrete_phes($stature);
        ($tassel_phe) = &convert_discrete_phes($tassel);
        ($ear_phe) = &convert_discrete_phes($ear);
        ($bug_phe,$other_phe) = &convert_bug_phe($bug,$other_phe);


# must still test altered other_phe and followup_plan logic in non-12n data
#
# Kazic, 26.2.2013

        if ( ( $other_phe ne "" ) || ( $other_phe ne " " ) ) { ($int_note) = &expand_note($other_phe); }



        if ( $sample eq "true" ) { $sample_plan = "sample"; }
        else {  $sample_plan = ""; }




        if ( $int_note =~ /^\_$/ ) { 
#		$full_note = $lesion_phenotype . "," . $stature_phe . "," . $tassel_phe . "," . $ear_phe;
		$full_note = $lesion_phenotype . "," . $stature_phe . "," . $tassel_phe . "," . $ear_phe . "," . $bug_phe;
                $followup_plan = "[" . $sample_plan . "]";
	        }
	
	
        else { 

                $combined_note = $int_note . "; " . $sample_plan;
		($note,$followup) = &divide_note($combined_note);
#                $full_note = $lesion_phenotype . "," . $stature_phe . "," . $tassel_phe . "," . $ear_phe . "," . $note;
                $full_note = $lesion_phenotype . "," . $stature_phe . "," . $tassel_phe . "," . $ear_phe . "," . $bug_phe . "," . $note;
                $followup_plan = &tidy_list($followup);
	        }
	
        $full_note = &tidy_list($full_note);

        return ($full_note,$followup_plan);
        }









# untested with post-11r data
#
# Kazic, 26.2.2013

sub divide_note {
        my ($note) = @_;

        undef(@note_array);
        undef(@phenotype_array);
        undef(@followup_array);
        my $phe_string = "";
        my $followup_string = "";

        my (@note_array) = split(/;\s/,$note);

        for ( $i = 0 ; $i <= $#note_array ; $i++ ) {
                my ($fragmt) = &check_quotes($note_array[$i]);
 
                if ( $fragmt =~ /(ask Gerry|not needed|discard if possible|follow warning on bag|check cross record|recheck|sample|check pedigree|check parental photo|check ancestral photos)/ ) { push(@followup_array,$fragmt) ; }
                else { push(@phenotype_array,$fragmt); }
                $fragmt = "";
	        }

	for ( $j = 0 ; $j <= $#phenotype_array ; $j++ ) { $phe_string .= "phenotype(" . $phenotype_array[$j] . "),"; }
	for ( $k = 0 ; $k <= $#followup_array ; $k++ ) { $followup_string .= $followup_array[$k] . ","; }

        my ($endnote) = &tidy_list($phe_string);
        my ($followup) = &tidy_list($followup_string);
        $followup = "[" . $followup . "]";

        return ($endnote,$followup);
        }







sub check_quotes {
        ($string) = @_;

        if ( $string !~ /^\'/ ) { $int = "'" . $string; }
        else { $int = $string; }

        if ( $int !~ /\'$/ ) { $int2 = $int . "'"; }
        else { $int2 = $int; }

        $int2 =~ s/^\'\s/\'/g;
        $int2 =~ s/\s\'$/\'/g;

        return $int2;
        }






# a null string is not a string containing 0!
# Nor should it imply 0; the data are most likely to be text.
#
# added condition for just spaces
#
# Kazic, 20.7.2019


sub check_null {
        ($string) = @_;

        if ( ( $string eq "" ) || ( $string =~ /\"\"/ ) || ( $string =~ /\s+/ ) || ( $string =~ /\_/ ) ) { $string = "\"\""; }

        return $string;
        }









sub check_false {
        ($string) = @_;

        if ( $string =~ /[Ff][Aa][Ll][Ss][Ee]/ ) { $string = "\"\""; }

        return $string;
        }




sub tidy_list {
        ($list) =@_;

#        print "tl: $list    ::  ";

        $list =~ s/\"\"//g;
#        $list =~ s/^,//g;
        $list =~ s/^,,*//g;
#        print "$list   ,,,   ";
#        $list =~ s/,$//g;
        $list =~ s/,*,$//g;
#        print "$list   ;;  ";
        $list =~ s/,,,*/,/g;


#        print "$list\n";

        return $list;
        }




sub concat_notes {
        (@notes) = @_;

        $string = "";
        for ( $i = 0; $i <= $#notes; $i++ ) { 
                if ( ( $notes[$i] !~ /\"\"/ ) && ( $notes[$i] ne 'false' ) && ( $notes[$i] ne '_' ) && ( $notes[$i] ne '0' ) ) { $string .= $notes[$i] . "; "; }
	        }

        $string =~ s/\'//g;
        $string =~ s/\'\;\s/\;\s/;
        $string =~ s/\;\s$//;
        $string =~ s/\'\; \'/\; /g;

        if ( ( $string eq "" ) || ( $string eq "\'whole ear\'" ) || ( $string eq "\'whole\'" )  || ( $string eq "whole" ) )  { $string = '_'; }

        if ( $string ne '_' ) { $string = "'" . $string . "'"; }

        return $string;
	}









sub convert_cl {
        ($ma_plant,$fuzzy_cl,$num_cl) = @_;


        if ( ( ( $fuzzy_cl eq "nil" ) || ( $fuzzy_cl eq "fuzzy_cl" ) || ( $fuzzy_cl eq '' ) ) && ( $num_cl =~ /\d+/ ) ) { $final_num_cl = $num_cl; }
        elsif ( ( ( $fuzzy_cl ne "nil" ) || ( $fuzzy_cl ne "fuzzy_cl" ) || ( $fuzzy_cl ne '' ) ) && ( ( $num_cl eq '' ) || ( $num_cl eq '0' ) ) ) {  $final_num_cl = $fuzzy_cl; }
        else { print "Warning! Kernel count ambiguous for $ma_plant having $fuzzy_cl and $num_cl.\n"; }

#        print "($fuzzy_cl,$num_cl,$final_num_cl)\n";

        return $final_num_cl;
        }






sub string_cl {
        ($final_num_cl) = @_;

        if ( $final_num_cl =~ /\d+/ ) { $string_cl = "'" . $final_num_cl . " cl'"; }
        else { ($string_cl) = &expand_note($final_num_cl); }
 

#        print "($final_num_cl,$string_cl)\n";

        return $string_cl;
        }





# matches new ipad data collection menu, but untested
#
# Kazic, 8.4.2012

sub convert_cross_plan {

        ($cross) = @_;

	($cross) = &check_false($cross);

        if ( $cross !~ /\"\"/ ) { $cross_plan = "cross"; }
        else { $cross_plan = "false"; }

        return $cross_plan;
        }









# modified to accommodate ipad data collection; tested
#
# Kazic, 7.4.2012

sub convert_num_tfs {
        (@num_tfs) = @_;
        undef @tfs; 

        foreach $elt (@num_tfs) {
                if ( $elt == 0 ) { push(@tfs,"false"); }
                elsif ( $elt == 1 ) { push(@tfs,"true"); }
                else { push(@tfs,"$elt"); }
	        }

        return @tfs;
        }






sub convert_photo_plan {
        ($photograph) = @_;

	($photograph) = &check_false($photograph);

        if ( $photograph !~ /\"\"/ ) { $photo_plan = "photo"; }
        else { $photo_plan = "false"; }

        return $photo_plan;
        }







# buffed up to handle common date formatting variations from the
# spreadsheet.  24 hour time is still preferable as seconds are not
# assumed.
#
# Kazic, 24.4.2018

sub convert_datetime {
        ($datetime) = @_;

        ($date,$time) = $datetime =~ /(${date_re}) (${time_re})/;
        ($mon,$day,$year) = $date =~/(${month_re})\/(${day_re})\/(${year_re})/;
        if ( length($year) == 2 ) { $year = "20" . $year; }


        ($hour,$min,$rest) = $time =~ /($hour_re):($hour_re)(.+)$/;

        if ( $rest =~ /($pm_re)/ ) {
   	        $sec = "00";
	        $hour = $hour + 12;
                }

        else { ($sec) = $rest =~ /:(\d+)/; }				  

#        print "$datetime $date $time |$rest| ($mon,$day,$year,$hour,$min,$sec)\n";	
	
        ($mon,$day,$hour,$min,$sec) = &pad_digits($mon,$day,$hour,$min,$sec);

        $date = "date($day,$mon,$year)";
        $time = "time($hour,$min,$sec)";

        return ($date,$time);
        }




# spreadsheets often format single digits in dates and times as just that, with no
# leading zero:  so insert a zero into such
#
# Kazic, 9.6.2012


sub pad_digits {

	(@unpadded) = @_;
        for ( $i = 0; $i <= $#unpadded; $i++ ) { 
                if ( $unpadded[$i] =~ /^\d$/ ) { $unpadded[$i] =~ s/(\d)/0\1/; }
	       }

        return @unpadded;
        }





# both Prolog and R run their clocks from 00 to 23; ignore time zone since
# South Farms assumes DST
#
# Kazic, 31.5.2011

sub convert_south_farms_datetime {
        ($month,$day,$year,$hour) = @_;


        $date = "date($day,$month,$year)";
        if ( $month =~ /\d\d/ ) { $Rmonth = $month; }
        else { $Rmonth = "0" . $month; }
        $Rdate = "$year-$Rmonth-$day";

        $hour = $hour - 100;
        if ( $hour eq "0" ) { $hour = "0000"; }
        elsif ( $hour =~ /^\d{3}$/ ) { $hour = "0" . $hour; }
        $hour =~ s/00$/:00:00/g;
        $Rtime = $hour;
        $hour =~ s/:/,/g;
        $time = "time($hour)";

        $Rdatetime = $Rdate . " " . $Rtime;

        return ($date,$time,$Rdatetime);
        }









sub convert_discrete_phes {
        ($discrete_phe) = @_;

#        print "dp: $discrete_phe\n";


        $discrete_phe =~ s/,$//g;
	($discrete_phe) = &check_false($discrete_phe);

        if ( $discrete_phe !~ /\"?\s?\"?/ )  { $discrete_phe = ""; }

        elsif ( $discrete_phe =~ /(short|dwarf|miniscule|ear|tassel)/ ) { 

                ($discrete_phe) = $discrete_phe =~ /\"?(.+)\"?/; 
                if ( ( $discrete_phe eq "ear" ) ||  ( $discrete_phe eq "tassel" ) ) { $discrete_phe = ""; }
                $discrete_phe =~ s/(\w)\s(\w)/\1\_\2/g;
                }

        else { $discrete_phe = ""; }


        if ( $discrete_phe ne "" ) { $discrete_phe = "phenotype($discrete_phe)"; }
        else { $discrete_phe = ""; }

#        print "dpr: $discrete_phe\n";


        return $discrete_phe;
        }






# modified to capture numerical bug scores folded into the
# other_phes field as raw digits
#
# Kazic, 26.4.2018

sub convert_bug_phe {
        ($bug_score,$other_phe) = @_;

        if ( $other_phe !~ /[;,]*[012][;,]*/ ) { $bug_score = "0"; }
        else {
	        ($front,$bug_score,$back) = $other_phe =~ /^([\w\_\s\.,]*[,;]*)([012])[;,]*(.*)$/;
                $other_phe = $front . $back;
	        }
	
        $bug_phe = "bug(" . $bug_score . ")";
        return ($bug_phe,$other_phe);
        }








sub convert_fungus {
        ($fungus) = @_;

	($fungus) = &check_false($fungus);

        if ( $fungus !~ /\"\"/ ) { $fungus = "\'fungus\'"; }

        return $fungus;
        }







sub convert_leaves {
        ($abs_leaf_num,$rel_leaf_num) = @_;

        if ( ( $abs_leaf_num eq unk ) || ( $abs_leaf_num eq "" ) )  {
                if ( $rel_leaf_num =~ /[\+\-]/ ) { $leaf = "'" . $rel_leaf_num . "'"; }
                else { $leaf = $rel_leaf_num; }
	        }
        else { $leaf = $abs_leaf_num; }

        return $leaf;
        }











sub convert_image_range {
        ($image_range) = @_;

        if ( $image_range ) { 
                ($start,$end) = $image_range =~ /(\d+) (\d+)/;
                $image_start = "image(start,$start)";
                $image_end = "image(end,$end)";
	        }

        else {
                $image_start = '_';
                $image_end = '_';
    	        }

        return ($image_start,$image_end);
        }








sub convert_mutant_scoring {
        ($plant,$wild_type,$lesion) = @_;

	($wild_type) = &check_false($wild_type);
        ($lesion) = &check_false($lesion);

        if ( ( $wild_type !~ /\"\"/ ) && ( $lesion =~ /\"\"/ ) ) { $lesion_phenotype = "phenotype(wild_type)"; }
        elsif ( ( $wild_type =~ /\"\"/ ) && ( $lesion !~ /\"\"/ ) ) { $lesion_phenotype = "phenotype(les)"; }
        elsif ( ( $wild_type =~ /\"\"/ ) && ( $lesion =~ /\"\"/ ) ) { $lesion_phenotype = ""; }
        elsif ( ( $wild_type !~ /\"\"/ ) && ( $lesion !~ /\"\"/ ) ) { $lesion_phenotype = ""; print "Warning! plant $plant scored as both wild-type and lesion!\n"; }
        }








sub convert_photo_plant {
        ($photo) = @_;

        if ( $photo ) { $photo_plant = "photo_plant($photo)"; }
        else { $photo_plant = '_'; }
 
        return $photo_plant;
        }




sub convert_pollination_results {
        ($ok,$failed) = @_;

        if ( $ok =~ /[fF]alse/ ) {
                if ( $failed =~ /[tT]rue/ ) { $success = "failed"; }
                else { $success = "unk"; }
	        }
        else { $success = "succeeded"; }

        return $success;
        }



sub convert_pollination_results2 {
        ($ok) = @_;

        if ( $ok =~ /[fF]alse/ ) { $success = "failed"; }
        else { $success = "succeeded"; }

        return $success;
        }






sub convert_sleeve {
        ($sleeve) = @_;

#	print "in: $sleeve";
        if ( $sleeve eq '' ) { $sleeve = 'v00000'; }
        elsif ( $sleeve eq 'v00' ) { $sleeve = 'v00000'; }
        elsif ( $sleeve eq 'v' ) { $sleeve = 'v00000'; }
        elsif ( $sleeve =~ /[^v][123456789]*\d*/ ) {
                $padding = 5 - length($sleeve);
                $pad = '0' x $padding;
                $sleeve = 'v' . $pad . $sleeve;
                }
	elsif ( $sleeve =~ /v\d{5}/ ) { }  # do nothing
#	print "   out: $sleeve\n";
		
        return $sleeve;
        }


	


	

# uses nice trick for upper-casing the letters in the string

sub grab_crop_from_file {
        ($file) = @_;

        ($crop) = $file =~ /\/(${crop_re})\//;
        $crop = "\U$crop";

        return $crop;        
        }





1;
