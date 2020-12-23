#!/bin/sh

source $1
sample_list=$2

genes_gff=all_19_pangenome.fasta_names.converted_coord

#grep "mRNA" ${DATA_DIR}${genes_gff}.gff > ${DATA_DIR}${genes_gff}.mRNA.gff


while read sample; 
do echo $sample ; 
  head ${DATA_DIR}all_19_pangenome.windows.bed
  
  #Per window
  $BEDTOOLS_PATH coverage \
     -a ${DATA_DIR}all_19_pangenome.windows.bed \
     -b ${pan_mapped}${sample}.bam \
     -d | \
   awk 'BEGIN{OFS = "\t"} {print $1 "_" $2 "_" $3, $4, $5} ' | \
   $BEDTOOLS_PATH groupby -g 1 -c 3 -o median > \
      ${pan_DP_win}${sample}.depth_per_window.txt ;
  echo "Windows are done"

  #Per gene
  $BEDTOOLS_PATH coverage \
     -a ${DATA_DIR}${genes_gff}.mRNA.gff \
     -b ${pan_mapped}${sample}.bam \
     -d | \
   awk 'BEGIN{OFS = "\t"} {print $1 ";" $9, $10, $11} ' | \
   $BEDTOOLS_PATH groupby -g 1 -c 3 -o median > \
     ${pan_DP_gene}${sample}.depth_per_gene.txt ;
  echo "Genes are done!"

done < $sample_list

