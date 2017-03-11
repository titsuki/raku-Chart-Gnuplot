use v6;
use Test;
use Chart::Gnuplot;


my $gnu = Chart::Gnuplot.new(:terminal("png"),:filename("sample.png"));
$gnu.rectangle(:index(1), :from([0.5,0.5]), :to([1,10]), :layer("front"));
$gnu.ellipse(:index(2), :center([5,5]), :w(10), :h(20));
$gnu.polygon(:index(3), :from([2,3]), :to([3,3],[1,1]), :layer("front"));
$gnu.circle(:index(4), :center([1,-4]), :radius(1), :fillcolor('rgb "red"') :layer("behind"));
$gnu.plot(:title("abc"), :style("lines"), :vertices([2,10,-10],[10,20,30]));
$gnu.plot(:title("bcd"), :style("lines"), :vertices([2,0,-10]));

done-testing;
