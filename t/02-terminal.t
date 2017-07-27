use v6;
use Test;
use Chart::Gnuplot;
use IO::Capture::Simple;

{
	my $gnu = Chart::Gnuplot.new(:terminal("png"), :filename("sample.png"), :debug);
    my $msg = capture_stderr({ $gnu.terminal("png"); });
    $msg.say;
    nok $msg ~~ /unknown/, "Chart::Gnuplot.terminal should accept \"png\" as an argument.";
}

{
	my $gnu = Chart::Gnuplot.new(:terminal("png"), :filename("sample.png"), :debug);
    my $msg = capture_stderr({ $gnu.terminal("Perl6isFun"); });
    ok $msg ~~ /unknown/, "Chart::Gnuplot.terminal shouldn't accept \"Perl6isFun\" as an argument.";
}

done-testing;
