#!/bin/bash

source $1
read_name=$2
sample=$3

read1=${RAW_READS}${read_name}_R1.fastq.gz
read2=${RAW_READS}${read_name}_R2.fastq.gz


${SPADES_PATH}spades.py  \
  -o ${DENOVO_ASSEMB}${sample} \
  --continue

${BOWTIE_PATH} \
 --very-sensitive-local \
 --phred33 \
 --rg-id ${sample} --rg SM:${sample} \
 -x ${PAN_REF} \
 -1 ${FILTERED_READS}${sample}_1_paired.fq.gz \
 -2 ${FILTERED_READS}${sample}_2_paired.fq.gz \
 -S ${pan_mapped}${sample}.sam

${SAMTOOLS_PATH} view -bS ${pan_mapped}${sample}.sam | ${SAMTOOLS_PATH}  sort -o ${pan_mapped}${sample}.bam
${SAMTOOLS_PATH} index ${pan_mapped}${sample}.bam
rm ${pan_mapped}${sample}.sam


