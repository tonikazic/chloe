# this is ../c/maize/label_making/Typesetting/GenerateOutput.pm

# a set of output commands to produce the final postscript or pdf output

# a more officially Perl way, but not intended for upload to CPAN
#
# despite the good advice, I use @EXPORT instead of @EXPORT_OK for now to
# simplify refactoring; otherwise all the variable names must be included in the
# import statement of the calling script (see http://perldoc.perl.org/Exporter.html)
#
# Kazic, 5.11.2007



package GenerateOutput;




use Exporter;

our @ISA = qw(Exporter);
our @EXPORT = qw(generate_pdf 
                 generate_ps 
                 generate_pdfl 
                 generate_plant_tags 
                 generate_hydro_labels);








sub generate_pdf {
        ($output_dir,$file_stem,$ps_suffix,$pdf_suffix) = @_;

        chdir($output_dir);
        system("latex $file_stem");
        system("dvips $file_stem");
        system("ps2pdf $file_stem" . "$ps_suffix $file_stem" . "$pdf_suffix");
        }




sub generate_ps {
        ($output_dir,$file_stem) = @_;

        chdir($output_dir);
        system("latex $file_stem");
        system("dvips $file_stem");
        }



sub generate_pdfl {
        ($output_dir,$file_stem) = @_;

        chdir($output_dir);
        system("pdflatex $file_stem");
        }



# dvipdf works ok on athe



# use just dvips -t legal, NOT dvips -t landscape -t legal, despite what everyone says!
# at least with the plant_tags margins.
#
# Kazic, 6.1.07

sub generate_plant_tags {
	($output_dir,$tags_stem)= @_;

        chdir($output_dir);
        system("latex $tags_stem ; dvips -t legal $tags_stem");
        }



sub generate_hydro_labels {
	($output_dir,$tags_stem)= @_;

        chdir($output_dir);
        system("latex $tags_stem ; dvips $tags_stem");
        }




# I've never worked out how to get ghostscript to generate landscape pages, despite
# some (not a lot) fiddling and reading.  (It has to be ghostscript, not ps2pdf:  see 
# http://pages.cs.wisc.edu/~ghost/doc/cvs/Ps2pdf.htm#Limitations and
# http://pages.cs.wisc.edu/~ghost/doc/cvs/Language.htm#.setpdfwrite.)
# If anyone knows, I'd be glad to hear it.  Meanwhile, the code below is
# commented out.
#
# What I do in practice is simply open the PostScript file in a PDF viewer
# and print from there.  Some of the viewers are quirky, even in 2007 (see
# The Grumpy Editor's Guide to PDF Viewers, http://lwn.net/Articles/113094/), 
# but Preview on the Mac works very well.
#
# Kazic, 8.11.07
#
#
#        $infile = $tags_stem . $ps_suffix;
#        $outfile = $tags_stem . $pdf_suffix;
#
#        system("gs -q -dSAFER -dNOPAUSE -dBATCH -sOutputFile=$outfile -sPAPERSIZE=legal -c \"<</Orientation 3>> setpagedevice\" -sDEVICE=pdfwrite -c .setpdfwrite -f $infile");





1;
