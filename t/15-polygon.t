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
    $gnu.polygon(:index(1), :from(["graph" => 0, "graph" => 0]), :to([$["graph" => 1, "graph" => 1]]), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set object 1 polygon from graph 0,graph 0 to graph 1,graph 1';
    is @actual, @expected, 'Given :index, :from, :to as arguments, then Chart::Gnuplot.polygon should set these properties.';
}

done-testing;
