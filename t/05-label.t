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
    $gnu.label(:label-text("mylabel"), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set label "mylabel"';
    is @actual, @expected, 'Given :label-text as arguments, then Chart::Gnuplot.label should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.label(:tag("1"), :label-text("mylabel"), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set label 1 "mylabel"';
    is @actual, @expected, 'Given :tag and :label-text as arguments, then Chart::Gnuplot.label should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.label(:label-text("mylabel"), :at(["graph" => 1, "graph" => 2]), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set label "mylabel" at graph 1,graph 2';
    is @actual, @expected, 'Given :label-text, :at as arguments, then Chart::Gnuplot.label should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.label(:label-text("mylabel"), :left, :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set label "mylabel" left';
    is @actual, @expected, 'Given :label-text, :left as arguments, then Chart::Gnuplot.label should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.label(:label-text("mylabel"), :center, :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set label "mylabel" center';
    is @actual, @expected, 'Given :label-text, :center as arguments, then Chart::Gnuplot.label should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.label(:label-text("mylabel"), :right, :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set label "mylabel" right';
    is @actual, @expected, 'Given :label-text, :right as arguments, then Chart::Gnuplot.label should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.label(:label-text("mylabel"), :rotate(90), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set label "mylabel" rotate by 90';
    is @actual, @expected, 'Given :label-text, :rotate as arguments, then Chart::Gnuplot.label should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.label(:label-text("mylabel"), :rotate(False), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set label "mylabel" norotate';
    is @actual, @expected, 'Given :label-text, :rotate(False) as arguments, then Chart::Gnuplot.label should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.label(:label-text("mylabel"), :font-name("Helvetica"), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set label "mylabel" font "Helvetica"';
    is @actual, @expected, 'Given :label-text, :font-name as arguments, then Chart::Gnuplot.label should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.label(:label-text("mylabel"), :font-size(10), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set label "mylabel" font ",10"';
    is @actual, @expected, 'Given :label-text, :font-size as arguments, then Chart::Gnuplot.label should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.label(:label-text("mylabel"), :enhanced(False), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set label "mylabel" noenhanced';
    is @actual, @expected, 'Given :label-text, :enhanced(False) as arguments, then Chart::Gnuplot.label should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.label(:label-text("mylabel"), :front, :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set label "mylabel" front';
    is @actual, @expected, 'Given :label-text, :front as arguments, then Chart::Gnuplot.label should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.label(:label-text("mylabel"), :back, :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set label "mylabel" back';
    is @actual, @expected, 'Given :label-text, :back as arguments, then Chart::Gnuplot.label should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.label(:label-text("mylabel"), :textcolor('rgb "blue"'), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set label "mylabel" textcolor rgb "blue"';
    is @actual, @expected, 'Given :label-text, :textcolor as arguments, then Chart::Gnuplot.label should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.label(:label-text("mylabel"), :point(False), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set label "mylabel" nopoint';
    is @actual, @expected, 'Given :label-text, :point(False) as arguments, then Chart::Gnuplot.label should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.label(:label-text("mylabel"), :line-type(0), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set label "mylabel" point lt 0';
    is @actual, @expected, 'Given :label-text, :line-type as arguments, then Chart::Gnuplot.label should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.label(:label-text("mylabel"), :point-type(0), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set label "mylabel" point pt 0';
    is @actual, @expected, 'Given :label-text, :point-type as arguments, then Chart::Gnuplot.label should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.label(:label-text("mylabel"), :offset([1]), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set label "mylabel" offset 1';
    is @actual, @expected, 'Given :label-text, :offset as arguments, then Chart::Gnuplot.label should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.label(:label-text("mylabel"), :boxed, :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set label "mylabel" boxed';
    is @actual, @expected, 'Given :label-text, :boxed as arguments, then Chart::Gnuplot.label should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.label(:label-text("mylabel"), :hypertext, :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set label "mylabel" hypertext';
    is @actual, @expected, 'Given :label-text, :hypertext as arguments, then Chart::Gnuplot.label should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.xlabel(:label("mylabel"), :offset(["graph" => 1, "graph" => 1]), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set xlabel "mylabel" offset graph 1,graph 1';
    is @actual, @expected, 'Given :label, :offset as arguments, then Chart::Gnuplot.xlabel should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.xlabel(:label("mylabel"), :font-name("Helvetica"), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set xlabel "mylabel" font "Helvetica"';
    is @actual, @expected, 'Given :label, :font-name as arguments, then Chart::Gnuplot.xlabel should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.xlabel(:label("mylabel"), :font-size(10), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set xlabel "mylabel" font ",10"';
    is @actual, @expected, 'Given :label, :font-size as arguments, then Chart::Gnuplot.xlabel should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.xlabel(:label("mylabel"), :textcolor('rgb "white"'), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set xlabel "mylabel" textcolor rgb "white"';
    is @actual, @expected, 'Given :label, :textcolor as arguments, then Chart::Gnuplot.xlabel should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.xlabel(:label("mylabel"), :enhanced, :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set xlabel "mylabel" enhanced';
    is @actual, @expected, 'Given :label, :enhanced as arguments, then Chart::Gnuplot.xlabel should set these properties.';
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("actual.svg"));
    my @actual;
    $gnu.xlabel(:label("mylabel"), :rotate(90), :writer(-> $msg { @actual.push($msg); }));
    $gnu.dispose;
    my @expected = 'set xlabel "mylabel" rotate by 90';
    is @actual, @expected, 'Given :label, :rotate as arguments, then Chart::Gnuplot.xlabel should set these properties.';
}

done-testing;
