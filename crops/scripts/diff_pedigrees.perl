# this is ../work/maize/crops/diff_pedigrees.perl


# given a crop and two standard trees, check each file in one tree
# against its recomputed analogue in the other.
#
# Kazic, 3.5.2012

# call:  perl ./diff_pedigrees CROP
#
# ABANDONED:  diff -r works well enough!
#
# Kazic, 3.5.2012


use lib qw(../label_making/);
use Typesetting::DefaultOrgztn;


$crop = $ARGV[0];

$old_peds_dir = $crop . "/planning/old/";
$new_peds_dir = $crop . "/planning/new/";



opendir(OLD,$old_peds_dir) || die "Couldn't open $old_peds_dir\n";
my @files = grep { !/^\./ } readdir(OLD);
closedir(OLD);


foreach $file ( @files ) {

        chomp($file);
        $old = $old_peds_dir . $file;
        $new = $new_peds_dir . $file;


        open(TMPO,">tmpo");
        open(OLDF,"<$old") || die "Couldn't open $old\n";
        while (<OLDF>) { 
                if ( $_ !~ /%/ ) { print TMPO $_; }
	        }
        close(OLDF);
        close(TMPO);


        open(TMPN,">tmpn");
        open(NEWF,"<$new") || die "Couldn't open $old\n";
        while (<NEWF>) { 
                if ( $_ !~ /%/ ) { print TMPO $_; }
	        }
        close(NEWF);
        close(TMPN);



# diff -B -q -r
        }

