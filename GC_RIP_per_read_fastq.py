
#/usr/bin/python3


#    *********************************************************
# |  This script was written by Alice Feurtey on the 14/05/20.  |
# |  It was last modified on the 14/05/20.                      |
#    *********************************************************


import argparse
import gzip
from Bio import SeqIO
from Bio.SeqUtils import GC
import matplotlib.pyplot as plt
import numpy as np

#    <<>><<>><<>><<>><<>><<>><<>><<>><<>>
# |  Inputs, outputs & initial variables  |
#    <<>><<>><<>><<>><<>><<>><<>><<>><<>>

parser = argparse.ArgumentParser()
parser.add_argument('--out', type=str, help='path to an optional output file suffix')
parser.add_argument('--input_format', type=str, default="fasta", choices=['fasta', 'fastq'], 
help='This is the format of the input. Possible values are "fasta" and "fastq".')
parser.add_argument('--gzipped', action = "store_true")
parser.add_argument('--max_reads', default = 100000000, type =int,
help = "This is for making tests. If you need to check whether the script is working you can set this value to 10000, for instance." +
"The default is supposed to be so high that it could not stop before the end of your files. If you know it to be too low, you can change it.")
parser.add_argument('fastx_input', help='Path to the input file.')

A = parser.parse_args()

if A.out:
    out_name = A.out
else:
    out_name = A.fastx_input + ".output"

if A.gzipped:
    reading_option = "rt"
else:
    reading_option="r"


GC_list = []
product_index=[]
substrate_index=[]
comp_RIP = []
c = 0

#print (A.max_reads)
#   <<>><<>><<>>
# |  Script body |
#   <<>><<>><<>>

#path_file= "/Volumes/Seagate_fil/WW_PopGen/Fastq/ST16DK_Biog_DK32.sorted.1.fq"
with open(A.fastx_input, reading_option) as handle:
    for record in SeqIO.parse(handle, A.input_format) :
        c += 1
        if c == A.max_reads :
          #print(c, A.max_reads)
          break
        else :
          #print(record.seq)
          GC_list.append(GC(record.seq))
          ATc = record.seq.count("AT")
          if ATc > 0 :
              pi_temp = record.seq.count("TA")/ATc
              product_index.append(pi_temp)
          temp = (record.seq.count("AC")+record.seq.count("GT"))
          if temp > 0 :
              temp2 = record.seq.count("CA") + record.seq.count("TG")
              subi_temp = temp2 / temp
              substrate_index.append(subi_temp)
          if temp > 0 and ATc > 0 :
              comp_RIP.append(pi_temp - subi_temp)

#print(len(GC_list), len(product_index), len(substrate_index), len(comp_RIP))
ax1 = plt.subplot(2, 2, 1)
plt.hist(x = GC_list, bins = 30,
                   color='#FFA62B')
ax1.title.set_text('GC %')

ax2 = plt.subplot(2, 2, 2)
plt.hist(x = substrate_index, bins = 30,
                   color='#82C0CC')
ax2.title.set_text('Substrate index')

ax3 = plt.subplot(2, 2, 3)
plt.hist(x = product_index, bins = 30,
                   color='#489FB5')
ax3.title.set_text('Product index')

ax4 = plt.subplot(2, 2, 4)
plt.hist(x = comp_RIP, bins = 50,
                   color='#16697A')
ax4.set_xlim([-5, 5])
ax4.title.set_text('Composite index')
plt.show()
plt.savefig(out_name + ".pdf")

with open(out_name + ".txt", "w") as out :
    names_lists = [("GC", GC_list), ("Product index", product_index), 
    ("Substrate index", substrate_index), ("Composite", comp_RIP)]
    to_write="\t".join(["Estimate", "Median", "Mean"]) + "\n"
    print(to_write)
    out.write(to_write)
    for name, liste in names_lists :
        to_write = "\t".join([name, str(round(np.median(liste), 4)), str(round(np.mean(liste), 4))] ) + "\n"
        print(to_write)
        out.write(to_write)

