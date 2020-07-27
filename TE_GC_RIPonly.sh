#!/bin/bash
p=$1
echo $p

#conda activate env0

BWAPATH=/userhome/alice/Software/bwa-0.7.17/
BEDTOOLS_PATH=/userhome/alice/Software/
SAMTOOLS_PATH=/userhome/alice/Software/samtools-1.10/
BOWTIE_PATH=/userhome/alice/Software/bowtie2-2.4.1-linux-x86_64/
SCRIPTS_PATH=/userhome/alice/Scripts/

python ${SCRIPTS_PATH}GC_RIP_per_read_fastq.py \
   --out /data3/alice/Aln_essai/BAM_TE/${p}.TE.unmapped.GC_RIP \
   --input_format fastq \
   /data3/alice/Aln_essai/BAM_TE/${p}.TE.unmapped.fq
python ${SCRIPTS_PATH}GC_RIP_per_read_fastq.py \
   --out /data3/alice/Aln_essai/BAM_TE/${p}.TE.mapped.GC_RIP \
   --input_format fastq \
   /data3/alice/Aln_essai/BAM_TE/${p}.TE.mapped.fq


