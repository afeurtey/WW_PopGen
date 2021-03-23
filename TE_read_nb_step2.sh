#!/bin/sh
source $1


echo "ID_file Te_aligned_reads Genome_aligned_reads Total_reads" > \
   ${RIP_DIR}Nb_reads.txt
rm ${RIP_DIR}Nb_reads_per_TE.txt


while read sample ;
do
  bam_path=$(grep ${sample} ${list_dir}list_bam_paths.txt | cut -f 1)
  if [ -f ${RIP_aln}${sample}.bam ] ; then
    # Get read number per sample
    # --------------------------

    # Results from genome aln
    ${SAMTOOLS_PATH} flagstat $bam_paths > temp
    total_reads=$(cat temp | grep "total" | cut -f1 -d " ");
    genome_reads=$(cat temp | grep "mapped" | grep "with" -v | cut -f1 -d " ");

    # Results from TE alignments
    TE_reads=$(${SAMTOOLS_PATH} flagstat ${RIP_aln}${sample}.bam | grep "mapped" | grep "with" -v | cut -f1 -d " ");

    # Saving results
    echo $name $TE_reads $genome_reads $total_reads >> ${RIP_DIR}Nb_reads.txt;


    # Get read number per sample per TE
    # ----------------------------------
    ${SAMTOOLS_PATH} idxstats ${RIP_aln}${sample}.bam temp.txt ;
    awk -v var="$name"  '{OFS="\t"} {print var, $1, $2, $3, $4}' temp.txt >> ${RIP_DIR}Nb_reads_per_TE.txt ;
  fi
done < ${list_dir}Ztritici_global_March2021.genotyped.sample_list.args


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
