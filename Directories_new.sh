
#Software directories
#--------------------
SOFTPATH=/home/alice/Software/
TRIMMOPATH=${SOFTPATH}Trimmomatic-0.39/
BWAPATH=${SOFTPATH}bwa-0.7.17/
BEDTOOLS_PATH=${SOFTPATH}bedtools
SAMTOOLS_PATH=${SOFTPATH}samtools-1.10/samtools
BOWTIE_PATH=${SOFTPATH}bowtie2-2.4.1-linux-x86_64/bowtie2 
SCRIPTS_PATH=/home/alice/Scripts/
SPADES_PATH=${SOFTPATH}SPAdes-3.14.1-Linux/bin/
BLAST_PATH=${SOFTPATH}ncbi-blast-2.10.0+/bin/
GATK_PATH=${SOFTPATH}gatk-4.1.8.0/gatk
BCFTOOLS_PATH=${SOFTPATH}bcftools-1.10.2/bcftools
TABIX_PATH=${SOFTPATH}htslib-1.10.2/tabix

# Files directories
#------------------
project_dir=/data2/alice/WW_PopGen/

#Data
DATA_DIR=${project_dir}Data/
RAW_READS=${DATA_DIR}0_Raw_reads/
FILTERED_READS=${DATA_DIR}1_Filtered_reads/
DENOVO_ASSEMB=${DATA_DIR}2_Denovo_assemblies/

#Population genomics
var_cal_dir=${project_dir}1_Variant_calling/

#Pangenome
pan_mapped=${var_cal_dir}0_Mappings/
pan_DP_win=${var_cal_dir}1_Depth_per_window/
pan_DP_gene=${var_cal_dir}2_Depth_per_gene/


#TE and RIP
WWTERIP_DIR=${project_dir}4_WW_TE_RIP/
RIP_DIR=${WWTERIP_DIR}0_RIP_estimation/
RIP_raw0=${RIP_DIR}0_BAM_temp/
RIP_raw1=${RIP_DIR}1_Fastq_from_bam/
RIP_aln=${RIP_DIR}2_Aln_TE_consensus/
RIP_est=${RIP_DIR}3_RIP_estimation/
DIM2_DIR=${WWTERIP_DIR}1_Blast_from_denovo_assemblies/
DIM_denovo=${DIM2_DIR}0_Spades/
DIM_blast=${DIM2_DIR}1_Blast_dim2_deRIPped/

#Fungicides
fung_dir=${project_dir}6_Fungicide_resistance/



# File paths
#-----------
adapt_file=${SOFTPATH}Trimmomatic-0.39/adapters/adapters_all.fasta
TE_REF=${DATA_DIR}Badet_BMC_Biology_2020_TE_consensus_sequences
PAN_REF=${DATA_DIR}all_19_pangenome
IPO323_REF=${DATA_DIR}Zymoseptoria_tritici.MG2.dna.toplevel.mt+.fa
dim2_seq=${DATA_DIR}Zt10_dim2_from_MgDNMT_deRIP.fa
IPO323_VCF=${pop_genome}Ztritici_global_March2020.filtered.vcf.gz 
