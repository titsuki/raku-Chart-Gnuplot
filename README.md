[![Build Status](https://travis-ci.org/titsuki/p6-Chart-Gnuplot.svg?branch=master)](https://travis-ci.org/titsuki/p6-Chart-Gnuplot)

NAME
====

Chart::Gnuplot - blah blah blah

SYNOPSIS
========

    use Chart::Gnuplot;

    my $gnu = Chart::Gnuplot.new(:terminal("png"), :filename("synopsis.png"));
    $gnu.title(:text("Synopsis"));
    $gnu.plot(:function('sin(x)'));

DESCRIPTION
===========

Chart::Gnuplot is ...

EXAMPLES
========

surface
-------

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

html
====

<br>Figure 1.<IMG SRC="surface.dem.00.png.png"><br>

AUTHOR
======

titsuki <titsuki@cpan.org>

COPYRIGHT AND LICENSE
=====================

Copyright 2017 titsuki

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.
