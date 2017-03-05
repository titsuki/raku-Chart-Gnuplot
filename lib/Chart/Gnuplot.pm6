use v6;
unit class Chart::Gnuplot;

has $!gnuplot;
has $!style;
has Bool $.persist;
has $.debug;
has $.terminal;
has %.options;
has Str @!plots;
has Str @!objects;
has Str @!pre-commands;
has Str @!post-commands;

submethod BUILD(:$!terminal!, Str :$filename, :$!persist = True, :$!debug = False) {
    my @opts;
    @opts.push('-persist') if $!persist;
    $!gnuplot = run("gnuplot", @opts.join(" "), :in, :out, :err);
    $!gnuplot.in.say: sprintf("set terminal %s", $!terminal);
    $!gnuplot.in.say: sprintf("set output \"%s\"", $filename);
}

submethod DESTROY {
    $!gnuplot.in.say: "exit";
}

method terminal($terminal) {
    $!terminal = $terminal;
    $!gnuplot.in.say: sprintf("set terminal \"%s\"", $!terminal);
}

method draw {
    $!gnuplot.in.say: $_ for @!pre-commands;
    $!gnuplot.in.say: $_ for @!objects;
    $!gnuplot.in.say: sprintf("%s %s", "plot", @!plots.join(","));
    $!gnuplot.in.say: $_ for @!post-commands;
}

method plot(Str :$title, Str :$style, :@vertices) {
    my $tmpfile = ("$*TMPDIR", "/p6gnuplot-", "$*PID", "-", time, "-", @vertices.WHERE).join;
    my $fh = open $tmpfile, :w;
    for ^@vertices.elems -> $r {
        $fh.say(@vertices[$r;*].join(" "));
    }
    $fh.close;

    my $plot = sprintf("\'%s\' with %s title \"%s\"", $tmpfile, $style, $title);
    @!plots.push($plot);
}

multi method rectangle(:$index, :@from where *.elems == 2, :@to where *.elems == 2,
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

    my $object = sprintf("set object %d rectangle from %s to %s %s", $index, @from.join(","), @to.join(","), @args.join(" "));
    @!objects.push($object);
}

multi method rectangle(:$index, :@from where *.elems == 2, :@rto where *.elems == 2,
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

    my $object = sprintf("set object %d rectangle from %s to %s %s", $index, @from.join(","), @rto.join(","), @args.join(" "));
    @!objects.push($object);
}

multi method ellipse(:$index, :@at where *.elems == 2, :$w, :$h,
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

    my $object = sprintf("set object %d ellipse at %s size %d,%d %s", $index, @at.join(","), $w, $h, @args.join(" "));
    @!objects.push($object);
}

multi method ellipse(:$index, :@center where *.elems == 2, :$w, :$h,
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

    my $object = sprintf("set object %d ellipse center %s size %d,%d %s", $index, @center.join(","), $w, $h, @args.join(" "));
    @!objects.push($object);
}

multi method circle(:$index, :@at where *.elems == 2, :$radius,
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

    my $object = sprintf("set object %d circle at %s size %d %s", $index, @at.join(","), $radius, @args.join(" "));
    @!objects.push($object);
}

multi method circle(:$index, :@center where *.elems == 2, :$radius,
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
    
    my $object = sprintf("set object %d circle center %s size %d %s", $index, @center.join(","), $radius, @args.join(" "));
    @!objects.push($object);
}

method polygon(:$index, :@from where *.elems == 2, :@to,
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

    my $object = sprintf("set object %d polygon from %s %s %s", $index, @from.join(","), @to.map({ "to " ~ $_.join(",") }).join(" "), @args.join(" "));
    @!objects.push($object);
}

method pre-process-command(Str $command) {
    @!pre-commands.push($command);
}

method post-process-command(Str $command) {
    @!post-commands.push($command);
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
