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

while read clone1 clone2 ; 
  do 
  echo $clone1 $clone2
  

${BCFTOOLS_PATH}  view  \
 -Ov -s  ${clone1},${clone2} \
 ${vcf_dir}${VCFNAME}.vcf.gz | \
 ${BCFTOOLS_PATH} query \
  -f '%CHROM\t%POS\t%REF\t%ALT[\t%GT]\n' | 
 awk '$5 != $6 && $5 != "." && $6 != "." {print}' \
  > ${vcf_qual_check_dir}${VCFNAME}.${clone1}.tab


${BCFTOOLS_PATH}  view  \
 -Ov -s  ${clone1},${clone2} \
 ${vcf_dir}${VCFNAME}.filtered.clean.vcf.gz| \
 ${BCFTOOLS_PATH} query \
  -f '%CHROM\t%POS\t%REF\t%ALT[\t%GT]\n' | 
 awk '$5 != $6 && $5 != "." && $6 != "." {print}' \
  > ${vcf_qual_check_dir}${VCFNAME}.filtered.clean.${clone1}.tab

done < /home/alice/WW_PopGen/Keep_lists_samples/Repeat_sequencing.txt 

