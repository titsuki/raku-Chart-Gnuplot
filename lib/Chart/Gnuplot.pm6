use v6;
unit class Chart::Gnuplot:ver<0.0.10>;

use Chart::Gnuplot::Arrow;
use Chart::Gnuplot::Border;
use Chart::Gnuplot::Grid;
use Chart::Gnuplot::Label;
use Chart::Gnuplot::Legend;
use Chart::Gnuplot::Object;
use Chart::Gnuplot::Output;
use Chart::Gnuplot::Range;
use Chart::Gnuplot::Terminal;
use Chart::Gnuplot::Tics;
use Chart::Gnuplot::Timestamp;
use Chart::Gnuplot::Title;
use Chart::Gnuplot::Util;
use Chart::Gnuplot::Subset;

has $!gnuplot;
has Bool $.persist;
has $.debug;
has %.options;
has Int $!num-plot;
has $!promise;
has @!msg-pool;
has &!writer;

has Chart::Gnuplot::Arrow $!arrow handles <arrow>;
has Chart::Gnuplot::Border $!border handles <border>;
has Chart::Gnuplot::Grid $!grid handles <grid>;
has Chart::Gnuplot::Label $!label handles <label xlabel ylabel zlabel x2label y2label cblabel>;
has Chart::Gnuplot::Legend $!legend handles <legend>;
has Chart::Gnuplot::Object $!object handles <rectangle ellipse circle polygon>;
has Chart::Gnuplot::Output $.output;
has Chart::Gnuplot::Range $!range handles <xrange yrange zrange x2range y2range cbrange rrange trange urange vrange>;
has Chart::Gnuplot::Terminal $!terminal;
has Chart::Gnuplot::Tics $!tics handles <xtics ytics ztics x2tics y2tics cbtics>;
has Chart::Gnuplot::Timestamp $!timestamp handles <timestamp>;
has Chart::Gnuplot::Title $!title handles <title>;

submethod BUILD(:$terminal!, Str :$filename, :$!persist = True, :$!debug = False, :&!writer? = -> $msg { self.command: $msg }) {
    my $HOME = qq:x/echo \$HOME/.subst(/\s*/,"",:g);
    my $prefix = "$HOME/.p6chart-gnuplot";

    my @opts;
    @opts.push('-persist') if $!persist;
    $!gnuplot = Proc::Async.new(:w, "$prefix/bin/gnuplot", @opts.join(" "));

    if $!debug {
        $!gnuplot.stderr.act(-> $v { @!msg-pool.push($v); });
        $!gnuplot.stdout.act(-> $v { @!msg-pool.push($v); });
    } else {
        $!gnuplot.stderr.act({;});
        $!gnuplot.stdout.act({;});
    }
    $!promise = $!gnuplot.start;
    $!num-plot = 0;

    $!arrow = Chart::Gnuplot::Arrow.new(:&!writer);
    $!border = Chart::Gnuplot::Border.new(:&!writer);
    $!grid = Chart::Gnuplot::Grid.new(:&!writer);
    $!label = Chart::Gnuplot::Label.new(:&!writer);
    $!legend = Chart::Gnuplot::Legend.new(:&!writer);
    $!object = Chart::Gnuplot::Object.new(:&!writer);
    $!output = Chart::Gnuplot::Output.new(:$filename, :&!writer);
    $!range = Chart::Gnuplot::Range.new(:&!writer);
    $!terminal = Chart::Gnuplot::Terminal.new(:type($terminal), :&!writer);
    $!tics = Chart::Gnuplot::Tics.new(:&!writer);
    $!timestamp = Chart::Gnuplot::Timestamp.new(:&!writer);
    $!title = Chart::Gnuplot::Title.new(:&!writer);
}

submethod DESTROY {
    $!gnuplot.close-stdin;
    await $!promise;
}

method terminal($terminal, :&writer? = -> $msg { self.command: $msg }) {
    $!terminal.writer(&writer).type($terminal).set;
}

