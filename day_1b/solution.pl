#!/usr/bin/env perl

use strict;
use warnings;
use v5.14;
use List::Util qw(sum);

open my $fh, "<", "input.txt" or die $!;

my @candidates = (0);

while (my $line = <$fh>) {
  chomp $line;

  if ($line eq "") {
    @candidates = sort{ $a > $b} @candidates;
    @candidates > 3 && shift @candidates;
    unshift @candidates, 0;
    next;
  }

  $candidates[0] += sprintf("%d", $line);
}

@candidates = sort{ $a > $b } @candidates;
@candidates > 3 && shift @candidates;
say sum @candidates;
