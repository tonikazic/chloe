#!/usr/local/bin/perl

# this is make_labels.perl

$input = "crosses.csv";
$suffix = ".eps";
$little = "little_labels.tex";
$big = "big_labels.tex";
$littled = "little_labels.dvi";
$bigd = "big_labels.dvi";


$date = `date`;
($month,$day) = $date =~ /^\w{3} (\w\w\w)\ (\d\d)/;
if ( $month eq "Jul" ) { $month = ".7"; }
elsif ( $month eq "Aug" ) { $month = ".8"; }
elsif ( $month eq "Jun" ) { $month = ".6"; }
elsif ( $month eq "Nov" ) { $month = ".11"; }
elsif ( $month eq "Dec" ) { $month = ".12"; }
elsif ( $month eq "Jan" ) { $month = ".1"; }
elsif ( $month eq "Feb" ) { $month = ".2"; }
$date = "$day" . "$month";


open(IN,"<$input");

while (<IN>) {
        ($male,$females) = $_ =~ /^(\w+),(.+)$/;
        $male =~ s/\"//g;
        $females =~ s/\"//g;
        $females =~ s/,,/,/g;
        $females =~ s/^,+//;
        $females =~ s/,+$//;
        print "male is $male and females are $females\n";
        
        (@female) = split(/,/,$females);
        $male_out = $male . $suffix;

        system("/opt/local/bin/barcode -c -E -b $male -u in -g \"2x1+0.2+0.2\" -e 128 -o $male_out");

	

        foreach $female (@female)  {
                $female_out = $female . $suffix;
                print "output file is $female_out\n";
                system("/opt/local/bin/barcode -c -E -b $female -u in -g \"2x1+0.2+0.2\" -e 128 -o $female_out");
                $files = $female_out . "::" . $male_out;
                print "files are $files\n";
                push(@cross,$files);
 	        }
        }

close(IN);



# now have to make the latex files for the labels, moving over @cross


open(LITTLE,">$little");
open(BIG,">$big");

print LITTLE "\\documentclass[11pt]{article}\n\\usepackage{graphics,graphicx}\n\\usepackage{barcode_margins}\n\\pagestyle{empty}\n\\thispagestyle{empty}\n\\begin{document}\n\n";
print BIG "\\documentclass[11pt]{article}\n\\usepackage{graphics,graphicx}\n\\usepackage{barcode_margins}\n\\pagestyle{empty}\n\\thispagestyle{empty}\n\\begin{document}\n\n";

print "num crosses is $#cross\n";

