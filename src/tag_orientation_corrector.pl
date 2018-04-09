#! /usr/bin/perl -w
use strict;
open FILE,$ARGV[0] || die $!;
my (%count,%zhengcount,%fucount,$half,%hash);
while(<FILE>) {
chomp;
my @seg = split /\t/,$_;
my @flag = split /:/,$seg[0];
$count{$flag[0]."-".$seg[4]}++;
if(($seg[3]==16) || ($seg[3]==2064)) {
  $fucount{$flag[0]."-".$seg[4]}++;
}
else {
  $zhengcount{$flag[0]."-".$seg[4]}++;
}
}
foreach my $key (sort keys %count) {
$half = $count{$key}/2;
if (exists $zhengcount{$key}) {
  if($zhengcount{$key} > $half) {
    $hash{$key."-+"}=$zhengcount{$key};
  }
  elsif ($zhengcount{$key} < $half){
    $hash{$key."--"}=$fucount{$key};
  }
  else {
  }
}
else {
  $hash{$key."--"}=$fucount{$key};
}
}
undef %count;
undef %zhengcount;
undef %fucount;
open FILE2,$ARGV[0] || die $!;
my $dir;
while(<FILE2>) {
chomp;
my @seg_2 = split /\t/,$_;
my @flag = split /:/,$seg_2[0];
if(($seg_2[3]==16) || ($seg_2[3]==2064)) {
  $dir = "-";
}
else {
  $dir = "+";
}
if(exists $hash{$flag[0]."-".$seg_2[4]."-".$dir}) {
  print "$flag[0]\t$flag[1]\t$seg_2[1]\t$seg_2[2]\t$seg_2[3]\t$seg_2[4]\t$seg_2[5]\t$seg_2[6]\n";
}
}
close FILE;
close FILE2;
