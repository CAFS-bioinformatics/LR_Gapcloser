#! /usr/bin/perl -w
use strict;
open INFO,$ARGV[0] || die $! ;
open LR,$ARGV[1] || die $!;
open CONTIG,$ARGV[2] || die $!;
my (%hash,%lr,%contig,%location,@flag,@flag2,@seg,@zz,@yy,@xx,%symbol,%idgap);
while(<INFO>) {
  chomp;
   @seg = split /\t/,$_;
   @flag = split /\(:/,$seg[1];
##
if(!exists $idgap{$seg[0]}) {
  $idgap{$seg[0]}=$_;
}
else {
  my @zz = split /\t/,$idgap{$seg[0]};
  my @yy = split /-/,$zz[2];
  my @xx = split /-/,$seg[2];
  if($xx[1]>$yy[1]) {
    $symbol{$seg[1]}=1;
  }
  else {
    $symbol{$zz[1]}=1;
  }
}
##
  if(!exists $lr{$flag[0]}) {
    $lr{$flag[0]} = "$flag[1](:$flag[2]";
  }
  else {
    $lr{$flag[0]} .= "\t$flag[1](:$flag[2]";
  }
   @flag2 = split /\(:/,$seg[2];
  if(!exists $contig{$flag2[0]}) {
    $contig{$flag2[0]} = "$flag2[1];$seg[1]"; 
    $location{$flag2[0]} = $flag2[1];
  }
  else {
    $contig{$flag2[0]} .= "\t$flag2[1];$seg[1]";
    $location{$flag2[0]} .= "-$flag2[1]";
  }
}
undef %idgap;
local $/=">";
while (<LR>) {
  chomp;
  my @fram;
unless (/^\s*$/) {
  my ($id,$seq) = split("\n",$_,2);
  $seq =~ s/\s+//g;
  if(exists $lr{$id}) {
    my @cut = split /\t/,$lr{$id};
    my $i=0;
    my ($line1,$line2);
    for(0..$#cut) {
      my @cutt = split /\(:/,$cut[$i];
      @fram = split /-/,$cutt[0];
      my $big = &max(@fram);
      my $small = &min(@fram);
      if($cutt[1] eq "+") {
        $line1 = substr($seq,$small-1,$big-$small+1);
##add 100N
if(exists $symbol{$id."(:".$cut[$i]}) {
  $line1 = "N" x 100 . $line1;
}
##
        $hash{$id."(:".$cut[$i]} = $line1;
      }
      else {
        $line1 = substr($seq,$small-1,$big-$small+1);
        $line1 =~ tr/ATGCatgc/TACGtacg/;
        $line2 = reverse $line1;
##add 100N
if(exists $symbol{$id."(:".$cut[$i]}) {
  $line1 = "N" x 100 . $line1;
}
##
        $hash{$id."(:".$cut[$i]} = $line2;
      }
      $i++;
    }
  }
}
}
local $/=">";
while(<CONTIG>) {
  chomp;
unless (/^\s*$/) {
  my ($id2_ori,$seq2) = split("\n",$_,2);
  my $id2=$1 if($id2_ori=~/^(\S+)/);
  $seq2 =~ s/\s+//g;
  if(exists $contig{$id2}) {
    my @box1 = split /-/,$location{$id2};
    my @box = sort{$a <=> $b}@box1;
    my $d=@box;
    my $tmp=0;
    my (@bb,%info,%info2);
    my $n=0;
    for(my $ii=0;$ii<$d/2;$ii++) {
      $a=shift @box;
      $b=shift @box;
      if($a-1>$tmp) {
        my $sq = substr($seq2,$tmp,$a-$tmp-1);
        push @bb,$sq;
        my $tmp1=$tmp+1;
        my $a1=$a-1;
        $info{$tmp1."-".$a1}=$n;
        $n++;
      }
      my $sq2 = substr($seq2,$a-1,$b-$a+1);
      push @bb,$sq2;
      $info{$a."-".$b}=$n;
      $n++;
      $tmp=$b;
    }
    my $sq = substr($seq2,$tmp);
    push @bb,$sq;
    my @flag3 = split /\t/,$contig{$id2};
    my $i=0;
    for(0..$#flag3) {
      my @con = split /;/,$flag3[$i];
      my @conn = split /-/,$con[0];
      if($conn[1]>$conn[0]) {
        $info2{$con[0]}=$con[1];
      }
      else {
        $info2{$conn[1]."-".$conn[0]}=$con[1];
      }
      $i++;
    }
    foreach my $key (keys %info2) {
      my $nn = $info{$key};
      $bb[$nn]=$hash{$info2{$key}};
    }
    my $line = join " ",@bb;
    $line =~ s/ //g;
    print ">$id2_ori\n$line\n";
    undef %info;
    undef %info2;
    undef @bb;
    undef @box1;
    undef @box;
  }
  else {
    print ">$id2_ori\n$seq2\n";
  }
}
}
sub max {
  my ($max_so_far) = shift @_;
  foreach (@_) {
    if ($_ > $max_so_far) {
      $max_so_far = $_;
    }
  }
  $max_so_far;
}
sub min {
  my ($min_so_far) = shift @_;
  foreach (@_) {
    if($_ < $min_so_far) {
      $min_so_far = $_;
    }
  }
  $min_so_far;
}
