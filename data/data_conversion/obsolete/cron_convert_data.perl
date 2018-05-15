# this is /athe/c/maize/data/data_conversion/cron_convert_data.perl

# adapted from /athe/c/maize/data/data_conversion/convert_data.perl
#
# the manual script adapted for automated data conversion
# the main difference is to check for a cleaned.X.csv file, process it, and then move it to done.X.csv
# however, now we have to discover the current_crop.  This we do by just reading the prolog fact.
#
# Kazic, 17.7.2014


# This script is built to use our existing convert_*_data.perl script library.  Each script
# in that library takes an input and output file, and assumes that it's called from convert_data.perl.
#
# Now it would be nicer if the script library knows which program is calling it . . . 
# the obvious thing to do is add another argument to the call, and then make each script toggle its
# descriptor based on the argument.
#
# But it would be better to refactor the code into modules, and then let each script call the right
# modules.  After looking at convert_{planted,image,row_status}_data.perl, it doesn't seem that much
# is repeated except the pattern of movement through the array and the gist of the header message.  That
# movement was based on some misunderstanding I had about loading data into the array, and is irksome, but
# maybe not worth the effort to change.  The header message I might factor out as we go through each script in
# the coming crop.
#
# This is a project for another day, I think . . .
#
# Kazic, 4.8.2014




# everything works for me, now someone else must test it!
#
# Kazic, 4.8.3014


# call is:  perl ./cron_convert_data.perl


use File::Find;

use lib qw(../../label_making/);
use Typesetting::DefaultOrgztn;
use Typesetting::MaizeRegEx;


$crop_file = $demeter_dir . "current_crop.pl";







open(CROP,"<$crop_file") or die "can't open current crop file $crop_file\n"; 
while (<CROP>) {
        ($crop) = $_ =~ /^current_crop\(\'(${crop_re})\'\)\./;
        $crop = lc($crop);
        }
close(CROP);







# set up the search path for finding the data files, and log what's been done and any errors
# 
# suggestions at http://www.perlmonks.org/?node_id=857618, including a nice discussion of STDOUT and STDERR


$data_tree = $raw_data_dir . "/" . $crop . "/";

$conversion_log = $data_tree . "data_conversion.log";
$error_log = $data_tree . "data_conversion_errors.log";

                      
open(STDOUT,">>$conversion_log") or die "Can't open data conversion log\n";
open(STDERR,">>$error_log") or die "Can't open data conversion error log\n";

$now = `date`;
chomp($now);

print STDOUT "\n\n\n%%%%%% results of data conversion of $now, check demeter data for errors! %%%%%%\n\n";

print STDERR "\n\n\n%%%%%% results of data conversion of $now, check demeter data for errors! %%%%%%\n\n";






# get the array of cleaned data files that are ready to process
#
# we stuff the files into @files in the subroutine so they can be read in the next step
# note return value of find is ignored, per perl documentation

find(\&get_data_files,$data_tree);





# now form the hash of input, output, and script files, as we do in convert_data.perl

foreach $file ( @files ) {

        chomp($file);
        $head = `head -1 $file`;
        chomp($head);


        ($menu) = $head =~ /\"?dat*e*time\"?,\"?([\w]+)\"?/;
        $target{$file} = $menu;
#        print "\nf: $file\nh: $head\nm: $menu\n\n";
        }







# check that input file can be read and output file can be written; otherwise die
# 
# process the data and rename the processed file so it isn't processed again


for $input_file ( sort keys %target ) {

        $fact = $target{$input_file};


# for the special case of mutant/mutanta

        if ( $fact eq "mutanta" ) { $fact = "mutant"; }

        $out_file = $demeter_dir . $fact . ".pl";
        $script = "convert_" . $fact . "_data.perl";


        if ( -r $input_file ) {
		if ( -w $out_file ) {
                        print "\ni: $input_file o: $out_file s: $script\n";
                        system("perl ./$script $input_file $out_file");
                        $mv_file = $input_file;
                        $mv_file =~ s/cleaned/done/;
                        system("mv $input_file $mv_file");
	                }

                else { die "can't write output file $out_file, check permissions\n"; }
	        }
        else { die "can't read input file $input_file, check permissions\n"; }
        }





close(STDOUT);
close(STDERR);






# find which palms and dump days have unprocessed data and store the names of those files
# in the array @files.  Because the same file name will occur multiple times in the Find, only 
# store the first instance of this file in the array; that 1 is just a true.  
# This array is constructed implicitly and is returned above. 

sub get_data_files { 

        foreach $palm ( @palms ) {

                $partl_dump_dir = $raw_data_dir . "/" . $crop . "/" . $palm . "/";

                if ( ( $File::Find::name =~ /cleaned\./ ) && ( $File::Find::name =~ /\.csv/ ) ) { 

		        if ( exists $sofar{$File::Find::name} ) { 1; }
                        else {
                                $sofar{$File::Find::name} = 1;
                                push(@files,$File::Find::name); 
                                }
		        }
                }
        }