multi method plot(:$title, :$ignore, :@range, :@vertices!, :$smooth,
                  :@using,
                  Str :$style, :ls(:$linestyle), :lt(:$linetype), :lw(:$linewidth), :lc(:$linecolor),
                  :pt(:$pointtype), :ps(:$pointsize), :$fill, FalseOnly :$hidden3d, FalseOnly :$contours, FalseOnly :$surface, :$palette,
                  :&writer? = -> $msg { self.command: $msg }) {
    my @args;

    my $tmpvariable = '$mydata' ~ ($*PID, time, @vertices.WHERE).join;
    &writer(sprintf("%s << EOD", $tmpvariable));
    for ^@vertices.elems -> $r {
        &writer(@vertices[$r;*].join(" "));
    }
    &writer("EOD");

    for @range {
        @args.push(sprintf("[%s]", $_.join(":")));
    }

    @args.push($tmpvariable);
    @args.push("using " ~ @using.join(":")) if @using.elems > 0;
    @args.push(sprintf("smooth %s", $smooth)) if $smooth.defined;
    @args.push("with " ~ $style) if $style.defined;

    if $title.defined {
        given $title {
            when * ~~ Str { @args.push(sprintf("title \"%s\"", $title)) }
            when * == False { @args.push(sprintf("notitle")) }
        }
    }

    @args.push(sprintf("notitle [%s]", $ignore)) if $ignore.defined;

    @args.push("linestyle " ~ $linestyle) if $linestyle.defined;
    @args.push("linetype " ~ $linetype) if $linetype.defined;
    @args.push("linewidth " ~ $linewidth) if $linewidth.defined;
    @args.push("linecolor " ~ $linecolor) if $linecolor.defined;
    @args.push("pointtype " ~ $pointtype) if $pointtype.defined;
    @args.push("pointsize " ~ $pointsize) if $pointsize.defined;
    @args.push("fill " ~ $fill) if $fill.defined;
    @args.push("nohidden3d") if $hidden3d.defined and $hidden3d == False;
    @args.push("nocontours") if $contours.defined and $contours == False;
    @args.push("nosurface") if $surface.defined and $surface == False;
    @args.push("palette") if $palette.defined;

    $!terminal.writer(&writer).set;
    $!output.writer(&writer).set;

    my $cmd = do given $!num-plot {
        when * > 0 { "replot" }
        default { "plot" }
    };
    &writer(sprintf("%s %s",$cmd, @args.grep(* ne "").join(" ")));
    $!num-plot++;
}

multi method plot(:$title, :$ignore, :@range, :$function!, :$smooth,
                  Str :$style, :ls(:$linestyle), :lt(:$linetype), :lw(:$linewidth), :lc(:$linecolor),
                  :pt(:$pointtype), :ps(:$pointsize), :$fill, FalseOnly :$hidden3d, FalseOnly :$contours, FalseOnly :$surface, :$palette,
                  :&writer? = -> $msg { self.command: $msg }) {
    my @args;

    for @range {
        @args.push(sprintf("[%s]", $_.join(":")));
    }
    
    @args.push($function) if $function.defined;

    if $title.defined {
        given $title {
            when * ~~ Str { @args.push(sprintf("title \"%s\"", $title)) }
            when * == False { @args.push(sprintf("notitle")) }
        }
    }

    @args.push(sprintf("notitle [%s]", $ignore)) if $ignore.defined;
    @args.push(sprintf("smooth %s", $smooth)) if $smooth.defined;
    @args.push("with " ~ $style) if $style.defined;

    @args.push("linestyle " ~ $linestyle) if $linestyle.defined;
    @args.push("linetype " ~ $linetype) if $linetype.defined;
    @args.push("linewidth " ~ $linewidth) if $linewidth.defined;
    @args.push("linecolor " ~ $linecolor) if $linecolor.defined;
    @args.push("pointtype " ~ $pointtype) if $pointtype.defined;
    @args.push("pointsize " ~ $pointsize) if $pointsize.defined;
    @args.push("fill " ~ $fill) if $fill.defined;
    @args.push("nohidden3d") if $hidden3d.defined and $hidden3d == False;
    @args.push("nocontours") if $contours.defined and $contours == False;
    @args.push("nosurface") if $surface.defined and $surface == False;
    @args.push("palette") if $palette.defined;

    $!terminal.writer(&writer).set;
    $!output.writer(&writer).set;

    my $cmd = do given $!num-plot {
        when * > 0 { "replot" }
        default { "plot" }
    };

    &writer(sprintf("%s %s", $cmd, @args.grep(* ne "").join(" ")));
    $!num-plot++;
}

