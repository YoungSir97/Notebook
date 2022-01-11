#!/usr/bin/env python
# -*- coding: UTF-8 -*-
#author: ys
import gzip,argparse,re,sys

def get_cds(gff,fa,outfile):
    ##read gff##
    Chr = {}
    Stand = {}
    Gene ={}
    pattern1 = re.compile(r'ID=(.*);') #编译正则表达式  #ID=FBgn0267430;
    pattern2 = re.compile(r'Parent=(.*);') #Parent=FBgn0267430;
    fr = gzip.open(gff,'rt') if '.gz' in gff else open(gff,'r')
    for line in fr:
        list1 = line.rstrip().split('\t')
        if list1[2] == 'mRNA':
            gene_id = pattern1.search(list1[8]).group(1) #ID=(FBgn0267430);
            if not gene_id:
                sys.stderr.write("check gff3 format: mRNA's lines not match \"ID=\"\n")
            Stand[gene_id] = list1[6]
            if list1[0] in Chr.keys():
                Chr[list1[0]].append(gene_id)
            else:
                Chr[list1[0]] = []
                Chr[list1[0]].append(gene_id)
            if gene_id in Gene:
                sys.stderr.write("check gff3 format: mRNA's ID repeat\n")
            else:
                Gene[gene_id] = []
        elif list1[2] == 'CDS':
            gene_id = pattern2.search(list1[8]).group(1) #Parent=(FBgn0267430);
            if not gene_id:
                sys.stderr.write("check gff3 format: CDS's lines not match \"Parent=\"\n")
            if gene_id in Gene:
                Gene[gene_id].append(int(list1[3]))
                Gene[gene_id].append(int(list1[4]))
            else:
                sys.stderr.write("gff didn't find the mRNA before CDS:"+gene_id+"\n")
        else:
            sys.stderr.write("check: "+line+"\n")
    fr.close()

    ##read fa & get CDS##
    Out_handle = []
    trantab1 = str.maketrans('ACGT','TGCA') #创建字符映射转换表

    fr2 = gzip.open(fa,'rt') if '.gz' in fa else open(fa,'r')
    fr2=fr2.read().split('>')
    for chunk in fr2[1:]:
        chunk=chunk.split("\n",1)
        seqid=re.sub(' .*','',chunk[0])
        if seqid not in Chr.keys():
            continue
        seq=chunk[1].replace("\n","").upper()
        #判断是否有负链基因，如果有，生成一条反向互补链#
        for key in Chr[seqid]:
            if Stand[key] == '-':
                re_seq = seq[::-1].translate(trantab1)
                break
            else:
                pass

        for geneid in Chr[seqid]:
            Gene[geneid].sort()
            n = len(Gene[geneid])
            if Stand[geneid] == '+':
                i = 0
                CDS = []
                while i < n:
                    CDS.append(seq[Gene[geneid][i]-1:Gene[geneid][i+1]])
                    i += 2
                cds = ''.join(CDS)
            elif Stand[geneid] == '-':
                i = 1
                CDS = []
                while i < n:
                    CDS.append(re_seq[-Gene[geneid][-i]:-Gene[geneid][-i-1]+1])
                    i += 2
                cds = ''.join(CDS)
            Out_handle.append('>'+geneid)
            Out_handle.append(cds)

    fw = open(outfile,'w+') #output
    print("\n".join(Out_handle),file=fw)
    fw.close()

def main(infile1,infile2,outfile1,outtype):
    if outtype == 'cds':
        get_cds(infile1,infile2,outfile1)
    elif outtype == 'pep':
        print("I'll write it when I have time\n")
    else:
        sys.stderr.write('check: --type\n')

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='get gene from sequences according to coordinates')

    parser.add_argument('gff',help='Gene annotation file, gff format')
    parser.add_argument('fasta',help='Genome file, fasta format')
    parser.add_argument('outfile',help='path of output file')
    parser.add_argument("-t","--type",choices=['cds','pep'],default='cds',help='get gene,then output cds or pep')
    parser.add_argument("-c","--check",action='store_true',help="check cds length")

    args = parser.parse_args()

    mygff = args.gff
    myfa = args.fasta
    myout = args.outfile
    mytype = args.type

    main(mygff,myfa,myout,mytype)
