#!/usr/bin/perl

# this is maize/label_making/make_extra_male_tags.perl

# generate the equivalent of tear-off tags for those that we don't expect
# to have on pollination bags because that plant was used more than thrice.
#
# input file is full plantIds, one per line, sorted by rowplant for convenience
#
# over 30-up labels
#
# Kazic and Ngo, 15.10.2014

# call is ./make_extra_male_tags.perl CROP



use Typesetting::DefaultOrgztn;
use Typesetting::OrganizeData;
use Typesetting::TypesetGenetics;
use Typesetting::TypesettingMisc;
use Typesetting::GenerateOutput;
use autovivification;


no autovivification;
 



$input_file = "all_males_crossed";
$file_stem = "extra_tags";



$input = $input_dir . $input_file;
$output = $output_dir . $file_stem . $tex_suffix;


$num_gtype_re = qr/[\w\:\.\-\s\;\?]{15}/;
$in_btwn_re = qr/[\w\*\-\+\.\/\s\{\}\|\;\(\)\?\^\,]*/;

$crop =~ tr/[a-z]/[A-Z]/;

undef %plants;



open(IN,"<$input") || die "can't open input $input\n";



# this works correctly, but right now I am too stupid to understand the counting
#
# Kazic, 15.10.2014

while (<IN>) {

        chomp($_);
        $_ =~ s/\"//g;	        
        $_ =~ s/,,/,/g;


        if ( ( $_ =~ /$crop/ ) && ( $_ !~ /\%/ ) ) { 
                my $plant = $_;


# 4th and later hits put us here . . . but why the 4th?
#
# Kazic, 15.10.2014

                if ( ( exists $plants{$plant} ) && ( $plants{$plant} > 2 ) ) {

                        my $value = $plants{$plant};
			my $barcode_out = &make_barcodes($barcodes,$plant,$esuffix);
			my $record = $barcode_out  . "::" . $plant . "::" . $value;

#                        print "$record\n";
			push(@labels,$record);

                        $value++;
                        $plants{$plant} = $value;
#                        print "cnd3\n";
		        }


# here is the puzzle; hitting a plantID the third time still puts us in
# this condition.  Why?
#
# Kazic, 15.10.2014


                elsif ( ( exists $plants{$plant} ) && ( $plants{$plant} <= 2 ) ) {
                        my $value = $plants{$plant};
                        $value++;
                        $plants{$plant} = $value;
#                        print "cnd2\n";
                        }

                elsif ( !exists $plants{$plant} ) { $plants{$plant} = 1; } # print "cnd0\n"; }

                else { print "ha\n!"; }

#		print "$plant $plants{$plant}\n";

	        }
        }

close(IN);


# for ( $i = 0 ; $i <= $#labels; $i++ ) { print "$labels[$i]\n"; }





# now have to make the latex files for the labels, moving over @labels

# print "out is $output\n\n **************************** \n\n";

open(TAG,">$output");



# discard any trailing arguments

&begin_latex_file(\*TAG);

for ( $i = 0; $i <= $#labels; $i++ ) {
        ($barcode_out,$needed_num_gtype) = split(/::/,$labels[$i]);
        &print_tear_off_tag(\*TAG,$barcode_out,$needed_num_gtype,$i,$#labels);
        }

&end_latex_file(\*TAG);

close(TAG);


&generate_pdf($output_dir,$file_stem,$ps_suffix,$pdf_suffix);

