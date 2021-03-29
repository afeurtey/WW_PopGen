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

parser = argparse.ArgumentParser()
parser.add_argument('--input', type=str, help='path to the input vcf file. Max number of alleles is 3.')
parser.add_argument('--out', type=str, help='path to an optional output file suffix')
parser.add_argument('--gzipped', action = "store_true")
parser.add_argument('--set_filtered_gt_to_nocall', action = "store_true")
parser.add_argument('--AB_ratio', type=float, default = 0.9, help='')

A = parser.parse_args()



#  ------------
# |   Script   |
#  ------------

out = open(A.out, "w")
vcf = open(A.input, "r")
count_filtered = 0
count_all = 0


for line in vcf :
  # Read headers
  if line.startswith("##") :
    out.write(line)
  elif line.startswith("#CHROM") :
    header = line.strip().split("\t")
    count_per_sample = dict(zip(header[9:], [0]*len(header[9:])))

  # Start reading genotypes
  else :
    line_sp = line.strip().split("\t")
    to_write = line_sp.copy()

    # Make sure that the format contains the filter field
    format = line_sp[8].split(":")
    if "FT" in format :
      format_tw = format.copy()
    else:
      format_tw = ["GT"] + sorted(format[1:] + ["FT"])
      #print(":".join(format) + "\n" + ":".join(format_tw) + "\n")
    filter_i = format_tw.index("FT")
    to_write[8] = ":".join(format_tw)

    # Check allelic balance per genotype and filter if needed.
    for i, genotype in enumerate(line_sp[9:]) :
      GT_sp = genotype.split(":")
      GT_dict = dict(zip(format, GT_sp))

      if "FT" not in format :
        GT_dict["FT"] = "PASS"

      AD_sp = [int(x) for x in GT_dict["AD"].split(",")]
      if sum(AD_sp) != 0 :
        AB = max(AD_sp)/sum(AD_sp)
        genotype2  = GT_sp.copy()
        if AB < A.AB_ratio :
          #print(GT_dict)
          if GT_dict["FT"] == "PASS" :
            #print( "AB_fail")
            GT_dict["FT"] = "AB_fail"
            #print(GT_dict)
          else :
            GT_dict["FT"] = GT_dict["FT"] + ";AB_fail"

          if A.set_filtered_gt_to_nocall :
            GT_dict["GT"] = "."

      to_write[i + 9] = ":".join([ GT_dict[x] for x in  format_tw ])
      #print(to_write)
    out.write("\t".join(to_write) + "\n")


vcf.close()
out.close()
