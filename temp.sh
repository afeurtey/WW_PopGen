#!/bin/sh

while read sample; 
do echo $sample ; \
  mv /data2/alice/WW_project/WW_GEA/On_pangenome_ref/0_Mappings/STnnJGI_${sample}.bam /data2/alice/WW_project/WW_GEA/On_pangenome_ref/0_Mappings/${sample}.bam 
  ~/Software/bedtools coverage \
     -a /data2/alice/WW_project/Data/all_19_pangenome.windows.bed \
     -b /data2/alice/WW_project/WW_GEA/On_pangenome_ref/0_Mappings/${sample}.bam \
     -d | \
   awk 'BEGIN{OFS = "\t"} {print $1 "_" $2 "_" $3, $4, $5} ' | \
   ~/Software/bedtools groupby -g 1 -c 3 -o median > \
   /data2/alice/WW_project/WW_GEA/On_pangenome_ref/1_Depth_per_window/${sample}.depth_per_window.txt ;
done < /home/alice/WW_project/list_Marcel2020.txt