multi method splot(:@range,
                   :@vertices!, :$smooth,
                   :$binary, :$matrix, :$index, :$every,
                   :$title, :$style, :ls(:$linestyle), :lt(:$linetype), :lw(:$linewidth), :lc(:$linecolor),
                   :pt(:$pointtype), :ps(:$pointsize), :$fill, FalseOnly :$hidden3d, FalseOnly :$contours, FalseOnly :$surface, :$palette, :&writer? = -> $msg { self.command: $msg }) {
    my @args;

    for @range {
        @args.push(sprintf("[%s]", $_.join(":")));
    }

    my $tmpvariable = '$mydata' ~ ($*PID, time, @vertices.WHERE).join;
    &writer(sprintf("%s << EOD", $tmpvariable));
    for ^@vertices.elems -> $r {
        &writer(@vertices[$r;*].join(" "));
    }
    &writer("EOD");

    @args.push($tmpvariable);

    @args.push("binary") if $binary.defined;
    @args.push("matrix") if $matrix.defined;
    @args.push("index") if $index.defined;
    @args.push("every") if $every.defined;

    if $title.defined {
        given $title {
            when * ~~ Str { @args.push(sprintf("title \"%s\"", $title)) }
            when * == False { @args.push(sprintf("notitle")) }
        }
    }

    @args.push(sprintf("smooth %s", $smooth)) if $smooth.defined;
    @args.push("with " ~ $style) if $style.defined;

    @args.push("linestyle " ~ $linestyle) if $linestyle.defined;
    @args.push("linetype " ~ $linetype) if $linetype.defined;
    @args.push("linewidth " ~ $linewidth) if $linewidth.defined;
    @args.push("linecolor " ~ $linecolor) if $linecolor.defined;
    @args.push("pointtype " ~ $pointtype) if $pointtype.defined;
    @args.push("pointsize " ~ $pointsize) if $pointsize.defined;
    @args.push("fill " ~ $fill) if $fill.defined;
    @args.push("nohidden3d") if $hidden3d.defined and $hidden3d == False;
    @args.push("nocontours") if $contours.defined and $contours == False;
    @args.push("nosurface") if $surface.defined and $surface == False;
    @args.push("palette") if $palette.defined;

    $!terminal.writer(&writer).set;
    $!output.writer(&writer).set;

    my $cmd = do given $!num-plot {
        when * > 0 { "replot" }
        default { "splot" }
    };
    &writer(sprintf("%s %s", $cmd, @args.grep(* ne "").join(" ")));
    $!num-plot++;
}

multi method splot(:@range,
                   :$function!, :$smooth,
                   :$title, :$style, :ls(:$linestyle), :lt(:$linetype), :lw(:$linewidth), :lc(:$linecolor),
                   :pt(:$pointtype), :ps(:$pointsize), :$fill, FalseOnly :$hidden3d, FalseOnly :$contours, FalseOnly :$surface, :$palette, :&writer? = -> $msg { self.command: $msg }) {
    my @args;

    for @range {
        @args.push(sprintf("[%s]", $_.join(":")));
    }

    @args.push($function) if $function.defined;

    if $title.defined {
        given $title {
            when * ~~ Str { @args.push(sprintf("title \"%s\"", $title)) }
            when * == False { @args.push(sprintf("notitle")) }
        }
    }

    @args.push(sprintf("smooth %s", $smooth)) if $smooth.defined;
    @args.push("with " ~ $style) if $style.defined;

    @args.push("linestyle " ~ $linestyle) if $linestyle.defined;
    @args.push("linetype " ~ $linetype) if $linetype.defined;
    @args.push("linewidth " ~ $linewidth) if $linewidth.defined;
    @args.push("linecolor " ~ $linecolor) if $linecolor.defined;
    @args.push("pointtype " ~ $pointtype) if $pointtype.defined;
    @args.push("pointsize " ~ $pointsize) if $pointsize.defined;
    @args.push("fill " ~ $fill) if $fill.defined;
    @args.push("nohidden3d") if $hidden3d.defined and $hidden3d == False;
    @args.push("nocontours") if $contours.defined and $contours == False;
    @args.push("nosurface") if $surface.defined and $surface == False;
    @args.push("palette") if $palette.defined;

    $!terminal.writer(&writer).set;
    $!output.writer(&writer).set;

    my $cmd = do given $!num-plot {
        when * > 0 { "replot" }
        default { "splot" }
    };
    &writer(sprintf("%s %s", $cmd, @args.grep(* ne "").join(" ")));
    $!num-plot++;
}

