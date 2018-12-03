# The portions of the code are licensed under the Artistic License 2.0:
# zef ( https://github.com/ugexe/zef ) by ugexe

# Relicensed under the GPL:
# p6-ChartGnuplot by titsuki

use Zef;
use Zef::Fetch;
use Zef::Extract;

class Build {
    method build($workdir) {
        if $*DISTRO.is-win {
            die "Sorry, this binding doesn't support windows";
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
        my $uri          = 'http://ftp.cstug.cz/pub/CTAN/graphics/gnuplot/5.2.5/gnuplot-5.2.5.tar.gz';
        my $archive-file = "gnuplot-5.2.5.tar.gz".IO.e
        ?? "gnuplot-5.2.5.tar.gz"
        !! $fetcher.fetch($uri, "gnuplot-5.2.5.tar.gz");

        my @extract-backends = [
            { module => "Zef::Service::Shell::tar" },
            { module => "Zef::Service::Shell::p5tar" },
        ];
        my $extractor = Zef::Extract.new(:backends(@extract-backends));
        my $extract-dir = $extractor.extract($archive-file, $*CWD);
        chdir("gnuplot-5.2.5");
        shell("./configure --prefix=$prefix");
        shell("make");
        shell("make install");
        chdir($goback);
    }
}
