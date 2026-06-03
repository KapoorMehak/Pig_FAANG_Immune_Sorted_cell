#!/bin/bash --login

#SBATCH --time=00:30:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=2G
#SBATCH --job-name DNAmeth_computeMatrix

f1=(`ls -1 ./dna_methylation_data/ | grep '*.*cpgMeth.bw'`)
module load py-deeptools/2.5.2-py2-lgbtqfe
for (( i = 0 ; i < ${#f1[@]} ; i++ )) do
	output= ./3_chromatin_state_prediction/3.2_chromstate_DNAmeth_integration/output/computeMatrix_`echo ${f1[$i]} | cut -f1 -d.`'.out'
	bw=(./dna_methylation_data/'`echo ${f1[$i]}`')
	bed=(3_chromatin_state_prediction/3.1_run_chromHMM/output/15_state/'`echo ${f1[$i]} | cut -f1 -d c`'15_dense_noheader.bed)
	outdir=(./3_chromatin_state_prediction/3.2_chromstate_DNAmeth_integration/output)
	computeMatrix scale-regions --skipZeros --regionBodyLength 1000 -S $bw -R $bed --outFileName $outdir/'`echo ${f1[$i]} | cut -f1 -d.`'_out --outFileNameMatrix $outdir/'`echo ${f1[$i]} | cut -f1 -d.`'_outMatrix
