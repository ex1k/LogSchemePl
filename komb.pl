use strict;
use v5.18;
#use warnings;
use Data::Dumper;

sub or_func {
  my $first = shift;
  my $second = shift;
  my $history = shift;
  return sub {
    my $a = 0;
    my $b = 0;
    if (!defined $second) {
      $a = $first->(0);
      $b = $first->(0);
    }
    else {
      $a = $first->();
      $b = $second->();
    }
    my $c = ($a or $b);
    if (defined $history) {
      $history->(1, $c);
    }
    return $c;
  }
}

sub f_input {
  my $input = shift;
  my $history = shift;
  return sub {
    if (defined $_[0]) {
      if ($_[0] == 0) {
        my $a = substr($input, 0, 1);
        substr($input, 0, 1) = "";
        return $a;
      }
      elsif ($_[0] == 1) {
        $history = $_[1];
        return $history;
      }
      elsif (defined $_[0]) {
        $input = $_[0];
        return $input;
      }
    }
    return $history;
  }
}

sub and_func {
  my $first = shift;
  my $second = shift;
  return sub {
    my $a = 0;
    my $b = 0;
    if (!defined $second) {
      $a = $first->(0);
      $b = $first->(0);
    }
    else {
      $a = $first->();
      $b = $second->();
    }
    if ($b == -1) {
      my $c = (not $a);
      if ($c == '') { $c = 0};
      return $c;
    }
    else {
      my $c = ($a and $b);
      return $c;
    }
  }
}

sub not_func {
  my $first = shift;
  my $input = shift;
  return sub {
    my $a = 0;
    if (defined $input) {
      $a = $first->(0);
    }
    else {
      $a = $first->();
    }
    my $c = (not $a);
    if ($c == '') { $c = 0};
    return $c;
  }
}

sub scheme($) {
  my $input = shift;
  print or_func(not_func(and_func($input)), and_func(or_func($input), and_func($input)))->();
  print not_func(or_func(and_func(or_func($input), $input), and_func($input), $input))->() . "\n";
}
my $input = f_input("", -1);
my $i = 3;
while (<>) {
  $input->($_);
  scheme($input);
  $i--;
  last if $i == 0;
}

