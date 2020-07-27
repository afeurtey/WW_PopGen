#!/bin/bash

source $1
sample=$2

java -jar ${TRIMMOPATH}trimmomatic-0.39.jar PE \
  ${RAW_READS}${sample}_1.fastq.gz ${RAW_READS}${sample}_2.fastq.gz \
  ${FILTERED_READS}${sample}_1_paired.fq.gz ${FILTERED_READS}${sample}_1_unpaired.fq.gz \
  ${FILTERED_READS}${sample}_2_paired.fq.gz ${FILTERED_READS}${sample}_2_unpaired.fq.gz \
  ILLUMINACLIP:${adapt_file}:2:30:10 \
  LEADING:20 TRAILING:20 SLIDINGWINDOW:5:20 MINLEN:50
