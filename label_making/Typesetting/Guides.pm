# this is ../c/maize/label_making/Typesetting/Guides.pm

# a module of frameboxes for different types of Avery laser printer stock:  
# 2 x 4 inch labels, 1 x 4 inch labels, and business cards.
#
# These assume a picture (204,250).  The reference to the opened file handle is
# passed as the scalar variable.
#
# Each set of parameters has been manually adjusted to fit the labels on the actual 
# Avery stock, so that each box is surrounded by approximately 1 mm on all four sides,
# and so that integers are used for the coordinates.  These boxes are reliable guides
# for the algorithmic placement of typeset material.  DO NOT ALTER THESE VALUES!
#
# Kazic, 2.12.2006




package Guides;






use Exporter;

our @ISA = qw(Exporter);
our @EXPORT = qw(print_big_label_guide_boxes
             print_seed_packet_guide_boxes
             print_business_card_guide_boxes
             print_business_card_guide_lines
             print_partial_business_card_guide_lines
             print_horizontal_row_stake_cutting_lines
             print_little_label_guide_boxes
             print_vertical_row_stake_label_guide_boxes
             print_vertical_row_stake_label_cutting
             print_vertical_row_stake_layout
             print_vertical_row_stake_cutting
             print_plant_tag_guide_boxes
             print_pan_guide_box
             );






# for Avery 2 x 4 inch labels, 10/page (#5163)
#
# delta y = 51
#
# adjusted for teosinte labels, 100% autorotate
#
# Kazic
#
# 16.12.2011

sub print_big_label_guide_boxes {
        ($filehandle) = @_;

        print $filehandle "\\put(-1,225){\\framebox(98,48){1}}\n";
        print $filehandle "\\put(-1,174){\\framebox(98,48){2}}\n";
        print $filehandle "\\put(-1,123){\\framebox(98,48){3}}\n";
        print $filehandle "\\put(-1,72){\\framebox(98,48){4}}\n";
        print $filehandle "\\put(-1,21){\\framebox(98,48){5}}\n";
        print $filehandle "\\put(105,225){\\framebox(98,48){6}}\n";
        print $filehandle "\\put(105,174){\\framebox(98,48){7}}\n";
        print $filehandle "\\put(105,123){\\framebox(98,48){8}}\n";
        print $filehandle "\\put(105,72){\\framebox(98,48){9}}\n";
        print $filehandle "\\put(105,21){\\framebox(98,48){10}}\n";
        }






# for Avery 1 x 2 5/8 inch labels, 30/page (#5160)
#
# Kazic, 4.7.07

# ys adjusted
#
# Kazic, 26.9.07

# 68 = 204/3 x length
# 8 = offset btwn cols

sub print_seed_packet_guide_boxes {
        ($filehandle) = @_;

#	&print_vertical_row_stake_cutting($filehandle);

        print $filehandle "\\put(0,244){\\framebox(64,24){1}}\n";
        print $filehandle "\\put(0,219){\\framebox(64,24){2}}\n";
        print $filehandle "\\put(0,194){\\framebox(64,24){3}}\n";
        print $filehandle "\\put(0,168){\\framebox(64,24){4}}\n";
        print $filehandle "\\put(0,143){\\framebox(64,24){5}}\n";
        print $filehandle "\\put(0,118){\\framebox(64,24){6}}\n";
        print $filehandle "\\put(0,92){\\framebox(64,24){7}}\n";
        print $filehandle "\\put(0,66){\\framebox(64,24){8}}\n";
        print $filehandle "\\put(0,41){\\framebox(64,24){9}}\n";
        print $filehandle "\\put(0,16){\\framebox(64,24){10}}\n";

        print $filehandle "\\put(70,244){\\framebox(64,24){11}}\n";
        print $filehandle "\\put(70,219){\\framebox(64,24){12}}\n";
        print $filehandle "\\put(70,194){\\framebox(64,24){13}}\n";
        print $filehandle "\\put(70,168){\\framebox(64,24){14}}\n";
        print $filehandle "\\put(70,143){\\framebox(64,24){15}}\n";
        print $filehandle "\\put(70,118){\\framebox(64,24){16}}\n";
        print $filehandle "\\put(70,92){\\framebox(64,24){17}}\n";
        print $filehandle "\\put(70,66){\\framebox(64,24){18}}\n";
        print $filehandle "\\put(70,41){\\framebox(64,24){19}}\n";
        print $filehandle "\\put(70,16){\\framebox(64,24){20}}\n";

        print $filehandle "\\put(140,244){\\framebox(64,24){21}}\n";
        print $filehandle "\\put(140,219){\\framebox(64,24){22}}\n";
        print $filehandle "\\put(140,194){\\framebox(64,24){23}}\n";
        print $filehandle "\\put(140,168){\\framebox(64,24){24}}\n";
        print $filehandle "\\put(140,143){\\framebox(64,24){25}}\n";
        print $filehandle "\\put(140,118){\\framebox(64,24){26}}\n";
        print $filehandle "\\put(140,92){\\framebox(64,24){27}}\n";
        print $filehandle "\\put(140,66){\\framebox(64,24){28}}\n";
        print $filehandle "\\put(140,41){\\framebox(64,24){29}}\n";
        print $filehandle "\\put(140,16){\\framebox(64,24){30}}\n";
        }







