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
    $gnu.xtics(:axis, :rotate(False), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set xtics axis norotate';
    is @actual, @expected, 'Given :axis, :rotate(False) as arguments, then Chart::Gnuplot.xtics should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.xtics(:axis, :rotate(90), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set xtics axis rotate by 90';
    is @actual, @expected, 'Given :axis, :rotate(90) as arguments, then Chart::Gnuplot.xtics should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.xtics(:axis, :incr(0.1), :start(0), :end(1), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set xtics axis 0, 0.1, 1';
    is @actual, @expected, 'Given :axis, :incr, :start, :end as arguments, then Chart::Gnuplot.xtics should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.xtics(:axis, :tics([{:label("I love"), :pos(0.1)}, {:label("Perl 6"), :pos(0.5)}]), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set xtics axis ("I love" 0.1,"Perl 6" 0.5)';
    is @actual, @expected, 'Given :axis, :tics as arguments, then Chart::Gnuplot.xtics should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.xtics(:axis, :format('%.3f'), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set xtics axis format "%.3f"';
    is @actual, @expected, 'Given :axis, :format as arguments, then Chart::Gnuplot.xtics should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.xtics(:axis, :format('%.3f'), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set xtics axis format "%.3f"';
    is @actual, @expected, 'Given :axis, :format as arguments, then Chart::Gnuplot.xtics should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.xtics(:axis, :font-name("Helvetica"), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set xtics axis font "Helvetica"';
    is @actual, @expected, 'Given :axis, :font-name as arguments, then Chart::Gnuplot.xtics should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.xtics(:axis, :font-size(10), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set xtics axis font ",10"';
    is @actual, @expected, 'Given :axis, :font-size as arguments, then Chart::Gnuplot.xtics should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.xtics(:axis, :enhanced, :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set xtics axis enhanced';
    is @actual, @expected, 'Given :axis, :enhanced as arguments, then Chart::Gnuplot.xtics should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.xtics(:axis, :numeric, :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set xtics axis numeric';
    is @actual, @expected, 'Given :axis, :numeric as arguments, then Chart::Gnuplot.xtics should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.xtics(:axis, :timedate, :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set xtics axis timedate';
    is @actual, @expected, 'Given :axis, :timedate as arguments, then Chart::Gnuplot.xtics should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.xtics(:axis, :geographic, :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set xtics axis geographic';
    is @actual, @expected, 'Given :axis, :geographic as arguments, then Chart::Gnuplot.xtics should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.xtics(:axis, :rangelimited, :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set xtics axis rangelimited';
    is @actual, @expected, 'Given :axis, :rangelimited as arguments, then Chart::Gnuplot.xtics should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.xtics(:axis, :textcolor('rgb "red"'), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set xtics axis textcolor rgb "red"';
    is @actual, @expected, 'Given :axis, :textcolor as arguments, then Chart::Gnuplot.xtics should set these properties.';
}

done-testing;
