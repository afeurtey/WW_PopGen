#!/bin/bash
source $1
list=$2
col_nb=$3

p=$(head -n $SLURM_ARRAY_TASK_ID $list | tail -n1 | cut -f $3) 

#conda activate env0

#Convert

${BEDTOOLS_PATH} bamtofastq \
  -i ${mapped_dir}${p}.bam \
  -fq ${RIP_raw1}${p}.fq 


# TE reads and RIP per isolate
# ----------------------------

#Aligning paired reads as single on the TE consensus sequences
${BOWTIE_PATH}  --no-unal -x ${TE_REF} \
  -U ${RIP_raw1}${p}.fq \
  -S ${RIP_aln}${p}.sam \
  --very-sensitive-local --no-unal 

rm ${RIP_raw1}${p}.fq

#Getting back the aligning reads as fq
if [ ! -f  ${RIP_aln}${p}.fq ] ; then
 rm ${RIP_aln}${p}.fq  ;
fi

if [ ! -f ${RIP_aln}${p}.bam ] ; then
  rm ${RIP_aln}${p}.bam
fi

${BEDTOOLS_PATH} bamtofastq -i ${RIP_aln}${p}.sam \
  -fq ${RIP_aln}${p}.fq

${SAMTOOLS_PATH} sort -O bam -o ${RIP_aln}${p}.bam  ${RIP_aln}${p}.sam
${SAMTOOLS_PATH} index ${RIP_aln}${p}.bam
rm ${RIP_aln}${p}.sam

#Measuring RIP stats in the aligning reads

python ${SCRIPTS_PATH}GC_RIP_per_read_fastq.py \
   --out ${RIP_est}${p}.RIP_est \
   --input_format fastq  \
   ${RIP_aln}${p}.fq

rm ${RIP_aln}${p}.fq.gz
gzip ${RIP_aln}${p}.fq

# Per TE
# ------

ls_TE=$(grep ">" ${TE_REF}.fasta | sed 's/>//')

#Rerun the same script as above, 
# except TE per TE this time
for TE in $ls_TE; 
do 

  if [ ! -f ${RIP_aln}Per_TE/${p}.${TE}.fq ] ; then
     rm ${RIP_aln}Per_TE/${p}.${TE}.fq  ;
  fi 
 
  if [ ! -f  ${RIP_aln}Per_TE/${p}.${TE}.bam ] ; then
     rm ${RIP_aln}Per_TE/${p}.${TE}.bam ;
  fi

  ${SAMTOOLS_PATH} view \
    ${RIP_aln}${p}.bam ${TE} -b \
    > ${RIP_aln}Per_TE/${p}.${TE}.bam

  ${BEDTOOLS_PATH} bamtofastq -i ${RIP_aln}Per_TE/${p}.${TE}.bam \
    -fq ${RIP_aln}Per_TE/${p}.${TE}.fq

  python ${SCRIPTS_PATH}GC_RIP_per_read_fastq.py \
    --out ${RIP_est}${p}.${TE} \
    --input_format fastq  \
    ${RIP_aln}Per_TE/${p}.${TE}.fq

  rm ${RIP_aln}Per_TE/${p}.${TE}.fq.gz 
  gzip ${RIP_aln}Per_TE/${p}.${TE}.fq
done