# for Avery 2 x 3.5 inch business cards, 10/page (#5871)
#
# nb:  these have been slightly adjusted since their printing on actual stock,
# so the ys may be off by a millimeter or so.

sub print_business_card_guide_boxes {
        ($filehandle) = @_;

        print $filehandle "\\put(14,222){\\framebox(86,47){1}}\n";
        print $filehandle "\\put(14,171){\\framebox(86,47){3}}\n";
        print $filehandle "\\put(14,120){\\framebox(86,47){5}}\n";
        print $filehandle "\\put(14,69){\\framebox(86,47){7}}\n";
        print $filehandle "\\put(14,18){\\framebox(86,47){9}}\n";
        print $filehandle "\\put(103,222){\\framebox(86,47){2}}\n";
        print $filehandle "\\put(103,171){\\framebox(86,47){4}}\n";
        print $filehandle "\\put(103,120){\\framebox(86,47){6}}\n";
        print $filehandle "\\put(103,69){\\framebox(86,47){8}}\n";
        print $filehandle "\\put(103,18){\\framebox(86,47){10}}\n";
        }




# want nine little lines to guide the cutting, but want to leave
# them in the margins to reduce the need for precision and also
# to avoid problems with confusing the scanner with those nifty little lines, 
# like what happened in 12n in Hawai'i with the sample tags.
#
# Kazic, 23.5.2014

sub print_partial_business_card_guide_lines {
        ($filehandle) = @_;

        print $filehandle "\\put(14,269){\\line(0,1){15}}\n";
        print $filehandle "\\put(14,18){\\line(0,-1){15}}\n";


# but preserve a full-length center line to give options for cutting

        print $filehandle "\\put(101.5,284){\\line(0,-1){271}}\n";

#        print $filehandle "\\put(101.5,269){\\line(0,1){15}}\n";
#        print $filehandle "\\put(101.5,18){\\line(0,-1){15}}\n";


        print $filehandle "\\put(189,269){\\line(0,1){15}}\n";
        print $filehandle "\\put(189,18){\\line(0,-1){15}}\n";


        print $filehandle "\\put(14,269){\\line(-1,0){15}}\n";
        print $filehandle "\\put(189,269){\\line(1,0){15}}\n";

        print $filehandle "\\put(14,220){\\line(-1,0){15}}\n";
        print $filehandle "\\put(189,220){\\line(1,0){15}}\n";

        print $filehandle "\\put(14,169){\\line(-1,0){15}}\n";
        print $filehandle "\\put(189,169){\\line(1,0){15}}\n";

        print $filehandle "\\put(14,118){\\line(-1,0){15}}\n";
        print $filehandle "\\put(189,118){\\line(1,0){15}}\n";

        print $filehandle "\\put(14,67){\\line(-1,0){15}}\n";
        print $filehandle "\\put(189,67){\\line(1,0){15}}\n";

        print $filehandle "\\put(14,18){\\line(-1,0){15}}\n";
        print $filehandle "\\put(189,18){\\line(1,0){15}}\n";
        }




# want nine little lines to guide the cutting

