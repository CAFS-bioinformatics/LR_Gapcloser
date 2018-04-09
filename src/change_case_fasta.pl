#! /usr/bin/perl -w
use strict;
if(@ARGV != 2) {
  print "Usage:perl $0 file 1or2\nthe meaning of 1 and 2 as follows:\n1:converted to upper case.\n2:converted to lower case.\n";
  die;
}
open FILE,$ARGV[0] || die $!;
my $a;
local $/=">";
while(<FILE>) {
  chomp;
unless(/^\s*$/) {
  my($id,$seq)=split("\n",$_,2);
  $seq =~ s/\s+//g;
  if($ARGV[1]==1) {
    $a = uc($seq);
    print ">$id\n$a\n";
   }
  if($ARGV[1]==2) {
    $a = lc($seq);
    print ">$id\n$a\n";
  }
}
}
close FILE;
