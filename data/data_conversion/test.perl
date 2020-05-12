#!foobar



use strict;
use warnings;
use feature 'say';



use lib '../../label_making/Typesetting/';
use DefaultOrgztn;
use OrganizeData;
use MaizeRegEx;
use NoteExpsn;
use ConvertPalmData;




my $input_file = $ARGV[0];
my $out_file = $ARGV[1];
my $flag = $ARGV[2];


my $row_harvested_file = $demeter_dir . "row_harvested.pl";
my %rowh;


my ($crop) = &grab_crop_from_file($input_file);


open my $rowhfh, '<', $row_harvested_file or die "sorry, can't open cross file $row_harvested_file\n";
my @this_crops_rows = grep  { $_ =~ /${crop}/ && $_ =~ /^row_harvested/ && $_ !~ /\%/ } <$rowhfh> ;

# foreach my $elt  (@this_crops_rows) { print "$elt"; }



foreach my $elt (@this_crops_rows) {
	my ($row,$date,$time) = $elt =~ /^row_harvested\((${row_re}),\w+,(${prolog_date_re}),(${prolog_time_re}),/;
	$row =~ s/[rR]//;
	$rowh{$row} = $date . "," . $time;
        } 

say join "\n", %rowh;


