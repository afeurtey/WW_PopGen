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

if [ "${SLURM_ARRAY_TASK_ID}" -eq 0 ] ; 
then 
  CHR="mt";
else
  CHR=${SLURM_ARRAY_TASK_ID} ;
fi

echo "Working on chromosome" $CHR ;

#VCFNAME=${DIRNAME}1_Variant_calling/4_Joint_calling/Ztritici_global_December2020.genotyped.${CHR}
VCFNAME=${vcf_dir}${VCFBasename}.genotyped.${CHR}
echo $VCFNAME

#Cleaning the file per pos and ind
${GATK_PATH} SelectVariants  \
  -R ${IPO323_REF} \
  -V ${VCFNAME}.filtered.vcf \
  --exclude-sample-name ${remove_ID_file} \
  --exclude-sample-name ${low_depth_samples_file} \
  --exclude-sample-name ${clones_file}  \
  --exclude-filtered \
  --exclude-non-variants --remove-unused-alternates \
  -O ${VCFNAME}.filtered.clean.good_samples.vcf
  

gzip -f ${VCFNAME}.filtered.vcf
gzip -f ${VCFNAME}.filtered.clean.good_samples.vcf


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
  
