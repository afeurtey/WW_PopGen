~/Software/bedtools coverage \
    -a /data3/alice/WW_project/Data/all_19_pangenome.windows.bed \
    -b /data3/alice/WW_project/WW_GEA/On_pangenome_ref/0_Mappings/STnnJGI_SRR4235086.bam \
    -d | \
  awk 'BEGIN{OFS = "\t"} {print $1 "_" $2 "_" $3, $4, $5} ' | \
  ~/Software/bedtools groupby -g 1 -c 3 -o median
