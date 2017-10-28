use v6;
unit class Chart::Gnuplot::Output;

has Str $!filename;
has &!writer;

submethod BUILD(Str :$!filename, :&!writer) { }

method writer(&writer) {
    &!writer = &writer;
    self
}

method filename($filename) {
    $!filename = $filename;
    self
}

method set {
    &!writer(sprintf("set output \"%s\"", $!filename));
}
