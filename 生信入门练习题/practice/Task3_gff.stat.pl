#!/usr/bin/perl
use strict;
#use PerlIO::gzip;
#author:lzy

my($gene_count,@gene_id,%cds_len);

if($ARGV[0] =~ /\.gff$/){
	open IN, $ARGV[0];
	}else{die "USAGE:: perl $0 <.gff>\n"};

while(<IN>){
        chomp;
        my @line = split/\t/,$_;
        if ($line[2] eq "mRNA"){
                $gene_count++;
        }
        elsif ($line[2] eq "CDS"){
				#my $id = substr($line[8],7,-1);
				my $id = $1 if ($line[8] =~ /Parent=(\S+);/);
                $cds_len{$id} +=$line[4] - $line[3]+1;
        }
}
close IN;

print "total gene number: ".$gene_count."\n";

foreach my $key(keys %cds_len){
        print "$key\t$cds_len{$key}\n";
}
print @gene_id;
