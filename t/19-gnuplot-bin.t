use v6;
use Test;
use Chart::Gnuplot;

# Helper: a fake gnuplot executable that echoes each received command
# back to stdout prefixed with a marker. In debug mode Chart::Gnuplot
# pipes the subprocess' stdout/stderr to the supplied $stderr, so we can
# observe which binary was actually launched.
sub make-fake-gnuplot(--> Str) {
    my $path = $*TMPDIR.add("fake-gnuplot-{$*PID}-{(^1000).pick}").Str;
    spurt $path, q:to/SH/;
        #!/bin/sh
        while IFS= read -r line; do
            echo "FAKEGNUPLOT:$line"
        done
        SH
    $path.IO.chmod(0o755);
    $path;
}

# A tiny stderr sink that accumulates everything printed to it.
my class Capture {
    has $.buf is rw = "";
    method print(*@args) { $!buf ~= @args.join; }
    method say(*@args)   { $!buf ~= @args.join ~ "\n"; }
    method flush {}
}

# 1. The default (no :gnuplot) constructor still works.
{
    lives-ok {
        my $gnu = Chart::Gnuplot.new(:terminal("png"), :filename("sample.png"));
    }, "Chart::Gnuplot.new should work without :gnuplot (falls back to bundled/PATH).";
}

# 2. A user-supplied :gnuplot path is accepted.
{
    my $fake = make-fake-gnuplot;
    my $gnu;
    lives-ok {
        $gnu = Chart::Gnuplot.new(:terminal("png"), :filename("sample.png"), :gnuplot($fake));
    }, "Chart::Gnuplot.new should accept a user-supplied :gnuplot path.";
    # dispose awaits the subprocess promise, guaranteeing the binary has been
    # exec'd before we remove it. Removing it earlier races the async spawn and
    # makes exec fail with "no such file or directory" (notably on macOS, where
    # $*TMPDIR lives under /var/folders).
    $gnu.dispose;
    $fake.IO.unlink;
}

# 3. The injected :gnuplot binary is the one actually executed.
{
    my $fake = make-fake-gnuplot;
    my $cap = Capture.new;
    my $gnu = Chart::Gnuplot.new(:terminal("png"), :filename("sample.png"),
                                 :gnuplot($fake), :debug, :stderr($cap));
    $gnu.command("set xrange [0:1]");
    sleep 1;
    ok $cap.buf.contains("FAKEGNUPLOT:set xrange [0:1]"),
        "The user-supplied :gnuplot binary should be the one that receives commands.";
    $gnu.dispose;
    $fake.IO.unlink;
}

done-testing;
