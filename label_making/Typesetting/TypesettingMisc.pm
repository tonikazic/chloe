# this is ../c/maize/label_making/Typesetting/TypesettingMisc.pm

# a module of miscellaneoustypesetting commands for various types of labels


# file and picture starting and closing
#
# margin style files are in 
# /usr/share/teTeX/share/texmf-dist/tex/latex/tonis
# on our local machines



package TypesettingMisc;

use Guides;




use Exporter;

our @ISA = qw(Exporter);
our @EXPORT = qw(begin_latex_file
             begin_latex_plant_tags_file
             begin_row_stake_latex_file
             begin_box_label_latex_file
             begin_small_label_latex_file
             end_latex_file
             end_box_label_latex_file
             begin_picture
             begin_big_picture
             begin_row_stake_picture
             end_picture
             make_crop
             print_higher_stack
             print_stack
             print_centered_page_num
             print_page_num
             pad_row
             easy_row
             pad_plant
             adjust_row_spacing
             prune_box
             clean_line
             new_page
             print_vertical_row_stake_cutting_templates
             make_num_gtype
             );











# adjust margins style file as needed
#
# Kazic, 12.4.10

sub begin_latex_file {
        ($filehandle) = @_;

#        print $filehandle "\\documentclass[12pt]{article}\n\\usepackage{graphics,graphicx,graphpap,amsmath,multirow}\n\\usepackage{barcode_margins}\n\\pagestyle{empty}\n\\thispagestyle{empty}\n\\DeclareMathSizes{12}{30}{13}{9}\n\\begin{document}\n\n";

        print $filehandle "\\documentclass[12pt]{article}\n\\usepackage{graphics,graphicx,graphpap,amsmath,multirow}\n\\usepackage{row_stake_margins}\n\\pagestyle{empty}\n\\thispagestyle{empty}\n\\DeclareMathSizes{12}{30}{13}{9}\n\\begin{document}\n\n";
        }





sub begin_small_label_latex_file {
        ($filehandle) = @_;

        print $filehandle "\\documentclass[12pt]{article}\n\\usepackage{graphics,graphicx,graphpap,amsmath,multirow}\n\\usepackage{small_label_margins}\n\\pagestyle{empty}\n\\thispagestyle{empty}\n\\DeclareMathSizes{12}{30}{13}{9}\n\\begin{document}\n\n";
        }




# don't use both landscape and legal!!!!! just legal in the preamble and
# dvips -t legal in the dvips
#
# Kazic, 6.1.07

sub begin_latex_plant_tags_file {
        ($filehandle) = @_;

        print $filehandle "\\documentclass[legalpaper,12pt]{article}\n\n\\usepackage{graphics,graphicx,amsmath,multirow}\n\\usepackage{plant_tag_margins}\n\\pagestyle{empty}\n\\thispagestyle{empty}\n\\DeclareMathSizes{12}{30}{13}{9}\n\n\\begin{document}\n\n";
        }




# added stackengine for easier vertical typesetting of row numbers
#
# Kazic, 15.5.2024

sub begin_row_stake_latex_file {
        ($filehandle) = @_;

        print $filehandle "\\documentclass[12pt]{article}\n\\usepackage{graphics,graphicx,graphpap,amsmath,multirow,stackengine}\n\\usepackage{row_stake_margins}\n\\pagestyle{empty}\n\\thispagestyle{empty}\n\\DeclareMathSizes{12}{30}{13}{9}\n\\begin{document}\n\n";
        }



sub begin_box_label_latex_file {
        ($filehandle) = @_;

        print $filehandle "\\documentclass[12pt]{article}\n\\usepackage{multirow,lscape,array}\n\\usepackage{box_label_margins}\n\\pagestyle{empty}\n\\thispagestyle{empty}\n\\DeclareMathSizes{12}{30}{13}{9}\n\\begin{document}\n\n\\begin{landscape}\n\n";
        }

sub end_box_label_latex_file {
        ($filehandle) = @_;

        print $filehandle "\\end{landscape}\n\\end{document}";
        }




sub end_latex_file {
        ($filehandle) = @_;

        print $filehandle "\\end{document}";
        }


sub begin_picture {
        ($filehandle) = @_;

#        print $filehandle "\\unitlength=1mm\n\\begin{picture}(204,250)(0,0)\\graphpaper(0,0)(204,250)\n";
        print $filehandle "\\unitlength=1mm\n\\begin{picture}(204,250)(0,0)\n";
        }


sub begin_big_picture {
        ($filehandle) = @_;

        print $filehandle "\\unitlength=1mm\n\\begin{picture}(216,330)(0,0)\n";
        }




sub begin_row_stake_picture {
        ($filehandle) = @_;

        print $filehandle "\\unitlength=1mm\n\\begin{picture}(200,270)(0,0)\n";
        }




