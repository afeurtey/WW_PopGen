#!/bin/bash
source $1
p=$2
echo $p

#conda activate env0

# TE reads and RIP per isolate
# ----------------------------

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