sub print_business_card_guide_lines {
        ($filehandle) = @_;

        print $filehandle "\\put(14,269){\\line(0,-1){251}}\n";
        print $filehandle "\\put(101.5,269){\\line(0,-1){251}}\n";
        print $filehandle "\\put(189,269){\\line(0,-1){251}}\n";
        print $filehandle "\\put(14,269){\\line(1,0){175}}\n";
        print $filehandle "\\put(14,220){\\line(1,0){175}}\n";
        print $filehandle "\\put(14,169){\\line(1,0){175}}\n";
        print $filehandle "\\put(14,118){\\line(1,0){175}}\n";
        print $filehandle "\\put(14,67){\\line(1,0){175}}\n";
        print $filehandle "\\put(14,18){\\line(1,0){175}}\n";
        }











# for Avery 1 x 4 inch labels, 20/page (#5161)

sub print_little_label_guide_boxes {
        ($filehandle) = @_;

        print $filehandle "\\put(0,246){\\framebox(98,22){1}}\n";
        print $filehandle "\\put(0,221){\\framebox(98,22){2}}\n";
        print $filehandle "\\put(0,196){\\framebox(98,22){3}}\n";
        print $filehandle "\\put(0,170){\\framebox(98,22){4}}\n";
        print $filehandle "\\put(0,145){\\framebox(98,22){5}}\n";
        print $filehandle "\\put(0,119){\\framebox(98,22){6}}\n";
        print $filehandle "\\put(0,94){\\framebox(98,22){7}}\n";
        print $filehandle "\\put(0,68){\\framebox(98,22){8}}\n";
        print $filehandle "\\put(0,43){\\framebox(98,22){9}}\n";
        print $filehandle "\\put(0,18){\\framebox(98,22){10}}\n";

        print $filehandle "\\put(105,246){\\framebox(98,22){11}}\n";
        print $filehandle "\\put(105,221){\\framebox(98,22){12}}\n";
        print $filehandle "\\put(105,196){\\framebox(98,22){13}}\n";
        print $filehandle "\\put(105,170){\\framebox(98,22){14}}\n";
        print $filehandle "\\put(105,145){\\framebox(98,22){15}}\n";
        print $filehandle "\\put(105,119){\\framebox(98,22){16}}\n";
        print $filehandle "\\put(105,94){\\framebox(98,22){17}}\n";
        print $filehandle "\\put(105,68){\\framebox(98,22){18}}\n";
        print $filehandle "\\put(105,43){\\framebox(98,22){19}}\n";
        print $filehandle "\\put(105,18){\\framebox(98,22){20}}\n";
        }









sub print_vertical_row_stake_cutting {
        ($filehandle) = @_;

        print $filehandle "\\put(67,0){\\line(0,1){280}}\n";
        print $filehandle "\\put(137,0){\\line(0,1){280}}\n";

        print $filehandle "\\put(-5,272){\\line(1,0){216}}\n";
        print $filehandle "\\put(-5,246.5){\\line(1,0){216}}\n";
        print $filehandle "\\put(-5,221){\\line(1,0){216}}\n";
        print $filehandle "\\put(-5,195.5){\\line(1,0){216}}\n";
        print $filehandle "\\put(-5,170){\\line(1,0){216}}\n";
        print $filehandle "\\put(-5,145){\\line(1,0){216}}\n";
        print $filehandle "\\put(-5,120){\\line(1,0){216}}\n";
        print $filehandle "\\put(-5,94){\\line(1,0){216}}\n";
        print $filehandle "\\put(-5,68){\\line(1,0){216}}\n";
        print $filehandle "\\put(-5,43){\\line(1,0){216}}\n";
        print $filehandle "\\put(-5,18){\\line(1,0){216}}\n";
        }



















# for Missouri's Printing Services' plant tags, 8/landscape legal page
# each tag is 27mm wide
#
# corrected 30.3.08

# legal is 8.5 x 14 in or 215.9 x 355.6 mm