method multiplot(:$title, :$font-name, :$font-size, Bool :$enhanced, :@layout, :$rowsfirst, :$columnsfirst,
                 :$downwards, :$upwards, :$scale, :$offset, :$margins,
                 :$spacing, :&writer = -> $msg { self.command: $msg }) {
    my @args;

    @args.push(sprintf("title \"%s\"", $title)) if $title.defined;
    @args.push(tweak-fontargs(:$font-name, :$font-size));
    @args.push($enhanced ?? "enhanced" !! "noenhanced") if $enhanced.defined;
    @args.push("layout " ~ @layout.join(",")) if @layout.elems > 0;
    @args.push("rowsfirst") if $rowsfirst.defined;
    @args.push("columnsfirst") if $columnsfirst.defined;
    @args.push("downwards") if $downwards.defined;
    @args.push("upwards") if $upwards.defined;
    @args.push("scale " ~ $scale.join(",")) if $scale.defined;
    @args.push(tweak-coordinate(:name("offset"), :coordinate($offset)));
    @args.push("margins " ~ $margins.join(",")) if $margins.elems == 4;
    @args.push("spacing " ~ $spacing.join(",")) if $spacing.defined;

    &writer(sprintf("set multiplot %s", @args.grep(* ne "").join(" ")));
}

method dispose {
    self.command: "exit";
    $!gnuplot.close-stdin;
    await $!promise;
}

method command(Str $command) {
    try sink await $!gnuplot.say: $command;

    if $!debug {
        sleep .5 unless @!msg-pool;
        $*ERR.print: $command ~ "\n"; # for IO::Capture::Simple
        $*ERR.print: @!msg-pool.join;
        @!msg-pool = ();
    }
}

=begin pod

=head1 NAME

Chart::Gnuplot - A Perl 6 bindings for gnuplot

=head1 SYNOPSIS

=head3 SOURCE

    use Chart::Gnuplot;
    use Chart::Gnuplot::Subset;
    my $gnu = Chart::Gnuplot.new(:terminal("png"), :filename("histogram.png"));
    
    my @data = (q:to/EOF/).split("\n", :skip-empty)>>.split(" ", :skip-empty);
    Year Male Female
    1950 100 90
    1960 100 90
    1970 80 70
    1980 130 140
    1990 140 120
    2000 200 210
    2010 240 230
    2020 400 420
    EOF
    
    my ($header, *@body) = @data;
    
    $gnu.command("set style histogram clustered");
    $gnu.legend(:left);
    my AnyTicsTic @tics = (@body>>.[0]).pairs.map(-> (:key($pos), :value($year)) { %(:label($year), :pos($pos)) });
    $gnu.xtics(:tics(@tics));
    $gnu.xlabel(:label($header[0]));
    $gnu.plot(:vertices(@body), :using([2]), :style("histogram"), :title($header[1]), :fill("solid 1.0"));
    $gnu.plot(:vertices(@body), :using([3]), :style("histogram"), :title($header[2]), :fill("solid 1.0"));
    
    $gnu.dispose;

=head3 OUTPUT

=begin para

    <img src="histogram.png" alt="histogram">

=end para

=head1 DESCRIPTION

Chart::Gnuplot is a Perl 6 naive bindings for gnuplot. Chart::Gnuplot runs C<gnuplot> using C<Proc::Async> and enables you to plot chart or graph with Perl6ish interface.


=head2 SUBSET

Defined as:

        subset FalseOnly of Bool is export where { $_ ~~ Bool:U or $_ === False };
        subset TrueOnly of Bool is export where { $_ ~~ Bool:U or $_ === True};
        subset LabelRotate of Cool is export where { $_ ~~ Cool:U or $_ ~~ Real or $_ === False };
        subset AnyLabelRotate of Cool is export where { $_ ~~ Cool:U or $_ eq "parallel" or $_ ~~ Real or $_ === False };
        subset LegendMax of Cool is export where { $_ ~~ Cool:U or $_ eq "auto" or $_ ~~ Real };
        subset AnyTicsRotate of Cool is export where { $_ ~~ Cool:U or $_ ~~ Real or $_ === False };
        subset AnyTicsOffset of Mu is export where { $_ ~~ Mu:U or $_ ~~ FalseOnly or ($_ ~~ List and $_.all ~~ Pair|Real) };
        subset AnyTicsTic of Mu is export where { $_ ~~ Mu:U or $_ ~~ Hash and .<label>:exists and .<pos>:exists and .keys.grep(* eq "label"|"pos"|"level").elems == .keys.elems };

