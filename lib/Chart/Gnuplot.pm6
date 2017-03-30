use v6;
unit class Chart::Gnuplot;

has $!gnuplot;
has $!style;
has Bool $.persist;
has $.debug;
has $.terminal;
has %.options;
has $!filename;
has Int $!num-plot;

submethod BUILD(:$!terminal!, Str :$!filename, :$!persist = True, :$!debug = False) {
    my @opts;
    @opts.push('-persist') if $!persist;
    $!gnuplot = run("gnuplot", @opts.join(" "), :in, :out, :err);
    $!num-plot = 0;
}

submethod DESTROY {
    $!gnuplot.in.say: "exit";
}

method terminal($terminal) {
    $!terminal = $terminal;
    $!gnuplot.in.say: sprintf("set terminal \"%s\"", $!terminal);
}

my subset FalseOnly of Bool where { if not $_.defined { True } else { $_ == False } }

method plot(Str :$title, :@range, :@vertices,
            Str :$style, :$linestyle, :$linetype, :$linewidth, :$linecolor,
            :$pointtype, :$pointsize, :$fill, FalseOnly :$hidden3d, FalseOnly :$contours, FalseOnly :$surface, :$palette) {
    my $tmpvariable = '$mydata' ~ ($*PID, time, @vertices.WHERE).join;

    self.command(sprintf("%s << EOD", $tmpvariable));
    for ^@vertices.elems -> $r {
        self.command(@vertices[$r;*].join(" "));
    }
    self.command("EOD");

    my @range-args;
    for @range {
        @range-args.push(sprintf("[%s]", $_.join(":")));
    }

    my @style-args;
    @style-args.push("linestyle " ~ $linestyle) if $linestyle.defined;
    @style-args.push("linetype " ~ $linetype) if $linetype.defined;
    @style-args.push("linewidth " ~ $linewidth) if $linewidth.defined;
    @style-args.push("linecolor " ~ $linecolor) if $linecolor.defined;
    @style-args.push("pointtype " ~ $pointtype) if $pointtype.defined;
    @style-args.push("pointsize " ~ $pointsize) if $pointsize.defined;
    @style-args.push("fill " ~ $fill) if $fill.defined;
    @style-args.push("nohidden3d") if $hidden3d.defined and $hidden3d == False;
    @style-args.push("nocontours") if $contours.defined and $contours == False;
    @style-args.push("nosurface") if $surface.defined and $surface == False;
    @style-args.push("palette") if $palette.defined;

    $!gnuplot.in.say: sprintf("set terminal %s", $!terminal);
    $!gnuplot.in.say: sprintf("set output \"%s\"", $!filename);

    my $cmd = do given $!num-plot {
        when * > 0 { "replot" }
        default { "plot" }
    };
    $!gnuplot.in.say: sprintf("%s %s %s with %s title \"%s\" %s",$cmd, @range-args.join(" "), $tmpvariable, $style, $title, @style-args.join(" "));
    $!num-plot++;
}

my subset LabelRotate of Cool where { if not $_.defined { True } elsif $_ ~~ Bool and $_ == True { False } else { $_ ~~ Real or ($_ ~~ Bool and $_ == False) } };

