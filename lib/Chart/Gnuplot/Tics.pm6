use v6;
unit class Chart::Gnuplot::Tics:ver<0.0.17>;

use Chart::Gnuplot::Util;
use Chart::Gnuplot::Subset;

has &!writer;

submethod BUILD(:&!writer) { }

method writer(&writer) {
    &!writer = &writer;
    self
}

method !anytics(TrueOnly :$axis, TrueOnly :$border, Bool :$mirror,
                TrueOnly :$in, TrueOnly :$out, TrueOnly :$scale-default, :$scale-major, :$scale-minor, AnyTicsRotate :$rotate, AnyTicsOffset :$offset,
                TrueOnly :$left, TrueOnly :$right, TrueOnly :$center, TrueOnly :$autojustify,
                TrueOnly :$add,
                TrueOnly :$autofreq,
               :$incr,
               :$start, :$end,
               :@tics where Array[AnyTicsTic] | Array[],
               :$format, :$font-name, :$font-size, Bool :$enhanced,
               TrueOnly :$numeric, TrueOnly :$timedate, TrueOnly :$geographic,
               TrueOnly :$rangelimited,
               :$textcolor
               ) {
    my @args;
    @args.push("axis") if $axis.defined;
    @args.push("border") if $border.defined;
    @args.push($mirror ?? "mirror" !! "nomirror") if $mirror.defined;
    @args.push("in") if $in.defined;
    @args.push("out") if $out.defined;
    
    @args.push("scale default") if $scale-default.defined;

    my @scale-args;
    @scale-args.push($scale-major) if $scale-major.defined;
    @scale-args.push($scale-minor) if $scale-major.defined and $scale-minor.defined;
    
    if @scale-args.elems > 0 {
        @args.push(sprintf("scale %s", @scale-args.join(",")));
    }
    
    if $rotate.defined {
        given $rotate {
            when $_ === False { @args.push("norotate") }
            when * ~~ Real { @args.push("rotate by $rotate") }
            default { die "Error: Something went wrong." }
        }
    }

    @args.push(tweak-coordinate(:name("offset"), :coordinate($offset), :enable-nooffset));
    @args.push("left") if $left.defined;
    @args.push("right") if $right.defined;
    @args.push("center") if $center.defined;
    @args.push("autojustify") if $autojustify.defined;
    @args.push("add") if $add.defined;
    @args.push("autofreq") if $autofreq.defined;

    if $incr.defined and (not $start.defined and not $end.defined) {
        @args.push($incr) if $incr.defined;
    } else {
        if $start.defined and $incr.defined and $end.defined {
            @args.push(sprintf("%s, %s, %s", $start, $incr, $end));
        } elsif $start.defined and $incr.defined {
            @args.push(sprintf("%s, %s", $start, $incr));
        }
    }

    if @tics.elems > 0 {
        my @tic-args;
        for @tics -> $t {
            my @tmp;
            if $t<label>:exists {
                @tmp.push(sprintf("\"%s\"", $t<label>));
            }

            @tmp.push($t<pos>);
            if $t<level>:exists {
                @tmp.push($t<level>);
            }
            @tic-args.push(@tmp.join(" "));
        }
        @args.push(sprintf("(%s)", @tic-args.join(",")));
    }

    @args.push(sprintf("format \"%s\"", $format)) if $format.defined;
    @args.push(tweak-fontargs(:$font-name, :$font-size));

    @args.push($enhanced ?? "enhanced" !! "noenhanced") if $enhanced.defined;
    @args.push("numeric") if $numeric.defined;
    @args.push("timedate") if $timedate.defined;
    @args.push("geographic") if $geographic.defined;
    @args.push("rangelimited") if $rangelimited.defined;
    @args.push("textcolor " ~ $textcolor) if $textcolor.defined;
    @args.grep(* ne "").join(" ")
}

