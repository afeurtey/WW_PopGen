#!/bin/bash

source $1

if [ "${SLURM_ARRAY_TASK_ID}" -eq 0 ] ; 
then 
  CHR="mt";
else
  CHR=${SLURM_ARRAY_TASK_ID} ;
fi

echo "Working on chromosome" $CHR ;

VCFNAME=${VCFBasename}.genotyped.${CHR}

while read clone1 clone2 ; 
  do 
  echo $clone1 $clone2
  

 ${VCFTOOLS_PATH} \
  --gzvcf ${vcf_dir}${VCFNAME}.vcf.gz \
  --indv $clone1 \
  --indv $clone2 \
  --max-missing 1 \
  --max-alleles 3 \
  --counts2 \
  --out ${vcf_qual_check_dir}${VCFNAME}.${clone1}.${SLURM_ARRAY_TASK_ID}

${VCFTOOLS_PATH} \
  --gzvcf ${vcf_dir}${VCFNAME}.filtered.clean.vcf.gz \
  --indv $clone1 \
  --indv $clone2 \
  --max-missing 1 \
  --max-alleles 3 \
  --counts2 \
  --out ${vcf_qual_check_dir}${VCFNAME}.filtered.clean.${clone1}.${SLURM_ARRAY_TASK_ID}


done < /home/alice/WW_PopGen/Keep_lists_samples/Repeat_sequencing.txt 
