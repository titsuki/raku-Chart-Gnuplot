use v6;
use Test;
use Chart::Gnuplot;

sub comp(@lhs, @rhs) returns Bool {
    return False if @lhs.elems != @rhs.elems;
    for @lhs Z @rhs -> ($l, $r) {
        given $r {
            when * ~~ Regex {
                return False unless $l ~~ $r;
            }
            when * ~~ Str {
                return False unless $l eq $r;
            }
            default {}
        }
    }
    True
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.title(:text("Perl6 is fun"), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set title "Perl6 is fun"';
    is @actual, @expected, 'Given :text as arguments, then Chart::Gnuplot.title should set these properties.';
}
