#!/opt/perl5/perls/perl-5.26.1/bin/perl


# this is ../c/maize/crops/scripts/make_pdf_pedigrees.perl


# given a crop, go to the right place, traverse the pedigree tree, and for each file,
# call enscript FILE -o f.ps ; ps2pdf f.ps FILE.pdf ; rm f.ps.
#
# I would have preferred to do this on the prolog side, but
# enscript can't handle the load.  So do it here instead.
#
# http://www.perlmonks.org/?node_id=217166 is a nice basic tutorial on File::Find.
# 
# Kazic, 26.9.2012
#
#
# converted to run in perl 5.26
#
# Kazic, 24.5.2018
#
#
# added more flags; retest in 19r
#
# Kazic, 2.12.2018




# call is ./make_pdf_pedigrees.perl CROP FLAG
#
# where CROP is the crop being planned and FLAG is one of {go,q,test}.




use strict;
use warnings;


use Cwd 'getcwd';
use File::Find;
use File::Path 'make_path';
use File::Basename;


use lib '../../label_making/Typesetting/';
use DefaultOrgztn;



# our $crop = $ARGV[0]; in DefaultOrgztn

my $flag = $ARGV[1];
my $local_dir = getcwd;
my ($dir) = &adjust_paths($crop,$local_dir);

if ( $flag eq 'test' ) { print "local_dir: $local_dir\ndir: $dir\n"; }




# nb: the $pedigree_tree directory is relative to the directory in which 
# this script, make_pdf_pedigrees.perl, resides.  After we have cd'ed 
# to the $pedigree_tree directory, its relative path will be incorrect!  
# That's why we use the $curr_dir in the subsequent calls.
#
# Kazic, 13.6.2018


my $curr_dir = getcwd;
my $pedigree_tree = $dir . $pedigree_root;

my $pdf_pedigree_tree = $pedigree_tree;
$pdf_pedigree_tree =~ s/current/pdf/;
my $dropbox_pedigree_root = $dropbox_root . $crop . "/" . $pdf_pedigrees;


if ( $flag eq 'test' ) {
	print "pedigree_tree: $pedigree_tree\n"; 
        print "pdf_pedigree_tree: $pdf_pedigree_tree\ndropbox_pedigree_root: $dropbox_pedigree_root\n"; 
        }








# comments on the perl make_path alternative to mkdir -p command are in 
# http://stackoverflow.com/questions/1050365/how-do-i-create-a-directory-and-parent-directories-in-one-perl-command
#
# test first if the directory exists to avoid dying if it does
# (Randall Schwartz's comment)
#
# Kazic, 9.4.2014


my $pdf_mk_cmd = "mkdir -p $pdf_pedigree_tree 2> /dev/null";
my $dp_mk_cmd = "mkdir -p $dropbox_pedigree_root 2> /dev/null";
if ( $flag eq 'test' ) { print "pdf mkdir: $pdf_mk_cmd\n"; print "dropbox mkdir: $dp_mk_cmd\n"; }



if ( ( $flag eq 'test' ) || ( $flag eq 'go' ) ) {

        if ( ( $flag eq 'go' ) && ( ! -d $pdf_pedigree_tree ) ) { system($pdf_mk_cmd); }
        if ( ( $flag eq 'go' ) && ( ! -d $dropbox_pedigree_root ) ) { system($dp_mk_cmd); }

        find(\&build_pdf_tree,$pedigree_tree);
        find(\&generate_pdf,$pedigree_tree);
        }











# cp -pR files from the pdf tree into Dropbox . . . this preserves the local
# data while updating the shared cloud version.
#
# Kazic, 23.5.2018

chdir $pdf_pedigree_tree;
my $now_dir = getcwd;
my $cp_cmd = "cp -pR * $dropbox_pedigree_root";

if ( $flag eq 'test' ) { print "now in $now_dir\ncp_cmd is $cp_cmd\n"; }
elsif ( $flag eq 'go' ) { system($cp_cmd); }













################# subroutines ######################



# here, I've just used the unix command as it's simpler


# hmm, not creating correct dir names for the pdf pedigrees...
# passing the subdir; get whole name, substitute pdf for current,
# and make that tree
# am I passing in the right directory?  think so
#
# stopped here

sub build_pdf_tree {

        print "bdf top: $_\n";
	
        if ( -d ) {
	        $pdf_pedigree_tree =~ s/current_/pdf_/;
		$pdf_pedigree_tree .= $_;
	        if ( $flag eq 'test' ) { print "lpd: $pdf_pedigree_tree \n"; }
                if ( $flag eq 'go' ) { print "bdt: $pdf_pedigree_tree \n"; system("mkdir -p $pdf_pedigree_tree 2> /dev/null"); }
	        }
        }













# single quotes handle the problem of embedded semi-colons, but still need to fix the 
# problem of files whose names begin -_, e.g., not_useful/-_hsf1.  Enscript crashes
# because it can't find the file.
#
# Kazic, 26.9.2012      
#
#
# Believe this is now fixed.
#
# Kazic, 3.6.2018



sub generate_pdf {
    
        if ( -f ) {

                my $out = $_;
                $out =~ s/^\-(\_.+)/$1/; 
                if ( $out !~ /pdf/ ) {

		    
# I want to say:
#
#                        ($pdf_branch) = $File::Find::name =~ s/current/pdf/;
# 
# but it seems perl doesn't like one to modify the internal variable.  So do it in two steps,
# though it seems kludgy.  Oh, and get rid of the trailing underscores and make the right path
# for the output.
#
# Remember that we are in the current_pedigrees/WHATEVER subdirectory, and so need to go up two 
# and over for the pdf output.

                        my $pdf_branch = $File::Find::name;
                        if ( $flag eq 'test' ) { print "pdfb: $pdf_branch\n"; }


                        $pdf_branch =~ s/current/pdf/;
                        my $pdf = $pdf_branch . ".pdf";

                        if ( $flag eq 'test' ) { print "pdf file: $pdf\n"; }
			
                        if ( ! -e $pdf ) {
                                my $cmd = "enscript -r '" . $_ . "' -o f.ps; ps2pdf f.ps '" . $pdf . "'; rm f.ps";
                                if ( $flag eq 'test' ) { print "cmd is $cmd\n"; }
                                if ( $flag eq 'go' ) { system($cmd); }
			        }
		        }
	        }
        }
