#! /usr/bin/perl -w
use strict;
if(!@ARGV) {
print "Usage:perl $0 file\n";
}
my $range;
if(@ARGV==2) {
  $range=$ARGV[1];
}
else {
  $range=600;
}
open FILE,$ARGV[0] || die $!;
while(<FILE>) {
  chomp;
  my @seg = split /\t/,$_;
  if($seg[13] eq 'NULL') {
    if(($seg[6]==16) || ($seg[6]==2064)) {
      if((($seg[9]+$seg[4]-1>$seg[2]) && ($seg[9]+$seg[4]-1<$seg[12])) || (($seg[9]+$seg[4]-1>$seg[12]) && ($seg[9]+$seg[4]-1<$seg[12]+$range))){
        print "$_\n";
      }
    }
    else {
      if((($seg[9]+$seg[21]-$seg[5]>$seg[2]) && ($seg[9]+$seg[21]-$seg[5]<$seg[12])) || (($seg[9]+$seg[21]-$seg[5]>$seg[12]) && ($seg[9]+$seg[21]-$seg[5]<$seg[12]+$range))) {
        print "$_\n";
      }
    } 
  }
  elsif($seg[3] eq 'NULL') {
    if(($seg[16]==16) || ($seg[16]==2064)) {
      if((($seg[18]-($seg[21]-$seg[15])>$seg[2]) && ($seg[18]-($seg[21]-$seg[15])<$seg[12])) || (($seg[18]-($seg[21]-$seg[15])>$seg[2]-$range)&& ($seg[18]-($seg[21]-$seg[15])<$seg[2]))){
        print "$_\n";
      }
    }
    else {
      if((($seg[18]-$seg[14]+1>$seg[2]) && ($seg[18]-$seg[14]+1<$seg[12])) || (($seg[18]-$seg[14]+1>$seg[2]-$range) && ($seg[18]-$seg[14]+1<$seg[2]))) {
        print "$_\n";
      }
    }
  }
  else {
    print "$_\n";
  }
}
