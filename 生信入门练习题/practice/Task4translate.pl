#!usr/bin/perl -w
use strict;
#author:psf

die "perl $0 <gff_file> <fasta_file> > <result.cds.fa>\n" if (@ARGV <2);
my $gff =shift;
my $fasta = shift;

my $out = shift;
#====read fasta file=====
my %sequence=();
open FASTA,"<$fasta" or die $!;
$/ = ">";<FASTA>;$/="\n";

while (my $tmp = <FASTA>){
    my $head = (split /\s+/,$tmp)[0];
    $/=">";
    my $seq = <FASTA>;
    $seq =~ s/\n//g;
    $sequence{$head}=$seq;
    $/="\n";
}
close FASTA;

#====read gff file=======
my %result_cds=();
open GFF,"<$gff" or die $!;
while(my $eachline = <GFF>){
    my($chr,$type,$start,$end,$strand,$info)=(split/\s+/,$eachline)[0,2,3,4,6,8];
   if($type eq "mRNA"){
       my $ID=$1 if($info =~/ID=(\S+);/);
       $result_cds{$ID}{strand}=$strand;
    }elsif($type eq "CDS"){
       my $parent=$1 if($info =~ /Parent=(\S+);/);
       my $cds = substr($sequence{$chr},$start-1,$end-$start+1);
       $result_cds{$parent}{seq} .= $cds;
    }
}
close GFF;

#====CODE list========== 
my %CODE = (
			'GCA' => 'A', 'GCC' => 'A', 'GCG' => 'A', 'GCT' => 'A',                               # Alanine
			'TGC' => 'C', 'TGT' => 'C',                                                           # Cysteine
			'GAC' => 'D', 'GAT' => 'D',                                                           # Aspartic Acid
			'GAA' => 'E', 'GAG' => 'E',                                                           # Glutamic Acid
			'TTC' => 'F', 'TTT' => 'F',                                                           # Phenylalanine
			'GGA' => 'G', 'GGC' => 'G', 'GGG' => 'G', 'GGT' => 'G',                               # Glycine
			'CAC' => 'H', 'CAT' => 'H',                                                           # Histidine
			'ATA' => 'I', 'ATC' => 'I', 'ATT' => 'I',                                             # Isoleucine
			'AAA' => 'K', 'AAG' => 'K',                                                           # Lysine
			'CTA' => 'L', 'CTC' => 'L', 'CTG' => 'L', 'CTT' => 'L', 'TTA' => 'L', 'TTG' => 'L',   # Leucine
			'ATG' => 'M',                                                                         # Methionine
			'AAC' => 'N', 'AAT' => 'N',                                                           # Asparagine
			'CCA' => 'P', 'CCC' => 'P', 'CCG' => 'P', 'CCT' => 'P',                               # Proline
			'CAA' => 'Q', 'CAG' => 'Q',                                                           # Glutamine
			'CGA' => 'R', 'CGC' => 'R', 'CGG' => 'R', 'CGT' => 'R', 'AGA' => 'R', 'AGG' => 'R',   # Arginine
			'TCA' => 'S', 'TCC' => 'S', 'TCG' => 'S', 'TCT' => 'S', 'AGC' => 'S', 'AGT' => 'S',   # Serine
			'ACA' => 'T', 'ACC' => 'T', 'ACG' => 'T', 'ACT' => 'T',                               # Threonine
			'GTA' => 'V', 'GTC' => 'V', 'GTG' => 'V', 'GTT' => 'V',                               # Valine
			'TGG' => 'W',                                                                         # Tryptophan
			'TAC' => 'Y', 'TAT' => 'Y',                                                           # Tyrosine
			'TAA' => 'U', 'TAG' => 'U', 'TGA' => 'U'                                              # Stpen IN, "< /home/bgi902/CDS.fa" or die $!;
);
#======translate and save========
#===get CDS and save =====
#open OUT,"> /home/bgi902/translate.fa" or die $!;
open OUT,">$out" or die $!;
#my $prot;
foreach my $key(keys %result_cds){
    my $prot;
	if($result_cds{$key}{strand} eq "-"){
        $result_cds{$key}{seq}=~ tr/ATCG/TAGC/;
        $result_cds{$key}{seq}=reverse($result_cds{$key}{seq});
    }
    for(my $i=0; $i<= length($result_cds{$key}{seq});$i+=3){
        my $code = substr($result_cds{$key}{seq},$i,3);
        last if (length($code)<3);
        $prot .= (exists $CODE{$code} ? $CODE{$code}: "x");
    }    
    print OUT  ">$key\n";
    my @seq = &line($prot,60);
    print OUT "$_\n" for (@seq);
}

close OUT;
#====sub=========
sub line{
    my($seq,$width)=@_;
    my @line= ($seq =~ /.{$width}/g);
    my $n = length($seq)%$width;
    my $last = substr($seq,length($seq)-$n,$n);
    push(@line,$last);
    @line;
}


