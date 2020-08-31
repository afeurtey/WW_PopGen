#!/bin/bash

source $1
sample=$2

out_file=${DIM_blast}Results_blast_dim2_${sample}.txt

#Getting fastq reads

#python2 ${SCRIPTS_PATH}Rename_fragments_in_fasta.py  \
#    -i ${DENOVO_ASSEMB}${sample}/scaffolds.fasta \
#    -o ${DIM_denovo}${sample}.fasta \
#    --simple -f spades
    
#${BLAST_PATH}makeblastdb \
#  -dbtype nucl \
#  -in ${DIM_denovo}${sample}.fasta \
#  -out ${DIM_denovo}${sample}
 
rm $out_file 
${BLAST_PATH}blastn \
  -query ${dim2_seq} \
  -db ${DIM_denovo}${sample} \
  -outfmt 6  | \
  awk -v sample="${sample}" -v gene="dim2" 'BEGIN {OFS = " "} {print sample, gene, $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12}' >> \
  $out_file

${BLAST_PATH}blastn \
  -query ${dim2_flank1} \
  -db ${DIM_denovo}${sample} \
  -outfmt 6  | \
  awk -v sample="${sample}" -v gene="dim2_flank1" 'BEGIN {OFS = " "} {print sample, gene, $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12}' >> \
  $out_file

${BLAST_PATH}blastn \
  -query ${dim2_flank2} \
  -db ${DIM_denovo}${sample} \
  -outfmt 6  | \
  awk -v sample="${sample}" -v gene="dim2_flank2" 'BEGIN {OFS = " "} {print sample, gene, $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12}' >> \
  $out_file
