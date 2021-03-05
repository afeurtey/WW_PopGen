#!/bin/bash

source $1

if [ "${SLURM_ARRAY_TASK_ID}" -eq 0 ] ; 
then 
  CHR="mt";
else
  CHR=${SLURM_ARRAY_TASK_ID} ;
fi

echo "Working on chromosome" $CHR ;
VCFNAME=${vcf_dir}${VCFBasename}.genotyped.${CHR}
Pheno_fam_file=${GEA_dir}Phenotypes_with_climatic_variables.fam

# Kinship matrix
#${VCFTOOLS_PATH} \
#  --gzvcf ${vcf_dir}${VCFBasename}.genotyped.ALL.filtered.clean.good_samples.SNP.max-m-0.8.maf-0.05.thin-1000bp.recode.vcf.gz \
#  --recode --recode-INFO-all \
#  --not-chr ${CHR} \
#  --out ${GEA_dir}${VCFBasename}.genotyped.ALL.filtered.clean.good_samples.SNP.max-m-0.8.maf-0.05.thin-1000bp.wo_${CHR}

#${SOFTPATH}plink \
#  --vcf ${GEA_dir}${VCFBasename}.genotyped.ALL.filtered.clean.good_samples.SNP.max-m-0.8.maf-0.05.thin-1000bp.wo_${CHR}.recode.vcf \
#  --make-bed \
#  --out ${GEA_dir}For_kinship_${CHR} \
#  --double-id 

cd ${GEA_dir}
cp ${Pheno_fam_file} For_kinship_${CHR}.fam

#gemma \
#  -bfile For_kinship_${CHR} \
#  -gk 1 \
#  -o Kinship_for_chr${CHR}


# Association

${SOFTPATH}plink \
  --vcf ${vcf_dir}${VCFBasename}.genotyped.${CHR}.filtered.clean.good_samples.SNP.max-m-0.8.recode.vcf.gz \
  --make-bed \
  --out ${GEA_dir}${VCFBasename}.genotyped.${CHR}.filtered.clean.good_samples.SNP.max-m-0.8 \
  --double-id 

cp ${Pheno_fam_file} ${GEA_dir}${VCFBasename}.genotyped.${CHR}.filtered.clean.good_samples.SNP.max-m-0.8.fam

for i in {1..19} ;
do
gemma \
  -bfile ${GEA_dir}${VCFBasename}.genotyped.${CHR}.filtered.clean.good_samples.SNP.max-m-0.8 \
  -lmm 1 \
  -k output/Kinship_for_chr${CHR}.cXX.txt \
  -o Kinship_for_chr${CHR}_for_phenotype_${i} \
  -n ${i}
done
