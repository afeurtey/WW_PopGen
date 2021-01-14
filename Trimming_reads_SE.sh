#!/bin/bash

source $1
sample=$2

java -jar ${TRIMMOPATH}trimmomatic-0.39.jar SE \
  ${RAW_READS}${sample}.fastq.gz \
  ${FILTERED_READS}${sample}_1_paired.fq.gz ${FILTERED_READS}${sample}_1_unpaired.fq.gz \
  ${FILTERED_READS}${sample}_2_paired.fq.gz ${FILTERED_READS}${sample}_2_unpaired.fq.gz \
  ILLUMINACLIP:TruSeq3-PE.fa:2:30:10 \
  LEADING:20 TRAILING:20 SLIDINGWINDOW:5:20 MINLEN:50