method label(:$tag, :$label-text, :@at, :$left, :$center, :$right,
             LabelRotate :$rotate, :$font-name, :$font-size, FalseOnly :$enhanced,
             :$front, :$back, :$textcolor, FalseOnly :$point, :$line-type, :$point-type, :$point-size, :@offset,
             :$boxed, :$hypertext) {
    my @args;
    @args.push($tag) if $tag.defined;
    @args.push(sprintf("\"%s\"", $label-text)) if $label-text.defined;
    
    my @at-args;
    if @at.elems >= 2 {
        while @at {
            my $p = @at.shift;
            @at-args.push(sprintf("%s %s", $p.key, $p.value));
        }
    } else {
        die "Error: Found invalid coordinate";
    }
    
    @args.push(sprintf("at %s",@at-args.join(","))) if @at-args.defined;
    @args.push("left") if $left.defined;
    @args.push("center") if $center.defined;
    @args.push("right") if $right.defined;

    if $rotate.defined {
        given $rotate {
            when * ~~ Real { @args.push("rotate by $rotate") }
            when * == False { @args.push("norotate") }
            default { die "Error: Something went wrong." }
        }
    }

    my @font;
    if $font-name.defined {
        @font.push($font-name);
        @font.push($font-size) if $font-size.defined;
        @args.push(sprintf("font \"%s\"", @font.join(",")));
    }

    @args.push("noenhanced") if $enhanced.defined and $enhanced == False;
    @args.push("front") if $front.defined;
    @args.push("back") if $back.defined;
    @args.push("textcolor " ~ $textcolor) if $textcolor.defined;
    @args.push("nopoint") if $point.defined and $point == False;

    my @point-args;
    @point-args.push("lt " ~ $line-type) if $line-type.defined;
    @point-args.push("pt " ~ $point-type) if $point-type.defined;
    @point-args.push("ps " ~ $point-size) if $point-size.defined;

    @args.push("point " ~ @point-args.join(" ")) if @point-args.elems > 0;

    my @offset-args;
    if @offset.elems > 0 {
        while @offset {
            my $p = @offset.shift;
            @offset-args.push(sprintf("%s %s", $p.key, $p.value));
        }
    }

    @args.push("offset " ~ @offset-args.join(",")) if @offset-args.elems > 0;
    @args.push("boxed") if $boxed.defined;
    @args.push("hypertext") if $hypertext.defined;

    $!gnuplot.in.say: sprintf("set label %s", @args.join(" "));
}

my subset AnyLabelRotate of Cool where { if not $_.defined { True } elsif $_ ~~ Bool and $_ == True { False } else { $_ eq "parallel" or $_ ~~ Real or ($_ ~~ Bool and $_ == False) } };

method !anylabel(Str :$label, :@offset, :$font-name, :$font-size, :$textcolor, Bool :$enhanced, AnyLabelRotate :$rotate) {
    my @args;
    @args.push(sprintf("\"%s\"", $label)) if $label.defined;

    my @offset-args;
    if @offset.elems > 0 {
        while @offset {
            my $p = @offset.shift;
            @offset-args.push(sprintf("%s %s", $p.key, $p.value));
        }
    }
    @args.push("offset " ~ @offset-args.join(",")) if @offset-args.elems > 0;

    my @font;
    if $font-name.defined {
        @font.push($font-name);
        @font.push($font-size) if $font-size.defined;
        @args.push(sprintf("font \"%s\"", @font.join(",")));
    }

    @args.push("textcolor " ~ $textcolor) if $textcolor.defined;
    @args.push($enhanced ?? "enhanced" !! "noenhanced") if $enhanced.defined;
    
    if $rotate.defined {
        given $rotate {
            when * ~~ Real { @args.push("rotate by $rotate") }
            when * eq "parallel" { @args.push("rotate parallel") }
            when * == False { @args.push("norotate") }
            default { die "Error: Something went wrong." }
        }
    }
    @args.join(" ");
}

method xlabel(Str :$label, :@offset, :$font-name, :$font-size, :$textcolor, Bool :$enhanced, AnyLabelRotate :$rotate) {
    $!gnuplot.in.say: sprintf("set xlabel %s", self!anylabel(:$label, :@offset, :$font-name, :$font-size, :$textcolor, :$enhanced, :$rotate));
}

method ylabel(Str :$label, :@offset, :$font-name, :$font-size, :$textcolor, Bool :$enhanced, AnyLabelRotate :$rotate) {
    $!gnuplot.in.say: sprintf("set ylabel %s", self!anylabel(:$label, :@offset, :$font-name, :$font-size, :$textcolor, :$enhanced, :$rotate));
}

method zlabel(Str :$label, :@offset, :$font-name, :$font-size, :$textcolor, Bool :$enhanced, AnyLabelRotate :$rotate) {
    $!gnuplot.in.say: sprintf("set zlabel %s", self!anylabel(:$label, :@offset, :$font-name, :$font-size, :$textcolor, :$enhanced, :$rotate));
}

method x2label(Str :$label, :@offset, :$font-name, :$font-size, :$textcolor, Bool :$enhanced, AnyLabelRotate :$rotate) {
    $!gnuplot.in.say: sprintf("set x2label %s", self!anylabel(:$label, :@offset, :$font-name, :$font-size, :$textcolor, :$enhanced, :$rotate));
}

method y2label(Str :$label, :@offset, :$font-name, :$font-size, :$textcolor, Bool :$enhanced, AnyLabelRotate :$rotate) {
    $!gnuplot.in.say: sprintf("set y2label %s", self!anylabel(:$label, :@offset, :$font-name, :$font-size, :$textcolor, :$enhanced, :$rotate));
}

