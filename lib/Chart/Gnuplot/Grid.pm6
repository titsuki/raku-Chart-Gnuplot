use v6;
unit class Chart::Gnuplot::Grid:ver<0.0.8>;

use Chart::Gnuplot::Subset;

has &!writer;

submethod BUILD(:&!writer) { }

method writer(&writer) {
    &!writer = &writer;
    self
}

method grid(Bool :$xtics, TrueOnly :$mxtics, Bool :$ytics, TrueOnly :$mytics, Bool :$ztics, TrueOnly :$mztics, Bool :$x2tics, TrueOnly :$mx2tics, Bool :$y2tics, TrueOnly :$my2tics, Bool :$cbtics, TrueOnly :$mcbtics,
            :$polar, :$layerdefault, :$front, :$back,
            :ls(:@linestyle), :lt(:@linetype), :lw(:@linewidth), :&writer? = &!writer) {
    my @args;
    @args.push($xtics ?? "xtics" !! "noxtics") if $xtics.defined;
    @args.push("mxtics") if $mxtics.defined;
    @args.push($ytics ?? "ytics" !! "noytics") if $ytics.defined;
    @args.push("mytics") if $mytics.defined;
    @args.push($ztics ?? "ztics" !! "noztics") if $ztics.defined;
    @args.push("mztics") if $mztics.defined;

    @args.push($x2tics ?? "x2tics" !! "nox2tics") if $x2tics.defined;
    @args.push("mx2tics") if $mx2tics.defined;
    @args.push($y2tics ?? "y2tics" !! "noy2tics") if $y2tics.defined;
    @args.push("my2tics") if $my2tics.defined;
    @args.push($cbtics ?? "cbtics" !! "nocbtics") if $cbtics.defined;
    @args.push("mcbtics") if $mcbtics.defined;

    @args.push("polar " ~ $polar) if $polar.defined;
    @args.push("layerdefault") if $layerdefault.defined;
    @args.push("front") if $front.defined;
    @args.push("back") if $back.defined;

    @args.push("linestyle " ~ @linestyle[0]) if @linestyle.elems >= 1;
    @args.push("linetype " ~ @linetype[0]) if @linetype.elems >= 1;
    @args.push("linewidth " ~ @linewidth[0]) if @linewidth.elems >= 1;

    @args.push(",") if @linestyle.elems|@linetype.elems|@linewidth.elems == 2;
    @args.push("linestyle " ~ @linestyle[1]) if @linestyle.elems == 2;
    @args.push("linetype " ~ @linetype[1]) if @linetype.elems == 2;
    @args.push("linewidth " ~ @linewidth[1]) if @linewidth.elems == 2;

    &writer(sprintf("set grid %s", @args.grep(* ne "").join(" ")));
}