method xtics(TrueOnly :$axis, TrueOnly :$border, Bool :$mirror,
             TrueOnly :$in, TrueOnly :$out, TrueOnly :$scale-default, :$scale-major, :$scale-minor, AnyTicsRotate :$rotate, AnyTicsOffset :$offset,
             TrueOnly :$left, TrueOnly :$right, TrueOnly :$center, TrueOnly :$autojustify,
             TrueOnly :$add,
             TrueOnly :$autofreq,
             :$incr,
             :$start, :$end,
             :@tics where Array[AnyTicsTic] | Array[],
             :$format, :$font-name, :$font-size, Bool :$enhanced,
             TrueOnly :$numeric, TrueOnly :$timedate, TrueOnly :$geographic,
             TrueOnly :$rangelimited,
             :$textcolor, :&writer? = &!writer
            ) {
    &writer(sprintf("set xtics %s", self!anytics(:$axis, :$border, :$mirror,
                                                           :$in, :$out, :$scale-default, :$scale-major, :$scale-minor, :$rotate, :$offset,
                                                           :$left, :$right, :$center, :$autojustify,
                                                           :$add,
                                                           :$autofreq,
                                                           :$incr,
                                                           :$start, :$end,
                                                           :@tics,
                                                           :$format, :$font-name, :$font-size, :$enhanced,
                                                           :$numeric, :$timedate, :$geographic,
                                                           :$rangelimited,
                                                           :$textcolor)));
}

method ytics(TrueOnly :$axis, TrueOnly :$border, Bool :$mirror,
             TrueOnly :$in, TrueOnly :$out, TrueOnly :$scale-default, :$scale-major, :$scale-minor, AnyTicsRotate :$rotate, AnyTicsOffset :$offset,
             TrueOnly :$left, TrueOnly :$right, TrueOnly :$center, TrueOnly :$autojustify,
             TrueOnly :$add,
             TrueOnly :$autofreq,
             :$incr,
             :$start, :$end,
             :@tics where Array[AnyTicsTic] | Array[],
             :$format, :$font-name, :$font-size, Bool :$enhanced,
             TrueOnly :$numeric, TrueOnly :$timedate, TrueOnly :$geographic,
             TrueOnly :$rangelimited,
             :$textcolor, :&writer? = &!writer
            ) {
    &writer(sprintf("set ytics %s", self!anytics(:$axis, :$border, :$mirror,
                                                 :$in, :$out, :$scale-default, :$scale-major, :$scale-minor, :$rotate, :$offset,
                                                 :$left, :$right, :$center, :$autojustify,
                                                 :$add,
                                                 :$autofreq,
                                                 :$incr,
                                                 :$start, :$end,
                                                 :@tics,
                                                 :$format, :$font-name, :$font-size, :$enhanced,
                                                 :$numeric, :$timedate, :$geographic,
                                                 :$rangelimited,
                                                 :$textcolor)));
}

method ztics(TrueOnly :$axis, TrueOnly :$border, Bool :$mirror,
             TrueOnly :$in, TrueOnly :$out, TrueOnly :$scale-default, :$scale-major, :$scale-minor, AnyTicsRotate :$rotate, AnyTicsOffset :$offset,
             TrueOnly :$left, TrueOnly :$right, TrueOnly :$center, TrueOnly :$autojustify,
             TrueOnly :$add,
             TrueOnly :$autofreq,
             :$incr,
             :$start, :$end,
             :@tics where Array[AnyTicsTic] | Array[],
             :$format, :$font-name, :$font-size, Bool :$enhanced,
             TrueOnly :$numeric, TrueOnly :$timedate, TrueOnly :$geographic,
             TrueOnly :$rangelimited,
             :$textcolor, :&writer? = &!writer
            ) {
    &writer(sprintf("set ztics %s", self!anytics(:$axis, :$border, :$mirror,
                                                 :$in, :$out, :$scale-default, :$scale-major, :$scale-minor, :$rotate, :$offset,
                                                 :$left, :$right, :$center, :$autojustify,
                                                 :$add,
                                                 :$autofreq,
                                                 :$incr,
                                                 :$start, :$end,
                                                 :@tics,
                                                 :$format, :$font-name, :$font-size, :$enhanced,
                                                 :$numeric, :$timedate, :$geographic,
                                                 :$rangelimited,
                                                 :$textcolor)));
}

