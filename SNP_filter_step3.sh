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
#${BCFTOOLS_PATH} query \
#  -f '%CHROM\t%POS\t%REF\t%ALT\n' \
#  ${VCFNAME}.filtered.clean.AB_filtered.variants.good_samples.vcf.gz \
#  > ${vcf_qual_check_dir}${VCFBasename}.genotyped.ALL.filtered.clean.AB_filtered.variants.good_samples.tab

# Allele counts
#${VCFTOOLS_PATH} \
#   --gzvcf ${vcf_dir}${VCFBasename}.genotyped.ALL.filtered.clean.AB_filtered.variants.good_samples.vcf.gz \
#   --counts2 \
#   --out ${vcf_qual_check_dir}${VCFBasename}.genotyped.ALL.filtered.clean.AB_filtered.variants.good_samples


#  ---------------------
# | Missing data filter |
#  ---------------------

while read CHR nb threshold ;
do
   
   ${VCFTOOLS_PATH} --gzvcf ${vcf_dir}${VCFBasename}.genotyped.ALL.filtered.clean.AB_filtered.variants.good_samples.vcf.gz \
      --recode --recode-INFO-all \
      --chr  $CHR \
      --max-missing-count ${threshold} \
      --out ${vcf_dir}${VCFBasename}.genotyped.${CHR}.filtered.clean.AB_filtered.variants.good_samples.max-m-80

   gzip ${vcf_dir}${VCFBasename}.genotyped.${CHR}.filtered.clean.AB_filtered.variants.good_samples.max-m-80.recode.vcf

done < ${NA_thresholds}


${BCFTOOLS_PATH} concat \
  -o ${vcf_dir}${VCFBasename}.genotyped.ALL.filtered.clean.AB_filtered.variants.good_samples.max-m-80.vcf.gz \
  --output-type  z \
  ${vcf_dir}${VCFBasename}.genotyped.1.filtered.clean.AB_filtered.variants.good_samples.max-m-80.recode.vcf.gz \
  ${vcf_dir}${VCFBasename}.genotyped.2.filtered.clean.AB_filtered.variants.good_samples.max-m-80.recode.vcf.gz \
  ${vcf_dir}${VCFBasename}.genotyped.3.filtered.clean.AB_filtered.variants.good_samples.max-m-80.recode.vcf.gz \
  ${vcf_dir}${VCFBasename}.genotyped.4.filtered.clean.AB_filtered.variants.good_samples.max-m-80.recode.vcf.gz \
  ${vcf_dir}${VCFBasename}.genotyped.5.filtered.clean.AB_filtered.variants.good_samples.max-m-80.recode.vcf.gz \
  ${vcf_dir}${VCFBasename}.genotyped.6.filtered.clean.AB_filtered.variants.good_samples.max-m-80.recode.vcf.gz \
  ${vcf_dir}${VCFBasename}.genotyped.7.filtered.clean.AB_filtered.variants.good_samples.max-m-80.recode.vcf.gz \
  ${vcf_dir}${VCFBasename}.genotyped.8.filtered.clean.AB_filtered.variants.good_samples.max-m-80.recode.vcf.gz \
  ${vcf_dir}${VCFBasename}.genotyped.9.filtered.clean.AB_filtered.variants.good_samples.max-m-80.recode.vcf.gz \
  ${vcf_dir}${VCFBasename}.genotyped.10.filtered.clean.AB_filtered.variants.good_samples.max-m-80.recode.vcf.gz \
  ${vcf_dir}${VCFBasename}.genotyped.11.filtered.clean.AB_filtered.variants.good_samples.max-m-80.recode.vcf.gz \
  ${vcf_dir}${VCFBasename}.genotyped.12.filtered.clean.AB_filtered.variants.good_samples.max-m-80.recode.vcf.gz \
  ${vcf_dir}${VCFBasename}.genotyped.13.filtered.clean.AB_filtered.variants.good_samples.max-m-80.recode.vcf.gz \
  ${vcf_dir}${VCFBasename}.genotyped.14.filtered.clean.AB_filtered.variants.good_samples.max-m-80.recode.vcf.gz \
  ${vcf_dir}${VCFBasename}.genotyped.15.filtered.clean.AB_filtered.variants.good_samples.max-m-80.recode.vcf.gz \
  ${vcf_dir}${VCFBasename}.genotyped.16.filtered.clean.AB_filtered.variants.good_samples.max-m-80.recode.vcf.gz \
  ${vcf_dir}${VCFBasename}.genotyped.17.filtered.clean.AB_filtered.variants.good_samples.max-m-80.recode.vcf.gz \
  ${vcf_dir}${VCFBasename}.genotyped.18.filtered.clean.AB_filtered.variants.good_samples.max-m-80.recode.vcf.gz \
  ${vcf_dir}${VCFBasename}.genotyped.19.filtered.clean.AB_filtered.variants.good_samples.max-m-80.recode.vcf.gz \
  ${vcf_dir}${VCFBasename}.genotyped.20.filtered.clean.AB_filtered.variants.good_samples.max-m-80.recode.vcf.gz \
  ${vcf_dir}${VCFBasename}.genotyped.21.filtered.clean.AB_filtered.variants.good_samples.max-m-80.recode.vcf.gz \
  ${vcf_dir}${VCFBasename}.genotyped.mt.filtered.clean.AB_filtered.variants.good_samples.max-m-80.recode.vcf.gz


# Transform in tab file without genotypes to get stats
${BCFTOOLS_PATH} query \
  -f '%CHROM\t%POS\t%REF\t%ALT\n' \
  ${VCFNAME}.filtered.clean.AB_filtered.variants.good_samples.max-m-80.vcf.gz \
  > ${vcf_qual_check_dir}${VCFBasename}.genotyped.ALL.filtered.clean.AB_filtered.variants.good_samples.max-m-80.tab



#   -----------------------------------
# | Create additional, subset VCF files |
#   -----------------------------------

# for diversity analyses: biallelic SNPs only
${VCFTOOLS_PATH} --gzvcf ${VCFNAME}.filtered.clean.AB_filtered.variants.good_samples.max-m-80.vcf.gz \
        --recode --recode-INFO-all --remove-filtered-all --remove-indels \
        --min-alleles 2 --max-alleles 2 \
        --out ${VCFNAME}.filtered.clean.AB_filtered.variants.good_samples.max-m-80.biall_SNP

# for population genetics: biallelic SNPs only, max-missing 100, 5% MAF, thinned to 1 per 1000 bp
${VCFTOOLS_PATH} --gzvcf ${VCFNAME}.filtered.clean.AB_filtered.variants.good_samples.max-m-80.biall_SNP.recode.vcf \
        --recode --recode-INFO-all --remove-filtered-all --remove-indels \
        --mac 1 --thin 1000 \
        --max-missing 1 \
        --min-alleles 2 --max-alleles 2 \
        --maf 0.05 \
        --out ${VCFNAME}.filtered.clean.AB_filtered.variants.good_samples.biall_SNP.max-m-1.maf-0.05.thin-1000bp
