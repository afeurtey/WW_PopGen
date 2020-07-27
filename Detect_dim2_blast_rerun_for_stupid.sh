#!/bin/bash

sample=$1
out_file=/data3/alice/WW_project/WW_TE_RIP/1_Ztdim2_detection/1_Blast_from_denovo_assemblies/Results_blast_dim2_${sample}.txt


#Software directories
BWAPATH=/userhome/alice/Software/bwa-0.7.17/
BEDTOOLS_PATH=/userhome/alice/Software/
SAMTOOLS_PATH=/userhome/alice/Software/samtools-1.10/
BOWTIE_PATH=/userhome/alice/Software/bowtie2-2.4.1-linux-x86_64/
SCRIPTS_PATH=/userhome/alice/Scripts/
REF_NAME=/userhome/alice/WW_project/WW_TE_RIP/Badet_BMC_Biology_2020_TE_consensus_sequences
SPADES_PATH=/userhome/alice/Software/SPAdes-3.14.1-Linux/bin/
BLAST_PATH=/userhome/alice/Software/ncbi-blast-2.10.0+/bin/

# Files directories
DATA_DIR=/data3/alice/WW_project/Data/
WWTERIP_DIR=/data3/alice/WW_project/WW_TE_RIP/
RIP_DIR=${WWTERIP_DIR}0_RIP_estimation/
RIP_raw0=${RIP_DIR}0_BAM_temp/
RIP_raw1=${RIP_DIR}1_Fastq_from_bam/
RIP_aln=${RIP_DIR}2_Aln_TE_consensus/
RIP_est=${RIP_DIR}3_RIP_estimation/
DIM2_DIR=${WWTERIP_DIR}1_Ztdim2_detection/1_Blast_from_denovo_assemblies/
DIM_denovo=${DIM2_DIR}0_Spades/
DIM_blast=${DIM2_DIR}1_Blast_dim2_deRIPped/


#Getting fastq reads
${SPADES_PATH}spades.py  \
  -o ${DIM_denovo}${sample} \
  --continue 

#
python2 ${SCRIPTS_PATH}Rename_fragments_in_fasta.py  \
    -i ${DIM_denovo}${sample}/scaffolds.fasta \
    -o ${DIM_blast}${sample}.fasta \
    --simple -f spades
    
${BLAST_PATH}makeblastdb \
  -dbtype nucl \
  -in ${DIM_blast}${sample}.fasta \
  -out ${DIM_blast}${sample}
  
${BLAST_PATH}blastn \
  -query /userhome/alice/WW_project/WW_TE_RIP/Zt10_dim2_from_MgDNMT_deRIP.fa \
  -db ${DIM_blast}${sample} \
  -outfmt 6  | \
  awk -v sample="${sample}" 'BEGIN {OFS = " "} {print sample, $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12}' >> \
  $out_file
