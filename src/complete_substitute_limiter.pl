#! /usr/bin/perl -w
use strict;
open FILE,$ARGV[0] || die $!;
my ($range,$LR,$contig,$difference);
if(@ARGV==2) {
  if($ARGV[1]>=0) {
    $range=$ARGV[1];
  }
  else {
    $range=0;
  }
}
else {
  $range=0.2;
}
while(<FILE>) {
  chomp;
  my @seg = split /\t/,$_;
  if($seg[6]==0) {
    $LR=abs($seg[5]-$seg[14]);
  }
  else {
    $LR=abs($seg[4]-$seg[15]);
  }
  $contig=abs($seg[9]-$seg[18]);
  $difference=abs($LR-$contig);
  my $tolerance=$range*$contig;
  if($difference<=$tolerance) {
    print "$_\n";
  }
}
