#! /usr/bin/perl -w
use strict;
if(@ARGV != 2) {
print "Usage:perl $0 input_file tag_length\n";
die;
}
open FILE,$ARGV[0] || die $!;
local $/=">";
while(<FILE>) {
  chomp;
unless(/^\s*$/) {
  my($id,$seq)=split("\n",$_,2);
  $seq =~ s/\s+//g;
  my $len = length($seq);
  for(my $i=0;$i<$len;$i+=$ARGV[1]) {
    my $subseq = substr($seq,$i,$ARGV[1]);
    print ">$id:$i\n$subseq\n";
  }
}
}
close FILE;
