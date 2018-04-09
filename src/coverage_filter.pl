#! /usr/bin/perl -w
use strict;
if(@ARGV != 2) {
  die"Usage:perl $0 file number\n";
}
my ($line,%hash) ;
open FILE,$ARGV[0] || die $!;
while(<FILE>) {
  chomp;
  my @seg = split /\t/,$_;
  $line = "$seg[0]\t$seg[1]\t$seg[2]\t$seg[3]\t$seg[4]\t$seg[5]\t$seg[6]";
  if($seg[11] >= $ARGV[1] && !exists($hash{$line})) 
  {
    print $line."\n";
    $hash{$line}=1;
  }
}
close FILE;
