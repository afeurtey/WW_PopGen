#!/bin/bash

source $1
list=$2

c=0;
while read read1 sample ; 
do c=$((${c}+1)) ; 
if [ "$c" -eq $SLURM_ARRAY_TASK_ID ] ; 
then echo $c $read1  $sample ;
${SPADES_PATH}spades.py  \
  -o ${DENOVO_ASSEMB}${sample} \
  --continue
fi ;
done < $list
