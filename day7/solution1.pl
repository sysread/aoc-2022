#!/usr/bin/env perl

use strict;
use warnings;
use v5.14;

sub dir_size ($\%) {
  my ($dir, $sizes) = @_;

  my $size = 0;
  for my $key (keys %$sizes) {
    $size += $sizes->{$key}
      if $key =~ /^$dir\//;
  }

  return $size;
}

open my $fh, '<', 'input.txt' or die $!;

my @path;
my %size;

while (my $line = <$fh>) {
  chomp $line;

  if ($line =~ /^\$ cd \//) {
    undef @path;
  }
  elsif ($line =~ /^\$ cd \.\./) {
    pop @path;
  }
  elsif (my ($chdir) = $line =~ /^\$ cd (.+)$/) {
    push @path, $chdir;
  }
  elsif (my ($lsdir) = $line =~ /^dir (.+)$/) {
    my $dir_path = join '/', @path, $lsdir;
    $size{$dir_path} = 0;
  }
  elsif (my ($size, $file) = $line =~ /^(\d+) (.+)$/) {
    my $file_path = join '/', @path, $file;
    $size{$file_path} = $size;
  }
}

my $total = 0;

for my $path (keys %size) {
  next unless $size{$path} == 0;
  if ((my $size = dir_size $path, %size) <= 100_000) {
    $total += $size;
  }
}

say $total;
