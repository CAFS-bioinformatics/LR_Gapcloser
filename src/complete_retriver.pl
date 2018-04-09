#! /usr/bin/perl -w
use strict;
if( @ARGV != 2 ) {
    print "Usage: $0 close1.txt tag.coverage \n";
    exit 0;
}
open FILE,$ARGV[0] || die $!;
my %hash;
while(<FILE>) {
  chomp;
  my @seg = split /\t/,$_;
  if($seg[13] eq "NULL") 
  {
    $hash{$seg[3]."-".$seg[7]."-".$seg[6]}="right\t$seg[12]\t$seg[3]\t$seg[4]\t$seg[5]\t$seg[7]\t$seg[8]\t$seg[9]";
  }
  else {
    $hash{$seg[13]."-".$seg[17]."-".$seg[16]}="left\t$seg[2]\t$seg[13]\t$seg[14]\t$seg[15]\t$seg[17]\t$seg[18]\t$seg[19]";
  }
}
open FILE2,$ARGV[1] || die $!;
while(<FILE2>) 
{
  chomp;
  my @seg2 = split /\t/,$_;
  my @flag = split /:/,$seg2[0];
  if(exists $hash{$flag[0]."-".$seg2[4]."-".$seg2[3]}) {
    my @flag2 = split /\t/,$hash{$flag[0]."-".$seg2[4]."-".$seg2[3]};
    if($flag2[0] eq "right") {
      if($flag2[1]<$seg2[6]) {
        print "R\t$seg2[0]\t$seg2[1]\t$seg2[2]\t$seg2[3]\t$seg2[4]\t$seg2[5]\t$seg2[6]\n";
      }
    }
    else {
     if($flag2[1]>$seg2[6]) {
        print "F\t$seg2[0]\t$seg2[1]\t$seg2[2]\t$seg2[3]\t$seg2[4]\t$seg2[5]\t$seg2[6]\n";
      }
    }
  }
}
