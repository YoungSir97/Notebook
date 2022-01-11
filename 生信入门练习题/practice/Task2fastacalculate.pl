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

open IN,"< $file" or die $!;
my ($sum,$C_num,$G_num,$A_num,$T_num,$N_num,$enzyme_cutting);
my %seq=();
my $id;
while(my $line =<IN>){
    chomp $line;
	#if($line =~ />([^\s]+)\s([^\s]+)\schromosome:([^\s]+)\sREF/){
	if($line =~ />(\S+)/){
		$id = $1;
		#$id = $3;
    }else{
        $line =~ s/\s//g;       
        $sum += length($line);
        $seq{$id} += length($line);
        $C_num += ($line =~ tr/Cc/Cc/);
        $G_num += ($line =~ tr/Gg/Gg/);
        $T_num += ($line =~ tr/Tt/Tt/);
        $A_num += ($line =~ tr/Aa/Aa/);
        $N_num += ($line =~ tr/Nn/Nn/);
		#$enzyme_cutting += ($line =~ tr/(TATGGCAGCAG)/(TATGGCAGCAG)/);
		$enzyme_cutting += ($line =~ s/TATGGCAGCAG/TATGGCAGCAG/g); #这里没有考虑到酶切位点跨两行的情况，...TATGG\nCAGCAG...
	}
}
close IN;
foreach my $key (keys %seq){
    print "$key => length:$seq{$key}\n";
} 
my $sum_total=$C_num+$G_num+$A_num+$T_num+$N_num;
my $CG_content = ($C_num+$G_num)/($sum-$N_num);
print "the total length is $sum;\n the numbers of C base is $C_num;\n the numbers of G base is $G_num;\n the numbers of A base is $A_num;\n the numbers of T base is $T_num;\n the numbers of N base is $N_num;\n the sum_total is $sum_total;\n";
printf "the CG_content is %.2f\n",$CG_content;
print "the numbers of enzyme_cutting(TATGGCAGCAG) is $enzyme_cutting\n"; 
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
} 
