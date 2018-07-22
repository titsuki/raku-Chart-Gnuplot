use v6;
unit class Chart::Gnuplot::Object:ver<0.0.6>;

use Chart::Gnuplot::Util;

has &!writer;

submethod BUILD(:&!writer) { }

method writer(&writer) {
    &!writer = &writer;
    self
}

method !anyobject(:$front, :$back, :$behind, Bool :$clip, :$fillcolor, :$fillstyle,
                  :$default, :$linewidth, :$dashtype, :&writer? = &!writer) {

    my @args;
    @args.push("front") if $front.defined;
    @args.push("back") if $back.defined;
    @args.push("behind") if $behind.defined;
    @args.push($clip ?? "clip" !! "noclip") if $clip.defined;
    @args.push("fillcolor " ~ $fillcolor) if $fillcolor.defined;
    @args.push("fillstyle " ~ $fillstyle) if $fillstyle.defined;
    @args.push("default") if $default.defined;
    @args.push("linewidth " ~ $linewidth) if $linewidth.defined;
    @args.push("dashtype " ~ $dashtype) if $dashtype.defined;
    @args.grep(* ne "").join(" ");
}

multi method rectangle(:$index!, :$from, :$to,
                       :$front, :$back, :$behind, Bool :$clip, :$fillcolor, :$fillstyle,
                       :$default, :$linewidth, :$dashtype, :&writer? = &!writer) {

    my @args;
    @args.push(tweak-coordinate(:name("from"), :coordinate($from)));
    @args.push(tweak-coordinate(:name("to"), :coordinate($to)));
    @args.push(self!anyobject(:$front, :$back, :$behind, :$clip, :$fillcolor, :$fillstyle,
                              :$default, :$linewidth, :$dashtype));
    &writer(sprintf("set object %d rectangle %s", $index, @args.grep(* ne "").join(" ")))
}

multi method rectangle(:$index, :$from, :$rto,
                       :$front, :$back, :$behind, Bool :$clip, :$fillcolor, :$fillstyle,
                       :$default, :$linewidth, :$dashtype, :&writer? = &!writer) {

    my @args;
    @args.push(tweak-coordinate(:name("from"), :coordinate($from)));
    @args.push(tweak-coordinate(:name("rto"), :coordinate($rto)));
    @args.push(self!anyobject(:$front, :$back, :$behind, :$clip, :$fillcolor, :$fillstyle,
                              :$default, :$linewidth, :$dashtype));
    &writer(sprintf("set object %d rectangle %s", $index, @args.grep(* ne "").join(" ")));
}

method ellipse(:$index, :center(:$at), :$w!, :$h!,
               :$front, :$back, :$behind, Bool :$clip, :$fillcolor, :$fillstyle,
               :$default, :$linewidth, :$dashtype, :&writer? = &!writer) {
    my @args;
    @args.push(tweak-coordinate(:name("at"), :coordinate($at)));
    @args.push(sprintf("size %s,%s", $w, $h));
    @args.push(self!anyobject(:$front, :$back, :$behind, :$clip, :$fillcolor, :$fillstyle,
                              :$default, :$linewidth, :$dashtype));
    &writer(sprintf("set object %d ellipse %s", $index, @args.grep(* ne "").join(" ")));
}

method circle(:$index, :center(:$at), :$radius!,
              :$front, :$back, :$behind, Bool :$clip, :$fillcolor, :$fillstyle,
              :$default, :$linewidth, :$dashtype, :&writer? = &!writer) {
    my @args;
    @args.push(tweak-coordinate(:name("at"), :coordinate($at)));
    @args.push(sprintf("size %s", $radius));
    @args.push(self!anyobject(:$front, :$back, :$behind, :$clip, :$fillcolor, :$fillstyle,
                              :$default, :$linewidth, :$dashtype));
    
    &writer(sprintf("set object %d circle %s", $index, @args.grep(* ne "").join(" ")));
}

method polygon(:$index, :$from, :@to,
               :$front, :$back, :$behind, Bool :$clip, :$fillcolor, :$fillstyle,
               :$default, :$linewidth, :$dashtype, :&writer? = &!writer) {
    my @args;
    @args.push(tweak-coordinate(:name("from"), :coordinate($from)));
    @args.push(@to.map(-> $c { tweak-coordinate(:coordinate($c), :name("to")) }).join(" "));
    @args.push(self!anyobject(:$front, :$back, :$behind, :$clip, :$fillcolor, :$fillstyle,
                              :$default, :$linewidth, :$dashtype));
    &writer(sprintf("set object %d polygon %s", $index, @args.grep(* ne "").join(" ")));
}

