#!/bin/bash --login
#SBATCH --time=10:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=36
#SBATCH --mem=200G
#SBATCH --job-name human_immune_atac_pipeline

module load singularity miniconda3 r-rjava/0.9-8-py2-r3.4-wadatwr

design=(ATAC-seq/human_immune_atac_design.csv)
fasta=(Homo_sapiens.GRCh38.dna.primary_assembly.fa)
gtf=(Homo_sapiens.GRCh38.107.gtf)
index=(Homo_sapiens.GRCh38.dna.primary_assembly.fa)
outdir=(./ATAC-seq/results)

nextflow run nf-core/atacseq -profile singularity --input $design --fasta $fasta --gtf $gtf --bwa_index $index --macs_gsize 3.4e9 --mito_name MT --bwa_min_score 20 --macs_fdr 0.05 --broad_cutoff 0.05 --max_memory 200.GB --max_time 10.h --max_cpus 36 --outdir $outdir

