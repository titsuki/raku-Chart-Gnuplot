use v6;
unit module Chart::Gnuplot::Subset:ver<0.0.11>;

subset FalseOnly of Bool is export where { $_ ~~ Bool:U or $_ === False };
subset TrueOnly of Bool is export where { $_ ~~ Bool:U or $_ === True};
subset LabelRotate of Cool is export where { $_ ~~ Cool:U or $_ ~~ Real or $_ === False };
subset AnyLabelRotate of Cool is export where { $_ ~~ Cool:U or $_ eq "parallel" or $_ ~~ Real or $_ === False };
subset LegendMax of Cool is export where { $_ ~~ Cool:U or $_ eq "auto" or $_ ~~ Real };
subset AnyTicsRotate of Cool is export where { $_ ~~ Cool:U or $_ ~~ Real or $_ === False };
subset AnyTicsOffset of Mu is export where { $_ ~~ Mu:U or $_ ~~ FalseOnly or ($_ ~~ List and $_.all ~~ Pair|Real) };
subset AnyTicsTic of Mu is export where { $_ ~~ Mu:U or $_ ~~ Hash and .<label>:exists and .<pos>:exists and .keys.grep(* eq "label"|"pos"|"level").elems == .keys.elems };
