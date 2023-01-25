# World-wide population genomics of *Z.tritici*
These are the scripts that I have written to study the population genomics of *Z.tritici* at a world-wide scale using around 1000 genomes. The paper has now been accepted in Nature Communications. I will update this readme once I have the link to the publication.

## Data preparation
### SNP calling and filtering
First, the scripts Trim_and_map_on_ref_Daniel (several variants). These are named "Daniel" because I have replicated the scripts found previously as best I could to match the processing of the resequencing pre-2020. These scripts include 3 steps: 1. trimming with Trimmomatic v0.39, 2. mapping with bowtie and 3. haplotype calling with gatk.

Once I get the g.vcf for all the samples (using the previously generated ones for the pre-2020 data), I get on with the short variant discovry, using the scripts [SNP_calling_2021.sh](./Data_prep/SNP_calling_2021.sh). Filtering is then done per position and per samples, the process, criteria and visualization can be found in the [SNP_filtering.Rmd](./Data_prep/SNP_filtering.Rmd)/[html](./Data_prep/SNP_filtering.html). I distinguished several steps:
* The short variants are filtered first based on the quality stats (depth, MAPQ etc.) per position [SNP_filter_step1.sh](./Data_prep/SNP_filter_step1.sh) with the thresholds defined in the SNP_filtering.Rmd script.
* As a second step, I filter the dataset by removing the positions identified as being most likely errors based on the resequencing pairs. First, I run the script Check_genotyping_errors_based_on_resequencing.sh with a list of the repeated samples (the names being slightly different from one another). The positions are identified in SNP_filtering.Rmd as well, but the actual filtering is done in [SNP_filter_step2.sh](./Data_prep/SNP_filter_step2.sh). This script include steps to measure the identity-by-descent between all pairs of samples, the depth of coverage, and missing data proportion per sample.
* Samples are also removed based on missing data as well as based on identity-by-state (as measured in the previous step). The samples to remove are visualized and identified in the SNP_filtering.Rmd and a final filtering of the vcf file is done in [SNP_filter_step3.sh](./Data_prep/SNP_filter_step3.sh).

### *De novo* assemblies
For each sample, run [Assemble_array.sh](./Data_prep/Assemble_array.sh) to get the *de novo* assemblies. Genes, such as the mat or dim2 genes, are detected in each of these with the script [Detect_gene_blast_array](./TE_RIP/Detect_gene_blast_array.sh)


### Depth of coverage and GC bias
GC bias and depth of coverage were estimated for all resequencing using Depth_estimates_array.sh and 
Depth.Rmd.


## Analyses
### Population structure
The population structure and other basic genetic statistics can be found in the [PopGen](./PopGen/) folder. These generally correspond to the beginning of the paper. The visualisation and data wrangling can be found in the [markdown](./PopGen/WW_Zt_Pop_Gen.Rmd) or in [html](./PopGen/WW_Zt_Pop_Gen.html).

### TE quantifications and RIP
The reads were mapped to the TE consensus sequences to extract which reads align to these and can thus be considered to be a TE read. These reads have then been used to estimate RIP (for all reads and for each TE consensus). For each sample, run: [TE_GC_RIP_bowtie_array](./TE_RIP/TE_GC_RIP_bowtie_array.sh) which calls [GC_RIP_per_read_fastq](./TE_RIP/GC_RIP_per_read_fastq.py) ; then summarize all results for TE reads number together with: [TE_read_nb_step2](./TE_RIP/TE_read_nb_step2.sh)
In a first draft, I had used the depth of coverage to estimate the TE content per sample. However, I decided later on to use the tool [ngs_te_mapper2](https://github.com/bergmanlab/ngs_te_mapper2) which had the advantage of giving localization information. I [ran](./TE_RIP/Array_ngs_te_mapper.sh) the tool in an array. 

Further statistics and data visualisation was done in R using the [markdown](./TE_RIP/WW_Zt_TE_RIP.Rmd), that can also be seen as an [html](./TE_RIP/WW_Zt_TE_RIP.html). 


### Adaptation: GWAS analyses of climate-related and distribution of known fungicide resistance alleles
The analyses and visualization related to adaptation in *Z.tritici* can be found in the [GEA](./GEA/) folder (including for fungicide resistance). 

***

## Disclaimer
As a little warning: not all my scripts will be prettily annotated, hopefully most are but I do not garantee anything. I certainly can't guarantee that you can use the scripts as they are on a different system, changes will have to be made to suit the system architecture or new versions of software. 
Likewise, some of the comments in the markdowns might not correspond perfectly to the code chunks. These were my working documents and as much as I try to clean my files as I go, I'm sure that some obsolete content will have slipped through! 