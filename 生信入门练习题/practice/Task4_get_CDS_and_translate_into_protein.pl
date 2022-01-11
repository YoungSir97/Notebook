#!/usr/bin/perl
use strict;
use PerlIO::gzip;
#author:lzy

#my(@cds_id,@seq_id,%cds_pos);
#my($gene_count,@gene_id,%cds_len);

if(($ARGV[0] =~ /\.gff$/)&&($ARGV[1]=~/\.gz$/)){
	open GFF, $ARGV[0];
	open FASTA, "gunzip -c $ARGV[1] | ";}
elsif(($ARGV[0] =~ /\.gff$/)&&($ARGV[1]=~/\.fa$/)){
	open GFF, $ARGV[0];
	open FASTA, $ARGV[1];}else{die "USAGE: perl $0 <.gff> <.fa.gz>\norUSAGE: perl $0 <.gff> <.fa>"};

my (%seq, $seq_id);

while(<FASTA>){
	chomp;
	if ($_ =~ /^>(\S+)/){$seq_id=$1;}else{$seq{$seq_id} .= $_}
}
close FASTA;

my (%cds_seq,%cds_seq_reverse);
while (<GFF>) {
	chomp;
	my @line = split/\t/,$_;
	if (($line[2] eq "CDS")&&($line[6] eq "+")&&($line[8]=~/Parent=(\S+);/)){
		$cds_seq{">".$1} .= substr($seq{$line[0]},$line[3]-1,($line[4]-$line[3]+1));

	}elsif(($line[2] eq "CDS")&&($line[6] eq "-")&&($line[8]=~/Parent=(\S+);/)){
		$cds_seq_reverse{">".$1} .= substr($seq{$line[0]},$line[3]-1,($line[4]-$line[3]+1));
	}
}
#print $cds_seq_reverse{FBgn0023094}."\n";

foreach my $key(keys %cds_seq_reverse){
	$cds_seq_reverse{$key} =~ tr/ATGCatgcn/TACGtacgN/;
	$cds_seq{$key} = reverse($cds_seq_reverse{$key});

}

close FASTA;

my %protein;
open(A,">cds_seq.fa");
open(B,">cds_seq_2_aa.fa");
foreach my $key(keys %cds_seq){
	#open(a,">>cds_seq.fa"); # bad
	print A "$key\n$cds_seq{$key}\n";
	#close a;

	for(my $i=0; $i<(length($cds_seq{$key})-2);$i+=3)
	{
		my $codon=substr($cds_seq{$key},$i,3);
		$protein{$key} .=codon2aa($codon);
	}

}
close A;

foreach my $key(keys %cds_seq){
	#open(b,">>cds_seq_2_aa.fa");
	print B "$key\n$protein{$key}\n";
	#close b;
}
close B;

# codon2aa   
#   
# A subroutine to translate a DNA 3-character codon to an amino acid   
#   Version 3, using hash lookup   

sub codon2aa   
{   
	my($codon) = @_;   

	$codon = uc $codon;#uc=uppercase;lc=lowercase  
	#也就是大小写转换，uc表示将所有的小写 转换为大写  
	#lc将所有的大写转换为小写  

	my(%genetic_code) = (   

		'TCA' => 'S',    # Serine   
		'TCC' => 'S',    # Serine   
		'TCG' => 'S',    # Serine   
		'TCT' => 'S',    # Serine   
		'TTC' => 'F',    # Phenylalanine   
		'TTT' => 'F',    # Phenylalanine   
		'TTA' => 'L',    # Leucine   
		'TTG' => 'L',    # Leucine   
		'TAC' => 'Y',    # Tyrosine    
		'TAT' => 'Y',    # Tyrosine   
		'TAA' => '_',    # Stop   
		'TAG' => '_',    # Stop   
		'TGC' => 'C',    # Cysteine   
		'TGT' => 'C',    # Cysteine   
		'TGA' => '_',    # Stop   
		'TGG' => 'W',    # Tryptophan   
		'CTA' => 'L',    # Leucine   
		'CTC' => 'L',    # Leucine   
		'CTG' => 'L',    # Leucine   
		'CTT' => 'L',    # Leucine   
		'CCA' => 'P',    # Proline   
		'CCC' => 'P',    # Proline   
		'CCG' => 'P',    # Proline   
		'CCT' => 'P',    # Proline   
		'CAC' => 'H',    # Histidine   
		'CAT' => 'H',    # Histidine   
		'CAA' => 'Q',    # Glutamine   
		'CAG' => 'Q',    # Glutamine   
		'CGA' => 'R',    # Arginine   
		'CGC' => 'R',    # Arginine   
		'CGG' => 'R',    # Arginine   
		'CGT' => 'R',    # Arginine   
		'ATA' => 'I',    # Isoleucine   
		'ATC' => 'I',    # Isoleucine   
		'ATT' => 'I',    # Isoleucine   
		'ATG' => 'M',    # Methionine   
		'ACA' => 'T',    # Threonine   
		'ACC' => 'T',    # Threonine   
		'ACG' => 'T',    # Threonine   
		'ACT' => 'T',    # Threonine   
		'AAC' => 'N',    # Asparagine   
		'AAT' => 'N',    # Asparagine   
		'AAA' => 'K',    # Lysine   
		'AAG' => 'K',    # Lysine   
		'AGC' => 'S',    # Serine   
		'AGT' => 'S',    # Serine   
		'AGA' => 'R',    # Arginine   
		'AGG' => 'R',    # Arginine   
		'GTA' => 'V',    # Valine   
		'GTC' => 'V',    # Valine   
		'GTG' => 'V',    # Valine   
		'GTT' => 'V',    # Valine   
		'GCA' => 'A',    # Alanine   
		'GCC' => 'A',    # Alanine   
		'GCG' => 'A',    # Alanine   
		'GCT' => 'A',    # Alanine       
		'GAC' => 'D',    # Aspartic Acid   
		'GAT' => 'D',    # Aspartic Acid   
		'GAA' => 'E',    # Glutamic Acid   
		'GAG' => 'E',    # Glutamic Acid   
		'GGA' => 'G',    # Glycine   
		'GGC' => 'G',    # Glycine   
		'GGG' => 'G',    # Glycine   
		'GGT' => 'G',    # Glycine   
	);   

	if(exists $genetic_code{$codon})   
	{   
		return $genetic_code{$codon};   
	}  
	else  
	{   

		print STDERR "Bad codon \"$codon\"!!\n";   
		exit;   
	}   
} 


#print $seq{'2L'};
#print %cds_seq;
print $cds_seq{FBgn0023094};
