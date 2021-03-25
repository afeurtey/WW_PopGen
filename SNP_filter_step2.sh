#!/bin/bash

source $1

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

#Depth
${VCFTOOLS_PATH} \
  --gzvcf ${vcf_dir}${VCFBasename}.genotyped.ALL.filtered.clean.vcf.gz \
  --out ${vcf_dir}${VCFBasename}.genotyped.ALL.filtered.clean \
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
  --gzvcf ${vcf_dir}${VCFBasename}.genotyped.ALL.filtered.clean.vcf.gz  \
  --out ${vcf_dir}${VCFBasename}.genotyped.ALL.filtered.clean \
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
  --vcf ${vcf_dir}${VCFBasename}.genotyped.ALL.filtered.clean.vcf.gz \
  --out ${vcf_dir}${VCFBasename}.genotyped.ALL.filtered.clean \
  --const-fid \
  --not-chr 14-21 mt

#Transform to tab for stats
${BCFTOOLS_PATH} query \
  -f '%CHROM\t%POS\t%REF\t%ALT\n' \
  ${vcf_dir}${VCFBasename}.genotyped.ALL.filtered.clean.vcf.gz \
  > ${vcf_qual_check_dir}${VCFBasename}.genotyped.ALL.filtered.clean.tab

