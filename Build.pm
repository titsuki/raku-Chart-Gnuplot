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
        my $uri          = 'http://ftp.cstug.cz/pub/CTAN/graphics/gnuplot/5.0.5/gnuplot-5.0.5.tar.gz';
        my $archive-file = $uri.IO.basename.IO.e
        ?? $uri.IO.basename.IO
        !! $fetcher.fetch($uri, $uri.IO.basename);
        
        my @extract-backends = [
            { module => "Zef::Service::Shell::tar" },
            { module => "Zef::Service::Shell::p5tar" },
        ];
        my $extractor   = Zef::Extract.new(:backends(@extract-backends));
        my $extract-dir = $archive-file.IO.basename.subst(/\.tar\.gz/, '').IO.e
        ?? $archive-file.IO.basename.subst(/\.tar\.gz/, '').IO
        !! $extractor.extract($archive-file, $*CWD);
        
        shell("./configure --prefix=$prefix", :cwd($extract-dir.relative));
        shell("make", :cwd($extract-dir.relative));
        shell("make install", :cwd($extract-dir.relative));
    }
}
