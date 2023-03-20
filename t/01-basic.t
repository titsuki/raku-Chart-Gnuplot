use v6;
use Test;
use Chart::Gnuplot;

{
    lives-ok {
        my $gnu = Chart::Gnuplot.new(:terminal("png"), :filename("sample.png"));
    }, "Chart::Gnuplot.new should create a new instance."
}

{
    my $msg;
    my $gnu = Chart::Gnuplot.new(:terminal("png"), :filename("sample.svg"), :debug);
    $gnu.command("set terminal svg", :stderr(class { method print(*@args){ $msg ~= @args.join; }; method flush{}}));
    sleep .5;
    ok $msg ~~ "set terminal svg\n", "Chart::Gnuplot.command should print given command to stderr with newline when debug option is enabled.";
}

done-testing;
