# this is ../c/maize/label_making/Typesetting/DefaultOrgztn.pm

# specifies the standard directory structure and elements for forming
# input and output file names for the scripts.
#
# modify to suit your own installation

# a more officially Perl way, but not intended for upload to CPAN
#
# despite the good advice, I use @EXPORT instead of @EXPORT_OK for now to
# simplify refactoring; otherwise all the variable names must be included in the
# import statement of the calling script 
# (see http://perldoc.perl.org/Exporter.html).
#
# Kazic, 5.11.2007


package DefaultOrgztn;


use lib './Typesetting/';
use MaizeRegEx;




use Exporter;

our @ISA = qw(Exporter);
our @EXPORT = qw(
             adjust_paths
             $crop
             $dir_step
             $demeter_dir
             $dir 
             $input_dir 
             $output_dir 
             $raw_data_dir
             $jumpdir
             $catted_dir
             $planning_root
             $dropbox_root
             $pedigree_root
             $current_pedigrees
             $pdf_pedigrees
             $tmp
             $barcodes 
             $barcode_rel_dir 
             $tex_suffix 
             $ps_suffix 
             $pdf_suffix 
             $esuffix
             $csv_suffix 
             $data_suffix 
             $undupe_suffix
             $surname
             $investigator
             $dept
             $university
             $max_row_length
             @palms
             %menus
             @cameras
             %next_inbred_families
             %bags
             @ear_order
             $proto_inventory_file
             $penult_inventory_file
            );









# use of our:
# https://stackoverflow.com/questions/16472187/perl-global-variables-available-in-all-included-scripts-and-modules


our $crop = $ARGV[0];
our ($dir,$input_dir,$barcodes);





# standard directory tree structure
#
#
# have the following directories with input or output data:
#
# barcodes/$crop
# crops/$crop
# data/palm/raw_data_from_palm/$crop
# demeter
#
#
# called from:
#
# crops/scripts
# data/data_conversion
# label_making


sub adjust_paths { 
        ($crop,$local_dir) = @_;

#        print "ap: $crop,$local_dir\n";

	my $rel_step;
        if ( $local_dir =~ /label_making/ ) { $rel_step = "../"; }
	elsif ($local_dir =~ /scripts/ ) { $rel_step = "../../"; }
	
        if ( $crop =~ /${crop_re}/ ) {
                $dir = "$rel_step" . "crops/$crop";
                $input_dir = "$dir/management/";
                $tags_dir = "$dir/tags/";
                $barcodes = "$rel_step" . "barcodes/$crop/";
                }


        elsif ( $crop =~ /i/ ) {
                $dir = "$rel_step" . "crops/inventory";
                $input_dir = "$dir/crops/inventory/management/";
                $tags_dir = "$dir/crops/inventory/tags/";
                $barcodes = "$rel_step" . "barcodes/inventory/";
                }



	
	return ($dir,$input_dir,$barcodes,$tags_dir);
        }










# new, after rooting crops' scripts in their own subdirectory
#
# Kazic, 13.6.2018
#
#
# the following incorporated into &adjust_paths
#
# Kazic, 2.7.2018
#
# if ( $crop =~ /${crop_re}/ ) {
#         $dir = "../../crops/$crop";
#         $input_dir = "$dir/management/";
#         $barcodes = "../../barcodes/$crop/";
#         }
#
#
# elsif ( $crop =~ /i/ ) {
#         $dir = "../../crops/inventory";
#         $input_dir = "../../crops/inventory/management/";
#         $barcodes = "../../barcodes/inventory/";
#         }
#
#
#
#
#
# old, before rooting all scripts in crops in their own subdirectory
#
# Kazic, 13.6.2018
#
# if ( $crop =~ /${crop_re}/ ) {
#         $dir = "../crops/$crop";
#         $input_dir = "$dir/management/";
#         $barcodes = "../barcodes/$crop/";
#         }
#
#
# elsif ( $crop =~ /i/ ) {
#         $dir = "../crops/inventory";
#         $input_dir = "../crops/inventory/management/";
#         $barcodes = "../barcodes/inventory/";
#         }









