use v6;
use Test;
use Chart::Gnuplot;

{
    my $gnu = Chart::Gnuplot.new(:terminal("png"),:filename("sample.png"));
    $gnu.rectangle(:index(1), :from(["" => 0.5, "" => 0.5]), :to(["" => 1, "" => 10]), :layer("front"));
    $gnu.ellipse(:index(2), :center(["" => 5, "" => 5]), :w(10), :h(20));
    $gnu.polygon(:index(3), :from(["" => 2, "" => 3]), :to(["" => 3, "" => 3],["" => 1, "" => 1]), :layer("front"));
    $gnu.circle(:index(4), :center(["first" => 1, "first" => -4]), :radius(1), :fillcolor('rgb "red"') :layer("behind"));
    $gnu.plot(:title("abc"), :style("lines"), :vertices([2,10,-10],[10,20,30]));
    $gnu.plot(:title("bcd"), :style("lines"), :vertices([2,0,-10]));
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("png"),:filename("sample2.png"));
    $gnu.plot(:title("abc"), :style("lines"), :range([$[1,2],$[3,4]]) :vertices([2,10,-10],[10,20,30]));
    $gnu.plot(:title("abc"), :style("lines"), :vertices([2,10,-10],[10,20,30]), :palette);
}

{
    my $gnu = Chart::Gnuplot.new(:terminal("png"),:filename("sample3.png"));
    $gnu.command("set bar 1.000000 front");
    $gnu.command("set style circle radius graph 0.02, first 0.00000, 0.00000");
    $gnu.command("set style ellipse size graph 0.05, 0.03, first 0.00000 angle 0 units xy");
    $gnu.command("unset key");
    $gnu.command("set style textbox transparent margins  1.0,  1.0 border");
    $gnu.command("unset logscale");
    $gnu.command("set size ratio -1 1,1");
    $gnu.command("unset paxis 1 tics");
    $gnu.command("unset paxis 2 tics");
    $gnu.command("unset paxis 3 tics");
    $gnu.command("unset paxis 4 tics");
    $gnu.command("unset paxis 5 tics");
    $gnu.command("unset paxis 6 tics");
    $gnu.command("unset paxis 7 tics");
    $gnu.command('set title "Trace of unconstrained optimization with trust-region method"');
    $gnu.command('set xrange [ -2.50000 : 1.50000 ] noreverse nowriteback');
    $gnu.command('set yrange [ -1.00000 : 2.50000 ] noreverse nowriteback');
    $gnu.command('set paxis 1 range [ * : * ] noreverse nowriteback');
    $gnu.command('set paxis 2 range [ * : * ] noreverse nowriteback');
    $gnu.command('set paxis 3 range [ * : * ] noreverse nowriteback');
    $gnu.command('set paxis 4 range [ * : * ] noreverse nowriteback');
    $gnu.command('set paxis 5 range [ * : * ] noreverse nowriteback');
    $gnu.command('set paxis 6 range [ * : * ] noreverse nowriteback');
    $gnu.command('set paxis 7 range [ * : * ] noreverse nowriteback');
    $gnu.command('set colorbox vertical origin screen 0.9, 0.2, 0 size screen 0.05, 0.6, 0 front  noinvert bdefault');
    $gnu.command('x = 0.0');
    $gnu.command('r = 0.01');
    $gnu.command('types = 6');
    $gnu.command('keyx = -137.0');
    $gnu.command('keyy = -15.0');
    $gnu.command('keyr = 25.0');
    $gnu.command('i = 6');
    ## Last datafile plotted: "optimize.dat"
    $gnu.plot(:title("abc"), :style("circles"), :vertices([0.1,0.2,0.3],[0.4,0.5,0.6]));
    # plot 'optimize.dat' with circles lc rgb "blue" fs transparent solid 0.15 noborder,
    # plot 'optimize.dat' u 1:2 with linespoints lw 2 lc rgb "black"
}
done-testing;
