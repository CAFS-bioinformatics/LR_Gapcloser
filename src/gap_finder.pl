#! /usr/bin/perl -w
use strict;
unless(@ARGV==1){
die"Usage:perl $0 <input.fa>\n";
}
my($infile)=@ARGV;
open IN,$infile||die"error:can't open infile:$infile";
$/=">";<IN>;
my $start=0;
my $skip=0;
my $step;
my $len=1;
my $stop;
my $end;
my $total_len=0;
my $number=0;
my $num_1bp=0;
my $line;
my ($i,%hash);
while(my $seq=<IN>)
{
  if(index($seq,"N")!=-1)
  {#if-1
    my $id=$1 if($seq=~/^(\S+)/);
    chomp $seq;
    $seq=~s/^.+?\n//;
    $seq=~s/\s//g;
      if(index($seq,"N")==-1)
      {
        next;
      }
      $step=0;
      $stop=1;
      $start=index($seq,"N",$step)+1;
      $step=$start-1;
      $skip=$step;
      while($stop)
      {#while -2
        $skip=index($seq,"N",$step+1);
        if($skip==($step+1))
        {#if skip (49)
          $len++;
          $step++;
          next;
        }else{
        if($skip!=-1)
        {#if skip != -1 (55)
          if($len!=1){
            $end=$start+$len-1;
          }
          else{
            $num_1bp++;
            $end=$start;
          }
          $total_len+=$len;
          $number++;
          if(!exists $hash{$id}) {
            $hash{$id} = "$id(:$start-$end";
          }
          else {
            $hash{$id} .= "\t$start-$end";
          }
          $step=$skip;
          $start=$skip+1;
          $len=1;
        }else{  
        if($len!=1){  
          $end=$start+$len-1;
        }
        else{
          $num_1bp++;
          $end=$start;
        }
        $total_len+=$len;
        $number++;
        if(!exists $hash{$id}) {
          $hash{$id} = "$id(:$start-$end";
        }
        else {
          $hash{$id} .= "\t$start-$end";
        }
        $stop=0;
        $len=1;
        }#if-else- (56)
        }#if-else- (49)
      }#while -2  
    }#if-1
}#while 
$/="\n";
close IN;
foreach my $key (sort keys %hash) {
  print "$hash{$key}\n";
}
