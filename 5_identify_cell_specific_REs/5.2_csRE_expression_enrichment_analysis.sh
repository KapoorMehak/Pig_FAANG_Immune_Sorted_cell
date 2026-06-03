#!/bin/bash --login
#SBATCH --time=04:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=25Gb
#SBATCH --job-name=csRE_enrichment_analysis

module load r

Rscript csRE_expression_enrichment_analysis.R