=head2 METHODS

=head3 terminal

Defined as:

        method terminal($terminal)

Tells gnuplot what kind of output to generate.

=head3 plot

Defined as:

        multi method plot(
                :$title, :$ignore, :@range, :@vertices!, :$smooth,
                :@using,
                Str :$style, :ls(:$linestyle), :lt(:$linetype), :lw(:$linewidth), :lc(:$linecolor),
                :pt(:$pointtype), :ps(:$pointsize), :$fill, FalseOnly :$hidden3d, FalseOnly :$contours,
                FalseOnly :$surface, :$palette,
                :&writer? = -> $msg { self.command: $msg }
        )

        multi method plot(
              :$title, :$ignore, :@range, :$function!, :$smooth,
              Str :$style, :ls(:$linestyle), :lt(:$linetype), :lw(:$linewidth), :lc(:$linecolor),
              :pt(:$pointtype), :ps(:$pointsize), :$fill, FalseOnly :$hidden3d, FalseOnly :$contours,
              FalseOnly :$surface, :$palette,
              :&writer? = -> $msg { self.command: $msg }
        )

Draws a 2-dimensional plot.

=head3 splot

Defined as:

        multi method splot(
              :@range,
              :@vertices!, :$smooth,
              :$binary, :$matrix, :$index, :$every,
              :$title, :$style, :ls(:$linestyle), :lt(:$linetype), :lw(:$linewidth), :lc(:$linecolor),
              :$pointtype, :$pointsize, :$fill, FalseOnly :$hidden3d, FalseOnly :$contours,
              FalseOnly :$surface, :$palette, :&writer? = -> $msg { self.command: $msg }
        )

        multi method splot(
              :@range,
              :$function!, :$smooth,
              :$title, :$style, :ls(:$linestyle), :lt(:$linetype), :lw(:$linewidth), :lc(:$linecolor),
              :$pointtype, :$pointsize, :$fill, FalseOnly :$hidden3d, FalseOnly :$contours,
              FalseOnly :$surface, :$palette, :&writer? = -> $msg { self.command: $msg }
        )

Draws a 3-dimensional plot.

=head3 label

Defined as:

        method label(
               :$tag, Str :$label-text, :$at, TrueOnly :$left, TrueOnly :$center, TrueOnly :$right,
               LabelRotate :$rotate, :$font-name, :$font-size, FalseOnly :$enhanced,
               TrueOnly :$front, TrueOnly :$back, :$textcolor, FalseOnly :$point, :$line-type, :$point-type, :$point-size, :$offset,
               TrueOnly :$boxed, TrueOnly :$hypertext, :&writer? = -> $msg { self.command: $msg }
        )

Places the text string at the corresponding 2D or 3D position.

=head3 xlabel

Defined as:

       method xlabel(
              Str :$label, :$offset, :$font-name, :$font-size, :$textcolor,
              Bool :$enhanced, AnyLabelRotate :$rotate, :&writer? = -> $msg { self.command: $msg }
       )

Sets the x-axis label.

=head3 ylabel

Defined as:

       method ylabel(
              Str :$label, :$offset, :$font-name, :$font-size, :$textcolor,
              Bool :$enhanced, AnyLabelRotate :$rotate, :&writer? = -> $msg { self.command: $msg }
       )

Sets the y-axis label.

=head3 zlabel

Defined as:

       method zlabel(
              Str :$label, :$offset, :$font-name, :$font-size, :$textcolor,
              Bool :$enhanced, AnyLabelRotate :$rotate, :&writer? = -> $msg { self.command: $msg }
       )

Sets the z-axis label.

=head3 x2label

Defined as:

       method x2label(
              Str :$label, :$offset, :$font-name, :$font-size, :$textcolor,
              Bool :$enhanced, AnyLabelRotate :$rotate, :&writer? = -> $msg { self.command: $msg }
       )

Sets the x2-axis label.

=head3 y2label

Defined as:

       method y2label(
              Str :$label, :$offset, :$font-name, :$font-size, :$textcolor,
              Bool :$enhanced, AnyLabelRotate :$rotate, :&writer? = -> $msg { self.command: $msg }
       )

Sets the y2-axis label.

=head3 cblabel

Defined as:

       method cblabel(
              Str :$label, :$offset, :$font-name, :$font-size, :$textcolor,
              Bool :$enhanced, AnyLabelRotate :$rotate, :&writer? = -> $msg { self.command: $msg }
       )

