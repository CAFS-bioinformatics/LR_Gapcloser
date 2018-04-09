#! /usr/bin/perl -w
use strict;
if(@ARGV != 2) {
die "Usage:perl $0 LR_length_file file\n";
}
open LR,$ARGV[0] || die $!;
open FILE,$ARGV[1] || die $!;
my %hash;
while(<LR>) {
  chomp;
  my @seg = split /\t/,$_;
  $hash{$seg[0]}=$seg[1];
}
while(<FILE>) {
  chomp;
  my @seg2 = split /\t/,$_;
  if($seg2[3] eq 'NULL') {
    if($seg2[13] eq 'NULL') {
    }
    else {
      print $_."\t".$hash{$seg2[13]}."\n";
    }
  }
  else {
    print $_."\t".$hash{$seg2[3]}."\n";
  }
}
close LR;
close FILE;