sub print_plant_tag_guide_boxes {
        ($filehandle) = @_;
 

# print margins on gnomon are 5mm and are fixed; these are tested with the 
# straight-through paper path (both doors open)
#
# Kazic, 7.4.08

        &print_true_margins($filehandle);
#        &print_robust_margins($filehandle);
#        &print_5mm_error_margins($filehandle);


        print $filehandle "\\put(-3,151){\\framebox(25,162){1}}\n";
        print $filehandle "\\put(24,151){\\framebox(25,162){2}}\n";
        print $filehandle "\\put(51,151){\\framebox(25,162){3}}\n";
        print $filehandle "\\put(78,151){\\framebox(25,162){4}}\n";
        print $filehandle "\\put(105,151){\\framebox(25,162){5}}\n";
        print $filehandle "\\put(132,151){\\framebox(25,162){6}}\n";
        print $filehandle "\\put(159,151){\\framebox(25,162){7}}\n";
        print $filehandle "\\put(186,151){\\framebox(25,162){8}}\n";
 
        print $filehandle "\\put(-3,53){\\framebox(25,64){1}}\n";
        print $filehandle "\\put(24,53){\\framebox(25,64){2}}\n";
        print $filehandle "\\put(51,53){\\framebox(25,64){3}}\n";
        print $filehandle "\\put(78,53){\\framebox(25,64){4}}\n";
        print $filehandle "\\put(105,53){\\framebox(25,64){5}}\n";
        print $filehandle "\\put(132,53){\\framebox(25,64){6}}\n";
        print $filehandle "\\put(159,53){\\framebox(25,64){7}}\n";
        print $filehandle "\\put(186,53){\\framebox(25,64){8}}\n";

        print $filehandle "\\put(-3,-14){\\framebox(25,64){1}}\n";
        print $filehandle "\\put(24,-14){\\framebox(25,64){2}}\n";
        print $filehandle "\\put(51,-14){\\framebox(25,64){3}}\n";
        print $filehandle "\\put(78,-14){\\framebox(25,64){4}}\n";
        print $filehandle "\\put(105,-14){\\framebox(25,64){5}}\n";
        print $filehandle "\\put(132,-14){\\framebox(25,64){6}}\n";
        print $filehandle "\\put(159,-14){\\framebox(25,64){7}}\n";
        print $filehandle "\\put(186,-14){\\framebox(25,64){8}}\n";
        }






# need to test these on the printer; ok on screen
#
# Kazic, 7.4.08
#
# adjusted 27.4.08


sub print_true_margins {
       ($filehandle) = @_;
        print $filehandle "\\put(-1.75,-11.75){\\rule{5mm}{355.6mm}}\n";
        print $filehandle "\\put(-3.25,-9.75){\\rule{216mm}{5mm}}\n";
        print $filehandle "\\put(-3.25,336.5){\\rule{216mm}{5mm}}\n";
        print $filehandle "\\put(205,-11.75){\\rule{5mm}{355.6mm}}\n";
        }




# 7mm margins, to allow for both print margins and significant feed errors

sub print_robust_margins {
       ($filehandle) = @_;
        print $filehandle "\\put(-3.25,-11.75){\\rule{7mm}{355.6mm}}\n";
        print $filehandle "\\put(-3.25,-11.75){\\rule{216mm}{7mm}}\n";
        print $filehandle "\\put(-3.25,336.5){\\rule{216mm}{7mm}}\n";
        print $filehandle "\\put(205.25,-11.75){\\rule{7mm}{355.6mm}}\n";
        }





# need to test these on the printer; ok on screen; indented 5 on each coordinate
# to test precise placement, since when the true margins are printed they will be
# invisible!
#
# Kazic, 7.4.08


sub print_5mm_error_margins {
       ($filehandle) = @_;
        print $filehandle "\\put(1.75,-6.75){\\rule{5mm}{355.6mm}}\n";
        print $filehandle "\\put(1.75,-6.75){\\rule{216mm}{5mm}}\n";
        print $filehandle "\\put(1.75,327.5){\\rule{216mm}{5mm}}\n";
        print $filehandle "\\put(200.25,-6.75){\\rule{5mm}{355.6mm}}\n";
        }



# similiar subroutines for different feed errors would be useful
#
# Kazic, 7.4.08







# for counting pan inserts
#
# must re-measure pan; these coordinates are not quite correct
#
# Kazic, 27.4.08


