#!/bin/bash --login

#SBATCH --time=00:30:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=2G
#SBATCH --job-name binarize_bams

f1=(`ls -1 ./3_chromatin_state_prediction | grep 'markfile_bed.txt'`)
module load r-rjava/0.9-8-py2-r3.4-wadatwr
for (( i = 0 ; i < ${#f1[@]} ; i++ )) do
	chromHMM=(~/ChromHMM)
	chrom_sizes=(./Ss11_chrom_sizes.txt)
	indir=(./1_read_processing/output)
	markers=(./3_chromatin_state_prediction/'`echo ${f1[$i]}`')
	outdir=(./3_chromatin_state_prediction/3.1_run_chromHMM/output/)
	java -mx50000M -jar $chromHMM/ChromHMM.jar BinarizeBed -peaks $chrom_sizes $indir $markers $outdir


