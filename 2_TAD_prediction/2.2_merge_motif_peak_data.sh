#!/bin/bash --login
#SBATCH --time=04:00:00 
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=25Gb
#SBATCH --job-name motifs2peaks


module load bedtools2/2.27.1-s2mtpsu

scores=(./fimo_ctcf_peak_scores.bed)
peaks=(./output/merged_ctcf_peaks.bed)
motif2peaks=(./output/noFilter/motifs2peaks.bed)
peakmotifs=(./output/noFilter/peakmotifs.bed)

sort -k1,1 -k2,2n $scores | bedtools intersect -wo -a stdin -b $peaks > $motif2peaks

awk 'BEGIN{OFS="\t"}{print $1,$2,$3,$4,($13*($5/10)),$6}' $motif2peaks > $peakmotifs


peaks=(./output/merged_ctcf_peaks_filtered.bed)
motif2peaks=(./output/peakFilter/motifs2peaks.bed)
peakmotifs=(./output/peakFilter/peakmotifs.bed)

sort -k1,1 -k2,2n $scores | bedtools intersect -wo -a stdin -b $peaks > $motif2peaks

awk 'BEGIN{OFS="\t"}{print $1,$2,$3,$4,($14*($5/10)),$6}' $motif2peaks > $peakmotifs

scores=(./fimo_ctcf_peak_scores_filtered.bed)
peaks=(./output/merged_ctcf_peaks.bed)
motif2peaks=(./output/motifFilter/motifs2peaks.bed)
peakmotifs=(./output/motifFilter/peakmotifs.bed)

sort -k1,1 -k2,2n $scores | bedtools intersect -wo -a stdin -b $peaks > $motif2peaks

awk 'BEGIN{OFS="\t"}{print $1,$2,$3,$4,($13*($5/10)),$6}' $motif2peaks > $peakmotifs

scores=(./fimo_ctcf_peak_scores_filtered.bed)
peaks=(./output/merged_ctcf_peaks_filtered.bed)
motif2peaks=(./output/bothFilter/motifs2peaks.bed)
peakmotifs=(./output/bothFilter/peakmotifs.bed)

sort -k1,1 -k2,2n $scores | bedtools intersect -wo -a stdin -b $peaks > $motif2peaks

awk 'BEGIN{OFS="\t"}{print $1,$2,$3,$4,($14*($5/10)),$6}' $motif2peaks > $peakmotifs

