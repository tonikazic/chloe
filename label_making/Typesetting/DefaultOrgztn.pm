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
our @EXPORT = qw($crop
             $dir_step
             $demeter_dir
             $dir 
             $input_dir 
             $output_dir 
             $raw_data_dir
             $jumpdir
             $catted_dir
             $pedigree_root
             $pdf_pedigree_root
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






# standard directory tree structure

$crop = $ARGV[0];

if ( $crop =~ /${crop_re}/ ) {
        $dir = "../crops/$crop";
        $input_dir = "$dir/management/";
        $barcodes = "../barcodes/$crop/";
        }


elsif ( $crop =~ /i/ ) {
        $dir = "../crops/inventory";
        $input_dir = "../crops/inventory/management/";
        $barcodes = "../barcodes/inventory/";
        }


# same for both, once the parent branches are determined

$dir_step = "../";
$output_dir = "$dir/tags/";
$barcode_rel_dir = "../../";
$raw_data_dir = "../palm/raw_data_from_palms";
$demeter_dir = "../../demeter/data/";
$jumpdir = "/Volumes/SILVER";
$catted_dir = "catted_files";
$pedigree_root = "/planning/current_pedigrees/";
$pdf_pedigree_root = "../pdf_pedigrees/";
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
$dept = "Computer Science";
$university = "University of Missouri";






# planting organization

# maximum num of characters row can occupy in barcode
# maximum barcode length is 15 characters

$max_row_length = 5;



# data collection hardware and management


# @palms = ("alpha","beta","gamma","delta","epsilon","zeta");
@palms = ("zeta","eta","theta","dalet");

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
#
# "D" is for corn in one of David Braun's fields

%bags = (
        'S' => 'purple::yellow',
        'W' => 'green::yellow',
        'M' => 'red::yellow',
        'B' => 'white::red',
        'U' => 'purple::red',
        'D' => 'red::green',
        '@' => 'green::red',
        'P' => 'purple::green');





@ear_order = ("S","W","M","B","U","D","@","P");






# no longer correct; and anyway all menus now self-identify
#
# Kazic, 7.9.09

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





$proto_inventory_file = "$crop/management/proto_inventory";
$penult_inventory_file = "$crop/management/penult_inventory";




1;
