#!/bin/bash

#need python with biopython
# Example command:
# ----------------
# sbatch ./Identify_AAchange_from_vcf.sh  -s ./Keep_lists_samples/Ztritici_global_March2021.genotyped.good_samples.args  -p ./Directories_new.sh -b ./fungicideR_codon_ranges.bed

# Inputs:
# ------
#  - List of general paths to directories and files. Directories_new.sh
#  - List of samples of interest. Here, it's the genotyped samples. ${list_dir}Ztritici_global_March2021.genotyped.sample_list.args
#  - Vcf file which includes the samples of interest. Here set up to: ${vcf_dir}${VCFBasename}.genotyped.ALL.filtered.clean.AB_filtered.variants.good_samples.max-m-80.vcf.gz
#  - A tab-delimited table (called bed below despite it not being a bed file at all).
#       Example line: QoI     mitochondrial_cytb      G143A   cytb    mt      26989   28160   -       27733   27735

# Outputs:
# -------


#Reading options
while getopts p:s:b: flag
do
    case "${flag}" in
        p) path_file=${OPTARG};;
        s) sample_list=${OPTARG};;
        b) BED=${OPTARG};;
        #o) output_prefix=${OPTARG};;
    esac
done

source $path_file

final_vcf=${vcf_dir}${VCFBasename}.genotyped.ALL.filtered.clean.AB_filtered.variants.good_samples.max-m-80.vcf.gz

cd ${fung_dir}

$TABIX_PATH -p vcf $final_vcf
mkdir -p temp_files

# looping through the table of codons/loci
while IFS=$'\t' read -r -a myArray
do
  # picking up the correct columns from the input table
  chr=${myArray[4]}
  start=${myArray[8]}
  end=${myArray[9]}
  strand=${myArray[7]}
  gene=${myArray[1]}
  codon=${myArray[2]}

  # now looping through each sample to get the same position
  while read line
    do
	  sample=$line
    ${SAMTOOLS_PATH} faidx $IPO323_REF "$chr:$start-$end" | \
      ${BCFTOOLS_PATH} consensus \
        --sample $sample \
        -o temp_files/$gene.$codon.$sample.fa \
        ${final_vcf}

    sed -i "/>/ s/>.*/>$sample/" temp_files/$gene.$codon.$sample.fa
  done < $sample_list

  # combine files per locus
  cat temp_files/$gene.$codon.*.fa > $gene.$codon.tmp.fa
  rm temp_files/$gene.$codon.*.fa

  # perform rev. comp. with seqk if "-", otherwise just translate
  if [ $strand = "-" ]; then
	   seqkit seq -r -p $gene.$codon.tmp.fa > $gene.$codon.fa
  else
	  cat $gene.$codon.tmp.fa > $gene.$codon.fa
  fi

  seqkit translate $gene.$codon.fa > $gene.$codon.final.fa
  
done < $BED

### Combine all files into large table
AllFiles=$(find . -name "*.final.fa")
echo $AllFiles > genotypes.txt
paste $AllFiles >> genotypes.txt

cat > ./temp.py << EOL
from Bio import SeqIO
import glob
temp = glob.glob("./*final.fa")
out = open("genotypes_tidy_format.tab", "w")
for filename in temp :
     for record in SeqIO.parse(filename, "fasta"):
             to_write = [filename.replace(".final.fa", "").replace("./", "")] 
             to_write.append(record.id.replace("_frame=1", ""))
             to_write.append(str(record.seq))
             out.write("\t".join(to_write))
             out.write("\n")
out.close()

EOL

python ./temp.py
