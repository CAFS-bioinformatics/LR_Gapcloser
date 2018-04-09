#! /usr/bin/perl -w
use strict;
open FILE,$ARGV[0] || die $!;
my %hash;
while(<FILE>) {
  chomp;
  my @seg = split /\t/,$_;
  $hash{$seg[2]}=$_;
}
foreach my $key(sort keys %hash) {
  print "$hash{$key}\n";
}
close FILE;
