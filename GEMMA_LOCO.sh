#!/bin/bash

source $1

if [ "${SLURM_ARRAY_TASK_ID}" -eq 0 ] ; 
then 
  CHR="mt";
else
  CHR=${SLURM_ARRAY_TASK_ID} ;
fi

echo "Working on chromosome" $CHR ;
VCFNAME=${VCFBasename}.genotyped.ALL.filtered.clean.AB_filtered.variants.good_samples.max-m-80
PERCHR_VCFNAME=${VCFBasename}.genotyped.${CHR}.filtered.clean.AB_filtered.variants.good_samples.max-m-80
Pheno_fam_file=${GEA_dir}Phenotypes_with_climatic_variables.fam

# Kinship matrix
${VCFTOOLS_PATH} \
  --gzvcf ${vcf_dir}${VCFNAME}.vcf.gz \
  --recode --recode-INFO-all \
  --not-chr ${CHR} \
  --thin 200 \
  --out ${GEA_dir}${VCFNAME}.thin-200bp.wo_${CHR}

${SOFTPATH}plink \
  --vcf ${GEA_dir}${VCFNAME}.thin-200bp.wo_${CHR}.recode.vcf \
  --make-bed \
  --out ${GEA_dir}For_kinship_${CHR} \
  --double-id 

cd ${GEA_dir}
cp ${Pheno_fam_file} For_kinship_${CHR}.fam

gemma \
  -bfile For_kinship_${CHR} \
  -gk 1 \
  -o Kinship_for_chr${CHR}


# Association

${SOFTPATH}plink \
  --vcf ${vcf_dir}${PERCHR_VCFNAME}.recode.vcf.gz \
  --make-bed \
  --out ${GEA_dir}${PERCHR_VCFNAME} \
  --double-id 

cp ${Pheno_fam_file} ${GEA_dir}${PERCHR_VCFNAME}.fam

for i in {1..20} ;
do
gemma \
  -bfile ${GEA_dir}${PERCHR_VCFNAME} \
  -lmm 1 \
  -k output/Kinship_for_chr${CHR}.cXX.txt \
  -o Kinship_for_chr${CHR}_for_phenotype_${i} \
  -n ${i}
done
