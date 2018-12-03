use v6;
unit class Chart::Gnuplot::Title:ver<0.0.7>;

use Chart::Gnuplot::Util;

has &!writer;

submethod BUILD(:&!writer) { }

method writer(&writer) {
    &!writer = &writer;
    self
}

method title(:$text, :$offset, :$font-name, :$font-size, :tc(:$textcolor), :$colorspec, Bool :$enhanced, :&writer? = &!writer) {
    my @args;
    
    @args.push(sprintf("\"%s\"", $text));
    @args.push(tweak-coordinate(:name("offset"), :coordinate($offset)));
    @args.push(tweak-fontargs(:$font-name, :$font-size));
    @args.push("textcolor " ~ $textcolor) if $textcolor.defined;
    @args.push("colorspec " ~ $colorspec) if $colorspec.defined;
    @args.push($enhanced ?? "enhanced" !! "noenhanced") if $enhanced.defined;

    &writer(sprintf("set title %s", @args.grep(* ne "").join(" ")));
}
