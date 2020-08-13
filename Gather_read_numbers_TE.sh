#!/bin/sh

#Get read number per sample
echo "ID_file Te_aligned_reads Total_reads" > /data2/alice/WW_project/4_TE_RIP/0_RIP_estimation/Nb_reads.txt
for fq in /data2/alice/WW_project/4_TE_RIP/0_RIP_estimation/2_Aln_TE_consensus/*fq.gz ;  
do  
  name=$(echo $fq | sed 's|/data2/alice/WW_project/4_TE_RIP/0_RIP_estimation/2_Aln_TE_consensus/||' | sed 's/.fq.gz//' ); 
  echo $name
  total_reads=$(~/Software/samtools-1.10/samtools flagstat /data2/alice/WW_project/1_Variant_calling/0_Mappings/${name}.bam | grep "mapped" | grep "with" -v | cut -f1 -d " ");    
  aln_reads=$(zcat /data2/alice/WW_project/4_TE_RIP/0_RIP_estimation/2_Aln_TE_consensus/${name}.fq.gz | paste - - - - | wc -l | cut -f 1);  
  echo $name $aln_reads $total_reads >> /data2/alice/WW_project/4_TE_RIP/0_RIP_estimation/Nb_reads.txt; 
done

#Get read number per sample per TE
rm /data2/alice/WW_project/4_TE_RIP/0_RIP_estimation/Nb_reads_per_TE.txt
for bamF in /data2/alice/WW_project/4_TE_RIP/0_RIP_estimation/2_Aln_TE_consensus/*bam ;  
do 
  echo $bamF ;  
  name=$(echo $bamF | sed 's|/data2/alice/WW_project/4_TE_RIP/0_RIP_estimation/2_Aln_TE_consensus/||' | sed 's/.bam//' ) ; 
  /home/alice/Software/samtools-1.10/samtools idxstats $bamF > temp.txt ;  
  awk -v var="$name"  '{OFS="\t"} {print var, $1, $2, $3, $4}' temp.txt >> \
    /data2/alice/WW_project/4_TE_RIP/0_RIP_estimation/Nb_reads_per_TE.txt ; 
done
