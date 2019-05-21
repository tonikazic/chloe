# this is ../c/maize/label_making/Typesetting/NoteExpsn.pm

# gives simple context-free string substitutions for the various
# note-like fields in the palm menus, e.g. notes in nam and other phe in
# mutant/mutanta
#
# Kazic, 6.9.2009



package NoteExpsn;




use Exporter;

our @ISA = qw(Exporter);
our @EXPORT = qw(
             expand_note
             );









# problems with regular expression around cl and yellow; involves spaces and insertion of s.
# see harvest.pl records for Oct 4, 2009.  fix later
#
# Kazic, 11.10.09

# modified to correct reflexive upper-casing of first letter by numbers; and to 
# ensure each semi-colon is followed by a space.
#
# Kazic, 12.9.2013


sub expand_note {
        ($note) = @_;

        if ( $note ) {

                $note = lc($note);
                $note =~ s/\s{2,}/\s/g;
                $note =~ s/^\.+$//g;
                $note =~ s/\?\./\?/g;
                $note =~ s/,,/, ,/g;

		
# shifted in substitution sequence to prevent introduced spaces from confusing parser
# when handling compound comments
# must test
#
# Kazic, 21.5.2019

#                $note =~ s/^\s+//g;
                $note =~ s/\;/\; /g;



		
# next two don't seem to work
#
# Kazic, 11.10.09

                $note =~ s/\.(\S)/\. \1/g;
                $note =~ s/(\B)cl/\1 cl/g;

                $note =~ s/\bfp\b/few_spiking/g;
                $note =~ s/\bpp\b/pegging/g;

                $note =~ s/chl/chlorotic/g;
                $note =~ s/necrs\b/necroses/g;
                $note =~ s/nec\b/necrotic/g;
                $note =~ s/lesns\b/lesions/g;
                $note =~ s/sectg\b/sectoring/g;
                $note =~ s/mxd\b/mixed/g;
                $note =~ s/sl\b/stem lesions/g;

                $note =~ s/ n / and /g;
#                $note =~ s/ 2 / to /g;

                $note =~ s/\bdis\b/diseased/g;
                $note =~ s/\bbd\b/but diseased/g;

                $note =~ s/se\b/small ear/g;
                $note =~ s/re\b/rudimentary ear/g;
                $note =~ s/ne\b/no ear/g;

                $note =~ s/\bft\b/feminized tassel/g;
                $note =~ s/\bpt\b/poor tassel/g;
                $note =~ s/\brt\b/rudimentary tassel/g;
                $note =~ s/\bbt\b/bad tassel/g;
                $note =~ s/\bnt\b/no tassel/g;

                $note =~ s/ldg\b/lodging/g;
                $note =~ s/sbaf\b/shorter_by_a_foot/g;
                $note =~ s/sa\b/shorter_by_a_foot/g;
                $note =~ s/sb2f\b/shorter_by_2_feet/g;
                $note =~ s/s2\b/shorter_by_2_feet/g;
                $note =~ s/sb3f\b/shorter_by_3_feet/g;
                $note =~ s/s3\b/shorter_by_3_feet/g;
                $note =~ s/sb4f\b/shorter_by_4_feet/g;
                $note =~ s/s4\b/shorter_by_4_feet/g;
                $note =~ s/sb5f\b/shorter_by_5_feet/g;
                $note =~ s/s5\b/shorter_by_5_feet/g;
                $note =~ s/sb6f\b/shorter_by_6_feet/g;
                $note =~ s/s6\b/shorter_by_6_feet/g;
                $note =~ s/sb7f\b/shorter_by_7_feet/g;
                $note =~ s/s7\b/shorter_by_7_feet/g;

                $note =~ s/anthoc*y*n*/anthocyanin/g;

                $note =~ s/\bsm\b/small /g;
                $note =~ s/\bexp var\b/expression variable/g;
                $note =~ s/segrg*t*n*/segregation/g;


                $note =~ s/\bntg\b/needs tag/g;
                $note =~ s/\bmis\b/misbagged/g;

                $note =~ s/\bwe\b/whole ear/g;
                $note =~ s/\bhe\b/half ear/g;
                $note =~ s/\bqe\b/quarter ear/g;
                $note =~ s/\bee\b/eighth ear/g;
                $note =~ s/\bxe\b/sixteenth ear/g;
                $note =~ s/\b3\/4\s*e\b/three_quarter ear/g;
                $note =~ s/\btqe\b/three_quarter ear/g;



                $note =~ s/whole ear/whole/g;
                $note =~ s/half ear/half/g;
                $note =~ s/quarter ear/quarter/g;
                $note =~ s/eighth ear/eighth/g;
                $note =~ s/sixteenth ear/sixteenth/g;
                $note =~ s/three-quarter ear/three_quarter/g;
                $note =~ s/three_quarter ear/three_quarter/g;




                $note =~ s/\bfun\b/fungus/g;
                $note =~ s/\bew\b/earworm/g;
                $note =~ s/\bcomp\b/complete/g;
                $note =~ s/\bsig\b/significant/g;
                $note =~ s/\bextn*s*v*\b/extensive/g;
                $note =~ s/\bextst*n\b/extension/g;

                $note =~ s/\bls\b/long silks/g;
                $note =~ s/\bvls\b/very long silks/g;
                $note =~ s/\bvfs\b/very few silks/g;
                $note =~ s/\bfs\b/few silks/g;
                $note =~ s/\bss\b/short silks/g;
                $note =~ s/\bvss\b/very short silks/g;
                $note =~ s/\brs\b/rim silks/g;
                $note =~ s/\bws\b/wet silks/g;
                $note =~ s/\byp\b/yellow pollen/g;
                $note =~ s/\blp\b/low pollen/g;
                $note =~ s/\bvlp\b/very low pollen/g;
                $note =~ s/\bnp\b/no pollen/g;
                $note =~ s/\bdd\b/desperate daddy/g;
                $note =~ s/\bde\b/desperate ear/g;
                $note =~ s/\bpe\b/pulled ear/g;
                $note =~ s/\bue\b/uncut ear/g;
                $note =~ s/\bvye\b/very young ear/g;
                $note =~ s/\boe\b/old ear/g;
                $note =~ s/\bvoe\b/very old ear/g;
                $note =~ s/\blce\b/late cut ear/g;
                $note =~ s/\bpopt\b/popped tassel/g;
                $note =~ s/\bct\b/cut tassel/g;
                $note =~ s/\bglas\b/glassine bag/g;
                $note =~ s/\bunk\b/unknown/g;



                $note =~ s/\bsbae\b/stem broken above ear/g;
                $note =~ s/\bbsae\b/stem broken above ear/g;
                $note =~ s/\bear exp\b/ear exposed/g;
                $note =~ s/\bunf cl\b/unfertilized kernels/g;
                $note =~ s/\bupikd cl\b/picked goodish kernels/g;
                $note =~ s/\bgerm\b/germinated/g;
                $note =~ s/\bcl\b/kernels/g;


                $note =~ s/\bwt\b/wild-type/g;
                $note =~ s/\bp\b/purple/g;
                $note =~ s/\bblk\b/black/g;
                $note =~ s/\bbrz\b/bronze/g;
                $note =~ s/\bw\b/white/g;
                $note =~ s/\balbino\b/albino/g;
                $note =~ s/\by\b/yellow/g;
                $note =~ s/\byg\b/yellow-green/g;
                $note =~ s/\byblk\b/yellow-black/g;
                $note =~ s/\bywpspot\b/yellow-with-purple-spot/g;
                $note =~ s/\bly\b/light-yellow/g;
                $note =~ s/\byl\b/light-yellow/g;
                $note =~ s/\br\b/red/g;
                $note =~ s/\bpk\b/pink/g;
                $note =~ s/\bsilv*\b/silver/g;
                $note =~ s/\bspckld*\b/speckled/g;
                $note =~ s/\bsectg*\b/sectoring/g;
                $note =~ s/\bviv*i*p*r*y*\b/vivipary/g;
                $note =~ s/\bsvi\b/some vivipary/g;
 
                $note =~ s/\bag\b/ask Gerry/g;
                $note =~ s/\bdip\b/discard if possible/g;
                $note =~ s/\bdisc if poss\b/discard if possible/g;
                $note =~ s/\bdisc\b/discarded/g;
                $note =~ s/\bposs\b/possible/g;
                $note =~ s/\bnn\b/not needed/g;
                $note =~ s/\bwrn\b/follow warning on bag/g;
                $note =~ s/\bche*c*k X\s*r*e*c*o*r*d*\b/check cross record/g;
                $note =~ s/\brech\b/recheck/g;
                $note =~ s/\bsam\b/sample/g;
                $note =~ s/\bcp\b/check pedigree/g;
                $note =~ s/\bcpp\b/check parental photo/g;
                $note =~ s/\bcap\b/check ancestral photos/g;


                $note =~ s/\bknife\b/contains knife tip/g;

                $note =~ s/\busmall ear\b/use/g;

                $note =~ s/\b0w\b/0 earworms/g;
                $note =~ s/\b1w\b/1 earworm/g;
                $note =~ s/\b2w\b/2 earworms/g;
                $note =~ s/\b3w\b/3 earworms/g;
                $note =~ s/\b4w\b/4 earworms/g;
                $note =~ s/\b5w\b/5 earworms/g;



#                $note =~ s/\b\b//g;


                if ( ( $note =~ /^[a-z\_]+$/ ) && ( $note !~ /\s,.:;\-\+/ ) ) { $full_note = $note; }
                else { $full_note = "'" . $note . "'"; }
	        }
       
        else { $full_note = '_'; }

        return $full_note;
        }






1;
