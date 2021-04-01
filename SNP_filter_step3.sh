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
#${GATK_PATH} IndexFeatureFile \
# -I ${VCFNAME}.filtered.clean.AB_filtered.variants.vcf.gz

#${GATK_PATH} SelectVariants  \
#  -R ${IPO323_REF} \
#  -V ${VCFNAME}.filtered.clean.AB_filtered.variants.vcf.gz \
#  --exclude-sample-name ${low_depth_samples_file} \
#  --exclude-sample-name ${clones_file}  \
#  --exclude-filtered \
#  --exclude-non-variants --remove-unused-alternates \
#  -O ${VCFNAME}.filtered.clean.AB_filtered.variants.good_samples.vcf


#gzip -f ${VCFNAME}.filtered.clean.AB_filtered.variants.good_samples.vcf


# Transform in tab file without genotypes to get stats
${BCFTOOLS_PATH} query \
  -f '%CHROM\t%POS\t%REF\t%ALT\n' \
  ${VCFNAME}.filtered.clean.AB_filtered.variants.good_samples.vcf.gz \
  > ${vcf_qual_check_dir}${VCFBasename}.genotyped.ALL.filtered.clean.AB_filtered.variants.good_samples.tab

# Allele counts
${VCFTOOLS_PATH} \
   --gzvcf ${vcf_dir}${VCFBasename}.genotyped.ALL.filtered.clean.AB_filtered.variants.good_samples.vcf.gz \
   --counts2 \
   --out ${vcf_qual_check_dir}${VCFBasename}.genotyped.ALL.filtered.clean.AB_filtered.variants.good_samples


#   -----------------------------------
# | Create additional, subset VCF files |
#   -----------------------------------

# for diversity analyses: biallelic SNPs only
${VCFTOOLS_PATH} --gzvcf ${VCFNAME}.filtered.clean.AB_filtered.variants.good_samples.vcf.gz \
        --recode --recode-INFO-all --remove-filtered-all --remove-indels \
        --min-alleles 2 --max-alleles 2 \
        --out ${VCFNAME}.filtered.clean.AB_filtered.variants.good_samples.biall_SNP

# for diversity analyses: biallelic SNPs only, max-missing 80%
${VCFTOOLS_PATH} --gzvcf ${VCFNAME}.filtered.clean.AB_filtered.variants.good_samples.biall_SNP.vcf.gz \
        --recode --recode-INFO-all --remove-filtered-all --remove-indels \
        --min-alleles 2 --max-alleles 2 \
        --max-missing 0.8 \
        --out ${VCFNAME}.filtered.clean.AB_filtered.variants.good_samples.biall_SNP.max-m-80

# for population genetics: biallelic SNPs only, max-missing 100, 5% MAF, thinned to 1 per 1000 bp
${VCFTOOLS_PATH} --gzvcf ${VCFNAME}.filtered.clean.AB_filtered.variants.good_samples.biall_SNP.max-m-80.recode.vcf \
        --recode --recode-INFO-all --remove-filtered-all --remove-indels \
        --mac 1 --thin 1000 \
        --max-missing 1 \
        --min-alleles 2 --max-alleles 2 \
        --maf 0.05 \
        --out ${VCFNAME}.filtered.clean.AB_filtered.variants.good_samples.biall_SNP.max-m-1.maf-0.05.thin-1000bp
