use v6;
use Test;
use Chart::Gnuplot::CustomBuilder;

# When RAKU_CHART_GNUPLOT_NO_BUNDLE is set, the builder must skip the (heavy)
# source build of the bundled gnuplot entirely and return successfully,
# leaving Chart::Gnuplot to use the gnuplot found on PATH at runtime.

if $*DISTRO.is-win {
    plan 1;
    skip "Builder does not support Windows";
    done-testing;
    exit;
}

{
    my $builder = Chart::Gnuplot::CustomBuilder.new;
    my $result;
    lives-ok {
        $result = %*ENV<RAKU_CHART_GNUPLOT_NO_BUNDLE> := "1" andthen $builder.build($*CWD);
    }, "build() should not die when RAKU_CHART_GNUPLOT_NO_BUNDLE is set.";
    ok $result, "build() should return a true value when bundling is skipped.";
    nok "$*HOME/.p6chart-gnuplot/bin/gnuplot.no-bundle-marker".IO.e,
        "build() should not produce a bundled gnuplot when skipping.";
}

done-testing;
