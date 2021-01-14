grep "gene" -v -w /data2/alice/WW_project/0_Data/all_19_pangenome.fasta_names.converted_coord.gff | \
   awk 'BEGIN {FS = "\t"; OFS = "\t"} {if ($3 == "mRNA") {n = split($9,ID,";");  print $1, $2, "gene", $4, $5, $6, $7, $8, ID[n]; print $1, $2, $3, $4, $5, $6, $7, $8, $9} else {print $1, $2, $3, $4, $5, $6, $7, $8, $9}}' | \
   sed 's/\tgeneID/\tID/' | sed 's/\tName/\tID/' | grep -v "CDS" \
   > /data2/alice/WW_project/0_Data/all_19_pangenome.fasta_names.converted_coord.forSGS.gff
