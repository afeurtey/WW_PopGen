#!/bin/bash
source $1
list=$2

#conda activate env0

c=0;
while read p  read1 read2 ; 
#while read read1 p ;
do c=$((${c}+1)) ; 
if [ "$c" -eq $SLURM_ARRAY_TASK_ID ] ; 
then echo $c $p $read1 $read2 ;

# TE reads and RIP per isolate
# ----------------------------

#Aligning paired reads as single on the TE consensus sequences
${BOWTIE_PATH}  --no-unal -x ${TE_REF} \
  -U ${FILTERED_READS}${p}_1_paired.fq.gz,${FILTERED_READS}${p}_2_paired.fq.gz \
  -S ${RIP_aln}${p}.sam \
  --very-sensitive-local --no-unal 

#Getting back the aligning reads as fq
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
gzip ${RIP_aln}${p}.fq

# Per TE
# ------

ls_TE=$(grep ">" ${TE_REF}.fasta | sed 's/>//')

#Rerun the same script as above, 
# except TE per TE this time
for TE in $ls_TE; 
do 
  ${SAMTOOLS_PATH} view \
    ${RIP_aln}${p}.bam ${TE} -b \
    > ${RIP_aln}Per_TE/${p}.${TE}.bam

  ${BEDTOOLS_PATH} bamtofastq -i ${RIP_aln}Per_TE/${p}.${TE}.bam \
    -fq ${RIP_aln}Per_TE/${p}.${TE}.fq

  python ${SCRIPTS_PATH}GC_RIP_per_read_fastq.py \
    --out ${RIP_est}${p}.${TE} \
    --input_format fastq  \
    ${RIP_aln}Per_TE/${p}.${TE}.fq
  
  gzip ${RIP_aln}Per_TE/${p}.${TE}.fq
done

fi ;
done < $list
