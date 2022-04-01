#!/bin/bash

source $1
group_args=$2

VCFNAME=${vcf_dir}${VCFBasename}.genotyped.ALL


#  ---------------------------
# | Remove bad quality samples |
#  ---------------------------

#Cleaning the file per pos and ind
#gunzip ${VCFNAME}.filtered.clean.AB_filtered.variants.good_samples.max-m-80.vcf.gz

#${GATK_PATH} IndexFeatureFile \
# -I ${VCFNAME}.filtered.clean.AB_filtered.variants.good_samples.max-m-80.vcf.gz

#${GATK_PATH} SelectVariants  \
#  -R ${IPO323_REF} \
#  -V ${VCFNAME}.filtered.clean.AB_filtered.variants.good_samples.max-m-80.vcf.gz \
#  --sample-name ${group_args} \
#  --exclude-filtered \
#  --exclude-non-variants --remove-unused-alternates \
#  -O ${group_args%args}vcf

#gzip ${group_args%args}vcf

java -jar ${SNPEFF_PATH}snpEff.jar -ud 1000 \
    Zt09 \
    ${group_args%args}vcf.gz \
    > ${group_args%args}ann.vcf

gzip ${group_args%args}ann.vcf

${BCFTOOLS_PATH} query \
  -f '%CHROM\t%POS\t%REF\t%ALT\t%INFO/ANN\n' ${group_args%args}ann.vcf.gz > \
   ${group_args%args}ann.tsv

#rm ${group_args%args}.vcf.gz 
