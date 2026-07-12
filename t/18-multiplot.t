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
    my @expected = 'set terminal svg', 'set output "actual.svg"', 'set multiplot title "Perl6 is fun" font "Helvetica"';
    is @actual, @expected, 'Given :title, :font-name as arguments, then Chart::Gnuplot.multiplot should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.multiplot(:title("Perl6 is fun"), :font-size(10), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set terminal svg', 'set output "actual.svg"', 'set multiplot title "Perl6 is fun" font ",10"';
    is @actual, @expected, 'Given :title, :font-size as arguments, then Chart::Gnuplot.multiplot should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.multiplot(:title("Perl6 is fun"), :layout([2,2]), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set terminal svg', 'set output "actual.svg"', 'set multiplot title "Perl6 is fun" layout 2,2';
    is @actual, @expected, 'Given :title, :layout as arguments, then Chart::Gnuplot.multiplot should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.multiplot(:title("Perl6 is fun"), :offset("graph" => 0), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set terminal svg', 'set output "actual.svg"', 'set multiplot title "Perl6 is fun" offset graph 0';
    is @actual, @expected, 'Given :title, :offset as arguments, then Chart::Gnuplot.multiplot should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    my &writer = -> $msg { @actual.push($msg) };

    $gnu.multiplot(:layout([1, 2]), :&writer);
    $gnu.plot(:function("sin(x)"), :&writer);
    $gnu.splot(:function("x*y"), :&writer);
    $gnu.end-multiplot(:&writer);
    $gnu.plot(:function("tan(x)"), :&writer);
    $gnu.plot(:function("x"), :&writer);
    $gnu.dispose;

    my @plot-commands = @actual.grep({ .starts-with("plot ") || .starts-with("replot ") || .starts-with("splot ") });
    my @expected = 'plot sin(x)', 'splot x*y', 'plot tan(x)', 'replot x';
    is @plot-commands, @expected, 'Each multiplot panel uses plot, and ending multiplot resets plotting state.';
    ok @actual.grep(* eq 'unset multiplot'), 'end-multiplot leaves multiplot mode.';
    is @actual[0..4], ['set terminal svg', 'set output "actual.svg"', 'set multiplot layout 1,2', 'plot sin(x)', 'splot x*y'],
        'The terminal and output are configured once before multiplot starts.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.multiplot(:writer(-> $msg { @actual.push($msg) }));
    $gnu.dispose;
    is @actual, ['set terminal svg', 'set output "actual.svg"', 'set multiplot'], 'multiplot without options configures output and does not append whitespace.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    my &writer = -> $msg { @actual.push($msg) };

    $gnu.multiplot(:layout([1, 2]), :&writer, {
        $gnu.plot(:function("sin(x)"), :&writer);
        $gnu.plot(:function("cos(x)"), :&writer);
    });
    $gnu.plot(:function("tan(x)"), :&writer);
    $gnu.dispose;

    my @plot-commands = @actual.grep({ .starts-with("plot ") || .starts-with("replot ") });
    is @plot-commands, ['plot sin(x)', 'plot cos(x)', 'plot tan(x)'], 'The block form renders panels and resets plotting state automatically.';
    is @actual.grep(* eq 'unset multiplot').elems, 1, 'The block form ends multiplot exactly once.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    my &writer = -> $msg { @actual.push($msg) };

    throws-like {
        $gnu.multiplot(:layout([1, 1]), :&writer, {
            die "plot failed";
        });
    }, X::AdHoc, message => 'plot failed', 'The block form propagates exceptions.';
    is @actual[*-1], 'unset multiplot', 'The block form ends multiplot when its body throws.';
    $gnu.dispose;
}

done-testing;
