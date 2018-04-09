#!/usr/bin/perl
if (@ARGV!=4)
{
  print "Usage: perl $0 inputfile.fa number dir name\n";
  exit 0;
}
my ($file,$number,$dir,$name)=@ARGV;
open FILE, $file or die "can not open $file:$!";
my $i=0;
while(<FILE>)
{
  if($_ =~/>/)
  {
    $i=$i+1;
    my $n= $i % $number;
    if ($i<=$number)
    {
      open OUTPUT, ">",$dir.'/'.$name.$n;
    }
    else
    {
      close OUTPUT;
      open OUTPUT, ">>",$dir.'/'.$name.$n;
    }
    print OUTPUT $_;
  }
  else
  {
    print OUTPUT $_;
  }
}
close FILE;  
