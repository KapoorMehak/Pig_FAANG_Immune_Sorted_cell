#!/bin/bash --login
#SBATCH --time=00:30:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=50Gb
#SBATCH --job-name=binarize_bed_`echo ${f1[$i]}`
module load r-rjava/0.9-8-py2-r3.4-wadatwr
f1=(`ls -1 ./3_chromatin_state_prediction | grep 'markfile_bed.txt'`)
-f1 -d.`'.out'

for (( i = 0 ; i < ${#f1[@]} ; i++ )) do
	chromHMM=(~/ChromHMM)
        chrom_sizes=(./Ss11_chrom_sizes.txt)
        indir=(./1_read_processing/output)
        markers=(./3_chromatin_state_prediction/'`echo ${f1[$i]}`')
        outdir=(./3_chromatin_state_prediction/3.1_run_chromHMM/output/)
        java -mx50000M -jar $chromHMM/ChromHMM.jar BinarizeBed -peaks $chrom_sizes $indir $markers $outdir

