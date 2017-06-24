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
    $gnu.timestamp(:format('%d'), :top, :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set timestamp "%d" top';
    is @actual, @expected, 'Given :format, :top as arguments, then Chart::Gnuplot.timestamp should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.timestamp(:format('%d'), :bottom, :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set timestamp "%d" bottom';
    is @actual, @expected, 'Given :format, :bottom as arguments, then Chart::Gnuplot.timestamp should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.timestamp(:format('%d'), :bottom, :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set timestamp "%d" bottom';
    is @actual, @expected, 'Given :format, :bottom as arguments, then Chart::Gnuplot.timestamp should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.timestamp(:format('%d'), :rotate, :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set timestamp "%d" rotate';
    is @actual, @expected, 'Given :format, :rotate as arguments, then Chart::Gnuplot.timestamp should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.timestamp(:format('%d'), :offset-x("graph" => 1), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set timestamp "%d" graph 1';
    is @actual, @expected, 'Given :format, :offset-x as arguments, then Chart::Gnuplot.timestamp should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.timestamp(:format('%d'), :offset-x("graph" => 1), :offset-y("graph" => 1), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set timestamp "%d" graph 1 , graph 1';
    is @actual, @expected, 'Given :format, :offset-x, :offset-y as arguments, then Chart::Gnuplot.timestamp should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.timestamp(:format('%d'), :font-name("Helvetica"), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set timestamp "%d" font "Helvetica"';
    is @actual, @expected, 'Given :format, :font-name as arguments, then Chart::Gnuplot.timestamp should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.timestamp(:format('%d'), :font-size(10), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set timestamp "%d" font ",10"';
    is @actual, @expected, 'Given :format, :font-size as arguments, then Chart::Gnuplot.timestamp should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.timestamp(:format('%d'), :textcolor('rgb "blue"'), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set timestamp "%d" textcolor rgb "blue"';
    is @actual, @expected, 'Given :format, :textcolor as arguments, then Chart::Gnuplot.timestamp should set these properties.';
}
