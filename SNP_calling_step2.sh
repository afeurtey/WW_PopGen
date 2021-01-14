#!/bin/bash

#(Alice, December 2020; based on Daniel, 10 April 2020)
#Run with: sbatch -J $i -p normal.168h -c 1 

#Imported variables
source $1
i=$2

#Variables
VCFBasename=Ztritici_global_December2020
MAXALT=2
GVCF_list=/home/alice/WW_project/WW_PopGen/GVCF_list.txt

### Genotype 
#$GATK_PATH --java-options '-XX:+UseSerialGC' IndexFeatureFile \
#     --input ${vcf_dir}${VCFBasename}.combined.$i.g.vcf.gz

$GATK_PATH --java-options '-XX:+UseSerialGC' GenotypeGVCFs \
  -L $i \
  -R ${IPO323_REF} \
  -V ${vcf_dir}${VCFBasename}.combined.$i.g.vcf.gz \
  -O ${vcf_dir}${VCFBasename}.genotyped.$i.vcf.gz \
  --max-alternate-alleles $MAXALT