method x2tics(TrueOnly :$axis, TrueOnly :$border, Bool :$mirror,
              TrueOnly :$in, TrueOnly :$out, TrueOnly :$scale-default, :$scale-major, :$scale-minor, AnyTicsRotate :$rotate, AnyTicsOffset :$offset,
              TrueOnly :$left, TrueOnly :$right, TrueOnly :$center, TrueOnly :$autojustify,
              TrueOnly :$add,
              TrueOnly :$autofreq,
              :$incr,
              :$start, :$end,
              :@tics where Array[AnyTicsTic] | Array[],
              :$format, :$font-name, :$font-size, Bool :$enhanced,
              TrueOnly :$numeric, TrueOnly :$timedate, TrueOnly :$geographic,
              TrueOnly :$rangelimited,
              :$textcolor, :&writer? = &!writer
             ) {
    &writer(sprintf("set x2tics %s", self!anytics(:$axis, :$border, :$mirror,
                                                  :$in, :$out, :$scale-default, :$scale-major, :$scale-minor, :$rotate, :$offset,
                                                  :$left, :$right, :$center, :$autojustify,
                                                  :$add,
                                                  :$autofreq,
                                                  :$incr,
                                                  :$start, :$end,
                                                  :@tics,
                                                  :$format, :$font-name, :$font-size, :$enhanced,
                                                  :$numeric, :$timedate, :$geographic,
                                                  :$rangelimited,
                                                  :$textcolor)));
}

method y2tics(TrueOnly :$axis, TrueOnly :$border, Bool :$mirror,
              TrueOnly :$in, TrueOnly :$out, TrueOnly :$scale-default, :$scale-major, :$scale-minor, AnyTicsRotate :$rotate, AnyTicsOffset :$offset,
              TrueOnly :$left, TrueOnly :$right, TrueOnly :$center, TrueOnly :$autojustify,
              TrueOnly :$add,
              TrueOnly :$autofreq,
              :$incr,
              :$start, :$end,
              :@tics where Array[AnyTicsTic] | Array[],
              :$format, :$font-name, :$font-size, Bool :$enhanced,
              TrueOnly :$numeric, TrueOnly :$timedate, TrueOnly :$geographic,
              TrueOnly :$rangelimited,
              :$textcolor, :&writer? = &!writer
             ) {
    &writer(sprintf("set y2tics %s", self!anytics(:$axis, :$border, :$mirror,
                                                  :$in, :$out, :$scale-default, :$scale-major, :$scale-minor, :$rotate, :$offset,
                                                  :$left, :$right, :$center, :$autojustify,
                                                  :$add,
                                                  :$autofreq,
                                                  :$incr,
                                                  :$start, :$end,
                                                  :@tics,
                                                  :$format, :$font-name, :$font-size, :$enhanced,
                                                  :$numeric, :$timedate, :$geographic,
                                                  :$rangelimited,
                                                  :$textcolor)));
}

method cbtics(TrueOnly :$axis, TrueOnly :$border, Bool :$mirror,
              TrueOnly :$in, TrueOnly :$out, TrueOnly :$scale-default, :$scale-major, :$scale-minor, AnyTicsRotate :$rotate, AnyTicsOffset :$offset,
              TrueOnly :$left, TrueOnly :$right, TrueOnly :$center, TrueOnly :$autojustify,
              TrueOnly :$add,
              TrueOnly :$autofreq,
              :$incr,
              :$start, :$end,
              :@tics where Array[AnyTicsTic] | Array[],
              :$format, :$font-name, :$font-size, Bool :$enhanced,
              TrueOnly :$numeric, TrueOnly :$timedate, TrueOnly :$geographic,
              TrueOnly :$rangelimited,
              :$textcolor, :&writer? = &!writer
             ) {
    &writer(sprintf("set cbtics %s", self!anytics(:$axis, :$border, :$mirror,
                                                  :$in, :$out, :$scale-default, :$scale-major, :$scale-minor, :$rotate, :$offset,
                                                  :$left, :$right, :$center, :$autojustify,
                                                  :$add,
                                                  :$autofreq,
                                                  :$incr,
                                                  :$start, :$end,
                                                  :@tics,
                                                  :$format, :$font-name, :$font-size, :$enhanced,
                                                  :$numeric, :$timedate, :$geographic,
                                                  :$rangelimited,
                                                  :$textcolor)));
}

