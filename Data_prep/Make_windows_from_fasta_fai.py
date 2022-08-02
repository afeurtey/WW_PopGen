
#/usr/bin/python3


#    *********************************************************
# |  This script was written by Alice Feurtey on the 21/07/20.  |
# |  It was last modified on the 21/07/20.                      |
#    *********************************************************


import argparse
#import gzip
#from Bio import SeqIO
#from Bio.SeqUtils import GC
#import matplotlib.pyplot as plt
#import numpy as np

#    <<>><<>><<>><<>><<>><<>><<>><<>><<>>
# |  Inputs, outputs & initial variables  |
#    <<>><<>><<>><<>><<>><<>><<>><<>><<>>

parser = argparse.ArgumentParser()
parser.add_argument('--out', type=str, help='Path to an optional output file suffix')
parser.add_argument('--window_size', type=int, default=1000,
 help='Integer giving the window size in bp. The default is 1kb (1000bp).')
parser.add_argument('--window_step', type=int, default=1000,
 help='Integer giving the window step in bp. The default is 1kb (1000bp), which is the same as the window size, thus creating non-overlapping windows.')
parser.add_argument('fasta_fai', help='Path to the input file. This is expected to the the output of the samtools faidx command from a fasta.')

A = parser.parse_args()

if A.out:
    out_name = A.out
else:
    out_name = A.fasta_fai.replace(".fai","") + ".windows.bed"


#   <<>><<>><<>>
# |  Script body |
#   <<>><<>><<>>

out = open(out_name, "w")

with open(A.fasta_fai, "r") as input_file:
    for line in input_file :
        sp = line.strip().split("\t")
        chr = sp[0]
        length = int(sp[1])
        start = 0
        end = A.window_size
        while start <= length :
            if end <= length :
       	        out.write("\t".join([chr, str(start), str(end)]) + "\n")
            else :
                out.write("\t".join([chr, str(start), str(length)]) + "\n")
            start += A.window_step
            end += A.window_step

out.close()
