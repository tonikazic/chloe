#!/usr/local/bin/perl

# this is ../c/maize/label_making/make_inventory_labels.perl




# generate labels to go on the boxes and the sleeves.  The sleeves 30-up
# labels.  Each one is a separate set of routines, activated by a call from
# the command line.
#
# call for boxes is make_inventory_labels.perl i x STARTBOX ENDBOX FLAG
#
# call for sleeves is make_inventory_labels.perl i v STARTSLEEVE ENDSLEEVE FLAG
#
# call for bags is make_inventory_labels.perl i a STARTBAG ENDBAG FLAG
#
# call for pots is make_inventory_labels.perl i t STARTPOT ENDPOT FLAG
#
# where FLAG is one of {go,q,test}.
#
# Kazic, 24.11.2018
#
# added pots to prevent future greenhouse confusion
#
# Kazic, 14.1.2008




# converted to run in perl 5.26
#
# Kazic, 27.4.2018


use strict;
use warnings;

use Cwd 'getcwd';
use Data::Dumper 'Dumper';
use autovivification;


use lib './Typesetting/';
use DefaultOrgztn;
use OrganizeData;
use TypesetGenetics;
use TypesettingMisc;
use GenerateOutput;



my $type = $ARGV[1];
my $start = $ARGV[2];
my $stop = $ARGV[3];
my $flag = $ARGV[4];



my $local_dir = getcwd;
my ($dir,$input_dir,$barcodes,$tags_dir) = &adjust_paths($crop,$local_dir);
# print "d: $dir\nid: $input_dir\nb: $barcodes\nt:$tags_dir\n";



my $file_stem;
if ( $type eq "x" ) { $file_stem = "box_labels"; }
elsif ( $type eq "v" ) { $file_stem = "sleeve_labels"; }
elsif ( $type eq "a" ) { $file_stem = "bag_labels"; }
elsif ( $type eq "t" ) { $file_stem = "pot_labels"; }


my $input_file = $input_dir . $file_stem . ".csv";
my $output_file = $tags_dir . $file_stem . $tex_suffix;


# if ( $flag eq 'q' ) { print "b: $barcodes\nid: $input_dir\nif: $input_file\nfs: $file_stem\nof: $output_file\n"; }







open my $in, '<', $input_file  or die "can't open $input_file\n";
my (@lines) = grep { $_ !~ /%/ && $_ !~ /^\n/ && $_ !~ /\#/ } <$in>;

my @boxes;
my %tmp;

foreach my $line (@lines) {

	no autovivification;

	if ( $line =~ /^\d+/ ) {
                my ($box,$sleeve,$start,$stop,$comment) = split(/,/,$line);
		chomp(($box,$sleeve,$start,$stop,$comment));
                $start =~ s/\'//g;
                $stop =~ s/\'//g;

		my @record =  ($start,$stop,$comment) ;

		
# simple pushes do the job, but must split into the cases according to
# whether the keys exist or not
		
                if ( !exists $tmp{$box}) {
                        push @{$tmp{$box}}, $sleeve, [ @record ];
 		        }

		else { push @{$tmp{$box}}, $sleeve, [ @record ]; }
	        }
        }


# if ( $flag eq 'q' ) { print Dumper \%tmp; }










# since the box_labels.csv are ordered by sleeve number, there's no need to
# compare them, just grab box start and ends


foreach my $box ( sort { $a <=> $b } ( keys %tmp ) ) {

         my $num_sleeves = $#{$tmp{$box}};	

	 my $last = $#{$tmp{$box}} - 1;
	 my @ref = \@{$tmp{$box}};

		
# need to pluck out boundary elements

        my $first_sleeve = $ref[0][0];
        my $last_sleeve = @{$tmp{$box}}[$last];
        my $first_ma = @{$tmp{$box}}[1]->[0];
        my $last_ma = @{$tmp{$box}}[$num_sleeves]->[1];


# need to grab the comments and crops

	my $comment;
	if ( ( $box eq '0' ) || ( $box eq '20' ) ) { $comment = @{$tmp{$box}}[$num_sleeves]->[2]; }
	else { $comment = ''; }

        my ($first_crop) = $first_ma =~ /^(\w{3})/;
        my ($last_crop) = $last_ma =~ /^(\w{3})/;
		
#        print "bx:  $box  fc: $first_crop  lc: $last_crop  fs: $first_sleeve   ls: $last_sleeve   fm: $first_ma   lm: $last_ma  cm: $comment\n";

	push @boxes, join("::",($box,$first_crop,$last_crop,$first_sleeve,$last_sleeve,$first_ma,$last_ma,$comment));
        }


# foreach my $elt (@boxes) { print "$elt\n"; }











			
my (@labels) = &make_inventory_labels($type,$start,$stop,$crop,\@boxes);
# foreach my $label (@labels ) { print "$label\n"; }






# conversion of old bareword filehandle to lexical and passing that around; see
# https://stackoverflow.com/questions/16539193/how-to-pass-filehandle-as-reference-between-modules-and-subs-in-perl

open my $tag, '>', $output_file or die "can't open tags file $output_file\n";


if ( $type ne "x" ) { &begin_small_label_latex_file($tag); }
else { &begin_box_label_latex_file($tag); }







# nb:  picture not closed properly for non-box labels, but file runs ok
# box labels do close correctly
#
# Kazic, 26.11.2018

for ( my $i = 0; $i <= $#labels; $i++ ) {

        if ( $type eq "x" ) {
                &print_box_label($tag,$i,$#labels,$labels[$i]);
	        }
	
	else {
	        my ($type,$barcode_out,$crop,$box,$comment,$sleeve) = split(/::/,$labels[$i]);
                if ( $type eq "v" ) { &print_sleeve_label($tag,$barcode_out,$sleeve,$i,$#labels); }
                elsif ( $type eq "a" ) { &print_sleeve_label($tag,$barcode_out,$sleeve,$i,$#labels); }
                elsif ( $type eq "t" ) { &print_pot_label($tag,$barcode_out,$sleeve,$i,$#labels); }
                else { print "Warning! missing case in make_inventory_labels.perl\n"; }
	        }
        }


if ( $type eq "x" ) { &end_box_label_latex_file($tag); }
else { &end_latex_file($tag); }





&generate_pdf($tags_dir,$file_stem,$ps_suffix,$pdf_suffix);
