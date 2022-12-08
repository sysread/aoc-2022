#!/usr/bin/env perl

use strict;
use warnings;
use v5.14;

use constant TOTAL_SPACE      => 70_000_000;
use constant MIN_UPDATE_SPACE => 30_000_000;

sub dir_size ($\%) {
  my ($dir, $sizes) = @_;

  my $size = 0;
  for my $key (keys %$sizes) {
    if ($key =~ /^$dir\//) {
      $size += $sizes->{$key};
    }
  }

  return $size;
}

open my $fh, '<', 'input.txt' or die $!;

my @path = ("");
my %size = ("" => 0);

while (my $line = <$fh>) {
  chomp $line;

  if ($line =~ /^\$ cd \//) {
    @path = ("");
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

my $used = dir_size '', %size;
my $free = TOTAL_SPACE - $used;
my $need = MIN_UPDATE_SPACE - $free;
my $min;

for my $path (keys %size) {
  next unless $size{$path} == 0;

  my $size = dir_size $path, %size;

  next if $size < $need;
  next if defined $min && $size > $min;

  $min = $size;
}

say $min;
