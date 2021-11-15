# this is ../c/maize/label_making/Typesetting/TypesetGenetics.pm



package TypesetGenetics;

use DefaultOrgztn;
use TypesettingMisc;
use Guides;
use Utilities;
use GenerateOutput;




use Exporter;

our @ISA = qw(Exporter);
our @EXPORT = qw(
             clean_gtypes
             get_family_prefix
             print_accession_packet_label
             print_box_label
             print_counting_insert
             print_field_plant_tag
             print_harvest_tag
             print_horizontal_row_stake_label
             print_hydro_labels
             print_inbred_seed_bag_label
             print_leaf_photo_tags
             print_leaf_tag_label
             print_new_seed_labels
             print_plan_label
             print_plant_tags
             print_pot_label
             print_row_label
             print_row_num_label
             print_sample_tag                        
             print_seed_packet_label
             print_sleeve_label
             print_tear_off_tag
             print_vertical_row_stake_label
             );




# Throughout, the following variables are used:
#
#        $rem:  N/l, where N is the number of items printed and l is the 
#               number of labels on the Avery sheet or cardstock
#               l varies from 8 to 30
#
#        $side: which column of labels or tags on the sheet
#               varies from 0 to 2 (left, middle, right)
#
#        $stack: the number of the column of labels, numbered across all columns
#                on all output sheets
#                varies from 0 to N/c, where c is the number of labels per 
#                column
#
#        $step: the number of the row of labels on the sheet
#               varies from 0 to $rem/r, where r is the number of rows on the 
#               sheet
#
#
# The movement pattern of the layout varies by the intended use of the tag or 
# label.  If we plan to use sheets of labels in the field, the layout is always
# left -> down to the bottom of the page, then up to the right.  This gives 
# numbered stacks of consecutive labels to fit in an apron pocket.
#
#
# There are many opportunities for further refactoring and modularization
# of these subroutines.
#
# Kazic, 14.11.07





#### for inventory management

########################## new version for boxes #########################

# on a ~2 x 11 inch strip that will be laminated, want something like
#
# Kazic          crop              first ma -- last ma or note
# box #          crop              v00000 -- v00000
#
# where crop is really two lines high.  Printed on 8.5 x 11 inch paper, 1.7 inches wide,
# 5 labels/sheet.


# A different layout strategy here:  we're printing each page as a
# centered tabular of three columns, rotated into landscape mode.
# Five labels are on each page, each label is a block of two tabular lines. 
# Two lines are added at the beginning and end of each block to adjust the 
# spacing between labels so that the five labels fit properly on the page.
# The LaTeX array package's \centering mechanism is exploited to center the
# text within fixed-width columns.
#
# You must manually adjust the spacing to suit your record-keeping.  A sample
# LaTeX file, ../latex/box_label_test.tex, is provided to help you do that.



sub print_box_label {

        ($filehandle,$i,$num_labels,$labels) = @_;

#	print "sub $labels\n";
	my ($box,$crop,$sleeves,$rps) = split(/::/,$labels);

#	print "sub ($box,$crop,$sleeves,$rps)\n";
	


        $rem = $i % 5;


        if ( $rem == 0 )  {
                if ( $num_labels != 0 ) { print $filehandle "\\newpage\n"; }
                &begin_tabular($filehandle);
                &print_block($filehandle,$box,$crop,$sleeves,$rps);
                }


        elsif ( ( $rem > 0 ) && ($rem < 5 ) ) { &print_block($filehandle,$box,$crop,$sleeves,$rps); }


# finish the page

        if ( ( $rem == 4 ) || ( $i == $num_labels ) ) { &end_tabular($filehandle); }
        }




sub begin_tabular {
	($filehandle) = @_;

        print $filehandle "\\begin{center}\n
\\begin{tabular}{>{\\centering\\arraybackslash}p{2.85in} >{\\centering\\arraybackslash}p{2.5in} >{\\centering\\arraybackslash}p{5in}}\n";
        }







sub end_tabular { 
	($filehandle) = @_;

        print $filehandle "\\end{tabular}\n\\end{center}\n\n\n";
        }






sub print_block {
        ($filehandle,$box,$crop,$sleeves,$rps) = @_;

	print $filehandle "%
  \\rule{0mm}{4.97mm} & & \\\\
  \\scalebox{3.5}{\\textsc{KAZIC}}
  & \\multirow{2}{*}{\\scalebox{3.5}{\\textbf{$crop}}}
  & \\scalebox{2.9}{$rps} \\\\
  \\rule{0mm}{17mm} \\scalebox{4.5}{$box}
  & & \\scalebox{2.85}{$sleeves} \\\\
  \\rule{0mm}{4.97mm} & & \\\\ \\hline \n";
         }






######## old versions for box labels ##################

# each record is two labels:  a fixed left label and a varying right label
#
# thus, the movement pattern is different:  we print the left and right labels
# for each record, then move down the page


