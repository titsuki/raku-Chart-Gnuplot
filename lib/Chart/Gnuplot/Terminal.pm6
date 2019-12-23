use v6;
unit class Chart::Gnuplot::Terminal:ver<0.0.16>;

has Str $!type;
has &!writer;

submethod BUILD(Str:D :$!type, :&!writer) { }

method writer(&writer) {
    &!writer = &writer;
    self
}

method type($type) {
    $!type = $type;
    self
}

method set {
    &!writer(sprintf("set terminal %s", $!type));
}

