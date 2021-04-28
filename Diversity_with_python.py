#/usr/bin/python3

import argparse
import allel
import numpy as np
import scipy
import pandas
import matplotlib as mpl
import matplotlib.pyplot as plt
#%matplotlib inline
from os import walk
import seaborn as sns
sns.set_style('white')
sns.set_style('ticks')



#    <<>><<>><<>><<>><<>><<>><<>><<>><<>>
# |  Inputs, outputs & initial variables  |
#    <<>><<>><<>><<>><<>><<>><<>><<>><<>>

parser = argparse.ArgumentParser(description='',
        formatter_class=argparse.RawTextHelpFormatter)
parser.add_argument('--vcf_file', type=str, help='path to the input vcf file.')
parser.add_argument('--bed_file', type=str, help='path to the input bed file containing regions to compute the diversity over')
parser.add_argument('--sample_list', type=str, help='path to the input sample list. Extension must be args.')
parser.add_argument('--out_dir', type=str, help='path to the output directory')
A = parser.parse_args()


#  ------------
# |   Script   |
#  ------------

# Derive info from the subset file name
subset_name = A.sample_list.replace(".args", "").rsplit("/", 1)[1]
print("\n" + subset_name)

#

dict_bed = {}
with open(A.bed_file, "r") as bed_input :
    for ligne in bed_input :
        row = ligne.strip().split("\t")
        if str(row[0]) not in dict_bed :
            dict_bed[str(row[0])] = []
        dict_bed[str(row[0])].append(row)

out = open(A.out_dir + subset_name + "_diversity_pi.tsv", "w")

# Read samples from the subset as a list
with open(A.sample_list, "r") as input_file :
    samples = [x.strip() for x in input_file]

# Loop over chromosomes
for chromosome in [x+1 for x in range(21)] :
    print(subset_name, str(int(chromosome)))

    # Reading the SNPs for the right chromosome and the right samples
    callset = allel.read_vcf(A.vcf_file, samples = samples, region = str(chromosome))
    #callset.keys()
    print(callset['samples'])
    pos = callset['variants/POS'][:]
    h = allel.GenotypeArray(callset['calldata/GT'])

    #Estimating diversity
    ac = h.count_alleles()
    for row in dict_bed[str(chromosome)] :
        start = row[1]
        stop = row[2]
        try :
            pi = allel.sequence_diversity(pos, ac, start=int(start), stop=int(stop))
            to_write = [subset_name, str(chromosome), str(start), str(stop), str(round(pi, 6))]
            shutup = out.write("\t".join(to_write) + "\n")
        except :
            print([subset_name, str(chromosome), str(start), str(stop)])
    print(c)


print("All done!")
out.close()

