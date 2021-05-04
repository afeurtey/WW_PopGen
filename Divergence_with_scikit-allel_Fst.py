#/usr/bin/python3

import sys
import argparse
import allel
import numpy as np


#    <<>><<>><<>><<>><<>><<>><<>><<>><<>>
# |  Inputs, outputs & initial variables  |
#    <<>><<>><<>><<>><<>><<>><<>><<>><<>>

parser = argparse.ArgumentParser(description='',
        formatter_class=argparse.RawTextHelpFormatter)
parser.add_argument('--vcf_file', type=str, help='path to the input vcf file.')
parser.add_argument('--bed_file', type=str, help='path to the input bed file containing regions to compute the diversity over')
parser.add_argument('--sample_list1', type=str, help='path to the first sample list. Extension must be args.')
parser.add_argument('--sample_list2', type=str, help='path to the second sample list. Extension must be args.')
parser.add_argument('--out_dir', type=str, help='path to the output directory')

A = parser.parse_args()



#  ------------
# |   Script   |
#  ------------

# Derive info from the subset file name
subset1_name = A.sample_list1.replace(".args", "").rsplit("/", 1)[1]
subset2_name = A.sample_list2.replace(".args", "").rsplit("/", 1)[1]
print("\n" + subset1_name + " vs " + subset2_name)



#
dict_bed = {}
with open(A.bed_file, "r") as bed_input :
    for ligne in bed_input :
        row = ligne.strip().split("\t")
        if str(row[0]) not in dict_bed :
            dict_bed[str(row[0])] = []
        dict_bed[str(row[0])].append(row)

out = open(A.out_dir + "Divergence.Fst." + subset1_name + "_vs_" + subset2_name+ ".tsv", "w")
out.write("\t".join(["Subset1", "Subset2", "Chromosome", "Hudsons_Fst", "Weir_Cockerham_Fst"]) + "\n")

# Read samples from the two populations as lists
with open(A.sample_list1, "r") as input_file :
    subset1 = [x.strip() for x in input_file]
with open(A.sample_list2, "r") as input_file :
    subset2 = [x.strip() for x in input_file]


# Loop over chromosomes
for chromosome in [x+1 for x in range(21)] :
    print(subset1_name, subset2_name, str(int(chromosome)), "\n")

    # Reading the SNPs for the right chromosome and the right samples
    callset = allel.read_vcf(A.vcf_file, samples = subset1 + subset2, region = str(int(chromosome)))
    if callset:
        sample_list = callset['samples']
        pos = callset['variants/POS'][:]
        h = allel.GenotypeArray(callset['calldata/GT'])
        to_write = [subset1_name, subset2_name, str(chromosome)]

        ac1 = h.count_alleles(subpop=[list(sample_list).index(x) for x in subset1])
        ac2 = h.count_alleles(subpop=[list(sample_list).index(x) for x in subset2])
        num, den = allel.hudson_fst(ac1, ac2)
        fst = np.sum(num) / np.sum(den)
        to_write.append(str(fst))

        a, b, c = allel.weir_cockerham_fst(h, [[list(sample_list).index(x) for x in subset1], [list(sample_list).index(x) for x in subset2]])
        fst = np.sum(a) / (np.sum(a) + np.sum(b) + np.sum(c))
        to_write.append(str(fst))

        out.write("\t".join(to_write) + "\n")

print("All done!")
out.close()
