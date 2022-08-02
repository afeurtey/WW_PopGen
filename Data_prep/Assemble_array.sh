#!/bin/bash

source $1
list=$2

c=0;
#while read sample read1 read2 ; 
while read  read_prefix sample ;
do c=$((${c}+1)) ; 
if [ "$c" -eq $SLURM_ARRAY_TASK_ID ] ; 
then 

read1=${read_prefix}_R1_001.fastq.gz
read2=${read_prefix}_R2_001.fastq.gz

echo $c $sample $read1 $read2 ;

${SPADES_PATH}spades.py  \
  -o ${DENOVO_ASSEMB}${sample} \
  --careful \
  --threads 10 \
  -1 ${RAW_READS}${read1} \
  -2 ${RAW_READS}${read2}

fi ;
done < $list