method cblabel(Str :$label, :@offset, :$font-name, :$font-size, :$textcolor, Bool :$enhanced, AnyLabelRotate :$rotate) {
    $!gnuplot.in.say: sprintf("set cblabel %s", self!anylabel(:$label, :@offset, :$font-name, :$font-size, :$textcolor, :$enhanced, :$rotate));
}

method !anyrange(:$min, :$max, :$reverse, :$writeback, :$extend) {
    my @args;
    @args.push(sprintf("[%s:%s]", $min, $max));
    @args.push($reverse ?? "reverse" !! "noreverse") if $reverse.defined;
    @args.push($writeback ?? "writeback" !! "nowriteback") if $writeback.defined;
    @args.push($extend ?? "extend" !! "noextend") if $extend.defined;
    @args.join(" ");
}

multi method xrange(:$min, :$max, :$reverse, :$writeback, :$extend) {
   $!gnuplot.in.say: sprintf("set xrange %s", self!anyrange(:$min, :$max, :$reverse, :$writeback, :$extend));
}

multi method xrange(:$restore) {
    $!gnuplot.in.say: "set xrange restore";
}

multi method yrange(:$min, :$max, :$reverse, :$writeback, :$extend) {
   $!gnuplot.in.say: sprintf("set yrange %s", self!anyrange(:$min, :$max, :$reverse, :$writeback, :$extend));
}

multi method yrange(:$restore) {
    $!gnuplot.in.say: "set yrange restore";
}

multi method zrange(:$min, :$max, :$reverse, :$writeback, :$extend) {
   $!gnuplot.in.say: sprintf("set zrange %s", self!anyrange(:$min, :$max, :$reverse, :$writeback, :$extend));
}

multi method zrange(:$restore) {
    $!gnuplot.in.say: "set zrange restore";
}

multi method x2range(:$min, :$max, :$reverse, :$writeback, :$extend) {
   $!gnuplot.in.say: sprintf("set x2range %s", self!anyrange(:$min, :$max, :$reverse, :$writeback, :$extend));
}

multi method x2range(:$restore) {
    $!gnuplot.in.say: "set x2range restore";
}

multi method y2range(:$min, :$max, :$reverse, :$writeback, :$extend) {
   $!gnuplot.in.say: sprintf("set y2range %s", self!anyrange(:$min, :$max, :$reverse, :$writeback, :$extend));
}

multi method y2range(:$restore) {
    $!gnuplot.in.say: "set y2range restore";
}

multi method cbrange(:$min, :$max, :$reverse, :$writeback, :$extend) {
   $!gnuplot.in.say: sprintf("set cbrange %s", self!anyrange(:$min, :$max, :$reverse, :$writeback, :$extend));
}

multi method cbrange(:$restore) {
    $!gnuplot.in.say: "set cbrange restore";
}

multi method rrange(:$min, :$max, :$reverse, :$writeback, :$extend) {
    $!gnuplot.in.say: sprintf("set rrange %s", self!anyrange(:$min, :$max, :$reverse, :$writeback, :$extend));
}

multi method rrange(:$restore) {
    $!gnuplot.in.say: "set rrange restore";
}

multi method trange(:$min, :$max, :$reverse, :$writeback, :$extend) {
    $!gnuplot.in.say: sprintf("set trange %s", self!anyrange(:$min, :$max, :$reverse, :$writeback, :$extend));
}

multi method trange(:$restore) {
    $!gnuplot.in.say: "set trange restore";
}

multi method urange(:$min, :$max, :$reverse, :$writeback, :$extend) {
    $!gnuplot.in.say: sprintf("set urange %s", self!anyrange(:$min, :$max, :$reverse, :$writeback, :$extend));
}

multi method urange(:$restore) {
    $!gnuplot.in.say: "set urange restore";
}

multi method vrange(:$min, :$max, :$reverse, :$writeback, :$extend) {
    $!gnuplot.in.say: sprintf("set vrange %s", self!anyrange(:$min, :$max, :$reverse, :$writeback, :$extend));
}

multi method vrange(:$restore) {
    $!gnuplot.in.say: "set vrange restore";
}

my subset AnyTicsRotate of Cool where { if not $_.defined { True } elsif $_ ~~ Bool and $_ == True { False } else { $_ ~~ Real or ($_ ~~ Bool and $_ == False) } };
my subset AnyTicsOffset of Mu where { if not $_.defined { True } else { $_ ~~ FalseOnly or ($_ ~~ List and $_.all ~~ Pair|Real) } };

