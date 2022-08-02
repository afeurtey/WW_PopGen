#!/bin/bash

# This script runs GEMMA
# It has the option of running on subsets of isolates (see options below)
# Example command line: sbatch --array=0-13%2 ./GEMMA_LOCO.sh ./Directories_new.sh /data2/alice/WW_project/5_GEA/Phenotypes_with_climatic_variables_BIO13.fam BIO13 1
source $1
Pheno_fam_file=$2 #A fam formatted file containing only the samples of interest and the phenotypes
sub_name=$3 #A name to add to the files. For ex, ALL or BIO6 or European
Nb_phenotypes=$4 #The number of phenotypes to read from the Pheno_fam_file

CONDA_BASE=$(conda info --base)
source ${CONDA_BASE}/etc/profile.d/conda.sh
conda activate env0

if [ "${SLURM_ARRAY_TASK_ID}" -eq 0 ] ;
then
  CHR="mt";
else
  CHR=${SLURM_ARRAY_TASK_ID} ;
fi

echo "#--------"
echo "Working on chromosome" $CHR ;
echo ""
VCFNAME=${VCFBasename}.genotyped.ALL.filtered.clean.AB_filtered.variants.good_samples.max-m-80
PERCHR_VCFNAME=${VCFBasename}.genotyped.${CHR}.filtered.clean.AB_filtered.variants.good_samples.max-m-80
#PERCHR_VCFNAME=${VCFBasename}.${sub_name}.${CHR}
#Pheno_fam_file=${GEA_dir}Phenotypes_with_climatic_variables.fam
subset_file=${GEA_dir}Subset_isolates_${SLURM_ARRAY_JOB_ID}_${SLURM_ARRAY_TASK_ID}.txt

awk 'BEGIN {OFS = "\t"} {print $1, $1}' ${Pheno_fam_file} > ${subset_file}
echo "Let's look at the number of samples in the subset_file"
wc -l ${Pheno_fam_file} ${subset_file}
echo "#--------"


echo ""
echo ""
echo "#--------"
echo "Kinship: Transforming vcf to thin, exclude a chromosome, and subset samples"
echo "#--------"
# Kinship matrix
${VCFTOOLS_PATH} \
  --gzvcf ${vcf_dir}${VCFNAME}.vcf.gz \
  --recode --recode-INFO-all \
  --not-chr ${CHR} \
  --thin 200 \
  --out ${GEA_dir}${VCFNAME}.${sub_name}.thin-200bp.wo_${CHR}

${SOFTPATH}plink \
  --vcf ${GEA_dir}${VCFNAME}.${sub_name}.thin-200bp.wo_${CHR}.recode.vcf \
  --make-bed \
  --keep ${subset_file} \
  --out ${GEA_dir}For_kinship.${sub_name}.${CHR} \
  --double-id --biallelic-only strict


cd ${GEA_dir}
mv For_kinship.${sub_name}.${CHR}.fam For_kinship.${sub_name}.${CHR}.from_plink.fam
cp ${Pheno_fam_file} For_kinship.${sub_name}.${CHR}.fam
echo -e "\nIf you want to make sure that your phenotype files contains the samples in the right order,"
echo "you can compare the files", For_kinship.${sub_name}.${CHR}.from_plink.fam, "and"
echo "your own phenotype files."

echo ""
echo ""
echo "#--------"
echo "Kinship: Run GEMMA to get kinship matrix without the chromosome" $CHR
echo "#--------"
gemma \
  -bfile For_kinship.${sub_name}.${CHR} \
  -gk 1 \
  -o Kinship.${sub_name}.${CHR}

echo "Kinship matrix is done"
echo ""
echo ""
echo "*****************************"
echo ""


# Association
echo ""
echo "#--------"
echo "GWAS: Subset vcf for GWAS"
echo "#--------"
${SOFTPATH}plink \
  --vcf ${vcf_dir}${PERCHR_VCFNAME}.recode.vcf.gz \
  --make-bed \
  --keep ${subset_file} \
  --out ${GEA_dir}${PERCHR_VCFNAME}.${sub_name} \
  --double-id \
  --biallelic-only strict \
  --maf 0.01

#Association with standardized values
echo ""
echo "#--------"
echo "GWAS: Run GEMMA on phenotype of interest"
echo "#--------"
cp ${Pheno_fam_file} ${GEA_dir}${PERCHR_VCFNAME}.${sub_name}.fam

for (( c=1; c<=$Nb_phenotypes; c++ ));
do
gemma \
  -bfile ${GEA_dir}${PERCHR_VCFNAME}.${sub_name} \
  -lmm 1 \
  -k output/Kinship.${sub_name}.${CHR}.cXX.txt \
  -o GEMMA.chr${CHR}.phenotype_${c}.subset_${sub_name} \
  -n ${c}
#  -c ${WWTERIP_DIR}2_GWAS/PC_for_correction.cov \

done

#Cleaning
rm ${subset_file}
rm ${GEA_dir}${VCFNAME}.${sub_name}.thin-200bp.wo_${CHR}.recode.vcf
