#!/bin/bash --login
#SBATCH --time=04:00:00 
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=25Gb
#SBATCH --job-name predict_loops

module load bedtools2/2.27.1-s2mtpsu python/3.6.3-u4oaxsb

peakmotifs=(./output/noFilter/peakmotifs.bed)
loops_out=(./noFilter/predicted_loops_noFilter.bed12)
merged_loops=(.output/noFilter/merged_loops_noFilter.bed12)

python2 ctcf_peaks2loops.py -p 1.0:0.4:0.1 -n CTCFChIP -i $peakmotifs -o $loops_out
bedtools merge -i $loops_out > $merged_loops 

peakmotifs=(./output/peakFilter/peakmotifs.bed)
loops_out=(./output/peakFilter/predicted_loops_peakFilter.bed12)
merged_loops=(./output/peakFilter/merged_loops_peakFilter.bed12)

python2 ctcf_peaks2loops.py -p 1.0:0.4:0.1 -n CTCFChIP -i $peakmotifs -o $loops_out
bedtools merge -i $loops_out > $merged_loops 

peakmotifs=(./output/motifFilter/peakmotifs.bed)
loops_out=(./output/motifFilter/predicted_loops_motifFilter.bed12)
merged_loops=(./output/motifFilter/merged_loops_motifFilter.bed12)

python2 ctcf_peaks2loops.py -p 1.0:0.4:0.1 -n CTCFChIP -i $peakmotifs -o $loops_out
bedtools merge -i $loops_out > $merged_loops

peakmotifs=(./output/bothFilter/peakmotifs.bed)
loops_out=(.output/bothFilter/predicted_loops_bothFilter.bed12)
merged_loops=(./output/bothFilter/merged_loops_bothFilter.bed12)

python2 ctcf_peaks2loops.py -p 1.0:0.4:0.1 -n CTCFChIP -i $peakmotifs -o $loops_out
bedtools merge -i $loops_out > $merged_loops




