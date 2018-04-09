#! /usr/bin/perl -w
use strict;
if(@ARGV != 2) {
die "Usage:perl $0 input_file output_directory(existing)\n";
}
open FILE,$ARGV[0] || die $!;
open OUT1,">$ARGV[1]/LR.fasta";
open OUT2,">$ARGV[1]/LR_length";
my $n=0;
local $/=">";
while(<FILE>) {
chomp;
unless(/^\s*$/) { 
  my($id,$seq_ori) = split("\n",$_,2);
  $n++;
  $seq_ori =~ s/\s+//g;
  my $seq = lc($seq_ori);
  my $length = length($seq);
  print OUT1 ">LR$n\n$seq\n";
  print OUT2  "LR$n\t$length\n";
}
}
