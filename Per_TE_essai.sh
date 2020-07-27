#!/bin/bash
p=$1
bam_dir=$2
echo $p

conda activate env0

BWAPATH=/userhome/alice/Software/bwa-0.7.17/
BEDTOOLS_PATH=/userhome/alice/Software/
SAMTOOLS_PATH=/userhome/alice/Software/samtools-1.10/
BOWTIE_PATH=/userhome/alice/Software/bowtie2-2.4.1-linux-x86_64/
SCRIPTS_PATH=/userhome/alice/Scripts/
REF_NAME=/userhome/alice/WW_project/WW_TE_RIP/Badet_BMC_Biology_2020_TE_consensus_sequences

# Files directories
WWTERIP_DIR=/data3/alice/WW_project/WW_TE_RIP/
RIP_DIR=${WWTERIP_DIR}0_RIP_estimation/
RIP_raw0=${RIP_DIR}0_BAM_temp/
RIP_raw1=${RIP_DIR}1_Fastq_from_bam/
RIP_aln=${RIP_DIR}2_Aln_TE_consensus/
RIP_est=${RIP_DIR}3_RIP_estimation/

DIM2_DIR=${WWTERIP_DIR}1_Ztdim2_detection/


#script
ls_TE=$(grep ">" ${REF_NAME}.fasta | sed 's/>//')

${SAMTOOLS_PATH}samtools sort -O bam -o ${RIP_aln}${p}.bam  ${RIP_aln}${p}.sam
${SAMTOOLS_PATH}samtools index ${RIP_aln}${p}.bam

for TE in $ls_TE; 
do 
  ${SAMTOOLS_PATH}samtools view \
    ${RIP_aln}${p}.bam ${TE} -b \
    > ${RIP_aln}Per_TE/${p}.${TE}.bam

  ${BEDTOOLS_PATH}bedtools bamtofastq -i ${RIP_aln}Per_TE/${p}.${TE}.bam \
    -fq ${RIP_aln}Per_TE/${p}.${TE}.fq

python ${SCRIPTS_PATH}GC_RIP_per_read_fastq.py \
   --out ${RIP_est}${p}.${TE} \
   --input_format fastq  \
   ${RIP_aln}Per_TE/${p}.${TE}.fq

done
