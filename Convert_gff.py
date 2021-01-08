from Bio import SeqIO
from collections import defaultdict
Contigs = defaultdict(list)
CNV_dir = "/Users/feurtey/Documents/Postdoc_Bruce/Projects/WW_PopGen/CNV/"
for record in SeqIO.parse(CNV_dir + "all_19_pangenome.fa",  "fasta"):
    if "_0[" in record.id :
        contig = record.id.split("_0[")[0]
        coord = record.id.strip("]").split("_0[")[1].split(":")
        Contigs[contig].append([record.id] + coord)
    elif record.id.startswith("chr") :
        pass
    else :
        contig = record.id.split("_1[")[0]
        coord = record.id.strip("]").split("_1[")[1].split(":")
        Contigs[contig].append([record.id] + coord)

out = open(CNV_dir + "all_19_pangenome.fasta_names.converted_coord.gff", "w")

with open(CNV_dir + "all_19_pangenome.fasta_names.gff") as gff:
    for i, ligne in enumerate(gff) :
        written = False

        sp = ligne.strip().split()

        # The genes from the reference genome have their own treatment
        if sp[0].startswith("chr") :
             out.write("\t".join(sp) + "\n")

        # Removing "non-content" lines
        elif not ligne.strip() :
            pass
        elif ligne.startswith("#") :
            pass

        #Checking whether the whole mRNA is included in the pangenome contigs
        elif sp[2] == "mRNA" :
            good_coords = False
            for coords in Contigs[sp[0]] :
                if int(coords[1]) <= int(sp[3]) <= int(coords[2]) :
                    if int(coords[1]) <= int(sp[4]) <= int(coords[2]) :
                        good_coords = True
                        to_write = [coords[0]] + sp[1:3] +  [str(int(sp[3]) - int(coords[1])), str(int(sp[4]) - int(coords[1]))] + sp[5:]
                        out.write("\t".join(to_write) + "\n")
                        break
        # For every exon for which the whole parent mRNA is included
        # I will convert the coordinates using the variable "coords" which is the last one from above
        else :
            if good_coords :
                to_write = [coords[0]] + sp[1:3] +  [str(int(sp[3]) - int(coords[1])), str(int(sp[4]) - int(coords[1]))] + sp[5:]
                out.write("\t".join(to_write) + "\n")

out.close()
