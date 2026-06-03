#!/bin/bash --login
#SBATCH --time=40:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=36
#SBATCH --mem=350G
#SBATCH --job-name chip_seq_pipeline_broad_'`echo ${f1[$i]}

module load singularity miniconda3 r-rjava/0.9-8-py2-r3.4-wadatwr

f1=(Myeloid)
for (( i = 0 ; i < ${#f1[@]} ; i++ )) do
	mkdir ./1_read_processing/results/ChIP_seq_broad/`echo ${f1[$i]}`
	design=(./1_read_processing/designs/design_'`echo ${f1[$i]}`'_chipseq_broad.csv)
	fasta=(./Sequence/WholeGenomeFasta/genome.fa)
	gtf=(./Annotation/Genes/genes.gtf)
	index=(./Sequence/BWAIndex/genome.fa)
	outdir=(./1_read_processing/results/ChIP_seq_broad/'`echo ${f1[$i]}`')
	nextflow run nf-core/chipseq -profile singularity --input $design --fasta $fasta --gtf $gtf --bwa_index $index --macs_gsize 2.5e9 --mito_name MT --bwa_min_score 15 --macs_fdr 0.05 --broad_cutoff 0.05 --max_memory 350.GB --max_cpus 36 --max_time 40.h --outdir $outdir --skip_diff_analysis true --skip_spp true'


