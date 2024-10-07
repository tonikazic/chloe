# this is ../c/maize/label_making/Typesetting/MaizeRegEx.pm

# specifies the standard regular expressions used in the Perl scripts
# and modules
#
# modify to suit your own installation

# a more officially Perl way, but not intended for upload to CPAN
#
# despite the good advice, I use @EXPORT instead of @EXPORT_OK for now to
# simplify refactoring; otherwise all the variable names must be included in the
# import statement of the calling script 
# (see http://perldoc.perl.org/Exporter.html)
#
# Kazic, 5.11.2007


package MaizeRegEx;


use Exporter;

our @ISA = qw(Exporter);
our @EXPORT = qw($palm_re
             $camera_re
             $ipad_re
             $image_re
             $abs_leaf_num_re
             $rel_leaf_num_re
             $section_re
             $conditions_re
             $bug_re
             $note_re
             $instructns_re
             $num_tf_re
             $num_tfxtra_re
             $tf_re
             $blank_re
             $observer_re
             $height_re
             $est_kernel_re
             $cnted_kernel_re
             $dump_day_re
             $datetime_re
             $date_re
             $month_re
             $day_re
             $year_re
             $abbrv_date_re
             $prolog_date_innards_re
             $time_re
             $hour_re
             $pm_re 
             $prolog_date_re
             $prolog_time_re
             $prolog_time_innards_re
             $crop_re
             $planting_re
             $family_re
             $inbred_re
             $knum_re
             $marker_re
             $mutant_family_re
             $nonfun_particle_re
             $nonmutant_particle_re
             $old_num_gtype_re
             $num_gtype_re
             $barcode_elts_re
             $wierd_gtype_re
             $gtype_re
             $full_gtype_re
             $quasi_re
             $inbred_prefix_re
             $file_stem_re
             $ext_re
             $old_rowplant_re
             $rowplant_re
             $rest_re
             $sleeve_re
             $sleeve_bag_re
             $locatn_re
             $box_re
             $pure_packet_re
             $packet_re
             $packet_num_re
             $bag_re
             $pot_re
             $sample_re
             $plain_row_re
             $min_row_re
             $padded_row_re
             $plan_re
             $notes_re
             $row_re
             $cl_re
             $state_or_cl_re
             $word_cl_re
             $fuzzy_cl_re
             $ft_re
             $prow_re
             $pplant_re
             $spaced_plant_re		 
             $ipish_glob_re
             $ear_re
            );

#             $original_family_re






# palms, cameras, notes, people, Booleans

# $palm_re = qr/(alpha|beta|gamma|delta|epsilon)/;
# 
# removed dalet from list, not sure why it was in the palms, think a no-plant tag emergency
#
# Kazic, 17.7.2014
#
# $palm_re = qr/(zeta|eta|theta|dalet)/;
#
$palm_re = qr/(zeta|eta|theta)/;
$camera_re = qr/aleph|bet|gimmel|dalet/;
$ipad_re = qr/anuenue|eheu|fon/;
# $image_re = qr/\d{4}/;
$image_re = qr/\d{1,4}/;
$abs_leaf_num_re = qr/\d{0,2}|unk/;
$rel_leaf_num_re = qr/[etb][\-\+]*\d{1,2}|tassel|plant|row|set rows|unk/;
$section_re = qr/whole|tip|stem|middle|middle1|middle2|stem 1|stem 2|sheath|close-up/;
$conditions_re = qr/[\w\s,\-]+/;
$bug_re = qr/\s*|0|1|2/;
# $note_re = qr/.*/;
$note_re = qr/[\w\_\s\;\.]*/;
# $instructns_re = qr/[\w\s\d\;\_\.\!\-\:\,\?]+/;
$instructns_re = qr/.+/;
$tf_re = qr/[tTrRuUeE]+|[fFaAlLsSeE]+/;
$num_tf_re = qr/1|0/;
$num_tfxtra_re = qr/1|0|4/;
$observer_re = qr/toni|dewi|chimdi|evie|alondra|jang|chris|harperees|josh|mason|avi|linh|derek|wade|amy|hawaiian_research|bill|dylan|matt|clay/;
$blank_re = qr/\s*/;


