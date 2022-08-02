#!/bin/bash

# Written by Alice Feurtey in 2020
# This script detects a (gene) sequence in an assembly, through blast.
# It takes a fasta file and a sample name (corresponding to a sample_name.fasta assembly)
# It will output the tabular blast format 6 with the name of the gene (fasta file name) and the name of the sample added to it.


# Command line inputs
source $1 # File containing the path to software and files
gene_fasta=$2 # A fasta file giving the gene sequence to blast
sample=$3 # This is the sample name (which should correspond to the file names as well)
assembly_type=$4 # Values are PacBio or Illumina
out_file=$5 #The full path of the output file


#out_file=${DIM_blast}Results_blast_${sample}.txt

#    --------
#  |  Script  |
#    --------

#Making a blast database
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

fi


# Running the blast and changing the output format a little
gene=$(echo $gene_fasta | rev | cut -d "/" -f1 | rev | cut -d "."  -f1)

rm $out_file
${BLAST_PATH}blastn \
  -query ${gene_fasta} \
  -db ${DENOVO_ASSEMB}${sample} \
  -outfmt 6 | \
  awk -v sample="${sample}" -v gene="${gene}" 'BEGIN {OFS = " "} {print sample, gene, $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12}' >> \
  $out_file
