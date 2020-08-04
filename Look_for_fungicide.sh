#!/bin/bash

#need python with biopython

source $1
SAMPLES=$2
BED=$3 # tab-delim table with loci/codons (see below) NOT A BED AT ALL

cd ${WW_fung_dir}
#$TABIX_PATH -p vcf $IPO323_VCF
mkdir -p temp_files

# looping through the table of codons/loci
while IFS=$'\t' read -r -a myArray
do
  # picking up the correct columns from the input table
  chr=${myArray[4]}
  start=${myArray[8]}
  end=${myArray[9]}
  strand=${myArray[7]}
  gene=${myArray[1]}
  codon=${myArray[2]}

  # now looping through each sample to get the same position
  while read line
    do
	  sample=$line
    ${SAMTOOLS_PATH} faidx $IPO323_REF "$chr:$start-$end" | \
      ${BCFTOOLS_PATH} consensus \
        --sample $sample \
        -o temp_files/$gene.$codon.$sample.fa \
        ${IPO323_VCF}
        
    sed -i "/>/ s/>.*/>$sample/" temp_files/$gene.$codon.$sample.fa
  done < $SAMPLES
  
  # combine files per locus
  cat temp_files/$gene.$codon.*.fa > $gene.$codon.tmp.fa
  rm temp_files/$gene.$codon.*.fa
  
  # perform rev. comp. with seqk if "-", otherwise just translate
  if [ $strand = "-" ]; then
	   seqkit seq -r -p $gene.$codon.tmp.fa > $gene.$codon.fa
  else
	  cat $gene.$codon.tmp.fa > $gene.$codon.fa
  fi

  seqkit translate $gene.$codon.fa > $gene.$codon.final.fa
  
done < $BED

### Combine all files into large table
AllFiles=$(find . -name "*.final.fa")
echo $AllFiles > genotypes.txt
paste $AllFiles >> genotypes.txt

cat > ./temp.py << EOL
from Bio import SeqIO
import glob
temp = glob.glob("./*final.fa")
out = open("genotypes_tidy_format.tab", "w")
for filename in temp :
     for record in SeqIO.parse(filename, "fasta"):
             to_write = [filename.replace(".final.fa", "").replace("./", "")] 
             to_write.append(record.id.replace("_frame=1", ""))
             to_write.append(str(record.seq))
             out.write("\t".join(to_write))
             out.write("\n")
out.close()

EOL

python ./temp.py
