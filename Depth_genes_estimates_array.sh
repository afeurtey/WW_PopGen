#!/bin/sh

source $1
sample_list=$2
col_nb=$3

sample=$(head -n $SLURM_ARRAY_TASK_ID $sample_list | tail -n1 | cut -f $3) 
echo $sample 
temp_file=${pan_DP_gene}temp_${SLURM_ARRAY_JOB_ID}_${SLURM_ARRAY_TASK_ID}.txt

#Per gene
$BEDTOOLS_PATH coverage \
  -a $IPO323_GFF \
  -b ${mapped_dir}${sample}.bam \
  -d | \
awk -v id="$sample" 'BEGIN{OFS = "\t"} {print id ";" $1 ";" $9, $10, $11} ' > ${temp_file}
$BEDTOOLS_PATH groupby -i ${temp_file} -g 1 -c 3 -o median > \
  ${pan_DP_gene}${sample}.depth_per_gene.txt ;
rm ${temp_file}
echo "Genes are done!"