# Shu-Kai Chang
# Josh Terrana
# Mason Sexton
# Avi Vatsa
# Wade Mayham
# Derek Kelly
# Linh Ngo
# Amy Hauth
# Don Auger
# Huichao Ma
# Fei Wu
# Dylan Raithel
# Clay Young
# Bill Wise
# Toni Kazic



# how tall is that plant?
#
# Kazic, 26.4.2018

$height_re = qr/\d{1,4}\.?\d{0,4}/;



# codes for estimated kernel numbers
#
# Kazic, 28.3.2014

$est_kernel_re = qr/[tqwhex]{1,2}e|fuzzy_cl/;
$cnted_kernel_re = qr/\d{0,3}/;


# dates, times

$dump_day_re = qr/\d{1,2}\.\d{1,2}/;

# $datetime_re = qr/\d{2}\/\d{2}\/\d{4}\s\d{2}\:\d{2}:\d{2}/;
# $datetime_re = qr/\d{1,2}\/\d{1,2}\/\d{2,4}\s\d{1,2}\:\d{1,2}(:\d{1,2}|\s[AP]M)/;
$datetime_re = qr/\d{1,2}\/\d{1,2}\/\d{2,4}\s+\d{1,2}\:\d{1,2}[\:\d\sAPM]+/;
# $date_re = qr/\d{2}\/\d{2}\/\d{4}/;
$date_re = qr/\d{1,2}\/\d{1,2}\/\d{2,4}/;
# $month_re = qr/\d{2}/;
$month_re = qr/\d{1,2}/;
# $day_re = qr/\d{2}/;
$day_re = qr/\d{1,2}/;
$year_re = qr/\d{2,4}/;
$abbrv_date_re = qr/\d{1,2}\.\d{1,2}/;
$prolog_date_innards_re = qr/\d{1,2},\d{1,2},\d{4}/;


# $time_re = qr/\d{2}\:\d{2}:\d{2}/;
# $time_re = qr/\d{1,2}\:\d{1,2}:\d{1,2}/;
$time_re = qr/\d{1,2}\:\d{1,2}[\:\d\sAPM]+/;
# $hour_re = qr/\d{2}/;
$hour_re = qr/\d{1,2}/;
$pm_re = qr/PM/;

$prolog_date_re = qr/date[\d,\(\)]+/;

# was 
# $prolog_time_re = qr/time[\d,\(\)]+/;
#
# Kazic, 16.11.2018
#
$prolog_time_re = qr/time\([\d,]+\)/;
$prolog_time_innards_re = qr/\d{1,2},\d{1,2},\d{1,2}/;



# crops, families, genotypes, K numbers

$crop_re = qr/\d{2}\w/;
# $planting_re = qr/\d{1}/;
#
# to accommodate negative labe plantings
#
# Kazic, 16.4.2024
$planting_re = qr/\-\d{1}/;

