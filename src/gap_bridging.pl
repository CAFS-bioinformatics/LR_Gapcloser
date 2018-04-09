#! /usr/bin/perl -w
use strict;
## AB015752.1(:5581-16756   32684-35526     55822-87790 ##
## LR6218  0       12      300     0       AB001523.1      33948   34242 ##
my (%gap,@record,%Fhash,%Rhash,%use_gap);
my $tmp=0;
my $ab=0;
open GAP,$ARGV[0] || die $!;
open FILE,$ARGV[1] || die $!;
while(<GAP>){
chomp;
my @flag = split /\(:/,$_;
$gap{$flag[0]}=$flag[1];
}
while(<FILE>) {
  chomp;
  my @seg = split /\t/,$_;
  if (($seg[0] eq $tmp) && ($seg[5] eq $ab)) {
     push (@record,$_);
  }
  else { #else 21
    my $count = @record;
   if(($count>0) && (exists $gap{$ab})) {  #if 23
    my @ggap = split /\t/,$gap{$ab};
    foreach my $line (@record) {  #foreach 26
      my @seg2 = split /\t/,$line;
      my $right_gap = &right_half_search(\@ggap,$seg2[7]);
      my $left_gap = &left_half_search(\@ggap,$seg2[6]);
      if(($right_gap eq "NULL") && ($left_gap ne "NULL")) {
        my @Rid_0 = split /-/,$left_gap;
        $use_gap{$left_gap}=1;
        if( !exists $Rhash{$left_gap}) {
          $Rhash{$left_gap} = "R\t$ab\t$Rid_0[1]\t$seg2[0]\t$seg2[2]\t$seg2[3]\t$seg2[4]\t$seg2[5]\t$seg2[6]\t$seg2[7]";
        }
        else {
          my @hash_record = split /\t/,$Rhash{$left_gap};
          if($seg2[6]<$hash_record[8]) {
            $Rhash{$left_gap} = "R\t$ab\t$Rid_0[1]\t$seg2[0]\t$seg2[2]\t$seg2[3]\t$seg2[4]\t$seg2[5]\t$seg2[6]\t$seg2[7]"; 
          }
        }
        next;
      }
      if(($right_gap ne "NULL") && ($left_gap eq "NULL")) {
        my @Fid_0 = split /-/,$right_gap;
        $use_gap{$right_gap}=1;
        if( !exists $Fhash{$right_gap}) {
          $Fhash{$right_gap} = "F\t$ab\t$Fid_0[0]\t$seg2[0]\t$seg2[2]\t$seg2[3]\t$seg2[4]\t$seg2[5]\t$seg2[6]\t$seg2[7]";
        }
        else {
          my @hash_record = split /\t/,$Fhash{$right_gap};
          if($seg2[7]>$hash_record[9]) {
            $Fhash{$right_gap} = "F\t$ab\t$Fid_0[0]\t$seg2[0]\t$seg2[2]\t$seg2[3]\t$seg2[4]\t$seg2[5]\t$seg2[6]\t$seg2[7]";
          }
        }
        next;
      }
      if(($right_gap ne "NULL") && ($left_gap ne "NULL")) {
        my @Fid = split /-/,$right_gap;
        my @Rid = split /-/,$left_gap;
        $use_gap{$right_gap}=1;
        $use_gap{$left_gap}=1;
        if( !exists $Fhash{$right_gap}) {
          $Fhash{$right_gap} = "F\t$ab\t$Fid[0]\t$seg2[0]\t$seg2[2]\t$seg2[3]\t$seg2[4]\t$seg2[5]\t$seg2[6]\t$seg2[7]";
        }
        else {
          my @hash_record = split /\t/,$Fhash{$right_gap};
          if($seg2[7]>$hash_record[9]) {
            $Fhash{$right_gap} = "F\t$ab\t$Fid[0]\t$seg2[0]\t$seg2[2]\t$seg2[3]\t$seg2[4]\t$seg2[5]\t$seg2[6]\t$seg2[7]"; 
          }
        }
        if( !exists $Rhash{$left_gap}) {
          $Rhash{$left_gap} = "R\t$ab\t$Rid[1]\t$seg2[0]\t$seg2[2]\t$seg2[3]\t$seg2[4]\t$seg2[5]\t$seg2[6]\t$seg2[7]";
        }
        else {
          my @hash_record = split /\t/,$Rhash{$left_gap};
          if($seg2[6]<$hash_record[8]) {
            $Rhash{$left_gap} = "R\t$ab\t$Rid[1]\t$seg2[0]\t$seg2[2]\t$seg2[3]\t$seg2[4]\t$seg2[5]\t$seg2[6]\t$seg2[7]";
          }
        }
      }
    } #foreach 26
    foreach my $use (sort keys %use_gap) {
      my @guse = split /-/,$use;
      if((exists $Fhash{$use}) && (exists $Rhash{$use})) {
        print "$Fhash{$use}\t$Rhash{$use}\t$count\n";
      }
      elsif ((exists $Fhash{$use}) && (!exists $Rhash{$use})) {
        print "$Fhash{$use}\tR\t$ab\t$guse[1]\tNULL\tNULL\tNULL\tNULL\tNULL\tNULL\tNULL\t$count\n";
      }
      elsif ((!exists $Fhash{$use}) && (exists $Rhash{$use})) {
        print "F\t$ab\t$guse[0]\tNULL\tNULL\tNULL\tNULL\tNULL\tNULL\tNULL\t$Rhash{$use}\t$count\n";
      }
      else {
      }
    }
    }#if 23
    undef @record;
    undef %Rhash;
    undef %Fhash;
    undef %use_gap;
  push (@record,$_);
  } #else 21
  $tmp = $seg[0];
  $ab = $seg[5];
}
my $count = @record;
    if(($count>0) && (exists $gap{$ab})) {  #if 23
    my @ggap = split /\t/,$gap{$ab};
    foreach my $line (@record) {  #foreach 26
      my @seg2 = split /\t/,$line;
      my $right_gap = &right_half_search(\@ggap,$seg2[7]);
      my $left_gap = &left_half_search(\@ggap,$seg2[6]);
      if(($right_gap eq "NULL") && ($left_gap ne "NULL")){
        my @Rid_0 = split /-/,$left_gap;
        $use_gap{$left_gap}=1;
        if( !exists $Rhash{$left_gap}) {
          $Rhash{$left_gap} = "R\t$ab\t$Rid_0[1]\t$seg2[0]\t$seg2[2]\t$seg2[3]\t$seg2[4]\t$seg2[5]\t$seg2[6]\t$seg2[7]";
        }
        else {
          my @hash_record = split /\t/,$Rhash{$left_gap};
          if($seg2[6]<$hash_record[8]) {
            $Rhash{$left_gap} = "R\t$ab\t$Rid_0[1]\t$seg2[0]\t$seg2[2]\t$seg2[3]\t$seg2[4]\t$seg2[5]\t$seg2[6]\t$seg2[7]";
          }
        }
        next;
      }
      if(($right_gap ne "NULL") && ($left_gap eq "NULL")) {
        my @Fid_0 = split /-/,$right_gap;
        $use_gap{$right_gap}=1;
        if( !exists $Fhash{$right_gap}) {
          $Fhash{$right_gap} = "F\t$ab\t$Fid_0[0]\t$seg2[0]\t$seg2[2]\t$seg2[3]\t$seg2[4]\t$seg2[5]\t$seg2[6]\t$seg2[7]";
        }
        else {
          my @hash_record = split /\t/,$Fhash{$right_gap};
          if($seg2[7]>$hash_record[9]) {
            $Fhash{$right_gap} = "F\t$ab\t$Fid_0[0]\t$seg2[0]\t$seg2[2]\t$seg2[3]\t$seg2[4]\t$seg2[5]\t$seg2[6]\t$seg2[7]";
          }
        }
        next;
      }
      if(($right_gap ne "NULL") && ($left_gap ne "NULL")) {
        my @Fid = split /-/,$right_gap;
        my @Rid = split /-/,$left_gap;
        $use_gap{$right_gap}=1;
        $use_gap{$left_gap}=1;
        if( !exists $Fhash{$right_gap}) {
          $Fhash{$right_gap} = "F\t$ab\t$Fid[0]\t$seg2[0]\t$seg2[2]\t$seg2[3]\t$seg2[4]\t$seg2[5]\t$seg2[6]\t$seg2[7]";
        }
        else {
          my @hash_record = split /\t/,$Fhash{$right_gap};
          if($seg2[7]>$hash_record[9]) {
            $Fhash{$right_gap} = "F\t$ab\t$Fid[0]\t$seg2[0]\t$seg2[2]\t$seg2[3]\t$seg2[4]\t$seg2[5]\t$seg2[6]\t$seg2[7]";
          }
        }
        if( !exists $Rhash{$left_gap}) {
          $Rhash{$left_gap} = "R\t$ab\t$Rid[1]\t$seg2[0]\t$seg2[2]\t$seg2[3]\t$seg2[4]\t$seg2[5]\t$seg2[6]\t$seg2[7]";
        }
        else {
          my @hash_record = split /\t/,$Rhash{$left_gap};
          if($seg2[6]<$hash_record[8]) {
            $Rhash{$left_gap} = "R\t$ab\t$Rid[1]\t$seg2[0]\t$seg2[2]\t$seg2[3]\t$seg2[4]\t$seg2[5]\t$seg2[6]\t$seg2[7]";
          }
        }
      }
    } #foreach 26
    foreach my $use (sort keys %use_gap) {
      my @guse = split /-/,$use;
      if((exists $Fhash{$use}) && (exists $Rhash{$use})) {
        print "$Fhash{$use}\t$Rhash{$use}\t$count\n";
      }
      elsif ((exists $Fhash{$use}) && (!exists $Rhash{$use})) {
        print "$Fhash{$use}\tR\t$ab\t$guse[1]\tNULL\tNULL\tNULL\tNULL\tNULL\tNULL\tNULL\t$count\n";
      }
      elsif ((!exists $Fhash{$use}) && (exists $Rhash{$use})) {
        print "F\t$ab\t$guse[0]\tNULL\tNULL\tNULL\tNULL\tNULL\tNULL\tNULL\t$Rhash{$use}\t$count\n";
      }
      else {
      }
    }
    }
    undef @record;
    undef %Rhash;
    undef %Fhash;
    undef %use_gap;
sub right_half_search {
  my ($gap,$tag)=@_;
  my @gap = @$gap;
  my $low = 0;
  my $high = $#gap;
  my ($mid,@mid_gap);
  my @gap_low = split /-/,$gap[$low];
  my @gap_high = split /-/,$gap[$high];
  if($tag > $gap_high[0]) {
  return "NULL";
  exit;
}
else {  
while ($low<=$high) {
    $mid = int (($low+$high)/2);
    @mid_gap = split /-/,$gap[$mid]; 
        if($tag>$mid_gap[0]) {
          $low = $mid+1;
        }
        elsif($tag==$mid_gap[0]) {
          return $gap[$mid];
          last;
        }
        else {
          $high = $mid-1;
        }
  }
  if ($mid_gap[0] < $tag) {
    my @mid_gap_add = split /-/,$gap[$mid+1];
    if(($mid+1 <= $#gap) and ($mid_gap_add[0] > $tag)) {
      $mid++;
    }
    return $gap[$mid]; 
  }
  else {
    return $gap[$mid];
  }
}
}
sub left_half_search {
  my ($gap,$tag)=@_;
  my @gap = @$gap;
  my $low = 0;
  my $high = $#gap;
  my ($mid,@mid_gap);
  my @gap_low = split /-/,$gap[$low];
  my @gap_high = split /-/,$gap[$high];
if($tag < $gap_low[1]) {
  return "NULL";
  exit;
}
else {
while ($low<=$high) {
    $mid = int (($low+$high)/2);
    @mid_gap = split /-/,$gap[$mid];
        if($tag>$mid_gap[1]) {
          $low = $mid+1;
        }
        elsif($tag==$mid_gap[1]) {
          return $gap[$mid];
          last;
        }
        else {
          $high = $mid-1;
        }
  }
  if ($mid_gap[1] < $tag) {
      return $gap[$mid];
  }
  else {
    my @mid_gap_reduce = split /-/,$gap[$mid-1];
    if($mid_gap_reduce[1] < $tag) {
      $mid--;
    }
  return $gap[$mid];
}
}
}
