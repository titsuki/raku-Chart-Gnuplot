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
    $gnu.legend(:on, :title("Perl6"), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set key on title "Perl6"';
    is @actual, @expected, 'Given :on, :title as arguments, then Chart::Gnuplot.legend should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.legend(:off, :title("Perl6"), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set key off title "Perl6"';
    is @actual, @expected, 'Given :off, :title as arguments, then Chart::Gnuplot.legend should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.legend(:default, :title("Perl6"), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set key default title "Perl6"';
    is @actual, @expected, 'Given :default, :title as arguments, then Chart::Gnuplot.legend should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.legend(:inside, :title("Perl6"), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set key inside title "Perl6"';
    is @actual, @expected, 'Given :inside, :title as arguments, then Chart::Gnuplot.legend should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.legend(:outside, :title("Perl6"), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set key outside title "Perl6"';
    is @actual, @expected, 'Given :outside, :title as arguments, then Chart::Gnuplot.legend should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.legend(:lmargin, :title("Perl6"), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set key lmargin title "Perl6"';
    is @actual, @expected, 'Given :lmargin, :title as arguments, then Chart::Gnuplot.legend should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.legend(:rmargin, :title("Perl6"), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set key rmargin title "Perl6"';
    is @actual, @expected, 'Given :rmargin, :title as arguments, then Chart::Gnuplot.legend should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.legend(:tmargin, :title("Perl6"), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set key tmargin title "Perl6"';
    is @actual, @expected, 'Given :tmargin, :title as arguments, then Chart::Gnuplot.legend should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.legend(:bmargin, :title("Perl6"), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set key bmargin title "Perl6"';
    is @actual, @expected, 'Given :bmargin, :title as arguments, then Chart::Gnuplot.legend should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.legend(:at(["graph" => 0.5]), :title("Perl6"), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set key at graph 0.5 title "Perl6"';
    is @actual, @expected, 'Given :at, :title as arguments, then Chart::Gnuplot.legend should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.legend(:left, :title("Perl6"), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set key left title "Perl6"';
    is @actual, @expected, 'Given :left, :title as arguments, then Chart::Gnuplot.legend should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.legend(:right, :title("Perl6"), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set key right title "Perl6"';
    is @actual, @expected, 'Given :right, :title as arguments, then Chart::Gnuplot.legend should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.legend(:top, :title("Perl6"), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set key top title "Perl6"';
    is @actual, @expected, 'Given :top, :title as arguments, then Chart::Gnuplot.legend should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.legend(:bottom, :title("Perl6"), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set key bottom title "Perl6"';
    is @actual, @expected, 'Given :bottom, :title as arguments, then Chart::Gnuplot.legend should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.legend(:center, :title("Perl6"), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set key center title "Perl6"';
    is @actual, @expected, 'Given :center, :title as arguments, then Chart::Gnuplot.legend should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.legend(:vertical, :title("Perl6"), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set key vertical title "Perl6"';
    is @actual, @expected, 'Given :vertical, :title as arguments, then Chart::Gnuplot.legend should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.legend(:horizontal, :title("Perl6"), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set key horizontal title "Perl6"';
    is @actual, @expected, 'Given :horizontal, :title as arguments, then Chart::Gnuplot.legend should set these properties.';
}



{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.legend(:Left, :title("Perl6"), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set key Left title "Perl6"';
    is @actual, @expected, 'Given :Left, :title as arguments, then Chart::Gnuplot.legend should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.legend(:Right, :title("Perl6"), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set key Right title "Perl6"';
    is @actual, @expected, 'Given :Right, :title as arguments, then Chart::Gnuplot.legend should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.legend(:opaque, :title("Perl6"), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set key opaque title "Perl6"';
    is @actual, @expected, 'Given :opaque, :title as arguments, then Chart::Gnuplot.legend should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.legend(:reverse, :title("Perl6"), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set key reverse title "Perl6"';
    is @actual, @expected, 'Given :reverse, :title as arguments, then Chart::Gnuplot.legend should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.legend(:invert, :title("Perl6"), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set key invert title "Perl6"';
    is @actual, @expected, 'Given :invert, :title as arguments, then Chart::Gnuplot.legend should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.legend(:invert, :title("Perl6"), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set key invert title "Perl6"';
    is @actual, @expected, 'Given :invert, :title as arguments, then Chart::Gnuplot.legend should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.legend(:samplen(10), :title("Perl6"), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set key samplen 10 title "Perl6"';
    is @actual, @expected, 'Given :samplen, :title as arguments, then Chart::Gnuplot.legend should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.legend(:spacing(1.5), :title("Perl6"), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set key spacing 1.5 title "Perl6"';
    is @actual, @expected, 'Given :spacing, :title as arguments, then Chart::Gnuplot.legend should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.legend(:width(10), :title("Perl6"), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set key width 10 title "Perl6"';
    is @actual, @expected, 'Given :width, :title as arguments, then Chart::Gnuplot.legend should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.legend(:height(10), :title("Perl6"), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set key height 10 title "Perl6"';
    is @actual, @expected, 'Given :height, :title as arguments, then Chart::Gnuplot.legend should set these properties.';
}


{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.legend(:autotitle, :columnheader, :title("Perl6"), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set key autotitle columnheader title "Perl6"';
    is @actual, @expected, 'Given :autotitle, :columnheader, :title as arguments, then Chart::Gnuplot.legend should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.legend(:title("Perl6"), :box, :linestyle(1), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set key title "Perl6" box linestyle 1';
    is @actual, @expected, 'Given :title, :box, :linestyle as arguments, then Chart::Gnuplot.legend should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.legend(:title("Perl6"), :box, :linetype(1), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set key title "Perl6" box linetype 1';
    is @actual, @expected, 'Given :title, :box, :linetype as arguments, then Chart::Gnuplot.legend should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.legend(:title("Perl6"), :box, :linewidth(1), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set key title "Perl6" box linewidth 1';
    is @actual, @expected, 'Given :title, :box, :linewidth as arguments, then Chart::Gnuplot.legend should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.legend(:title("Perl6"), :maxcols(10), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set key title "Perl6" maxcols 10';
    is @actual, @expected, 'Given :title, :maxcols as arguments, then Chart::Gnuplot.legend should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.legend(:title("Perl6"), :maxrows(10), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set key title "Perl6" maxrows 10';
    is @actual, @expected, 'Given :title, :maxrows as arguments, then Chart::Gnuplot.legend should set these properties.';
}

done-testing;
