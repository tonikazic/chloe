#!/usr/local/bin/perl

# this is maize/label_making/make_plan_labels.perl

# generate labels to go on the shipping tags that go on the first plant
# of each row with the plan for that row: to guide activity in the field.
#
# Kazic, 6.7.09


# call is ./make_row_labels CROP


use Typesetting::DefaultOrgztn;
use Typesetting::MaizeRegEx;
use Typesetting::TypesetGenetics;
use Typesetting::TypesettingMisc;
use Typesetting::GenerateOutput;


$crop = $ARGV[0];

 

$input_file = "row_plans.csv";
$input = "$input_dir/$input_file";

$file_stem = "row_plans";
$output = $output_dir . $file_stem . $tex_suffix;



# don't clean the line too early:  need those quote delimiters!

open(IN,"<$input");

while (<IN>) {

        $quasi = "";
        $plan = "";
        $notes = "";



        if ( $_ =~ /^\'?\d+\'?\s/ ) {
                ($row,$ma_num_gtype,$pa_num_gtype,$ma_gma,$ma_gpa,$pa_gma,$pa_gpa,$quasi,$plan,$notes) = $_ =~ /^\'?(${plain_row_re})\'?\s\(\'?(${num_gtype_re})\'?,\'?(${num_gtype_re})\'?,\'?(${gtype_re})\'?,\'?(${gtype_re})\'?,\'?(${gtype_re})\'?,\'?(${gtype_re})\'?,\'?(${quasi_re})\'?,\d+,\'?(${plan_re})\'?,\'?(${notes_re})\'?/;  # \'?
  
#                print "($row,$ma_num_gtype,$pa_num_gtype,$ma_gma,$ma_gpa,$pa_gma,$pa_gpa,$quasi,$plan,$notes)\n";

                $record = $row . "::" . $ma_num_gtype . "::" . $pa_num_gtype . "::" . $ma_gma . "::" . $ma_gpa . "::" . $pa_gma . "::" . $pa_gpa . "::" . $quasi . "::" . $plan . "::" . $notes;

#               print "$record\n"; 

               push(@labels,$record);
	        }
        }

close(IN);




# now have to make the latex files for the labels, moving over @labels

open(TAG,">$output");

&begin_latex_file(\*TAG);

for ( $i = 0; $i <= $#labels; $i++ ) {
        ($row,$ma_num_gtype,$pa_num_gtype,$ma_gma,$ma_gpa,$pa_gma,$pa_gpa,$quasi,$plan,$notes) = split(/::/,$labels[$i]);
        &print_plan_label(\*TAG,$row,$ma_num_gtype,$pa_num_gtype,$ma_gma,$ma_gpa,$pa_gma,$pa_gpa,$quasi,$plan,$notes,$i,$#labels);
        }


&end_latex_file(\*TAG);

close(TAG);


# pdflatex does fine here; no barcodes to worry about!

&generate_pdfl($output_dir,$file_stem);



