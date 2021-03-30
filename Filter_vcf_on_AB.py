#/usr/bin/python3


#    *********************************************************
# |  This script was written by Alice Feurtey on the 29/03/21.  |
# |  It was last modified on the 29/03/21.                      |
#    *********************************************************


import argparse
import gzip


#    <<>><<>><<>><<>><<>><<>><<>><<>><<>>
# |  Inputs, outputs & initial variables  |
#    <<>><<>><<>><<>><<>><<>><<>><<>><<>>

parser = argparse.ArgumentParser(description='This script takes a vcf input file with haploid samples and outputs a vcf file filtered on the allelic balance.',
        formatter_class=argparse.RawTextHelpFormatter)
parser.add_argument('--input', type=str, help='path to the input vcf file. Max number of alleles is 3.')
parser.add_argument('--out', type=str, help='path to an optional output file suffix')
parser.add_argument('--gzipped', action = "store_true")
parser.add_argument('--set_filtered_gt_to_nocall', action = "store_true")
parser.add_argument('--AB_ratio', type=float, default = 0.9, help='Allelic balance ratio. A ratio of 1 means that all reads confirm one single allele. A ratio of 0.5 that the only half the reads give the called alleles.')

A = parser.parse_args()


#  ------------
# |   Script   |
#  ------------

out = open(A.out, "w")
if A.gzipped:
    vcf = gzip.open(A.input, 'rt')
else:
    vcf = open(A.input, reading_option)
count_filtered = 0
count_all = 0


for line in vcf :
  # Read headers
  if line.startswith("##") :
    out.write(line)
  elif line.startswith("#CHROM") :
    out.write(line)
    header = line.strip().split("\t")
    count_per_sample = dict(zip(header[9:], [0]*len(header[9:])))

  # Start reading genotypes
  else :
    line_sp = line.strip().split("\t")
    to_write = line_sp.copy()

    # Make sure that the format contains the filter field
    # Sort this field alphabetically (except for GT which is always first)
    format = line_sp[8].split(":")
    if "FT" in format :
      format_tw = format.copy()
    else:
      format_tw = ["GT"] + sorted(format[1:] + ["FT"])
    to_write[8] = ":".join(format_tw)

    # Check allelic balance per genotype and filter if needed.
    for i, genotype in enumerate(line_sp[9:]) :
      GT_sp = genotype.split(":")
      GT_dict = dict(zip(format, GT_sp))

      if "FT" not in format :
        GT_dict["FT"] = "PASS"
      
      # Allelic balance  is evaluated as the highest AD
      # divided by the sum of AD. If this value is too low,
      # I add a filter tag and, optionally, sets the genotype
      # to no call. 
      AD_sp = [int(x) for x in GT_dict["AD"].split(",")]
      if sum(AD_sp) != 0 :
        count_filtered += 1
        AB = max(AD_sp)/sum(AD_sp)
        genotype2  = GT_sp.copy()
        if AB < A.AB_ratio :
          if GT_dict["FT"] == "PASS" :
            GT_dict["FT"] = "AB_fail"
          else :
            GT_dict["FT"] = GT_dict["FT"] + ";AB_fail"

          if A.set_filtered_gt_to_nocall :
            GT_dict["GT"] = "."
      
      # Setting up the genotype to be written 
      # Except KeyError to take care of incomplete genotype fields
      # Not sure where they were coming from...
      to_write_list = []
      for x in  format_tw :
        try : 
          to_write_list.append(GT_dict[x])
        except KeyError:
          to_write_list.append(".")
        to_write[i + 9] = ":".join(to_write_list)
    out.write("\t".join(to_write) + "\n")


vcf.close()
out.close()

print("I filtered out " + count_filtered + " genotypes.")
