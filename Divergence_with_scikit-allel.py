#/usr/bin/python3

import sys
import argparse
import allel


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
parser.add_argument('--dxy', action="store_true")
parser.add_argument('--Fst', action="store_true")
A = parser.parse_args()



if not A.dxy :
    if not A.Fst :
        sys.exit("\n\n I have to stop now! Please use the options --dxy and/or --Fst. ")



#  ------------
# |   Script   |
#  ------------

# Derive info from the subset file name
subset1_name = A.sample_list1.replace(".args", "").rsplit("/", 1)[1]
subset2_name = A.sample_list1=2.replace(".args", "").rsplit("/", 1)[1]
print("\n" + subset1_name + " vs " + subset2_name)



#
dict_bed = {}
with open(A.bed_file, "r") as bed_input :
    for ligne in bed_input :
        row = ligne.strip().split("\t")
        if str(row[0]) not in dict_bed :
            dict_bed[str(row[0])] = []
        dict_bed[str(row[0])].append(row)

out = open(A.out_dir + subset_name + "_divergence." + subset1_name + "_vs_" + subset2_name+ ".tsv", "w")

# Read samples from the two populations as lists
with open(A.sample_list1, "r") as input_file :
    subset1 = [x.strip() for x in input_file]
with open(A.sample_list2, "r") as input_file :
    subset2 = [x.strip() for x in input_file]


# Loop over chromosomes
for chromosome in [x+1 for x in range(21)] :
    print(subset1_name, subset2_name, str(int(chromosome)))

    # Reading the SNPs for the right chromosome and the right samples
    callset = allel.read_vcf(A.vcf_file, samples = subset1 + subset2, region = str(chromosome))
    #callset.keys()
    sample_list = callset['samples']
    pos = callset['variants/POS'][:]
    h = allel.GenotypeArray(callset['calldata/GT'])

    ac1 = h.count_alleles(subpop=[sample_list.index(x) for x in subset1])
    ac2 = h.count_alleles(subpop=[sample_list.index(x) for x in subset2])
    for row in dict_bed[str(chromosome)] :
        start = row[1]
        stop = row[2]
        to_write = [subset1_name, subset2_name, str(chromosome), str(start), str(stop)]
        try :
            if A.dxy :
                dxy = sequence_divergence(pos, ac1, ac2, start=start, stop=stop)
                to_write.append(str(round(dxy, 6)))

            shutup = out.write("\t".join(to_write) + "\n")
        except :
            print([subset_name, str(chromosome), str(start), str(stop)])


print("All done!")
out.close()
