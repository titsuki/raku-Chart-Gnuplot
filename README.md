[![Build Status](https://travis-ci.org/titsuki/p6-Chart-Gnuplot.svg?branch=master)](https://travis-ci.org/titsuki/p6-Chart-Gnuplot)

NAME
====

Chart::Gnuplot - A Perl 6 bindings for gnuplot

SYNOPSIS
========

### SOURCE

    use Chart::Gnuplot;

    my $gnu = Chart::Gnuplot.new(:terminal("png"), :filename("synopsis.png"));
    $gnu.title(:text("sin(x) curve"));
    $gnu.plot(:function('sin(x)'));

### OUTPUT

<img src="synopsis.png" alt="sin(x)">

DESCRIPTION
===========

Chart::Gnuplot is a Perl 6 naive bindings for gnuplot. Chart::Gnuplot runs `gnuplot` using `Proc::Async` and enables you to plot chart or graph with Perl6ish interface.

METHODS
-------

### terminal

Defined as:

    method terminal($terminal)

Tells gnuplot what kind of output to generate.

### plot

Defined as:

    multi method plot(
            :$title, :$ignore, :@range, :@vertices!,
            :@using,
            Str :$style, :ls(:$linestyle), :lt(:$linetype), :lw(:$linewidth), :lc(:$linecolor),
            :$pointtype, :$pointsize, :$fill, FalseOnly :$hidden3d, FalseOnly :$contours,
            FalseOnly :$surface, :$palette,
            :&writer? = -> $msg { self.command: $msg }
    )

    multi method plot(
          :$title, :$ignore, :@range, :$function!,
          Str :$style, :ls(:$linestyle), :lt(:$linetype), :lw(:$linewidth), :lc(:$linecolor),
          :$pointtype, :$pointsize, :$fill, FalseOnly :$hidden3d, FalseOnly :$contours,
          FalseOnly :$surface, :$palette,
          :&writer? = -> $msg { self.command: $msg }
    )

Draws a 2-dimensional plot.

### splot

Defined as:

    multi method splot(
          :@range,
          :@vertices!,
          :$binary, :$matrix, :$index, :$every,
          :$title, :$style, :ls(:$linestyle), :lt(:$linetype), :lw(:$linewidth), :lc(:$linecolor),
          :$pointtype, :$pointsize, :$fill, FalseOnly :$hidden3d, FalseOnly :$contours,
          FalseOnly :$surface, :$palette, :&writer? = -> $msg { self.command: $msg }
    )

    multi method splot(
          :@range,
          :$function!,
          :$title, :$style, :ls(:$linestyle), :lt(:$linetype), :lw(:$linewidth), :lc(:$linecolor),
          :$pointtype, :$pointsize, :$fill, FalseOnly :$hidden3d, FalseOnly :$contours,
          FalseOnly :$surface, :$palette, :&writer? = -> $msg { self.command: $msg }
    )

Draws a 3-dimensional plot.

### label

Defined as:

    method label(
           :$tag, :$label-text, :$at, :$left, :$center, :$right,
           LabelRotate :$rotate, :$font-name, :$font-size, FalseOnly :$enhanced,
           :$front, :$back, :$textcolor, FalseOnly :$point, :$line-type, :$point-type, :$point-size, :$offset,
           :$boxed, :$hypertext, :&writer? = -> $msg { self.command: $msg }
    )

Places the text string at the corresponding 2D or 3D position.

### xlabel

Defined as:

    method xlabel(
           Str :$label, :$offset, :$font-name, :$font-size, :$textcolor,
           Bool :$enhanced, AnyLabelRotate :$rotate, :&writer? = -> $msg { self.command: $msg }
    )

Sets the x-axis label.

### ylabel

Defined as:

    method ylabel(
           Str :$label, :$offset, :$font-name, :$font-size, :$textcolor,
           Bool :$enhanced, AnyLabelRotate :$rotate, :&writer? = -> $msg { self.command: $msg }
    )

Sets the y-axis label.

### zlabel

Defined as:

    method zlabel(
           Str :$label, :$offset, :$font-name, :$font-size, :$textcolor,
           Bool :$enhanced, AnyLabelRotate :$rotate, :&writer? = -> $msg { self.command: $msg }
    )

Sets the z-axis label.

### x2label

Defined as:

    method x2label(
           Str :$label, :$offset, :$font-name, :$font-size, :$textcolor,
           Bool :$enhanced, AnyLabelRotate :$rotate, :&writer? = -> $msg { self.command: $msg }
    )

Sets the x2-axis label.

### y2label

Defined as:

    method y2label(
           Str :$label, :$offset, :$font-name, :$font-size, :$textcolor,
           Bool :$enhanced, AnyLabelRotate :$rotate, :&writer? = -> $msg { self.command: $msg }
    )

Sets the y2-axis label.

### cblabel

Defined as:

    method cblabel(
           Str :$label, :$offset, :$font-name, :$font-size, :$textcolor,
           Bool :$enhanced, AnyLabelRotate :$rotate, :&writer? = -> $msg { self.command: $msg }
    )

Sets the cb-axis label.

### xrange

Defined as:

    multi method xrange(
          :$min, :$max, Bool :$reverse, Bool :$writeback, Bool :$extend,
          :&writer? = -> $msg { self.command: $msg }
    )

    multi method xrange(:$restore, :&writer? = -> $msg { self.command: $msg })

Sets the horizontal range that will be displayed.

### yrange

Defined as:

    multi method yrange(
          :$min, :$max, Bool :$reverse, Bool :$writeback, Bool :$extend,
          :&writer? = -> $msg { self.command: $msg }
    )

    multi method yrange(:$restore, :&writer? = -> $msg { self.command: $msg })

Sets the vertical range that will be displayed.

### zrange

Defined as:

    multi method zrange(
          :$min, :$max, Bool :$reverse, Bool :$writeback, Bool :$extend,
          :&writer? = -> $msg { self.command: $msg }
    )

    multi method zrange(:$restore, :&writer? = -> $msg { self.command: $msg })

Sets the range that will be displayed on the z axis.

### x2range

Defined as:

    multi method x2range(
          :$min, :$max, Bool :$reverse, Bool :$writeback, Bool :$extend,
          :&writer? = -> $msg { self.command: $msg }
    )

    multi method x2range(:$restore, :&writer? = -> $msg { self.command: $msg })

Sets the range that will be displayed on the x2 axis.

### y2range

Defined as:

    multi method y2range(
          :$min, :$max, Bool :$reverse, Bool :$writeback, Bool :$extend,
          :&writer? = -> $msg { self.command: $msg }
    )

    multi method y2range(:$restore, :&writer? = -> $msg { self.command: $msg })

Sets the range that will be displayed on the y2 axis.

### cbrange

Defined as:

    multi method cbrange(
          :$min, :$max, Bool :$reverse, Bool :$writeback, Bool :$extend,
          :&writer? = -> $msg { self.command: $msg }
    )

    multi method cbrange(:$restore, :&writer? = -> $msg { self.command: $msg })

Sets the range of values which are colored.

### rrange

Defined as:

    multi method rrange(
          :$min, :$max, Bool :$reverse, Bool :$writeback, Bool :$extend,
          :&writer? = -> $msg { self.command: $msg }
    )

    multi method rrange(:$restore, :&writer? = -> $msg { self.command: $msg })

Sets the range that will be displayed on the r axis.

### trange

Defined as:

    multi method trange(
          :$min, :$max, Bool :$reverse, Bool :$writeback, Bool :$extend,
          :&writer? = -> $msg { self.command: $msg }
    )

    multi method trange(:$restore, :&writer? = -> $msg { self.command: $msg })

Sets the parametric range used to compute x and y values when in parametric or polar modes.

### urange

Defined as:

    multi method urange(
          :$min, :$max, Bool :$reverse, Bool :$writeback, Bool :$extend,
          :&writer? = -> $msg { self.command: $msg }
    )

    multi method urange(:$restore, :&writer? = -> $msg { self.command: $msg })

Set the parametric ranges used to compute x, y, and z values when in splot parametric mode.

### vrange

Defined as:

    multi method vrange(
          :$min, :$max, Bool :$reverse, Bool :$writeback, Bool :$extend,
          :&writer? = -> $msg { self.command: $msg }
    )

    multi method vrange(:$restore, :&writer? = -> $msg { self.command: $msg })

Set the parametric ranges used to compute x, y, and z values when in splot parametric mode.

### xtics

Defined as:

    method xtics(
           :$axis, :$border, Bool :$mirror,
           :$in, :$out, :$scale-default, :$scale-major, :$scale-minor, AnyTicsRotate :$rotate, AnyTicsOffset :$offset,
           :$left, :$right, :$center, :$autojustify,
           :$add,
           :$autofreq,
           :$incr,
           :$start, :$end,
           :@tics,
           :$format, :$font-name, :$font-size, Bool :$enhanced,
           :$numeric, :$timedate, :$geographic,
           :$rangelimited,
           :$textcolor, :&writer? = -> $msg { self.command: $msg }
    )

Controls the major (labeled) tics on the x axis.

### ytics

Defined as:

    method ytics(
           :$axis, :$border, Bool :$mirror,
           :$in, :$out, :$scale-default, :$scale-major, :$scale-minor, AnyTicsRotate :$rotate, AnyTicsOffset :$offset,
           :$left, :$right, :$center, :$autojustify,
           :$add,
           :$autofreq,
           :$incr,
           :$start, :$end,
           :@tics,
           :$format, :$font-name, :$font-size, Bool :$enhanced,
           :$numeric, :$timedate, :$geographic,
           :$rangelimited,
           :$textcolor, :&writer? = -> $msg { self.command: $msg }
    )

Controls the major (labeled) tics on the y axis.

### ztics

Defined as:

    method ztics(
           :$axis, :$border, Bool :$mirror,
           :$in, :$out, :$scale-default, :$scale-major, :$scale-minor, AnyTicsRotate :$rotate, AnyTicsOffset :$offset,
           :$left, :$right, :$center, :$autojustify,
           :$add,
           :$autofreq,
           :$incr,
           :$start, :$end,
           :@tics,
           :$format, :$font-name, :$font-size, Bool :$enhanced,
           :$numeric, :$timedate, :$geographic,
           :$rangelimited,
           :$textcolor, :&writer? = -> $msg { self.command: $msg }
    )

Controls the major (labeled) tics on the z axis.

### x2tics

Defined as:

    method x2tics(
           :$axis, :$border, Bool :$mirror,
           :$in, :$out, :$scale-default, :$scale-major, :$scale-minor, AnyTicsRotate :$rotate, AnyTicsOffset :$offset,
           :$left, :$right, :$center, :$autojustify,
           :$add,
           :$autofreq,
           :$incr,
           :$start, :$end,
           :@tics,
           :$format, :$font-name, :$font-size, Bool :$enhanced,
           :$numeric, :$timedate, :$geographic,
           :$rangelimited,
           :$textcolor, :&writer? = -> $msg { self.command: $msg }
    )

Controls the major (labeled) tics on the x2 axis.

### y2tics

Defined as:

    method y2tics(
           :$axis, :$border, Bool :$mirror,
           :$in, :$out, :$scale-default, :$scale-major, :$scale-minor, AnyTicsRotate :$rotate, AnyTicsOffset :$offset,
           :$left, :$right, :$center, :$autojustify,
           :$add,
           :$autofreq,
           :$incr,
           :$start, :$end,
           :@tics,
           :$format, :$font-name, :$font-size, Bool :$enhanced,
           :$numeric, :$timedate, :$geographic,
           :$rangelimited,
           :$textcolor, :&writer? = -> $msg { self.command: $msg }
    )

Controls the major (labeled) tics on the y2 axis.

### cbtics

Defined as:

    method cbtics(
           :$axis, :$border, Bool :$mirror,
           :$in, :$out, :$scale-default, :$scale-major, :$scale-minor, AnyTicsRotate :$rotate, AnyTicsOffset :$offset,
           :$left, :$right, :$center, :$autojustify,
           :$add,
           :$autofreq,
           :$incr,
           :$start, :$end,
           :@tics,
           :$format, :$font-name, :$font-size, Bool :$enhanced,
           :$numeric, :$timedate, :$geographic,
           :$rangelimited,
           :$textcolor, :&writer? = -> $msg { self.command: $msg }
    )

Controls the major (labeled) tics on the color box axis.

### legend

Defined as:

    method legend(
           :$on, :$off, :$default, :$inside, :$outside, :$lmargin, :$rmargin, :$tmargin, :$bmargin,
           :$at,
           :$left, :$right, :$center, :$top, :$bottom,
           :$vertical, :$horizontal, :$Left, :$Right,
           Bool :$opaque, Bool :$reverse, Bool :$invert,
           :$samplen, :$spacing, :$width, :$height,
           :$autotitle, :$columnheader, :$title, :$font-name, :$font-size, :$textcolor,
           Bool :$box, :$linestyle, :$linetype, :$linewidth,
           LegendMax :$maxcols, LegendMax :$maxrows, :&writer? = -> $msg { self.command: $msg }
    )

Enables a key (or legend) containing a title and a sample (line, point, box) for each plot in the graph.

### border

Defined as:

    method border(
           :$integer, :$front, :$back, :$behind,
           :lw(:$linewidth), :ls(:$linestyle), :lt(:$linetype), :&writer? = -> $msg { self.command: $msg }
    )

Controls the display of the graph borders for the plot and splot commands.

### grid

Defined as:

    method grid(
           Bool :$xtics, TrueOnly :$mxtics, Bool :$ytics, TrueOnly :$mytics, Bool :$ztics, TrueOnly :$mztics,
           Bool :$x2tics, TrueOnly :$mx2tics, Bool :$y2tics, TrueOnly :$my2tics, Bool :$cbtics, TrueOnly :$mcbtics,
           :$polar, :$layerdefault, :$front, :$back,
           :ls(:@linestyle), :lt(:@linetype), :lw(:@linewidth), :&writer? = -> $msg { self.command: $msg }
    )

Allows grid lines to be drawn on the plot.

### timestamp

Defined as:

    method timestamp(
            :$format, :$top, :$bottom, Bool :$rotate,
            :$offset, :$font-name, :$font-size, :$textcolor, :&writer? = -> $msg { self.command: $msg }
    )

Places the time and date of the plot in the left margin.

### rectangle

Defined as:

    multi method rectangle(
          :$index!, :$from, :$to,
          :$front, :$back, :$behind, Bool :$clip, :$fillcolor, :$fillstyle,
          :$default, :$linewidth, :$dashtype, :&writer? = -> $msg { self.command: $msg }
    )

    multi method rectangle(
          :$index, :$from, :$rto,
          :$front, :$back, :$behind, Bool :$clip, :$fillcolor, :$fillstyle,
          :$default, :$linewidth, :$dashtype, :&writer? = -> $msg { self.command: $msg }
    )

Defines a single rectangle which will appear in all subsequent 2D plot.

### ellipse

Defined as:

    method ellipse(
           :$index, :center(:$at), :$w!, :$h!,
           :$front, :$back, :$behind, Bool :$clip, :$fillcolor, :$fillstyle,
           :$default, :$linewidth, :$dashtype, :&writer? = -> $msg { self.command: $msg }
    )

Defines a single ellipse which will appear in all subsequent 2D plot.

### circle

Defined as:

    method circle(
           :$index, :center(:$at), :$radius!,
           :$front, :$back, :$behind, Bool :$clip, :$fillcolor, :$fillstyle,
           :$default, :$linewidth, :$dashtype, :&writer? = -> $msg { self.command: $msg }
    )

Defines a single circle which will appear in all subsequent 2D plot.

### polygon

Defined as:

    method polygon(
           :$index, :$from, :@to,
           :$front, :$back, :$behind, Bool :$clip, :$fillcolor, :$fillstyle,
           :$default, :$linewidth, :$dashtype, :&writer? = -> $msg { self.command: $msg }
    )

Defines a single polygon which will appear in all subsequent 2D plot.

### title

Defined as:

    method title(
           :$text, :$offset, :$font-name, :$font-size, :tc(:$textcolor), :$colorspec, Bool :$enhanced,
           :&writer? = -> $msg { self.command: $msg }
    )

Produces a plot title that is centered at the top of the plot.

### arrow

Defined as:

    multi method arrow(
          :$tag, :$from, :$to, Bool :$head, :$backhead, :$heads,
          :$head-length, :$head-angle, :$back-angle,
          :$filled, :$empty, :$border,
          :$front, :$back,
          :ls(:$linestyle), :lt(:$linetype), :lw(:$linewidth), :lc(:$linecolor), :dt(:$dashtype), :&writer? = -> $msg { self.command: $msg }
    )

Places an arrow on a plot.

### multiplot

Defined as:

    multi method arrow(
          :$tag, :$from, :$rto, Bool :$head, :$backhead, :$heads,
          :$head-length, :$head-angle, :$back-angle,
          :$filled, :$empty, :$border,
          :$front, :$back,
          :ls(:$linestyle), :lt(:$linetype), :lw(:$linewidth), :lc(:$linecolor), :dt(:$dashtype), :&writer? = -> $msg { self.command: $msg }
    )

Places gnuplot in the multiplot mode, in which several plots are placed next to each other on the same page or screen window.

### command

Defined as:

    method command(Str $command)

Runs a given `$command`. If there are no appropriate interfaces, this method will be a good alternative.

EXAMPLES
========

3D surface from a grid (matrix) of Z values
-------------------------------------------

### SOURCE

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

### OUTPUT

<img src="surface.dem.00.png" alt="3D surface from a grid (matrix) of Z values">

AUTHOR
======

titsuki <titsuki@cpan.org>

COPYRIGHT AND LICENSE
=====================

Copyright 2017 titsuki

This library is free software; you can redistribute it and/or modify it under the GNU General Public License version 3.0.
