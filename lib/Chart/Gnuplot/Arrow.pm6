use v6;
unit class Chart::Gnuplot::Arrow:ver<0.0.14>;

use Chart::Gnuplot::Util;
use Chart::Gnuplot::Subset;

has &!writer;

submethod BUILD(:&!writer) { }

method writer(&writer) {
    &!writer = &writer;
    self
}

multi method arrow(
    :$tag, :$from, :$to, Bool :$head, TrueOnly :$backhead, TrueOnly :$heads,
    :$head-length, :$head-angle, :$back-angle,
    Bool :$filled, TrueOnly :$empty, TrueOnly :$border,
    TrueOnly :$front, TrueOnly :$back,
    :ls(:$linestyle), :lt(:$linetype), :lw(:$linewidth), :lc(:$linecolor), :dt(:$dashtype), :&writer? = &!writer
) {
    my @args;

    @args.push($tag) if $tag.defined;
    @args.push(tweak-coordinate(:name("from"), :coordinate($from)));
    @args.push(tweak-coordinate(:name("to"), :coordinate($to)));
    @args.push($head ?? "head" !! "nohead") if $head.defined;
    @args.push("backhead") if $backhead.defined;
    @args.push("heads") if $heads.defined;
    if $head-length.defined and $head-angle.defined {
        if $back-angle.defined {
            @args.push(sprintf("size %s", ($head-length, $head-angle, $back-angle).join(",")));
        } else {
            @args.push(sprintf("size %s", ($head-length, $head-angle).join(",")));
        }
    }

    @args.push($filled ?? "filled" !! "nofilled") if $filled.defined;
    @args.push("empty") if $empty.defined;
    @args.push("border") if $border.defined;
    @args.push("front") if $front.defined;
    @args.push("back") if $back.defined;
    @args.push("linestyle " ~ $linestyle) if $linestyle.defined;
    @args.push("linetype " ~ $linetype) if $linetype.defined;
    @args.push("linewidth " ~ $linewidth) if $linewidth.defined;
    @args.push("linecolor " ~ $linecolor) if $linecolor.defined;
    @args.push("dashtype " ~ $dashtype) if $dashtype.defined;

    &writer(sprintf("set arrow %s", @args.grep(* ne "").join(" ")));
}

multi method arrow(
    :$tag, :$from, :$rto, Bool :$head, TrueOnly :$backhead, TrueOnly :$heads,
    :$head-length, :$head-angle, :$back-angle,
    Bool :$filled, TrueOnly :$empty, TrueOnly :$border,
    TrueOnly :$front, TrueOnly :$back,
    :ls(:$linestyle), :lt(:$linetype), :lw(:$linewidth), :lc(:$linecolor), :dt(:$dashtype), :&writer? = &!writer
) {
    my @args;

    @args.push($tag) if $tag.defined;
    @args.push(tweak-coordinate(:name("from"), :coordinate($from)));
    @args.push(tweak-coordinate(:name("rto"), :coordinate($rto)));
    @args.push($head ?? "head" !! "nohead") if $head.defined;
    @args.push("backhead") if $backhead.defined;
    @args.push("heads") if $heads.defined;
    if $head-length.defined and $head-angle.defined {
        if $back-angle.defined {
            @args.push(sprintf("size %s", ($head-length, $head-angle, $back-angle).join(",")));
        } else {
            @args.push(sprintf("size %s", ($head-length, $head-angle).join(",")));
        }
    }

    @args.push($filled ?? "filled" !! "nofilled") if $filled.defined;
    @args.push("empty") if $empty.defined;
    @args.push("border") if $border.defined;
    @args.push("front") if $front.defined;
    @args.push("back") if $back.defined;
    @args.push("linestyle " ~ $linestyle) if $linestyle.defined;
    @args.push("linetype " ~ $linetype) if $linetype.defined;
    @args.push("linewidth " ~ $linewidth) if $linewidth.defined;
    @args.push("linecolor " ~ $linecolor) if $linecolor.defined;
    @args.push("dashtype " ~ $dashtype) if $dashtype.defined;

    &writer(sprintf("set arrow %s", @args.grep(* ne "").join(" ")));
}

