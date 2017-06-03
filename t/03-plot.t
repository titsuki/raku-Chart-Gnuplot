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
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual-sinx.svg"));
    my @actual;
    $gnu.plot(:function("sin(x)"), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set terminal svg', 'set output "actual-sinx.svg"', 'plot sin(x)';
    is @actual, @expected, 'Given :function("sin(x)") as an argument, then Chart::Gnuplot.plot should plot a sin(x) graph.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual-population.svg"));
    my @actual;
    my @vertices = [$[1970,10],$[1980,100],$[2010,5000]];
    $gnu.plot(:vertices(@vertices), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = rx:s/\$mydata<[\d]>+ \<\< EOD/, '1970 10', '1980 100', '2010 5000', 'EOD', 'set terminal svg', 'set output "actual-population.svg"', rx:s/plot \$mydata<[\d]>+/;
    ok comp(@actual, @expected), 'Given :vertices([$[1970,10],$[1980,100],$[2010,5000]]) as an argument, then Chart::Gnuplot.plot should plot a population graph.';
}

done-testing;
