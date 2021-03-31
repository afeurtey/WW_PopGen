#!/bin/bash

#This script is the first one for filtering the vcf file.
# It takes the raw vcf file from the GATK variant calling,
# and filters the positions based on the quality thresholds identified with the visualization.


source $1

# Quality thresholds per position
# -------------------------------
FSTHR=10.0
MQTHR=20.0
QDTHR=20.0
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

VCFNAME=${vcf_dir}${VCFBasename}.genotyped.${CHR}
echo $VCFNAME

rm ${VCFNAME}.filtered.vcf.gz
rm ${VCFNAME}.filtered.clean.vcf.gz

# Filtering on the newly set parameters
# -------------------------------------
${GATK_PATH} VariantFiltration  \
 -R ${IPO323_REF} \
 -V ${VCFNAME}.vcf.gz \
 -O ${VCFNAME}.filtered.vcf \
   --filter-expression "FS > $FSTHR " --filter-name "FS_filter" \
   --filter-expression "MQ < $MQTHR"  --filter-name "MQ_filter" \
   --filter-expression "QD < $QDTHR"  --filter-name "QD_filter" \
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
  ${VCFNAME}.vcf.gz \
  > ${vcf_qual_check_dir}${VCFBasename}.genotyped.${CHR}.tab

${BCFTOOLS_PATH} query \
  -f '%CHROM\t%POS\t%REF\t%ALT\n' \
  ${VCFNAME}.filtered.clean.vcf.gz \
  > ${vcf_qual_check_dir}${VCFBasename}.genotyped.${CHR}.filtered.clean.tab

# Allele counts
${VCFTOOLS_PATH} \
   --gzvcf ${vcf_dir}${VCFBasename}.genotyped.${CHR}.filtered.clean.vcf.gz \
   --counts2 \
   --out ${vcf_qual_check_dir}${VCFBasename}.genotyped.${CHR}.filtered.clean