method !anytics(:$axis, :$border, :$mirror,
               :$in, :$out, :$scale-default, :$scale-major, :$scale-minor, AnyTicsRotate :$rotate, AnyTicsOffset :$offset,
               :$left, :$right, :$center, :$autojustify,
               :$add,
               :$autofreq,
               :$incr,
               :$start, :$end,
               :@tics,
               :$format, :$font-name, :$font-size, :$enhanced,
               :$numeric, :$timedate, :$geographic,
               :$rangelimited,
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
            when * ~~ Real { @args.push("rotate by $rotate") }
            when * == False { @args.push("norotate") }
            default { die "Error: Something went wrong." }
        }
    }
    
    if $offset.defined {
        given $offset {
            when * ~~ FalseOnly { @args.push("nooffset") }
            when * ~~ List {
                my @offset-args;
                if $offset.elems > 0 {
                    while $offset {
                        my $p = $offset.shift;
                        @offset-args.push(sprintf("%s %s", $p.key, $p.value));
                    }
                }
                @args.push("offset " ~ @offset-args.join(",")) if @offset-args.elems > 0;
            }
            default { die "Error: Something went wrong." }
        }
    }

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
        while @tics {
            my @tmp;
            my $t = @tics.shift;
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
    
    my @font;
    if $font-name.defined {
        @font.push($font-name);
        @font.push($font-size) if $font-size.defined;
        @args.push(sprintf("font \"%s\"", @font.join(",")));
    }

    @args.push($enhanced ?? "enhanced" !! "noenhanced") if $enhanced.defined;
    @args.push("numeric") if $numeric.defined;
    @args.push("timedate") if $timedate.defined;
    @args.push("geographic") if $geographic.defined;
    @args.push("rangelimited") if $rangelimited.defined;
    @args.push("textcolor " ~ $textcolor) if $textcolor.defined;
    @args.join(" ")
}

method xtics(:$axis, :$border, :$mirror,
             :$in, :$out, :$scale-default, :$scale-major, :$scale-minor, AnyTicsRotate :$rotate, AnyTicsOffset :$offset,
             :$left, :$right, :$center, :$autojustify,
             :$add,
             :$autofreq,
             :$incr,
             :$start, :$end,
             :@tics,
             :$format, :$font-name, :$font-size, :$enhanced,
             :$numeric, :$timedate, :$geographic,
             :$rangelimited,
             :$textcolor
            ) {
    $!gnuplot.in.say: sprintf("set xtics %s", self!anytics(:$axis, :$border, :$mirror,
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
                                                           :$textcolor));
}

method ytics(:$axis, :$border, :$mirror,
             :$in, :$out, :$scale-default, :$scale-major, :$scale-minor, AnyTicsRotate :$rotate, AnyTicsOffset :$offset,
             :$left, :$right, :$center, :$autojustify,
             :$add,
             :$autofreq,
             :$incr,
             :$start, :$end,
             :@tics,
             :$format, :$font-name, :$font-size, :$enhanced,
             :$numeric, :$timedate, :$geographic,
             :$rangelimited,
             :$textcolor
            ) {
    $!gnuplot.in.say: sprintf("set ytics %s", self!anytics(:$axis, :$border, :$mirror,
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
                                                           :$textcolor));
}

method ztics(:$axis, :$border, :$mirror,
             :$in, :$out, :$scale-default, :$scale-major, :$scale-minor, AnyTicsRotate :$rotate, AnyTicsOffset :$offset,
             :$left, :$right, :$center, :$autojustify,
             :$add,
             :$autofreq,
             :$incr,
             :$start, :$end,
             :@tics,
             :$format, :$font-name, :$font-size, :$enhanced,
             :$numeric, :$timedate, :$geographic,
             :$rangelimited,
             :$textcolor
            ) {
    $!gnuplot.in.say: sprintf("set ztics %s", self!anytics(:$axis, :$border, :$mirror,
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
                                                           :$textcolor));
}

