#!/usr/bin/env perl

use strict;
use warnings;
use v5.14;


package Knot {
  use List::Util qw(min max);

  use constant UP    => 'U';
  use constant DOWN  => 'D';
  use constant LEFT  => 'L';
  use constant RIGHT => 'R';
  use constant X     => 0;
  use constant Y     => 1;

  sub new {
    my $class = shift;
    my $id    = shift // 0;

    my $self = bless {
      id          => $id == 0 ? 'H' : $id,
      position    => [0, 0],
      breadcrumbs => {'0,0' => 1},
    }, $class;

    $self->{tail} = $class->new($id + 1)
      if $id < 9;
      #if $id < 1;

    return $self;
  }

  sub move {
    my ($self, $direction, $moves) = @_;
      $direction eq UP    ? $self->_move(Y,  $moves)
    : $direction eq DOWN  ? $self->_move(Y, -$moves)
    : $direction eq RIGHT ? $self->_move(X,  $moves)
    : $direction eq LEFT  ? $self->_move(X, -$moves)
    : die "invalid direction: $direction";
  }

  sub _move {
    my ($self, $axis, $moves) = @_;
    my $count = abs $moves;
    my $inc = $moves / $count;

    for (my $i = 0; $i < $count; ++$i) {
      $self->{position}[$axis] += $inc;

      $self->{tail}->follow($self->{position})
        if defined $self->{tail};
    }
  }

  sub follow {
    my ($self, $head) = @_;

    if ($self->distance($head) > 1) {
      my $start = [ @{ $self->{position} } ];
      my $moves = $self->moves_distant($head);
      my $rise  = $head->[Y] - $self->{position}[Y];
      my $run   = $head->[X] - $self->{position}[X];

      if ($moves == 1) {
        if ($rise > 1) {
          ++$self->{position}[Y];
        }
        elsif ($rise < -1) {
          --$self->{position}[Y];
        }
        elsif ($run > 1) {
          ++$self->{position}[X];
        }
        elsif ($run < -1) {
          --$self->{position}[X];
        }
      }
      elsif ($moves >= 2) {
        # NE
        if ($rise > 0 && $run > 0) {
          ++$self->{position}[Y];
          ++$self->{position}[X];
        }
        # NW
        elsif ($rise > 0 && $run < 0) {
          ++$self->{position}[Y];
          --$self->{position}[X];
        }
        # SE
        elsif ($rise < 0 && $run > 0) {
          --$self->{position}[Y];
          ++$self->{position}[X];
        }
        # SW
        elsif ($rise < 0 && $run < 0) {
          --$self->{position}[Y];
          --$self->{position}[X];
        }
      }

      my $position = join ',', @{ $self->{position} };
      $self->{breadcrumbs}{$position} = 1;
    }

    $self->{tail}->follow($self->{position})
      if defined $self->{tail};
  }

  sub moves_distant {
    my ($self, $head) = @_;
    my $moves = abs($self->{position}[Y] - $head->[Y])
              + abs($self->{position}[X] - $head->[X]);
    return max(0, $moves - 1);
  }

  sub distance {
    my ($self, $head) = @_;
    my $x = $head->[X] - $self->{position}[X];
    my $y = $head->[Y] - $self->{position}[Y];
    sqrt ($x * $x) + ($y * $y);
  }

  sub moves_by_tail {
    my $self = shift;
    if (defined $self->{tail}) {
      $self->{tail}->moves_by_tail;
    } else {
      scalar keys %{ $self->{breadcrumbs} };
    }
  }

  sub plot {
    my $self = shift;

    my $node = $self;
    my $min = 0;
    my $max = 0;
    my %point;
    my @points;

    while (defined $node) {
      my ($x, $y) = @{ $node->{position} };
      $point{$x} //= {};
      $point{$x}{$y} //= [];

      $min = min($min, $x, $y);
      $max = max($max, $x, $y);

      push @points, ["ID:$node->{id}", $x, $y];
      push @{$point{$x}{$y}}, $node->{id};

      $node = $node->{tail};
    }

    for my $y (reverse($min..$max)) {
      for my $x ($min..$max) {
        $point{$x} //= {};
        $point{$x}{$y} //= [];

        my $ids = $point{$x}{$y};
        if (@$ids > 1) {
          print $ids->[0];
        } elsif (@$ids) {
          print "@$ids";
        } else {
          print ".";
        }
      }

      for my $x ($min..$max) {
        my $ids = $point{$x}{$y};
        if (@$ids > 1) {
          my ($first, @rest) = @$ids;
          say "\t$first covers " . join(", ", @rest);
        }
      }

      print "\n";
    }
  }
};


my $debug = $ARGV[0] // 0;

open my $fh, '<', 'input.txt' or die $!;

my $knot = Knot->new;

if ($debug) {
  say "== INITIAL STATE ==\n";
  $knot->plot;
  say "";
}

while (my $line = <$fh>) {
  chomp $line;
  my ($direction, $moves) = split ' ', $line;
  $knot->move($direction, $moves);

  if ($debug) {
    say "== $direction $moves ==\n";
    $knot->plot;
    say "";
  }
}

say $knot->moves_by_tail;
