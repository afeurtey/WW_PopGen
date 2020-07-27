#!/bin/bash
p=$1
echo $p

conda activate env0

BWAPATH=/userhome/alice/Software/bwa-0.7.17/
BEDTOOLS_PATH=/userhome/alice/Software/
SAMTOOLS_PATH=/userhome/alice/Software/samtools-1.10/
BOWTIE_PATH=/userhome/alice/Software/bowtie2-2.4.1-linux-x86_64/
SCRIPTS_PATH=/userhome/alice/Scripts/

rsync -av /legserv/NGS_data/Zymoseptoria/Aligned_reads_Nuc_Mito_genomes/SRA_2019/SE/Bam/${p}.bam \
  /data3/alice/Aln_essai/BAM/; 

if [ ! -f /data3/alice/Aln_essai/Fastq_from_bam/${p}.fq ]; then
${BEDTOOLS_PATH}bedtools bamtofastq -i /data3/alice/Aln_essai/BAM/${p}.bam \
  -fq /data3/alice/Aln_essai/Fastq_from_bam/${p}.fq
fi

#Essai bwa TE
${BWAPATH}bwa mem \
  /data3/alice/Aln_essai/PanZymo_refTEs.fa \
  /data3/alice/Aln_essai/Fastq_from_bam/${p}.fq \
  > /data3/alice/Aln_essai/BAM_TE/${p}.TE.sam

${SAMTOOLS_PATH}samtools view \
  -b -F4 -o /data3/alice/Aln_essai/BAM_TE/${p}.TE.mapped.bam \
  /data3/alice/Aln_essai/BAM_TE/${p}.TE.sam
  
${SAMTOOLS_PATH}samtools view \
  -b -f4 -o /data3/alice/Aln_essai/BAM_TE/${p}.TE.unmapped.bam \
  /data3/alice/Aln_essai/BAM_TE/${p}.TE.sam

${BEDTOOLS_PATH}bedtools bamtofastq -i /data3/alice/Aln_essai/BAM_TE/${p}.TE.unmapped.bam \
  -fq /data3/alice/Aln_essai/BAM_TE/${p}.TE.unmapped.fq
${BEDTOOLS_PATH}bedtools bamtofastq -i /data3/alice/Aln_essai/BAM_TE/${p}.TE.mapped.bam \
  -fq /data3/alice/Aln_essai/BAM_TE/${p}.TE.mapped.fq

python ${SCRIPTS_PATH}GC_RIP_per_read_fastq.py \
   --out /data3/alice/Aln_essai/BAM_TE/${p}.TE.unmapped.GC_RIP \
   --input_format fastq --max_reads 100000 \
   /data3/alice/Aln_essai/BAM_TE/${p}.TE.unmapped.fq
python ${SCRIPTS_PATH}GC_RIP_per_read_fastq.py \
   --out /data3/alice/Aln_essai/BAM_TE/${p}.TE.mapped.GC_RIP \
   --input_format fastq --max_reads 100000 \
   /data3/alice/Aln_essai/BAM_TE/${p}.TE.mapped.fq


