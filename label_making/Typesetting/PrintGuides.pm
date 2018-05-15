# this is ../c/maize/label_making/Typesetting/PrintGuides.pm

# this manages the generation of the latex output files, using a reference
# to the opened filehandle.  
#
# As new types of media are added to Guides.pm, their conditionals must be added.
#
# Kazic, 5.11.2007


package PrintGuides;

use Guides;
use TypesettingMisc;





use Exporter;

our @ISA = qw(Exporter);
our @EXPORT = qw(print_guides);








# for calling from the command line; printing inside other subroutines
# calls the cited subroutines directly
#
# Kazic, 12.11.07

sub print_guides {
        ($type,$tags) = @_;

        open(TAG,">$tags");

        &begin_latex_file(\*TAG);
        &begin_picture(\*TAG);

        if ( $type eq "seed_packet" ) { &print_seed_packet_guide_boxes(\*TAG); }
        elsif ( $type eq "big_label" ) { &print_big_label_guide_boxes(\*TAG); }
        elsif ( $type eq "little_label" ) { &print_little_label_guide_boxes(\*TAG); }
        elsif ( $type eq "business_card" ) { &print_business_card_guide_boxes(\*TAG); }
        elsif ( $type eq "partial_business_card" ) { &print_partial_business_card_guide_lines(\*TAG); }
        elsif ( $type eq "plant_tag" ) { &print_plant_tag_guide_boxes(\*TAG); }

        &end_picture(\*TAG);
        &end_latex_file(\*TAG);
        close(TAG);
        }




1;
