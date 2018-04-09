#! /usr/bin/perl -w
use strict;
open FILE,$ARGV[0] || die $!;
my %hash;
while(<FILE>) {
  chomp;
  my @seg = split /\t/,$_;
  if(!exists $hash{$seg[5].$seg[0]}) {
    $hash{$seg[5].$seg[0]} = $_;
  }
  else {
    $hash{$seg[5].$seg[0]} .= "\n$_";
  }
}
foreach my $key (sort keys %hash) {
  print "$hash{$key}\n";
}
