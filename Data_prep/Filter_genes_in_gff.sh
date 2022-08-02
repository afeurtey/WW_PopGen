#!/bin/bash

source $1


# This script creates the snpEff annotation from our filtered vcf files
# and filters genes to remove the ones in which the effect prediction would not be reliable.

#checking for genes with multiple transcripts and not finding any
#  996  grep "mRNA" /${DATA_DIR}Zymoseptoria_tritici.MG2.Grandaubert2015.gff3 | cut -f 9 | sort | uniq -c | sort -n | less
#  997  grep "mRNA" /${DATA_DIR}Zymoseptoria_tritici.MG2.Grandaubert2015.gff3 | cut -f 9 | sort | uniq -c | sort -n | head
#  998  grep "mRNA" /${DATA_DIR}Zymoseptoria_tritici.MG2.Grandaubert2015.gff3 | cut -f 9 | sort | uniq -c | sort -n | tail



#Identifying genes with overlapping mRNAs and filtering

grep "mRNA"  /${DATA_DIR}Zymoseptoria_tritici.MG2.Grandaubert2015.gff3 \
  > /${DATA_DIR}Zymoseptoria_tritici.MG2.Grandaubert2015.mRNA.gff3

${BEDTOOLS_PATH} sort \
   -i /${DATA_DIR}Zymoseptoria_tritici.MG2.Grandaubert2015.mRNA.gff3 \
   > /${DATA_DIR}Zymoseptoria_tritici.MG2.Grandaubert2015.mRNA.sorted.gff3

${BEDTOOLS_PATH}  merge \
   -i /${DATA_DIR}Zymoseptoria_tritici.MG2.Grandaubert2015.mRNA.sorted.gff3 -c 1 -o count | \
   awk '$4 > 1 {print}'  \
   > /${DATA_DIR}Zymoseptoria_tritici.MG2.Grandaubert2015.mRNA.sorted.overlapping_mRNA.bed

${BEDTOOLS_PATH}  intersect \
   -a /${DATA_DIR}Zymoseptoria_tritici.MG2.Grandaubert2015.mRNA.gff3 \
   -b /${DATA_DIR}Zymoseptoria_tritici.MG2.Grandaubert2015.mRNA.sorted.overlapping_mRNA.bed    -wa | \
   cut -f 9 | cut -d "=" -f 3 | cut -d ";" -f 1 \
   > /${DATA_DIR}Zymoseptoria_tritici.MG2.Grandaubert2015.overlapping_mRNA.txt

${BEDTOOLS_PATH} intersect \
   -a /${DATA_DIR}Zymoseptoria_tritici.MG2.Grandaubert2015.mRNA.gff3 \
   -b /${DATA_DIR}Zymoseptoria_tritici.MG2.Grandaubert2015.mRNA.sorted.overlapping_mRNA.bed    -wa | \
   cut -f 9 | cut -d "=" -f 2 | cut -d ";" -f 1 \
   >> /${DATA_DIR}Zymoseptoria_tritici.MG2.Grandaubert2015.overlapping_mRNA.txt


grep -f /${DATA_DIR}Zymoseptoria_tritici.MG2.Grandaubert2015.overlapping_mRNA.txt -v \
    /${DATA_DIR}Zymoseptoria_tritici.MG2.Grandaubert2015.gff3 \
    > /${DATA_DIR}Zymoseptoria_tritici.MG2.Grandaubert2015.wo_overlap_mRNA.gff


# Running SnpEff

java -jar ${SNPEFF_PATH}snpEff.jar -ud \
    1000 \
    Zt09 \
    ${vcf_dir}${VCFBasename}.genotyped.ALL.filtered.clean.AB_filtered.variants.good_samples.max-m-80.vcf.gz \
    > ${vcf_dir}${VCFBasename}.genotyped.ALL.filtered.clean.AB_filtered.variants.good_samples.max-m-80.ann.vcf

# Identifying genes to filter based on high impact mutations and filtering
${BCFTOOLS_PATH} query -f "%ANN\n" ${vcf_dir}${VCFBasename}.genotyped.ALL.filtered.clean.AB_filtered.variants.good_samples.max-m-80.ann.vcf | \
   grep "HIGH" | sed "s/,/\n/g" | grep "HIGH" | cut -d "|" -f 4,5,7 | sed 's/|/\n/g' | sort -u > \
  ${vcf_dir}${VCFBasename}.genotyped.ALL.filtered.clean.AB_filtered.variants.good_samples.max-m-80.HIGH_impact_mut_genes.txt

grep -v -f  ${vcf_dir}${VCFBasename}.genotyped.ALL.filtered.clean.AB_filtered.variants.good_samples.max-m-80.HIGH_impact_mut_genes.txt \
   /${DATA_DIR}Zymoseptoria_tritici.MG2.Grandaubert2015.wo_overlap_mRNA.gff \
   > /${DATA_DIR}Zymoseptoria_tritici.MG2.Grandaubert2015.wo_overlap_mRNA.wo_high_impact.gff


