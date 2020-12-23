#!/bin/bash

source $1
list=$2

c=0;
while read  sample read1 read2 ; 
do c=$((${c}+1)) ; 
if [ "$c" -ge $SLURM_ARRAY_TASK_ID ] && [ "$c" -le $SLURM_ARRAY_TASK_ID ] ; 
then echo $c $read_name  $sample ;
${SPADES_PATH}spades.py  \
  -o ${DENOVO_ASSEMB}${sample} \
  --continue
fi ;
done < $list
