#!/bin/bash

source $1
sample=$2


${BOWTIE_PATH} \
 --very-sensitive-local \
 --phred33 \
 --rg-id ${sample} --rg SM:${sample} \
 -x ${PAN_REF} \
 -1 ${FILTERED_READS}${sample}_1_paired.fq.gz \
 -2 ${FILTERED_READS}${sample}_2_paired.fq.gz \
 -S ${pan_mapped}${sample}.sam

${SAMTOOLS_PATH} view -bS ${pan_mapped}${sample}.sam | ${SAMTOOLS_PATH}  sort -o ${pan_mapped}STnnJGI_${sample}.bam
${SAMTOOLS_PATH} index ${pan_mapped}${sample}.bam
#rm ${pan_mapped}${sample}.sam


