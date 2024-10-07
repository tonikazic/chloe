# this is maize/label_making/Typesetting/TypesetGenetics.pm

# a module of typesetting commands for various types of labels;
# really minor or universal subroutines are in TypesettingMisc.pm
#
# this should be further re-arranged, but leave it alone for now
#
# Kazic, 6.11.07


package Typesetting::TypesetGenetics;

use Typesetting::TypesettingMisc;
use Typesetting::PrintGuides;




use Exporter;

our (@EXPORT, @ISA);

@ISA = qw(Exporter);
@EXPORT = qw(typeset_plant_tags
             typeset_packet_label
             typeset_bc_gtype
             print_harvest_tag
             typeset_gtype
             make_inventory_labels
             print_sleeve_label
             print_box_label
             print_tear_off_tag
#
# ever called from top?
#
             get_family_prefix
             clean_gtypes
             scale_gtypes
            );














# typesets the bar code plant labels
#
# framebox is not needed around barcode provided the barcodes are well separated



# need to modify this based on 07r experience:
#
#        barcodes can be scaled 0.75 just fine;
#        make threefers to be three identical barcodes;
#        put large plantrow atop every barcode;
#        plantrow goes on both sides of the threading hole;
#        get genotypes better on tags and tear-off tags;
#        make sure a genotype is in the same position, relative to the barcode, 
#               on the first barcode next to threading hole, as it is on the tear-off tags;
#        adjust placement and sizing of layout to idiot-proof against feed errors in printing;
#
# Kazic, 26.9.07



sub typeset_plant_tags {
        ($barcode_out,$pre_row,$pplant,$family,$ma_num_gtype,$pa_family,$pa_num_gtype,$pma_ma_gma_gtype,$pma_ma_gpa_gtype,$pma_pa_gma_gtype,$pma_pa_mutant,$ppa_pa_gma_gtype,$ppa_ma_gpa_gtype,$ppa_pa_gma_gtype,$ppa_pa_mutant,$quasi_allele,$top_box_x,$top_box_y,$mid_box_x,$mid_box_y,$bot_box_x,$bot_box_y) = @_;

        ($ma_gtype) = &make_genotype($pma_ma_gma_gtype,$pma_ma_gpa_gtype,$pma_pa_gma_gtype,$pma_pa_mutant);
        ($pa_gtype) = &make_genotype($ppa_pa_gma_gtype,$ppa_ma_gpa_gtype,$ppa_pa_gma_gtype,$ppa_pa_mutant);



	&print_top_tag($filehandle,$top_box_x,$top_box_y,$pre_row,$pplant,$barcode_out,$family,$ma_gtype,$pa_gtype,$quasi_allele);
        &print_cross_tag($filehandle,$mid_box_x,$mid_box_y,$ma_gtype,$pa_gtype,$family,$pre_row,$plant,$quasi_allele,$barcode_out);
        &print_cross_tag($filehandle,$bot_box_x,$bot_box_y,$ma_gtype,$pa_gtype,$family,$pre_row,$plant,$quasi_allele,$barcode_out);
        }





sub get_family_prefix {
        ($family) = @_;

        if ( $family !~ /\d{4}/ ) {
                if ( $family =~ /2\d{2}/ ) { $prefix = "S"; }
                elsif ( $family =~ /3\d{2}/ ) { $prefix = "W"; }
                elsif ( $family =~ /4\d{2}/ ) { $prefix = "M"; }
	        }
        else { $prefix = ""; }

	return $prefix;
        }







sub make_genotype {
        my ($ma_gma_gtype,$ma_gpa_gtype,$pa_gma_gtype,$pa_gpa_gtype) = @_;

        if ( ( $ma_gma_gtype eq $ma_gpa_gtype ) && ( $ma_gma_gtype eq $pa_gma_gtype ) && ( $ma_gma_gtype eq $pa_gpa_gtype ) ) { $gtype = "\\mathrm{" . $ma_gma_gtype . "}"   ; }

        elsif  ( ( $ma_gma_gtype eq $ma_gpa_gtype ) && ( $ma_gma_gtype ne $pa_gma_gtype ) && ( $ma_gma_gtype ne $pa_gpa_gtype ) ) { $gtype = "\\frac{\\mathrm{" . $ma_gma_gtype . "}}{\\frac{\\mathrm{" . $pa_gma_gtype . "}}{\\mathrm{" . $pa_gpa_gtype . "}}}"; }

        elsif  ( ( $ma_gma_gtype ne $ma_gpa_gtype ) && ( $ma_gma_gtype ne $pa_gpa_gtype ) ) { $gtype = "\\frac{\\frac{\\mathrm{" . $ma_gma_gtype . "}}{\\mathrm{" . $ma_gpa_gtype . "}}}{\\frac{\\mathrm{" . $pa_gma_gtype . "}}{\\mathrm{" . $pa_gpa_gtype . "}}}"; }

#        print "$ma_gma_gtype,$ma_gpa_gtype,$pa_gma_gtype,$pa_gpa_gtype $gtype \n";

        return $gtype;

        }