sub end_picture {
        ($filehandle) = @_;

        print $filehandle "\\end{picture}\n\n";
        }



sub make_crop {
	($dir) = @_;

        ($crop) = $dir =~ /(\d\d[rgn])$/;
        $crop =~ tr/[a-z]/[A-Z]/;

        return $crop;
        }





# the stack numbers at the top of each half of the Avery stock; 
# good for any Avery label material

sub print_stack {
        ($filehandle,$side,$stack) = @_;

        if ( ( $side eq "left" ) || ( $side eq 0 ) ) { print $filehandle "\\put(52,276){$stack}\n"; }
        elsif ( ( $side eq "middle" ) || ( $side eq 1 ) ) { print $filehandle "\\put(102,276){$stack}\n"; }
        elsif ( ( $side eq "right" ) || ( $side eq 2 ) ) { print $filehandle "\\put(152,276){$stack}\n"; }

# new for bifocal-friendly row stakes
#
# Kazic, 15.5.2024

	elsif ( $side > 2 ) { print $filehandle "\\put(102,276){$stack}\n"; }
  
}









# scootch those numbers up above the guide line and clear space in the tag
#
# Kazic, 9.7.2022

sub print_higher_stack {
        ($filehandle,$side,$stack) = @_;

        if ( ( $side eq "0" ) || ( $side eq 0 ) ) { print $filehandle "\\put(52,285){$stack}\n"; }
        elsif ( ( $side eq "1" ) || ( $side eq 2 ) ) { print $filehandle "\\put(152,285){$stack}\n"; }
        }





# it could be red, but then there would be an extra printing charge
#
# empirical placement based on ../c/maize/crops/20r/tags/fake_prioritized_tags.tex
#
# Kazic, 13.7.2020

sub print_centered_page_num {
        ($filehandle) = @_;

        print $filehandle "\\put(100,335){\\Huge{\\textbf{\\thepage}}}\n";
        }






sub print_page_num {
        ($filehandle,$page_num) = @_;

        print $filehandle "\\put(100,324){$page_num}\n";
        }




# these next two pad the characters for rows and plants in the barcodes
#
# added removal of r from palm data on row_status
#
# Kazic, 4.7.09

sub pad_row {
	($num,$max) = @_;

        $padding = $max - length($num);
        $l = length($num);

        if ( $padding == 0 ) { $pnum = $num; }
        else {
                if ( $num =~ /r/ ) { ($num) =~ /r(\d+)/; }
                $pad = '';
                for ( $l = 1 ; $l <= $padding; $l++ ) { $pad .= "0"; }
                $pnum = $pad . $num;
	        }

        return $pnum;
        }






sub easy_row {
        ($prow,$prefix) = @_;


# modified regex for Gerry's fractional rows/families
#
# Kazic, 3.1.2011
#
#        ($row) = $prow =~ /0{0,4}(\d{1,4})/;
        ($row) = $prow =~ /0{0,4}(\d{1,4}\.*\d*)/;
        $pre_row = $prefix . $row;

        return($pre_row);
        }










sub pad_plant {
	($plant) = @_;

        if ( $plant =~ /^[123456789]$/ ) { $pplant = "0" . $plant; }
        else { $pplant = $plant; }
        return $pplant;
        }









sub adjust_row_spacing {
        ($prow,$row) = @_;

        $srow = '';
        $spaces = length($prow) - length($row);
        if ( $spaces == 0 ) { $srow = $row; }
        else {
                for ( $k = 0 ; $k <= $spaces ; $k++ ) { $srow .= "\\ "; }
                $srow = $srow . $row;
	        }
        return $srow;
        }





sub prune_box {
        ($box) = @_;

        ($pruned_box) = $box =~ /x0{0,4}(\d+)/;
        return $pruned_box;
        }






sub clean_line {
        $_ =~ s/\"//g;
        $_ =~ s/\'//g;
#        $_ =~ s/\s//g;
        $_ =~ s/^,+//g;
#        $_ =~ s/,,+$/,/g;
        chomp($_);
        }





sub new_page {
         ($filehandle) = @_;

         print $filehandle "\\newpage\n";
         }





# lay the labels on the laminating sheets, then cut the sheets

sub print_vertical_row_stake_cutting_templates {
         ($filehandle,$num_cutting) = @_;

         for ( $i = 0 ; $i < $num_cutting; $i++ ) { &begin_picture($filehandle); &print_vertical_row_stake_cutting($filehandle); &end_picture($filehandle); }
         }



         




sub make_num_gtype { 
        ($family,$crop) = @_; 

        $pfamily = &pad_row($family,4);
        ($year,$crop_letter) = $crop =~ /(\d\d)(\w)/;
        $ucrop = uc($crop_letter);
        $num_gtype = $year . $ucrop . $pfamily . ":0000000";

        return $num_gtype;
        }




1;
