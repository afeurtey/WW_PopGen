#############################################
#
# Z. tritici global isolate collection genotyping
#
#############################################

(Alice, December 2020; based on Daniel, 10 April 2020)


###################################
# GATK pipeline after running HaplotypeCaller

VCFBasename=Ztritici_global_December2020

GATK=/userhome/software/gatk-4.1.4.1/gatk
REF=/userhome/genomes/fasta/Zymoseptoria_tritici.MG2.dna.toplevel.mt+


### Merge all gvcf files into one
#find GATK_gvcf -name "*.g.vcf.idx" | sed 's/.idx//' > GATK_gvcf/$VCFBasename.g.vcf.list
GVCF_list=/home/alice/WW_project/WW_PopGen/GVCF_list.txt

# run chromosomes
for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 mt
do
	sbatch -J $i -p normal.168h -c 1 --wrap="$GATK_PATH --java-options '-XX:+UseSerialGC' CombineGVCFs -L $i -R $${IPO323_REF} -V GVCF_list -O GATK_joint/$VCFBasename.combined.$i.g.vcf.gz"
done


### Genotype 
MAXALT=2

for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 mt
do
sbatch --dependency=$(squeue --noheader --format %i --name $i) -p normal.168h --wrap="$GATK_PATH --java-options '-XX:+UseSerialGC' GenotypeGVCFs -L $i R ${IPO323_REF} -V GATK_joint/$VCFBasename.combined.$i.g.vcf.gz -O GATK_joint/$VCFBasename.genotyped.$i.vcf.gz --max-alternate-alleles $MAXALT"
done


#####################################################
### Concatenate variants using GatherVcfs

# create string listing all VCFs

var=""
for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 mt
do
var="$var -I GATK_joint/$VCFBasename.genotyped.$i.vcf.gz"
done

sbatch -p normal.168h -J GatherVar --wrap="$GATK_PATH GatherVcfs $var -O GATK_joint/$VCFBasename.genotyped.vcf.gz"


# create index file
sbatch -p normal.168h -J IndexVCF --dependency=$(squeue --noheader --format %i --name GatherVar) --wrap="$GATK_PATH IndexFeatureFile -I GATK_joint/$VCFBasename.genotyped.vcf.gz"


