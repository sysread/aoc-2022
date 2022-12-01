#!/usr/bin/env perl

use strict;
use warnings;
use v5.14;

open my $fh, "<", "input.txt" or die $!;

my $max = 0;
my $acc = 0;

while (my $line = <$fh>) {
  chomp $line;

  if ($line eq "") {
    $max = $acc
      if $max < $acc;

    $acc = 0;

    next;
  }

  $acc += sprintf("%d", $line);
}

$max = $acc
  if $max < $acc;

say $max;
