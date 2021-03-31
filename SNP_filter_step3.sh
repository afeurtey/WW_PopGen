#!/bin/bash

# This script is the final filtering script.
# It takes the vcf file after all per-position filtering is done,
# and removes samples that had either low depth, high missing data or are clones from another, better quality sample.
# It also creates subset of the data for general analyses (such as the population structure)

source $1

VCFNAME=${vcf_dir}${VCFBasename}.genotyped.ALL


#  ---------------------------
# | Remove bad quality samples |
#  ---------------------------

#Cleaning the file per pos and ind
${GATK_PATH} IndexFeatureFile \
 -I ${VCFNAME}.filtered.clean.AB_filtered.variants.vcf.gz

${GATK_PATH} SelectVariants  \
  -R ${IPO323_REF} \
  -V ${VCFNAME}.filtered.clean.AB_filtered.variants.vcf.gz \
  --exclude-sample-name ${low_depth_samples_file} \
  --exclude-sample-name ${clones_file}  \
  --exclude-filtered \
  --exclude-non-variants --remove-unused-alternates \
  -O ${VCFNAME}.filtered.clean.AB_filtered.variants.good_samples.vcf
  

gzip -f ${VCFNAME}.filtered.clean.AB_filtered.variants.good_samples.vcf

# Transform in tab file without genotypes to get stats
${BCFTOOLS_PATH} query \
  -f '%CHROM\t%POS\t%REF\t%ALT\n' \
  ${vcf_dir}${VCFNAME}.filtered.clean.AB_filtered.variants.good_samples.vcf.gz \
  > ${vcf_qual_check_dir}${VCFNAME}.filtered.clean.AB_filtered.variants.good_samples.tab

# Allele counts
${VCFTOOLS_PATH} \
   --gzvcf ${vcf_dir}${VCFBasename}.genotyped.${CHR}.filtered.clean.AB_filtered.variants.good_samples.vcf.gz \
   --counts2 \
   --out ${vcf_qual_check_dir}${VCFBasename}.genotyped.${CHR}.filtered.clean.AB_filtered.variants.good_samples


#   -----------------------------------
# | Create additional, subset VCF files |
#   -----------------------------------

# for diversity analyses: SNPs only, max-missing 80%
${VCFTOOLS_PATH} --gzvcf ${VCFNAME}.filtered.clean.AB_filtered.variants.good_samples.vcf.gz \
        --recode --recode-INFO-all --remove-filtered-all --remove-indels \
        --max-missing 0.8 \
        --out ${VCFNAME}.filtered.clean.good_samples.SNP.max-m-0.8

# for population genetics: SNPs only, max-missing, 5% MAF, thinned to 1 per 1000 bp
${VCFTOOLS_PATH} --gzvcf ${VCFNAME}.filtered.clean.AB_filtered.variants.good_samples.vcf.gz \
        --recode --recode-INFO-all --remove-filtered-all --remove-indels \
        --mac 1 --thin 1000 \
        --max-missing 0.8 \
        --maf 0.05 \
        --out ${VCFNAME}.filtered.clean.AB_filtered.variants.good_samples.SNP.max-m-0.8.maf-0.05.thin-1000bp
  

