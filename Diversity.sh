#!/bin/bash

source $1

for CHR in {1..21};
do

gzip ${vcf_dir}${VCFBasename}.genotyped.${CHR}.filtered.clean.good_samples.SNP.max-m-0.8.recode.vcf

${VCFTOOLS_PATH} \
   --gzvcf ${vcf_dir}${VCFBasename}.genotyped.${CHR}.filtered.clean.good_samples.SNP.max-m-0.8.recode.vcf.gz \
   --out ${vcf_dir}${VCFBasename}.genotyped.${CHR}.filtered.clean.good_samples.SNP.max-m-0.8 \
   --depth 


${VCFTOOLS_PATH} \
   --gzvcf ${vcf_dir}${VCFBasename}.genotyped.${CHR}.filtered.clean.good_samples.SNP.max-m-0.8.recode.vcf.gz \
   --haploid --window-pi 1000 \
   --out ${div_dir}${VCFBasename}.genotyped.${CHR}.filtered.clean.good_samples.SNP.max-m-0.8


${VCFTOOLS_PATH} \
   --gzvcf ${vcf_dir}${VCFBasename}.genotyped.${CHR}.filtered.clean.good_samples.SNP.max-m-0.8.recode.vcf.gz \
   --haploid --TajimaD  1000 \
   --out ${div_dir}${VCFBasename}.genotyped.${CHR}.filtered.clean.good_samples.SNP.max-m-0.8

done
