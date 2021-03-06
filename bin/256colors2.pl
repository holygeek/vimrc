#!/usr/bin/perl
use strict;
use warnings;
# Author: Todd Larason <jtl@molehill.org>
# $XFree86: xc/programs/xterm/vttests/256colors2.pl,v 1.2 2002/03/26 01:46:43 dickey Exp $

use Getopt::Std;

my %opts;
getopts('s', \%opts);

my ($red, $green, $blue, $gray, $color, $level);

# use the resources for colors 0-15 - usually more-or-less a
# reproduction of the standard ANSI colors, but possibly more
# pleasing shades

# colors 16-231 are a 6x6x6 color cube
for ($red = 0; $red < 6; $red++) {
    for ($green = 0; $green < 6; $green++) {
	for ($blue = 0; $blue < 6; $blue++) {
	    printf("\x1b]4;%d;rgb:%2.2x/%2.2x/%2.2x\x1b\\",
		   16 + ($red * 36) + ($green * 6) + $blue,
		   ($red ? ($red * 40 + 55) : 0),
		   ($green ? ($green * 40 + 55) : 0),
		   ($blue ? ($blue * 40 + 55) : 0));
	}
    }
}

# colors 232-255 are a grayscale ramp, intentionally leaving out
# black and white
for ($gray = 0; $gray < 24; $gray++) {
    $level = ($gray * 10) + 8;
    printf("\x1b]4;%d;rgb:%2.2x/%2.2x/%2.2x\x1b\\",
	   232 + $gray, $level, $level, $level);
}


# display the colors

# first the system ones:
print "System colors:\n";
for ($color = 0; $color < 8; $color++) {
    print "\x1b[0m", sprintf("%2d", $color);
    print "\x1b[48;5;${color}m  ";
}
print "\x1b[0m\n";
for ($color = 8; $color < 16; $color++) {
    print "\x1b[0m", sprintf("%2d", $color);
    print "\x1b[48;5;${color}m  ";
}
print "\x1b[0m\n\n";

# now the color cube
print "Color cube, 6x6x6:\n";

# Show ruler at the top
my $spacer = $opts{s} ? "  " : " ";
my $nfmt = "%2d" . ($opts{s} ? " " : "");
for (1..6) {
    printf " " if ($_ > 2);
    print "    ";
    print sprintf $nfmt, $_ for (1..5);
    print $spacer;
}
print "\n";

$spacer = "\x1b[0m" . ($opts{s} ? " " : "");
for ($green = 0; $green < 6; $green++) {
    for ($red = 0; $red < 6; $red++) {
	$color = 16 + ($red * 36) + ($green * 6);
	my $w = $color < 83? 2 : 3;
	print sprintf("%${w}d", $color);
	for ($blue = 0; $blue < 6; $blue++) {
	    print "\x1b[48;5;${color}m  ";
	    print $spacer;
	    $color += 1;
	}
	print "\x1b[0m ";
    }
    print "\n";
    if ($opts{s}) {
	print "\n";
    }
}


# now the grayscale ramp
print "\n";
print "Grayscale ramp:\n";
for ($color = 232; $color < 256; $color++) {
    print "\x1b[0m ";
    print sprintf("\x1b[0m%3d", $color);
    print "\x1b[48;5;${color}m  ";
    # Break at middle
    if ($color == 232 + int((255 - 232) / 2)) {
        print "\x1b[0m";
	print "\n";
    }
}
print "\x1b[0m\n";
