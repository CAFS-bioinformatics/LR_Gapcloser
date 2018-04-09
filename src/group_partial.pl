#! /usr/bin/perl -w
use strict;
if(@ARGV != 3) {
  print "usage:perl $0 input output_directory output_prefix\n";
  die;
}
open FILE,$ARGV[0] || die $!;
my %hash;
while(<FILE>) {
  chomp;
  my @seg = split /\t/,$_;
  if(!exists $hash{$seg[1]."-".$seg[2]}){
    $hash{$seg[1]."-".$seg[2]} = $_;
  }
  else {
    $hash{$seg[1]."-".$seg[2]} .= "\n$_";
  }
}
open OUT1,">$ARGV[1]/$ARGV[2]_open.txt";
open OUT2,">$ARGV[1]/$ARGV[2]_close_1.txt";
open OUT3,">$ARGV[1]/$ARGV[2]_close_2.txt";
foreach my $key (keys %hash) {
  my @line = split /\n/,$hash{$key};
  my($Fline,$Rline,$Fstop,$Rstart);
  if($#line==0) {
    my @sega = split /\t/,$line[0];
    if($sega[13] eq 'NULL') {
      if($sega[6]==0) {
        $Fstop=$sega[9]+$sega[21]-$sega[5];
      }
      else {
        $Fstop=$sega[9]+$sega[4]-1;
      }
      if($Fstop>$sega[12]) {
        print OUT2 "$line[0]\n";
      }
      else {
        print OUT1 "$line[0]\n";
      }
    }
    else {
      if($sega[16]==0) {
        $Rstart=$sega[18]-$sega[14]+1;
      }
      else {
        $Rstart=$sega[18]-($sega[21]-$sega[15]);
      }
      if($Rstart<$sega[2]) {
        print OUT2 "$line[0]\n";
      }
      else {
        print OUT1 "$line[0]\n";
      }
    }
  }
  else {
    my @seg2 = split /\t/,$line[0];
    my @seg3 = split /\t/,$line[1];
    if($seg2[13] eq 'NULL') {
      $Fline=$line[0];
      $Rline=$line[1];
      if($seg2[6]==0) {
        $Fstop=$seg2[9]+$seg2[21]-$seg2[5];
      }
      else {
        $Fstop=$seg2[9]+$seg2[4]-1;
      }
      if($seg3[16]==0) {
        $Rstart=$seg3[18]-$seg3[14]+1;
      }
      else {
        $Rstart=$seg3[18]-($seg3[21]-$seg3[15]);
      }
    }
    else {
      $Fline=$line[1];
      $Rline=$line[0];
      if($seg3[6]==0) {
        $Fstop=$seg3[9]+$seg3[21]-$seg3[5];
      }
      else {
        $Fstop=$seg3[9]+$seg3[4]-1;
      }
      if($seg2[16]==0) {
        $Rstart=$seg2[18]-$seg2[14]+1;
      }
      else {
        $Rstart=$seg2[18]-($seg2[21]-$seg2[15]);
      }
    }
    if($Fstop>=$seg2[12]) {
      print OUT2 "$Fline\n";
    }
    else {
      if($Rstart<=$seg2[2]) {
        print OUT2 "$Rline\n";
      }
      elsif(($Rstart>$seg2[2]) && ($Rstart<=$Fstop)) {
        print OUT3 "$Fline\n$Rline\n";
      }
      else {
        print OUT1 "$Fline\n$Rline\n";
      }
    }
  }
}