method x2tics(:$axis, :$border, :$mirror,
              :$in, :$out, :$scale-default, :$scale-major, :$scale-minor, AnyTicsRotate :$rotate, AnyTicsOffset :$offset,
              :$left, :$right, :$center, :$autojustify,
              :$add,
              :$autofreq,
              :$incr,
              :$start, :$end,
              :@tics,
              :$format, :$font-name, :$font-size, :$enhanced,
              :$numeric, :$timedate, :$geographic,
              :$rangelimited,
              :$textcolor
             ) {
    $!gnuplot.in.say: sprintf("set x2tics %s", self!anytics(:$axis, :$border, :$mirror,
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
                                                            :$textcolor));
}

method y2tics(:$axis, :$border, :$mirror,
              :$in, :$out, :$scale-default, :$scale-major, :$scale-minor, AnyTicsRotate :$rotate, AnyTicsOffset :$offset,
              :$left, :$right, :$center, :$autojustify,
              :$add,
              :$autofreq,
              :$incr,
              :$start, :$end,
              :@tics,
              :$format, :$font-name, :$font-size, :$enhanced,
              :$numeric, :$timedate, :$geographic,
              :$rangelimited,
              :$textcolor
             ) {
    $!gnuplot.in.say: sprintf("set y2tics %s", self!anytics(:$axis, :$border, :$mirror,
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
                                                            :$textcolor));
}

method cbtics(:$axis, :$border, :$mirror,
              :$in, :$out, :$scale-default, :$scale-major, :$scale-minor, AnyTicsRotate :$rotate, AnyTicsOffset :$offset,
              :$left, :$right, :$center, :$autojustify,
              :$add,
              :$autofreq,
              :$incr,
              :$start, :$end,
              :@tics,
              :$format, :$font-name, :$font-size, :$enhanced,
              :$numeric, :$timedate, :$geographic,
              :$rangelimited,
              :$textcolor
             ) {
    $!gnuplot.in.say: sprintf("set cbtics %s", self!anytics(:$axis, :$border, :$mirror,
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
                                                            :$textcolor));
}

my subset LegendMax of Cool where { if not $_.defined { True } else { $_ eq "auto" or $_ ~~ Real } };

method legend(:$on, :$off, :$default, :$inside, :$outside, :$lmargin, :$rmargin, :$tmargin, :$bmargin,
              :$at,
              :$left, :$right, :$center, :$top, :$bottom,
              :$vertical, :$horizontal, :$Left, :$Right,
              :$opaque, :$reverse, :$invert,
              :$samplen, :$spacing, :$width, :$height,
              :$autotitle, :$columnheader, :$title, :$font-name, :$font-size, :$textcolor,
              :$box, :$linestyle, :$linetype, :$linewidth,
              LegendMax :$maxcols, LegendMax :$maxrows) {
    my @args;
    @args.push("on") if $on.defined;
    @args.push("off") if $off.defined;
    @args.push("default") if $default.defined;
    @args.push("inside") if $inside.defined;
    @args.push("outside") if $outside.defined;
    @args.push("lmargin") if $lmargin.defined;
    @args.push("rmargin") if $rmargin.defined;
    @args.push("tmargin") if $tmargin.defined;
    @args.push("bmargin") if $bmargin.defined;
    @args.push(sprintf("at %s", $at)) if $at.defined;
    @args.push("left") if $left.defined;
    @args.push("right") if $right.defined;
    @args.push("top") if $top.defined;
    @args.push("bottom") if $bottom.defined;
    @args.push("center") if $center.defined;
    @args.push("vertical") if $vertical.defined;
    @args.push("horizontal") if $horizontal.defined;
    @args.push("Left") if $Left.defined;
    @args.push("Right") if $Right.defined;
    @args.push($opaque ?? "opaque" !! "noopaque") if $opaque.defined;
    @args.push($reverse ?? "reverse" !! "noreverse") if $reverse.defined;
    @args.push($invert ?? "invert" !! "noinvert") if $invert.defined;
    @args.push("samplen " ~ $samplen) if $samplen.defined;
    @args.push("spacing " ~ $spacing) if $spacing.defined;
    @args.push("width " ~ $width) if $width.defined;
    @args.push("height " ~ $height) if $height.defined;
    @args.push("autotitle") if $autotitle.defined;
    @args.push("columnheader") if $autotitle.defined and $columnheader.defined;
    @args.push(sprintf("title \"%s\"", $title)) if $title.defined;
    
    my @font;
    if $font-name.defined {
        @font.push($font-name);
        @font.push($font-size) if $font-size.defined;
        @args.push(sprintf("font \"%s\"", @font.join(",")));
    }
    
    @args.push("textcolor " ~ $textcolor) if $textcolor.defined;
    @args.push($box ?? "box" !! "nobox") if $box.defined;
    @args.push("linestyle " ~ $linestyle) if $box.defined and $linestyle.defined;
    @args.push("linetype " ~ $linetype) if $box.defined and $linetype.defined;
    @args.push("linewidth " ~ $linewidth) if $box.defined and $linewidth.defined;
    if $maxcols.defined {
        @args.push("maxcols " ~ $maxcols) if $maxcols ~~ Real;
        @args.push("maxcols auto") if $maxcols eq "auto";
    }

    if $maxrows.defined {
        @args.push("maxrows " ~ $maxrows) if $maxrows ~~ Real;
        @args.push("maxrows auto") if $maxrows eq "auto";
    }

    $!gnuplot.in.say: sprintf("set key %s", @args.join(" "));
}

