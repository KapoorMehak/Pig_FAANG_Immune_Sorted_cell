#!/bin/bash --login

#SBATCH --time=00:30:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=2G
#SBATCH --job-name DNAmeth_computeMatrix_tss
module load py-deeptools/2.5.2-py2-lgbtqfe
f1=(`ls -1 ./dna_methylation_data/ | grep 'cpgMeth.bw'`)

for (( i = 0 ; i < ${#f1[@]} ; i++ )) do
	output= ./3_chromatin_state_prediction/3.2_chromstate_DNAmeth_integration/output/computeMatrix_'`echo ${f1[$i]} | cut -f1 -d.`'_tss.out
	bw=(./dna_methylation_data/'`echo ${f1[$i]}`')
	bed3=(./3_chromatin_state_prediction/3.1_run_chromHMM/output/15_state/`echo ${f1[$i]} | cut -f1 -d c`'state3.bed)'
	bed4=(./3_chromatin_state_prediction/3.1_run_chromHMM/output/15_state/`echo ${f1[$i]} | cut -f1 -d c`'state4.bed)'
	bed5=(./3_chromatin_state_prediction/3.1_run_chromHMM/output/15_state/`echo ${f1[$i]} | cut -f1 -d c`'state5.bed)'
	bed8=(./3_chromatin_state_prediction/3.1_run_chromHMM/output/15_state/`echo ${f1[$i]} | cut -f1 -d c`'state8.bed)'
	bed9=(./3_chromatin_state_prediction/3.1_run_chromHMM/output/15_state/`echo ${f1[$i]} | cut -f1 -d c`'state9.bed)'
	outdir=(./3_chromatin_state_prediction/3.2_chromstate_DNAmeth_integration/output)
	computeMatrix scale-regions --skipZeros -a 1000 -b 1000 --regionBodyLength 1000 -S $bw -R $bed3 $bed4 $bed5 $bed8 $bed9 --outFileName $outdir/'`echo ${f1[$i]} | cut -f1 -d.`'_out_tss --outFileNameMatrix $outdir/'`echo ${f1[$i]} | cut -f1 -d.`'_outMatrix_tss.txt
	plotProfile -m $outdir/'`echo ${f1[$i]} | cut -f1 -d.`'_out_tss -out $outdir/'`echo ${f1[$i]} | cut -f1 -d.`'_tssState_heatmap.png --plotHeight 10 --plotWidth 12 --regionsLabel TssPois TssFlnk TssA TssStrA TssDown --colors "#5f3533" "#df62ac" "#ec706c" "#bb271b" "#f7Ce9f" --startLabel "Start" --endLabel "End" --yAxisLabel "DNA Methylation %" --legendLocation best --yMin 0 --yMax 100
