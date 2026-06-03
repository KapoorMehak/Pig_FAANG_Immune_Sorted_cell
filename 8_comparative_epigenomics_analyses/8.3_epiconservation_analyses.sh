#!/bin/bash --login
#SBATCH --time=01:00:00 
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=50Gb
#SBATCH --job-name TssStrA_liftOver_chromatinState_intersect


output=./*_liftOver.out
module load bedtools2/2.27.1-s2mtpsu
liftOver= (./8.3_run_liftOver_human_to_pig/output/Bcell_TssStrA_liftOver.bed)
outdir=(./8_epiconservation_analyses/output)
bedtools intersect -a $liftOver -b CD21nB_6798_15_dense.bed -wb > $outdir/Bcell_TssStrA_liftOver_CD21nB98.bed
bedtools intersect -a $liftOver -b CD21nB_6800_15_dense.bed -wb > $outdir/Bcell_TssStrA_liftOver_CD21nB00.bed
bedtools intersect -a $liftOver -b CD21pB_6798_15_dense.bed -wb > $outdir/Bcell_TssStrA_liftOver_CD21pB98.bed
bedtools intersect -a $liftOver -b CD21pB_6800_15_dense.bed -wb > $outdir/Bcell_TssStrA_liftOver_CD21pB00.bed
bedtools intersect -a $liftOver -b CD4T_6798_15_dense.bed -wb > $outdir/Bcell_TssStrA_liftOver_CD4T98.bed
bedtools intersect -a $liftOver -b CD4T_6800_15_dense.bed -wb > $outdir/Bcell_TssStrA_liftOver_CD4T00.bed
bedtools intersect -a $liftOver -b CD8T_6798_15_dense.bed -wb > $outdir/Bcell_TssStrA_liftOver_CD8T98.bed
bedtools intersect -a $liftOver -b CD8T_6800_15_dense.bed -wb > $outdir/Bcell_TssStrA_liftOver_CD8T00.bed
bedtools intersect -a $liftOver -b NK_6798_15_dense.bed -wb > $outdir/Bcell_TssStrA_liftOver_NK98.bed
bedtools intersect -a $liftOver -b NK_6800_15_dense.bed -wb > $outdir/Bcell_TssStrA_liftOver_NK00.bed
