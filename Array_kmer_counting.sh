#!/bin/bash

source $1
sample_list=$2


# Creating directories and lists of read files
#while read sample read1 read2; do mkdir /data2/alice/WW_project/4_TE_RIP/3_kmers_GWAS/${sample} ; echo /data2/alice/WW_project/0_Data/0_Raw_reads/${read1} > /data2/alice/WW_project/4_TE_RIP/3_kmers_GWAS/${sample}/${sample}_files.txt ; echo /data2/alice/WW_project/0_Data/0_Raw_reads/${read2} >> /data2/alice/WW_project/4_TE_RIP/3_kmers_GWAS/${sample}/${sample}_files.txt ; done < Keep_lists_samples/list_convert_Novogene_2020_reads_1.txt
#while read sample read1 read2; do echo /data2/alice/WW_project/0_Data/0_Raw_reads/${read1} >> /data2/alice/WW_project/4_TE_RIP/3_kmers_GWAS/${sample}/${sample}_files.txt ; echo /data2/alice/WW_project/0_Data/0_Raw_reads/${read2} >> /data2/alice/WW_project/4_TE_RIP/3_kmers_GWAS/${sample}/${sample}_files.txt ; done < Keep_lists_samples/list_convert_Novogene_2020_reads_2.txt


#Different dataset have different list configurations so here are some possibilities. 
#Change before running the script 
#sample=$(head -n $SLURM_ARRAY_TASK_ID $sample_list | tail -n1 | cut -f 1)
#read1=$(head -n $SLURM_ARRAY_TASK_ID $sample_list | tail -n1 | cut -f 2) 
#read2=$(head -n $SLURM_ARRAY_TASK_ID $sample_list | tail -n1 | cut -f 3) 

sample=$(head -n $SLURM_ARRAY_TASK_ID $sample_list | tail -n1 | cut -f 2)
prefix=$(head -n $SLURM_ARRAY_TASK_ID $sample_list | tail -n1 | cut -f 1)
read1=${prefix}_R1.fastq.gz
read2=${prefix}_R2.fastq.gz

mkdir /data2/alice/WW_project/4_TE_RIP/3_kmers_GWAS/${sample}

# Filtering the reads
java -jar ${TRIMMOPATH}trimmomatic-0.39.jar PE \
  ${RAW_READS}${read1} ${RAW_READS}${read2} \
  ${FILTERED_READS}${sample}_1_paired.fq.gz ${FILTERED_READS}${sample}_1_unpaired.fq.gz \
  ${FILTERED_READS}${sample}_2_paired.fq.gz ${FILTERED_READS}${sample}_2_unpaired.fq.gz \
  ILLUMINACLIP:TruSeq3-PE.fa:2:30:10 \
  LEADING:15 TRAILING:15 SLIDINGWINDOW:5:15 MINLEN:50

echo ${FILTERED_READS}${sample}_1_paired.fq.gz > /data2/alice/WW_project/4_TE_RIP/3_kmers_GWAS/${sample}/${sample}_files.txt 
echo ${FILTERED_READS}${sample}_2_paired.fq.gz >> /data2/alice/WW_project/4_TE_RIP/3_kmers_GWAS/${sample}/${sample}_files.txt 


# Running the kmer counting
/home/alice/Software/kmer_gwas/external_programs/kmc_v3 \
  -t1 -k31 -ci2  \
  @/data2/alice/WW_project/4_TE_RIP/3_kmers_GWAS/${sample}/${sample}_files.txt \
   /data2/alice/WW_project/4_TE_RIP/3_kmers_GWAS/${sample}/output_kmc_canon \
   /data2/alice/WW_project/4_TE_RIP/3_kmers_GWAS/${sample}/

/home/alice/Software/kmer_gwas/external_programs/kmc_v3 \
  -t1 -k31 -ci0 -b \
  @/data2/alice/WW_project/4_TE_RIP/3_kmers_GWAS/${sample}/${sample}_files.txt \
  /data2/alice/WW_project/4_TE_RIP/3_kmers_GWAS/${sample}/output_kmc_all \
  /data2/alice/WW_project/4_TE_RIP/3_kmers_GWAS/${sample}/

#Gathering both types of info
/home/alice/Software/kmer_gwas/bin/kmers_add_strand_information \
  -c /data2/alice/WW_project/4_TE_RIP/3_kmers_GWAS/${sample}/output_kmc_canon \
  -n /data2/alice/WW_project/4_TE_RIP/3_kmers_GWAS/${sample}/output_kmc_all \
  -k 31 \
  -o /data2/alice/WW_project/4_TE_RIP/3_kmers_GWAS/${sample}/kmers_with_strand


#Removing large intermediate files
rm /data2/alice/WW_project/4_TE_RIP/3_kmers_GWAS/${sample}/output_kmc_all.kmc_pre
rm /data2/alice/WW_project/4_TE_RIP/3_kmers_GWAS/${sample}/output_kmc_all.kmc_suf
rm /data2/alice/WW_project/4_TE_RIP/3_kmers_GWAS/${sample}/output_kmc_canon.kmc_pre
rm /data2/alice/WW_project/4_TE_RIP/3_kmers_GWAS/${sample}/output_kmc_canon.kmc_suf


