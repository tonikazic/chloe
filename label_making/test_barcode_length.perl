#!/usr/local/bin/perl

# this is /mnemosyne/a/maize/label_making/test_barcode_length.perl

# are all those barcodes exactly 15 characters??
#
# Kazic, 5.1.07


$input = "barcode_list";



open(IN,"<$input") || die "can't open $input\n";


while (<IN>) {
    chomp($_);

    if ( $_ !~ /.{15}/ ) { print $_; }

        }



close(IN);
