use v6;
use Test;
use Chart::Gnuplot;

{
    my $msg = "";
    my $gnu = Chart::Gnuplot.new(:terminal("svg"), :filename("sample.svg"), :debug, :stderr(class { method print(*@args){ $msg ~= @args.join; }; method flush {} }));
    $gnu.terminal("svg");
    nok $msg ~~ /unknown/, "Chart::Gnuplot.terminal should accept \"svg\" as an argument.";
}

{
    my $msg;
    my $gnu = Chart::Gnuplot.new(:terminal("png"), :filename("sample.png"), :debug, :stderr(class { method print(*@args){ $msg ~= @args.join; }; method flush{}}));
    $gnu.terminal("Perl6isFun");
    sleep .5;
    ok $msg ~~ /unknown/, "Chart::Gnuplot.terminal shouldn't accept \"Perl6isFun\" as an argument.";
}

done-testing;
