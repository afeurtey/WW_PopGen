#!/bin/bash

source $1
read1=$2
read2=$3
sample=$4

java -jar ${TRIMMOPATH}trimmomatic-0.39.jar PE \
  ${read1} ${read2} \
  ${FILTERED_READS}${sample}_1_paired.fq.gz ${FILTERED_READS}${sample}_1_unpaired.fq.gz \
  ${FILTERED_READS}${sample}_2_paired.fq.gz ${FILTERED_READS}${sample}_2_unpaired.fq.gz \
  ILLUMINACLIP:${adapt_file}:2:30:10 \
  LEADING:20 TRAILING:20 SLIDINGWINDOW:5:20 MINLEN:50

${SPADES_PATH}spades.py  \
  -o ${DENOVO_ASSEMB}${sample} \
  --careful \
  -1 ${read1} \
  -2 ${read2}

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