# modified to use 07r data
#
# Kazic, 8.7.07

sub print_top_tag {

        ($filehandle,$top_box_x,$top_box_y,$pre_row,$pplant,$barcode_out,$family,$ma_gtype,$pa_gtype,$quasi_allele) = @_;

        $row_x = $top_box_x + 2;
	$row_y = $top_box_y + 50;


#        $ngtype_x = $top_box_x + 2;
        $ngtype_x = $top_box_x - 2 - 0;
#        $ngtype_y = $top_box_y - 36;
        $ngtype_y = $top_box_y - 40;

        $family_x = $ngtype_x + 4;
        $family_y = $ngtype_y + 45;


#        $fam_x = $top_box_x + 4;
        $fam_x = $top_box_x - 1;
#        $fam_y = $top_box_y - 80;
        $fam_y = $top_box_y - 75 - 7;

#        $fx = $fam_x + 8;
        $fx = $fam_x + 5;
        $fy = $fam_y - 1;

        print $filehandle  "\\put($row_x,$row_y){\\rotatebox{90}{\\begin{tabular}{p{1.6cm}}  \\begin{tabular}{r}
                   \\scalebox{1.6}{\\textbf{$pre_row}} \\\\  \\\\  \\scalebox{1.60}{\\textbf{$pplant}}  \\end{tabular} \\end{tabular}}} \n";
                 
        print $filehandle "\\put($family_x,$family_y){\\rotatebox{90}{\\scalebox{1.2}{$family}}}\n";

        &print_threefers($filehandle,$top_box_x,$top_box_y,$barcode_out);

        print $filehandle "\\put($ngtype_x,$ngtype_y){\\begin{tabular}{c}
                   \\rotatebox{90}{\\scalebox{1}{\\Large{\\textbf{$pre_row \\hspace{7mm}   $pplant}}}}
                   \\end{tabular}} \n";



        print $filehandle "\\put($fam_x,$fam_y){\\rotatebox{90}{\\begin{tabular}{c}
                           \\scalebox{0.85}{$quasi_allele}
                           \\end{tabular}}} \n";


        &scale_gtypes($filehandle,$fx,$fy,$ma_gtype,$pa_gtype);

        }













sub scale_gtypes {
        ($filehandle,$fx,$fy,$ma_gtype,$pa_gtype) = @_;

        $big_gtype_re = qr/[lL]\*?-[\w-]+/;
 
# huh?

        if ( ( $ma_gtype =~ /\|/ ) || ( length($ma_gtype) < 10 ) || ( $pa_gtype =~ /\|/ ) || ( length($pa_gtype) < 10 ) && ( $ma_gtype !~ /les\*-74-1873-9/ ) &&  ( $pa_gtype !~ /${big_gtype_re}/ ) ) {

#
#                print $filehandle "\\put($fx,$fy){\\rotatebox{90}{\\scalebox{0.65}{\$\\frac{" . $ma_gtype . "}{" . $pa_gtype . "}\$}}}\n";
                 print $filehandle "\\put($fx,$fy){\\rotatebox{90}{\\scalebox{0.5}{\$\\frac{" . $ma_gtype . "}{" . $pa_gtype . "}\$}}}\n";
	        }

        elsif ( ( ( $ma_gtype =~ /${big_gtype_re}/ ) && ( length($ma_gtype) >= 10 ) )
                || ( ( $pa_gtype =~ /${big_gtype_re}/ ) && ( length($pa_gtype) >= 10 ) ) ) {
#                print $filehandle "\\put($fx,$fy){\\rotatebox{90}{\\scalebox{0.27}{\$\\frac{" . $ma_gtype . "}{" . $pa_gtype . "}\$}}}\n";
                print $filehandle "\\put($fx,$fy){\\rotatebox{90}{\\scalebox{0.22}{\$\\frac{" . $ma_gtype . "}{" . $pa_gtype . "}\$}}}\n";
	        }

        else { print $filehandle "\\put($fx,$fy){\\rotatebox{90}{\\scalebox{0.75}{\$\\frac{" . $ma_gtype . "}{" . $pa_gtype . "}\$}}}\n"; }
        }











