#! /usr/bin/perl -w
use strict;
my %hash;
open FILE,$ARGV[0] || die $!;
while(<FILE>) {
  chomp;
  my @seg = split /\t/,$_;
  if(!exists $hash{$seg[1]."-".$seg[2]}) {
    $hash{$seg[1]."-".$seg[2]}=$_;
  }
  else {
    $hash{$seg[1]."-".$seg[2]} .= "\n$_";
  }
}
foreach my $key (keys %hash) {
  my @line = split /\n/,$hash{$key};
  my $i=0;
  my $tag=0;
  my $bb=0;
  my $best;
  for(0..$#line) {
    my @seg2 = split /\t/,$line[$i];
    if($seg2[20]>$tag) {
      $best = $line[$i];
      $tag  = $seg2[20];
      $bb = $seg2[8];
    }
    elsif($seg2[20]==$tag) {
      if($seg2[8]>$bb) {
        $best = $line[$i];
        $tag = $seg2[20];
        $bb = $seg2[8];
      }
    }
    else {
    }
      $i++;
  }
  print "$best\n";
}