for ( $i = 0; $i <= $#cross; $i++ ) {
        ($female_out,$male_out) = split(/::/,$cross[$i]);
        &print_little_label($female_out,$male_out,$i,$date,$#cross);
        &print_big_label($female_out,$male_out,$i,$date,$#cross);
        }




print LITTLE "\\end{document}";
print BIG "\\end{document}";

close(LITTLE);
close(BIG);



system("latex $little ; dvips $littled");
system("latex $big ; dvips $bigd");



sub print_little_label {
        ($female_out,$male_out,$i,$date,$end) = @_;

        $rem = $i % 20;
        $side = $rem % 2;
        $box = $i + 1;        

#        print "i is $i; rem is $rem; side is $side; box is $box; end is $end\n";

        if ( ( $rem eq 0 ) && ( $i eq 0 ) ) {
                print LITTLE "\\unitlength=1mm\n\\begin{picture}(204,250)(0,0)\n";
#                print LITTLE "\\put(0,225){\\framebox(98,22){$box}}\n";
                print LITTLE "\\put(0,225){\\makebox(98,22){$box}}\n";
                print LITTLE "\\put(1,227){\\shortstack{A\\\\v\\\\e\\\\r\\\\y}}\n";
                print LITTLE "\\put(0,243){$date}\n";
                print LITTLE "\\put(12,232){\\scalebox{0.5}{\\includegraphics{$female_out}}}\n";  
                print LITTLE "\\put(60,224){\\scalebox{0.5}{\\includegraphics{$male_out}}}\n";
                }

        elsif ( ( $rem eq 0 ) && ( $i ne 0 ) ) {

                print LITTLE "\\newpage\n\\unitlength=1mm\n\\begin{picture}(204,250)(0,0)\n";
#                print LITTLE "\\put(0,225){\\framebox(98,22){$box}}\n";
                print LITTLE "\\put(0,225){\\makebox(98,22){$box}}\n";
                print LITTLE "\\put(1,227){\\shortstack{A\\\\v\\\\e\\\\r\\\\y}}\n";
                print LITTLE "\\put(0,243){$date}\n";
                print LITTLE "\\put(12,232){\\scalebox{0.5}{\\includegraphics{$female_out}}}\n";  
                print LITTLE "\\put(60,224){\\scalebox{0.5}{\\includegraphics{$male_out}}}\n";
                }


        elsif ( $rem > 0 ) { 


# left side

                if ( $side eq 0 ) {

                        $step = (($rem - 1) /2 ) + 1.5;

                        $base_y = 250 - 25 * $step;
                        $avery_y = $base_y + 2;
                        $date_y = $base_y + 18;
                        $female_y = $base_y + 7;
                        $male_y = $base_y - 1;



#                        print "in left: rem is $rem; side is $side; step is $step\n";
#                        print "base_y is $base_y; avery_y is $avery_y; date_y is $date_y; female_y is $female_y; male_y is $male_y\n";

#                        print LITTLE "\\put(0,$base_y){\\framebox(98,22){$box}}\n";
                        print LITTLE "\\put(0,$base_y){\\makebox(98,22){$box}}\n";
                        print LITTLE "\\put(1,$avery_y){\\shortstack{A\\\\v\\\\e\\\\r\\\\y}}\n";
                        print LITTLE "\\put(0,$date_y){$date}\n";
                        print LITTLE "\\put(12,$female_y){\\scalebox{0.5}{\\includegraphics{$female_out}}}\n";  
                        print LITTLE "\\put(60,$male_y){\\scalebox{0.5}{\\includegraphics{$male_out}}}\n";
                        }



# right side

                elsif ( $side eq 1 ) {

                        $step = (($rem - 1) /2 ) + 1;

                        $base_y = 250 - 25 * $step;
                        $avery_y = $base_y + 2;
                        $date_y = $base_y + 18;
                        $female_y = $base_y + 7;
                        $male_y = $base_y - 1;


#                        print "in right: rem is $rem; side is $side; step is $step\n";
#                        print "base_y is $base_y; avery_y is $avery_y; date_y is $date_y; female_y is $female_y; male_y is $male_y\n";


#                        print LITTLE "\\put(107,$base_y){\\framebox(98,22){$box}}\n";
                        print LITTLE "\\put(107,$base_y){\\makebox(98,22){$box}}\n";
                        print LITTLE "\\put(108,$avery_y){\\shortstack{A\\\\v\\\\e\\\\r\\\\y}}\n";
                        print LITTLE "\\put(107,$date_y){$date}\n";
                        print LITTLE "\\put(119,$female_y){\\scalebox{0.5}{\\includegraphics{$female_out}}}\n";  
                        print LITTLE "\\put(160,$male_y){\\scalebox{0.5}{\\includegraphics{$male_out}}}\n";
		        }

                if ( ( $rem eq 19 ) || ( $i eq $end ) ) { print LITTLE "\\end{picture}\n\n"; }

                }
        }






sub print_big_label {
        ($female_out,$male_out,$i,$date,$end) = @_;

        $rem = $i % 10;
        $side = $rem % 2;
        $box = $i + 1;        

#        print "i is $i; rem is $rem; side is $side; box is $box; end is $end\n";

        if ( ( $rem eq 0 ) && ( $i eq 0 ) ) {
                print BIG "\\unitlength=1mm\n\\begin{picture}(204,250)(0,0)\n";
#                print BIG "\\put(0,200){\\framebox(98,47){$box}}\n";
                print BIG "\\put(0,200){\\makebox(98,47){$box}}\n";
                print BIG "\\put(10,242){\\Large{Avery, $date, cross no.}}\n";
                print BIG "\\put(0,217){\\scalebox{0.8}{\\includegraphics{$female_out}}}\n";  
                print BIG "\\put(50,198){\\scalebox{0.8}{\\includegraphics{$male_out}}}\n";
                }


        elsif ( ( $rem eq 0 ) && ( $i ne 0 ) ) {
                print BIG "\\newpage\n\\unitlength=1mm\n\\begin{picture}(204,250)(0,0)\n";
#                print BIG "\\put(0,200){\\framebox(98,47){$box}}\n";
                print BIG "\\put(0,200){\\makebox(98,47){$box}}\n";
                print BIG "\\put(10,242){\\Large{Avery, $date, cross no.}}\n";
                print BIG "\\put(0,217){\\scalebox{0.8}{\\includegraphics{$female_out}}}\n";  
                print BIG "\\put(50,198){\\scalebox{0.8}{\\includegraphics{$male_out}}}\n";
                }



        elsif ( $rem > 0 ) { 


# left side

                if ( $side eq 0 ) {

                        $step = (($rem - 1) /2 ) + 1.5;

                        $base_y = 250 - 50 * $step;
                        $avery_y = $base_y + 42;
                        $female_y = $base_y + 17;
                        $male_y = $base_y - 2;

#                        print BIG "\\put(0,$base_y){\\framebox(98,47){$box}}\n";
                        print BIG "\\put(0,$base_y){\\makebox(98,47){$box}}\n";
                        print BIG "\\put(10,$avery_y){\\Large{Avery, $date, cross no.}}\n";
                        print BIG "\\put(0,$female_y){\\scalebox{0.8}{\\includegraphics{$female_out}}}\n";  
                        print BIG "\\put(50,$male_y){\\scalebox{0.8}{\\includegraphics{$male_out}}}\n";
                        }



# right side

                elsif ( $side eq 1 ) {

                        $step = (($rem - 1) /2 ) + 1;

                        $base_y = 250 - 50 * $step;
                        $avery_y = $base_y + 42;
                        $female_y = $base_y + 17;
                        $male_y = $base_y - 2;


#                        print "in right: rem is $rem; side is $side; step is $step\n";
#                        print "base_y is $base_y; avery_y is $avery_y; date_y is $date_y; female_y is $female_y; male_y is $male_y\n";


#                        print BIG "\\put(107,$base_y){\\framebox(98,47){$box}}\n";
                        print BIG "\\put(107,$base_y){\\makebox(98,47){$box}}\n";
                        print BIG "\\put(117,$avery_y){\\Large{Avery, $date, cross no.}}\n";
                        print BIG "\\put(107,$female_y){\\scalebox{0.5}{\\includegraphics{$female_out}}}\n";  
                        print BIG "\\put(157,$male_y){\\scalebox{0.8}{\\includegraphics{$male_out}}}\n";
		        }

                if ( ( $rem eq 9 ) || ( $i eq $end ) ) { print BIG "\\end{picture}\n\n"; }

                }
        }


