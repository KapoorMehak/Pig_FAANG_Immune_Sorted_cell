#!/bin/bash --login

#SBATCH --time=00:30:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=2G
#SBATCH --job-name DNAmeth_computeMatrix_misc
module load py-deeptools/2.5.2-py2-lgbtqfe
f1=(`ls -1 ./dna_methylation_data/ | grep 'cpgMeth.bw'`)
for (( i = 0 ; i < ${#f1[@]} ; i++ )) do
	output= ./3_chromatin_state_prediction/3.2_chromstate_DNAmeth_integration/output/computeMatrix_`echo ${f1[$i]} | cut -f1 -d.`'_misc.out'
	bw=(/dna_methylation_data/'`echo ${f1[$i]}`')
	bed1=(./3_chromatin_state_prediction/3.1_run_chromHMM/output/15_state/`echo ${f1[$i]} | cut -f1 -d c`'state1.bed)'
	bed7=(./3_chromatin_state_prediction/3.1_run_chromHMM/output/15_state/`echo ${f1[$i]} | cut -f1 -d c`'state7.bed)'
	bed10=(./3_chromatin_state_prediction/3.1_run_chromHMM/output/15_state/`echo ${f1[$i]} | cut -f1 -d c`'state10.bed)'
	bed11=(./3_chromatin_state_prediction/3.1_run_chromHMM/output/15_state/`echo ${f1[$i]} | cut -f1 -d c`'state11.bed)'
	bed15=(./3_chromatin_state_prediction/3.1_run_chromHMM/output/15_state/`echo ${f1[$i]} | cut -f1 -d c`'state15.bed)'
	outdir=(./3_chromatin_state_prediction/3.2_chromstate_DNAmeth_integration/output)
	computeMatrix scale-regions --skipZeros -a 1000 -b 1000 --regionBodyLength 1000 -S $bw -R $bed1 $bed7 $bed10 $bed11 $bed15 --outFileName $outdir/'`echo ${f1[$i]} | cut -f1 -d.`'_out_misc --outFileNameMatrix $outdir/'`echo ${f1[$i]} | cut -f1 -d.`'_outMatrix_misc.txt
	plotProfile -m $outdir/'`echo ${f1[$i]} | cut -f1 -d.`'_out_misc -out $outdir/'`echo ${f1[$i]} | cut -f1 -d.`'_miscState_heatmap.png --plotHeight 10 --plotWidth 12 --regionsLabel Repr ATACIsl Qui Act Ins --colors "#7f7f7f" "#88c8e4" "#d9d9d9" "#9fce62" "#000000" --startLabel "Start" --endLabel "End" --yAxisLabel "DNA Methylation %" --legendLocation best --yMin 0 --yMax 100

