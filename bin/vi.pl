#!/usr/bin/env perl
use strict;
use warnings;
use File::Basename;
# vi
# Created: Tue Mar 25 11:15:04 SGT 2014
my $bin = basename($0);
if ($bin eq 'vi') {
  $bin = 'vim';
}
my $realvi = '/usr/local/bin/' . $bin;
sub run_vi_normally {
  undef $ENV{LD_LIBRARY_PATH};
  system("$realvi", @ARGV);
}

sub open_with_line_number {
  my ($arg) = @_;
  $arg =~ s/:/ +/;
  $arg =~ s/:.*//;
  my $cmd = "$realvi $arg";
  print "$cmd\n";
  system($cmd);
}

if ($ENV{GOROOT}) {
  $ENV{PATH} = "$ENV{GOROOT}/bin:$ENV{PATH}";
}
if (@ARGV == 1) {
  if ($ARGV[0] =~ /\d\d:\d\d:\d\d/) {
    run_vi_normally();
  } elsif ($ARGV[0] =~ /:\d+:?/) {
    open_with_line_number($ARGV[0]);
  } else {
    run_vi_normally();
  }
} else {
  run_vi_normally();
}
