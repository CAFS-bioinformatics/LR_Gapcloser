#!/usr/bin/perl -w 
use strict;
if( @ARGV != 2 ) 
{
    print "Usage: $0  0.8_LR.tag.coverage  tag_alignment_filter.out \n";
    exit 0;
}
my $fh1=shift @ARGV;
my $fh2=shift @ARGV;
open FH2,"<$fh2";
open FH1,"<$fh1";
my $unique;
my $median;
my $info;
while (<FH2>)
{
  chomp($_);
  $_ =~ s# ##g;
  my @rec=split(/\t/,$_);
  my @info=split(/\:/,$rec[0]);  
  $unique->{$_}=1;
  $info->{$info[0]}{$info[1]}=$info[0]."\t".$info[1]."\t".$rec[1]."\t".$rec[2]."\t".$rec[3]."\t".$rec[4]."\t".$rec[5]."\t".$rec[6]."\n";
}
close FH2;
foreach my $LR (keys %$info)
{
  my @keys=sort {$a<=>$b} keys %{$info->{$LR}};
  my @temp;
  if (@keys %2 == 1)
  {
    @temp=split(/\t/,$info->{$LR}{$keys[$#keys/2]});
  }
  else
  {
    @temp=split(/\t/,$info->{$LR}{$keys[($#keys-1)/2]});
  }
  $median->{$LR}{'qstart'}=$temp[2];
  $median->{$LR}{'qend'}=$temp[3];
  $median->{$LR}{'ori'}=$temp[4];
  $median->{$LR}{'target'}=$temp[5];
  $median->{$LR}{'tstart'}=$temp[6];
  $median->{$LR}{'tend'}=$temp[7];
}
while (<FH1>)
{
  chomp($_);
  my @rec=split(/\s+/,$_);
  my @info=split(/\:/,$rec[0]);
  if (exists($unique->{$_}))
  {
    print $_."\n";
  }
  elsif (!exists($unique->{$_}) && exists($median->{$info[0]}) && $median->{$info[0]}{'ori'} eq $rec[3] && $median->{$info[0]}{'target'} eq $rec[4])
  {
    if ($rec[3] == 0 && $rec[5] != $median->{$info[0]}{'tstart'})
    {
      if (($rec[1] - $median->{$info[0]}{'qstart'})/($rec[5]-$median->{$info[0]}{'tstart'}) <= 1.2 && ($rec[1] - $median->{$info[0]}{'qstart'})/($rec[5]-$median->{$info[0]}{'tstart'}) >= 0.8)
      {
        print $_."\n";
      }
    }
    elsif ($rec[3] == 16 && $rec[5] != $median->{$info[0]}{'tstart'})
    {
      if (($median->{$info[0]}{'qstart'} - $rec[1])/($rec[5]-$median->{$info[0]}{'tstart'}) <= 1.2 && ($median->{$info[0]}{'qstart'} - $rec[1])/($rec[5]-$median->{$info[0]}{'tstart'}) >= 0.8)
      {
         print $_."\n";
      }
    }
  }
}
close FH1;
