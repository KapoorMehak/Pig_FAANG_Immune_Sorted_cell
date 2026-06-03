#!/bin/bash --login
#SBATCH --time=15:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=250Gb
#SBATCH --job-name=chromHMM_learnModel_18_bed

module load r-rjava/0.9-8-py2-r3.4-wadatwr
unset DISPLAY

chromHMM=(~/ChromHMM)
chrom_sizes=(.Ss11_chrom_sizes.txt)
indir=(./3_chromatin_state_prediction/3.1_run_chromHMM/output/)
outdir=(./3_chromatin_state_prediction/3.1_run_chromHMM/output/18_state/)


java -mx200000M -jar $chromHMM/ChromHMM.jar LearnModel -p 0 $indir $outdir 18 Ss11
