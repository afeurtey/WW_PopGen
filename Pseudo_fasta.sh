#!/bin/bash

source $1
sample_list=$2

#${VCFTOOLS_PATH} \
#  --vcf /data2/alice/WW_project/1_Variant_calling/Ztritici_global_March2020.filtered-clean.max-m-0.8.ann.vcf \
#  --recode --recode-INFO-all \
#  --remove-indels \
#  --out /data2/alice/WW_project/1_Variant_calling/Ztritici_global_March2020.filtered-clean.max-m-0.8.ann.SNP_only

#~/Software/htslib-1.10.2/bgzip /data2/alice/WW_project/1_Variant_calling/Ztritici_global_March2020.filtered-clean.max-m-0.8.ann.SNP_only.recode.vcf 
#~/Software/htslib-1.10.2/tabix -p vcf /data2/alice/WW_project/1_Variant_calling/Ztritici_global_March2020.filtered-clean.max-m-0.8.ann.SNP_only.recode.vcf.gz

while read sample ; 
do
  echo $sample

  ${BCFTOOLS_PATH} consensus \
    --sample $sample \
    --fasta-ref  /data2/alice/WW_project/0_Data/Zymoseptoria_tritici.MG2.dna.toplevel.mt+.fa \
    /data2/alice/WW_project/1_Variant_calling/Ztritici_global_March2020.filtered-clean.max-m-0.8.ann.SNP_only.recode.vcf.gz \
   > ${pseudo_fasta_dir}${sample}.pseudo_fasta.fasta
done <  ${sample_list}


#while read p; 
#do 
#  c=1; 
#  for x in $p ; 
#  do 
#    if [[ $c -gt 1 ]] ; 
#      then echo $gene $x ; 
#    else  
#       gene=$x ; 
#       c=2;  
#    fi; 
#  done; 
#done < /data2/alice/WW_project/8_Selection/Only_unique_copies.tab