# same for both, once the parent branches are determined

$dir_step = "../";
$output_dir = "$dir/tags/";
$barcode_rel_dir = "../../";
$raw_data_dir = "../palm/raw_data_from_palms";
$demeter_dir = "../../demeter/data/";
$jumpdir = "/Volumes/SILVER";
$catted_dir = "catted_files";
$planning_root = "/planning/";
$dropbox_root = "~/Dropbox/corn/";
$pedigree_root = "/planning/current_pedigrees/";
$current_pedigrees = "current_pedigrees/";
$pdf_pedigrees = "pdf_pedigrees/";
$tmp = "tmp";







# standard suffixes

$tex_suffix = ".tex";
$ps_suffix = ".ps";
$pdf_suffix = ".pdf";
$esuffix = ".eps";
$csv_suffix = ".csv";
$data_suffix = "_data.txt";
$unduped_suffix = "_dupes_rmed";


# standard P.I.

$surname = "KAZIC";
$investigator = "T.\\,Kazic";
$dept = "Electrcl Eng and Comp Sci";
$university = "University of Missouri";






# planting organization

# maximum num of characters row can occupy in barcode
# maximum barcode length is 15 characters

$max_row_length = 5;



# data collection hardware and management


# @palms = ("alpha","beta","gamma","delta","epsilon","zeta");
# @palms = ("zeta","eta","theta","dalet");
@palms = ("zeta","eta");

@cameras = ("aleph","bet","gimmel","dalet");




# Mo20W, W23 self families incremented to reflect the shelling of the 09r corn
#
# Kazic, 29.10.09


%next_inbred_families = ("S_self" => 206,
                         "W_self" => 306,
                         "M_self" => 406,
                         "B_self" => 506,
			 "S_sib" => 254,
                         "W_sib" => 354,
                         "M_sib" => 454,
                         "B_sib" => 551,
                        );





# onion bag :: mesh bag colors for types of ears

# next year, use yellow mesh bags for S and red mesh bags for W,
# permute onion bag colors accordingly
#
# Kazic, 22.9.2018

%bags = (
        'S' => 'purple::red::Mo20W females',
        'W' => 'green::yellow::W23 females',
        'M' => 'red::red::M14 females',
        'B' => 'orange::red::B73 females',
        'U' => 'purple::yellow::mutant bulking',
        '@' => 'green::red::back-crossed selves',
        'D' => 'red::yellow::double mutants',
        'P' => 'green::green::fun, test, and open pollinated corn');





@ear_order = ("@","U","S","W","M","B","D","P");





########################## obsolete #####################################



# now obsolete due to revision of Prolog inventory code
#
# Kazic, 1.7.2018


$proto_inventory_file = "$crop/management/proto_inventory";
$penult_inventory_file = "$crop/management/penult_inventory";



# no longer correct; and anyway all menus now self-identify
#
# Kazic, 7.9.2009

%menus = (
        "S01" => "plant_anatomy",
        "S03" => "plant_observation",
        "S04" => "crosses",
        "S06" => "study_plant",
        "S07" => "plant_tassel",
        "S09" => "cross_prep",
        "S10" => "tassel_status",
        "S14" => "images",
        "S18" => "mutants",
        "S19" => "lesions",
        "S20" => "plant_fate",
        "S21" => "leaf_emergence",
        "S22" => "first_extra_tag",
        "S23" => "anomalous_inbred",
        "S24" => "bad_ear",
        "S25" => "tassel_watch_list",
#        "S26" => "good_ear",
        "S26" => "sleeve_inventory",
        "S40" =>  "short_study_plant",
        "S41" =>  "short_next_crop");


#        "S" => "",





1;
