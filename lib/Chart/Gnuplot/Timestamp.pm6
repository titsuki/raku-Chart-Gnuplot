use v6;
unit class Chart::Gnuplot::Timestamp:ver<0.0.16>;

use Chart::Gnuplot::Util;
use Chart::Gnuplot::Subset;

has &!writer;

submethod BUILD(:&!writer) { }

method writer(&writer) {
    &!writer = &writer;
    self
}

method timestamp(Str :$format, TrueOnly :$top, TrueOnly :$bottom, Bool :$rotate,
                 :$offset, :$font-name, :$font-size, :$textcolor, :&writer? = &!writer) {
    my @args;
    @args.push(sprintf("\"%s\"", $format)) if $format.defined;
    @args.push("top") if $top.defined;
    @args.push("bottom") if $bottom.defined;
    @args.push($rotate ?? "rotate" !! "norotate") if $rotate.defined;

    @args.push(tweak-coordinate(:name("offset"), :coordinate($offset))) if $offset.defined;
    @args.push(tweak-fontargs(:$font-name, :$font-size));

    @args.push("textcolor " ~ $textcolor) if $textcolor.defined;

    &writer(sprintf("set timestamp %s", @args.grep(* ne "").join(" ")));
}