# threefer
#        $fam_y = $top_box_y - 73;

# 0.5 - 0.6 are fine; so can use 0.65 in threefers, spread these out nicely

# double-check scanning!

sub print_threefers { 
        ($filehandle,$top_box_x,$top_box_y,$barcode_out) = @_;


#        print $filehandle "\\put($top_box_x,$top_box_y){\\begin{tabular}{c}
        print $filehandle "\\put($top_box_x,$top_box_y){\\begin{tabular}{r}
                   \\rotatebox{90}{\\scalebox{0.5}{\\includegraphics{$barcode_out}}} \\\\
                   \\rotatebox{90}{\\scalebox{0.60}{\\includegraphics{$barcode_out}}} \\\\
                   \\rotatebox{90}{\\scalebox{0.75}{\\includegraphics{$barcode_out}}}
                   \\end{tabular}} \n";
        }











sub print_twofers {
        ($filehandle,$top_box_x,$top_box_y,$barcode_out) = @_;

        $tx = $top_box_x - 1;
        $ty = $top_box_y + 30;

        print $filehandle "\\put($tx,$ty){\\begin{tabular}{c}
                   \\rotatebox{90}{\\scalebox{1}{\\includegraphics{$barcode_out}}}
                   \\end{tabular}} \n";

        $mtx = $tx + 5;
        $mty = $top_box_y - 35;
        print $filehandle "\\put($mtx,$mty){\\begin{tabular}{c}
                   \\rotatebox{90}{\\scalebox{0.75}{\\includegraphics{$barcode_out}}}
                   \\end{tabular}} \n";
        }








# add quasi; test scale 0.8 for barcode

sub print_cross_tag {
        ($filehandle,$mid_box_x,$mid_box_y,$ma_gtype,$pa_gtype,$family,$pre_row,$plant,$quasi_allele,$barcode_out) = @_;

        $cross_box_x = $mid_box_x - 4;
        $cross_box_y = $mid_box_y - 39.5 - 4;

        $data_x = $mid_box_x - 4 + 1;
        $data_y = $mid_box_y + 5;
        
        $gtype_x = $cross_box_x + 2;
        $gtype_y = $cross_box_y + 4;
       

#                     \\rotatebox{90}{\\scalebox{0.7}{\\includegraphics{$barcode_out}}}

        print $filehandle "\\put($mid_box_x,$mid_box_y){\\begin{tabular}{c}
                     \\rotatebox{90}{\\scalebox{0.75}{\\includegraphics{$barcode_out}}}
                     \\end{tabular}}\n";

        print $filehandle "\\put($data_x,$data_y){\\begin{tabular}{c}
                     \\rotatebox{90}{$quasi_allele \\hspace{1mm} $family: $pre_row $pplant}
                     \\end{tabular}}\n";

        &scale_gtypes($filehandle,$gtype_x,$gtype_y,$ma_gtype,$pa_gtype);

        }










# leave room for staples!

sub print_female_tag {
        ($filehandle,$mid_box_x,$mid_box_y,$barcode_out) = @_;

        
        print $filehandle "\\put($mid_box_x,$mid_box_y){\\begin{tabular}{c}
                     \\rotatebox{90}{\\scalebox{0.9}{\\includegraphics{$barcode_out}}}
                     \\end{tabular}}\n";
        }




sub print_male_tag {
        ($filehandle,$bot_box_x,$bot_box_y,$barcode_out) = @_;
        
        print $filehandle "\\put($bot_box_x,$bot_box_y){\\begin{tabular}{c}
                     \\rotatebox{90}{\\scalebox{0.9}{\\includegraphics{$barcode_out}}}
                     \\end{tabular}}\n";
        }









# uses tabular, \frac, \cfrac and \SetDisplayMathSizes to produce a genetically clearer label
# still lots of hand-wiring, for example in the number of skipped rows; and more complicated
# genotypes would still need extra type-setting
#
# Kazic, 2.12.06.

