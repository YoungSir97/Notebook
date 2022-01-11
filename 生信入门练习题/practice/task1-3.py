#!/usr/bin/env python3
# -*- coding: UTF-8 -*-
#author: ys
import os
import sys
import gzip
import re
import argparse

def get_gff_info(filename):
    gene_numbers = 0
    cds_len = {}
    ##read gff##
    for lines in open(filename,'r'):
        lines.rstrip()
        list2 = lines.split("\t")
        if list2[2] == 'mRNA':
            gene_numbers += 1
            ID = re.search(r'ID=(.*);',list2[8]).group(1) #t = re.search(r'ID=(.*);',list2[8]); ID = t.group(1)
            if ID in cds_len:
                 sys.stderr.write("check gff file format,",ID,"exist\n")
            else:
                cds_len[ID] = 0
        if list2[2] == 'CDS':
            Parent = re.search(r'Parent=(.*);',list2[8]).group(1)
            if Parent in cds_len:

                cds_len[ID] += int(list2[4]) - int(list2[3])
            else:
                sys.stderr.write("check gff file format:",Parent,"\n")

    ##output result##
    for key2 in cds_len.keys():
        print (key2+"\t",cds_len[key2])

    return gene_numbers

def get_fasta_info(filename):
    ##read fasta##
    dict1 = {}
    fr = gzip.open(filename,'rt') if '.gz' in filename else open(filename,'r')
    for line in fr:
        if (line[0] == '>'):
            seq_head = line.rstrip()
            list1 = seq_head.split()
            seq_id = list1[0]
            seq_id = seq_id[1:] #remove '>'
            dict1[seq_id] = []
        if (line[0] != '>'):
            seq = line.rstrip()
            #dict1[seq_id] += seq
            dict1[seq_id].append(seq) #add seq to list
    fr.close()

    ##get info##
    genome_size = 0
    GC = 0
    enzyme_cutting_sites = 0

    for key in dict1.keys():
        scarf = ''.join(dict1[key]) #join up list into one seqence
        scarf.upper
        scarf_length = len(scarf)
        genome_size += scarf_length
        GC += scarf.count('G') + scarf.count('C')
        s = re.findall('TATGGCAGCAG',scarf) #scarf.count('TATGGCAGCAG')
        enzyme_cutting_sites += len(s)

        print (">"+key,"\t",scarf_length)

    GC_content = GC/genome_size
    return genome_size,GC_content,enzyme_cutting_sites

def count_fastq_reads_bases(filename):
    reads = 0
    bases = 0
    A = 0;T = 0;C =0;G = 0;N =0

    fr = gzip.open(filename,'rt') if '.gz' in filename else open(filename,'r')

    while True:
        ID = fr.readline().rstrip()
        seq = fr.readline().rstrip()
        d = fr.readline()
        fr.readline()

        if ID == '':
            break
        seqlen = len(seq)
        if seqlen == 0:
            break
        if '@' not in ID:
            sys.stderr.write("check fastq format")
        if '+' not in d:
            Warning

        reads += 1
        bases += seqlen
        seq.upper() # a2A
        A += seq.count("A");T += seq.count("T");C += seq.count("C");G += seq.count("G");N += seq.count("N") # method 1
        #it = re.finditer("A",seq,re.I) # method 2
        #A += len(it)

    fr.close()
    return reads,bases,A,T,C,G,N

def main (infile,t):
    if t == 1:
        reads,bases,A,T,C,G,N = count_fastq_reads_bases(infile)
        print ("reads:",reads,"\tbases:",bases,"\nA numbers:",A,"\tT numbers:",T,"\tC numbers:",C,"\tG numbers:",G,"\tN number:",N,"\n")
    elif t == 2:
        genome_size,GC_content,enzyme_cutting_sites = get_fasta_info(infile)
        print ("genome_size:",genome_size,"\tGC_content:",GC_content,"\tenzyme_cutting_sites:",enzyme_cutting_sites,"\n")
    elif t == 3:
        gene_numbers = get_gff_info(infile)
        print ("gene_numbers:",gene_numbers,"\n")
    else:
        exit("check --task\n")

if __name__ == "__main__":
    # Instantiate the parser
    parser = argparse.ArgumentParser(description='The script is a practice for task1-3, type `python3 task1-3.py test.fq.gz -t 1 ` to run task 1. More information --help')

    parser.add_argument('input',help='input file [fq|fa|gff]')
    parser.add_argument('-v','--version',action='version',version='%(prog)s version : v1.0', help='show the version')
    parser.add_argument('-t','--task',required=True,type=int,choices=[1,2,3],default='1',help='task number')

    args = parser.parse_args()
    # run
    infile = args.input
    t = args.task
    main(infile,t)

