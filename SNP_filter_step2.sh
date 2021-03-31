#!/bin/bash

#This script takes quality filtered vcf files per chromosomes.
#It concatenate all the vcf files in one, and filters on AB.
#It also estimates different per samples stats (depth, NA and IBS).

source $1

#  ------------------------------------
#|  Gathering files and filtering on AB |
#  ------------------------------------

# Get all variants in one file
${BCFTOOLS_PATH} concat \
  ${vcf_dir}${VCFBasename}.genotyped.1.filtered.clean.vcf.gz \
  ${vcf_dir}${VCFBasename}.genotyped.2.filtered.clean.vcf.gz \
  ${vcf_dir}${VCFBasename}.genotyped.3.filtered.clean.vcf.gz \
  ${vcf_dir}${VCFBasename}.genotyped.4.filtered.clean.vcf.gz \
  ${vcf_dir}${VCFBasename}.genotyped.5.filtered.clean.vcf.gz \
  ${vcf_dir}${VCFBasename}.genotyped.6.filtered.clean.vcf.gz \
  ${vcf_dir}${VCFBasename}.genotyped.7.filtered.clean.vcf.gz \
  ${vcf_dir}${VCFBasename}.genotyped.8.filtered.clean.vcf.gz \
  ${vcf_dir}${VCFBasename}.genotyped.9.filtered.clean.vcf.gz \
  ${vcf_dir}${VCFBasename}.genotyped.10.filtered.clean.vcf.gz \
  ${vcf_dir}${VCFBasename}.genotyped.11.filtered.clean.vcf.gz \
  ${vcf_dir}${VCFBasename}.genotyped.12.filtered.clean.vcf.gz \
  ${vcf_dir}${VCFBasename}.genotyped.13.filtered.clean.vcf.gz \
  ${vcf_dir}${VCFBasename}.genotyped.14.filtered.clean.vcf.gz \
  ${vcf_dir}${VCFBasename}.genotyped.15.filtered.clean.vcf.gz \
  ${vcf_dir}${VCFBasename}.genotyped.16.filtered.clean.vcf.gz \
  ${vcf_dir}${VCFBasename}.genotyped.17.filtered.clean.vcf.gz \
  ${vcf_dir}${VCFBasename}.genotyped.18.filtered.clean.vcf.gz \
  ${vcf_dir}${VCFBasename}.genotyped.19.filtered.clean.vcf.gz \
  ${vcf_dir}${VCFBasename}.genotyped.20.filtered.clean.vcf.gz \
  ${vcf_dir}${VCFBasename}.genotyped.21.filtered.clean.vcf.gz \
  ${vcf_dir}${VCFBasename}.genotyped.mt.filtered.clean.vcf.gz | \
  ${BCFTOOLS_PATH} view \
  --targets-file ^${vcf_qual_check_dir}Erroneous_positions_from_resequencing.tsv \
  -o ${vcf_dir}${VCFBasename}.genotyped.ALL.filtered.clean.vcf.gz \
  --output-type  z 

# Filtering samples with allelic balance indicative of failed genotyping
python Filter_vcf_on_AB.py \
   --input ${vcf_dir}${VCFNAME}.filtered.clean.vcf.gz \
   --gzipped --set_filtered_gt_to_nocall \
   --out ${vcf_dir}${VCFNAME}.filtered.clean.AB_filtered.vcf

 ${GATK_PATH} SelectVariants \
   -R ${IPO323_REF} \
   -V ${vcf_dir}${VCFNAME}.filtered.clean.AB_filtered.vcf \
   --exclude-filtered  --exclude-non-variants --remove-unused-alternates  \
   -O ${vcf_dir}${VCFNAME}.filtered.clean.AB_filtered.variants.vcf
   
gzip ${vcf_dir}${VCFNAME}.filtered.clean.AB_filtered.variants.vcf
gzip ${vcf_dir}${VCFNAME}.filtered.clean.AB_filtered.vcf




#  ----------------------------------
#|  Estimating per sample information |
#  ----------------------------------

#Depth
${VCFTOOLS_PATH} \
  --gzvcf ${vcf_dir}${VCFBasename}.genotyped.ALL.filtered.clean.AB_filtered.variants.vcf.gz \
  --out ${vcf_dir}${VCFBasename}.genotyped.ALL.filtered.AB_filtered.variants.clean \
  --depth \
  --not-chr 14 \
  --not-chr 15 \
  --not-chr 16 \
  --not-chr 17 \
  --not-chr 18 \
  --not-chr 19 \
  --not-chr 20 \
  --not-chr 21 \
  --not-chr mt


#Missing data
${VCFTOOLS_PATH} \
  --gzvcf ${vcf_dir}${VCFBasename}.genotyped.ALL.filtered.clean.AB_filtered.variants.vcf.gz  \
  --out ${vcf_dir}${VCFBasename}.genotyped.ALL.filtered.clean.AB_filtered.variants \
  --missing-indv  \
  --not-chr 14 \
  --not-chr 15 \
  --not-chr 16 \
  --not-chr 17 \
  --not-chr 18 \
  --not-chr 19 \
  --not-chr 20 \
  --not-chr 21 \
  --not-chr mt


#IBS
${SOFTPATH}plink \
  --distance square ibs \
  --vcf ${vcf_dir}${VCFBasename}.genotyped.ALL.filtered.clean.AB_filtered.variants.vcf.gz \
  --out ${vcf_dir}${VCFBasename}.genotyped.ALL.filtered.clean.AB_filtered.variants \
  --const-fid \
  --not-chr 14-21 mt



#  --------------------------------
#|  Extracting positions for stats  |
#  --------------------------------

#Transform to tab for stats
${BCFTOOLS_PATH} query \
  -f '%CHROM\t%POS\t%REF\t%ALT\n' \
  ${vcf_dir}${VCFBasename}.genotyped.ALL.filtered.clean.vcf.gz \
  > ${vcf_qual_check_dir}${VCFBasename}.genotyped.ALL.filtered.clean.tab

${BCFTOOLS_PATH} query \
  -f '%CHROM\t%POS\t%REF\t%ALT\n' \
  ${vcf_dir}${VCFBasename}.genotyped.ALL.filtered.clean.AB_filtered.variants.vcf.gz \
  > ${vcf_qual_check_dir}${VCFBasename}.genotyped.ALL.filtered.clean.AB_filtered.variants.tab

