#!/bin/bash

source $1
read1=$2
read2=$3
sample=$4

${SPADES_PATH}spades.py  \
  -o ${DENOVO_ASSEMB}${sample} \
  --continue
