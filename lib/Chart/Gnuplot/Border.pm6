use v6;
unit class Chart::Gnuplot::Border:ver<0.0.8>;

use Chart::Gnuplot::Subset;

has &!writer;

submethod BUILD(:&!writer) { }

method writer(&writer) {
    &!writer = &writer;
    self
}

method border(:$integer, TrueOnly :$front, TrueOnly :$back, TrueOnly :$behind,
              :lw(:$linewidth), :ls(:$linestyle), :lt(:$linetype), :&writer? = &!writer) {
    my @args;
    @args.push($integer) if $integer.defined;
    @args.push("front") if $front.defined;
    @args.push("back") if $back.defined;
    @args.push("behind") if $behind.defined;
    @args.push("linewidth " ~ $linewidth) if $linewidth.defined;
    @args.push("linestyle " ~ $linestyle) if $linestyle.defined;
    @args.push("linetype " ~ $linetype) if $linetype.defined;

    &writer(sprintf("set border %s", @args.grep(* ne "").join(" ")));
}

