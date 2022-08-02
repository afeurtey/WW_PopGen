#!/bin/bash

source $1
read11=$2
read12=$3
read21=$4
read22=$5
sample=$4

${SPADES_PATH}spades.py  \
  -o ${DENOVO_ASSEMB}${sample} \
  --careful \
  --threads 10 \
  --pe1-1 ${RAW_READS}${read11} \
  --pe1-2 ${RAW_READS}${read12} \
  --pe2-1 ${RAW_READS}${read21} \
  --pe2-2 ${RAW_READS}${read22}
