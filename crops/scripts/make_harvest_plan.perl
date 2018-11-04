#!/opt/perl5/perls/perl-5.26.1/bin/perl


# this is ../c/maize/demeter/data/make_harvest_plan.perl
#
# for all pollinations, determine which rows should be harvested when, 
# allowing 40 days after the last pollination in each row
#
# Kazic, 22.8.2012





# call is: perl ./make_harvest_plan.perl CROP DAYS_TO_HARVEST_DATE FLAG
#
# where FLAG is one of {q,test,go}


# modify harvestdoy instructions as needed for special components of the crop, such as
# popcorn, double mutants, and sibs.  Modify bag scheme as needed, too.


# converted to run in perl 5.26 and improved
#
# Kazic, 20.9.2018







use strict;
use warnings;

use Cwd 'getcwd';
use Date::Calc qw(Delta_Days Add_Delta_Days Today Day_of_Year);





use lib '../../label_making/Typesetting/';
use MaizeRegEx;
use DefaultOrgztn;





my $crop_str = uc($crop);
my $days_out = $ARGV[1];
my $flag = $ARGV[2];


my $local_dir = getcwd;
my ($dir,$input_dir) = &adjust_paths($crop,$local_dir);
my $dropbox_dir = $dropbox_root . $crop . '/';


my $today = `date`;
chomp($today);
my ($todayyear,$todaymonth,$todayday) = &Today;
my $todaydoy = Day_of_Year($todayyear,$todaymonth,$todayday);
my ($year,$expharmon,$expharday) = &Add_Delta_Days($todayyear,$todaymonth,$todayday,$days_out);
my $exphardoy = Day_of_Year($year,$expharmon,$expharday);





my $cross_file = $demeter_dir . "cross.pl";
my $harvest_file = $demeter_dir . "row_harvested.pl";
my $plan_file = $input_dir . "harvest_plan";
my $todays_work = $input_dir . $expharday . "." . $expharmon . ".harvest";

if ( $flag eq 'q' ) { print "d: $dir\nc: $cross_file\nh: $harvest_file\np: $plan_file\nt: $todays_work\n"; }





my $marow;
my %rows;
my %harv;
my %type_hash;
my %harvest;
my %todayswork;





open my $harv_fh, '<', $harvest_file or die "sorry, can't open harvest file $harvest_file\n";
open my $plan_fh, '>', $plan_file or die "sorry, can't open plan file $plan_file\n";
open my $today_fh, '>', $todays_work or die "sorry, can't open work file $todays_work\n";








# grab bag plan from DefaultOrgztn
#
# Kazic, 24.8.2018


if ( ( $flag eq 'test' ) || ( $flag eq 'go' ) ) {


        print $plan_fh "% this is $plan_file\n%
% generated by ../c/maize/crops/scripts/make_harvest_plan.perl
% on $today for crop $crop.
%
% \"date range\" is the range of days over which the row was pollinated.
% \"days to harvest\" is the difference between the nominal harvest date and today.
%
% Bags for failed pollinations go in their own mesh bag with a shoot bag with 
% the harvest date on it.
%
%
% Color-coding of onion and mesh bags indicates the types of ears in each bag.  Be
% sure to insert a shoot bag with the harvest date on it in each onion bag!
%
%
% \t                Bag Color Coding Table\n% 
% code \t\t onion bag \t mesh bag \t description
% ---- \t\t --------- \t -------- \t -----------\n";




        foreach my $ear (@ear_order) {
                my $colors = $bags{$ear};
                my ($onion,$mesh,$desc) = split(/::/,$colors);
#                print $plan_fh "%   $ear \t\t $onion \t $mesh \t $desc\n";
                printf $plan_fh "%%  %-14s %-15s %-15s %-15s\n", $ear,$onion,$mesh,$desc;
                }
        }

print $plan_fh "\n\n\n";









# two steps to avoid annoying warning, even though the one-step method
# works

