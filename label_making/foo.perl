#!/opt/perl5/perls/perl-5.26.1/bin/perl


use strict;
use warnings;


use lib './Typesetting/';
use DefaultOrgztn;



my $crop = $ARGV[0];
my $num_rows = $ARGV[1];





# array of labels needed now in $input_file, which lives in 
# ../crops/inventory/management.  Each row on a single line,
# no commas or r00 or array machinery.
#
# Kazic, 22.5.2014


my $input_stem = "18r_more_row_stakes.csv";
# my $input_stem = "18r_foo_row_stakes";
my $input_file = $input_dir . $input_stem;

my @labels_needed;






open my $in, '<', $input_file or die "can't open $input_file\n";
while (<$in>) {
        chomp($_);
    print length($_) . "\n";
        push(@labels_needed,$_);
        }




foreach my $foo (@labels_needed) {
    my $len = length($foo);
    my $bar = 6 - $len;
#    print "$foo $len $bar\n";
#    print "$foo\n";
}
