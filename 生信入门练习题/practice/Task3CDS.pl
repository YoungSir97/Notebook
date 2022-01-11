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

my %result=();
my %result_cds;

while( <IN>){
	my ($chr,$type,$start,$end,$strand,$info)=(split/\s+/,$_)[0,2,3,4,6,8];
	if($type eq "mRNA"){
		my $ID=$1 if($info =~ /ID=(\S+);/);
		$result_cds{$ID}=$end-$start+1;
	}elsif($type eq "CDS"){
		my $parent = $1 if ($info =~ /Parent=(\S+);/);
		my $seq = $end -$start+1;
		#$result{$parent}=$seq;
		$result{$parent} += $seq;
	}
}
close IN;
my $total_CDS;
foreach my $key (keys %result){

	print "ID: $key  => the length of CDS is $result{$key}\n";    
	$total_CDS += $result{$key};
}
print "the total_CDS is $total_CDS\n";

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