sub print_pan_guide_box {
        ($filehandle) = @_;

        print $filehandle "\\put(0,20){\\line(1,0){190}}\n";
        print $filehandle "\\put(0,20){\\line(1,2){120}}\n";
        print $filehandle "\\put(190,20){\\line(-1,2){120}}\n";
        print $filehandle "\\put(82,182){\\line(1,0){49}}\n";
        }








########## obsolete




# to cut two row stake labels from one Avery 2 x 4 inch label in
# preparation for lamination

sub old_print_vertical_row_stake_label_cutting {
        ($filehandle) = @_;

        print $filehandle "\\put(0,250){\\line(1,0){200}}\n";
        print $filehandle "\\put(0,240){\\line(1,0){200}}\n";

        print $filehandle "\\put(0,199){\\line(1,0){200}}\n";
        print $filehandle "\\put(0,189){\\line(1,0){200}}\n";

        print $filehandle "\\put(0,148){\\line(1,0){200}}\n";
        print $filehandle "\\put(0,138){\\line(1,0){200}}\n";

        print $filehandle "\\put(0,97){\\line(1,0){200}}\n";
        print $filehandle "\\put(0,87){\\line(1,0){200}}\n";

        print $filehandle "\\put(0,46){\\line(1,0){200}}\n";
        print $filehandle "\\put(0,36){\\line(1,0){200}}\n";
        }



sub old_print_vertical_row_stake_cutting {
        ($filehandle) = @_;

        print $filehandle "\\put(102,0){\\line(0,1){280}}\n";

        print $filehandle "\\put(-5,254.6){\\line(1,0){216}}\n";
        print $filehandle "\\put(-5,229.2){\\line(1,0){216}}\n";
        print $filehandle "\\put(-5,203.8){\\line(1,0){216}}\n";
        print $filehandle "\\put(-5,178.4){\\line(1,0){216}}\n";
        print $filehandle "\\put(-5,153){\\line(1,0){216}}\n";
        print $filehandle "\\put(-5,127.6){\\line(1,0){216}}\n";
        print $filehandle "\\put(-5,102.2){\\line(1,0){216}}\n";
        print $filehandle "\\put(-5,76.8){\\line(1,0){216}}\n";
        print $filehandle "\\put(-5,51.4){\\line(1,0){216}}\n";
        print $filehandle "\\put(-5,26){\\line(1,0){216}}\n";
        }







# for Avery 2 x 4 inch labels, cut into the individual labels
# for the stakes; want the individual labels to be 0.75 inch wide
# to fit nicely on the stakes, once laminated
#
# Kazic, 27.4.08

sub print_vertical_row_stake_label_guide_boxes {
        ($filehandle) = @_;


#        print $filehandle "\\put(0,221){\\framebox(98,48){1}}\n";
        print $filehandle "\\put(0,250){\\framebox(98,19){1u}}\n";
        print $filehandle "\\put(0,221){\\framebox(98,19){1l}}\n";

#        print $filehandle "\\put(0,170){\\framebox(98,48){2}}\n";
        print $filehandle "\\put(0,199){\\framebox(98,19){2u}}\n";
        print $filehandle "\\put(0,170){\\framebox(98,19){2l}}\n";

#        print $filehandle "\\put(0,119){\\framebox(98,48){3}}\n";
        print $filehandle "\\put(0,148){\\framebox(98,19){3u}}\n";
        print $filehandle "\\put(0,119){\\framebox(98,19){3l}}\n";

#        print $filehandle "\\put(0,68){\\framebox(98,48){4}}\n";
        print $filehandle "\\put(0,97){\\framebox(98,19){4u}}\n";
        print $filehandle "\\put(0,68){\\framebox(98,19){4l}}\n";

#        print $filehandle "\\put(0,17){\\framebox(98,48){5}}\n";
        print $filehandle "\\put(0,46){\\framebox(98,19){5u}}\n";
        print $filehandle "\\put(0,17){\\framebox(98,19){5l}}\n";

#        print $filehandle "\\put(106,221){\\framebox(98,48){6}}\n";
        print $filehandle "\\put(106,250){\\framebox(98,19){6u}}\n";
        print $filehandle "\\put(106,221){\\framebox(98,19){6l}}\n";

#        print $filehandle "\\put(106,170){\\framebox(98,48){7}}\n";
        print $filehandle "\\put(106,199){\\framebox(98,19){7u}}\n";
        print $filehandle "\\put(106,170){\\framebox(98,19){7l}}\n";

#        print $filehandle "\\put(106,119){\\framebox(98,48){8}}\n";
        print $filehandle "\\put(106,148){\\framebox(98,19){8u}}\n";
        print $filehandle "\\put(106,119){\\framebox(98,19){8l}}\n";

#        print $filehandle "\\put(106,68){\\framebox(98,48){9}}\n";
        print $filehandle "\\put(106,97){\\framebox(98,19){9u}}\n";
        print $filehandle "\\put(106,68){\\framebox(98,19){9l}}\n";

#        print $filehandle "\\put(106,17){\\framebox(98,48){10}}\n";
        print $filehandle "\\put(106,46){\\framebox(98,19){10u}}\n";
        print $filehandle "\\put(106,17){\\framebox(98,19){10l}}\n";
        }