# need to modify so that the packet number and packet barcode are printed, instead of the 
# female and male barcodes.  The idea is to scan the packet label and the mommy and daddy tags 
# from the ear or seed packet when packaging seed.  On planting, we will scan the seed packet
# barcode and the row stake barcode.
#
# Kazic, 26.9.07

sub typeset_packet_label {
         ($filehandle,$family,$female,$male,$ma_gtype,$pa_gma_gtype,$pa_mutant,$cl,$ft,$box_x,$box_y) = @_;

         print $filehandle "\\put($box_x,$box_y){\\rotatebox{90}{\\begin{tabular}{c}\\scalebox{2}{$family} \\\\ \\\\ \\\\ \\\\
                    \$\\frac{\\displaystyle \\mathrm{$female}}{\\displaystyle \\mathrm{$male}}\$ \\\\ \\\\ \\\\
                    \$\\cfrac{\\mathrm{$ma_gtype}}{\\ \\ \\ \\ \\cfrac{\\mathrm{$pa_gma_gtype}}{\\mathrm{$pa_mutant}}}\$ \\\\ \\\\ \\\\
                    $cl cl ($ft ft) \\end{tabular}}}\n";
        }





# more primitive

sub typeset_bc_gtype {
        ($filehandle,$ma_gtype,$pa_gma_gtype,$pa_mutant,$gtype_x,$gtype_y) = @_;

        $gtype_y += 3;

        print $filehandle "\\put($gtype_x,$gtype_y){\\rotatebox{90}{\\scalebox{1.25}{\$\\begin{matrix} \\text{$ma_gtype} \\\\ \\times \\\\ \\frac{\\text{\\large{$pa_gma_gtype}}}{\\text{\\large{$pa_mutant}}} \\end{matrix}\$}}}\n";
        }













############## for make_harvest_tags.new.perl; transplanted and modified from that file




# the Avery business cards are 10/sheet, in two columns of five.  I want to print the tags
# a column at a time so they fit nicely in the pocket of the pollinating apron.  A stack number is 
# printed at the top of each column so they may be reliably sorted if the stacks are dropped.
#
# LaTeX begins commands with \, but Perl uses the \ in character codes in regular expressions.  So it
# must be escaped using another \\.  This produces all those \\.  This particular file uses picture mode,
# one picture per page of Avery labels.


# I may have violated this movement pattern since I transplanted the organization of make_missing_tags.perl
# and its subroutines.  However, this doesn't really matter as we are now using these tags in the seed room,
# not the field.
#
# Kazic, 23.10.07

