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
    $gnu.ellipse(:index(1), :center(["graph" => 1, "graph" => 1]), :w(1), :h(1), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set object 1 ellipse at graph 1,graph 1 size 1,1';
    is @actual, @expected, 'Given :index, :center, :w, :h as arguments, then Chart::Gnuplot.ellipse should set these properties.';
}

done-testing;
