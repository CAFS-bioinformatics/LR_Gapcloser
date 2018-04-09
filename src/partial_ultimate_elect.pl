#! /usr/bin/perl -w
use strict;
if(@ARGV != 2) {
  die "Usage:perl $0 file tagnumber(keep longest extend)\n";
} 
my (%hashF,%hashR,@file);
my $tagn=$ARGV[1]-1;
open FILE,$ARGV[0] || die $!;
while(<FILE>) {
  chomp;
  my @seg = split /\t/,$_;
  if($seg[13] eq 'NULL') {
    if(!exists $hashF{$seg[1]."-".$seg[2]}) {
      $hashF{$seg[1]."-".$seg[2]} = $_;
    }
    else {
      $hashF{$seg[1]."-".$seg[2]} .= "\n$_";
    }
  }
  else {
    if(!exists $hashR{$seg[11]."-".$seg[12]}) {
      $hashR{$seg[11]."-".$seg[12]} = $_;
    }
    else {
      $hashR{$seg[11]."-".$seg[12]} .= "\n$_";
    }
  }
}
foreach my $key (keys %hashF) {
  my @seg2 = split /\n/,$hashF{$key};
  my $i = 0;
  my $bb=0;
  my $tag=0;
  my ($aa,$best);
  for(0..$#seg2) {
    my @flag1 = split /\t/,$seg2[$i];
if($flag1[20]>$tagn) {
    if($flag1[6] == 0) {
        $aa=$flag1[8]+$flag1[21]-$flag1[5];
    }
      else {
        $aa=$flag1[9]+$flag1[4]-1;
      }
    if($aa > $bb) {
      $best = $seg2[$i];
      $bb=$aa;
      $tag=$flag1[20];
    }
    elsif($aa == $bb) {
      if($flag1[20]>$tag) {
        $best = $seg2[$i];
        $bb=$aa;
        $tag=$flag1[20];
      }
      else {
      }
    }
    else {
    }
}
    $i++;
  }
  push @file,$best;
}
foreach my $key (keys %hashR) {
  my @seg3 = split /\n/,$hashR{$key};
  my $i = 0;
  my $bb=0;
  my $tag=0;
  my ($length,$best);
  for(0..$#seg3) {
  my @flag2 = split /\t/,$seg3[$i];
if($flag2[20]>$tagn) {
  if($flag2[16] == 0) {
    $length=$flag2[12]-($flag2[18]-$flag2[14]+1);
  }
  else {
    $length=$flag2[12]-($flag2[18]-$flag2[21]+$flag2[15]); 
 }
  if($length>$bb) {
    $best = $seg3[$i];
    $bb=$length;
    $tag=$flag2[20];
  }
  elsif($length==$bb) {
    if($flag2[20]>$tag) {
      $best = $seg3[$i];
      $bb=$length;
      $tag=$flag2[20];
    }
    else {
    }
  }
  else {
  }
}
  $i++;
  }
  push @file,$best;
  }
## record uniq select
my %hash;
foreach my $a (@file) {
if(defined $a) {  
  my @seg = split /\t/,$a;
  if(!exists $hash{$seg[1]."-".$seg[2]}){
    $hash{$seg[1]."-".$seg[2]} = $a;
  }
  else {
    $hash{$seg[1]."-".$seg[2]} .= "\n$a";
  }
}
}
undef @file;
foreach my $key (keys %hash) {
  my @line = split /\n/,$hash{$key};
  my($Fline,$Rline,$Fstop,$Rstart,$Ftag,$Rtag);
  if($#line==0) {
    print "$line[0]\n";
  }
  else {
    my @seg2 = split /\t/,$line[0];
    my @seg3 = split /\t/,$line[1];
    if($seg2[13] eq 'NULL') {
      $Fline=$line[0];
      $Rline=$line[1];
      $Ftag=$seg2[20];
      $Rtag=$seg3[20];
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
      $Ftag=$seg3[20];
      $Rtag=$seg2[20];
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
    if($Fstop>$seg2[12]) {
      if($Rstart>$seg2[2]) {
        print "$Fline\n";
      }
      else {
        if($Rtag>$Ftag) {
          print "$Rline\n";
        }
        else {
          print "$Fline\n";
        }
      }
    }
    else {
      if($Rstart<$seg2[2]) {
        print "$Rline\n";
      }
      else {
        print "$Fline\n$Rline\n";
      }
    }
  }
}