sub print_harvest_tag {

        ($filehandle,$female_out,$male_out,$female,$male,$female_gtype,$male_gtype,$ear,$date,$i,$#cross) = @_;


        $rem = $i % 10;
        $side = int($rem / 5);
        $stack = int($i / 5);  



# check these

        $step = $rem;

        $base_x = 15;
        $base_y = 200 - 50 * $step;

        $barcode_x = $base_x - 1;
        $barcode_y = $base_y + 1;
	$barcode1_x = $base_x + 44;

        $num_gtype_x = $base_x + 25;
        $num_gtype_y = $base_y + 11;

        $gtype_x = $base_x + 50;
        $gtype_y = $base_y + 3;

        $ear_x = $base_x + 76;
        $ear_y = $base_y + 20;

        $date_x = $base_x + 82;
        $date_y = $base_y + 14;




# need to pass coordinates to the print_harvest_tag_aux subroutine!

        if ( ( $rem eq 0 ) && ( $i eq 0 ) ) {
                &begin_picture($filehandle);
                &print_stack($filehandle,$side,$stack);
#                &print_business_card_guide_boxes($filehandle);
#                &print_harvest_tag_aux($filehandle,....,$female_out,$male_out,$female,$male,$female_gtype,$male_gtype,$ear,$date,$i,$#cross);
                }


        elsif ( $rem > 0 ) { 


# check this next condition

                if ( ( $rem eq 10 ) ) { &print_stack($filehandle,$side,$stack); }

# left side

                if ( $side eq 0 ) {
#                        &print_harvest_tag_aux($filehandle,....,$female_out,$male_out,$female,$male,$female_gtype,$male_gtype,$ear,$date,$i,$#cross);
                        }


# right side

                elsif ( $side eq 1 ) {
#                        &print_harvest_tag_aux($filehandle,....,$female_out,$male_out,$female,$male,$female_gtype,$male_gtype,$ear,$date,$i,$#cross);
		        }


# finish the page

                if ( ( $rem eq 9 ) || ( $i eq $#labels ) ) { &end_picture($filehandle); }

	        }
        }







# need to finish!

sub print_harvest_tag_aux {

# pass variables here!


        ($filehandle) = @_;
              


        print $filehandle "\\put($barcode_x,$barcode_y){\\rotatebox{90}{\\scalebox{0.8}{\\includegraphics{$female_out}}}}\n";
        print $filehandle "\\put($num_gtype_x,$num_gtype_y){\\rotatebox{90}{\\scalebox{1.3}{\$\\begin{matrix}\\text{female} \\\\ \\times \\\\ \\text{male} \\end{matrix}\$}}}\n";
        print $filehandle "\\put($barcode1_x,$barcode_y){\\rotatebox{90}{\\scalebox{0.8}{\\includegraphics{$male_out}}}}\n";


#       &typeset_gtype($female_gtype,$male_gtype,$gtype_x,$gtype_y);

#       print $filehandle "\\put($ear_x,$ear_y){\\rotatebox{90}{\\Large{ear $ear}}}\n";
        print $filehandle "\\put($date_x,$date_y){\\rotatebox{90}{\\Large{$date}}}\n";
        }





# there may be better genotype typesetting elsewhere in this module;
# refine this last

# make easy genotypes for sorting during harvest


sub clean_gtypes {

        ($female,$female_gtype,$male,$male_gtype) = @_;


#        print "in clean:  female is $female; fegt is $female_gtype; male is $male; mgt is $male_gtype\n";

#        if ( ( $female_gtype =~ /^(Mo|W|M)[\dt]/ ) &&  ( $male_gtype =~ /^(Mo|W|M)[\dt]/ ) ) {

        if ( ( $female_gtype =~ /^(Mo|W|M)[\dt]/ ) ||  ( $male_gtype =~ /^(Mo|W|M)[\dt]/ ) ) {

                ($check_female) = $female_gtype =~ /^((Mo|W|M))[\dt]/;
                ($check_male) = $male_gtype =~ /^((Mo|W|M))[\dt]/;
#                print "cf is $check_female; cm is $check_male\n";

                if ( $check_female eq $check_male ) { $male_gtype = "sib"; }

                if ( $check_female eq "Mo" ) { $female_gtype = "Mo20W"; }
		elsif ( $check_female eq "M" ) { $female_gtype = "M14"; }
		elsif ( $check_female eq "W" ) { $female_gtype = "W23"; }
	        }

        if ( $female eq $male ) { $male_gtype = "@"; }

        return($female_gtype,$male_gtype);
        }









sub typeset_gtype {

        ($filehandle,$female_gtype,$male_gtype,$gtype_x,$gtype_y) = @_;

        $fe_len = length($female_gtype);
        $m_len = length($male_gtype);
        $total_len = $fe_len + $m_len;


        if ( $total_len <= 10 ) {
                print $filehandle "\\put($gtype_x,$gtype_y){\\rotatebox{90}{\\scalebox{1.25}{\$\\begin{matrix} \\text{$female_gtype} & \\times & \\text{$male_gtype} \\end{matrix}\$}}}\n";
	        }

        else {
#                if ( ( $fe_len <= 7 ) && ( $m_len <= 7 ) ) {
#                        print $filehandle "\\put($gtype_x,$gtype_y){\\rotatebox{90}{\\scalebox{1.25}{\$\\begin{matrix} \\text{$female_gtype} & \\times \\\\ & \\text{$male_gtype} \\end{matrix}\$}}}\n";

                 
                $gtype_y += 3;

                print $filehandle "\\put($gtype_x,$gtype_y){\\rotatebox{90}{\\scalebox{1.25}{\$\\begin{matrix} \\text{$female_gtype} \\\\ \\times \\\\  \\text{$male_gtype} \\end{matrix}\$}}}\n";

	        }
        }














### for sleeves


# this has corrected y relative to print_seed_packet_label

sub print_sleeve_label {

        ($filehandle,$barcode_out,$sleeve,$i,$#labels) = @_;
        $barcode_file = $barcode_rel_dir . $barcode_out;


        $rem = $i % 30;
        $stack = int($i / 10);
        $side = $stack % 3;
        $box = $i + 1;        
        $step = $rem % 10;

#        print "bc is $barcode_file i is $i; rem is $rem; side is $side; stack is $stack step is $step\n";


# guides x are 0, 70, 140

        $delta_x = 70;
        $left_x = -1;
        $mid_x = $left_x + $delta_x; 
        $rt_x = $left_x + 2*$delta_x;

#        $y = 255 - 25.5 * $step;      
        $y = 250 - 25.5 * $step;      


        if ( ( $rem eq 0 ) && ( $i eq 0 ) ) {
                &begin_picture($filehandle);
                &print_stack($filehandle,$side,$stack);
#                &print_seed_packet_guide_boxes($filehandle);
                &print_sleeve_label_aux($filehandle,$left_x,$y,$barcode_file,$sleeve);
                }


        elsif ( ( $rem eq 0 ) && ( $i ne 0 ) ) {
                print $filehandle "\\newpage\n";
                &begin_picture($filehandle);
                &print_stack($filehandle,$side,$stack);
 #               &print_seed_packet_guide_boxes($filehandle);
                &print_sleeve_label_aux($filehandle,$left_x,$y,$barcode_file,$sleeve);
                }



        elsif ( $rem > 0 ) { 

                if ( ( $rem eq 10 ) || ( $rem eq 20 ) ) { &print_stack($filehandle,$side,$stack); }

# left side

                if ( $side eq 0 ) {
                        &print_sleeve_label_aux($filehandle,$left_x,$y,$barcode_file,$sleeve);
                        }


# middle

                elsif ( $side eq 1 ) {
                        &print_sleeve_label_aux($filehandle,$mid_x,$y,$barcode_file,$sleeve);
		        }



# right side

                elsif ( $side eq 2 ) {
                        &print_sleeve_label_aux($filehandle,$rt_x,$y,$barcode_file,$sleeve);
		        }


# finish the page

                if ( ( $rem eq 29 ) || ( $i eq $#labels ) ) { &end_picture($filehandle); }

	        }
        }








sub print_sleeve_label_aux {
        ($filehandle,$x,$y,$barcode_file,$sleeve) = @_;

        $label_x = $x + 3;
        $label_y = $y + 2;

        $sl_x = $x + 8;
        $sl_y = $y - 6;

        print $filehandle "\\put($sl_x,$sl_y){\\scalebox{0.8}{\\includegraphics{$barcode_file}}}\n";
        }                             













### for boxes

# each record is two labels:  a fixed left label and a varying right label
#
# thus, the movement pattern is different:  we print the left and right labels
# for each record, then move down the page


sub print_box_label {

        ($filehandle,$barcode_out,$box,$crop,$comment,$i,$#labels) = @_;

        $barcode_file = $barcode_rel_dir . $barcode_out;

        $pruned_box = &prune_box($box);


        $rem = $i % 10;
        $stack = int($i / 10);
        $side = $stack % 2;
        $step = $rem % 10;

#        print "bc is $barcode_file i is $i; rem is $rem; side is $side; stack is $stack step is $step total is $#labels\n";


# guides x are 0, 106

        $delta_x = 106;
        $left_x = -1;
        $rt_x = $left_x + $delta_x;

        $y = 250 - 25.5 * $step;  
        $rt_y = $y;    


        if ( ( $rem eq 0 ) && ( $i eq 0 ) ) {
                &begin_picture($filehandle);
                &print_stack($filehandle,$side,$stack);
                &print_little_label_guide_boxes($filehandle);
                &print_box_label_left($filehandle,$left_x,$y,$crop,$pruned_box);
                &print_box_label_aux($filehandle,$rt_x,$rt_y,$barcode_file,$comment);
                }


        elsif ( ( $rem eq 0 ) && ( $i ne 0 ) ) {
                print $filehandle "\\newpage\n";
                &begin_picture($filehandle);
                &print_stack($filehandle,$side,$stack);
                &print_little_label_guide_boxes($filehandle);
                &print_box_label_left($filehandle,$left_x,$y,$crop,$pruned_box);
                &print_box_label_aux($filehandle,$rt_x,$rt_y,$barcode_file,$comment);
                }



        elsif ( $rem > 0 ) { 

                if ( $rem eq 10 ) { &print_stack($filehandle,$side,$stack); }

                &print_box_label_left($filehandle,$left_x,$y,$crop,$pruned_box);
                &print_box_label_aux($filehandle,$rt_x,$y,$barcode_file,$comment);
	        }

# finish the page

        if ( ( $rem eq 9 ) || ( $i eq $#labels ) ) { &end_picture($filehandle); }

        }








sub print_box_label_left { 
        ($filehandle,$x,$y,$crop,$pruned_box) = @_;

        $name_x = $x + 1;
        $name_y = $y + 2;

        $crop_x = $x + 60;
        $crop_y = $y + 6.8;


        print $filehandle "\\put($name_x,$name_y){\\scalebox{1.8}{\\Huge{\\textbf{KAZIC}}}} \\\\
                   \\put($crop_x,$crop_y){\\begin{tabular}{p{35mm}} \\\\
                                          \\hfill \\scalebox{1.2}{\\Huge{\\textbf{$crop}}} \\\\
                                          \\hfill  \\rule{0mm}{9mm} \\scalebox{1.2}{\\Huge{\\textbf{$pruned_box}}}
                                          \\end{tabular}}\n";
        }









# still need to adjust font and placement of comment; this awaits a more
# accurate box hash
#
# Kazic, 26.9.07

sub print_box_label_aux {
        ($filehandle,$x,$y,$barcode_file,$comment) = @_;

        $comment_x = $x + 3;
        $comment_y = $y + 7;

        $bc_x = $x + 51;
        $bc_y = $y - 3;

        print $filehandle "\\put($comment_x,$comment_y){\\Large{$comment}} \\\\
                   \\put($bc_x,$bc_y){\\scalebox{0.75}{\\includegraphics{$barcode_file}}}\n";

        }                             




































####### for make_missing_tags

# this has corrected y relative to print_seed_packet_label

sub print_tear_off_tag {

        ($filehandle,$barcode_out,$ma_num_gtype,$i,$#labels) = @_;
        $barcode_file = $barcode_rel_dir . $barcode_out;


        $rem = $i % 30;
        $stack = int($i / 10);
        $side = $stack % 3;
        $box = $i + 1;        
        $step = $rem % 10;

#        print "bc is $barcode_file i is $i; rem is $rem; side is $side; stack is $stack step is $step\n";


# guides x are 0, 70, 140

        $delta_x = 70;
        $left_x = -1;
        $mid_x = $left_x + $delta_x; 
        $rt_x = $left_x + 2*$delta_x;

#        $y = 255 - 25.5 * $step;      
        $y = 250 - 25.5 * $step;      


        if ( ( $rem eq 0 ) && ( $i eq 0 ) ) {
                &begin_picture($filehandle);
                &print_stack($filehandle,$side,$stack);
#                &print_seed_packet_guide_boxes($filehandle);
                &print_tear_off_tag_aux($filehandle,$left_x,$y,$barcode_file,$ma_num_gtype);
                }


        elsif ( ( $rem eq 0 ) && ( $i ne 0 ) ) {
                print $filehandle "\\newpage\n";
                &begin_picture($filehandle);
                &print_stack($filehandle,$side,$stack);
#                &print_seed_packet_guide_boxes($filehandle);
                &print_tear_off_tag_aux($filehandle,$left_x,$y,$barcode_file,$ma_num_gtype);
                }



        elsif ( $rem > 0 ) { 

                if ( ( $rem eq 10 ) || ( $rem eq 20 ) ) { &print_stack($filehandle,$side,$stack); }

# left side

                if ( $side eq 0 ) {
                        &print_tear_off_tag_aux($filehandle,$left_x,$y,$barcode_file,$ma_num_gtype);
                        }


# middle

                elsif ( $side eq 1 ) {
                        &print_tear_off_tag_aux($filehandle,$mid_x,$y,$barcode_file,$ma_num_gtype);
		        }



# right side

                elsif ( $side eq 2 ) {
                        &print_tear_off_tag_aux($filehandle,$rt_x,$y,$barcode_file,$ma_num_gtype);
		        }


# finish the page

                if ( ( $rem eq 29 ) || ( $i eq $#labels ) ) { &end_picture($filehandle); }

	        }
        }








sub print_tear_off_tag_aux {
        ($x,$y,$barcode_file,$ma_num_gtype) = @_;

        $ma_x = $x + 16;
        $ma_y = $y + 14;

        $sl_x = $x + 8;
        $sl_y = $y - 6;

        print $filehandle "\\put($ma_x,$ma_y){$ma_num_gtype}
                   \\put($sl_x,$sl_y){\\scalebox{0.8}{\\includegraphics{$barcode_file}}}\n";
        }                             












1;

