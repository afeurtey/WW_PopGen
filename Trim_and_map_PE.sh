#!/bin/bash

source $1
sample=$2

java -jar ${TRIMMOPATH}trimmomatic-0.39.jar PE \
  ${RAW_READS}${sample}_R1.fastq.gz ${RAW_READS}${sample}_R2.fastq.gz \
  ${FILTERED_READS}${sample}_1_paired.fq.gz ${FILTERED_READS}${sample}_1_unpaired.fq.gz \
  ${FILTERED_READS}${sample}_2_paired.fq.gz ${FILTERED_READS}${sample}_2_unpaired.fq.gz \
  ILLUMINACLIP:${adapt_file}:2:30:10 \
  LEADING:20 TRAILING:20 SLIDINGWINDOW:5:20 MINLEN:50

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


