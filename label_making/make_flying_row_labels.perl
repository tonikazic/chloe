#!/usr/local/bin/perl

# this is ../c/maize/label_making/make_flying_row_labels.perl

# this is adapted from ./make_labels.perl

# want to experiment with layout of row labels easily read from the air
#
# once we know the parameters, we can laminate these and have them on hand
#
# Kazic, 27.6.2023


# call will probably be perl ./make_flying_row_labels.perl i START_ROW STOP_ROW SKIP_IN_BETWEEN_ROWS


######### stopped here, gotta debug!  but not sure this is what I really want
# need to test visibility of numbers on flying phone screen first
#
# Kazic, 28.6.2023


use strict;
use warnings;


use Cwd 'getcwd';


use lib './Typesetting/';
use DefaultOrgztn;
use MaizeRegEx;
use AuxiliaryFiles;
use OrganizeData;
use TypesetGenetics;
use TypesettingMisc;
use GenerateOutput;


# our $crop = $ARGV[0]; in DefaultOrgztn


my $start = $ARGV[1];
my $stop = $ARGV[2];
my $skip = $ARGV[3];
my $local_dir = getcwd;

my ($dir,$input_dir,$barcodes,$tags_dir) = &adjust_paths($crop,$local_dir);




my $tags_stem = "row_tags";
my $input_file = $input_dir . $input_stem . $csv_suffix;
my $output_file = $tags_dir . $tags_stem . $tex_suffix;

# print "if: $input_file\nof: $output_file\n";


my @rows;


# generate array of row numbers from input start, stop, and skip

for ( my $i = $start; $i <= $stop; $i + $skip ) { push(@rows,$i); }








# now have to make the latex files for the labels, moving over @rows
#
# want to use the big Avery labels


open my $output_fh, '>', $output_file or die "can't open $output_file\n";
print $output_fh "\\documentclass[11pt]{article}\n\\usepackage{graphics,graphicx,rotating}\n\\usepackage{barcode_margins}\n\\pagestyle{empty}\n\\thispagestyle{empty}\n\\begin{document}\n\n";

foreach ($row in @rows) &print_flying_row_label($output_fh,$row,$#row)"; }

print $output_fh "\\end{document}";

close($output_fh);

system("pdflatex $big");




# need to rotate row numbers 90 deg, so trying
#
# https://www.overleaf.com/latex/examples/example-of-rotated-text-in-latex/fkmpsbztrxmv
#
# size should be \scalebox{12}{\textbf{23R5013}}



sub print_flying_row_label {
        ($output_fh,$row,$#row) = @_;

        $rem = $row % 10;
        $side = $rem % 2;
        $box = $row + 1;        

#        print "row is $row; rem is $rem; side is $side; box is $box; end is $#row\n";

        if ( ( $rem eq 0 ) && ( $row eq 0 ) ) {
                print $output_fh "\\unitlength=1mm\n\\begin{picture}(204,250)(0,0)\n";
                print $output_fh "\\put(0,200){\\makebox(98,47){\\begin{turn}{90}\\scalebox{12}{\\textbf{$row}}\\end{turn}}}\n";

                }


        elsif ( ( $rem eq 0 ) && ( $row ne 0 ) ) {
                print $output_fh "\\newpage\n\\unitlength=1mm\n\\begin{picture}(204,250)(0,0)\n";
                print $output_fh "\\put(0,200){\\makebox(98,47){\\begin{turn}{90}\\scalebox{12}{\\textbf{$row}}\\end{turn}}}\n";
                }



        elsif ( $rem > 0 ) { 


# left side

                if ( $side eq 0 ) {

                        $step = (($rem - 1) /2 ) + 1.5;

                        $base_y = 250 - 50 * $step;
                        print $output_fh "\\put(0,$base_y){\\makebox(98,47){\\begin{turn}{90}\\scalebox{12}{\\textbf{$row}}\\end{turn}}}\n";
                        }



# right side

                elsif ( $side eq 1 ) {

                        $step = (($rem - 1) /2 ) + 1;

                        $base_y = 250 - 50 * $step;


                        print "in right: rem is $rem; side is $side; step is $step\n";

                        print $output_fh "\\put(107,$base_y){\\makebox(98,47){\\begin{turn}{90}\\scalebox{12}{\\textbf{$row}}\\end{turn}}}\n";
		        }

                if ( ( $rem eq 9 ) || ( $row eq $end ) ) { print $output_fh "\\end{picture}\n\n"; }

                }
        }


