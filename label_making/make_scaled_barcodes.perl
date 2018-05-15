#!/usr/local/bin/perl

# this is make_scaled_barcodes.perl

# a little script for printing out barcodes of different sizes to test scanning
#
# Kazic, 1.7.07


use guides;
use typeset_genetics;
use typesetting_misc;

$file_stem = "scaled_barcodes";
$tex_suffix = ".tex";
$ps_suffix = ".ps";
$pdf_suffix = ".pdf";

$tags = $file_stem . $tex_suffix;


open(TAG,">$tags");


&begin_latex_file;
&begin_picture;
&print_barcodes;
&end_picture;
&end_latex_file;


close(TAG);

# system("pdflatex $tags");


system("latex $file_stem");
system("dvips $file_stem");
system("ps2pdf $file_stem" . "$ps_suffix $file_stem" . "$pdf_suffix");




sub print_barcodes {
        print TAG "\\put(0,247){\\framebox(64,22){\\scalebox{1.1}{\\includegraphics{../barcodes/06R0005:0000504.eps}}}}\n";
        print TAG "\\put(0,222){\\framebox(64,22){\\scalebox{1.0}{\\includegraphics{../barcodes/06R0005:0000504.eps}}}}\n";
        print TAG "\\put(0,197){\\framebox(64,22){\\scalebox{0.8}{\\includegraphics{../barcodes/06R0005:0000504.eps}}}}\n";
        print TAG "\\put(0,171){\\framebox(64,22){\\scalebox{0.7}{\\includegraphics{../barcodes/06R0005:0000504.eps}}}}\n";
        print TAG "\\put(0,146){\\framebox(64,22){\\scalebox{0.6}{\\includegraphics{../barcodes/06R0005:0000504.eps}}}}\n";
        print TAG "\\put(0,121){\\framebox(64,22){\\scalebox{0.5}{\\includegraphics{../barcodes/06R0005:0000504.eps}}}}\n";
        print TAG "\\put(0,95){\\framebox(64,22){\\scalebox{0.4}{\\includegraphics{../barcodes/06R0005:0000504.eps}}}}\n";
        print TAG "\\put(0,69){\\framebox(64,22){\\scalebox{1.1}{\\includegraphics{../barcodes/06R0034:0003409.eps}}}}\n";
        print TAG "\\put(0,44){\\framebox(64,22){\\scalebox{1.0}{\\includegraphics{../barcodes/06R0034:0003409.eps}}}}\n";
        print TAG "\\put(0,19){\\framebox(64,22){\\scalebox{0.8}{\\includegraphics{../barcodes/06R0034:0003409.eps}}}}\n";

        print TAG "\\put(70,247){\\framebox(64,22){\\scalebox{0.7}{\\includegraphics{../barcodes/06R0034:0003409.eps}}}}\n";
        print TAG "\\put(70,222){\\framebox(64,22){\\scalebox{0.6}{\\includegraphics{../barcodes/06R0034:0003409.eps}}}}\n";
        print TAG "\\put(70,197){\\framebox(64,22){\\scalebox{0.5}{\\includegraphics{../barcodes/06R0034:0003409.eps}}}}\n";
        print TAG "\\put(70,171){\\framebox(64,22){\\scalebox{0.4}{\\includegraphics{../barcodes/06R0034:0003409.eps}}}}\n";
        print TAG "\\put(70,146){\\framebox(64,22){\\scalebox{1.1}{\\includegraphics{../barcodes/06R300:W000I208.eps}}}}\n";
        print TAG "\\put(70,121){\\framebox(64,22){\\scalebox{1.0}{\\includegraphics{../barcodes/06R300:W000I208.eps}}}}\n";
        print TAG "\\put(70,95){\\framebox(64,22) {\\scalebox{0.8}{\\includegraphics{../barcodes/06R300:W000I208.eps}}}}\n";
        print TAG "\\put(70,69){\\framebox(64,22) {\\scalebox{0.7}{\\includegraphics{../barcodes/06R300:W000I208.eps}}}}\n";
        print TAG "\\put(70,44){\\framebox(64,22) {\\scalebox{0.6}{\\includegraphics{../barcodes/06R300:W000I208.eps}}}}\n";
        print TAG "\\put(70,19){\\framebox(64,22) {\\scalebox{0.5}{\\includegraphics{../barcodes/06R300:W000I208.eps}}}}\n";

        print TAG "\\put(140,247){\\framebox(64,22){\\scalebox{0.4}{\\includegraphics{../barcodes/06R300:W000I208.eps}}}}\n";
        print TAG "\\put(140,222){\\framebox(64,22){\\scalebox{1.1}{\\includegraphics{../barcodes/06N401:M0012103.eps}}}}\n";
        print TAG "\\put(140,197){\\framebox(64,22){\\scalebox{1.0}{\\includegraphics{../barcodes/06N401:M0012103.eps}}}}\n";
        print TAG "\\put(140,171){\\framebox(64,22){\\scalebox{0.8}{\\includegraphics{../barcodes/06N401:M0012103.eps}}}}\n";
        print TAG "\\put(140,146){\\framebox(64,22){\\scalebox{0.7}{\\includegraphics{../barcodes/06N401:M0012103.eps}}}}\n";
        print TAG "\\put(140,121){\\framebox(64,22){\\scalebox{0.6}{\\includegraphics{../barcodes/06N401:M0012103.eps}}}}\n";
        print TAG "\\put(140,95){\\framebox(64,22){\\scalebox{0.5}{\\includegraphics{../barcodes/06N401:M0012103.eps}}}}\n";
        print TAG "\\put(140,69){\\framebox(64,22){\\scalebox{0.4}{\\includegraphics{../barcodes/06N401:M0012103.eps}}}}\n";
        print TAG "\\put(140,44){\\framebox(64,22){\\scalebox{0.3}{\\includegraphics{../barcodes/06N401:M0012103.eps}}}}\n";
        print TAG "\\put(140,19){\\framebox(64,22){\\scalebox{0.2}{\\includegraphics{../barcodes/06N401:M0012103.eps}}}}\n";
        }
