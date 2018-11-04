#!/opt/perl5/perls/perl-5.26.1/bin/perl

# this is ../c/maize/data/data_conversion/convert_data.perl


# the routing script:  given a crop and dump day, get the data into the right
# prolog files, appending
#
# Kazic, 7.9.2009


# if the spreadsheet produces only ONE file, then there is no need to rename the file
# before running this.
#
# Otherwise, rename each useful csv file with the name of its spreadsheet prior to conversion.
#
# Kelly and Kazic, 4.8.2014


# converted to run in perl 5.26
#
# Kazic, 20.4.2018



# call is:  perl ./convert_data CROP DUMPDAY FLAG
#
# FLAG is "test" --- for just print to screen, don't move anything;
# "q" --- suppress printing to screen, don't move anything;
# or "go" --- print to prolog data file and move the files.
#
# Kazic, 20.4.2018



# directory management fine here already
#
# Kazic, 14.7.2018


use strict;
use warnings;


use File::Basename;

use lib '../../label_making/Typesetting/';
use DefaultOrgztn;



my $crop = $ARGV[0];
my $dump_day = $ARGV[1];
my $flag = $ARGV[2];

my @files;
my %target;




# find which palms have data for that day and store the first line of the dumped data
# to get the menu/fact identification.

foreach my $palm ( @palms ) {
        my $dump_dir = $raw_data_dir . "/" . $crop . "/" . $palm . "/" . $dump_day;


        if ( -e $dump_dir) { 
#                @files = <$dump_dir/*.txt>;
                @files = <$dump_dir/*.csv>;
                foreach my $file ( @files ) { 


# I don't know if phrasing the regular expression this way is faster
# than as alternation (e.g., (done|raw|etc)), but feel this is
# declaratively clearer.   Conditions are ordered by descending frequency
# of occurence (mostly).
# 
# Add additional toggles as needed to mirror the evolving semantics of the workflow.
#
# Kazic, 24.4.2018

                        if ( ( $file !~ /done\./ ) 
                             && ( $file !~ /csv\~$/ ) && ( $file !~ /zip$/ ) && ( $file !~ /org$/ ) 
                             && ( $file !~ /pdf$/ ) 
                             && ( $file !~ /raw\./ ) && ( $file !~ /check\./ ) && ( $file !~ /clean.*\./ ) 
                             && ( $file !~ /correct.*\./ ) && ( $file !~ /safe\./ ) && ( $file !~ /patched\./ ) 
                             && ( $file !~ /bogus\./ ) && ( $file !~ /duped?\./ ) && ( $file !~ /^\d+\./ ) ) {
			        chomp($file);
#			        my $first_two = `head -2 $file`;
                                my $head = `head -1 $file`;
                                chomp($head);


# menu/spreadsheet name is always the last column, unlike datetime
#
# Kazic, 19.5.2017				
#                                ($menu) = $head =~ /\"?dat*e*time\"?,\"?([\w\_]+)\"?/;
				
				 my ($menu) = $head =~ /[\w\d\s,\_]+,(\w+)/;

				
# fixed to handle the mutanta case
# 
# Kazic, 22.9.2014

                                if ( $menu =~ /mutanta+/ ) { $target{$file} = "mutant"; }
			        else { $target{$file} = $menu; }
#                                print "\nf: $file\nh: $head\nm: $menu\nft: $first_two\n\n";
#                                print "\nf: $file\nh: $head\nm: $menu\n\n"; 				
                                }

		        else { print "skipping $file, not ready or already processed\n"; }
		        }

	        }
        else { print "no directory $dump_dir found\n"; }
        }






for my $input_file ( sort keys %target ) {

        my $fact = $target{$input_file};
        
        my $out_file = $demeter_dir . $fact . ".pl";
        my $script = "convert_" . $fact . "_data.perl";


# check that input file can be read and output file can be written; otherwise die
#
# Kazic, 17.7.2014

        if ( -r $input_file ) {
		if ( -w $out_file ) {
                        print "\ni: $input_file o: $out_file s: $script\n";
                        system("perl ./$script $input_file $out_file $flag");


# if perl script succeeds with the right flag, automatically move the file
#
# Kazic, 20.4.2018			
			
                        my $exit_code = $? >> 8;

			if ( $? == -1 ) { print "$script failed on input $input_file\n"; }

                        elsif ( ( $exit_code == 42 ) 
                                && ( ( $flag eq 'q' ) 
                                     || ( $flag eq 'test' ) ) ) { print "nothing moved yet\n"; }

			elsif ( $flag eq 'go' )  {
			        my($stem, $path, $suffix) = fileparse($input_file);
			        my $new_file = $path . "done." . $stem . "$suffix";
			        system("mv $input_file $new_file");
                                print "\n$input_file mved to $new_file\n";
			        }
	                }

                else { die "can't write output file $out_file, check permissions\n"; }
	        }

        else { die "can't read input file $input_file, check permissions\n"; }
        }
