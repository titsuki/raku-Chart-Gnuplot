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
    $gnu.multiplot(:title("Perl6 is fun"), :font-name("Helvetica"), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set multiplot title "Perl6 is fun" font "Helvetica"';
    is @actual, @expected, 'Given :title, :font-name as arguments, then Chart::Gnuplot.multiplot should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.multiplot(:title("Perl6 is fun"), :font-size(10), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set multiplot title "Perl6 is fun" font ",10"';
    is @actual, @expected, 'Given :title, :font-size as arguments, then Chart::Gnuplot.multiplot should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.multiplot(:title("Perl6 is fun"), :layout([2,2]), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set multiplot title "Perl6 is fun" layout 2,2';
    is @actual, @expected, 'Given :title, :layout as arguments, then Chart::Gnuplot.multiplot should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.multiplot(:title("Perl6 is fun"), :offset("graph" => 0), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set multiplot title "Perl6 is fun" offset graph 0';
    is @actual, @expected, 'Given :title, :offset as arguments, then Chart::Gnuplot.multiplot should set these properties.';
}

done-testing;
