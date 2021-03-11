# World-wide population genomics of *Z.tritici*

These are the scripts that I am writing to study the population genomics of *Z.tritici* at a world-wide scale using around 1000 genomes. 


## Data preparation 
### SNP calling and filtering
First, the scripts Trim_and_map_on_ref_Daniel (several variants). These are named "Daniel" because I have replicated the scripts found previously as best I could to match the processing of the resequencing pre-2020. These scripts include 3 steps: 1. trimming with Trimmomatic v0.39, 2. mapping with bowtie and 3. haplotype calling with gatk.

Once I get the g.vcf for all the samples (using the previously generated ones for the pre-2020 data), I get on with the SNP calling, using the scripts SNP_calling_step1.sh and SNP_calling_step2.sh

Filtering is then done per position and per samples. The criteria and visualization can be found in the [SNP_filtering.Rmd](./SNP_filtering.Rmd)/[html](./SNP_filtering.html). The script itself is [SNP_filters.sh](./SNP_filters.sh)


### Depth per gene

### Proportion TE reads and RIP

### *De novo* assemblies



