# The portions of the code are licensed under the Artistic License 2.0:
# zef ( https://github.com/ugexe/zef ) by ugexe

# Relicensed under the GPL:
# p6-ChartGnuplot by titsuki

use Zef;
use Zef::Fetch;
use Zef::Extract;
use Distribution::Builder::MakeFromJSON;

class Chart::Gnuplot::CustomBuilder:ver<0.0.22> is Distribution::Builder::MakeFromJSON {
    method build(IO() $work-dir = $*CWD) {
        my $workdir = ~$work-dir;
        if $*DISTRO.is-win {
            die "Sorry, this binding doesn't support windows";
        }
        if %*ENV<RAKU_CHART_GNUPLOT_NO_BUNDLE> {
            note "RAKU_CHART_GNUPLOT_NO_BUNDLE is set; skipping the bundled gnuplot build. Chart::Gnuplot will use the gnuplot found on PATH at runtime.";
            return True;
        }
        my $HOME = qq:x/echo \$HOME/.subst(/\s*/,"",:g);
        my $prefix = "$HOME/.p6chart-gnuplot";
        self!install-gnuplot($workdir, $prefix);
    }

    method !install-gnuplot($workdir, $prefix) {
        my $goback = $*CWD;
        chdir($workdir);

        my @fetch-backends = [
            { module => "Zef::Service::Shell::wget" },
            { module => "Zef::Service::Shell::curl" },
        ];
        my $fetcher      = Zef::Fetch.new(:backends(@fetch-backends));
        my $uri          = 'https://downloads.sourceforge.net/project/gnuplot/gnuplot/6.0.3/gnuplot-6.0.3.tar.gz';
        my $archive-file = "gnuplot-6.0.3.tar.gz".IO.e
        ?? "gnuplot-6.0.3.tar.gz"
        !! $fetcher.fetch(Candidate.new(:$uri), "gnuplot-6.0.3.tar.gz");

        my @extract-backends = [
            { module => "Zef::Service::Shell::tar" },
            { module => "Zef::Service::Shell::p5tar" },
        ];
        my $extractor = Zef::Extract.new(:backends(@extract-backends));
        my $extract-dir = $extractor.extract(Candidate.new(:uri($archive-file)), $*CWD);
        chdir("gnuplot-6.0.3");
        shell("./configure --prefix=$prefix --with-latex --with-texdir={$prefix}/share/texmf/tex/latex/gnuplot --without-qt --without-x");
        shell("make");
        shell("make install");
        chdir($goback);
    }
}
