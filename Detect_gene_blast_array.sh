#!/bin/bash

source $1
gene_fasta=$2
sample_list=$3
assembly_type=$4
out_dir=$5

#out_file=${DIM_blast}Results_blast_${sample}.txt

while read sample ;
do c=$((${c}+1)) ;
if [ "$c" -eq $SLURM_ARRAY_TASK_ID ] ;
then
if [ $assembly_type = "PacBio" ] ;
then
# PacBio
${BLAST_PATH}makeblastdb \
  -dbtype nucl \
  -in ${PB_ASSEMB}${sample}.fasta \
  -out ${DENOVO_ASSEMB}${sample}

else
# Illumina
python2 ${SCRIPTS_PATH}Rename_fragments_in_fasta.py  \
    -i ${DENOVO_ASSEMB}${sample}/scaffolds.fasta \
    -o ${DENOVO_ASSEMB}${sample}.fasta \
    --simple -f spades
    
${BLAST_PATH}makeblastdb \
  -dbtype nucl \
  -in ${DENOVO_ASSEMB}${sample}.fasta \
  -out ${DENOVO_ASSEMB}${sample}

fi;

gene=$(echo $gene_fasta | rev | cut -d "/" -f1 | rev | cut -d "."  -f1)

${BLAST_PATH}blastn \
  -query ${gene_fasta} \
  -db ${DENOVO_ASSEMB}${sample} \
  -outfmt 6 | \
  awk -v sample="${sample}" -v gene="${gene}" 'BEGIN {OFS = " "} {print sample, gene, $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12}' > \
  ${out_dir}${sample}.blast.tab

fi;

done < $sample_list
