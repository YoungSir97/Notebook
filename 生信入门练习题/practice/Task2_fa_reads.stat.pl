#!/usr/bin/perl
use strict;
use PerlIO::gzip;
#author:lzy

my($name, %seq, $full_len, $count_of_C, $count_of_G, $count_of_GC, $count_of_enzyme_site);

if ($ARGV[0] =~ /\.gz$/){
	open IN,"gunzip -c $ARGV[0] | ";
}elsif($ARGV[0] =~ /\.fa$/){
	open IN, $ARGV[0];
}else{
	die "USAGE:: perl $0 <fa>\n";
}

$/=">";<IN>;$/="\n";
while (<IN>){
	my $title=$_;
	chomp $title;
	my $id = (split /\s+/,$title)[0];
	$/=">";
	my $seq=<IN>;
	chomp $seq;
	$/="\n";
	$seq =~ s/\n//g;
	
	print "Name: $id\tLength: ".length($seq)."\n";
	$full_len += length($seq);
	$count_of_C += $seq =~ tr/C/C/;
	$count_of_G += $seq =~ tr/G/G/;
	$count_of_enzyme_site += ($seq =~ s/TATGGCAGCAG/TATGGCAGCAG/g);
}
close IN;

=pod
while(<IN>){
	chomp;
	if(/^>(\S+)/){			#匹配染色体的名字
		$name = $1;
	}
	else{
		$seq{$name} .= $_;
	}
}
close IN;

print "[ INFO ] Length Infomation:\n\n";
foreach $name(sort{$a cmp $b} keys %seq){
	print "Name: ".$name."\tLength: ".length($seq{$name})."\n";
	$full_len += length($seq{$name});
	$count_of_C += $seq{$name} =~ tr/C/C/;
	$count_of_G += $seq{$name} =~ tr/G/G/;
	$count_of_enzyme_site += $seq{$name} =~ tr/TATGGCAGCAG/TATGGCAGCAG/;
}
print "\n";
=cut

$full_len /= 1000000;
print "[ INFO ] Genome size is: ".$full_len."Mb\n";
$count_of_G /= $full_len*1000000/100;
$count_of_C /= $full_len*1000000/100;
$count_of_GC = $count_of_G+$count_of_C;
printf "[ INFO ] GC info. G:%.4f%\tC:%.4f%\tG+C:%.4f%\n",$count_of_G,$count_of_C,$count_of_GC;
print "[ INFO ] restriction enzyme sites count: ".$count_of_enzyme_site."\n";
