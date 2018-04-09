#! /usr/bin/perl -w
use strict;
if(!@ARGV) {
  print "Usage: perl $0 part2-file ends-file\n";
  die;
}
my %hash;
open FILE,$ARGV[0] || die $!;
open FILE2,$ARGV[1] || die $!;
while(<FILE>) {
  chomp;
  my @seg = split /\t/,$_;
  $hash{$seg[1]."-".$seg[2]}=1;
}
while(<FILE2>) {
  chomp;
  my @seg2 = split /\t/,$_;
  if(exists $hash{$seg2[1]."-".$seg2[2]}) {
  }
  else {
    print "$_\n";
  }
}
