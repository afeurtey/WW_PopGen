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

rm ${VCFNAME}.filtered.vcf.gz
rm ${VCFNAME}.filtered.clean.vcf.gz

#Filtering on the newly set parameters
${GATK_PATH} VariantFiltration  \
 -R ${IPO323_REF} \
 -V ${VCFNAME}.vcf.gz \
 -O ${VCFNAME}.filtered.vcf \
   --filter-expression "FS > $FSTHR " --filter-name "FS_filter" \
   --filter-expression "MQ < $MQTHR"  --filter-name "MQ_filter" \
   --filter-expression "QD < $QDTHR"  --filter-name "QD_filter" \
   --filter-expression "DP > $DPTHR"  --filter-name "DP_filter" \
   --genotype-filter-expression "DP < 3"   --genotype-filter-name "Low_depth"   --set-filtered-genotype-to-no-call   \
   --filter-expression 'ReadPosRankSum < $ReadPosRankSum_lower' --filter-name 'ReadPosRankSumL' \
   --filter-expression 'ReadPosRankSum > $ReadPosRankSum_upper' --filter-name 'ReadPosRankSumH' \
   --filter-expression 'MQRankSum < $MQRankSum_lower' --filter-name 'MQRankSumL'\
   --filter-expression 'MQRankSum > $MQRankSum_upper' --filter-name 'MQRankSumH' \
   --filter-expression 'BaseQRankSum < $BaseQRankSum_lower' --filter-name 'BaseQRankSumL' \
   --filter-expression 'BaseQRankSum > $BaseQRankSum_upper' --filter-name 'BaseQRankSumH' 


#Cleaning the file per pos
${GATK_PATH} SelectVariants  \
  -R ${IPO323_REF} \
  -V ${VCFNAME}.filtered.vcf \
  --exclude-filtered \
  --exclude-non-variants --remove-unused-alternates \
  -O ${VCFNAME}.filtered.clean.vcf
  
gzip -f ${VCFNAME}.filtered.vcf
gzip -f ${VCFNAME}.filtered.clean.vcf

# Transforming to tab without genotypes to get stats
${BCFTOOLS_PATH} query \
  -f '%CHROM\t%POS\t%REF\t%ALT\n' \
  ${vcf_dir}${VCFNAME}.vcf.gz \
  > ${vcf_qual_check_dir}${VCFNAME}.tab

# Get all variants in one file
${BCFTOOLS_PATH} concat \
  --output ${vcf_dir}${VCFBasename}.genotyped.ALL.filtered.clean.vcf.gz \
  --output-type  z \
  ${vcf_dir}${VCFBasename}.genotyped.1.filtered.clean.vcf.gz \
  ${vcf_dir}${VCFBasename}.genotyped.2.filtered.clean.vcf.gz \
  ${vcf_dir}${VCFBasename}.genotyped.3.filtered.clean.vcf.gz \
  ${vcf_dir}${VCFBasename}.genotyped.4.filtered.clean.vcf.gz \
  ${vcf_dir}${VCFBasename}.genotyped.5.filtered.clean.vcf.gz \
  ${vcf_dir}${VCFBasename}.genotyped.6.filtered.clean.vcf.gz \
  ${vcf_dir}${VCFBasename}.genotyped.7.filtered.clean.vcf.gz \
  ${vcf_dir}${VCFBasename}.genotyped.8.filtered.clean.vcf.gz \
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
  ${vcf_dir}${VCFBasename}.genotyped.mt.filtered.clean.vcf.gz

# Estimate IBS 
${SOFTPATH}plink \
  --vcf ${vcf_dir}${VCFBasename}.genotyped.ALL.filtered.clean.vcf.gz \
  --distance ibs \
  --double-id \
  --out ${vcf_dir}${VCFBasename}.genotyped.ALL.filtered.clean

# Transforming to tab without genotypes to get stats after filtering
${BCFTOOLS_PATH} query \
  -f '%CHROM\t%POS\t%REF\t%ALT\n' \
  ${vcf_dir}${VCFBasename}.genotyped.ALL.filtered.clean.vcf.gz \
  > ${vcf_qual_check_dir}${VCFBasename}.genotyped.ALL.filtered.clean.tab
