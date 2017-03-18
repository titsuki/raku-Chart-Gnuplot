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

method plot(Str :$title, :@range, :@vertices,
            Str :$style, :$linestyle, :$linetype, :$linewidth, :$linecolor,
            :$pointtype, :$pointsize, :$fill, :$nohidden3d, :$nocontours, :$nosurface, :$palette) {
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
    @style-args.push("nohidden3d") if $nohidden3d.defined;
    @style-args.push("nocontours") if $nocontours.defined;
    @style-args.push("nosurface") if $nosurface.defined;
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

method label(:$tag, :$label-text, :@at, :$relative-position,
             :$norotate, :$rotate, :$font, :$noenhanced,
             :$layer, :$textcolor, :$point, :$nopoint, :$offset,
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
        @at-args.join(" ");
    } else {
        die "Error: Found invalid coordinate";
    }
    
    @args.push(sprintf("at %s",@at-args.join(","))) if @at-args.defined;
    @args.push($layer) if $layer.defined;
    @args.push("norotate") if $norotate.defined;

    my @rotate;
    if $rotate.defined {
        @rotate.push("rotate") ;
        if $rotate<degrees>:exists {
            @rotate.push(sprintf("by %d", $rotate<degrees>));
        }
    }
    @args.push(@rotate.join(" ")) if @rotate.elems > 0;

    my @font;
    if $font<name>:exists {
        @font.push($font<name>);
        if $font<size>:exists {
            @font.push($font<size>);
        }
        @args.push(sprintf("font \"%s\"", @font.join(",")));
    }

    @args.push("noenhanced") if $noenhanced.defined;
    @args.push($layer) if $layer.defined;
    @args.push("textcolor " ~ $textcolor) if $textcolor.defined;
    @args.push("point " ~ $point) if $point.defined;
    @args.push("offset " ~ $offset) if $offset.defined;
    @args.push("boxed") if $boxed.defined;
    @args.push("hypertext") if $hypertext.defined;

    $!gnuplot.in.say: sprintf("set label %s", @args.join(" "));
}

multi method rectangle(:$index, :@from, :@to,
                       :$layer, :$clip, :$noclip, :$fillcolor, :$fillstyle,
                       :$default, :$linewidth, :$dashtype) {
    my @args;
    
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

    @args.push($layer) if $layer.defined;
    @args.push("clip") if $clip.defined;
    @args.push("noclip") if $noclip.defined;
    @args.push("fillcolor " ~ $fillcolor) if $fillcolor.defined;
    @args.push("fillstyle " ~ $fillstyle) if $fillstyle.defined;
    @args.push("default") if $default.defined;
    @args.push("linewidth " ~ $linewidth) if $linewidth.defined;
    @args.push("dashtype " ~ $dashtype) if $dashtype.defined;

    $!gnuplot.in.say: sprintf("set object %d rectangle from %s to %s %s", $index, @from-args.join(","), @to-args.join(","), @args.join(" "));
}

multi method rectangle(:$index, :@from, :@rto,
                       :$layer, :$clip, :$noclip, :$fillcolor, :$fillstyle,
                       :$default, :$linewidth, :$dashtype) {
    my @args;

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

    @args.push($layer) if $layer.defined;
    @args.push("clip") if $clip.defined;
    @args.push("noclip") if $noclip.defined;
    @args.push("fillcolor " ~ $fillcolor) if $fillcolor.defined;
    @args.push("fillstyle " ~ $fillstyle) if $fillstyle.defined;
    @args.push("default") if $default.defined;
    @args.push("linewidth " ~ $linewidth) if $linewidth.defined;
    @args.push("dashtype " ~ $dashtype) if $dashtype.defined;

    $!gnuplot.in.say: sprintf("set object %d rectangle from %s to %s %s", $index, @from-args.join(","), @rto-args.join(","), @args.join(" "));
}

method ellipse(:$index, :center(:@at), :$w, :$h,
               :$layer, :$clip, :$noclip, :$fillcolor, :$fillstyle,
               :$default, :$linewidth, :$dashtype) {
    my @args;

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

    @args.push($layer) if $layer.defined;
    @args.push("clip") if $clip.defined;
    @args.push("noclip") if $noclip.defined;
    @args.push("fillcolor " ~ $fillcolor) if $fillcolor.defined;
    @args.push("fillstyle " ~ $fillstyle) if $fillstyle.defined;
    @args.push("default") if $default.defined;
    @args.push("linewidth " ~ $linewidth) if $linewidth.defined;
    @args.push("dashtype " ~ $dashtype) if $dashtype.defined;

     $!gnuplot.in.say: sprintf("set object %d ellipse at %s size %d,%d %s", $index, @at-args.join(","), $w, $h, @args.join(" "));
}

method circle(:$index, :center(:@at), :$radius,
              :$layer, :$clip, :$noclip, :$fillcolor, :$fillstyle,
              :$default, :$linewidth, :$dashtype) {
    my @args;

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

    @args.push($layer) if $layer.defined;
    @args.push("clip") if $clip.defined;
    @args.push("noclip") if $noclip.defined;
    @args.push("fillcolor " ~ $fillcolor) if $fillcolor.defined;
    @args.push("fillstyle " ~ $fillstyle) if $fillstyle.defined;
    @args.push("default") if $default.defined;
    @args.push("linewidth " ~ $linewidth) if $linewidth.defined;
    @args.push("dashtype " ~ $dashtype) if $dashtype.defined;

    $!gnuplot.in.say: sprintf("set object %d circle at %s size %d %s", $index, @at-args.join(","), $radius, @args.join(" "));
}

method polygon(:$index, :@from, :@to,
              :$layer, :$clip, :$noclip, :$fillcolor, :$fillstyle,
              :$default, :$linewidth, :$dashtype) {
    my @args;
    @args.push($layer) if $layer.defined;
    @args.push("clip") if $clip.defined;
    @args.push("noclip") if $noclip.defined;
    @args.push("fillcolor " ~ $fillcolor) if $fillcolor.defined;
    @args.push("fillstyle " ~ $fillstyle) if $fillstyle.defined;
    @args.push("default") if $default.defined;
    @args.push("linewidth " ~ $linewidth) if $linewidth.defined;
    @args.push("dashtype " ~ $dashtype) if $dashtype.defined;

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

    $!gnuplot.in.say: sprintf("set object %d polygon from %s %s %s", $index, @from-args.join(","), @to.map({ "to " ~ myproc($_).join(",") }).join(" "), @args.join(" "));
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
