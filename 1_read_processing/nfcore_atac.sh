#!/bin/bash --login
#SBATCH --time=10:00:00 
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --cpus-per-task=1
#SBATCH --mem=200G
#SBATCH --job-name atac_seq_pipeline_'`echo ${f1[$i]}`
module load singularity miniconda3 r-rjava/0.9-8-py2-r3.4-wadatwr
f1=(Myeloid)
for (( i = 0 ; i < ${#f1[@]} ; i++ )) do
	mkdir ./1_read_processing/results/ATAC/`echo ${f1[$i]}`
	design=(./1_read_processing/designs/design_'`echo ${f1[$i]}`'_atac.csv)
	fasta=(./Sequence/WholeGenomeFasta/genome.fa)
	gtf=(./Annotation/Genes/genes.gtf)
	index=(./Sequence/BWAIndex/genome.fa)
	outdir=(./1_read_processing/results/ATAC/'`echo ${f1[$i]}`')
	nextflow run nf-core/atacseq -profile singularity --input $design --fasta $fasta --gtf $gtf --bwa_index $index --macs_gsize 2.5e9 --mito_name MT --bwa_min_score 20 --macs_fdr 0.05 --broad_cutoff 0.05 --max_memory 300.GB --max_time 10.h --max_cpus 36 --outdir $outdir
	

