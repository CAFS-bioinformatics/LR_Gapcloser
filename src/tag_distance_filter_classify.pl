#! /usr/bin/perl -w
use strict;
## F	AB001523.1	53889	LR6218	8739	9000	0	AB001523.1	42675	42940	R	AB001523.1	56714	NULL	NULL	NULL	NULLNULL	NULL	NULL ##
if(@ARGV != 4) {
  die "Usage: perl $0 file number(default=600) output_directory prefix_output\n";
}
open FILE,$ARGV[0] || die $!;
open OUTC,">$ARGV[2]/$ARGV[3]_complete.txt";
open OUTP,">$ARGV[2]/$ARGV[3]_partial.txt";
my $distance=$ARGV[1];
while(<FILE>) {
  chomp;
  my @seg = split /\t/,$_;
  if(($seg[3] ne "NULL") && ($seg[13] ne "NULL")) {
        if(($seg[2]-$seg[9]<=$distance) && ($seg[18]-$seg[12]<=$distance)) {
          print OUTC "$_\n";
        }
      }
  elsif($seg[13] eq "NULL") {
      if($seg[2]-$seg[9]<=$distance) {
        print OUTP "$_\n";
      }
    }
  else {
    if($seg[18]-$seg[12]<=$distance) {
      print OUTP "$_\n";
    }
  }
}
close FILE;
close OUTC;
close OUTP;
