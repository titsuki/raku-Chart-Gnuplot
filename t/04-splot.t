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
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual-xy.svg"));
    my @actual;
    $gnu.splot(:function("x*y"), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set terminal svg', 'set output "actual-xy.svg"', 'splot x*y';
    is @actual, @expected, 'Given :function("x*y") as an argument, then Chart::Gnuplot.splot should plot a xy graph.';
}

{
    my @vertices = [$[1,1,1],$[2,2,2],$[3,3,3]];
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual-xyz.svg"));
    my @actual;
    $gnu.splot(:vertices(@vertices), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = rx:s/\$mydata<[\d]>+ \<\< EOD/, '1 1 1', '2 2 2', '3 3 3', 'EOD', 'set terminal svg', 'set output "actual-xyz.svg"', rx:s/splot \$mydata<[\d]>+/;
    ok comp(@actual, @expected), 'Given :verteices([$[1,1,1],$[2,2,2],$[3,3,3]]) as an argument, then Chart::Gnuplot.splot should plot a xyz graph.';
}
