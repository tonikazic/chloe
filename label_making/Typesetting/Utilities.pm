# this is ../c/maize/label_making/Typesetting/Utilities.pm

# a grab bag of little utility subroutines
#
# a more officially Perl way, but not intended for upload to CPAN
#
# despite the good advice, I use @EXPORT instead of @EXPORT_OK for now to
# simplify refactoring; otherwise all the variable names must be included in the
# import statement of the calling script (see http://perldoc.perl.org/Exporter.html)
#
# Kazic, 6.11.2007


package Utilities;

use MaizeRegEx;
use TypesettingMisc;



use Exporter;

our @ISA = qw(Exporter);
our @EXPORT = qw(abbreviate_num_gtypes 
             clean_string 
             make_safe_for_perl 
             literalize 
             de_literalize
            );


sub abbreviate_num_gtypes {
        ($ma_num_gtype,$pa_num_gtype)= @_;

        ($ma_num_gtype) = &abbreviate_num_gtype($ma_num_gtype);
        ($pa_num_gtype) = &abbreviate_num_gtype($pa_num_gtype);
        return($ma_num_gtype,$pa_num_gtype);
        }




sub abbreviate_num_gtype {

        ($num_gtype) = @_;

        $num_gtype =~ s/\w+\:([\w]+)/\1/;
        if ( $num_gtype =~ /${inbred_prefix_re}/ ) { $num_gtype =~ s/\w([\d\.]+)/\1/; }
        ($num_gtype) = &pad_row($num_gtype,8);
        return($num_gtype);
        }




sub clean_string {
        ($string) = @_;

        $string =~ s/,,/,/g;
        $string =~ s/\"//g;
        return $string;
        }




sub make_safe_for_perl {
        ($string) = @_;

        $string =~ s/\?/\\\?/g;        
        $string =~ s/\+/\\\+/g;        
        $string =~ s/\*/\\\*/g;        
        $string =~ s/\(/\\\(/g;        
        $string =~ s/\)/\\\)/g;        
        $string =~ s/\|/\\\|/g;        
        return $string;
        }






# esacpe anything latex needs escaped

sub literalize {

        ($string) = @_;

        $string =~ s/\{/\\\{/g;
        $string =~ s/\}/\\\}/g;
        $string =~ s/\_/\\\_/g;
        return $string;
        }



# make the string safe for latex!

sub de_literalize {

        ($string) = @_;

        $string =~ s/\\+\?/?/g;
        $string =~ s/\\+\+/+/g;
        $string =~ s/\\+\*/*/g;
        $string =~ s/\\+\(/(/g;
        $string =~ s/\\+\)/)/g;
        $string =~ s/\\+\|/|/g;

        return $string;
        }








1;