Sets the cb-axis label.

=head3 xrange

Defined as:

        multi method xrange(
              :$min, :$max, Bool :$reverse, Bool :$writeback, Bool :$extend,
              :&writer? = -> $msg { self.command: $msg }
        )

        multi method xrange(TrueOnly :$restore, :&writer? = -> $msg { self.command: $msg })

Sets the horizontal range that will be displayed.

=head3 yrange

Defined as:

        multi method yrange(
              :$min, :$max, Bool :$reverse, Bool :$writeback, Bool :$extend,
              :&writer? = -> $msg { self.command: $msg }
        )

        multi method yrange(TrueOnly :$restore, :&writer? = -> $msg { self.command: $msg })

Sets the vertical range that will be displayed.

=head3 zrange

Defined as:

        multi method zrange(
              :$min, :$max, Bool :$reverse, Bool :$writeback, Bool :$extend,
              :&writer? = -> $msg { self.command: $msg }
        )

        multi method zrange(TrueOnly :$restore, :&writer? = -> $msg { self.command: $msg })

Sets the range that will be displayed on the z axis.

=head3 x2range

Defined as:

        multi method x2range(
              :$min, :$max, Bool :$reverse, Bool :$writeback, Bool :$extend,
              :&writer? = -> $msg { self.command: $msg }
        )

        multi method x2range(TrueOnly :$restore, :&writer? = -> $msg { self.command: $msg })

Sets the range that will be displayed on the x2 axis.

=head3 y2range

Defined as:

        multi method y2range(
              :$min, :$max, Bool :$reverse, Bool :$writeback, Bool :$extend,
              :&writer? = -> $msg { self.command: $msg }
        )

        multi method y2range(TrueOnly :$restore, :&writer? = -> $msg { self.command: $msg })

Sets the range that will be displayed on the y2 axis.

=head3 cbrange

Defined as:

        multi method cbrange(
              :$min, :$max, Bool :$reverse, Bool :$writeback, Bool :$extend,
              :&writer? = -> $msg { self.command: $msg }
        )

        multi method cbrange(TrueOnly :$restore, :&writer? = -> $msg { self.command: $msg })

Sets the range of values which are colored.

=head3 rrange

Defined as:

        multi method rrange(
              :$min, :$max, Bool :$reverse, Bool :$writeback, Bool :$extend,
              :&writer? = -> $msg { self.command: $msg }
        )

        multi method rrange(TrueOnly :$restore, :&writer? = -> $msg { self.command: $msg })

Sets the range that will be displayed on the r axis.

=head3 trange

Defined as:

        multi method trange(
              :$min, :$max, Bool :$reverse, Bool :$writeback, Bool :$extend,
              :&writer? = -> $msg { self.command: $msg }
        )

        multi method trange(TrueOnly :$restore, :&writer? = -> $msg { self.command: $msg })

Sets the parametric range used to compute x and y values when in parametric or polar modes.

=head3 urange

Defined as:

        multi method urange(
              :$min, :$max, Bool :$reverse, Bool :$writeback, Bool :$extend,
              :&writer? = -> $msg { self.command: $msg }
        )

        multi method urange(TrueOnly :$restore, :&writer? = -> $msg { self.command: $msg })

Set the parametric ranges used to compute x, y, and z values when in splot parametric mode.

=head3 vrange

Defined as:

        multi method vrange(
              :$min, :$max, Bool :$reverse, Bool :$writeback, Bool :$extend,
              :&writer? = -> $msg { self.command: $msg }
        )

        multi method vrange(TrueOnly :$restore, :&writer? = -> $msg { self.command: $msg })

Set the parametric ranges used to compute x, y, and z values when in splot parametric mode.

=head3 xtics

Defined as:

        method xtics(
               TrueOnly :$axis, TrueOnly :$border, Bool :$mirror,
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
               :$textcolor, :&writer? = -> $msg { self.command: $msg }
        )

Controls the major (labeled) tics on the x axis.

=head3 ytics

Defined as:

        method ytics(
               TrueOnly :$axis, TrueOnly :$border, Bool :$mirror,
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
               :$textcolor, :&writer? = -> $msg { self.command: $msg }
        )

Controls the major (labeled) tics on the y axis.

=head3 ztics

Defined as:

        method ztics(
               TrueOnly :$axis, TrueOnly :$border, Bool :$mirror,
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
               :$textcolor, :&writer? = -> $msg { self.command: $msg }
        )

