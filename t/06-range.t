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
    $gnu.xrange(:min(0.1), :max(0.5), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set xrange [0.1:0.5]';
    is @actual, @expected, 'Given :min, :max as arguments, then Chart::Gnuplot.xrange should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.xrange(:min(0.1), :max(0.5), :reverse, :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set xrange [0.1:0.5] reverse';
    is @actual, @expected, 'Given :min, :max, :reverse as arguments, then Chart::Gnuplot.xrange should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.xrange(:min(0.1), :max(0.5), :writeback, :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set xrange [0.1:0.5] writeback';
    is @actual, @expected, 'Given :min, :max, :writeback as arguments, then Chart::Gnuplot.xrange should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.xrange(:min(0.1), :max(0.5), :extend, :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set xrange [0.1:0.5] extend';
    is @actual, @expected, 'Given :min, :max, :extend as arguments, then Chart::Gnuplot.xrange should set these properties.';
}

done-testing;
