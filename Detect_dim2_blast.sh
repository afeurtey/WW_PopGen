#!/bin/bash
source $1
sample=$2

out_file=${DIM_blast}Results_blast_dim2_${sample}.txt

#Getting fastq reads
${SPADES_PATH}spades.py  \
  -o ${DIM_denovo}${sample} \
  --careful \
  -1 ${RAW_READS}${sample}_R1.fastq.gz \
  -2 ${RAW_READS}${sample}_R2.fastq.gz

#
python2 ${SCRIPTS_PATH}Rename_fragments_in_fasta.py  \
    -i ${DIM_denovo}${sample}/scaffolds.fasta \
    -o ${DIM_blast}${sample}.fasta \
    --simple -f spades
    
${BLAST_PATH}makeblastdb \
  -dbtype nucl \
  -in ${DIM_blast}${sample}.fasta \
  -out ${DIM_blast}${sample}
  
${BLAST_PATH}blastn \
  -query ${dim2_seq} \
  -db ${DIM_blast}${sample} \
  -outfmt 6  | \
  awk -v sample="${sample}" 'BEGIN {OFS = " "} {print sample, $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12}' >> \
  $out_file
