#!/bin/bash --login
#SBATCH --time=08:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=50G
#SBATCH --job-name enhancer_gene_correlations

module load r/3.6.3-py3-oywcw22

Rscript 4.2_calculate_enhancer_gene_expr_correlations_tissue_cell_merged.R
