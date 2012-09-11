#!/usr/bin/env perl
use strict;
use warnings;

use Test::More;

my @symlinks = qw(
      doc/matchit.txt
      plugin/matchit.vim
    );

foreach my $symlink (@symlinks) {
  ok(readlink $symlink, "$symlink");
}

done_testing();