Controls the major (labeled) tics on the z axis.

=head3 x2tics

Defined as:

        method x2tics(
               TrueOnly :$axis, TrueOnly :$border, Bool :$mirror,
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
               :$textcolor, :&writer? = -> $msg { self.command: $msg }
        )

Controls the major (labeled) tics on the x2 axis.

=head3 y2tics

Defined as:

        method y2tics(
               TrueOnly :$axis, TrueOnly :$border, Bool :$mirror,
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
               :$textcolor, :&writer? = -> $msg { self.command: $msg }
        )

Controls the major (labeled) tics on the y2 axis.

=head3 cbtics

Defined as:

        method cbtics(
               TrueOnly :$axis, TrueOnly :$border, Bool :$mirror,
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
               :$textcolor, :&writer? = -> $msg { self.command: $msg }
        )

Controls the major (labeled) tics on the color box axis.

=head3 legend

Defined as:

        method legend(
               TrueOnly :$on, TrueOnly :$off, TrueOnly :$default, TrueOnly :$inside, TrueOnly :$outside, TrueOnly :$lmargin, TrueOnly :$rmargin, TrueOnly :$tmargin, TrueOnly :$bmargin,
               :$at,
               TrueOnly :$left, TrueOnly :$right, TrueOnly :$center, TrueOnly :$top, TrueOnly :$bottom,
               TrueOnly :$vertical, TrueOnly :$horizontal, TrueOnly :$Left, TrueOnly :$Right,
               Bool :$opaque, Bool :$reverse, Bool :$invert,
               :$samplen, :$spacing, :$width, :$height,
               TrueOnly :$autotitle, TrueOnly :$columnheader, :$title, :$font-name, :$font-size, :$textcolor,
               Bool :$box, :$linestyle, :$linetype, :$linewidth,
               LegendMax :$maxcols, LegendMax :$maxrows, :&writer? = -> $msg { self.command: $msg }
        )

Enables a key (or legend) containing a title and a sample (line, point, box) for each plot in the graph.

=head3 border

Defined as:

        method border(
               :$integer, TrueOnly :$front, TrueOnly :$back, TrueOnly :$behind,
               :lw(:$linewidth), :ls(:$linestyle), :lt(:$linetype), :&writer? = -> $msg { self.command: $msg }
        )

Controls the display of the graph borders for the plot and splot commands.

=head3 grid

Defined as:

        method grid(
               Bool :$xtics, TrueOnly :$mxtics, Bool :$ytics, TrueOnly :$mytics, Bool :$ztics, TrueOnly :$mztics,
               Bool :$x2tics, TrueOnly :$mx2tics, Bool :$y2tics, TrueOnly :$my2tics, Bool :$cbtics, TrueOnly :$mcbtics,
               :$polar, TrueOnly :$layerdefault, TrueOnly :$front, TrueOnly :$back,
               :ls(:@linestyle), :lt(:@linetype), :lw(:@linewidth), :&writer? = -> $msg { self.command: $msg }
        )

Allows grid lines to be drawn on the plot.

=head3 timestamp

Defined as:

        method timestamp(
                Str :$format, TrueOnly :$top, TrueOnly :$bottom, Bool :$rotate,
                :$offset, :$font-name, :$font-size, :$textcolor, :&writer? = -> $msg { self.command: $msg }
        )

Places the time and date of the plot in the left margin.

=head3 rectangle

Defined as:

        multi method rectangle(
              :$index!, :$from, :$to,
              TrueOnly :$front, TrueOnly :$back, TrueOnly :$behind, Bool :$clip, :$fillcolor, :$fillstyle,
              TrueOnly :$default, :$linewidth, :$dashtype, :&writer? = -> $msg { self.command: $msg }
        )

        multi method rectangle(
              :$index, :$from, :$rto,
              TrueOnly :$front, TrueOnly :$back, TrueOnly :$behind, Bool :$clip, :$fillcolor, :$fillstyle,
              TrueOnly :$default, :$linewidth, :$dashtype, :&writer? = -> $msg { self.command: $msg }
        )

Defines a single rectangle which will appear in all subsequent 2D plot.
 
=head3 ellipse

Defined as:

        method ellipse(
               :$index, :center(:$at), :$w!, :$h!,
               TrueOnly :$front, TrueOnly :$back, TrueOnly :$behind, Bool :$clip, :$fillcolor, :$fillstyle,
               TrueOnly :$default, :$linewidth, :$dashtype, :&writer? = -> $msg { self.command: $msg }
        )