open my $cross_fh, '<', $cross_file or die "sorry, can't open cross file $cross_file\n";
my @foo = <$cross_fh>;
my @crosses = grep { /${crop_str}/ && !/% / } @foo; 


# if ( $flag eq 'test') { foreach my $cross (@crosses) { print "$cross"; } }







foreach my $cross ( @crosses ) {


        my ($ma,$pa,$date,$mindate,$maxdate,$marow,$maplant,$cross_type,$type,$type_so_far,$new_type_so_far,$value,$plants);

	
        ($ma,$pa,$date) = $cross =~ /^cross\(\'(${num_gtype_re})\',\'(${num_gtype_re})\',.+,[trufalse]+,.+,(${prolog_date_re})/;
        chop($date);
 

	
# the inbreds are easy to pick off

        if ( $ma =~ /\:[SWMB]/ ) { ($cross_type,$marow,$maplant) = $ma =~ /\:(\w)?(\d{3,5})(\d{2})/; }


# now sort through inter-mutant crosses

        else {
                my ($ma_rowplant) = $ma =~ /\:0{2,4}(\d{5,6})/;
                my ($pa_rowplant) = $pa =~ /\:0{2,4}(\d{5,6})/;
                ($marow,$maplant) = $ma_rowplant =~ /(\d{1,4})(\d{2})$/;


                if ( $ma_rowplant eq $pa_rowplant ) { $cross_type = "@"; }

                else {
                        my ($parow) = $pa_rowplant =~ /(\d{1,4})\d{2}$/;
                        my ($mafam) = $ma =~ /^\d{2}\w(\d+)\:/;
                        my ($pafam) = $pa =~ /^\d{2}\w(\d+)\:/;
                        if ( ( $marow eq $parow ) || ( $mafam eq $pafam ) ) { $cross_type = "U" }
                        elsif ( $mafam ne $pafam ) { $cross_type = "D"; }
                        }
	        }



        $marow = int($marow);



# postpone evaluation of majority type until after all ears stored
# e.g., bulking rows may contain selves, sibs, and double mutant crosses
#
# Kazic, 23.9.2014
	

        if ( ( exists $rows{$marow} ) && ( $marow ne "0" ) ) {
                my ($mindate,$maxdate,$plants,$type_so_far) = split('::',$rows{$marow});
                if ( $date lt $mindate ) { $mindate = $date; }                         
                if ( $date gt $maxdate ) { $maxdate = $date; }                         
                ++$plants;




# accumulate the type of ear in each row
# types stored as string of the form type=num;


                if ( $type_so_far =~ /$cross_type/ ) {
                        my ($front,$value,$back) = $type_so_far =~ /(^.*$cross_type\=)(\d+)(.*$)/;
                        ++$value;
                        $new_type_so_far = $front . $value . $back;
                        }


                else { $new_type_so_far = $type_so_far . ";" . $cross_type . "=" . 1; }


                $rows{$marow} = $mindate . "::" . $maxdate . "::" . $plants . "::" . $new_type_so_far;
                }                        


	
        elsif ( $marow ne "0" ) { 
                $new_type_so_far = $cross_type . "=" . 1;
                $mindate = $date;
                $maxdate = $date;
                $plants = 1;
		$rows{$marow} = $mindate . "::" . $maxdate . "::" . $plants . "::" . $new_type_so_far;
	        }
        }



# if ( $flag eq 'test' ) { for $marow ( sort { $a <=> $b } keys %rows ) { print "$marow, $rows{$marow}\n"; } }








# We used to collect the harvest data in the field, so as to monitor our
# progress and enable faster crop planning.  But this is too slow now with
# hundreds of ears.  So instead, we harvest, keeping track of what rows
# were harvested when and then collect harvest data in the seed
# room.  It makes harvest a lot faster!
#
# To help with early planning, we put failed ears in their own mesh bag
# and scan those first.
#
# We started this new harvest procedure in 13r.
#
# Kazic, 19.9.2018




my @bar = <$harv_fh>;
my @harv_so_far = grep { /${crop_str}/ && !/% / } @bar;

# if ( $flag eq 'test') { foreach my $harv_so_far (@harv_so_far) { print "hr: $harv_so_far"; } }


# finally, the right one-liner, from Dmitri Lihhatsov's answer in
# https://stackoverflow.com/questions/3652527/match-regex-and-assign-results-in-single-line-of-code/15625858

foreach my $harv_so_far ( @harv_so_far ) {

	my ($harvmarow) = ($harv_so_far =~ /^row_harvested\((${row_re}),/); 

	$harvmarow =~ s/[rR]0+//;
	if ( ( exists $harv{$harvmarow} ) && ( $harvmarow ne "0" ) ) { $harv{$harvmarow} = 1; }
        elsif ( $harvmarow ne "0" ) { $harv{$harvmarow} = 1; }

#       print "h: $harvmarow $harv{$harvmarow}\n";

        }


















# now, for each distinct maxdate, compute the harvest date and compile 
# which rows and their numbers of plants should be harvested on that date.  Sort
# into row order and print out.
#
# this is the complete plan, not today's increment


foreach $marow ( sort ( keys %rows ) ) {

        if ( !exists $harv{$marow} ) {

	
                my ($mindate,$maxdate,$plants,$type,$minday,$minmo,$year,$maxday,$maxmo,$ear_type,$row_type,$range,$harvestmonth,$harvestday,$harvestdoy,$info);
		
		($mindate,$maxdate,$plants,$type) = split(/::/,$rows{$marow});
                ($minday,$minmo,$year) = $mindate =~ /date\((\d+),(\d+),(\d+)/;
                ($maxday,$maxmo) = $maxdate =~ /date\((\d+),(\d+),/;
	


# now read the types into a hash and figure out the majority type
#
# sorting idea from Gabor Szabo [[http://perlmaven.com/how-to-sort-a-hash-in-perl]]
# this returns the key corresponding to the maximum value
#
# the trick relies on the maximum coming last in the sort, overwriting all previous
# values of $row_type


                (%type_hash) = split(/[\;=]/,$type);
	        foreach $ear_type ( sort { $type_hash{$a} <=> $type_hash{$b} } keys %type_hash ) { $row_type = $ear_type; }
	
                $range = &Delta_Days($year,$maxmo,$maxday,$year,$minmo,$minday);
             	
                ($year,$harvestmonth,$harvestday) = &Add_Delta_Days($year,$maxmo,$maxday,40);
		
	        $harvestdoy = Day_of_Year($year,$harvestmonth,$harvestday);
                $info = $plants . "::" . $range . "::" . $row_type;
                $harvest{$harvestdoy}{$marow} = $info;

#               if ( $flag eq 'test' ) {print "$marow,$row_type,$mindate,$maxdate,$plants,$range,$harvestday,$harvestmonth\n"; }
	        }
        }
	





# now write the hash of hashes to $plan_fh

my $total_ears = 0;
my $total_rows = 0;
my $harvestdoy;
my $harvest_days = scalar keys %harvest;
print $plan_fh "% $harvest_days harvest days\n\n\n";

printf $plan_fh "%s %6s %6s %6s %12s %17s %13s %13s\n" ,"harvest date","row","type","ears","date range","days to harvest","ears this day","rows this day";
print $plan_fh "------------------------------------------------------------------------------------------------\n";


        
foreach $harvestdoy ( sort { $a <=> $b } ( keys %harvest ) ) {

	my ($total_ears,$total_rows);
        my ($year,$hmonth,$hday) = Add_Delta_Days($year,1,1, $harvestdoy - 1);
        printf $plan_fh "\n%6d.%0d\n", $hday,$hmonth;


        for $marow ( sort { $a <=> $b } keys %{ $harvest{$harvestdoy} } ) {
                my $info = $harvest{$harvestdoy}{$marow};
                my ($plants,$range,$row_type) = split(/::/,$info);
                my $delayed = &Delta_Days($todayyear,$todaymonth,$todayday,$year,$hmonth,$hday);
                $total_ears += $plants;
                $total_rows += 1;

                printf $plan_fh "%19s%6s%7s%10s%15s\n" ,$marow,$row_type,$plants,$range,$delayed;
	        }
        printf $plan_fh "%74d%14d\n\n",$total_ears,$total_rows;
        }













# now, give us today's work: for each harvestdoy <= exphardoy, for each
# unharvested row, return the same
# information as above, but sorted by type of cross and row, and with the
# color coding alongside.
#
# assume a row has been completely harvested

foreach $harvestdoy ( sort { $a <=> $b } ( keys %harvest ) ) {

	if ( $harvestdoy <= $exphardoy ) { 

                for $marow ( sort { $a <=> $b } keys %{ $harvest{$harvestdoy} } ) {

                        my $info = $harvest{$harvestdoy}{$marow};
                        my ($plants,$range,$row_type) = split(/::/,$info);

			
                        my $ears_harvested;
		        if ( exists $harv{$marow} ) { 
			
                                $ears_harvested = $harv{$marow};

#	     		        print "$marow ($plants,$range,$row_type)\n";
			        }
                        else { $ears_harvested = 0; }


                        if ( $ears_harvested <= $plants ) { 

			        my $colors = $bags{$row_type};
                                my $diff = $harvestdoy - $exphardoy;

                                my $hinfo = $plants . "::" . $colors . "::" . $diff;
			        $todayswork{$row_type}{$marow} = $hinfo;

#                               print "$row_type $marow $diff $hinfo\n";
			        }
		        }
                }
        }









print $today_fh "% this is $todays_work
% generated by ../c/maize/crops/make_harvest_plan.perl
% on $today for crop $crop.
%
% \"days to harvest\" is the difference between the nominal
% harvest date and the expected harvest date 
% of $expharday.$expharmon.\n\n\n";


printf $today_fh "%29s %7s %6s %6s %7s\n" ,"days to","onion","mesh","total","total";
printf $today_fh "%s %5s %7s %10s %6s %6s %6s %7s\n" ,"type","row","ears","harvest","bag","bag","ears","rows";
print $today_fh "-----------------------------------------------------------";



$total_ears = 0;
$total_rows = 0;





# if the crop has no ears of a $row_type, the total will just be repeated

foreach my $row_type (@ear_order) {

        print $today_fh "\n\n";

        foreach $marow ( sort { $a <=> $b } keys %{ $todayswork{$row_type} } ) {


# !exists is the negation of exists :-)

                if ( !exists $harv{$marow} ) { 

                        my $hinfo = $todayswork{$row_type}{$marow};
                        my ($plants,$onion,$mesh,$anon,$diff) = split(/::/,$hinfo);
                        $total_ears += $plants;
                        $total_rows += 1;
		        
#                        print "$row_type, $hinfo\n";
		        
                        printf $today_fh "%2s%8s%6s%10s%11s%7s\n" ,$row_type,$marow,$plants,$diff,$onion,$mesh; 
                        }

	        }

        printf $today_fh "%50d%8d\n\n",$total_ears,$total_rows;

        }









# now enscript and cp the files
#
# untested!
# Kazic, 19.9.2018

my $plan_pdf = $plan_file . '.pdf';    
my $today_pdf = $todays_work . '.pdf';    
my $plan_drop = $plan_pdf =~ s/$input_dir/$dropbox_dir/;
my $today_drop = $today_pdf =~ s/$input_dir/$dropbox_dir/;

system("enscript -r $plan_file -o h.ps ; ps2pdf h.ps $plan_pdf ; rm h.ps ; cp -p $plan_pdf $plan_drop");
system("enscript $todays_work -o h.ps ; ps2pdf h.ps $today_pdf ; rm h.ps ; cp -p $today_pdf $today_drop");
