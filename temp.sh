#!/bin/sh

# Running SnpEff

java -jar ~/Software/snpEff/snpEff.jar Zt09 \
    /data2/alice/WW_project/1_Variant_calling/Ztritici_global_March2020.filtered-clean.max-m-0.8.recode.vcf \
    > /data2/alice/WW_project/1_Variant_calling/Ztritici_global_March2020.filtered-clean.max-m-0.8.ann.vcf

# Identifying genes to filter based on high impact mutations and filtering
~/Software/bcftools-1.10.2/bcftools query -f "%ANN\n" /data2/alice/WW_project/1_Variant_calling/Ztritici_global_March2020.filtered-clean.max-m-0.8.ann.vcf | \
   grep "HIGH" | sed "s/,/\n/g" | grep "HIGH" | cut -d "|" -f 4,5,7 | sed 's/|/\n/g' | sort -u > \
  /data2/alice/WW_project/1_Variant_calling/Ztritici_global_March2020.filtered-clean.max-m-0.8.HIGH_impact_mut_genes.txt

grep -v -f  /data2/alice/WW_project/1_Variant_calling/Ztritici_global_March2020.filtered-clean.max-m-0.8.HIGH_impact_mut_genes.txt \
   /data2/alice/WW_project/0_Data/Zymoseptoria_tritici.MG2.Grandaubert2015.wo_overlap_mRNA.gff \
   > /data2/alice/WW_project/0_Data/Zymoseptoria_tritici.MG2.Grandaubert2015.wo_overlap_mRNA.wo_high_impact.gff

