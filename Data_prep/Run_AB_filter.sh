#!/bin/bash

#This script takes a list of repeated sequencing in pairs
#with one line per pair. It then extract the variants from 
#these pairs into tab files. This is done before and after 
#filtering on positions.x

source $1

if [ "${SLURM_ARRAY_TASK_ID}" -eq 0 ] ; 
then 
  CHR="mt";
else
  CHR=${SLURM_ARRAY_TASK_ID} ;
fi

echo "Working on chromosome" $CHR ;

VCFNAME=${VCFBasename}.genotyped.${CHR}


python ./Filter_vcf_on_AB.sh \
  --input ${vcf_dir}${VCFNAME}.filtered.clean.vcf.gz \
  --out ${vcf_dir}${VCFNAME}.filtered.clean.AB_filtered \
  --set_filtered_gt_to_nocall


