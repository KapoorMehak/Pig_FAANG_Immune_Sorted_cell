#!/bin/bash --login

#SBATCH --time=00:30:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=2G
#SBATCH --job-name DNAmeth_computeMatrix_enh
module load py-deeptools/2.5.2-py2-lgbtqfe
f1=(`ls -1 ./dna_methylation_data/ | grep 'cpgMeth.bw'`)
for (( i = 0 ; i < ${#f1[@]} ; i++ )) do
	output= ./3_chromatin_state_prediction/3.2_chromstate_DNAmeth_integration/output/computeMatrix_`echo ${f1[$i]} | cut -f1 -d.`'_enh.out'
	bw=(./dna_methylation_data/'`echo ${f1[$i]}`')
	bed2=(./_chromatin_state_prediction/3.1_run_chromHMM/output/15_state/`echo ${f1[$i]} | cut -f1 -d c`'state2.bed)'
	bed6=(./_chromatin_state_prediction/3.1_run_chromHMM/output/15_state/`echo ${f1[$i]} | cut -f1 -d c`'state6.bed)'
	bed12=(./_chromatin_state_prediction/3.1_run_chromHMM/output/15_state/`echo ${f1[$i]} | cut -f1 -d c`'state12.bed)'
	bed13=(./_chromatin_state_prediction/3.1_run_chromHMM/output/15_state/`echo ${f1[$i]} | cut -f1 -d c`'state13.bed)'
	bed14=(./_chromatin_state_prediction/3.1_run_chromHMM/output/15_state/`echo ${f1[$i]} | cut -f1 -d c`'state14.bed)'
	outdir=(./3_chromatin_state_prediction/3.2_chromstate_DNAmeth_integration/output)
	computeMatrix scale-regions --skipZeros -a 1000 -b 1000 --regionBodyLength 1000 -S $bw -R $bed2 $bed6 $bed12 $bed13 $bed14 --outFileName $outdir/'`echo ${f1[$i]} | cut -f1 -d.`'_out_enh --outFileNameMatrix $outdir/'`echo ${f1[$i]} | cut -f1 -d.`'_outMatrix_enh.txt
	plotProfile -m $outdir/'`echo ${f1[$i]} | cut -f1 -d.`'_out_enh -out $outdir/'`echo ${f1[$i]} | cut -f1 -d.`'_enhState_heatmap.png --plotHeight 10 --plotWidth 12 --regionsLabel EnhPois EnhA1 EnhA2 H3K4me1 EnhCTCF --colors "#ef8837" "#dac754" "#fae45f" "#fefe55" "#9c8d3a" --startLabel "Start" --endLabel "End" --yAxisLabel "DNA Methylation %" --legendLocation best --yMin 0 --yMax 100
