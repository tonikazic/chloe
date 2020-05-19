#!/usr/local/bin/perl

# this is . . ./maize/crops/make_pdf_pedigrees.perl

# given a crop, go to the right place, traverse the pedigree tree, and for each file,
# call enscript FILE -o f.ps ; ps2pdf f.ps FILE.pdf ; rm f.ps.
#
# I would have preferred to do this on the prolog side, but
# enscript can't handle the load.  So do it here instead.
#
# http://www.perlmonks.org/?node_id=217166 is a nice basic tutorial on File::Find.
# 
# Kazic, 26.9.2012

# call is perl ./make_pdf_pedigrees.perl CROP



use File::Find;
use lib qw(../label_making/);
use Typesetting::DefaultOrgztn;

$crop = $ARGV[0];
$pedigree_tree = $crop . $pedigree_root;
$pdf_pedigree_tree = $pdf_pedigree_root;


find(\&build_pdf_tree,$pedigree_tree);
find(\&generate_pdf,$pedigree_tree);
      


# single quotes handle the problem of embedded semi-colons, but still need to fix the 
# problem of files whose names begin -_, e.g., not_useful/-_hsf1.  Enscript crashes
# because it can't find the file.
#
# Kazic, 26.9.2012      








# golly, set up a parallel tree for the pdfs so that iannotate can load these
# correctly from dropbox and save rejiggering.  Use a link in athe from dropbox
# to the correct directory so that I don't have to move files.
#
# the mkdir -p command is from
# http://stackoverflow.com/questions/1050365/how-do-i-create-a-directory-and-parent-directories-in-one-perl-command
#
# I favor the call to the shell rather than File::Path because of Randall Schwartz's comment
# about error behavior if the directories are already created (File::Path whines if so).
#
# Kazic, 9.4.2014


sub build_pdf_tree {

        if ( -d ) {
                $pdf_dir = $pdf_pedigree_tree . $_;
#                print "$pdf_dir\n";
                system("mkdir -p $pdf_dir 2> /dev/null");
	        }
        }





sub generate_pdf {

        if ( -f ) {

                $out = $_;
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

                        $pdf_branch = $File::Find::name;
                        $pdf_branch =~ s/^\-(\_.+)/$1/; 
                        $pdf_branch =~ s/(.+)\_$/$1/; 
                        $pdf_branch =~ s/current/pdf/;
                        $pdf_branch =~ s/\d+\w\/\w+(\/.+)$/\.\.\/\.\.$1/;

                        $pdf = $pdf_branch . ".pdf";

                        if ( ! -e $pdf ) {
                                $cmd = "enscript -r '" . $_ . "' -o f.ps; ps2pdf f.ps '" . $pdf . "'; rm f.ps";
#                                print "cmd is $cmd\n";
                                system($cmd);
		                }
		        }
				
                $out = "";
                $pdf = "";
                $cmd = "";
	        }
        }
