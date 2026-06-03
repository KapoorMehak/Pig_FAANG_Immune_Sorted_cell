#!/bin/bash --login
#SBATCH --time=04:00:00 
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=25Gb
#SBATCH --job-name peak_counts

module load subread/1.6.0-ak6vxhs
bam=(./1_read_processing/output/*.mLb.clN.sorted.bam)
annot=(./ATAC_merged_peak_annotation.saf)
out=(./1_read_processing/output/*ATAC_cts_in_peaks.txt)
featureCounts --primary -d 25 -Q 10 -s 0 -F SAF -a $annot -o $out $bam