# need to print templates for sticking labels on the lamination sheets and
# for cutting the laminated labels
#
# test on physical stock!
#
# Kazic, 27.4.08

sub print_vertical_row_stake_layout {
        ($filehandle) = @_;

        &print_vertical_row_stake_cutting($filehandle);

        print $filehandle "\\put(-1,258){\\framebox(98,19){1u}}\n";
        print $filehandle "\\put(-1,232){\\framebox(98,19){1l}}\n";
        print $filehandle "\\put(-1,206){\\framebox(98,19){2u}}\n";
        print $filehandle "\\put(-1,181){\\framebox(98,19){2l}}\n";
        print $filehandle "\\put(-1,156){\\framebox(98,19){3u}}\n";
        print $filehandle "\\put(-1,130){\\framebox(98,19){3l}}\n";
        print $filehandle "\\put(-1,105){\\framebox(98,19){4u}}\n";
        print $filehandle "\\put(-1,79){\\framebox(98,19){4l}}\n";
        print $filehandle "\\put(-1,54){\\framebox(98,19){5u}}\n";
        print $filehandle "\\put(-1,29){\\framebox(98,19){5l}}\n";
        print $filehandle "\\put(-1,4){\\framebox(98,19){5x}}\n";


        print $filehandle "\\put(106,258){\\framebox(98,19){6u}}\n";
        print $filehandle "\\put(106,232){\\framebox(98,19){6l}}\n";
        print $filehandle "\\put(106,206){\\framebox(98,19){7u}}\n";
        print $filehandle "\\put(106,181){\\framebox(98,19){7l}}\n";
        print $filehandle "\\put(106,156){\\framebox(98,19){8u}}\n";
        print $filehandle "\\put(106,130){\\framebox(98,19){8l}}\n";
        print $filehandle "\\put(106,105){\\framebox(98,19){9u}}\n";
        print $filehandle "\\put(106,79){\\framebox(98,19){9l}}\n";
        print $filehandle "\\put(106,54){\\framebox(98,19){10u}}\n";
        print $filehandle "\\put(106,29){\\framebox(98,19){10l}}\n";
        print $filehandle "\\put(106,4){\\framebox(98,19){10x}}\n";
        }





sub print_horizontal_row_stake_cutting_lines {
        ($filehandle) = @_;


# vertical rules
#
	print $filehandle "\\put(0,50){\\rule{0.1mm}{232mm}}\n";
	print $filehandle "\\put(40,50){\\rule{0.1mm}{232mm}}\n";
	print $filehandle "\\put(80,50){\\rule{0.1mm}{232mm}}\n";
	print $filehandle "\\put(120,50){\\rule{0.1mm}{232mm}}\n";
	print $filehandle "\\put(160,50){\\rule{0.1mm}{232mm}}\n";
	print $filehandle "\\put(200,50){\\rule{0.1mm}{232mm}}\n";



# horizontal rules
#
	print $filehandle "\\put(0,282){\\rule{200mm}{0.1mm}}\n";
	print $filehandle "\\put(0,224){\\rule{200mm}{0.1mm}}\n";
	print $filehandle "\\put(0,166){\\rule{200mm}{0.1mm}}\n";
	print $filehandle "\\put(0,108){\\rule{200mm}{0.1mm}}\n";
	print $filehandle "\\put(0,50){\\rule{200mm}{0.1mm}}\n";
        }




1;
