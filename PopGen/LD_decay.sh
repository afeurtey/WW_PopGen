#!/bin/bash 

#Expect 4 arguments.
#  1 - the file with the paths to directories and software
#  2 - a file containing the list of samples to keep
#  3 - a suffix to add to the subset vcf and to the LD file
#  4 - a file containing the windows over which to compute the LD

source $1
subset_file=$2
out_suffix=$3
windows_file=$4

${VCFTOOLS_PATH} \
     --gzvcf ${vcf_dir}${VCFBasename}.genotyped.ALL.filtered.clean.AB_filtered.variants.good_samples.max-m-80.vcf.gz  \
     --keep ${subset_file}  \
     --min-alleles 2 --max-alleles 2 --mac 1   --recode --recode-INFO-all  \
     --out  ${vcf_dir}${VCFBasename}.genotyped.ALL.filtered.clean.AB_filtered.variants.good_samples.max-m-80.${out_suffix}

gzip ${vcf_dir}${VCFBasename}.genotyped.ALL.filtered.clean.AB_filtered.variants.good_samples.max-m-80.${out_suffix}.recode.vcf

echo -e "Start\tStop\tMean\tMedian\tSstdev" > ${nuc_PS_dir}LD_${out_suffix}.tab
while read start stop ; do
   results=$(${VCFTOOLS_PATH} \
                   --gzvcf ${vcf_dir}${VCFBasename}.genotyped.ALL.filtered.clean.AB_filtered.variants.good_samples.max-m-80.${out_suffix}.recode.vcf.gz \
                   --ld-window-bp-min $start --ld-window-bp $stop   --hap-r2  --stdout | \
               grep -v "CHR"  | grep -v "na" | \
               ${SOFTPATH}datamash-1.3/datamash mean 5 median 5 sstdev 5 ) ;
   echo $start $stop $results >> ${nuc_PS_dir}LD_${out_suffix}.tab ; 
done < ${windows_file}


