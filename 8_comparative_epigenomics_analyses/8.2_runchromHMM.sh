#!/bin/bash --login
#SBATCH --time=20:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=250Gb
#SBATCH --job-name=chromHMM_learnModel_15_bed'
module load r-rjava/0.9-8-py2-r3.4-wadatwr
unset DISPLAY

chromHMM=(~/ChromHMM)
chrom_sizes=(Homo_sapiens_chrsizes.txt)
indir=(./8_comparative_epigenomics_analyses/output)
outdir=(./8_comparative_epigenomics_analyses/output/15state_prediction)


java -mx200000M -jar $chromHMM/ChromHMM.jar LearnModel -p 0 $indir $outdir 15 GRCh38
