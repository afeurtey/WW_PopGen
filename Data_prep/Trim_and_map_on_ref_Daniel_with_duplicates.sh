#!/bin/bash

source $1
read1=$2
read2=$3
sample=$4

java -jar ${TRIMMOPATH}trimmomatic-0.39.jar PE \
  ${RAW_READS}${read1} ${RAW_READS}${read2} \
  ${FILTERED_READS}${sample}_1_paired.fq.gz ${FILTERED_READS}${sample}_1_unpaired.fq.gz \
  ${FILTERED_READS}${sample}_2_paired.fq.gz ${FILTERED_READS}${sample}_2_unpaired.fq.gz \
  ILLUMINACLIP:TruSeq3-PE.fa:2:30:10 \
  LEADING:15 TRAILING:15 SLIDINGWINDOW:5:15 MINLEN:50

n=1
REF=/userhome/genomes/fasta/Zymoseptoria_tritici.MG2.dna.toplevel.mt+

${BOWTIE_PATH} \
  -p $n \
 --very-sensitive-local \
 --phred33 \
 --rg-id ${sample} --rg SM:${sample} \
 -x ${IPO323_REF} \
 -1 ${FILTERED_READS}${sample}_1_paired.fq.gz \
 -2 ${FILTERED_READS}${sample}_2_paired.fq.gz \
 -S ${mapped_dir}${sample}.sam

samtools view -bS ${mapped_dir}${sample}.sam | samtools sort -o ${mapped_dir}${sample}.bam
samtools index ${mapped_dir}${sample}.bam

rm ${mapped_dir}${sample}.bam


# GATK HaplotypeCaller

GATK=/userhome/software/gatk-4.1.4.1/gatk
REF=/userhome/genomes/fasta/Zymoseptoria_tritici.MG2.dna.toplevel.mt+

$GATK \
  --java-options '-XX:+UseSerialGC' \
  HaplotypeCaller \
  -R ${IPO323_REF} \
  -ploidy 1 \
  -I ${mapped_dir}${sample}.bam \
  --emit-ref-confidence GVCF \
  --native-pair-hmm-threads $n \
  -O ${gvcf_dir}${sample}.gvcf
