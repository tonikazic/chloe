#!/usr/bin/perl

use MaizeRegEx;

foreach $argnum (0 .. $#ARGV)
{
	opendir(DIR, $ARGV[$argnum]) or die "can't opendir $dirname: $!";
	while (defined($file = readdir(DIR))) {
		next if $file =~ /^\.\.?$/;  # skip . and ..
	    # $file is every file in the directory.  Process.
		open INFILE, $file or die $1;
		
		close INFILE or die $1;
	}
	closedir(DIR);
}