sub old_print_box_label {

        ($filehandle,$barcode_out,$box,$crop,$comment,$i,$#labels) = @_;

        $barcode_file = $barcode_rel_dir . $barcode_out;

        $pruned_box = &prune_box($box);

        $rem = $i % 10;
        $stack = int($i / 10);
        $side = $stack % 2;
        $step = $rem % 10;


# guides x are 0, 106

        $delta_x = 106;
        $left_x = -1;
        $rt_x = $left_x + $delta_x;

        $y = 250 - 25.5 * $step;  
        $rt_y = $y;    


        if ( $rem == 0 )  {
                if ( $i != 0 ) { print $filehandle "\\newpage\n"; }

                &begin_picture($filehandle);
                &print_stack($filehandle,$side,$stack);
#                &print_little_label_guide_boxes($filehandle);
                &print_box_label_left($filehandle,$left_x,$y,$crop,$pruned_box);
                &print_box_label_right($filehandle,$rt_x,$rt_y,$barcode_file,$comment);
                }


        elsif ( $rem > 0 ) { 

                if ( $rem == 10 ) { &print_stack($filehandle,$side,$stack); }

                &print_box_label_left($filehandle,$left_x,$y,$crop,$pruned_box);
                &print_box_label_right($filehandle,$rt_x,$y,$barcode_file,$comment);
	        }

# finish the page

        if ( ( $rem == 9 ) || ( $i == $#labels ) ) { &end_picture($filehandle); }
        }







sub old_print_box_label_left { 
        ($filehandle,$x,$y,$crop,$pruned_box) = @_;

        $name_x = $x + 1;
        $name_y = $y + 2;

        $crop_x = $x + 60;
        $crop_y = $y + 6.8;


        print $filehandle "\\put($name_x,$name_y){\\scalebox{1.8}{\\Huge{\\textbf{$surname}}}} \\\\
                   \\put($crop_x,$crop_y){\\begin{tabular}{p{35mm}} \\\\
                                          \\hfill \\scalebox{1.2}{\\Huge{\\textbf{$crop}}} \\\\
                                          \\hfill  \\rule{0mm}{9mm} \\scalebox{1.2}{\\Huge{\\textbf{$pruned_box}}}
                                          \\end{tabular}}\n";
        }










sub old_print_box_label_right {
        ($filehandle,$x,$y,$barcode_file,$comment) = @_;

        $new = "";
        $sleeve = "";

        $comment_x = $x;
        $comment_y = $y + 9;

        $sleeve_x = $comment_x + 1;
        $sleeve_y = $y - 1;

        $bc_x = $x + 51;
        $bc_y = $y - 3;

        my $i;

        @comment_lines = split(/;;/,$comment);

        for ( $i = 0 ; $i <= $#comment_lines ; $i++) {
                if ( $i == $#comment_lines ) { $sleeve = "\\large{" . $comment_lines[$i] . "}"; } 
                elsif ( $i == $#comment_lines - 1 ) { $new .= "\\Large{" . $comment_lines[$i] . "}"; } 
                else { $new .= "\\Large{" . $comment_lines[$i] . "} \\\\ "; }
	        }

        print $filehandle "\\put($comment_x,$comment_y){\\begin{tabular}{l}$new\\end{tabular}}
                   \\put($sleeve_x,$sleeve_y){\\emph{$sleeve}}
                   \\put($bc_x,$bc_y){\\scalebox{0.75}{\\includegraphics{$barcode_file}}}\n";
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


# guides x are 0, 70, 140

        $delta_x = 70;
        $left_x = -1;
        $mid_x = $left_x + $delta_x; 
        $rt_x = $left_x + 2*$delta_x;

        $y = 250 - 25.5 * $step;      


        if ( $rem == 0 ) {
                if ( $i != 0 ) { print $filehandle "\\newpage\n"; }
                &begin_picture($filehandle);
                &print_stack($filehandle,$side,$stack);
#                &print_seed_packet_guide_boxes($filehandle);
                &print_sleeve_label_aux($filehandle,$left_x,$y,$barcode_file,$sleeve);
                }



        elsif ( $rem > 0 ) { 

                if ( ( $rem == 10 ) || ( $rem == 20 ) ) { &print_stack($filehandle,$side,$stack); }

# left side

                if ( $side == 0 ) {
                        &print_sleeve_label_aux($filehandle,$left_x,$y,$barcode_file,$sleeve);
                        }


# middle

                elsif ( $side == 1 ) {
                        &print_sleeve_label_aux($filehandle,$mid_x,$y,$barcode_file,$sleeve);
		        }


# right side

                elsif ( $side == 2 ) {
                        &print_sleeve_label_aux($filehandle,$rt_x,$y,$barcode_file,$sleeve);
		        }


# finish the page

                if ( ( $rem == 29 ) || ( $i == $#labels ) ) { &end_picture($filehandle); }

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







sub print_pot_label {

        ($filehandle,$barcode_out,$pot,$i,$#labels) = @_;
        $barcode_file = $barcode_rel_dir . $barcode_out;



        $rem = $i % 30;
        $stack = int($i / 10);
        $side = $stack % 3;
        $box = $i + 1;        
        $step = $rem % 10;


# guides x are 0, 70, 140

        $delta_x = 70;
        $left_x = -1;
        $mid_x = $left_x + $delta_x; 
        $rt_x = $left_x + 2*$delta_x;

        $y = 250 - 25.5 * $step;      



        if ( $rem == 0 ) {
                if ( $i != 0 ) { print $filehandle "\\newpage\n"; }
                &begin_picture($filehandle);
                &print_stack($filehandle,$side,$stack);
#                &print_seed_packet_guide_boxes($filehandle);
                &print_pot_label_aux($filehandle,$left_x,$y,$barcode_file,$pot);
                }



        elsif ( $rem > 0 ) { 

                if ( ( $rem == 10 ) || ( $rem == 20 ) ) { &print_stack($filehandle,$side,$stack); }

# left side

                if ( $side == 0 ) {
                        &print_pot_label_aux($filehandle,$left_x,$y,$barcode_file,$pot);
                        }


# middle

                elsif ( $side == 1 ) {
                        &print_pot_label_aux($filehandle,$mid_x,$y,$barcode_file,$pot);
		        }


# right side

                elsif ( $side == 2 ) {
                        &print_pot_label_aux($filehandle,$rt_x,$y,$barcode_file,$pot);
		        }


# finish the page

                if ( ( $rem == 29 ) || ( $i == $#labels ) ) { &end_picture($filehandle); }

	        }
        }








sub print_pot_label_aux {
        ($filehandle,$x,$y,$barcode_file,$pot) = @_;

        $label_x = $x + 2; # was 3
        $label_y = $y + 5; # was +2
        $sl_x = $x + 16; # was 8
        $sl_y = $y - 6; 
        $pot_x = $x + 25;
        $pot_y = $y + 17.8;



        print $filehandle "\\put($label_x,$label_y){\\scalebox{0.75}{\\begin{tabular}{c}
                           \\textbf{\\Large{K}} \\\\
                           \\textbf{\\Large{A}} \\\\
                           \\textbf{\\Large{Z}} \\\\
                           \\textbf{\\Large{I}} \\\\
                           \\textbf{\\Large{C}} 
                           \\end{tabular}}}\n";       
        print $filehandle "\\put($sl_x,$sl_y){\\scalebox{0.75}{\\includegraphics{$barcode_file}}}\n";
        print $filehandle "\\put($pot_x,$pot_y){\\scalebox{1.75}{\\rotatebox{-180}{\\textbf{$pot}}}}\n";
        }                             














######## for make_row_stake_label, but with horizontal layout for new wire stakes

# I am cutting these from paper stock, so layout and guides are unusual; in general
# these will be smaller than a business card.
#
# Kazic, 23.3.10

# 4 down, 5 across

sub print_horizontal_row_stake_label {

        ($filehandle,$barcode_out,$row_num,$i,$num_rows) = @_;

#        $barcode_file = $barcode_rel_dir . $barcode_out;

        $rem = $i % 20;
        $stack = int($i / 4);
        $column = $stack % 5;
        $step = $rem % 4;


# guides x are 0, 40, 80, 120, 160
# guides y are 224, 166, 108, 50

        $delta_x = 40;
        $left_x = 0;
        $next_x = $left_x + $column * $delta_x;

        $y = 224 - 58 * $step;      


#	print "rem: $rem stack: $stack col: $column step: $step next_x: $next_x y: $y\n";


        if ( $rem == 0 )  {

                if ( $i != 0 ) { print $filehandle "\\newpage\n"; }
                &begin_row_stake_picture($filehandle);
                &print_horizontal_row_stake_cutting_lines($filehandle);
	        }


# any "side" --- that is, a column

               &print_horizontal_row_stake_label_aux($filehandle,$next_x,$y,$row_num,$barcode_out);



# finish the page

        if ( ( $rem == 19 ) || ( $i == $num_rows - 1 ) ) { &end_picture($filehandle); }
        }











# down the column; if length of row string is 3, add 7 to y coordinate of
# lower bounding rule
#
# row number x is vertical rule + 2
# row number y is horizontal rule + string length finagle
#
# barcode x is row number x + 19
# barcode y is always horizontal rule + 6


sub print_horizontal_row_stake_label_aux { 
        ($filehandle,$x,$y,$row_num,$barcode_out) = @_;


# measure string length of $row_num and adjust offsets to center
# the number nicely

        $row_num_len = length($row_num);
        $finagle = (4- $row_num_len) * 7;

        $row_x = $x + 2; 
        $row_y = $y + $finagle;  

        $barcode_x = $row_x + 19;
        $barcode_y = $y + 6;

	&print_horizontal_row_stake_label_aux_aux($filehandle,$barcode_x,$barcode_y,$barcode_out,$row_x,$row_y,$row_num);
        }









sub print_horizontal_row_stake_label_aux_aux {

        my ($filehandle,$barcode_x,$barcode_y,$barcode_file,$row_x,$row_y,$row) = @_;


        print $filehandle "\\put($row_x,$row_y){\\rotatebox{90}{\\scalebox{7}{$row}}}\n";

	print $filehandle "\\put($barcode_x,$barcode_y){\\rotatebox{90}{\\scalebox{0.75}{\\includegraphics{$barcode_file}}}}\n";
        }














######## for make_vertical_row_stake_label

# decided to use the Avery 1 x 2 5/8 inch label, so now the movement goes in the usual way.
# Placement is a little unusual; we want the information at the edge of the label to 
# simplify cutting.
#
# Kazic, 29.4.08



sub print_old_vertical_row_stake_label {

        ($filehandle,$barcode_out_upper,$row_upper,$i,$num_rows) = @_;

        $barcode_file = $barcode_rel_dir . $barcode_out;


        $rem = $i % 30;
        $stack = int($i / 10);
        $side = $stack % 3;
        $step = $rem % 10;


# guides x are 0, 70, 140

        $delta_x = 70;
        $left_x = -13;
        $mid_x = $left_x + $delta_x; 
        $rt_x = $left_x + 2*$delta_x;

        $y = 250 - 25.5 * $step;      

        if ( $rem == 0 )  {

                if ( $i != 0 ) { print $filehandle "\\newpage\n"; }

                &begin_picture($filehandle);
                &print_stack($filehandle,$side,$stack);
#                &print_seed_packet_guide_boxes($filehandle);
                &print_old_vertical_row_stake_label_aux($filehandle,$left_x,$y,$barcode_out_upper,$row_upper);
	        }



# what's the right condition for the 31st label? $rem is 1, $i = $num_rows

        elsif ( $rem > 0 ) { 

                if ( ( $rem == 10 ) || ( $rem == 20 ) ) { &print_stack($filehandle,$side,$stack); }

# left side

                if ( $side == 0 ) {
                        &print_old_vertical_row_stake_label_aux($filehandle,$left_x,$y,$barcode_out_upper,$row_upper);
                        }


# middle

                elsif ( $side == 1 ) {
                        &print_old_vertical_row_stake_label_aux($filehandle,$mid_x,$y,$barcode_out_upper,$row_upper);
		        }


# right side

                elsif ( $side == 2 ) {
                        &print_old_vertical_row_stake_label_aux($filehandle,$rt_x,$y,$barcode_out_upper,$row_upper);
		        }

	        }
# finish the page

        if ( ( $rem == 29 ) || ( $i == $num_rows - 1 ) ) { &end_picture($filehandle); }
        }










sub print_old_vertical_row_stake_label_aux { 
        ($filehandle,$x,$y,$barcode_out_upper,$row_upper) = @_;

        $row_x = $x + 14; 
        $row_y = $y + 1;  

        $barcode_x = $x + 30;
        $barcode_y = $y + 0;

	&print_old_vertical_row_stake_label_aux_aux($filehandle,$barcode_x,$barcode_y,$barcode_out_upper,$row_x,$row_y,$row_upper);
        }








# include the line for cutting the excess label right on it!

sub print_old_vertical_row_stake_label_aux_aux {

        my ($filehandle,$barcode_x,$barcode_y,$barcode_file,$row_x,$row_y,$row) = @_;

        $rule_y = $row_y - 1;

        if ( $row !~ /\d{4}/ ) { print $filehandle "\\put($row_x,$row_y){\\rotatebox{90}{\\scalebox{1.2}{\\Huge{\\textbf{$row}}}}}\n"; }
        else { print $filehandle "\\put($row_x,$row_y){\\rotatebox{90}{\\scalebox{0.9}{\\Huge{\\textbf{$row}}}}}\n"; }

	print $filehandle "\\put($barcode_x,$barcode_y){\\rotatebox{0}{\\scalebox{0.75}{\\includegraphics{$barcode_file}}}}\n";

	print $filehandle "\\put($row_x,$rule_y){\\rule{60mm}{0.1mm}}\n";

        }








########### rewrote to accommodate new plastic labels and layout
#
# shifted to 20-up for plastic sheets
#
# Kazic, 12.5.2014


# added crop marker (same for all pages) and material, 1 page/material
#
# Kazic, 15.5.2020

sub print_vertical_row_stake_label {

#        ($filehandle,$barcode_out_upper,$row_upper,$i,$num_rows) = @_;

        ($filehandle,$barcode_out_upper,$row_upper,$num_cutting,$material,$i,$num_rows) = @_;

#        print "($barcode_out_upper,$row_upper,$num_cutting,$material,$i,$num_rows)\n";



	
        $barcode_file = $barcode_rel_dir . $barcode_out;


        $rem = $i % 20;
        $stack = int($i / 10);
        $side = $stack % 2;
        $step = $rem % 10;


# guides x are 0, 105; setting the $left_x to 0 gives a nice margin on the 
# left edge for stapling

        $delta_x = 105;
        $left_x = 0;
        $right_x = $left_x + $delta_x; 

        $y = 250 - 25.5 * $step;      


        if ( $rem == 0 )  {

                if ( $i != 0 ) { print $filehandle "\\newpage\n"; }

                &begin_picture($filehandle);
                &print_stack($filehandle,$side,$stack);
#		&print_vertical_row_stake_label_guide_boxes($filehandle);
                &print_vertical_row_stake_label_aux($filehandle,$left_x,$y,$barcode_out_upper,$row_upper,$num_cutting,$material);
	        }



# what's the right condition for the 21st label? $rem is 1, $i = $num_rows

        elsif ( $rem > 0 ) { 

                if ( $rem == 10 ) { &print_stack($filehandle,$side,$stack); }

# left side

                if ( $side == 0 ) {
                        &print_vertical_row_stake_label_aux($filehandle,$left_x,$y,$barcode_out_upper,$row_upper,$num_cutting,$material);
                        }


# right side

                elsif ( $side == 1 ) {
                        &print_vertical_row_stake_label_aux($filehandle,$right_x,$y,$barcode_out_upper,$row_upper,$num_cutting,$material);
		        }

	        }
# finish the page

        if ( ( $rem == 19 ) || ( $i == $num_rows - 1 ) ) { &end_picture($filehandle); }
        }





# $row_* is the position of the row number and the start of the rules
# for three-digit row numbers, $row_y = $y + 3, $rule_y = $row_y - 4 is right.
# for four-digit row numbers, $row_y = $y + 1, $rule_y = $row_y - 1 is right at the same
# scaling as the three-digit numbers.
# this nicely centers everything.
#
# $barcode_* is the position of the barcode.  I have shited +5 in the x direction and
# +1 in the y.
#
# Kazic, 13.5.2014

sub print_vertical_row_stake_label_aux { 
        ($filehandle,$x,$y,$barcode_out_upper,$row_upper,$num_cutting,$material) = @_;

        $row_x = $x + 14; 
        $row_y = $y + 3;  

        $barcode_x = $x + 35;
        $barcode_y = $y + 1;

	&print_vertical_row_stake_label_aux_aux($filehandle,$barcode_x,$barcode_y,$barcode_out_upper,$row_x,$row_y,$row_upper,$num_cutting,$material);
        }








# include the line for cutting the excess label right on it!

sub print_vertical_row_stake_label_aux_aux {

        my ($filehandle,$barcode_x,$barcode_y,$barcode_file,$row_x,$row_y,$row,$num_cutting,$material) = @_;

        $rule_y = $row_y - 4;
        $guide_x = $row_x - 15;

        $num_cutting_x = $row_x + 75;	
	$num_cutting_y = $rule_y + 2;
	$material_y = $rule_y + 10;	


        if ( $row !~ /\d{4}/ ) { print $filehandle "\\put($row_x,$row_y){\\rotatebox{90}{\\scalebox{1.2}{\\Huge{\\textbf{$row}}}}}\n"; }
        else { print $filehandle "\\put($row_x,$row_y){\\rotatebox{90}{\\scalebox{0.9}{\\Huge{\\textbf{$row}}}}}\n"; }

	print $filehandle "\\put($barcode_x,$barcode_y){\\rotatebox{0}{\\scalebox{0.75}{\\includegraphics{$barcode_file}}}}\n";

	print $filehandle "\\put($row_x,$rule_y){\\rule{60mm}{0.1mm}}\n";
#	print $filehandle "\\put($guide_x,$rule_y){\\rule{0.1mm}{1in}}\n";

        print $filehandle "\\put($num_cutting_x,$num_cutting_y){\\rotatebox{90}{\\scalebox{0.75}{\\large{\\textbf{$num_cutting}}}}}\n";
        print $filehandle "\\put($num_cutting_x,$material_y){\\rotatebox{90}{\\scalebox{0.75}{\\large{\\textbf{$material}}}}}\n";	
        }



























####### for make_leaf_tags



sub print_leaf_tag_label {

        ($filehandle,$barcode_out,$row,$pplant,$i,$#labels) = @_;
        $barcode_file = $barcode_rel_dir . $barcode_out;


        $rem = $i % 30;
        $stack = int($i / 10);
        $side = $stack % 3;
        $step = $rem % 10;


# guides x are 0, 70, 140

        $delta_x = 70;
        $left_x = -2;
        $mid_x = $left_x + $delta_x; 
        $rt_x = $left_x + 2*$delta_x;

        $y = 253 - 25.3 * $step;      


        if ( ( $rem == 0 ) && ( $i == 0 ) ) {
                &begin_picture($filehandle);
                &print_stack($filehandle,$side,$stack);
                &print_seed_packet_guide_boxes($filehandle);
                &print_leaf_tag_label_aux($filehandle,$left_x,$y,$barcode_file,$row,$pplant);
                }


        elsif ( ( $rem == 0 ) && ( $i != 0 ) ) {
                print $filehandle "\\newpage\n";
                &begin_picture($filehandle);
                &print_stack($filehandle,$side,$stack);
                &print_seed_packet_guide_boxes($filehandle);
                &print_leaf_tag_label_aux($filehandle,$left_x,$y,$barcode_file,$row,$pplant);
                }


        elsif ( $rem > 0 ) { 

                if ( ( $rem == 10 ) || ( $rem == 20 ) ) { &print_stack($filehandle,$side,$stack); }

# left side

                if ( $side == 0 ) {
                        &print_leaf_tag_label_aux($filehandle,$left_x,$y,$barcode_file,$row,$pplant);
                        }


# middle

                elsif ( $side == 1 ) {
                        &print_leaf_tag_label_aux($filehandle,$mid_x,$y,$barcode_file,$row,$pplant);
		        }


# right side

                elsif ( $side == 2 ) {
                        &print_leaf_tag_label_aux($filehandle,$rt_x,$y,$barcode_file,$row,$pplant);
		        }


# finish the page

                if ( ( $rem == 29 ) || ( $i == $#labels ) ) { &end_picture($filehandle); }
	        }
        }








sub print_leaf_tag_label_aux {
        ($filehandle,$x,$y,$barcode_file,$row,$pplant) = @_;

        $ma_x = $x + 5;
        $ma_y = $y - 6;
        $packet_x = $x + 40;
        $packet_y = $y - 4.5;


# need to diminish intercolumn padding to make a slightly larger table;
# barcode was 0.5. 0.55 is the limit without this diminution.

# for the 07g experiments, start the table at leaf 7
#
# Kazic, 6.11.07

        print $filehandle "\\put($x,$y){\\scalebox{0.63}{\\includegraphics{$barcode_file}}}
                   \\put($ma_x,$ma_y){\\scalebox{1.3}{\\textbf{$row} \\hspace{0.4cm} \\textbf{$pplant}}}\n";
#
#                   \\put($packet_x,$packet_y){\\setlength{\\tabcolsep}{0.5mm}\\renewcommand{\\arraystretch}{0.85}\\begin{tabular}{|l|p{7mm}|l|p{7mm}|} \\hline
#                   13 & \\rule{7mm}{0mm} & 16 &  \\rule{7mm}{0mm} \\\\ \\hline
#                   14 & & 17 &  \\\\ \\hline
#                   15 & & 18 &  \\\\ \\hline  \\end{tabular}}\n";
        }                             








# for make_hydro_plant_labels

sub print_hydro_labels {

        ($filehandle,$barcode_file,$pre_row,$pplant,$family,$ma_num_gtype,$pa_family,$pa_num_gtype,$pma_ma_gma_gtype,$pma_ma_gpa_gtype,$pma_pa_gma_gtype,$pma_pa_mutant,$ppa_ma_gma_gtype,$ppa_ma_gpa_gtype,$ppa_pa_gma_gtype,$ppa_pa_mutant,$quasi_allele,$i,$#labels) = @_;


        $rem = $i % 30;
        $stack = int($i / 10);
        $side = $stack % 3;
        $step = $rem % 10;


# guides x are 0, 70, 140

        $delta_x = 70;
        $left_x = -2;
        $mid_x = $left_x + $delta_x; 
        $rt_x = $left_x + 2*$delta_x;

        $y = 253 - 25.3 * $step;      


        if ( ( $rem == 0 ) && ( $i == 0 ) ) {
                &begin_picture($filehandle);
                &print_stack($filehandle,$side,$stack);
#                &print_seed_packet_guide_boxes($filehandle);
                &print_hydro_label_aux($filehandle,$left_x,$y,$pma_ma_gma_gtype,$pma_ma_gpa_gtype,$pma_pa_gma_gtype,$pma_pa_mutant,$ppa_ma_gma_gtype,$ppa_ma_gpa_gtype,$ppa_pa_gma_gtype,$ppa_pa_mutant,$family,$pre_row,$plant,$quasi_allele,$barcode_file);
                }


        elsif ( ( $rem == 0 ) && ( $i != 0 ) ) {
                print $filehandle "\\newpage\n";
                &begin_picture($filehandle);
                &print_stack($filehandle,$side,$stack);
#                &print_seed_packet_guide_boxes($filehandle);
                &print_hydro_label_aux($filehandle,$left_x,$y,$pma_ma_gma_gtype,$pma_ma_gpa_gtype,$pma_pa_gma_gtype,$pma_pa_mutant,$ppa_ma_gma_gtype,$ppa_ma_gpa_gtype,$ppa_pa_gma_gtype,$ppa_pa_mutant,$family,$pre_row,$plant,$quasi_allele,$barcode_file);
                }


        elsif ( $rem > 0 ) { 

                if ( ( $rem == 10 ) || ( $rem == 20 ) ) { &print_stack($filehandle,$side,$stack); }

# left side

                if ( $side == 0 ) {
                        &print_hydro_label_aux($filehandle,$left_x,$y,$pma_ma_gma_gtype,$pma_ma_gpa_gtype,$pma_pa_gma_gtype,$pma_pa_mutant,$ppa_ma_gma_gtype,$ppa_ma_gpa_gtype,$ppa_pa_gma_gtype,$ppa_pa_mutant,$family,$pre_row,$plant,$quasi_allele,$barcode_file);
                        }


# middle

                elsif ( $side == 1 ) {
                        &print_hydro_label_aux($filehandle,$mid_x,$y,$pma_ma_gma_gtype,$pma_ma_gpa_gtype,$pma_pa_gma_gtype,$pma_pa_mutant,$ppa_ma_gma_gtype,$ppa_ma_gpa_gtype,$ppa_pa_gma_gtype,$ppa_pa_mutant,$family,$pre_row,$plant,$quasi_allele,$barcode_file);
		        }


# right side

                elsif ( $side == 2 ) {
                        &print_hydro_label_aux($filehandle,$rt_x,$y,$pma_ma_gma_gtype,$pma_ma_gpa_gtype,$pma_pa_gma_gtype,$pma_pa_mutant,$ppa_ma_gma_gtype,$ppa_ma_gpa_gtype,$ppa_pa_gma_gtype,$ppa_pa_mutant,$family,$pre_row,$plant,$quasi_allele,$barcode_file);
		        }


# finish the page

                if ( ( $rem == 29 ) || ( $i == $#labels ) ) { &end_picture($filehandle); }
	        }
        }






sub print_hydro_label_aux {

        ($filehandle,$x,$y,$pma_ma_gma_gtype,$pma_ma_gpa_gtype,$pma_pa_gma_gtype,$pma_pa_mutant,$ppa_ma_gma_gtype,$ppa_ma_gpa_gtype,$ppa_pa_gma_gtype,$ppa_pa_mutant,$family,$pre_row,$plant,$quasi_allele,$barcode_file) = @_;

        ($ma_gtype) = &make_genotype($pma_ma_gma_gtype,$pma_ma_gpa_gtype,$pma_pa_gma_gtype,$pma_pa_mutant);
        ($pa_gtype) = &make_genotype($ppa_ma_gma_gtype,$ppa_ma_gpa_gtype,$ppa_pa_gma_gtype,$ppa_pa_mutant);

        &print_hydro_tag($filehandle,$x,$y,$ma_gtype,$pa_gtype,$family,$pre_row,$plant,$quasi_allele,$barcode_file);
        }








# modelled on print_cross_tag, just omit the rotations and adjust the coordinates

sub print_hydro_tag {
        ($filehandle,$x,$y,$ma_gtype,$pa_gtype,$family,$pre_row,$plant,$quasi_allele,$barcode_out) = @_;


        $cross_box_x = $x + 17;
        $cross_box_y = $y - 3;
        $data_x = $x + 9;
        $data_y = $y + 8;
        $gtype_x = $x + 5;
        $gtype_y = $y + 1;
       

# scale was 0.65

        print $filehandle "\\put($cross_box_x,$cross_box_y){\\begin{tabular}{c}
                     \\scalebox{0.7}{\\includegraphics{$barcode_out}}
                     \\end{tabular}}\n";


        print $filehandle "\\put($data_x,$data_y){\\begin{tabular}{c}
                     \\scalebox{1.3}{$quasi_allele \\textbf{$family: $pre_row $pplant}}
                     \\end{tabular}}\n";

        &scale_gtypes($filehandle,$gtype_x,$gtype_y,$ma_gtype,$pa_gtype,0);
        }












####### for make_missing_tags

# replace crummy daddy (or mommy, if needed) tags
# 
# these are printed out on card stock and then cut apart
#
# this has corrected y relative to print_seed_packet_label
#
# condition to finish the page is not correct if 31 tags needed?
#
# Kazic, 18.9.2010

sub print_tear_off_tag {

        ($filehandle,$barcode_out,$ma_num_gtype,$i,$#labels) = @_;
        $barcode_file = $barcode_rel_dir . $barcode_out;


        $rem = $i % 30;
        $stack = int($i / 10);
        $side = $stack % 3;
        $box = $i + 1;        
        $step = $rem % 10;


# guides x are 0, 70, 140

        $delta_x = 70;
        $left_x = -1;
        $mid_x = $left_x + $delta_x; 
        $rt_x = $left_x + 2*$delta_x;

#        $y = 250 - 25.5 * $step;      
#
# this raises the output relative to the label boundaries; check before
# printing
#
# Kazic, 17.7.2013

        $y = 255 - 25.5 * $step;      


        if ( $rem == 0 ) {

                if ( $i != 0 ) { print $filehandle "\\newpage\n"; }

                &begin_picture($filehandle);
                &print_stack($filehandle,$side,$stack);
#                &print_seed_packet_guide_boxes($filehandle);
                &print_tear_off_tag_aux($filehandle,$left_x,$y,$barcode_file,$ma_num_gtype);
                }


        elsif ( $rem > 0 ) { 

                if ( ( $rem == 10 ) || ( $rem == 20 ) ) { &print_stack($filehandle,$side,$stack); }

# left side

                if ( $side == 0 ) {
                        &print_tear_off_tag_aux($filehandle,$left_x,$y,$barcode_file,$ma_num_gtype);
                        }


# middle

                elsif ( $side == 1 ) {
                        &print_tear_off_tag_aux($filehandle,$mid_x,$y,$barcode_file,$ma_num_gtype);
		        }


# right side

                elsif ( $side == 2 ) {
                        &print_tear_off_tag_aux($filehandle,$rt_x,$y,$barcode_file,$ma_num_gtype);
		        }


# finish the page

                if ( ( $rem == 29 ) || ( $i == $#labels ) ) { &end_picture($filehandle); }
	        }
        }








sub print_tear_off_tag_aux {
        ($filehandle,$x,$y,$barcode_file,$ma_num_gtype) = @_;

#        $ma_x = $x + 16;
        $ma_x = $x + 12;
        $ma_y = $y + 14;
        $sl_x = $x + 8;
        $sl_y = $y - 6;

        print $filehandle "\\put($ma_x,$ma_y){\\large{\\textbf{$ma_num_gtype}}}
                   \\put($sl_x,$sl_y){\\scalebox{0.8}{\\includegraphics{$barcode_file}}}\n";
        }                             








# for printing the tags that mark relative leaf numbers in photograph; variant would work for absolute 
# leaf numbers.  Actually printed on cardstock but labels are the same dimensions as the tear-off tags.
#
# Kazic, 17.8.09


# replace crummy daddy (or mommy, if needed) tags
# 
# these are printed out on card stock and then cut apart
#
# this has corrected y relative to print_seed_packet_label

sub print_leaf_photo_tags {

        ($filehandle,$radix,$sign,$subscript,$i,$#labels) = @_;



        $rem = $i % 30;
        $stack = int($i / 10);
        $side = $stack % 3;
        $box = $i + 1;        
        $step = $rem % 10;


# guides x are 0, 70, 140

        $delta_x = 70;
        $left_x = -1;
        $mid_x = $left_x + $delta_x; 
        $rt_x = $left_x + 2*$delta_x;

        $y = 250 - 25.5 * $step;      


        if ( $rem == 0 ) {

                if ( $i != 0 ) { print $filehandle "\\newpage\n"; }

                &begin_picture($filehandle);
                &print_stack($filehandle,$side,$stack);
#                &print_seed_packet_guide_boxes($filehandle);
                &print_leaf_photo_tag_aux($filehandle,$left_x,$y,$radix,$sign,$subscript);
                }


        elsif ( $rem > 0 ) { 

                if ( ( $rem == 10 ) || ( $rem == 20 ) ) { &print_stack($filehandle,$side,$stack); }

# left side

                if ( $side == 0 ) {
                        &print_leaf_photo_tag_aux($filehandle,$left_x,$y,$radix,$sign,$subscript);
                        }


# middle

                elsif ( $side == 1 ) {
                        &print_leaf_photo_tag_aux($filehandle,$mid_x,$y,$radix,$sign,$subscript);
		        }


# right side

                elsif ( $side == 2 ) {
                        &print_leaf_photo_tag_aux($filehandle,$rt_x,$y,$radix,$sign,$subscript);
		        }


# finish the page

                if ( ( $rem == 29 ) || ( $i == $#labels ) ) { &end_picture($filehandle); }
	        }
        }








sub print_leaf_photo_tag_aux {
        ($filehandle,$x,$y,$radix,$sign,$subscript) = @_;


        $ma_x = $x + 25;
        $ma_y = $y + 3;

        if ( $sign =~ /\'\'/ ) { print $suffix = $subscript; }
        else { $suffix = $sign . $subscript; }

        print $filehandle "\\put($ma_x,$ma_y){\\scalebox{2}{\$ $radix\_{$suffix} \$}}\n";

        }                             




















####### for planting


# 1 x 2 5/8 inch 30-up labels, 10/column

# Warning!  guide boxes are off in both x and y, at least for 
# teosinte
#
# Kazic, 17.5.09
#
# corrected for gnomon; guide boxes are still off but labels are correct.
#
# Kazic, 28.5.2010


# modified to include row sequence number
#
# print a test page on gnomon
#
# Kazic, 24.4.2011


sub print_seed_packet_label {

        ($filehandle,$barcode_out,$family,$ma_num_gtype,$pa_num_gtype,$sleeve,$cl,$ft,$rowseqnum,$plntg,$i,$#labels) = @_;
        $barcode_file = $barcode_rel_dir . $barcode_out;
#	        $barcode_file = $barcode_out;

        $rem = $i % 30;
        $stack = int($i / 10);
        $side = $stack % 3;
        $box = $i + 1;        
        $step = $rem % 10;



# guides x are 0, 70, 140

        $delta_x = 70;
#
# gnomon
#
        $left_x = -1;
#
# additional terms are for teosinte: mid_x+1, rt_x+3
#
        $mid_x = $left_x + $delta_x; 
        $rt_x = $left_x + 2*$delta_x;
#
# maybe for calliope this works, but not teosinte
#
#        $y = 253.5 - 25.5 * $step;      
#
# teosinte
#
#
# Kazic, 17.5.09
#
#         $y = 263 - 26.5 * $step;      
#
# gnomon
#
        $y = 259.5 - 25.5 * $step;      




# for teosinte, regular paper, stack numbers should be moved upward by ~ 1 cm
#
# Kazic, 17.5.09

        if ( $rem == 0 ) {
                if ( $i != 0 ) { print $filehandle "\\newpage\n"; }

                &begin_picture($filehandle);
                &print_stack($filehandle,$side,$stack);
#                &print_seed_packet_guide_boxes($filehandle);
                &print_seed_packet_label_aux($filehandle,$left_x,$y,$barcode_file,$family,$ma_num_gtype,$pa_num_gtype,$sleeve,$cl,$ft,$rowseqnum,$plntg);
                }


        elsif ( $rem > 0 ) { 

                if ( ( $rem == 10 ) || ( $rem == 20 ) ) { &print_stack($filehandle,$side,$stack); }

# left side

                if ( $side == 0 ) {
                        &print_seed_packet_label_aux($filehandle,$left_x,$y,$barcode_file,$family,$ma_num_gtype,$pa_num_gtype,$sleeve,$cl,$ft,$rowseqnum,$plntg);
                        }


# middle

                elsif ( $side == 1 ) {
                        &print_seed_packet_label_aux($filehandle,$mid_x,$y,$barcode_file,$family,$ma_num_gtype,$pa_num_gtype,$sleeve,$cl,$ft,$rowseqnum,$plntg);
		        }


# right side

                elsif ( $side == 2 ) {
                        &print_seed_packet_label_aux($filehandle,$rt_x,$y,$barcode_file,$family,$ma_num_gtype,$pa_num_gtype,$sleeve,$cl,$ft,$rowseqnum,$plntg);
		        }


# finish the page

                if ( ( $rem == 29 ) || ( $i == $#labels ) ) { &end_picture($filehandle); }
	        }
        }






# modified to include row sequence number
#
# Kazic, 24.4.2011
#
# labels for skipped rows now obvious
#
# Kazic, 2.5.2011

# scootched row sequence number to left a bit and enlarged numerical genotype
#
# Kazic, 7.5.2011
#
#
#
# scootch row sequence number 1mm to right to accommodate paper clip; enlarge
# numerical genotype further and scootch to left.  It's a bit too small to read 
# comfortably, and packing errors arose in 11r because of this.
#
# For the skipped packets, insert a barcode for scanning during planting; retain
# the big 'SKIP' on the label.
#
# Kazic, 19.5.2011


sub print_seed_packet_label_aux {
        ($filehandle,$x,$y,$barcode_file,$family,$ma_num_gtype,$pa_num_gtype,$sleeve,$cl,$ft,$rowseqnum,$plntg) = @_;


        $ma_x = $x + 8;
        $ma_y = $y - 5;
        $pa_x = $ma_x;
        $pa_y = $y - 6;
%        $packet_x = $x + 45;
        $packet_x = $x + 42.5;
        $packet_y = $y + 1;
        $barx = $packet_x + 2;
        $bary = $packet_y - 9;


        if ( ( $ma_num_gtype =~ /000000000000000/ ) && ( $pa_num_gtype =~ /000000000000000/ ) ) {
                $ma_num_gtype = "\\qquad \\qquad \\qquad \\qquad \\qquad \\quad";
                $pa_num_gtype = $ma_num_gtype;
                $ma_x -= 6;
	        }


# shut off inbred family numbers temporarily, as 11N packets
# are disposable and the sequence number is more valuable
#
# Kazic, 6.11.2011
#
#        if ( $family =~ /^[234]\d\d$/ ) { $big = $family; }
#        else { $big = $rowseqnum; }
#
         $big = $rowseqnum;


# next year, make the skip location negative so they come out first!
#
# Kazic, 2.5.2011

        if ( ( $ma_num_gtype == $pa_num_gtype )
             && ( $cl == 0 )
             && ( $sleeve == 0 ) ) { 
                $skip_y = $ma_y + 5;

                print $filehandle "
 		   \\put($ma_x,$skip_y){\\scalebox{3}{\\textbf{SKIP}}}
                   \\put($packet_x,$packet_y){\\begin{tabular}{lr}
                   \\multicolumn{2}{c}{\\huge{$big}} \\\\
                   \\multicolumn{2}{c}{$sleeve} \\\\
                   \\multicolumn{2}{c}{\\small{$cl cl ($ft)}} \\end{tabular}}\n";
	        }

# \\put($x,$y){\\scalebox{0.65}{\\includegraphics{$barcode_file}}}


#  		   \\put($ma_x,$ma_y){\\scalebox{0.8}{\$\\frac{\\mathrm{$ma_num_gtype}}{\\mathrm{$pa_num_gtype}}\$}}

        else { print $filehandle "\\put($x,$y){\\scalebox{0.65}{\\includegraphics{$barcode_file}}}
 		   \\put($ma_x,$ma_y){\\scalebox{0.85}{\$\\frac{\\mathrm{$ma_num_gtype}}{\\mathrm{$pa_num_gtype}}\$}}
                   \\put($packet_x,$packet_y){\\begin{tabular}{lr}
                   \\multicolumn{2}{c}{\\huge{$big}} \\\\
                   \\multicolumn{2}{c}{$sleeve} \\\\
                   \\multicolumn{2}{c}{\\small{$cl k ($ft)}} \\end{tabular}}\n";
	        }
                    

        if ( $plntg > 1 ) { print $filehandle "\\put($barx,$bary){\\rule{1cm}{2mm} \\small{$plntg}}\n"; }
        }                             












######## for tagging plants

# typesets the bar code plant labels


# for each mutant plant, we want to print two plant tags; mutant plants 
# have no letter in front of their row number, and have no mutant in their
# abbreviated genotype (e.g. Les1).
#
# for each inbred plant, we want to print one plant tag; inbred plants 
# have row numbers beginning with S,W, or M and say only Mo20W, W23, M14

# for gnomon, printing the ps file from athe; guide boxes and margins are not in quite the right places
#
# feed stock in so that pass-through hole is first


# re-arrange order of elemnts in main part of tag so that littlest barcode
# is next to threading hole
#
# shift row and plant number down ~ 2mm so they clear the holes
# 
# Kazic, 26.9.09



# toggle print_perforation_guides_plant_tags to suit Fedex's preferences
# as needed.  So far they prefer the guide lines.
#
# Kazic, 29.7.2019

sub print_plant_tags {

#        ($filehandle,$barcode_file,$pre_row,$pplant,$family,$ma_num_gtype,$pa_family,$pa_num_gtype,$pma_ma_gma_gtype,$pma_ma_gpa_gtype,$pma_pa_gma_gtype,$pma_pa_mutant,$ppa_ma_gma_gtype,$ppa_ma_gpa_gtype,$ppa_pa_gma_gtype,$ppa_pa_mutant,$quasi_allele,$i,$#tags) = @_;


#	print "($filehandle,$barcode_file,$pre_row,$pplant,$family,$ma_num_gtype,$pa_family,$pa_num_gtype,$pma_ma_gma_gtype,$pma_ma_gpa_gtype,$pma_pa_gma_gtype,$pma_pa_mutant,$ppa_ma_gma_gtype,$ppa_ma_gpa_gtype,$ppa_pa_gma_gtype,$ppa_pa_mutant,$quasi_allele,$i,$#tags)\n";


#
# 09R and later

         ($filehandle,$barcode_file,$pre_row,$pplant,$crop,$family,$ma_num_gtype,$pa_family,$pa_num_gtype,$ma_gma_gtype,$marker,$quasi_allele,$i,$#tags) = @_;


#	 print "($filehandle,$barcode_file,$pre_row,$pplant,$crop,$family,$ma_num_gtype,$pa_family,$pa_num_gtype,$ma_gma_gtype,$marker,$quasi_allele,$i,$#tags)\n";

# kristen
#
#         ($filehandle,$kristen_plant_id,$barcode_file,$pre_row,$pplant,$crop,$marker,$i,$#tags) = @_;


        $rem = $i % 8;
        $stack = int($i / 8);  
        $step = $rem;
#        $base_x = -3 + (27 * $step);
        $base_x = -5 + (27 * $step);

        $top_box_x = $base_x + 4;
        $med_box_x = $base_x + 5.5;

# just a little more gap to fit the new stock nicely

        $mid_box_x = $base_x + 5.5;
        $bot_box_x = $base_x + 5.5;



# old tag stock with two tear-offs and punch-outs; no med_box needed for old tags
# to move left, decrease the offset
#
#        $base_y = -5;
#
#        $top_box_y = $base_y + 235;            # top tag
#        $mid_box_y = $base_y + 92;            # middle tag
#        $bot_box_y = $base_y + 26;             # bottom tag  28





#
# just a little more gap to fit the new stock (the one with three tear-offs) nicely
#
        $base_y = 7;     
        $top_box_y = $base_y + 235;            # top tag
        $med_box_y = $base_y + 146;  
        $mid_box_y = $base_y + 80;	 
        $bot_box_y = $base_y + 14;




# start the page


# $stack is the page number
#
# Kazic, 13.7.2020

	 
        if ( $rem == 0 ) {

                if ( $i != 0 ) { print $filehandle "\\newpage\n"; }

                &begin_big_picture($filehandle);

		&print_centered_page_num($filehandle);
                &print_perforation_guides_plant_tags($filehandle);		
#                &print_plant_tag_guide_boxes($filehandle);
                }


#        &typeset_plant_tags($filehandle,$barcode_file,$pre_row,$pplant,$family,$ma_num_gtype,$pa_family,$pa_num_gtype,$pma_ma_gma_gtype,$pma_ma_gpa_gtype,$pma_pa_gma_gtype,$pma_pa_mutant,$ppa_ma_gma_gtype,$ppa_ma_gpa_gtype,$ppa_pa_gma_gtype,$ppa_pa_mutant,$quasi_allele,$top_box_x,$top_box_y,$mid_box_x,$mid_box_y,$bot_box_x,$bot_box_y);
#
# 09R
#

# kristen
#
#	 $crop = $kristen_plant_id;
#	 $family = "";
#	 $ma_num_gtype = "";
#	 $pa_family = "";
#	 $pa_num_gtype = "";
#	 $ma_gma_gtype = "$marker";
#	 $quasi_allele = "";
#

# old, for tag stock with two tear-off tags and punch-outs
#
#        &typeset_plant_tags($filehandle,$barcode_file,$pre_row,$pplant,$crop,$family,$ma_num_gtype,$pa_family,$pa_num_gtype,$ma_gma_gtype,$marker,$quasi_allele,$top_box_x,$top_box_y,$mid_box_x,$mid_box_y,$bot_box_x,$bot_box_y);


# new, for tag stock with three tear-off tags and no punch-outs, as we used
# in 12n

        &typeset_plant_tags($filehandle,$barcode_file,$pre_row,$pplant,$crop,$family,$ma_num_gtype,$pa_family,$pa_num_gtype,$ma_gma_gtype,$marker,$quasi_allele,$top_box_x,$top_box_y,$med_box_x,$med_box_y,$mid_box_x,$mid_box_y,$bot_box_x,$bot_box_y);


        if ( ( $rem == 7 ) || ( $i == $#tags ) ) { &end_picture($filehandle); }
        }








# framebox is not needed around barcode provided the barcodes are well separated
#
# need to modify this based on 07r experience:
#
#        barcodes can be scaled 0.75 just fine;
#        make threefers to be three identical barcodes;  (decided against, 30.3.08)
#        put large plantrow atop every barcode (close; one is alongside, 30.3.08);
#        plantrow goes on both sides of the threading hole;
#        get genotypes better on tags and tear-off tags;
#        make sure a genotype is in the same position, relative to the barcode, 
#               on the first barcode next to threading hole, as it is on the tear-off tags;
#        adjust placement and sizing of layout to idiot-proof against feed errors in printing;
#
# Kazic, 26.9.07
#
#
# done
#
# Kazic, 30.3.08
#
#
#
# layout extensively revised to avoid holes and saw kerf,
# repeat all of the key elements of the barcode, and produce
# FOUR usable cross tags, in order along the stem.
#
# Optimized for gnomon.
#
# Kazic, 21.7.2010


sub typeset_plant_tags {
#        ($filehandle,$barcode_out,$pre_row,$pplant,$family,$ma_num_gtype,$pa_family,$pa_num_gtype,$pma_ma_gma_gtype,$pma_ma_gpa_gtype,$pma_pa_gma_gtype,$pma_pa_mutant,$ppa_ma_gma_gtype,$ppa_ma_gpa_gtype,$ppa_pa_gma_gtype,$ppa_pa_mutant,$quasi_allele,$top_box_x,$top_box_y,$mid_box_x,$mid_box_y,$bot_box_x,$bot_box_y) = @_;
#
#
# 09R and later, for old tag stock with two tear-off tags and punch-outs
#
#        ($filehandle,$barcode_out,$pre_row,$pplant,$crop,$family,$ma_num_gtype,$pa_family,$pa_num_gtype,$ma_gma_gtype,$marker,$quasi_allele,$top_box_x,$top_box_y,$mid_box_x,$mid_box_y,$bot_box_x,$bot_box_y) = @_;


# for new tag stock with three tear-off tags

        ($filehandle,$barcode_out,$pre_row,$pplant,$crop,$family,$ma_num_gtype,$pa_family,$pa_num_gtype,$ma_gma_gtype,$marker,$quasi_allele,$top_box_x,$top_box_y,$med_box_x,$med_box_y,$mid_box_x,$mid_box_y,$bot_box_x,$bot_box_y) = @_;



#
#
# pre-09R
#
#        ($ma_gtype) = &make_genotype($pma_ma_gma_gtype,$pma_ma_gpa_gtype,$pma_pa_gma_gtype,$pma_pa_mutant);
#        ($pa_gtype) = &make_genotype($ppa_ma_gma_gtype,$ppa_ma_gpa_gtype,$ppa_pa_gma_gtype,$ppa_pa_mutant);
#
# 09R and subsequent

        $marker =~ s/\[//g;
        $marker =~ s/\]//g;


# kristen
#
#        if ( $marker =~ /\/BSA/ ) { $marker =~ s/\/BSA//g; }
#        if ( $ma_gma_gtype =~ /\/BSA/ ) { $ma_gma_gtype =~ s/\/BSA//g; }



# for old plant tag stock, with two tear-off tags and punch-outs for threading tag
# around plant
#
#	&print_top_tag($filehandle,$top_box_x,$top_box_y,$pre_row,$pplant,$barcode_out,$crop,$family,$ma_gma_gtype,$marker,$quasi_allele);
#        &print_cross_tag($filehandle,$mid_box_x,$mid_box_y,$ma_gma_gtype,$marker,$crop,$family,$pre_row,$plant,$quasi_allele,$barcode_out);
#        &print_cross_tag($filehandle,$bot_box_x,$bot_box_y,$ma_gma_gtype,$marker,$crop,$family,$pre_row,$plant,$quasi_allele,$barcode_out);


# for new tag stock, with three tear-off tags

	&print_new_top_tag($filehandle,$top_box_x,$top_box_y,$pre_row,$pplant,$barcode_out,$crop,$family,$ma_gma_gtype,$marker,$quasi_allele);
        &print_cross_tag($filehandle,$med_box_x,$med_box_y,$ma_gma_gtype,$marker,$crop,$family,$pre_row,$plant,$quasi_allele,$barcode_out);
        &print_cross_tag($filehandle,$mid_box_x,$mid_box_y,$ma_gma_gtype,$marker,$crop,$family,$pre_row,$plant,$quasi_allele,$barcode_out);
        &print_cross_tag($filehandle,$bot_box_x,$bot_box_y,$ma_gma_gtype,$marker,$crop,$family,$pre_row,$plant,$quasi_allele,$barcode_out);



# just for Gerry's 10N tags

#        &print_gerry_tag($filehandle,$mid_box_x,$mid_box_y-50,$pre_row);
#        &print_gerry_tag($filehandle,$bot_box_x,$bot_box_y-50,$pre_row);

        }








# modified to use 07r and subsequent data; for old tag stock with two tear-off tags
# and punch-outs
#
# Kazic, 8.7.07

sub print_top_tag {

        ($filehandle,$top_box_x,$top_box_y,$pre_row,$pplant,$barcode_out,$crop,$family,$ma_gtype,$pa_gtype,$quasi_allele) = @_;

#        $row_x = $top_box_x + 1.5;
        $row_x = $top_box_x + 3;
#	$row_y = $top_box_y + 60;
	$row_y = $top_box_y + 90;    #    was 65

        $hole_row_x = $row_x;
        $hole_row_y = $top_box_y - 110;

        $cross_x = $top_box_x + 1;
	$cross_sec_y = $top_box_y + 6;
#	$cross_y = $top_box_y - 47;
	$cross_y = $top_box_y - 55;




        print $filehandle  "\\put($row_x,$row_y){\\rotatebox{90}{\\begin{tabular}{p{1.6cm}}  \\begin{tabular}{r}
                   \\scalebox{1.6}{\\textbf{$pre_row}}  \\\\   \\rule{0mm}{8mm} \\scalebox{1.60}{\\textbf{$pplant}}  \\end{tabular} \\end{tabular}}} \n";
                 
        print $filehandle  "\\put($hole_row_x,$hole_row_y){\\rotatebox{90}{\\begin{tabular}{p{1.6cm}}  \\begin{tabular}{r}
                   \\scalebox{1.6}{\\textbf{$pre_row}}  \\\\   \\rule{0mm}{8mm} \\scalebox{1.60}{\\textbf{$pplant}}  \\end{tabular} \\end{tabular}}} \n";
                 


        &print_onefer($filehandle,$top_box_x,$top_box_y,$pre_row,$pplant,$barcode_out);
        &print_cross_tag($filehandle,$cross_x,$cross_sec_y,$ma_gtype,$pa_gtype,$crop,$family,$pre_row,$pplant,$quasi_allele,$barcode_out);
        &print_cross_tag($filehandle,$cross_x,$cross_y,$ma_gtype,$pa_gtype,$crop,$family,$pre_row,$pplant,$quasi_allele,$barcode_out);


#        &print_gerry_tag($filehandle,$top_box_x,$top_box_y,$pre_row);
#        &print_gerry_tag($filehandle,$cross_x,$cross_sec_y-60,$pre_row);
#        &print_gerry_tag($filehandle,$cross_x,$cross_y-50,$pre_row);


        }






# for new tag stock with three tear-off tags

sub print_new_top_tag {

        ($filehandle,$top_box_x,$top_box_y,$pre_row,$pplant,$barcode_out,$crop,$family,$ma_gtype,$pa_gtype,$quasi_allele) = @_;

#        $row_x = $top_box_x + 1.5;
        $row_x = $top_box_x + 3;
#	$row_y = $top_box_y + 60;
	$row_y = $top_box_y + 65;

        $hole_row_x = $row_x;
#        $hole_row_y = $top_box_y - 110;
        $hole_row_y = $top_box_y - 50;

        $cross_x = $top_box_x + 1;
	$cross_sec_y = $top_box_y + 6;
#	$cross_y = $top_box_y - 47;
	$cross_y = $top_box_y - 55;



# at the end of the tag

        print $filehandle  "\\put($row_x,$row_y){\\rotatebox{90}{\\begin{tabular}{p{1.6cm}}  \\begin{tabular}{r}
                   \\scalebox{1.6}{\\textbf{$pre_row}}  \\\\   \\rule{0mm}{8mm} \\scalebox{1.60}{\\textbf{$pplant}}  \\end{tabular} \\end{tabular}}} \n";



# at the end of the tear-offs, near where the tag's waist used to be

        print $filehandle  "\\put($hole_row_x,$hole_row_y){\\rotatebox{90}{\\begin{tabular}{p{1.6cm}}  \\begin{tabular}{r}
                   \\scalebox{1.6}{\\textbf{$pre_row}}  \\\\   \\rule{0mm}{8mm} \\scalebox{1.60}{\\textbf{$pplant}}  \\end{tabular} \\end{tabular}}} \n";
                 


        &print_onefer($filehandle,$top_box_x,$top_box_y,$pre_row,$pplant,$barcode_out);
        &print_cross_tag($filehandle,$cross_x,$cross_sec_y,$ma_gtype,$pa_gtype,$crop,$family,$pre_row,$pplant,$quasi_allele,$barcode_out);
#
# old stock
#        &print_cross_tag($filehandle,$cross_x,$cross_y,$ma_gtype,$pa_gtype,$crop,$family,$pre_row,$pplant,$quasi_allele,$barcode_out);


#        &print_gerry_tag($filehandle,$top_box_x,$top_box_y,$pre_row);
#        &print_gerry_tag($filehandle,$cross_x,$cross_sec_y-60,$pre_row);
#        &print_gerry_tag($filehandle,$cross_x,$cross_y-50,$pre_row);


        }






















# this version has more threefer-like sizing and incorporates the rowplant repeat
#
# Kazic, 30.3.08
#
# switched order of extra barcodes and rescaled; confirm correctness by printing
#
# Kazic, 20.7.2010

sub print_twofers {
        ($filehandle,$top_box_x,$top_box_y,$pre_row,$pplant,$barcode_out) = @_;

#        $tx = $top_box_x - 1.5;
        $tx = $top_box_x + 1.5;
#        $ty = $top_box_y + 38;
        $ty = $top_box_y + 45;

#        $mtx = $tx + 6;
        $mtx = $tx - 1;
#        $mty = $top_box_y + 1;
        $mty = $top_box_y + 3;

#        $ngtype_x = $mtx - 3;
        $ngtype_x = $mtx - 2.5;
#        $ngtype_y = $mty - 1;
        $ngtype_y = $mty + 5;

                 
        print $filehandle "\\put($ngtype_x,$ngtype_y){\\begin{tabular}{c}
                   \\rotatebox{90}{\\scalebox{1}{\\Large{\\textbf{$pre_row \\hspace{5mm}   $pplant}}}}
                   \\end{tabular}} \n";

        print $filehandle "\\put($tx,$ty){\\begin{tabular}{c}
                   \\rotatebox{90}{\\scalebox{0.53}{\\includegraphics{$barcode_out}}}
                   \\end{tabular}} \n";
# 0.65
        print $filehandle "\\put($mtx,$mty){\\begin{tabular}{c}
                   \\rotatebox{270}{\\scalebox{0.65}{\\includegraphics{$barcode_out}}}
                   \\end{tabular}} \n";

        }






# for 10r and subsequent; old or new tag stock

sub print_onefer {
        ($filehandle,$top_box_x,$top_box_y,$pre_row,$pplant,$barcode_out) = @_;

#        $tx = $top_box_x - 1.5;
        $tx = $top_box_x + 1.5;
#        $ty = $top_box_y + 38;
        $ty = $top_box_y + 48;


        print $filehandle "\\put($tx,$ty){\\begin{tabular}{c}
                   \\rotatebox{90}{\\scalebox{0.53}{\\includegraphics{$barcode_out}}}
                   \\end{tabular}} \n";
        }
















# barcode now at 0.75, historically a reliable value
#
# Kazic, 21.7.2010

sub print_cross_tag {
        ($filehandle,$x,$y,$ma_gtype,$pa_gtype,$crop,$family,$pre_row,$plant,$quasi_allele,$barcode_out) = @_;


        $cross_box_x = $x + 0;
#        $cross_box_x = $x - 2;
#        $cross_box_y = $y - 1;
        $cross_box_y = $y + 3;

#        $data_x = $x - 2;
#        $data_x = $x - 4;
        $data_x = $x - 1.5;
        $data_y = $y + 3;


#        $gtype_x = $x + 5;
        $gtype_x = $x + 5;
#        $gtype_y = $y - 34;
        $gtype_y = $y - 31;



        $quasi_x = $gtype_x + 7;
        $quasi_y = $gtype_y;
       


        print $filehandle "\\put($cross_box_x,$cross_box_y){\\begin{tabular}{c}
                     \\rotatebox{90}{\\scalebox{0.75}{\\includegraphics{$barcode_out}}}
                     \\end{tabular}}\n";


        print $filehandle "\\put($quasi_x,$quasi_y){\\scalebox{0.9}{\\rotatebox{90}{$quasi_allele}}}\n";


        print $filehandle "\\put($data_x,$data_y){\\begin{tabular}{c}
                     \\scalebox{1.2}{\\rotatebox{90}{\\textbf{$crop $family: $pre_row $pplant}}}
                     \\end{tabular}}\n";


# kristen
#
#        print $filehandle "\\put($data_x,$data_y){\\begin{tabular}{c}
#                     \\scalebox{1}{\\rotatebox{90}{\\textbf{$crop}}}
#                     \\end{tabular}}\n";



        &scale_gtypes($filehandle,$gtype_x,$gtype_y,$ma_gtype,$pa_gtype,1);
        }








# simple row marker tags for Gerry Neuffer's 10N crop
#
# Kazic, 31.12.2010

# mmm, spacing needs to be shifted slightly to accomodate fractional rows
#
# Kazic, 3.1.2011


sub print_gerry_tag {
        ($filehandle,$x,$y,$pre_row) = @_;

        $cross_box_x = $x + 4;
        $cross_box_y = $y + 33;

        print $filehandle "\\put($cross_box_x,$cross_box_y){\\rotatebox{90}{\\scalebox{5}{$pre_row}}}\n";
        }












sub scale_gtypes {
        ($filehandle,$fx,$fy,$ma_gtype,$pa_gtype,$rotn_flag) = @_;

        $big_gtype_re = qr/[lL]\*?-[\w-]+/;



# regular cross tags for plant tags
 
        if ( $rotn_flag == 1 ) {

	        if ( ( $ma_gtype eq $pa_gtype ) && ( $ma_gtype !~ /frac/ ) && ( length($ma_gtype) < 7 ) ) { print $filehandle "\\put($fx,$fy){\\rotatebox{90}{\\scalebox{0.5}{\$" . $ma_gtype . "\$}}}\n"; }



# kristen
#
#	        if ( ( $ma_gtype eq $pa_gtype ) && ( $ma_gtype !~ /frac/ ) && ( length($ma_gtype) < 10 ) ) { print $filehandle "\\put($fx,$fy){\\rotatebox{90}{\\scalebox{0.5}{\$" . $ma_gtype . "\$}}}\n"; }


#                elsif ( ( ( $ma_gtype =~ /\|/ ) || ( length($ma_gtype) < 10 ) ) && ( ( $pa_gtype =~ /\|/ )  || ( length($pa_gtype) < 10 ) ) && ( $ma_gtype !~ /les\*-74-1973-9/ ) &&  ( $pa_gtype !~ /${big_gtype_re}/ ) ) {
                elsif ( ( length($ma_gtype) < 10 ) && ( length($pa_gtype) < 10 ) ) {


# scale was 0.65

                         print $filehandle "\\put($fx,$fy){\\rotatebox{90}{\\scalebox{0.5}{\$\\frac{" . $ma_gtype . "}{" . $pa_gtype . "}\$}}}\n";
	                 }


                elsif ( ( ( $ma_gtype =~ /${big_gtype_re}/ ) && ( length($ma_gtype) >= 7 ) )
                        || ( ( $pa_gtype =~ /${big_gtype_re}/ ) && ( length($pa_gtype) >= 7 ) ) ) {

# scale was 0.27

                        print $filehandle "\\put($fx,$fy){\\rotatebox{90}{\\scalebox{0.21}{\$\\frac{" . $ma_gtype . "}{" . $pa_gtype . "}\$}}}\n";
	                }


                else { print $filehandle "\\put($fx,$fy){\\rotatebox{90}{\\scalebox{0.5}{\$\\frac{" . $ma_gtype . "}{" . $pa_gtype . "}\$}}}\n"; }
	        }



# don't rotate the hydro tags!

        else {

	        if ( ( $ma_gtype eq $pa_gtype ) && ( $ma_gtype !~ /frac/ ) ) { print $filehandle "\\put($fx,$fy){\\scalebox{0.4}{\$" . $ma_gtype . "\$}}\n"; }


                elsif ( ( $ma_gtype =~ /\|/ ) || ( length($ma_gtype) < 9 ) || ( $pa_gtype =~ /\|/ ) || ( length($pa_gtype) < 9 ) && ( $ma_gtype !~ /les\*-74-1973-9/ ) &&  ( $pa_gtype !~ /${big_gtype_re}/ ) ) {


# scale was 0.65

                         print $filehandle "\\put($fx,$fy){\\scalebox{0.5}{\$\\frac{" . $ma_gtype . "}{" . $pa_gtype . "}\$}}\n";
	                 }


                elsif ( ( ( $ma_gtype =~ /${big_gtype_re}/ ) && ( length($ma_gtype) >= 9 ) )
                        || ( ( $pa_gtype =~ /${big_gtype_re}/ ) && ( length($pa_gtype) >= 9 ) ) ) {

# scale was 0.27

                        print $filehandle "\\put($fx,$fy){\\scalebox{0.22}{\$\\frac{" . $ma_gtype . "}{" . $pa_gtype . "}\$}}\n";
	                }


                else { print $filehandle "\\put($fx,$fy){\\scalebox{0.75}{\$\\frac{" . $ma_gtype . "}{" . $pa_gtype . "}\$}}\n"; }
        	}
        }








####### for managing pollinations


# print the tags that go on the first plant of each row.  
# Space has been left at the top of
# each tag to drill a hole.  Adapted from print_row_label.
#
# Kazic, 6.7.09

# movement pattern is horizontal first: left -> right -> down

sub print_plan_label {
        ($filehandle,$row,$ma_num_gtype,$pa_num_gtype,$ma_gma,$ma_gpa,$pa_gma,$pa_gpa,$quasi,$plan,$notes,$i,$#labels) = @_;

        $rem = $i % 10;
        $side = $rem % 2;
#        $base_x = 10;
        $base_x = 7;
#        $base_y = 239;
        $base_y = 220;
        $delta_x = 106;
#        $delta_y = 51;
        $delta_y = 50;



# this simple condition works because LaTeX automatically paginates, and each picture 
# has been designed to fill the page.  This logic is a little less robust to changes
# in picture sizes than the logic used in other subroutines, which distinguishes
# $i ==/!= 0 and inserts a new page in the latter case.  I leave it in as an example
# of how one might live just slightly more dangerously (but more simply).
#
# Kazic, 7.11.07

        if ( $rem == 0 ) {
                &begin_picture($filehandle);
#                &print_big_label_guide_boxes($filehandle);
                &print_plan_label_aux($filehandle,$base_x,$base_y,$row,$ma_num_gtype,$pa_num_gtype,$ma_gma,$ma_gpa,$pa_gma,$pa_gpa,$quasi,$plan,$notes);
                }


        elsif ( $rem > 0 ) { 


# left side

                if ( $side == 0 ) {
                        $step = $rem/2; 
                        $y = $base_y - ($delta_y * $step);
                        &print_plan_label_aux($filehandle,$base_x,$y,$row,$ma_num_gtype,$pa_num_gtype,$ma_gma,$ma_gpa,$pa_gma,$pa_gpa,$quasi,$plan,$notes);
                        }


# right side

                elsif ( $side == 1 ) {
                        $base_x += $delta_x;
                        $step = ($rem/2) - 0.5; 
                        $y = $base_y - ($delta_y * $step);
                        &print_plan_label_aux($filehandle,$base_x,$y,$row,$ma_num_gtype,$pa_num_gtype,$ma_gma,$ma_gpa,$pa_gma,$pa_gpa,$quasi,$plan,$notes);
		        }


# condition not correct for last page!

                if ( ( $rem == 9 ) || ( $i == $#labels + 1 ) ) { &end_picture($filehandle); }
                }
        }





# adjust to include information you want!  This typesets a simple centered
# table; to shift it relative to the guide boxes, adjust the coordinates in 
# &print_row_label.

sub print_plan_label_aux {
        ($filehandle,$x,$y,$row,$ma_num_gtype,$pa_num_gtype,$ma_gma,$ma_gpa,$pa_gma,$pa_gpa,$quasi,$plan,$notes) = @_;

        print $filehandle "\\put($x,$y){\\rotatebox{90}{\\begin{tabular}{p{3.5cm}}
                                 \\Huge{\\textbf{$row}} \\\\ \\\\
                                 \\Large{\$\\frac{" . $ma_num_gtype . "}{" . $pa_num_gtype . "}\$} \\\\ \\\\
                                 \\scalebox{0.7}{\$\\frac{\\frac{" . $ma_gma . "}{" . $ma_gpa . "}}{\\frac{" . $pa_gma . "}{" . $pa_gpa . "}}\$} \\\\ \\\\
                                 \\large{$quasi}  \\\\ \\\\
                                 \\large{\\emph{\\textbf{$plan}}}  \\\\ \\\\";
        if ( $notes ne "" ) {
                print $filehandle "\\hline $notes \\end{tabular}}} \n";
	        }
        else { print $filehandle "\\end{tabular}}} \n"; }
        }











######## for harvesting


# print the tags that go on the first plant of each row (Hawai'i) or in our
# aprons to guide the harvest (Missouri).  Space has been left at the top of
# each tag to drill a hole.
#
# $investigator, $university, and $dept are supplied by DefaultOrgztn.pm

# movement pattern is horizontal first: left -> right -> down

# for teosinte label, 100% autorotate portrait
#
# Kazic, 16.12.2011

sub print_row_label {
        ($filehandle,$location,$year,$row,$family,$i,$#labels) = @_;

        $rem = $i % 10;
        $side = $rem % 2;
        $base_x = 0;
        $base_y = 226;
        $delta_x = 106;
        $delta_y = 51;

        ($prefix) = &get_family_prefix($family);


# this simple condition works because LaTeX automatically paginates, and each picture 
# has been designed to fill the page.  This logic is a little less robust to changes
# in picture sizes than the logic used in other subroutines, which distinguishes
# $i ==/!= 0 and inserts a new page in the latter case.  I leave it in as an example
# of how one might live just slightly more dangerously (but more simply).
#
# Kazic, 7.11.07

        if ( $rem == 0 ) {
                &begin_picture($filehandle);
#                &print_big_label_guide_boxes($filehandle);
                &print_row_label_aux($filehandle,$base_x,$base_y,$row,$location,$year,$family);
                }


        elsif ( $rem > 0 ) { 


# left side

                if ( $side == 0 ) {
                        $step = $rem/2; 
                        $y = $base_y - ($delta_y * $step);
                        &print_row_label_aux($filehandle,$base_x,$y,$row,$location,$year,$family);
                        }


# right side

                elsif ( $side == 1 ) {
                        $base_x += $delta_x;
                        $step = ($rem/2) - 0.5; 
                        $y = $base_y - ($delta_y * $step);
                        &print_row_label_aux($filehandle,$base_x,$y,$row,$location,$year,$family);
		        }

                if ( ( $rem == 9 ) || ( $i == $#labels ) ) { &end_picture($filehandle); }
                }
        }








# I number my mutant families with four digits, inbreds with three, and each inbred
# line has its own century.  If you have a regular pattern for numbering your lines, 
# you may find adapting this subroutine for your scheme useful.
#
# Kazic, 7.11.07

sub get_family_prefix {
        ($family) = @_;

        if ( $family !~ /\d{4}/ ) {
                if ( $family =~ /2\d{2}/ ) { $prefix = "S"; }
                elsif ( $family =~ /3\d{2}/ ) { $prefix = "W"; }
                elsif ( $family =~ /4\d{2}/ ) { $prefix = "M"; }
                elsif ( $family =~ /5\d{2}/ ) { $prefix = "B"; }
                elsif ( $family =~ /[89]\d{2}/ ) { $prefix = "P"; }
	        }
        else { $prefix = ""; }

	return $prefix;
        }






# adjust to include information you want!  This typesets a simple centered
# table; to shift it relative to the guide boxes, adjust the coordinates in 
# &print_row_label.

sub print_row_label_aux {
        ($filehandle,$x,$y,$row,$location,$year,$family) = @_;

        print $filehandle "\\put($x,$y){\\rotatebox{90}{\\begin{tabular}{c}
                                 \\scalebox{6}{\\textbf{$row}} \\\\ \\\\ 
                                 \\scalebox{2}{$prefix} \\\\ \\\\ 
                                 \\Large{$investigator} \\\\ \\\\ \\\\
                                  $university \\\\
                                  $dept \\\\ \\\\ \\\\
                                 \\Large{$location \\ $year} \\\\ \\\\  \\\\
                                 \\huge{$family} \\end{tabular}}} \n";
        }








############### for harvest tags



# make easy genotypes for sorting during harvest
# I believe this is now obsolete.
#
# Kazic, 12.11.07

sub clean_gtypes {

        ($female,$female_gtype,$male,$male_gtype) = @_;


#        print "in clean:  female is $female; fegt is $female_gtype; male is $male; mgt is $male_gtype\n";

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

        ($filehandle,$female_out,$male_out,$ma_num_gtype,$pa_num_gtype,$ma_gtype,$pa_gtype,$ear,$date,$i,$#crosses) = @_;

        $rem = $i % 10;
        $side = int($rem / 5);
        $stack = int($i / 5);  
        $step = $rem % 5;

        $base_x = 14;
        $delta_x = 89;
        $base_y = 225;
        $delta_y = 51;


        if ( $rem == 0 ) {

                if ( $i != 0 ) { print $filehandle "\\newpage\n"; }

                &begin_picture($filehandle);
                &print_stack($filehandle,$side,$stack);
#                &print_business_card_guide_boxes($filehandle);
                &print_business_card_guide_lines($filehandle);

                &print_harvest_tag_aux($filehandle,$base_x,$base_y,$female_out,$male_out,$ma_num_gtype,,$pa_num_gtype,$ma_gtype,$pa_gtype,$ear,$date);
                }


        elsif ( $rem > 0 ) { 


# a little trick to use the rightmost stack layout

                if ( ( $rem == 5 ) ) { $tside = $side + 1; &print_stack($filehandle,$tside,$stack); }


# left side

                if ( $side == 0 ) {
                        $step = $rem; 
                        $y = $base_y - ($delta_y * $step);

                        &print_harvest_tag_aux($filehandle,$base_x,$y,$female_out,$male_out,$ma_num_gtype,,$pa_num_gtype,$ma_gtype,$pa_gtype,$ear,$date);
                        }


# right side

                elsif ( $side == 1 ) {
                        $base_x += $delta_x;
                        $step = $rem - 5; 
                        $y = $base_y - ($delta_y * $step);

                        &print_harvest_tag_aux($filehandle,$base_x,$y,$female_out,$male_out,$ma_num_gtype,,$pa_num_gtype,$ma_gtype,$pa_gtype,$ear,$date);
		        }


# finish the page

                if ( ( $rem == 9 ) || ( $i == $#crosses ) ) { &end_picture($filehandle); }
	        }
        }







# scaling barcodes 0.65 is legible to scanner
#
# Warning!  assumes old passing of full grandparental genotypes, I think.
#
# Kazic, 5.7.09

sub print_harvest_tag_aux {

        ($filehandle,$x,$y,$female_out,$male_out,$ma_num_gtype,$male,$female_gtype,$male_gtype,$ear,$date) = @_;

        $fe_barcode_x = $x - 1;
        $barcode_y = $y + 1;
	$male_barcode_x = $x + 31;
        $num_gtype_x = $x + 22;
        $num_gtype_y = $y + 5;
        $gtype_x = $x + 55;
        $gtype_y = $y + 7;
        $ear_y = $y + 1;
        $date_x = $x + 80;
        $date_y = $y + 18;


        ($female_gtype) = &make_genotype($female_gtype);
        ($male_gtype) = &make_genotype($male_gtype);


# barcode scale was 0.8; num gtype scale was 1.3

        print $filehandle "\\put($fe_barcode_x,$barcode_y){\\rotatebox{90}{\\scalebox{0.7}{\\includegraphics{$female_out}}}}\n";

        print $filehandle "\\put($male_barcode_x,$barcode_y){\\rotatebox{90}{\\scalebox{0.7}{\\includegraphics{$male_out}}}}\n"; 
        print $filehandle "\\put($num_gtype_x,$num_gtype_y){\\rotatebox{90}{\\scalebox{1.0}{\$\\frac{\\text{$ma_num_gtype}}{\\text{$pa_num_gtype}}\$}}}\n";
 

        &typeset_gtype($filehandle,$female_gtype,$male_gtype,$gtype_x,$gtype_y);

        print $filehandle "\\put($date_x,$ear_y){\\rotatebox{90}{\\Large{ear $ear}}}\n";
        print $filehandle "\\put($date_x,$date_y){\\rotatebox{90}{\\Large{$date}}}\n";
        }











# extensively revised
#
# Kazic, 29.3.08
#
# may need to revise further to use compressed genotypes in the
# family facts (unless these are broken out separately)
#
# Kazic, 1.5.08

sub make_genotype {
        (@genotype) = @_;
              


        foreach $grandparent (@genotype) {
                ($grandparent) = &clean_string($grandparent);


# this is for the benefit of the regular expressions:  otherwise common genotypic
# symbols are interpreted as perl regular expression operators and delimiters.

                if ( ( $grandparent =~ /\?/ ) || ( $grandparent =~ /\+/ ) || ( $grandparent =~ /\*/ ) || ( $grandparent =~ /\(/ ) ) {  
                        ($grandparent) = &make_safe_for_perl($grandparent);
		        }


# do this before latex typesetting, or the latex delimiter braces will be escaped!

                if ( ( $grandparent =~ /{/ ) || ( $grandparent =~ /\|/ ) || ( $grandparent =~ /\_/ ) ) { 
                        ($grandparent) = &literalize($grandparent);
		        }
                }

        
#        $gtype = &old_genetic_typesetting_aux(@genotype);


        $gtype = &new_genetic_typesetting_aux(@genotype);

        return $gtype;
        }









# pre-09R:  all grandparents passed and the estimated genotype typeset according to these rules;
# the rules may be valuable for the Prolog version of this.
#
# Kazic, 5.7.09

sub old_genetic_typesetting_aux {
        (@genotype) = @_;

        ($ma_gma_gtype,$ma_gpa_gtype,$pa_gma_gtype,$pa_gpa_gtype) = @genotype;



# both parent's grandparents identical homozygotes

        if ( ( $ma_gma_gtype eq $ma_gpa_gtype ) && ( $ma_gma_gtype eq $pa_gma_gtype ) && ( $ma_gma_gtype eq $pa_gpa_gtype ) ) { $gtype = "\\mathrm{" . $ma_gma_gtype . "}"; } # print "case1\n"; }


# both parent's grandparents homozygotes, but not identical

        elsif ( ( $ma_gma_gtype eq $ma_gpa_gtype ) && ( $pa_gma_gtype eq $pa_gpa_gtype ) ) { $gtype = "\\frac{\\mathrm{" . $ma_gma_gtype . "}}{\\mathrm{" . $pa_gma_gtype . "}}"; } # print "case2\n"; }


# gma homozygous, gpa heterozygous

        elsif  ( ( $ma_gma_gtype eq $ma_gpa_gtype ) && ( $pa_gma_gtype ne $pa_gpa_gtype ) ) { $gtype = "\\frac{\\mathrm{" . $ma_gma_gtype . "}}{\\frac{\\mathrm{" . $pa_gma_gtype . "}}{\\mathrm{" . $pa_gpa_gtype . "}}}"; } #  print "case3\n"; }


# gma heterozygous, gpa homozygous

        elsif  ( ( $ma_gma_gtype ne $ma_gpa_gtype ) && ( $pa_gma_gtype eq $pa_gpa_gtype ) ) { $gtype = "\\frac{\\frac{\\mathrm{" . $ma_gma_gtype . "}}{\\mathrm{" . $ma_gpa_gtype . "}}}{\\mathrm{" . $pa_gma_gtype . "}}"; } # print "case4\n"; }


# both parent's grandparents identical heterozygotes

        elsif  ( ( $ma_gma_gtype ne $ma_gpa_gtype ) && ( $pa_gma_gtype ne $pa_gpa_gtype ) && ( $ma_gma_gtype eq $pa_gma_gtype ) && ( $ma_gpa_gtype eq $pa_gpa_gtype ) ) { $gtype = "\\frac{\\mathrm{" . $ma_gma_gtype . "}}{\\mathrm{" . $ma_gpa_gtype . "}}"; } #  print "case5\n"; }


# both parent's grandparents  different heterozygous

        elsif  ( ( $ma_gma_gtype ne $ma_gpa_gtype ) && ( $pa_gma_gtype ne $pa_gpa_gtype ) ) { $gtype = "\\frac{\\frac{\\mathrm{" . $ma_gma_gtype . "}}{\\mathrm{" . $ma_gpa_gtype . "}}}{\\frac{\\mathrm{" . $pa_gma_gtype . "}}{\\mathrm{" . $pa_gpa_gtype . "}}}"; } # print "case6\n"; }


# now make perl safe for latex without messing up the latex!

        ($gtype) = &de_literalize($gtype);

        return $gtype;
        }








# revised for 09R and subsequent data; genotype now calculated in Prolog, but must still be condensed
# for plant tags
#
# Kazic, 5.7.09

# a/a
# a/(b/b)
# (a/a)/b
# (a/a)/(b/b)

sub new_genetic_typesetting_aux {
        (@genotype) = @_;

        ($gma_gtype,$gpa_gtype,$marker) = @genotype;

        ($gma_left,$gma_right) = &split_genotype($gma_gtype,$marker);
        ($gpa_left,$gpa_right) = &split_genotype($gpa_gtype,$marker);


        print "$gma_left,$gma_right,$gpa_left,$gpa_right\n";

        ($gtype) = &old_genetic_typesetting_aux($gma_left,$gma_right,$gpa_left,$gpa_right);
        
        return $gtype;
        }






sub split_genotype {
        ($gtype) = @_;
         

        $g1 = "";
        $g2 = "";
        $gl = "";
        $gr = "";
        $g3 = "";
        $g4 = "";
        $g5 = "";
        $g6 = "";
        $g13 = "";
        $g25 = "";

        $gtype =~ s/\(//g;
        $gtype =~ s/\)//g;

        if ( $gtype =~ /\// ) {
                ($g1,$g2) = $gtype =~ /^(.+)\/(.+)/;

                if ( $g1 eq $g2 ) { $gl = $g1; }
                else { 
                        $gl = $g1;
                        $gr = $g2;
		        }

                if ( ( ($g3,$g4) = $gl =~ /^(.+)\/(.+)/ )
                     && ( $g3 eq $g4 ) ) { $g13 = $g3; }
                else { $g13 = $gl; }

                if ( ( ($g5,$g6) = $gr =~ /^(.+)\/(.+)/ )
                     && ( $g5 eq $g6 ) ) { $g25 = $g5; }
                else { $g25 = $gr; }
                }

        else {
                $g13 = $gtype;
                $g25 = $gtype;
	        }


        return($g13,$g25);

        }















# for printing slightly abbreviated symbolic genotypes
#
# These bounds have been chosen for robustness to complicated 
# genotypes, rather than beauty of layout.  There is a kludge for two funky
# genotypes.
#
# Kazic, 12.11.07
#
#
# possibly obsolete, but retained up here as it will likely be needed in the future
#
# Kazic, 30.3.08

sub typeset_gtype {

        ($filehandle,$female_gtype,$male_gtype,$gtype_x,$gtype_y) = @_;


        $string = $female_gtype . $male_gtype;

        $fe_len = length($female_gtype);
        $m_len = length($male_gtype);
        $total_len = $fe_len + $m_len;


# The next few lines are quite helpful in figuring out your own boundary 
# conditions.  The first prints the detailed length information to the screen,
# the next three to the tag.  Note these lengths include the LaTeX 
# typesetting commands!  
#
#        print "tot: $total_len fe: $female_gtype fel $fe_len ml: $male_gtype ml: $m_len\n";
#        $len_x = $gtype_x - 20;
#        $len_y = $gtype_y - 13;
#        print $filehandle "\\put($len_x,$len_y){\\rotatebox{90}{\\scalebox{0.7}{\\begin{tabular}{l\@{\\hspace{1mm}}r}t & $total_len\\\\f & $fe_len\\\\m & $m_len\\end{tabular}}}}\n";


        if ( $total_len <= 30 ) {
                print $filehandle "\\put($gtype_x,$gtype_y){\\rotatebox{90}{\\scalebox{0.8}{\$\\begin{matrix} $female_gtype & \\times & $male_gtype \\end{matrix}\$}}}\n";
	        }

        elsif ( ( $total_len > 30 ) && ( $total_len <= 75 ) && ( $string !~ /frac/ ) ) {
               $gtype_y += -4;

# handle the two wierd cases:
#
# {+|les*-74-1873-9} (44)
# {(W23/L317)|les*2119} (47)

                if ( $m_len !~ /4[47]/ ) {

                        print $filehandle "\\put($gtype_x,$gtype_y){\\rotatebox{90}{\\scalebox{0.6}{\$\\begin{matrix} $female_gtype \\times \\\\  \\  $male_gtype \\end{matrix}\$}}}\n";
         	        }

                else {
                        print $filehandle "\\put($gtype_x,$gtype_y){\\rotatebox{90}{\\scalebox{0.45}{\$\\begin{matrix} $female_gtype \\times \\\\  \\  $male_gtype \\end{matrix}\$}}}\n";
		        }
	        }


        elsif ( ( $total_len > 75 ) && ( $total_len <= 95 ) ) {
                if ( $female_gtype =~ /frac/ ) {
                        print $filehandle "\\put($gtype_x,$gtype_y){\\rotatebox{90}{\\scalebox{0.8}{\$\\begin{matrix} $female_gtype & \\times & $male_gtype \\end{matrix}\$}}}\n";
	                }

                elsif ( $female_gtype !~ /frac/ ) {
                        print $filehandle "\\put($gtype_x,$gtype_y){\\rotatebox{90}{\\scalebox{0.8}{\$\\begin{matrix} $female_gtype & \\times & $male_gtype \\end{matrix}\$}}}\n";
	                }
                }


        elsif ( ( $total_len > 95 ) && ( $total_len <= 159 ) ) {

                if ( ( $m_len >= $fe_len - 30 ) && ( $m_len <= $fe_len + 30 ) ) {
                        $gtype_y += -5;
                        print $filehandle "\\put($gtype_x,$gtype_y){\\rotatebox{90}{\\scalebox{0.8}{\$\\begin{matrix} $female_gtype & \\times & $male_gtype \\end{matrix}\$}}}\n";
		        }

                else {
                        $gtype_y += -7;
                        print $filehandle "\\put($gtype_x,$gtype_y){\\rotatebox{90}{\\scalebox{0.8}{\$\\begin{matrix} $female_gtype  \\times \\\\  \\rule{10mm}{0mm} $male_gtype \\end{matrix}\$}}}\n";
		        }
	        }


        elsif ( ( $total_len > 159 ) && ( $total_len <= 280 ) ) {
                $gtype_y += -7;
                print $filehandle "\\put($gtype_x,$gtype_y){\\rotatebox{90}{\\scalebox{0.8}{\$\\begin{matrix} $female_gtype  \\times \\\\  \\rule{10mm}{0mm} $male_gtype \\end{matrix}\$}}}\n";
	        }


# want a vertical strut in the denominator but \rule isn't working

        elsif ( $total_len > 280 ) {
                $gtype_x += -2; 
                $gtype_y += -8;
                print $filehandle "\\put($gtype_x,$gtype_y){\\rotatebox{90}{\\scalebox{0.8}{\$\\begin{matrix} $female_gtype \\times \\\\    \\rule{7mm}{0mm} $male_gtype \\end{matrix}\$}}}\n";
	        }

	else { print "\n\nWarning! unconsidered case in TypesetGenetics::typeset_gtype!\nfe: $female_gtype\nm: $male_gtype\n\n"; }
        }








#### for the bags of inbred seed ###########

# The layout is modelled on that of the harvest tags,
# but printed on the Avery 2" x 4" labels.


# adjusted for gnomon
#
# Kazic, 2.4.10

sub print_inbred_seed_bag_label {

        ($filehandle,$female_out,$male_out,$family,$crop,$ma_num_gtype,$pa_num_gtype,$gtype,$i,$num_lines) = @_;




        $rem = $i % 10;
        $side = $rem % 2;
#        $base_x = 10;
        $base_x = 8;
        $base_y = 239;
        $delta_x = 106;
        $delta_y = 51;


        if ( $rem == 0 ) {

                if ( $i != 0 ) { print $filehandle "\\newpage\n"; }

                &begin_picture($filehandle);
#                &print_big_label_guide_boxes($filehandle);
                &print_inbred_seed_bag_label_aux($filehandle,$base_x,$base_y,$female_out,$male_out,$family,$crop,$ma_num_gtype,$pa_num_gtype,$gtype);
                }


        elsif ( $rem > 0 ) { 


# left side

                if ( $side == 0 ) {
                        $step = $rem/2; 
                        $y = $base_y - ($delta_y * $step);
                        &print_inbred_seed_bag_label_aux($filehandle,$base_x,$y,$female_out,$male_out,$family,$crop,$ma_num_gtype,$pa_num_gtype,$gtype);
                       }


# right side

                elsif ( $side == 1 ) {
                        $base_x += $delta_x;
                        $step = ($rem/2) - 0.5; 
                        $y = $base_y - ($delta_y * $step);
                        &print_inbred_seed_bag_label_aux($filehandle,$base_x,$y,$female_out,$male_out,$family,$crop,$ma_num_gtype,$pa_num_gtype,$gtype);


		        }



# finish the page; last condition kludgey
#
# Kazic, 4.11.09

                if ( ( $rem == 9 ) || ( $i == $num_lines ) || ( $i == $num_lines - 1 ) ) { &end_picture($filehandle); }
	        }
        print "i: $i rem: $rem num_lines: $num_lines\n";

        }







# scaling barcodes 0.65 is legible to scanner
#
# adjusted for gnomon
#
# Kazic, 2.4.10

sub print_inbred_seed_bag_label_aux {

        ($filehandle,$x,$y,$female_out,$male_out,$family,$crop,$ma_num_gtype,$pa_num_gtype,$gtype) = @_;

        ($type_cross) = $family =~ /\d(\d\d)/;
        if ( $type_cross <= 50 ) { $type = "selfed"; }
        else  { $type = "sibbed"; }

        if ( $type eq "selfed" ) { ($prefix) = &get_family_prefix($family); }
        else { $prefix = ""; }

        $family_x = $x - 7;
        $family_y = $y - 5;


        $fe_barcode_x = $x + 5;
#        $barcode_y = $y - 16;
        $barcode_y = $y - 15;
	$male_barcode_x = $x + 37;
        $num_gtype_x = $x + 28;
        $num_gtype_y = $y - 11;
 
        $prefix_x = $x + 62;
        $prefix_y = $y - 1;

        $comment_x = $x + 78;
        $comment_y = $y - 11;


        print $filehandle "\\put($family_x,$family_y){\\rotatebox{90}{\\scalebox{2}{\\Huge{$family}}}}\n";
        print $filehandle "\\put($fe_barcode_x,$barcode_y){\\rotatebox{90}{\\scalebox{0.7}{\\includegraphics{$female_out}}}}\n";
        print $filehandle "\\put($male_barcode_x,$barcode_y){\\rotatebox{90}{\\scalebox{0.7}{\\includegraphics{$male_out}}}}\n"; 
        print $filehandle "\\put($num_gtype_x,$num_gtype_y){\\rotatebox{90}{\\scalebox{1.0}{\$\\frac{\\text{$ma_num_gtype}}{\\text{$pa_num_gtype}}\$}}}\n";
        print $filehandle "\\put($prefix_x,$prefix_y){\\rotatebox{90}{\\scalebox{2}{\\Huge{$prefix}}}}\n";
        print $filehandle "\\put($comment_x,$comment_y){\\rotatebox{90}{\\begin{tabular}{c}\\large{$crop} \\\\ \\large{$gtype $type}\\end{tabular}}}\n%\n%\n";
        }







# for printing a substitute harvest tag with corrected barcodes; business-card size
#
# Kazic, 21.5.2014

# ok, still have to add BIG BOLD plantIDs

# latex file should compile without errors; last condition closes the picture
#
# Kazic, 21.5.2019

sub print_new_seed_labels {

        ($filehandle,$ma,$ma_barcode_out,$pa,$pa_barcode_out,$old_ma,$today,$i,$#labels) = @_;

        $rem = $i % 10;
        $side = int($rem / 5);
        $stack = int($i / 5);  
        $step = $rem % 5;

        $base_x = 14;
        $delta_x = 89;
#        $base_y = 225;
#        $base_y = 221.5;
        $base_y = 223;
        $delta_y = 51;


#        print "rem: $rem side: $side stack: $stack step: $step\n";
	
        if ( $rem == 0 ) {

                if ( $i != 0 ) { print $filehandle "\\newpage\n"; }

                &begin_picture($filehandle);
                &print_stack($filehandle,$side,$stack);
                &print_partial_business_card_guide_lines($filehandle);

                &print_new_seed_label_aux($filehandle,$base_x,$base_y,$ma,$ma_barcode_out,$pa,$pa_barcode_out,$old_ma,$today);
                }


        elsif ( $rem > 0 ) { 


# a little trick to use the rightmost stack layout

                if ( ( $rem == 5 ) ) { $tside = $side + 1; &print_stack($filehandle,$tside,$stack); }


# left side

                if ( $side == 0 ) {
                        $step = $rem; 
                        $y = $base_y - ($delta_y * $step);

                        &print_new_seed_label_aux($filehandle,$base_x,$y,$ma,$ma_barcode_out,$pa,$pa_barcode_out,$old_ma,$today);
                        }


# right side

                elsif ( $side == 1 ) {
                        $base_x += $delta_x;
                        $step = $rem - 5; 
                        $y = $base_y - ($delta_y * $step);

                        &print_new_seed_label_aux($filehandle,$base_x,$y,$ma,$ma_barcode_out,$pa,$pa_barcode_out,$old_ma,$today);
		        }


# finish the page

                if ( ( $rem == 9 ) || ( $i == $#labels ) ) { &end_picture($filehandle); }

	        }
        }








sub print_new_seed_label_aux {

        ($filehandle,$x,$y,$ma,$ma_barcode_out,$pa,$pa_barcode_out,$old_ma,$today) = @_;

        $ma_barcode_x = $x;
        $ma_x = $x + 18;
        $barcode_y = $y + 1;
	$pa_barcode_x = $x + 35;
        $pa_x = $x + 53;
        $substn_x = $x + 70;
        $substn_y = $barcode_y + 2;
        $text = 1.15;


# barcode scale was 0.8

        print $filehandle "\\put($ma_barcode_x,$barcode_y){\\rotatebox{90}{\\scalebox{0.7}{\\includegraphics{$ma_barcode_out}}}}\n";
        print $filehandle "\\put($ma_x,$barcode_y){\\rotatebox{90}{\\scalebox{$text}{\\textbf{$ma}}}}\n";


        print $filehandle "\\put($pa_barcode_x,$barcode_y){\\rotatebox{90}{\\scalebox{0.7}{\\includegraphics{$pa_barcode_out}}}}\n"; 
        print $filehandle "\\put($pa_x,$barcode_y){\\rotatebox{90}{\\scalebox{$text}{\\textbf{$pa}}}}\n";


#        print $filehandle "\\put($substn_x,$substn_y){\\rotatebox{90}{\\begin{tabular}{c}replaced ma \\\\\\large{$old_ma}\\\\ on $today \\end{tabular}}}\n";

# for 21r only, since we never tagged the plants
#
# Kazic, 14.11.2021

        print $filehandle "\\put($substn_x,$substn_y){\\rotatebox{90}{\\begin{tabular}{c}see inside for\\\\contemporaneous\\\\record \\end{tabular}}}\n";	


        }





















############## obsolete


# from earlier versions of typeset_plant_tag and children

sub make_genotype2 {
        my ($ma_gma_gtype,$ma_gpa_gtype,$pa_gma_gtype,$pa_gpa_gtype) = @_;


        if ( ( $ma_gma_gtype eq $ma_gpa_gtype ) && ( $ma_gma_gtype eq $pa_gma_gtype ) && ( $ma_gma_gtype eq $pa_gpa_gtype ) ) { $gtype = "\\mathrm{" . $ma_gma_gtype . "}"; }

        elsif  ( ( $ma_gma_gtype eq $ma_gpa_gtype ) && ( $ma_gma_gtype ne $pa_gma_gtype ) && ( $ma_gma_gtype ne $pa_gpa_gtype ) ) { $gtype = "\\frac{\\mathrm{" . $ma_gma_gtype . "}}{\\frac{\\mathrm{" . $pa_gma_gtype . "}}{\\mathrm{" . $pa_gpa_gtype . "}}}"; }

        elsif  ( ( $ma_gma_gtype ne $ma_gpa_gtype ) && ( $ma_gma_gtype ne $pa_gpa_gtype ) ) { $gtype = "\\frac{\\frac{\\mathrm{" . $ma_gma_gtype . "}}{\\mathrm{" . $ma_gpa_gtype . "}}}{\\frac{\\mathrm{" . $pa_gma_gtype . "}}{\\mathrm{" . $pa_gpa_gtype . "}}}"; }

        return $gtype;
        }



# 0.5 - 0.6 are fine; so can use 0.65 in threefers, spread these out nicely

sub print_threefers { 
        ($filehandle,$top_box_x,$top_box_y,$barcode_out) = @_;

        print $filehandle "\\put($top_box_x,$top_box_y){\\begin{tabular}{r}
                   \\rotatebox{90}{\\scalebox{0.5}{\\includegraphics{$barcode_out}}} \\\\
                   \\rotatebox{90}{\\scalebox{0.60}{\\includegraphics{$barcode_out}}} \\\\
                   \\rotatebox{90}{\\scalebox{0.75}{\\includegraphics{$barcode_out}}}
                   \\end{tabular}} \n";
        }








sub old_print_twofers {
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









# for printing the paper seed-counting inserts that are folded and taped
# to the bottom of the counting pans

sub print_counting_insert {

        ($num_seeds,$filehandle) = @_; 

        &begin_picture($filehandle);
        &print_pan_guide_box($filehandle);
        &print_counting_insert_aux($num_seeds,$filehandle);
        &end_picture($filehandle);
        }







sub print_counting_insert_aux { 
        ($num_seeds,$filehandle) = @_;

         print $filehandle "\\put(40,45){\\scalebox{7}{\\circle{5}}}\n";
         print $filehandle "\\put(150,45){\\scalebox{7}{\\circle{5}}}\n";
         print $filehandle "\\put(98,160){\\scalebox{7}{\\circle{5}}}\n";


        if ( $num_seeds == 20 ) {
                print $filehandle "\\put(98,95){\\scalebox{7}{\\circle{5}}}\n";
	        }
        }















######## for field plant tags


sub print_field_plant_tag {

        ($filehandle,$barcode_out_upper,$row_upper,$i,$num) = @_;

        $barcode_file = $barcode_rel_dir . $barcode_out;

        $rem = $i % 30;
        $stack = int($i / 10);
        $side = $stack % 3;
        $step = $rem % 10;


# guides x are 0, 70, 140

        $delta_x = 70;
        $left_x = -13;
        $mid_x = $left_x + $delta_x; 
        $rt_x = $left_x + 2*$delta_x;

        $y = 250 - 25.5 * $step;      

        if ( $rem == 0 )  {

                if ( $i != 0 ) { print $filehandle "\\newpage\n"; }

                &begin_picture($filehandle);
                &print_stack($filehandle,$side,$stack);
#                &print_seed_packet_guide_boxes($filehandle);
                &print_field_plant_tag_aux($filehandle,$left_x,$y,$barcode_out_upper,$row_upper);
	        }



# what's the right condition for the 31st label? $rem is 1, $i = $num

        elsif ( $rem > 0 ) { 

                if ( ( $rem == 10 ) || ( $rem == 20 ) ) { &print_stack($filehandle,$side,$stack); }

# left side

                if ( $side == 0 ) {
                        &print_field_plant_tag_aux($filehandle,$left_x,$y,$barcode_out_upper,$row_upper);
                        }


# middle

                elsif ( $side == 1 ) {
                        &print_field_plant_tag_aux($filehandle,$mid_x,$y,$barcode_out_upper,$row_upper);
		        }


# right side

                elsif ( $side == 2 ) {
                        &print_field_plant_tag_aux($filehandle,$rt_x,$y,$barcode_out_upper,$row_upper);
		        }

	        }
# finish the page

        if ( ( $rem == 29 ) || ( $i == $num - 1 ) ) { &end_picture($filehandle); }
        }










sub print_field_plant_tag_aux { 
        ($filehandle,$x,$y,$barcode_out_upper,$row_upper) = @_;

        $row_x = $x + 39; 
        $row_y = $y + 3;  

        $barcode_x = $x + 38.5;
        $barcode_y = $y + 3;

	&print_field_plant_tag_aux_aux($filehandle,$barcode_x,$barcode_y,$barcode_out_upper,$row_x,$row_y);
        }








# include the line for cutting the excess label right on it!

sub print_field_plant_tag_aux_aux {

        my ($filehandle,$barcode_x,$barcode_y,$barcode_file,$row_x,$row_y) = @_;

	print $filehandle "\\put($barcode_x,$barcode_y){\\rotatebox{0}{\\scalebox{0.62}{\\includegraphics{$barcode_file}}}}\n";

	print $filehandle "\\put($row_x,$row_y){\\rule{38mm}{0.2mm}}\n";
        print $filehandle "\\put($row_x,$row_y){\\rule{0.2mm}{15mm}}\n";
        }













######## for field plant tags


sub print_sample_tag {

        ($filehandle,$barcode_out_upper,$row_upper,$i,$num) = @_;

        $barcode_file = $barcode_rel_dir . $barcode_out;

        $rem = $i % 30;
        $stack = int($i / 10);
        $side = $stack % 3;
        $step = $rem % 10;


# guides x are 0, 70, 140

        $delta_x = 70;
        $left_x = -13;
        $mid_x = $left_x + $delta_x; 
        $rt_x = $left_x + 2*$delta_x;

        $y = 250 - 25.5 * $step;      

        if ( $rem == 0 )  {

                if ( $i != 0 ) { print $filehandle "\\newpage\n"; }

                &begin_picture($filehandle);
                &print_stack($filehandle,$side,$stack);
#                &print_seed_packet_guide_boxes($filehandle);
                &print_sample_tag_aux($filehandle,$left_x,$y,$barcode_out_upper,$row_upper);
	        }



# what's the right condition for the 31st label? $rem is 1, $i = $num

        elsif ( $rem > 0 ) { 

                if ( ( $rem == 10 ) || ( $rem == 20 ) ) { &print_stack($filehandle,$side,$stack); }

# left side

                if ( $side == 0 ) {
                        &print_sample_tag_aux($filehandle,$left_x,$y,$barcode_out_upper,$row_upper);
                        }


# middle

                elsif ( $side == 1 ) {
                        &print_sample_tag_aux($filehandle,$mid_x,$y,$barcode_out_upper,$row_upper);
		        }


# right side

                elsif ( $side == 2 ) {
                        &print_sample_tag_aux($filehandle,$rt_x,$y,$barcode_out_upper,$row_upper);
		        }

	        }
# finish the page

        if ( ( $rem == 29 ) || ( $i == $num - 1 ) ) { &end_picture($filehandle); }
        }










sub print_sample_tag_aux { 
        ($filehandle,$x,$y,$barcode_out_upper,$row_upper) = @_;

        $row_x = $x + 39; 
        $row_y = $y + 3;  

        $barcode_x = $x + 38.5;
        $barcode_y = $y + 3;

	&print_sample_tag_aux_aux($filehandle,$barcode_x,$barcode_y,$barcode_out_upper,$row_x,$row_y);
        }








# include the line for cutting the excess label right on it! --- no!!!

sub print_sample_tag_aux_aux {

        my ($filehandle,$barcode_x,$barcode_y,$barcode_file,$row_x,$row_y) = @_;

	print $filehandle "\\put($barcode_x,$barcode_y){\\rotatebox{0}{\\scalebox{0.62}{\\includegraphics{$barcode_file}}}}\n";

# these helpful lines confuse the scanner!
#
# Kazic, 15.1.2013
#
#	print $filehandle "\\put($row_x,$row_y){\\rule{38mm}{0.2mm}}\n";
#       print $filehandle "\\put($row_x,$row_y){\\rule{0.2mm}{15mm}}\n";
        }































# a known handy line!
#
#         print "i: $i rem: $rem side: $side step: $step x: $x by: $y y: $y\n";














########## obsolete




# movement here is a little unusual.  I want to put the labels
# at the vertical extrema of the 2 x 4 inch labels to minimize the
# amount of cutting we must do.  So at each step, we will print two
# row stake labels, the upper and lower ones on a physical Avery label.
#
# Kazic, 27.4.08


sub old_print_vertical_row_stake_label {

        ($filehandle,$barcode_out_upper,$row_upper,$barcode_out_lower,$row_lower,$i,$num_records) = @_;

        $barcode_file = $barcode_rel_dir . $barcode_out;


        $rem = $i % 10;
        $side = int($rem / 5);
        $stack = int($i / 5);
        $step = $rem % 5;


	print "rem: $rem side: $side st: $stack step: $step i: $i \n";

# guides x are 0, 106

        $base_x = -1;
        $delta_x = 106;
        $base_y = 250;
        $delta_y = 51;


        if ( $rem == 0 )  {

                if ( $i != 0 ) { print $filehandle "\\newpage\n"; }

                &begin_picture($filehandle);
                &print_stack($filehandle,$side,$stack);
#                &print_vertical_row_stake_label_guide_boxes($filehandle);
                &print_vertical_row_stake_label_aux($filehandle,$base_x,$base_y,$barcode_out_upper,$row_upper,$barcode_out_lower,$row_lower);
                }


        elsif ( $rem > 0 ) { 

                if ( $rem == 5 ) { $tside = $side + 1; &print_stack($filehandle,$tside,$stack); }

                if  ( $side == 0 ) {
                        $y = $base_y - ($delta_y * $step);
                        &print_vertical_row_stake_label_aux($filehandle,$base_x,$y,$barcode_out_upper,$row_upper,$barcode_out_lower,$row_lower);
                        }

                elsif ( $side == 1 ) {
                        $base_x += $delta_x;
                        $y = $base_y - ($delta_y * $step);
                        &print_vertical_row_stake_label_aux($filehandle,$base_x,$y,$barcode_out_upper,$row_upper,$barcode_out_lower,$row_lower);
		        }
	        }

# finish the page

        if ( ( $rem == 9 ) || ( $i == $num_records ) ) { &end_picture($filehandle); }
        }








sub old_print_vertical_row_stake_label_aux { 
        ($filehandle,$x,$y,$barcode_out_upper,$row_upper,$barcode_out_lower,$row_lower) = @_;

        $row_x = $x + 15; 
        $row_y = $y + 1;  
        $row_y_l = $y - 28;  


        $barcode_x = $x + 32;
        $barcode_y = $y - 1;
        $barcode_y_l = $y - 29;

	&print_vertical_row_stake_label_aux_aux($filehandle,$barcode_x,$barcode_y,$barcode_out_upper,$row_x,$row_y,$row_upper);
   	&print_vertical_row_stake_label_aux_aux($filehandle,$barcode_x,$barcode_y_l,$barcode_out_lower,$row_x,$row_y_l,$row_lower);
        }










##### for packets of new lines from people
#
# this generates a canonical barcode for use in packing planting packets
#
# derived from print_seed_packet_label
#
# need to adjust spacing for gnomon per seed_packet_labels
#
# Kazic, 28.5.2010

sub print_accession_packet_label {

        ($filehandle,$barcode_out,$family,$num_gtype,$crop,$i,$#lines) = @_;
        $barcode_file = $barcode_rel_dir . $barcode_out;

        $rem = $i % 30;
        $stack = int($i / 10);
        $side = $stack % 3;
        $box = $i + 1;        
        $step = $rem % 10;


# guides x are 0, 70, 140

        $delta_x = 70;
#
# gnomon
#
        $left_x = -1;


#
# calliope?
#
#        $left_x = -1;
#        $left_x = 1;
#
# gnomon
#
        $mid_x = $left_x + $delta_x; 
        $rt_x = $left_x + 2*$delta_x;
#
# maybe for calliope this works, but not teosinte
#
#        $y = 253.5 - 25.5 * $step;      
#
# teosinte
#
#
# Kazic, 17.5.09
#
#        $y = 263 - 26.5 * $step;      
#
# gnomon
#
        $y = 259.5 - 25.5 * $step;      



# for teosinte, regular paper, stack numbers should be moved upward by ~ 1 cm
#
# Kazic, 17.5.09

        if ( $rem == 0 ) {
                if ( $i != 0 ) { print $filehandle "\\newpage\n"; }

                &begin_picture($filehandle);
#                &print_stack($filehandle,$side,$stack);
#                &print_seed_packet_guide_boxes($filehandle);
                &print_accession_packet_label_aux($filehandle,$left_x,$y,$barcode_file,$family,$num_gtype,$crop);
                }


        elsif ( $rem > 0 ) { 

#                if ( ( $rem == 10 ) || ( $rem == 20 ) ) { &print_stack($filehandle,$side,$stack); }

# left side

                if ( $side == 0 ) {
                        &print_accession_packet_label_aux($filehandle,$left_x,$y,$barcode_file,$family,$num_gtype,$crop);
                        }


# middle

                elsif ( $side == 1 ) {
                        &print_accession_packet_label_aux($filehandle,$mid_x,$y,$barcode_file,$family,$num_gtype,$crop);
		        }


# right side

                elsif ( $side == 2 ) {
                        &print_accession_packet_label_aux($filehandle,$rt_x,$y,$barcode_file,$family,$num_gtype,$crop);
		        }


# finish the page

                if ( ( $rem == 29 ) || ( $i == $#lines ) ) { &end_picture($filehandle); }
	        }
        }








sub print_accession_packet_label_aux {
        ($filehandle,$x,$y,$barcode_file,$family,$num_gtype,$crop) = @_;

        $ma_x = $x + 8;
        $ma_y = $y - 5;
        $packet_x = $x + 45;
        $packet_y = $y + 8;
        $crop_x = $packet_x;
        $crop_y = $y - 1;

        print $filehandle "\\put($x,$y){\\scalebox{0.65}{\\includegraphics{$barcode_file}}}
                   \\put($ma_x,$ma_y){\\scalebox{0.8}{$num_gtype}}
                   \\put($crop_x,$crop_y){\\scalebox{1.1}{$crop}}
                   \\put($packet_x,$packet_y){\\huge{$family}}\n";
        }                             









# almost right, but last page of delay stickers doesn't end properly
# with an \end{picture}
#
# stopped here

sub print_row_num_label {

        ($filehandle,$switch,$rowseqnum,$plntg,$prefix,$days_delay,$name,$institutn,$i,$size) = @_;
        
#        print "prn: $switch,$rowseqnum,$plntg,$prefix,$days_delay,$name,$institutn,$i,$size\n";

        $rem = $i % 30;
        $stack = int($i / 10);
        $side = $stack % 3;
        $box = $i + 1;        
        $step = $rem % 10;
        $teosinte_step = $step - 0.08;

# guides x are 0, 70, 140

        $delta_x = 70;
#
# gnomon
#
        $left_x = -1;
#
# additional terms are for teosinte: mid_x+1, rt_x+3
#
        $mid_x = $left_x + $delta_x; 
        $rt_x = $left_x + 2*$delta_x;
#
# maybe for calliope this works, but not teosinte
#
#        $y = 253.5 - 25.5 * $step;      
#
# teosinte
#
#
# Kazic, 17.5.09
#
         $y = 263 - 26.5 * $teosinte_step;      
#
# gnomon
#
#        $y = 259.5 - 25.5 * $step;      


#	if ( $switch eq "delay" ) { print "i: $i rem: $rem size: $size\n"; }

# for teosinte, regular paper, stack numbers should be moved upward by ~ 1 cm
#
# Kazic, 17.5.09

        if ( $rem == 0 ) {
                if ( $i != 0 ) { print $filehandle "\\newpage\n"; }

                &begin_picture($filehandle);
                &print_stack($filehandle,$side,$stack);
#                &print_seed_packet_guide_boxes($filehandle);
                &print_row_num_label_aux($filehandle,$left_x,$y,$switch,$rowseqnum,$plntg,$prefix,$days_delay,$name,$institutn);
                }


        elsif ( $rem > 0 ) { 

                if ( ( $rem == 10 ) || ( $rem == 20 ) ) { &print_stack($filehandle,$side,$stack); }

# left side

                if ( $side == 0 ) {
                        &print_row_num_label_aux($filehandle,$left_x,$y,$switch,$rowseqnum,$plntg,$prefix,$days_delay,$name,$institutn);
                        }


# middle

                elsif ( $side == 1 ) {
                        &print_row_num_label_aux($filehandle,$mid_x,$y,$switch,$rowseqnum,$plntg,$prefix,$days_delay,$name,$institutn);
		        }


# right side

                elsif ( $side == 2 ) {
                        &print_row_num_label_aux($filehandle,$rt_x,$y,$switch,$rowseqnum,$plntg,$prefix,$days_delay,$name,$institutn);
		        }


# finish the page

                if ( ( $switch eq "all" ) && ( ( $rem == 29 ) || ( $i == $size ) ) ) { &end_picture($filehandle); }
                elsif ( ( $switch eq "delay" ) && ( ( $rem == 29 ) || ( $i == $size - 1 ) ) ) { &end_picture($filehandle); }

	        }
        }









sub print_row_num_label_aux {
        ($filehandle,$x,$y,$switch,$rowseqnum,$plntg,$prefix,$days_delay,$name,$institutn) = @_;

#        print "aux: $switch,$rowseqnum,$plntg,$prefix,$days_delay,$name,$institutn\n";


        $ma_x = $x + 8;
        $ma_y = $y - 8;
        $packet_x = $x + 53;
        $packet_y = $y + 1;
        $barx = $x + 35;
        $bary = $packet_y - 5;




	if ( $switch eq "all" ) {

                print $filehandle "\\put($x,$packet_y){\\scalebox{3.5}{$prefix$rowseqnum}}\n

 		     \\put($x,$ma_y){\\scalebox{0.85}{$name $institutn}}\n";
#                     \\put($packet_x,$packet_y){\\scalebox{1.5}{$rowseqnum}}


                if ( $plntg > 1 ) {
                        print $filehandle "\\put($x,$bary){\\scalebox{1.25}{$days_delay days Delay Row}}\n"; 
                        }                

	        }
                    



        if ( $switch eq "delay" ) { print $filehandle "\\put($x,$packet_y){\\scalebox{4}{$prefix$rowseqnum}}
 		     \\put($x,$ma_y){\\scalebox{0.85}{$name $institutn}}
                     \\put($barx,$packet_y){\\scalebox{1.25}{DELAY $days_delay d}}\n";
                }                             

        }






1;



