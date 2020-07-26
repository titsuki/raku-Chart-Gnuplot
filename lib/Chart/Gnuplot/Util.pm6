use v6;
unit class Chart::Gnuplot::Util:ver<0.0.19>;

use Chart::Gnuplot::Subset;

sub tweak-fontargs(:$font-name, :$font-size) is export {
    my @font;
    @font.push($font-name.defined ?? $font-name !! "");
    @font.push($font-size) if $font-size.defined;
    
    (not $font-name.defined and not $font-size.defined) ?? "" !! sprintf("font \"%s\"", @font.join(","));
}

sub tweak-coordinate(Mu :$coordinate!, :$name!, :$enable-nooffset = False, Int :$upper-bound?) is export {
    return "" unless $coordinate.defined;
    
    my Str $coordinate-str = "";
    given $coordinate {
        when * ~~ FalseOnly and $enable-nooffset { $coordinate-str = "nooffset" }
        when * ~~ Pair {
            $coordinate-str = ($name, sprintf("%s %s", $_.key, $_.value)).join(" ");
        }
        when * ~~ List {
            if $upper-bound.defined and $coordinate.elems > $upper-bound {
                die "Error: Something went wrong."; # TODO: LTA
            }
            my @coordinate-args;
            for @$coordinate -> $p {
                given $p {
                    when * ~~ Pair {
                        @coordinate-args.push(sprintf("%s %s", $p.key, $p.value));
                    }
                    when * ~~ Real {
                        @coordinate-args.push(sprintf("%s", $p));
                    }
                    default { die "Error: Something went wrong." } # TODO: LTA
                }
            }
            $coordinate-str = "$name " ~ @coordinate-args.join(",") if @coordinate-args.elems > 0;
        }
        default { die "Error: Something went wrong." } # TODO: LTA
    }
    $coordinate-str;
}
