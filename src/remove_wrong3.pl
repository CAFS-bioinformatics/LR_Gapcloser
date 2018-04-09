#! /usr/bin/perl -w
use strict;
my (@sseg,@sseg2,@record,@conloc,@reselect,%hash,$tag_distance,$con_distance);
my $tmp=0;
my $aa=0;
open FILE,$ARGV[0] || die $!;
while(<FILE>) {
  chomp;
  my @seg = split /\t/,$_;
  if (($seg[0] eq $tmp) && ($seg[5] eq $aa)) {
    push (@record,$_);
    push (@conloc,$seg[6]);
    $hash{$seg[6]."aa"}=$seg[1];
  }
  else {
    my $count = @record;
    if($count<2) {
    }
    elsif($count==2) {
      @sseg = split /\t/,$record[0];
      @sseg2 = split /\t/,$record[1];
      if(($sseg[4]==0) || ($sseg[4]==2048)) {
        if($sseg2[6]>$sseg[6]) {
          print "$record[0]\n$record[1]\n";
        }
      }
      else {
        if($sseg2[6]<$sseg[6]) {
          print "$record[0]\n$record[1]\n";
        }
      }
    }
    else {
      my $rulecon = &median(@conloc);
      my $ruletag = $hash{$rulecon."aa"};
      foreach my $jilu (@record) {
        my @seg_4 = split /\t/,$jilu;
        $tag_distance = abs($seg_4[1]-$ruletag);
        $con_distance = abs($seg_4[6]-$rulecon);
        if(($con_distance >= $tag_distance*0.75) && ($con_distance <= $tag_distance*1.25)) {
           push @reselect,$jilu;
        }
      }
      my $renum = @reselect;
      if($renum==2) {
        my @reflag1 = split /\t/,$reselect[0];
        my @reflag2 = split /\t/,$reselect[1];
        if(($reflag1[4] == 0) || ($reflag1[4] == 2048)) {
          if($reflag2[6] > $reflag1[6]) {
            print "$reselect[0]\n$reselect[1]\n";
          }
        }
        else {
          if($reflag2[6]<$reflag1[6]) {
            print "$reselect[0]\n$reselect[1]\n";
          }
        }
      }
      elsif($renum>2) {
        foreach my $rr (@reselect) {
          print "$rr\n";
        }
      }
      else {
      }
    }
undef @reselect;
undef @record;
undef @conloc;
undef %hash;
push (@record,$_);
push (@conloc,$seg[6]);
$hash{$seg[6]."aa"}=$seg[1];
}
$tmp = $seg[0];
$aa = $seg[5];
}
    my $count = @record;
    if($count<2) {
    }
    elsif($count==2) {
      @sseg = split /\t/,$record[0];
      @sseg2 = split /\t/,$record[1];
      if(($sseg[4]==0) || ($sseg[4]==2048)) {
        if($sseg2[6]>$sseg[6]) {
          print "$record[0]\n$record[1]\n";
        }
      }
      else {
        if($sseg2[6]<$sseg[6]) {
          print "$record[0]\n$record[1]\n";
        }
      }
    }
    else {
      my $rulecon = &median(@conloc);
      my $ruletag = $hash{$rulecon."aa"};
      foreach my $jilu (@record) {
        my @seg_4 = split /\t/,$jilu;
        $tag_distance = abs($seg_4[1]-$ruletag);
        $con_distance = abs($seg_4[6]-$rulecon);
        if(($con_distance>=$tag_distance*0.75) && ($con_distance<=$tag_distance*1.25)) {
          push @reselect,$jilu;
        }
       }
      my $renum = @reselect;
      if($renum==2) {
        my @reflag1 = split /\t/,$reselect[0];
        my @reflag2 = split /\t/,$reselect[1];
        if(($reflag1[4] == 0) || ($reflag1[4] == 2048)) {
          if($reflag2[6] > $reflag1[6]) {  
            print "$reselect[0]\n$reselect[1]\n";            
          }
        }
        else {
          if($reflag2[6]<$reflag1[6]) {    
            print "$reselect[0]\n$reselect[1]\n";
          }    
        }
      } 
      elsif($renum>2) {
        foreach my $rr (@reselect) { 
          print "$rr\n";
        } 
      }
      else {
      }     
     }
sub median {
my $median;
my @list = sort{$a<=>$b} @_;
my $count = @list;
if($count==0) {
$median=0;
}
else {
if (($count%2)==1) {
my $a=$list[int(($count-1)/2)];
$median = $a;
}
else{
my $b=$list[int($count/2)];
$median = $b;
}
}
$median;
}
