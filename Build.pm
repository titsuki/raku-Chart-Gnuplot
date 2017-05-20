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
        my $wget-exit-code = run 'which', 'wget';
        if $wget-exit-code == 0 {
            my $CMD = qq:x/which wget/.subst(/\s*/,"",:g);
	    my $url = "http://ftp.cstug.cz/pub/CTAN/graphics/gnuplot/5.0.5/gnuplot-5.0.5.tar.gz";
	    my $dl-exit-code = run $CMD, $url, "-O", "gnuplot-5.0.5.tar.gz";
            if not $dl-exit-code == 0 {
                die;
            }
        }
        if "gnuplot-5.0.5".IO.d {
            run 'rm', '-rf', 'gnuplot-5.0.5';
        }
        run 'tar', 'xvzf', 'gnuplot-5.0.5.tar.gz';
        
        chdir("gnuplot-5.0.5");
        shell("./configure --prefix=$prefix");
        shell("make");
        shell("make install");
        chdir($goback);
    }
    method isa($what) {
        return True if $what.^name eq 'Panda::Builder';
        callsame;
    }
}
