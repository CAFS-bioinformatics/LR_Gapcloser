#! /usr/bin/perl -w
use strict;
if(@ARGV != 2) {
die "Usage:perl $0 mem_file output_prefix\n";
}
my(@seg,@seg_2,@seg_3,@seg_x,@seg_x2,@totl,@cover,$sum1,$match,$ratio,@totl2,@cover2,$sum2,$match2,$ratio2,@totl3,@cover3,$sum3,$match3,$ratio3,@ref1,@ref2,@ref12,@ref22,@ref13,@ref23,$read1,$read2,$read3,$ref_jian,$ref_jian2,$ref_jian3,$ref_jia,$ref_jia2,$ref_jia3,$ref_stop,$ref_stop2,$ref_stop3,@read_id,$read_start,$read_start2,$read_start3,$read_stop,$read_stop2,$read_stop3,@read1,@read2,@read3);
open FILE,$ARGV[0] || die $!;
open OUT,">$ARGV[1]";
while(<FILE>) {
  chomp;
  if(/^@/) {
  }
  else {
  @seg = split /\t/,$_;
  unless($seg[2] eq "*") {
    @totl = ($seg[5] =~ /(\d+)[SH]/g);
    @cover = ($seg[5] =~ /(\d+)M/g);
    @ref1 = ($seg[5] =~ /(\d+)I/g);
    @ref2 = ($seg[5] =~ /(\d+)[DP]/g);
    @read1 = ($seg[5] =~ /^(\d+)[HS]/);
    $read1 = &sum(@read1);
    my $SH = &sum(@totl);
    my $M = &sum(@cover);
    my $I = &sum(@ref1);
    $ref_jian = $SH+$I; 
    $ref_jia = &sum(@ref2);
    $sum1 = $SH+$I+$M;   
    $match = $M+$I;
    $ratio = $match/$sum1;
      $ref_stop = $sum1-$ref_jian+$ref_jia+$seg[3]-1;
      @read_id = split /:/,$seg[0];
      if(($seg[1] == 0) || ($seg[1] == 2048) ) {
        $read_start = $read_id[1]+$read1+1;
        $read_stop = $read_start+$match-1;
        print OUT "$seg[0]\t$read_start\t$read_stop\t0\t$seg[2]\t$seg[3]\t$ref_stop\t$seg[4]\t$seg[5]\t$match\t$sum1\t$ratio\n";
      }
      else {
        $read_stop = $read_id[1]+$sum1-$read1;
        $read_start = $read_stop-$match+1;
        print OUT "$seg[0]\t$read_start\t$read_stop\t16\t$seg[2]\t$seg[3]\t$ref_stop\t$seg[4]\t$seg[5]\t$match\t$sum1\t$ratio\n";
      }
    if(/XA:Z/) {
      if($seg[15] =~ /XA:Z/) {
        $seg[15] =~ s/XA:Z://;
        @seg_x = split /;/,$seg[15];
      }
      else {
        $seg[16] =~ s/XA:Z://;
        @seg_x = split /;/,$seg[16];
      }
      my $nn = @seg_x;
      for (my $ii=0;$ii<$nn;$ii++) {
        @seg_x2 = split /,/,$seg_x[$ii];
        @ref23 = ($seg_x2[2] =~ /(\d+)[DP]/g);
        @read3 = ($seg_x2[2] =~ /^(\d+)[HS]/);
        @totl3 = ($seg_x2[2] =~ /(\d+)[SH]/g);
        @cover3 = ($seg_x2[2] =~ /(\d+)M/g);
        @ref13 = ($seg_x2[2] =~ /(\d+)I/g);
        my $SH = &sum(@totl3);
        my $M = &sum(@cover3);
        my $I = &sum(@ref13);
        $read3 = &sum(@read3);
        $ref_jian3 = $SH+$I;
        $ref_jia3 = &sum(@ref23);
        $sum3 = $SH+$M+$I;
        $match3 = $M+$I;
        $ratio3 = $match3/$sum3;
          if($seg_x2[1] =~ /\+/) {
            $seg_x2[1] =~ s/\+//;
            $ref_stop3 = $sum3-$ref_jian3+$ref_jia3+$seg_x2[1]-1;
            $read_start3 = $read_id[1]+$read3+1;
            $read_stop3 = $read_start3+$match3-1;
            print OUT "$seg[0]\t$read_start3\t$read_stop3\t0\t$seg_x2[0]\t$seg_x2[1]\t$ref_stop3\t*\t$seg_x2[2]\t$match3\t$sum3\t$ratio3\n";
          }
          else {
            $seg_x2[1] =~ s/\-//;
            $ref_stop3 = $sum3-$ref_jian3+$ref_jia3+$seg_x2[1]-1;
            $read_stop3 = $read_id[1]+$sum3-$read3;
            $read_start3 = $read_stop3-$match3+1;
            print OUT "$seg[0]\t$read_start3\t$read_stop3\t16\t$seg_x2[0]\t$seg_x2[1]\t$ref_stop3\t*\t$seg_x2[2]\t$match3\t$sum3\t$ratio3\n";
          }
      }
    }
  } 
  }
}
sub sum {
  my (@num) = @_;
  my $total;
  if(@num==0) {
    $total=0;
  }
  else {
    foreach (0..$#num) {
      $total += $num[$_];
    }
  }
  $total;
}