Defines a single ellipse which will appear in all subsequent 2D plot.

=head3 circle

Defined as:

        method circle(
               :$index, :center(:$at), :$radius!,
               TrueOnly :$front, TrueOnly :$back, TrueOnly :$behind, Bool :$clip, :$fillcolor, :$fillstyle,
               TrueOnly :$default, :$linewidth, :$dashtype, :&writer? = -> $msg { self.command: $msg }
        )

Defines a single circle which will appear in all subsequent 2D plot.

=head3 polygon

Defined as:

        method polygon(
               :$index, :$from, :@to,
               TrueOnly :$front, TrueOnly :$back, TrueOnly :$behind, Bool :$clip, :$fillcolor, :$fillstyle,
               TrueOnly :$default, :$linewidth, :$dashtype, :&writer? = -> $msg { self.command: $msg }
        )

Defines a single polygon which will appear in all subsequent 2D plot.

=head3 title

Defined as:

        method title(
               Str :$text, :$offset, :$font-name, :$font-size, :tc(:$textcolor), :$colorspec, Bool :$enhanced,
               :&writer? = -> $msg { self.command: $msg }
        )

Produces a plot title that is centered at the top of the plot.

=head3 arrow

Defined as:

        multi method arrow(
              :$tag, :$from, :$to, Bool :$head, TrueOnly :$backhead, TrueOnly :$heads,
              :$head-length, :$head-angle, :$back-angle,
              Bool :$filled, TrueOnly :$empty, TrueOnly :$border,
              TrueOnly :$front, TrueOnly :$back,
              :ls(:$linestyle), :lt(:$linetype), :lw(:$linewidth), :lc(:$linecolor), :dt(:$dashtype), :&writer? = -> $msg { self.command: $msg }
        )

Places an arrow on a plot.

=head3 multiplot

Defined as:

        multi method arrow(
              :$tag, :$from, :$rto, Bool :$head, TrueOnly :$backhead, TrueOnly :$heads,
              :$head-length, :$head-angle, :$back-angle,
              Bool :$filled, TrueOnly :$empty, TrueOnly :$border,
              TrueOnly :$front, TrueOnly :$back,
              :ls(:$linestyle), :lt(:$linetype), :lw(:$linewidth), :lc(:$linecolor), :dt(:$dashtype), :&writer? = -> $msg { self.command: $msg }
        )

Places gnuplot in the multiplot mode, in which several plots are placed next to each other on the same page or screen window.

=head3 command

Defined as:

        method command(Str $command)

Runs a given C<$command>. If there are no appropriate interfaces, this method will be a good alternative.

=head1 EXAMPLES

=head2 3D surface from a grid (matrix) of Z values

=head3 SOURCE

    use Chart::Gnuplot;

    my $gnu = Chart::Gnuplot.new(:terminal("png"), :filename("surface.dem.00.png"));
    $gnu.title(:text("3D surface from a grid (matrix) of Z values"));
    $gnu.xrange(:min(-0.5), :max(4.5));
    $gnu.yrange(:min(-0.5), :max(4.5));
    $gnu.grid;
    $gnu.command("set hidden3d");

    my @grid = (q:to/EOF/).split("\n", :skip-empty)>>.split(" ", :skip-empty);
    5 4 3 1 0
    2 2 0 0 1
    0 0 0 1 0
    0 0 0 2 3
    0 1 2 4 3
    EOF

    $gnu.splot(:vertices(@grid), :style("lines"), :title(False), :matrix);
    $gnu.dispose;

=head3 OUTPUT

=begin para

    <img src="surface.dem.00.png" alt="3D surface from a grid (matrix) of Z values">

=end para

=head2 sin(x)

=head3 SOURCE

    use Chart::Gnuplot;

    my $gnu = Chart::Gnuplot.new(:terminal("png"), :filename("sinx.png"));
    $gnu.title(:text("sin(x) curve"));
    $gnu.plot(:function('sin(x)'));
    $gnu.dispose;

=head3 OUTPUT

=begin para

    <img src="sinx.png" alt="sin(x)">

=end para

=head1 AUTHOR

titsuki <titsuki@cpan.org>

=head1 COPYRIGHT AND LICENSE

Copyright 2017 titsuki

This library is free software; you can redistribute it and/or modify it under the GNU General Public License version 3.0.

=end pod
