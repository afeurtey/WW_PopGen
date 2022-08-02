#Loop on phenotypes
for i in {5..6} ; 
do 
  echo $i ; 
  
  # Extract one type of phenotypic information for a subset of samples (in kmers_table.names)
  grep -f kmers_table.names ../../5_GEA/Phenotypes_with_climatic_variables.fam | awk -v var=${i} 'BEGIN{OFS="\t"} {print $1, $var}' |  sed 's/NA/0/' \
      >> phenotypes.pheno 

  # Run the kmer gwas on this phenotype
  python ~/Software/kmer_gwas/kmers_gwas.py --pheno phenotypes.pheno --kmers_table kmers_table -l 31 -p 8 --outdir output_climate${i} ; 

  # Extract the kmers that pass the threshold
  cat /data2/alice/WW_project/4_TE_RIP/3_kmers_GWAS/output_climate${i}/kmers/pass_threshold_5per | cut -f 2 | sed 's/_/\t/' | awk '{print ">"$2"\n"$1}' > \
    /data2/alice/WW_project/4_TE_RIP/3_kmers_GWAS/output_climate${i}/kmers/pass_threshold_5per_for_fetch.fasta ; 

  # Blast the kmers on the reference genome
  ~/Software/ncbi-blast-2.10.0+/bin/blastn \
    -db /data2/alice/WW_project/0_Data/Zymoseptoria_tritici.MG2.dna.toplevel.mt+.fa \
    -query /data2/alice/WW_project/4_TE_RIP/3_kmers_GWAS/output_climate${i}/kmers/pass_threshold_5per_for_fetch.fasta -outfmt 6 > \
    /data2/alice/WW_project/4_TE_RIP/3_kmers_GWAS/output_climate${i}/kmers/pass_threshold_5per_for_fetch.blast.tsv ; 
done
