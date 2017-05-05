use v6;
use Test;
use Chart::Gnuplot;

{
    lives-ok {
        my $gnu = Chart::Gnuplot.new(:terminal("png"), :filename("sample.png"));
    }, "Chart::Gnuplot.new should create a new instance."
}

done-testing;
