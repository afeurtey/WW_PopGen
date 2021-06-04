#!/bin/bash
source $1
list=$2
col_nb=$3
sequencing_method=$4

sample=$(head -n $SLURM_ARRAY_TASK_ID $list | tail -n1 | cut -f $3) 

CONDA_BASE=$(conda info --base)
source ${CONDA_BASE}/etc/profile.d/conda.sh
conda activate ngs_te_mapper2

if [ $sequencing_method = "single" ]
then
#NB the annotation file was created by running the pipeline once without the -a option, and renamed
python3 /home/alice/Software/ngs_te_mapper2/sourceCode/ngs_te_mapper2.py \
  -o /data2/alice/WW_project/4_TE_RIP/4_ngs_TE_mapper/${sample} \
  -f /data2/alice/WW_project/0_Data/1_Filtered_reads/${sample}.fq.gz \
  -r /data2/alice/WW_project/4_TE_RIP/Zymoseptoria_tritici.MG2.dna.toplevel.mt.fa \
  -l /data2/alice/WW_project/4_TE_RIP/Badet_BMC_Biology_2020_TE_consensus_sequences.fasta \
  -a /data2/alice/WW_project/4_TE_RIP/Badet_BMC_Biology_2020_TE_consensus_sequences_gff_from_ngs_TE_mapper.gff3 \
  -t 2

elif [ $sequencing_method = "paired"  ]
then
python3 /home/alice/Software/ngs_te_mapper2/sourceCode/ngs_te_mapper2.py \
  -o /data2/alice/WW_project/4_TE_RIP/4_ngs_TE_mapper/${sample} \
  -f ${FILTERED_READS}${sample}_1_paired.fq.gz,${FILTERED_READS}${sample}_2_paired.fq.gz\
  -r /data2/alice/WW_project/4_TE_RIP/Zymoseptoria_tritici.MG2.dna.toplevel.mt.fa \
  -l /data2/alice/WW_project/4_TE_RIP/Badet_BMC_Biology_2020_TE_consensus_sequences.fasta \
  -a /data2/alice/WW_project/4_TE_RIP/Badet_BMC_Biology_2020_TE_consensus_sequences_gff_from_ngs_TE_mapper.gff3 \
  -t 2

else
        echo "Please define the sequencing method as either paired or single"
fi