$family_re = qr/\d{1,4}/;
$inbred_re = qr/[234567]\d\d/;
$knum_re = qr/(K\d{4,5}|\s{0})/;
# 
# original_family_re changed from {1,4}, but this still isn't good;
# the test is really just if it's numerically below 200.
#
# Kazic, 13.1.08
#
# $original_family_re = qr/[01]*\d*\d/;
#
# this should be better:  at least it shows the first-position padding
# second position frequently 0
#
# Kazic, 18.1.07
#
# $original_family_re = qr/0\d\d\d/;
#
# improved again to eliminate padding zeroes
#
# Kazic, 29.3.08
#
$original_family_re = qr/\d?\d?\d?\d/;
$mutant_family_re = qr/\d{4}/;
#
# added letters for addie's lines
#
# Kazic, 4.8.2023
#
$nonmutant_particle_re = qr/[SWMBLEPFGHXYZ]/;
$nonfun_particle_re = qr/[LEP]/;
#
# this next is not robust:  it is too greedy
#
$in_btwn_re = qr/[\,\"\w\*\-\+\.\/\s\{\}\|\;\(\)\?\^]+/;
# $num_gtype_re = qr/\d{2}\w\d{3,4}\:\w?\w{7}/;
# $num_gtype_re = qr/\d{2}\w\d{3,4}\:\w?[\w\.]+/;
# $num_gtype_re = qr/\d{2}\w\d{3,4}\:\w?[\w\.]*/;
#
# added letters for addie's lines
#
# Kazic, 11.7.2023
#
# $num_gtype_re = qr/\d{2}[RNG]\d{3,4}\:[SWMBEPLIFGHXYZ]?[\w\.]*/;
$num_gtype_re = qr/\d{2}[RNG]\d{3,4}\:[SWMB]?\d+/;
# $num_gtype_re = qr/\w+:\w+/;
$barcode_elts_re = qr/\d{2}[RNG]\d{3,4}\:[SWMBEPLIFGHXYZ]?/;
$old_num_gtype_re = qr/\d{2}[\w\.]{8}/;
$inbred_prefix_re = qr/[SWMBFGHXYZ]/;
$wierd_gtype_re = qr/[\w\-\:\?\*\+\.\/\s\'\;]*/;
$gtype_re = qr/[\w\*\-\+\.\/\s\{\}\|\;\(\)\?\^]*/;
$full_gtype_re = qr/\"?${gtype_re}\"?,\"?${gtype_re}\"?,\"?${gtype_re}\"?,\"?${gtype_re}\"?/;
$marker_re = qr/[\w\*\-\+\.\/\s\{\}\|\;\(\)\?\^\[\]]*/;
$quasi_re = qr/\-?\w{0,6}/;
#
# revised for crops/merge_plan_data.perl.  Single quote may break
# label_making/make_plan_labels.perl, but that script is obsolete.
#
# Kazic, 9.4.2013
#
# $plan_re = qr/[\w\,\;\s\.\-\?]+/;
#
$plan_re = qr/[\w\s\,\;\.\?\!\-\_\']+/;
$notes_re = qr/[\w\s\,\;\:\.\/\?\!\-\_]*/;


# inventory

# added capitals to compensate for numbers up-casing
# the first letter
#
# Kazic, 15.5.2018

$file_stem_re  = qr/[\w\_\s]+/;
$ext_re  = qr/\.\w{3}/;
#
# nb: haven't extensively tested this next on 06R numerical gtypes yet
#
# Kazic, 15.7.2018
#
$old_rowplant_re = qr/\d*I?[\d\.]{4,7}/;
$rowplant_re  = qr/\d{7}$/;
$rest_re  = qr/[\"\:\w\s\-\?\,\/]+/;


# added z to allow for z00000, the ``sleeve'' that ``contains'' either
# the infinite amount of elite corn or the infinite amount of skipped corn
#
# Kazic, 8.9.2019

$sleeve_re  = qr/[vVz]\d{5}/;
$sleeve_bag_re  = qr/[avAV]\d{5}/;
$locatn_re  = qr/[avxAVX]*\d{0,5}/;
$box_re  = qr/[xX]\d{5}/;
$pure_packet_re  = qr/[pP]\d{5}/;
$packet_re  = qr/[ptPT]\d{5}/;
$packet_num_re  = qr/[pP]?\d{1,5}/;
$bag_re  = qr/[aA]\d{5}/;
$pot_re  = qr/[tT]\d{5}/;
$sample_re  = qr/[eE]\d{5}/;
$plain_row_re  = qr/\d+/;
$min_row_re  = qr/\d{3}/;
$padded_row_re  = qr/\d{5}/;
$row_re  = qr/[rR]\d{5}/;
$cl_re = qr/\d{0,3}/;
$word_cl_re = qr/(whole|three_quarter|half|quarter|eighth|sixteenth|inf)/;
$fuzzy_cl_re = qr/[a-z\_]*/;
$state_or_cl_re = qr/[\w\d]+/;
$ft_re = qr/\d{1,3}/;



# plants, ears

$prow_re = qr/\d{5}/;
$pplant_re = qr/\d{2}/;
$spaced_plant_re = qr/\d+[\d\s]*/;
$ipish_glob_re = qr/\d{0,2}[\d\.]*/;
$ear_re = qr/[12]/;


# $_re  = qr//;

1;


