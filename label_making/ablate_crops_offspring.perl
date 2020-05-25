#!/usr/local/bin/perl

# this is /athe/c/maize/ablate_crops_offspring.perl

# Given a directory tree of pedigrees and a crop string, go through each
# pedigree in the tree and remove all lines containg offspring from that crop.
#
# The goal is to generate a parallel pedigree tree that can then be diff'ed against
# a previous version to look for missing pedigree branches.
#
# call is ./ablate_crops_offspring.perl CROP_TO_ABLATE INPUT_PEDIGREE_DIR
#
# where INPUT_PEDIGREE_DIR is relative to /athe/c/maize/crops and ends in current_pedigrees.
#
# rm any previously created directories to be on the safe side
#
# e.g., rm -rf 14r/planning/13r_ablated_pedigrees ; perl ./ablate_crops_offspring.perl 13r 14r/planning/current_pedigrees
#
#
# Once the ablated pedigree tree is constructed, cd to it (or other convenient place) and ask:
#
# diff -B -I '%' -r ../../13r/planning/current_pedigrees 13r_ablated_pedigrees
#
# This will show the differences between the pedigrees constructed for the previous crop and the ablated ones.
# Remember that < is from the first tree and > is from the second.
#
# Kazic, 2.6.2014






# coding notes:
#
# http://perldoc.perl.org/File/Path.html for make_path
# http://perldoc.perl.org/File/Find.html for File::Find
# http://perldoc.perl.org/functions/-X.html for file test operators
#
#
#
# could have used http://search.cpan.org/~rclamp/File-Find-Rule-0.33/lib/File/Find/Rule.pm
# for finding subdirs, but I was too lazy to install File::Find::Rule. 
#
# Its code bits are:
# use File::Find::Rule;
# my @subdirs = File::Find::Rule->directory->in( $old_peds_dir );



 
use File::Path qw(make_path);
use File::Find;



$crop = $ARGV[0];
$ablated = $crop . "_ablated_pedigrees";
$crop = uc($crop);


$today = `$date`;
chomp($today);




$old_peds_dir = $ARGV[1];
if ( $old_peds_dir !~ /\/$/ ) { $old_peds_dir = $old_peds_dir . "/"; }
@old_peds_dir[0] = $old_peds_dir;

find(\&stuff_file_into_array,@old_peds_dir);

foreach $file ( @files ) {

        $new_file = $file;
        $new_file =~ s/current_pedigrees/$ablated/;


# mode 0755 is u+rwx go+rx
# mode 0777 is ugo+rwx

        if ( -d $file ) {
#                print "itsa dir $new_file\n";
                unless ( -e $new_file ) { make_path($new_file, { mode => 0777, }) or die "Can't make output directory $new_file\n"; }
	        }



        elsif ( -f $file ) {
#		print "itsa file $file\n";
                open(OLDF,"<$file") or die "Couldn't open input $file\n";
                open(NEWF,">$new_file") or die "Couldn't open output file $new_file\n";
		
                print NEWF "% this is $new_file\n% generated on $today by /athe/c/maize/crops/ablate_crops_offspring.perl\n% with offspring from $crop removed.\n\n\n";
		
                while (<OLDF>) { 
                        if ( ( $_ =~ /%/ ) || ( $_ =~ /^\n/ ) ) { print NEWF $_; }
                        else { unless ( $_ =~ /$crop/ ) { print NEWF $_; } }
		        }
		
                close(OLDF);
                close(NEWF);
	        }

        else { print "whazziz $file\n"; }

        }




sub stuff_file_into_array { push(@files,$File::Find::name); }
