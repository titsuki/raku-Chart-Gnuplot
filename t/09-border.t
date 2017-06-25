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
    $gnu.border(:integer(8), :front, :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set border 8 front';
    is @actual, @expected, 'Given :integer, :front as arguments, then Chart::Gnuplot.border should set these properties.';
}


{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.border(:integer(8), :back, :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set border 8 back';
    is @actual, @expected, 'Given :integer, :back as arguments, then Chart::Gnuplot.border should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.border(:integer(8), :behind, :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set border 8 behind';
    is @actual, @expected, 'Given :integer, :behind as arguments, then Chart::Gnuplot.border should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.border(:integer(8), :linewidth(5), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set border 8 linewidth 5';
    is @actual, @expected, 'Given :integer, :linewidth as arguments, then Chart::Gnuplot.border should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.border(:integer(8), :linestyle(1), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set border 8 linestyle 1';
    is @actual, @expected, 'Given :integer, :linestyle as arguments, then Chart::Gnuplot.border should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.border(:integer(8), :linetype(1), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set border 8 linetype 1';
    is @actual, @expected, 'Given :integer, :linetype as arguments, then Chart::Gnuplot.border should set these properties.';
}

done-testing;
