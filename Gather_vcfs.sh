#!/bin/bash

source $1

FSTHR=10.0
MQTHR=20.0
QDTHR=20.0
DPTHR=60000.0
ReadPosRankSum_lower=-2.0
ReadPosRankSum_upper=2.0
MQRankSum_lower=-2.0
MQRankSum_upper=2.0
BaseQRankSum_lower=-2.0
BaseQRankSum_upper=2.0

${GATK_PATH} GatherVcfs \
  --INPUT ${vcf_dir}${VCFBasename}.genotyped.1.filtered.clean.good_samples.SNP.max-m-0.8.maf-0.05.thin-1000bp.recode.vcf \
  --INPUT ${vcf_dir}${VCFBasename}.genotyped.2.filtered.clean.good_samples.SNP.max-m-0.8.maf-0.05.thin-1000bp.recode.vcf \
  --INPUT ${vcf_dir}${VCFBasename}.genotyped.3.filtered.clean.good_samples.SNP.max-m-0.8.maf-0.05.thin-1000bp.recode.vcf \
  --INPUT ${vcf_dir}${VCFBasename}.genotyped.4.filtered.clean.good_samples.SNP.max-m-0.8.maf-0.05.thin-1000bp.recode.vcf \
  --INPUT ${vcf_dir}${VCFBasename}.genotyped.5.filtered.clean.good_samples.SNP.max-m-0.8.maf-0.05.thin-1000bp.recode.vcf \
  --INPUT ${vcf_dir}${VCFBasename}.genotyped.6.filtered.clean.good_samples.SNP.max-m-0.8.maf-0.05.thin-1000bp.recode.vcf \
  --INPUT ${vcf_dir}${VCFBasename}.genotyped.7.filtered.clean.good_samples.SNP.max-m-0.8.maf-0.05.thin-1000bp.recode.vcf \
  --INPUT ${vcf_dir}${VCFBasename}.genotyped.8.filtered.clean.good_samples.SNP.max-m-0.8.maf-0.05.thin-1000bp.recode.vcf \
  --INPUT ${vcf_dir}${VCFBasename}.genotyped.9.filtered.clean.good_samples.SNP.max-m-0.8.maf-0.05.thin-1000bp.recode.vcf \
  --INPUT ${vcf_dir}${VCFBasename}.genotyped.10.filtered.clean.good_samples.SNP.max-m-0.8.maf-0.05.thin-1000bp.recode.vcf \
  --INPUT ${vcf_dir}${VCFBasename}.genotyped.11.filtered.clean.good_samples.SNP.max-m-0.8.maf-0.05.thin-1000bp.recode.vcf \
  --INPUT ${vcf_dir}${VCFBasename}.genotyped.12.filtered.clean.good_samples.SNP.max-m-0.8.maf-0.05.thin-1000bp.recode.vcf \
  --INPUT ${vcf_dir}${VCFBasename}.genotyped.13.filtered.clean.good_samples.SNP.max-m-0.8.maf-0.05.thin-1000bp.recode.vcf \
  --INPUT ${vcf_dir}${VCFBasename}.genotyped.14.filtered.clean.good_samples.SNP.max-m-0.8.maf-0.05.thin-1000bp.recode.vcf \
  --INPUT ${vcf_dir}${VCFBasename}.genotyped.15.filtered.clean.good_samples.SNP.max-m-0.8.maf-0.05.thin-1000bp.recode.vcf \
  --INPUT ${vcf_dir}${VCFBasename}.genotyped.16.filtered.clean.good_samples.SNP.max-m-0.8.maf-0.05.thin-1000bp.recode.vcf \
  --INPUT ${vcf_dir}${VCFBasename}.genotyped.17.filtered.clean.good_samples.SNP.max-m-0.8.maf-0.05.thin-1000bp.recode.vcf \
  --INPUT ${vcf_dir}${VCFBasename}.genotyped.18.filtered.clean.good_samples.SNP.max-m-0.8.maf-0.05.thin-1000bp.recode.vcf \
  --INPUT ${vcf_dir}${VCFBasename}.genotyped.19.filtered.clean.good_samples.SNP.max-m-0.8.maf-0.05.thin-1000bp.recode.vcf \
  --INPUT ${vcf_dir}${VCFBasename}.genotyped.20.filtered.clean.good_samples.SNP.max-m-0.8.maf-0.05.thin-1000bp.recode.vcf \
  --INPUT ${vcf_dir}${VCFBasename}.genotyped.21.filtered.clean.good_samples.SNP.max-m-0.8.maf-0.05.thin-1000bp.recode.vcf \
  --OUTPUT ${vcf_dir}${VCFBasename}.genotyped.ALL.filtered.clean.good_samples.SNP.max-m-0.8.maf-0.05.thin-1000bp.recode.vcf


# create index file
$GATK_PATH IndexFeatureFile -I ${vcf_dir}${VCFBasename}.genotyped.ALL.filtered.clean.good_samples.SNP.max-m-0.8.maf-0.05.thin-1000bp.recode.vcf

