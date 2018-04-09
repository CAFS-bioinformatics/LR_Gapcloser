#! /use/bin/perl -w
use strict;
if(@ARGV != 5) {
  print "Usage:perl $0 complete-candidate close1 output-directory output-prefix range\n";
  die;
}
my (@array,@uniq_array,%hash,%num,@backfill);
my $range=$ARGV[4];
open FILE,$ARGV[0] || die $!;
while(<FILE>) {
  chomp;
  push @array,$_;
}
my %saw;
@saw{ @array } = ( );
@uniq_array = sort keys %saw;
undef %saw;
undef @array;
foreach my $line (@uniq_array) {
  my @seg = split /\t/,$line;
  my @flag = split /:/,$seg[1];
  $num{$seg[0]."-".$flag[0]."-".$seg[5]}++;
  $hash{$seg[0]."-".$flag[0]."-".$seg[5]} = "$seg[0]\t$flag[0]\t$seg[2]\t$seg[3]\t$seg[4]\t$seg[5]\t$seg[6]\t$seg[7]";
}
foreach my $key (keys %hash) {
  if($num{$key}==1) {
    push @backfill,$hash{$key};
  }
}
undef %hash;
undef %num;
close FILE;
open FILE2,$ARGV[1] || die $!;
foreach my $aa (@backfill) {
  my @seg = split /\t/,$aa;
  $hash{$seg[0]."-".$seg[1]."-".$seg[5]}="$seg[1]\t$seg[2]\t$seg[3]\t$seg[4]\t$seg[5]\t$seg[6]\t$seg[7]";
}
open OUT2,">$ARGV[2]/$ARGV[3]_cclose1.out";
open OUT1,">$ARGV[2]/$ARGV[3]_ccomplete.out";
while(<FILE2>) {
  chomp;
  my @seg2 = split /\t/,$_;
  if($seg2[13] eq "NULL") {
    if(exists $hash{"R-".$seg2[3]."-".$seg2[7]}) {
      my $aa = $hash{"R-".$seg2[3]."-".$seg2[7]};

      my @ab = split /\t/,$aa;
my ($LR,$contig,$difference);
  if($seg2[6]==0) {
    $LR=abs($seg2[5]-$ab[1]);
  }
  else {
    $LR=abs($seg2[4]-$ab[2]);
  }
  $contig=abs($seg2[9]-$ab[5]);
  $difference=abs($LR-$contig);
  my $tolerance=$range*$contig;
  if($difference<=$tolerance) {
      if($seg2[12] >= $ab[5]) {
        my ($lrsmall,$lrlarge,$consmall,$conlarge);
        if($ab[3]==0) {
          $lrsmall=$ab[1]+($seg2[12]-$ab[5]+1);
          $lrlarge=$ab[2];
          $consmall=$ab[5]+($seg2[12]-$ab[5]+1);
          $conlarge=$ab[6];
        }
        else {
          $lrsmall=$ab[1];
          $lrlarge=$ab[2]-($seg2[12]-$ab[5]+1);
          $consmall=$ab[5]+($seg2[12]-$ab[5]+1);
          $conlarge=$ab[6];
        }
        print OUT1 "$seg2[0]\t$seg2[1]\t$seg2[2]\t$seg2[3]\t$seg2[4]\t$seg2[5]\t$seg2[6]\t$seg2[7]\t$seg2[8]\t$seg2[9]\t$seg2[10]\t$seg2[11]\t$seg2[12]\t$ab[0]\t$lrsmall\t$lrlarge\t$ab[3]\t$ab[4]\t$consmall\t$conlarge\t$seg2[20]\t$seg2[21]\n";
      }
      else {
        print OUT1 "$seg2[0]\t$seg2[1]\t$seg2[2]\t$seg2[3]\t$seg2[4]\t$seg2[5]\t$seg2[6]\t$seg2[7]\t$seg2[8]\t$seg2[9]\t$seg2[10]\t$seg2[11]\t$seg2[12]\t$aa\t$seg2[20]\t$seg2[21]\n";
      }
}
else {
  print OUT2 "$_\n";
}
    }
    else {
      print OUT2 "$_\n";
    }
  }
  else {
    if(exists $hash{"F-".$seg2[13]."-".$seg2[17]}) {
      my $bb=$hash{"F-".$seg2[13]."-".$seg2[17]};
      my @ba = split /\t/,$bb;
my ($LR,$contig,$difference);
if($seg2[16]==0) {
    $LR=abs($ba[2]-$seg2[14]);
  }
  else {
     $LR=abs($ba[1]-$seg2[15]);
  }
  $contig=abs($ba[6]-$seg2[18]);
  $difference=abs($LR-$contig);
  my $tolerance=$range*$contig;
  if($difference<=$tolerance) {
      if($seg2[2] <= $ba[6]) {
        my ($lrsmall,$lrlarge,$consmall,$conlarge);
        if($ba[3]==0) {
          $lrsmall=$ba[1];
          $lrlarge=$ba[2]-($ba[6]-$seg2[2]+1);
          $consmall=$ba[5];
          $conlarge=$ba[6]-($ba[6]-$seg2[2]+1);
        }
        else {
          $lrsmall=$ba[1]+($ba[6]-$seg2[2]+1);
          $lrlarge=$ba[2];
          $consmall=$ba[5];
          $conlarge=$ba[6]-($ba[6]-$seg2[2]+1);
        }
        print OUT1 "$seg2[0]\t$seg2[1]\t$seg2[2]\t$ba[0]\t$lrsmall\t$lrlarge\t$ba[3]\t$ba[4]\t$consmall\t$conlarge\t$seg2[10]\t$seg2[11]\t$seg2[12]\t$seg2[13]\t$seg2[14]\t$seg2[15]\t$seg2[16]\t$seg2[17]\t$seg2[18]\t$seg2[19]\t$seg2[20]\t$seg2[21]\n";
      }
      else {
        print OUT1 "$seg2[0]\t$seg2[1]\t$seg2[2]\t$bb\t$seg2[10]\t$seg2[11]\t$seg2[12]\t$seg2[13]\t$seg2[14]\t$seg2[15]\t$seg2[16]\t$seg2[17]\t$seg2[18]\t$seg2[19]\t$seg2[20]\t$seg2[21]\n";
      }
}
else {
  print OUT2 "$_\n";
}
    }
    else {
      print OUT2 "$_\n";
    }
  }
}
