#checking for genes with multiple transcripts and not finding any
  996  grep "mRNA" /data2/alice/WW_project/0_Data/Zymoseptoria_tritici.MG2.Grandaubert2015.gff3 | cut -f 9 | sort | uniq -c | sort -n | less
  997  grep "mRNA" /data2/alice/WW_project/0_Data/Zymoseptoria_tritici.MG2.Grandaubert2015.gff3 | cut -f 9 | sort | uniq -c | sort -n | head
  998  grep "mRNA" /data2/alice/WW_project/0_Data/Zymoseptoria_tritici.MG2.Grandaubert2015.gff3 | cut -f 9 | sort | uniq -c | sort -n | tail



#Identifying genes with overlapping mRNAs and filtering

grep "mRNA"  /data2/alice/WW_project/0_Data/Zymoseptoria_tritici.MG2.Grandaubert2015.gff3 \
  > /data2/alice/WW_project/0_Data/Zymoseptoria_tritici.MG2.Grandaubert2015.mRNA.gff3

./Software/bedtools sort \
   -i /data2/alice/WW_project/0_Data/Zymoseptoria_tritici.MG2.Grandaubert2015.mRNA.gff3 \
   > /data2/alice/WW_project/0_Data/Zymoseptoria_tritici.MG2.Grandaubert2015.mRNA.sorted.gff3

./Software/bedtools merge \
   -i /data2/alice/WW_project/0_Data/Zymoseptoria_tritici.MG2.Grandaubert2015.mRNA.sorted.gff3 -c 1 -o count | \
   awk '$4 > 1 {print}'  \
   > /data2/alice/WW_project/0_Data/Zymoseptoria_tritici.MG2.Grandaubert2015.mRNA.sorted.overlapping_mRNA.bed

./Software/bedtools intersect \
   -a /data2/alice/WW_project/0_Data/Zymoseptoria_tritici.MG2.Grandaubert2015.mRNA.gff3 \
   -b /data2/alice/WW_project/0_Data/Zymoseptoria_tritici.MG2.Grandaubert2015.mRNA.sorted.overlapping_mRNA.bed    -wa | \
   cut -f 9 | cut -d "=" -f 3 | cut -d ";" -f 1 \
   > /data2/alice/WW_project/0_Data/Zymoseptoria_tritici.MG2.Grandaubert2015.overlapping_mRNA.txt

./Software/bedtools intersect \
   -a /data2/alice/WW_project/0_Data/Zymoseptoria_tritici.MG2.Grandaubert2015.mRNA.gff3 \
   -b /data2/alice/WW_project/0_Data/Zymoseptoria_tritici.MG2.Grandaubert2015.mRNA.sorted.overlapping_mRNA.bed    -wa | \
   cut -f 9 | cut -d "=" -f 2 | cut -d ";" -f 1 \
   >> /data2/alice/WW_project/0_Data/Zymoseptoria_tritici.MG2.Grandaubert2015.overlapping_mRNA.txt


grep -f /data2/alice/WW_project/0_Data/Zymoseptoria_tritici.MG2.Grandaubert2015.overlapping_mRNA.txt -v \
    /data2/alice/WW_project/0_Data/Zymoseptoria_tritici.MG2.Grandaubert2015.gff3 \
    > /data2/alice/WW_project/0_Data/Zymoseptoria_tritici.MG2.Grandaubert2015.wo_overlap_mRNA.gff


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


