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
  

 ${BCFTOOLS_PATH} query \
  -f '%CHROM\t%POS\t%REF\t%ALT\n' \
  ${vcf_dir}${VCFNAME}.vcf.gz \
  > ${vcf_qual_check_dir}${VCFNAME}.tab


${BCFTOOLS_PATH} query \
  -f '%CHROM\t%POS\t%REF\t%ALT\n' \
  ${vcf_dir}${VCFNAME}.filtered.clean.vcf.gz \
  > ${vcf_qual_check_dir}${VCFNAME}.filtered.clean.tab

done < /home/alice/WW_PopGen/Keep_lists_samples/Repeat_sequencing.txt 


