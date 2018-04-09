#! /usr/bin/perl -w
use strict;
open FILE,$ARGV[0] || die $!;
my (%hash,%clash);
while (<FILE>) {
chomp;
my @seg = split /\t/,$_;
my @flag = split /\(:/,$seg[2];
my @fflag = split /-/,$flag[1];
if(!exists $hash{$flag[0]}) {
  $hash{$flag[0]}=$_;
}
else {
  $hash{$flag[0]} .= ";$_";
}
}
foreach my $key (sort keys %hash) {
  my @line = split /;/,$hash{$key};
  for (my $i=0;$i<=$#line;$i++) {
    my $n=0;
    my @seg2 = split /\t/,$line[$i];
    my @flag2 = split /\(:/,$seg2[2];
    my @fflag2 = split /-/,$flag2[1];
    foreach my $aa (@line) {
      my @seg3 = split /\t/,$aa;
      if($aa eq $line[$i]) {
        next;
      }
      else {
        my @flag3 = split /\(:/,$seg3[2];
        my @fflag3 = split /-/,$flag3[1];
        if($fflag2[0]>=$fflag3[0]) {
          if($fflag2[0]<=$fflag3[1]) {
            if(!exists $clash{$flag2[0]}) {
              $clash{$flag2[0]}=$line[$i];
            }
            else {
              $clash{$flag2[0]} .= ";$line[$i]";
            }
            last;
          }
          else {
            $n++;
          }
        }
        else {
          if($fflag2[1]>=$fflag3[0]) {
            if(!exists $clash{$flag2[0]}) {
              $clash{$flag2[0]}=$line[$i];
            }
            else {
              $clash{$flag2[0]} .= ";$line[$i]";
            }
            last;
          }
          else {
            $n++;
          }
        }
      }
    }
    my $count = @line;
    my $cou = $count-1;
    if ($n==$cou) {
      print "$line[$i]\n";
    }
    $n=0;
  }
}
undef %hash;
foreach my $key (sort keys %clash) {
  my @line = split /;/,$clash{$key};
  my $retain;
  my $value=0;
  for(my $i=0;$i<=$#line;$i++) {
    my @seg2 = split /\t/,$line[$i];    
    my @flag2 = split /\(:/,$seg2[2];
    my @fflag2 = split /-/,$flag2[1];
    if ($fflag2[1]-$fflag2[0]>=$value) {
      $retain = $line[$i];
      $value = $fflag2[1]-$fflag2[0];
    }
  }
  print "$retain\n";
}
