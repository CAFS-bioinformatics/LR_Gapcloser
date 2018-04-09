#! /usr/bin/perl -w
use strict;
open FILE,$ARGV[0] || die $!;
my %hash;
while(<FILE>) 
{
 chomp;
 my @seg = split /\t/,$_;
 $hash{$seg[0]}++;
}
open FILE2,$ARGV[0] || die $!;
while(<FILE2>) 
{
 chomp;
 my @seg_2 = split /\t/,$_;
 if (exists $hash{$seg_2[0]} && ($hash{$seg_2[0]}==1)) 
 {
  print "$_\n";
 }
}
close FILE;
