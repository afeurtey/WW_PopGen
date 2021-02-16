#!/bin/sh

source $1
sample_list=$2


sample=$(head -n $SLURM_ARRAY_TASK_ID $sample_list | tail -n1 | cut -f 2) 
echo $sample 

#Per gene
$BEDTOOLS_PATH coverage \
  -a $IPO323_GFF \
  -b ${mapped_dir}${sample}.bam \
  -d | \
awk 'BEGIN{OFS = "\t"} {print $1 ";" $9, $10, $11} ' > temp${SLURM_ARRAY_TASK_ID}.txt
$BEDTOOLS_PATH groupby -i temp${SLURM_ARRAY_TASK_ID}.txt -g 1 -c 3 -o median > \
  ${pan_DP_gene}${sample}.depth_per_gene.txt ;
rm temp${SLURM_ARRAY_TASK_ID}.txt
echo "Genes are done!"
