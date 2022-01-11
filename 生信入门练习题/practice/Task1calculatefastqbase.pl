#!usr/bin/perl -w
use strict;
use Data::Dumper;
use Getopt::Long;
#author:psf

my $file;
GetOptions(
    "help|?" => \&USAGE,
    "file:s" => \$file,
);
&USAGE unless($file);

## define global variable
my ($sum,$C_num,$G_num,$A_num,$T_num,$N_num,$total_sum);

## read file
if ($file =~ /\.gz$/){
    #open IN,"gunzip -c $file | " or die $!;
    open IN,"/usr/bin/gunzip -c $file | " or die $!;
}else{
    open IN,"< $file" or die $!;
}
while( <IN>){
    chomp;
    my $id = substr($_,1);
    my $seq = <IN>;
    chomp($seq);
    my $add =<IN>;
    my $qual = <IN>;
    $sum ++;
    $total_sum += length($seq);
    $C_num += ($seq =~ tr/Cc/Cc/);
    $G_num += ($seq =~ tr/Gg/Gg/);
    $T_num += ($seq =~ tr/Tt/Tt/);
    $A_num += ($seq =~ tr/Aa/Aa/);
    $N_num += ($seq =~ tr/Nn/Nn/);
}
close IN;

## print output
my $total_sum2 = $C_num+$G_num+$T_num+$A_num+$N_num;
print "the reads is $sum;\n the numbers of C base is $C_num,\n the numbers of G base is $G_num,\n the numbers of A base is $A_num;\n the numbers of T base is $T_num;\n the total numbers of base is $total_sum($total_sum2)\n";

### sub function ###
sub USAGE{
   my $usage =<<"USAGE";
Name:
$0 --calculate the fastq bases

Description:
You can use it to calculate the totle bases, the numbers of A,T,C,G bases, the file should be *.fastq.

Usage:
  options:
  -file<must|file> infile(*.fastq)
  -h help

Example:
perl $0 -file xx.fastq

USAGE
  print $usage;
  die;
} 
