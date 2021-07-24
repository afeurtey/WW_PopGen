#!/bin/bash

source $1
sample=$2

java -jar ${TRIMMOPATH}trimmomatic-0.39.jar SE \
  ${RAW_READS}${sample}.fastq.gz \
  ${FILTERED_READS}${sample}.fq.gz \
  ILLUMINACLIP:TruSeq3-PE.fa:2:30:10 \
  LEADING:15 TRAILING:15 SLIDINGWINDOW:5:15 MINLEN:50

n=1

${BOWTIE_PATH} \
  -p $n \
 --very-sensitive-local \
 --phred33 \
 --rg-id ${sample} --rg SM:${sample} \
 -x ${IPO323_REF} \
 -U ${FILTERED_READS}${sample}.fq.gz \
 -S ${mapped_dir}${sample}.sam

samtools view -bS ${mapped_dir}${sample}.sam | samtools sort -o ${mapped_dir}${sample}.bam
samtools index ${mapped_dir}${sample}.bam

rm ${mapped_dir}${sample}.sam


# GATK HaplotypeCaller


#$GATK_PATH \
#  --java-options '-XX:+UseSerialGC' \
#  HaplotypeCaller \
#  -R ${IPO323_REF} \
#  -ploidy 1 \
#  -I ${mapped_dir}${sample}.bam \
#  --emit-ref-confidence GVCF \
#  --native-pair-hmm-threads $n \
#  -O ${gvcf_dir}${sample}.gvcf
