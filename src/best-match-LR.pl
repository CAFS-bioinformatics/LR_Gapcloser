#!/usr/bin/perl -w 
use strict;
if( @ARGV != 1 ) {
    print "Usage: $0 0.8.LR.tag-minialign.coverage  \n";
    exit 0;
}
my $fh1=shift @ARGV;
open FH1,"<$fh1";
my $location;
my $count;
while (<FH1>)
{
  chomp($_);
  my @rec=split(/\s+/,$_);
  my @info=split(/\:/,$rec[0]);
  if (!exists($location->{$rec[0]}{$rec[4]}))
  {
   $location->{$rec[0]}{$rec[4]}=$_;
  }
  else
  {
   $location->{$rec[0]}{$rec[4]}.="\n".$_;
  }
  if (!exists($count->{$info[0]}{$rec[4]}))
  { 
    $count->{$info[0]}{$rec[4]}=1;
  }
  else
  {
    $count->{$info[0]}{$rec[4]}+=1;  
  } 
}
close FH1;
my $max;
foreach my $key (keys %$count)
{
  my @contig=keys (%{$count->{$key}});
  if (@contig == 1)
  {
   $max->{$key}=$contig[0];
  }
  else
  {
    my $temp_contig=$contig[0];
    my $same=0;
    for (my $i=1;$i<=$#contig;$i++)
    { 
     if ($count->{$key}{$contig[$i]} > $count->{$key}{$temp_contig})
     {
       $temp_contig = $contig[$i];
       $same=0;
     } 
     elsif ($count->{$key}{$contig[$i]} == $count->{$key}{$temp_contig})  
     {
       $same=1;
     }  
    }
    if ($same == 0)
    {
       $max->{$key}=$temp_contig;
    }
  }
}
my $new_location;
foreach my $key (keys %$location)
{
  my @contig=keys (%{$location->{$key}});  
  my @info=split(/\:/,$key);
  for (my $i=0;$i<=$#contig;$i++)
  {
    if (exists($max->{$info[0]}) && $contig[$i] eq $max->{$info[0]} && $location->{$key}{$contig[$i]} !~/\n/)
    {
      $location->{$key}{$contig[$i]} =~s/\:/\t/g;
      $new_location->{$info[0]}{$info[1]}=$location->{$key}{$contig[$i]};
    }   
  }
}
foreach my $key (keys %$new_location)
{
   my @start=sort {$a<=>$b} keys (%{$new_location->{$key}});
   for (my $i=0;$i<=$#start;$i++)
   {
    my @temp=split(/\s+/,$new_location->{$key}{$start[$i]});
    print $temp[0].":".$temp[1]."\t".$temp[2]."\t".$temp[3]."\t".$temp[4]."\t".$temp[5]."\t".$temp[6]."\t".$temp[7]."\n";
   }
}
