# World-wide population genomics of *Z.tritici*

These are the scripts that I am writing to study the population genomics of *Z.tritici* at a world-wide scale using around 1000 genomes.


## Data preparation
### SNP calling and filtering
First, the scripts Trim_and_map_on_ref_Daniel (several variants). These are named "Daniel" because I have replicated the scripts found previously as best I could to match the processing of the resequencing pre-2020. These scripts include 3 steps: 1. trimming with Trimmomatic v0.39, 2. mapping with bowtie and 3. haplotype calling with gatk.

Once I get the g.vcf for all the samples (using the previously generated ones for the pre-2020 data), I get on with the short variant discovry, using the scripts [SNP_calling_2021.sh](./SNP_calling_2021.sh). Filtering is then done per position and per samples, the process, criteria and visualization can be found in the [SNP_filtering.Rmd](./SNP_filtering.Rmd)/[html](./SNP_filtering.html). I distinguished several steps:
* The short variants are filtered first based on the quality stats (depth, MAPQ etc.) per position [SNP_filter_step1.sh](./SNP_filter_step1.sh) with the thresholds defined in the SNP_filtering.Rmd script.
* As a second step, I filter the dataset by removing the positions identified as being most likely errors based on the resequencing pairs. First, I run the script Check_genotyping_errors_based_on_resequencing.sh with a list of the repeated samples (the names being slightly different from one another). The positions are identified in SNP_filtering.Rmd as well, but the actual filtering is done in [SNP_filter_step2.sh](./SNP_filter_step2.sh). This script include steps to measure the identity-by-descent between all pairs of samples, the depth of coverage, and missing data proportion per sample.
* Samples are also removed based on missing data as well as based on identity-by-state (as measured in the previous step). The samples to remove are visualized and identified in the SNP_filtering.Rmd and a final filtering of the vcf file is done in [SNP_filter_step3.sh](./SNP_filter_step3.sh).


### Depth of coverage and GC bias
Depth_estimates_array.sh
Depth.Rmd

### Proportion TE reads and RIP
For each sample, run: TE_GC_RIP_bowtie_array.sh which calls GC_RIP_per_read_fastq.py
Then summarize all results together with: TE_read_nb_step2.sh


### *De novo* assemblies
For each sample, run Assemble_array.sh to get the *de novo* assemblies. Genes, such as the mat or dim2 genes, are detected in each of these with the script Detect_gene_blast_array.sh

## Analyses
World_wide_Zt_popgen.Rmd
GEMMA_LOCO.sh
Look_for_fungicide.sh