method border(:$integer, :$front, :$back, :$behind,
              :lw(:$linewidth), :ls(:$linestyle), :lt(:$linetype)) {
    my @args;
    @args.push($integer) if $integer.defined;
    @args.push("front") if $front.defined;
    @args.push("back") if $back.defined;
    @args.push("begind") if $behind.defined;
    @args.push("linewidth " ~ $linewidth) if $linewidth.defined;
    @args.push("linestyle " ~ $linestyle) if $linestyle.defined;
    @args.push("linetype " ~ $linetype) if $linetype.defined;

    $!gnuplot.in.say: sprintf("set border %s", @args.join(" "));
}

method grid(:$xtics, :$ytics, :$ztics, :$x2tics, :$y2tics, :$cbtics,
            :$polar, :$layerdefault, :$front, :$back,
            :ls(:@linestyle), :lt(:@linetype), :lw(:@linewidth)) {
    my @args;
    @args.push($xtics) if $xtics.defined;
    @args.push($ytics) if $ytics.defined;
    @args.push($ztics) if $ztics.defined;
    @args.push($x2tics) if $x2tics.defined;
    @args.push($y2tics) if $y2tics.defined;
    @args.push($cbtics) if $cbtics.defined;
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

    $!gnuplot.in.say: sprintf("set grid %s", @args.join(" "));
}

method timestamp(:$format, :$top, :$bottom, :$rotate,
                 :$offset, :$font-name, :$font-size, :$textcolor) {
    my @args;
    @args.push(sprintf("\"%s\"", $format)) if $format.defined;
    @args.push("top") if $top.defined;
    @args.push("bottom") if $bottom.defined;
    @args.push($rotate ?? "rotate" !! "norotate") if $rotate.defined;

    my @off-args;
    @off-args.push($offset<xoff>) if $offset<xoff>:exists;
    @off-args.push($offset<yoff>) if $offset<xoff>:exists and $offset<yoff>:exists;
    @args.push(sprintf("offset %s", @off-args.join(","))) if @off-args.elems > 0;

    my @font;
    if $font-name.defined {
        @font.push($font-name);
        @font.push($font-size) if $font-size.defined;
        @args.push(sprintf("font \"%s\"", @font.join(",")));
    }

    @args.push("textcolor " ~ $textcolor) if $textcolor.defined;

    $!gnuplot.in.say: sprintf("set timestamp %s", @args.join(" "));
}

method !anyobject(:$front, :$back, :$behind, Bool :$clip, :$fillcolor, :$fillstyle,
                  :$default, :$linewidth, :$dashtype) {

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
    @args.join(" ");
}

multi method rectangle(:$index, :@from, :@to,
                       :$front, :$back, :$behind, Bool :$clip, :$fillcolor, :$fillstyle,
                       :$default, :$linewidth, :$dashtype) {
    my @from-args;
    if @from.elems >= 2 {
        while @from {
            my $p = @from.shift;
            @from-args.push(sprintf("%s %s", $p.key, $p.value));
        }
        @from-args.join(" ");
    } else {
        die "Error: Found invalid coordinate";
    }

    my @to-args;
    if @to.elems >= 2 {
        while @to {
            my $p = @to.shift;
            @to-args.push(sprintf("%s %s", $p.key, $p.value));
        }
        @to-args.join(" ");
    } else {
        die "Error: Found invalid coordinate";
    }

    $!gnuplot.in.say: sprintf("set object %d rectangle from %s to %s %s", $index, @from-args.join(","), @to-args.join(","),
                              self!anyobject(:$front, :$back, :$behind, :$clip, :$fillcolor, :$fillstyle,
                                             :$default, :$linewidth, :$dashtype));
}

