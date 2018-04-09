#! /usr/bin/perl -w
use strict;
if(!@ARGV) {
print "Usage:perl $0 id_file sequnce.fasta\n";
}
my %hash;
open ID,$ARGV[0] || die $!;
while(<ID>) {
  chomp;
  $hash{$_}=1;
}
open FILE,$ARGV[1] || die $!;
$/=">";
while(<FILE>) {
  chomp;
unless(/^\s*$/) {
my($head,$sequnce)=split("\n",$_,2);
my $name=$1 if($head=~/^(\S+)/);
$sequnce =~ s/\s+//g;
if(exists $hash{$name}) {
  print ">$name\n$sequnce\n";
}
}
}
