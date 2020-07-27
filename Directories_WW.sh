
#Software directories
#--------------------
SOFTPATH=/home/alice/Software/
TRIMMOPATH=${SOFTPATH}Trimmomatic-0.39/
BWAPATH=${SOFTPATH}bwa-0.7.17/
BEDTOOLS_PATH=${SOFTPATH}bedtools
SAMTOOLS_PATH=${SOFTPATH}samtools-1.10/samtools
BOWTIE_PATH=${SOFTPATH}bowtie2-2.4.1-linux-x86_64/bowtie2 
SCRIPTS_PATH=/userhome/alice/Scripts/
SPADES_PATH=${SOFTPATH}SPAdes-3.14.1-Linux/bin/
BLAST_PATH=${SOFTPATH}ncbi-blast-2.10.0+/bin/
GATK_PATH=${SOFTPATH}gatk-4.1.8.0/gatk

# Files directories
#------------------
DATA_DIR=/data2/alice/WW_project/Data/
RAW_READS=${DATA_DIR}0_Raw_reads/
FILTERED_READS=${DATA_DIR}1_Filtered_reads/

#TE and RIP
WWTERIP_DIR=/data2/alice/WW_project/WW_TE_RIP/
RIP_DIR=${WWTERIP_DIR}0_RIP_estimation/
RIP_raw0=${RIP_DIR}0_BAM_temp/
RIP_raw1=${RIP_DIR}1_Fastq_from_bam/
RIP_aln=${RIP_DIR}2_Aln_TE_consensus/
RIP_est=${RIP_DIR}3_RIP_estimation/
DIM2_DIR=${WWTERIP_DIR}1_Blast_from_denovo_assemblies/
DIM_denovo=${DIM2_DIR}0_Spades/
DIM_blast=${DIM2_DIR}1_Blast_dim2_deRIPped/

#Population genomics
pop_genome=/data2/alice/WW_project/WW_GEA/

#Pangenome
pan_dir=${pop_genome}On_pangenome_ref/
pan_mapped=${pan_dir}0_Mappings/

pan_counts=${pan_dir}1_SGSGeneLoss_counts/
pan_counts_raw=${pan_counts}0_Raw_outputs/
pan_counts_concat=${pan_counts}1_Concatenated_per_sample/
pan_counts_sum=${pan_counts}2_Custom_present_or_absent/

pan_SNPcall=${pan_dir}2_SNP_calling/
pan_SNPcall_per_sample=${pan_SNPcall}0_Per_sample/
pan_SNPcall_all=${pan_SNPcall}1_Gathered/




# File paths
#-----------
adapt_file=${SOFTPATH}Trimmomatic-0.39/adapters/adapters_all.fasta
TE_REF=/home/alice/WW_project/WW_TE_RIP/Badet_BMC_Biology_2020_TE_consensus_sequences
PAN_REF=${DATA_DIR}all_19_pangenome
