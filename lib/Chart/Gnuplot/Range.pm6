use v6;
unit class Chart::Gnuplot::Range;

has &!writer;

submethod BUILD(:&!writer) { }

method !anyrange(:$min, :$max, Bool :$reverse, Bool :$writeback, Bool :$extend) {
    my @args;
    @args.push(sprintf("[%s:%s]", $min, $max));
    @args.push($reverse ?? "reverse" !! "noreverse") if $reverse.defined;
    @args.push($writeback ?? "writeback" !! "nowriteback") if $writeback.defined;
    @args.push($extend ?? "extend" !! "noextend") if $extend.defined;
    @args.grep(* ne "").join(" ");
}

multi method xrange(:$min, :$max, Bool :$reverse, Bool :$writeback, Bool :$extend, :&writer? = &!writer) {
   &writer(sprintf("set xrange %s", self!anyrange(:$min, :$max, :$reverse, :$writeback, :$extend)));
}

multi method xrange(:$restore, :&writer? = &!writer) {
    &writer("set xrange restore");
}

multi method yrange(:$min, :$max, Bool :$reverse, Bool :$writeback, Bool :$extend, :&writer? = &!writer) {
   &writer(sprintf("set yrange %s", self!anyrange(:$min, :$max, :$reverse, :$writeback, :$extend)));
}

multi method yrange(:$restore, :&writer? = &!writer) {
    &writer("set yrange restore");
}

multi method zrange(:$min, :$max, Bool :$reverse, Bool :$writeback, Bool :$extend, :&writer? = &!writer) {
   &writer(sprintf("set zrange %s", self!anyrange(:$min, :$max, :$reverse, :$writeback, :$extend)));
}

multi method zrange(:$restore, :&writer? = &!writer) {
    &writer("set zrange restore");
}

multi method x2range(:$min, :$max, Bool :$reverse, Bool :$writeback, Bool :$extend, :&writer? = &!writer) {
   &writer(sprintf("set x2range %s", self!anyrange(:$min, :$max, :$reverse, :$writeback, :$extend)));
}

multi method x2range(:$restore, :&writer? = &!writer) {
    &writer("set x2range restore");
}

multi method y2range(:$min, :$max, Bool :$reverse, Bool :$writeback, Bool :$extend, :&writer? = &!writer) {
   &writer(sprintf("set y2range %s", self!anyrange(:$min, :$max, :$reverse, :$writeback, :$extend)));
}

multi method y2range(:$restore, :&writer? = &!writer) {
    &writer("set y2range restore");
}

multi method cbrange(:$min, :$max, Bool :$reverse, Bool :$writeback, Bool :$extend, :&writer? = &!writer) {
    &writer(sprintf("set cbrange %s", self!anyrange(:$min, :$max, :$reverse, :$writeback, :$extend)));
}

multi method cbrange(:$restore, :&writer? = &!writer) {
    &writer("set cbrange restore");
}

multi method rrange(:$min, :$max, Bool :$reverse, Bool :$writeback, Bool :$extend, :&writer? = &!writer) {
    &writer(sprintf("set rrange %s", self!anyrange(:$min, :$max, :$reverse, :$writeback, :$extend)));
}

multi method rrange(:$restore, :&writer? = &!writer) {
    &writer("set rrange restore");
}

multi method trange(:$min, :$max, Bool :$reverse, Bool :$writeback, Bool :$extend, :&writer? = &!writer) {
    &writer(sprintf("set trange %s", self!anyrange(:$min, :$max, :$reverse, :$writeback,  :$extend)));
}

multi method trange(:$restore, :&writer? = &!writer) {
    &writer("set trange restore");
}

multi method urange(:$min, :$max, Bool :$reverse, Bool :$writeback, Bool :$extend, :&writer? = &!writer) {
    &writer(sprintf("set urange %s", self!anyrange(:$min, :$max, :$reverse, :$writeback, :$extend)));
}

multi method urange(:$restore, :&writer? = &!writer) {
    &writer("set urange restore");
}

multi method vrange(:$min, :$max, Bool :$reverse, Bool :$writeback, Bool :$extend, :&writer? = &!writer) {
    &writer(sprintf("set vrange %s", self!anyrange(:$min, :$max, :$reverse, :$writeback, :$extend)));
}

multi method vrange(:$restore, :&writer? = &!writer) {
    &writer("set vrange restore");
}

