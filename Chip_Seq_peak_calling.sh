#!/bin/sh

source $1
sample=$2
#sample_list=$2
threshold=30

CONDA_BASE=$(conda info --base)
source ${CONDA_BASE}/etc/profile.d/conda.sh
conda activate env0

#sample=$(head -n $SLURM_ARRAY_TASK_ID $sample_list | tail -n1) 
echo $sample 


#MapQ filtering
samtools view -q ${threshold} -b  ${mapped_dir}${sample}.bam > ${mapped_dir}${sample}.q${threshold}.bam

macs2  callpeak -t ${mapped_dir}${sample}.q${threshold}.bam \
 --outdir ${chipseq}  -n ${sample} -g 25000000 --nomodel
