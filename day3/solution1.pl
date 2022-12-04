#!/usr/bin/env perl

use strict;
use warnings;
use v5.14;

sub priority {
  my $item = shift;

  if ($item =~ /^[a-z]$/) {
    ord($item) - ord("a") + 1;
  }
  elsif ($item =~ /^[A-Z]$/) {
    ord($item) - ord("A") + 27;
  }
  else {
    0;
  }
}

open my $fh, '<', 'input.txt' or die $!;
my $priority = 0;

while (my $line = <$fh>) {
  chomp $line;

  # Split the contents into compartments
  my $items_per_side = length($line) / 2;
  my $compartment_a  = substr $line, 0, $items_per_side;
  my $compartment_b  = substr $line, $items_per_side;

  # Find the item that is in both compartments
  my ($shared_item)  = $compartment_b =~ /([$compartment_a])/;

  # Calculate the item's priority
  $priority += priority $shared_item;
}

say $priority;
