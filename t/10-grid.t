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
    $gnu.grid(:xtics, :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set grid xtics';
    is @actual, @expected, 'Given :xtics as arguments, then Chart::Gnuplot.grid should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.grid(:ytics, :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set grid ytics';
    is @actual, @expected, 'Given :ytics as arguments, then Chart::Gnuplot.grid should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.grid(:ztics, :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set grid ztics';
    is @actual, @expected, 'Given :ztics as arguments, then Chart::Gnuplot.grid should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.grid(:x2tics, :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set grid x2tics';
    is @actual, @expected, 'Given :x2tics as arguments, then Chart::Gnuplot.grid should set these properties.';
}


{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.grid(:cbtics, :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set grid cbtics';
    is @actual, @expected, 'Given :cbtics as arguments, then Chart::Gnuplot.grid should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.grid(:polar(30), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set grid polar 30';
    is @actual, @expected, 'Given :polar as arguments, then Chart::Gnuplot.grid should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.grid(:layerdefault, :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set grid layerdefault';
    is @actual, @expected, 'Given :layerdefault as arguments, then Chart::Gnuplot.grid should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.grid(:front, :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set grid front';
    is @actual, @expected, 'Given :front as arguments, then Chart::Gnuplot.grid should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.grid(:back, :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set grid back';
    is @actual, @expected, 'Given :back as arguments, then Chart::Gnuplot.grid should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.grid(:linewidth([1,1]), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set grid linewidth 1 , linewidth 1';
    is @actual, @expected, 'Given :linewidth as arguments, then Chart::Gnuplot.grid should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.grid(:linestyle([1,1]), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set grid linestyle 1 , linestyle 1';
    is @actual, @expected, 'Given :linestyle as arguments, then Chart::Gnuplot.grid should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.grid(:linetype([1,1]), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set grid linetype 1 , linetype 1';
    is @actual, @expected, 'Given :linetype as arguments, then Chart::Gnuplot.grid should set these properties.';
}

done-testing;
