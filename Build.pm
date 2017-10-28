# The portions of the code are licensed under the Artistic License 2.0:
# zef ( https://github.com/ugexe/zef ) by ugexe

# Relicensed under the GPL:
# p6-ChartGnuplot by titsuki

use Zef;
use Zef::Fetch;

class Build {

    method extract(IO() $archive-file, IO() $extract-to) {
        die "archive file does not exist: {$archive-file.absolute}"
        unless $archive-file.e && $archive-file.f;
        die "target extraction directory {$extract-to.absolute} does not exist and could not be created"
        unless ($extract-to.e && $extract-to.d) || mkdir($extract-to);

        my $passed;
        react {
            my $cwd := $archive-file.parent;
            my $ENV := %*ENV;
            my $proc = zrun-async('tar', '-zxvf', $archive-file.basename, '-C', $extract-to.relative($cwd));
            whenever $proc.stdout(:bin) { }
            whenever $proc.stderr(:bin) { }
            whenever $proc.start(:$ENV, :$cwd) { $passed = $_.so }
        }

        my $meta6-prefix = self.list($archive-file).sort.first({ .IO.basename eq 'VERSION' });
        my $extracted-to = $extract-to.child($meta6-prefix);
        ($passed && $extracted-to.e) ?? $extracted-to.parent !! False;
    }

    method list(IO() $archive-file) {
        die "archive file does not exist: {$archive-file.absolute}"
        unless $archive-file.e && $archive-file.f;

        my $passed;
        my $output = Buf.new;
        react {
            my $cwd := $archive-file.parent;
            my $ENV := %*ENV;
            my $proc = zrun-async('tar', '--list', '-f', $archive-file.basename);
            whenever $proc.stdout(:bin) { $output.append($_) }
            whenever $proc.stderr(:bin) { }
            whenever $proc.start(:$ENV, :$cwd) { $passed = $_.so }
        }

        my @extracted-paths = $output.decode.lines;
        $passed ?? @extracted-paths.grep(*.defined) !! ();
    }

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
        
        my $extract-dir = $archive-file.IO.basename.subst(/\.tar\.gz/, '').IO.e
        ?? $archive-file.IO.basename.subst(/\.tar\.gz/, '').IO
        !! self.extract($archive-file, $*CWD);

        shell("./configure --prefix=$prefix", :cwd($extract-dir.relative));
        shell("make", :cwd($extract-dir.relative));
        shell("make install", :cwd($extract-dir.relative));
    }
}
