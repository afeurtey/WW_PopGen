 
cd /data2/alice/WW_project/4_TE_RIP/Temp_RIP_along_chR

for genome in  Arg00   Aus01   CH95   CNR93   CRI10   I93    IR01_26b   IR01_48b   ISY92   KE94   OregS90  TN09   UR95   YEQ92 ;
do

    for TE in RLG_Neptunus_consensus-1 \
      RLG_Mercurius_consensus-1 \
      RLG_Sol_consensus-1 \
      RLG_Venus_consensus-1 \
      RLG_Luna_consensus-1 \
      RLG_Namaka_consensus-1 \
      RLC_Deimos_consensus-1 \
      DTX_Kolyma_consensus-2 \
      RII_Cassini_consensus-1 \
      RIX_Lucy_consensus-1 \
      RLG_Uranus_consensus-1 \
      RLX_LARD_Gridr_consensus-1  ;

    do 

        grep ${TE} /legserv/NGS_data/Zymoseptoria/Zt_Reference_genomes/Genomes/${genome}/${genome}.TE.gtf > ${genome}.TE.${TE}.gtf; 
        #cp /legserv/NGS_data/Zymoseptoria/Zt_Reference_genomes/Genomes/${genome}/${genome}.fa ./${genome}.fa ; 
        ~/Software/bedtools getfasta -fi ./${genome}.fa -bed ${genome}.TE.${TE}.gtf -fo ${genome}.${TE}.fa 
        python ~/Scripts/GC_RIP_per_read_fastq.py --out_lists --out ${genome}.${TE}.GC.RIP ${genome}.${TE}.fa
    done
done

rm All_genomes.all_TEs.GC.RIP.tab
for genome in  Arg00   Aus01   CH95   CNR93   CRI10   I93    IR01_26b   IR01_48b   ISY92   KE94   OregS90  TN09   UR95   YEQ92 ;
do 
 
    for TE in RLG_Neptunus_consensus-1 \
      RLG_Mercurius_consensus-1 \
      RLG_Sol_consensus-1 \
      RLG_Venus_consensus-1 \
      RLG_Luna_consensus-1 \
      RLG_Namaka_consensus-1 \
      RLC_Deimos_consensus-1 \
      DTX_Kolyma_consensus-2 \
      RII_Cassini_consensus-1 \
      RIX_Lucy_consensus-1 \
      RLG_Uranus_consensus-1 \
      RLX_LARD_Gridr_consensus-1  ;

    do 

    awk -v genome="$genome"  -v TE="$TE" 'BEGIN {OFS = "\t"} NR>1 {print genome, TE, $1, $2, $3, $4, $5}' ${genome}.${TE}.GC.RIP.list \
       >> All_genomes.all_TEs.GC.RIP.tab

done
done



rm All_genomes.all_TEs.GC.RIP.tab
for genome in  Arg00   Aus01   CH95   CNR93   CRI10   I93    IR01_26b   IR01_48b   ISY92   KE94   OregS90  TN09   UR95   YEQ92 ;
do 

        cut -f 1,4,5 /legserv/NGS_data/Zymoseptoria/Zt_Reference_genomes/Genomes/${genome}/${genome}.TE.gtf > ${genome}.TE.bed;
        ~/Software/bedtools getfasta \
             -fi ${genome}.fa \
             -bed ${genome}.TE.bed \
             -fo ${genome}.TEs.fa 
        python ~/Scripts/GC_RIP_per_read_fastq.py --out_lists --out ${genome}.TEs.GC.RIP ${genome}.TEs.fa
        awk -v genome="$genome"  'BEGIN {OFS = "\t"} NR>1 {print genome, $1, $2, $3, $4, $5}' ${genome}.TEs.GC.RIP.list \
       >> All_genomes.all_TEs.GC.RIP.tab
done
