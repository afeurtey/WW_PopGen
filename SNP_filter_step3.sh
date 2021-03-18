#!/bin/bash

source $1

#VCFNAME=${DIRNAME}1_Variant_calling/4_Joint_calling/Ztritici_global_December2020.genotyped.${CHR}
VCFNAME=${vcf_dir}${VCFBasename}.genotyped.ALL

#${BCFTOOLS_PATH}  sort \
# -O z -o ${VCFNAME}.filtered.clean.sorted.vcf.gz \
# --temp-dir ${vcf_dir} \
# ${VCFNAME}.filtered.clean.vcf.gz 

#Cleaning the file per pos and ind
${GATK_PATH} IndexFeatureFile \
 -I ${VCFNAME}.filtered.clean.vcf.gz

${GATK_PATH} SelectVariants  \
  -R ${IPO323_REF} \
  -V ${VCFNAME}.filtered.clean.vcf.gz \
  --exclude-sample-name ${low_depth_samples_file} \
  --exclude-sample-name ${clones_file}  \
  --exclude-filtered \
  --exclude-non-variants --remove-unused-alternates \
  -O ${VCFNAME}.filtered.clean.good_samples.vcf
  

gzip -f ${VCFNAME}.filtered.clean.good_samples.vcf

# Transform in tab file without genotypes to get stats
${BCFTOOLS_PATH} query \
  -f '%CHROM\t%POS\t%REF\t%ALT\n' \
  ${vcf_dir}${VCFNAME}.filtered.clean.good_samples.vcf.gz \
  > ${vcf_qual_check_dir}${VCFNAME}.filtered.clean.good_samples.tab

#Create additional, subset VCF files

# for diversity analyses: SNPs only, max-missing 80%
${VCFTOOLS_PATH} --gzvcf ${VCFNAME}.filtered.clean.good_samples.vcf.gz \
        --recode --recode-INFO-all --remove-filtered-all --remove-indels \
        --max-missing 0.8 \
        --out ${VCFNAME}.filtered.clean.good_samples.SNP.max-m-0.8

# for population genetics: SNPs only, max-missing, 5% MAF, thinned to 1 per 1000 bp
${VCFTOOLS_PATH} --gzvcf ${VCFNAME}.filtered.clean.good_samples.vcf.gz \
        --recode --recode-INFO-all --remove-filtered-all --remove-indels \
        --mac 1 --thin 1000 \
        --max-missing 0.8 \
        --maf 0.05 \
        --out ${VCFNAME}.filtered.clean.good_samples.SNP.max-m-0.8.maf-0.05.thin-1000bp
  
