#/usr/bin/python3

import sys
import argparse


#    <<>><<>><<>><<>><<>><<>><<>><<>><<>>
# |  Inputs, outputs & initial variables  |
#    <<>><<>><<>><<>><<>><<>><<>><<>><<>>
parser = argparse.ArgumentParser(description='This script takes a file containing SnpEff annotations for some variants. '+
'It will then sort through the different annotations and only output a summary for the one with the strongest effect. ' +
'If there are several genes affected in the same way, only the first one will be considered.',
        formatter_class=argparse.RawTextHelpFormatter)
parser.add_argument('-i', '--input', type=str,
help='Path to the input annotation file. This file should contain the columns CHROM, POS, REF, ALT, ANN.')
A = parser.parse_args()


#  <<>><<>><<>>
# |   Script   |
#  <<>><<>><<>>

dict_rankings = {"HIGH": 1, "MODERATE": 2, "LOW": 3, "MODIFIER": 4}
annotations = open(A.input, "r")
for ligne in annotations:
    sp_ligne = ligne.strip().split("\t")
    annots = sp_ligne[4].split(",") #listing all annotations for the variant
    alt_alleles = sp_ligne[3].split(",") #The variant can have more than 2 alleles
    for ALT in alt_alleles :
        effects = []
        rank_effects = []
        if not annots :
            effects.append("\t".join([str(rank), "NO_EFFECT"]))
            rank_effects.append(rank)
        else :
            for annot in annots:
                temp = annot.split("|")[0:4]
                if temp[0] == ALT :
                    rank = dict_rankings[temp[2]]
                    effects.append("\t".join([str(rank), temp[2], temp[1], temp[3], temp[0]]))
                    rank_effects.append(rank)
                if rank_effects == []:
                    effects.append("\t".join([str(5), "NO_EFFECT"]))
                    rank_effects.append(5)

        #select highest effect
        i = rank_effects.index(min(rank_effects))

        to_write = "\t".join(sp_ligne[0:3] + [ALT, effects[i]])
        print(to_write)
annotations.close()
