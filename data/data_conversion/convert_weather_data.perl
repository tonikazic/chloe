#!/usr/bin/perl

# this is maize/data/data_conversion/convert_weather_data.perl

# a quick script to convert the South Farms hourly weather summary to weather/11
# and generate a flat file suitable for reading into R with the command:
#
# wea <- read.table("WHATEVER.csv",header=TRUE,sep=",",comment.char="#")
#
#
# BE CAREFUL!  This script APPENDS to pre-existing files, so tail the output to know
# where to start the next increment.
#
# Kazic, 31.5.2011


# call is perl ./convert_weather_data.perl FILE


# for now I have stuffed all the subroutines in the Typesetting subdirectory.  The 
# first line ("lib") references that easily

use lib qw(../../label_making/);
use Typesetting::DefaultOrgztn;
use Typesetting::ConvertPalmData;




$input_file = $ARGV[0];
$out_file = $demeter_dir . "weather.pl";
$Rout_file = $ARGV[0];
$Rout_file =~ s/txt/csv/;
print "$Rout_file\n";


$now = `date`;
chomp($now);


open(OUT,">>$out_file");
print OUT "\n\n\n\n% data added from $input_file on $now\n% by data/data_conversion/convert_weather_data.perl\n\n\n";



open(ROUT,">>$Rout_file");
print ROUT "\n\n\n\n# data added from $input_file on $now\n# by data/data_conversion/convert_weather_data.perl\n\n\n";
print ROUT "datetime,airtemp,twosoil,foursoil,eightsoil,twtysoil,precip,relhum,windsp,windir,solarad\n";


open(IN,"<$input_file") || die "sorry, can't open input file $input_file\n";

while (<IN>) {

        if ( ( $_ =~ /^\s+\d+/ ) && ( $_ !~ /IN./ ) ) {


                ($month,$day,$year,$hour,$precip,$airtemp,$relhum,$windsp,$windir,$solarad,$twosoil,$foursoil,$eightsoil,$twtysoil) = $_ =~ /^\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+([\d\.]+)\s+([\d\.]+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+([\d\.]+)\s+([\d\.]+)\s+([\d\.]+)\s+([\d\.]+)\s+$/;

#                print "($month,$day,$year,$hour,$precip,$airtemp,$relhum,$windsp,$windir,$solarad,$twosoil,$foursoil,$eightsoil,$twtysoil)\n";


                ($date,$time,$Rdatetime) = &convert_south_farms_datetime($month,$day,$year,$hour);


                print OUT "weather(temp($airtemp,air,'F'),temp($twosoil,soil2in,'F'),temp($foursoil,soil4in,'F'),temp($eightsoil,soil8in,'F'),temp($twtysoil,soil20in,'F'),precip($precip,in),relhum($relhum,percent),wind($windsp,mph,$windir,deg),solar_rad($solarad,watts_per_sq_m),$date,$time).\n";

                print ROUT "$Rdatetime,$airtemp,$twosoil,$foursoil,$eightsoil,$twtysoil,$precip,$relhum,$windsp,$windir,$solarad\n";


	         }
         }



close(IN);
close(OUT);
close(ROUT);