multi method rectangle(:$index, :@from, :@rto,
                       :$front, :$back, :$behind, Bool :$clip, :$fillcolor, :$fillstyle,
                       :$default, :$linewidth, :$dashtype) {
    my @from-args;
    if @from.elems >= 2 {
        while @from {
            my $p = @from.shift;
            @from-args.push(sprintf("%s %s", $p.key, $p.value));
        }
        @from-args.join(" ");
    } else {
        die "Error: Found invalid coordinate";
    }

    my @rto-args;
    if @rto.elems >= 2 {
        while @rto {
            my $p = @rto.shift;
            @rto-args.push(sprintf("%s %s", $p.key, $p.value));
        }
        @rto-args.join(" ");
    } else {
        die "Error: Found invalid coordinate";
    }

    $!gnuplot.in.say: sprintf("set object %d rectangle from %s to %s %s", $index, @from-args.join(","), @rto-args.join(","),
                              self!anyobject(:$front, :$back, :$behind, :$clip, :$fillcolor, :$fillstyle,
                                             :$default, :$linewidth, :$dashtype));
}

method ellipse(:$index, :center(:@at), :$w, :$h,
               :$front, :$back, :$behind, Bool :$clip, :$fillcolor, :$fillstyle,
               :$default, :$linewidth, :$dashtype) {
    my @at-args;
    if @at.elems >= 2 {
        while @at {
            my $p = @at.shift;
            @at-args.push(sprintf("%s %s", $p.key, $p.value));
        }
        @at-args.join(" ");
    } else {
        die "Error: Found invalid coordinate";
    }

    $!gnuplot.in.say: sprintf("set object %d ellipse at %s size %d,%d %s", $index, @at-args.join(","), $w, $h,
                              self!anyobject(:$front, :$back, :$behind, :$clip, :$fillcolor, :$fillstyle,
                                             :$default, :$linewidth, :$dashtype));
}

method circle(:$index, :center(:@at), :$radius,
              :$front, :$back, :$behind, Bool :$clip, :$fillcolor, :$fillstyle,
              :$default, :$linewidth, :$dashtype) {
    my @at-args;
    if @at.elems >= 2 {
        while @at {
            my $p = @at.shift;
            @at-args.push(sprintf("%s %s", $p.key, $p.value));
        }
        @at-args.join(" ");
    } else {
        die "Error: Found invalid coordinate";
    }

    $!gnuplot.in.say: sprintf("set object %d circle at %s size %d %s", $index, @at-args.join(","), $radius,
                              self!anyobject(:$front, :$back, :$behind, :$clip, :$fillcolor, :$fillstyle,
                                             :$default, :$linewidth, :$dashtype));
}

method polygon(:$index, :@from, :@to,
               :$front, :$back, :$behind, Bool :$clip, :$fillcolor, :$fillstyle,
               :$default, :$linewidth, :$dashtype) {
    my @from-args;
    if @from.elems >= 2 {
        while @from {
            my $p = @from.shift;
            @from-args.push(sprintf("%s %s", $p.key, $p.value));
        }
        @from-args.join(" ");
    } else {
        die "Error: Found invalid coordinate";
    }

    my &myproc = -> @at {
        my @at-args;
        if @at.elems >= 2 {
            while @at {
                my $p = @at.shift;
                @at-args.push(sprintf("%s %s", $p.key, $p.value));
            }
            @at-args.join(" ");
        } else {
            die "Error: Found invalid coordinate";
        }
        @at-args
    }

    $!gnuplot.in.say: sprintf("set object %d polygon from %s %s %s", $index, @from-args.join(","), @to.map({ "to " ~ myproc($_).join(",") }).join(" "),
                              self!anyobject(:$front, :$back, :$behind, :$clip, :$fillcolor, :$fillstyle,
                                             :$default, :$linewidth, :$dashtype));
}

method command(Str $command) {
    $!gnuplot.in.say: $command;
}

=begin pod

=head1 NAME

Chart::Gnuplot - blah blah blah

=head1 SYNOPSIS

  use Chart::Gnuplot;

=head1 DESCRIPTION

Chart::Gnuplot is ...

=head1 AUTHOR

titsuki <titsuki@cpan.org>

=head1 COPYRIGHT AND LICENSE

Copyright 2017 titsuki

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
