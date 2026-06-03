#!/bin/bash --login
#SBATCH --time=04:00:00 
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=25Gb
#SBATCH --job-name merge_ctcf_peaks

module load bedtools2/2.27.1-s2mtpsu
ctcf_dir=(./1_read_processing/1.4_peak_calling/output)
combined_out=(./output/combined_ctcf_peaks.bed)
sorted_out=(./output/combined_sorted_ctcf_peaks.bed)
merged_out=(./output/merged_ctcf_peaks.bed)


fasta=(./Sus_scrofa.Sscrofa11.1.dna.toplevel.fa)
ctcf_fasta=(./output/merged_ctcf_peaks.fa)
cat $ctcf_dir/*CTCF_peaks.narrowPeak > $combined_out

sort -k1,1 -k2,2n $combined_out > $sorted_out

bedtools merge -i $sorted_out -c 5 -o max > $merged_out

bedtools getfasta -fi $fasta -bed $merged_out -fo $ctcf_fasta

#filter files

merged_out=(./output/merged_ctcf_peaks_count.bed)

cat $ctcf_dir/*CTCF_peaks.narrowPeak > $combined_out

sort -k1,1 -k2,2n $combined_out > $sorted_out

bedtools merge -i $sorted_out -c 1,5,5 -o count,max,mean > $merged_out

#bedtools getfasta -fi $fasta -bed $merged_out -fo $ctcf_fasta
