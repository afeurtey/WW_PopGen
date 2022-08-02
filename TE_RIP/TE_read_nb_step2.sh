#!/bin/sh

# Example command:
# ----------------
# sbatch ./TE_read_nb_step2.sh -p ${list_dir}list_bam_paths.txt -s ${list_dir}Ztritici_global_March2021.genotyped.sample_list.args -o Nb_read ./Directories_new.sh

# Inputs:
# ------
#  - List of general paths to directories and files. Directories_new.sh
#  - List of paths to genome alignments: bam_path | sample_name. ${list_dir}list_bam_paths.txt
#  - List of samples of interest. Here, it's the genotyped samples. ${list_dir}Ztritici_global_March2021.genotyped.sample_list.args
#  - Bam files from the genome alignments
#  - Bam files from the TE consensus alignments

# Outputs:
# -------
# Two files are given as outputs.
#  - A tab-delimited table without headers containing the nb of reads per sample per TE consensus
#  - A space-delimited table with a heade (see below for header and thus content description)



#Reading options
while getopts p:s:o: flag
do
    case "${flag}" in
        p) path_file=${OPTARG};;
        s) sample_list=${OPTARG};;
        o) output_prefix=${OPTARG};;
    esac
done
ARG1=${@:$OPTIND:1}
source $ARG1

echo "General paths found in: $ARG1";
echo "Bam paths found in : $path_file";
echo "Sample names found in: $sample_list";
echo "Output prefix is $output_prefix";


#Cleaning potential files
echo "ID_file Te_aligned_reads Genome_aligned_reads Total_reads" > ${RIP_DIR}${output_prefix}.txt
rm ${RIP_DIR}${output_prefix}_per_TE.txt


#Starting per sample
while read sample ;
do
  #echo $sample
  genome_bam_path=$(grep -w ${sample} ${path_file} | cut -f 1)
  echo $sample $genome_bam_path
  if [ -f ${RIP_aln}${sample}.bam ] ; then
    # Get read number per sample
    # --------------------------

    # Results from genome aln
    ${SAMTOOLS_PATH} flagstat ${genome_bam_path} > temp
    total_reads=$(cat temp | grep "total" | cut -f1 -d " ");
    genome_reads=$(cat temp | grep "mapped" | grep "with" -v | cut -f1 -d " ");

    # Results from TE alignments
    TE_reads=$(${SAMTOOLS_PATH} flagstat ${RIP_aln}${sample}.bam | grep "mapped" | grep "with" -v | cut -f1 -d " ");

    # Saving results
    echo $sample $TE_reads $genome_reads $total_reads >> ${RIP_DIR}${output_prefix}.txt ;


    # Get read number per sample per TE
    # ----------------------------------
    ${SAMTOOLS_PATH} idxstats ${RIP_aln}${sample}.bam > temp ;
    awk -v var="$sample"  '{OFS="\t"} {print var, $1, $2, $3, $4}' temp >> ${RIP_DIR}${output_prefix}_per_TE.txt ;
  fi
done < ${sample_list}
