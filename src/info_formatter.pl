#! /usr/bin/perl -w
use strict;
if(@ARGV != 4) {
print "Usage:perl $0 part2_file close1_file open_file close2_file\n";
die;
}
open FILE1,$ARGV[0] || die $!;  ##part2_file
while(<FILE1>) {
  chomp;
  my @seg = split /\t/,$_;
  if($seg[6]==0) {
    print "$seg[1](:$seg[2]-$seg[12]\t$seg[3](:$seg[5]-$seg[14](:+\t$seg[1](:$seg[9]-$seg[18]\n";
  }
  else {
    print "$seg[1](:$seg[2]-$seg[12]\t$seg[3](:$seg[4]-$seg[15](:-\t$seg[1](:$seg[9]-$seg[18]\n";
  }
}
open FILE2,$ARGV[1] || die $!;  ##close1_file
while(<FILE2>) {
my ($start,$stop);
  chomp;
  my @seg = split /\t/,$_;
  if($seg[13] eq 'NULL') {
    if($seg[6]==0) {
      $stop = $seg[5]+$seg[12]-$seg[9];
      print "$seg[1](:$seg[2]-$seg[12]\t$seg[3](:$seg[5]-$stop(:+\t$seg[1](:$seg[9]-$seg[12]\n";
    }
    else {
      $stop = $seg[4]-($seg[12]-$seg[9]);
      print "$seg[1](:$seg[2]-$seg[12]\t$seg[3](:$seg[4]-$stop(:-\t$seg[1](:$seg[9]-$seg[12]\n";
    }
  }
  else {
    if($seg[16]==0) {
      $start = $seg[14]-($seg[18]-$seg[2]);
      print "$seg[1](:$seg[2]-$seg[12]\t$seg[13](:$start-$seg[14](:+\t$seg[11](:$seg[2]-$seg[18]\n";
    }
    else {
      $start = $seg[15]+$seg[18]-$seg[2];
      print "$seg[1](:$seg[2]-$seg[12]\t$seg[13](:$start-$seg[15](:-\t$seg[11](:$seg[2]-$seg[18]\n";
    }
  }
}
open FILE3,$ARGV[2] || die $!;  ##open_file
while(<FILE3>) {
my ($start,$stop,$ref_start,$ref_stop);
  chomp;
  my @seg = split /\t/,$_;
  if($seg[13] eq 'NULL') {
    if($seg[6]==0) {
      $start = $seg[5];
      $stop = $seg[21];
      $ref_start = $seg[9];
      $ref_stop = $seg[21]-$seg[5]+$seg[9];
      print "$seg[1](:$seg[2]-$seg[12]\t$seg[3](:$start-$stop(:+\t$seg[1](:$ref_start-$ref_stop\n";
     }
    else {
      $start = $seg[4];
      $stop = 1;
      $ref_start = $seg[9];
      $ref_stop = $seg[4]-1+$seg[9];
      print "$seg[1](:$seg[2]-$seg[12]\t$seg[3](:$start-$stop(:-\t$seg[1](:$ref_start-$ref_stop\n";
      }
  }
  else {
    if($seg[16]==16) {
      $start=$seg[21];
      $stop = $seg[15];
      $ref_start = $seg[18]-($seg[21]-$seg[15]);
      $ref_stop = $seg[18];
      print "$seg[1](:$seg[2]-$seg[12]\t$seg[13](:$start-$stop(:-\t$seg[1](:$ref_start-$ref_stop\n";
    }
    else {
      $start = 1;
      $stop = $seg[14];
      $ref_start = $seg[18]-($seg[14]-1);
      $ref_stop = $seg[18];
      print "$seg[1](:$seg[2]-$seg[12]\t$seg[13](:$start-$stop(:+\t$seg[1](:$ref_start-$ref_stop\n";
      }
    }
}
my %hash;  ##close2
open FILE4,$ARGV[3] || die $!;
while(<FILE4>) {
  chomp;
  my @seg = split /\t/,$_;
  if(!exists $hash{$seg[1]."-".$seg[2]}) {
    $hash{$seg[1]."-".$seg[2]} = $_;
  }
  else {
    $hash{$seg[1]."-".$seg[2]} .= "\n$_";
  }
}
my($Fline,$Rline,$Rstart,$Rstop,$ref_inter,$Fstart,$Fstop,$Fref_stop,$line);
foreach my $key (keys %hash) {
  my @box = split /\n/,$hash{$key};
  my @record1 = split /\t/,$box[0];
  my @record2 = split /\t/,$box[1];
  if($record1[13] eq 'NULL') {
    $Fline = $box[0];
    $Rline = $box[1];
  }
  else {
    $Fline = $box[1];
    $Rline = $box[0];
  }
  my @Frecord = split /\t/,$Fline;
  my @Rrecord = split /\t/,$Rline;
  if($Frecord[6]==0) {
    if($Rrecord[16]==0) {
      $Rstart=1;
      $Rstop=$Rrecord[14];
      $ref_inter=$Rrecord[18]-($Rrecord[14]-1);
      $Fstart=$Frecord[5];
      $Fstop=$Frecord[5]+($ref_inter-$Frecord[9]-1);
      $Fref_stop=$ref_inter-1;
      $line="$Frecord[1](:$Frecord[2]-$Frecord[12]\t$Frecord[3](:$Fstart-$Fstop(:+\t$Frecord[1](:$Frecord[9]-$Fref_stop\n$Frecord[1](:$Frecord[2]-$Frecord[12]\t$Rrecord[13](:$Rstart-$Rstop(:+\t$Rrecord[1](:$ref_inter-$Rrecord[18]";
    }
    else {
      $Rstart=$Rrecord[21];
      $Rstop=$Rrecord[15];
      $ref_inter=$Rrecord[18]-($Rrecord[21]-$Rrecord[15]);
      $Fstart=$Frecord[5];
      $Fstop=$Frecord[5]+($ref_inter-$Frecord[9]-1);
      $Fref_stop=$ref_inter-1;
      $line="$Frecord[1](:$Frecord[2]-$Frecord[12]\t$Frecord[3](:$Fstart-$Fstop(:+\t$Frecord[1](:$Frecord[9]-$Fref_stop\n$Frecord[1](:$Frecord[2]-$Frecord[12]\t$Rrecord[13](:$Rstart-$Rstop(:-\t$Rrecord[1](:$ref_inter-$Rrecord[18]";
    }
  }
  else {
    if($Rrecord[16]==0) {
      $Rstart=1;
      $Rstop=$Rrecord[14];
      $ref_inter=$Rrecord[18]-($Rrecord[14]-1);
      $Fstart=$Frecord[4];
      $Fstop=$Frecord[4]-($ref_inter-$Frecord[9]-1);
      $Fref_stop=$ref_inter-1;
      $line="$Frecord[1](:$Frecord[2]-$Frecord[12]\t$Frecord[3](:$Fstart-$Fstop(:-\t$Frecord[1](:$Frecord[9]-$Fref_stop\n$Frecord[1](:$Frecord[2]-$Frecord[12]\t$Rrecord[13](:$Rstart-$Rstop(:+\t$Rrecord[1](:$ref_inter-$Rrecord[18]";
    }
    else {
      $Rstart=$Rrecord[21];
      $Rstop=$Rrecord[15];
      $ref_inter=$Rrecord[18]-($Rrecord[21]-$Rrecord[15]);
      $Fstart=$Frecord[4];
      $Fstop=$Frecord[4]-($ref_inter-$Frecord[9]-1);
      $Fref_stop=$ref_inter-1;
      $line="$Frecord[1](:$Frecord[2]-$Frecord[12]\t$Frecord[3](:$Fstart-$Fstop(:-\t$Frecord[1](:$Frecord[9]-$Fref_stop\n$Frecord[1](:$Frecord[2]-$Frecord[12]\t$Rrecord[13](:$Rstart-$Rstop(:-\t$Rrecord[1](:$ref_inter-$Rrecord[18]";
    }
  }
  print "$line\n";
}
