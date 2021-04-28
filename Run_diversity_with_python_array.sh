#!/bin/sh

source $1
file_list=$2

samples=$(head -n $SLURM_ARRAY_TASK_ID $file_list | tail -n1) 

python Diversity_with_python.py  \
   --vcf_file ${vcf_dir}${VCFBasename}.genotyped.ALL.filtered.clean.AB_filtered.variants.good_samples.max-m-80.vcf.gz \
   --bed_file ${div_dir}Windows_for_diversity.bed \
   --sample_list ${nuc_PS_dir}${samples} \
   --out_dir ${div_dir}
