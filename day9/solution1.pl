#!/usr/bin/env perl

use strict;
use warnings;
use v5.14;


package Grid {
  use List::Util qw(max);

  use constant UP    => 'U';
  use constant DOWN  => 'D';
  use constant LEFT  => 'L';
  use constant RIGHT => 'R';
  use constant X     => 0;
  use constant Y     => 1;

  sub new {
    my $class = shift;

    bless {
      head        => [0, 0],
      tail        => [0, 0],
      breadcrumbs => {'0,0' => 1},
    }, $class;
  }

  sub move {
    my ($self, $direction, $moves) = @_;
      $direction eq UP    ? $self->move_head(Y,  $moves)
    : $direction eq DOWN  ? $self->move_head(Y, -$moves)
    : $direction eq RIGHT ? $self->move_head(X,  $moves)
    : $direction eq LEFT  ? $self->move_head(X, -$moves)
    : die "invalid direction: $direction";
  }

  sub move_head {
    my ($self, $axis, $moves) = @_;
    my $count = abs $moves;
    my $inc = $moves / $count;

    for (my $i = 0; $i < $count; ++$i) {
      $self->{head}[$axis] += $inc;
      $self->move_tail;
    }
  }

  sub move_tail {
    my $self = shift;

    if ($self->distance > 1) {
      my $moves = $self->moves_distant;
      my $rise  = $self->{head}[Y] - $self->{tail}[Y];
      my $run   = $self->{head}[X] - $self->{tail}[X];

      if ($moves == 1) {
        if ($rise > 1) {
          ++$self->{tail}[Y];
        }
        elsif ($rise < -1) {
          --$self->{tail}[Y];
        }
        elsif ($run > 1) {
          ++$self->{tail}[X];
        }
        elsif ($run < -1) {
          --$self->{tail}[X];
        }
      }
      elsif ($moves == 2) {
        # NE
        if ($rise > 0 && $run > 0) {
          ++$self->{tail}[Y];
          ++$self->{tail}[X];
        }
        # NW
        elsif ($rise > 0 && $run < 0) {
          ++$self->{tail}[Y];
          --$self->{tail}[X];
        }
        # SE
        elsif ($rise < 0 && $run > 0) {
          --$self->{tail}[Y];
          ++$self->{tail}[X];
        }
        # SW
        elsif ($rise < 0 && $run < 0) {
          --$self->{tail}[Y];
          --$self->{tail}[X];
        }
      }

      my $position = join ',', @{ $self->{tail} };
      $self->{breadcrumbs}{$position} = 1;
    }
  }

  sub moves_distant {
    my $self  = shift;
    my $moves = abs($self->{tail}[Y] - $self->{head}[Y])
              + abs($self->{tail}[X] - $self->{head}[X]);
    return max(0, $moves - 1);
  }

  sub distance {
    my ($self) = @_;
    my $x = $self->{head}[X] - $self->{tail}[X];
    my $y = $self->{head}[Y] - $self->{tail}[Y];
    sqrt ($x * $x) + ($y * $y);
  }

  sub moves_by_tail {
    my $self = shift;
    scalar keys %{ $self->{breadcrumbs} };
  }
};


open my $fh, '<', 'input.txt' or die $!;

my $grid = Grid->new;

while (my $line = <$fh>) {
  chomp $line;
  my ($direction, $moves) = split ' ', $line;
  $grid->move($direction, $moves);
}

say $grid->moves_by_tail;
