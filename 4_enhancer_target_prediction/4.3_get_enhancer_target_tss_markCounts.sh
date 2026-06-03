#!/bin/bash --login

#SBATCH --time=00:30:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=2G
#SBATCH --job-name enh_featureCounts_k27ac
module load subread/1.6.0-ak6vxhs
f1=(`ls -1 ./1_read_processing/output/ grep 'K27ac_merged.bam' | grep -v 'bai'`)

for (( i = 0 ; i < ${#f1[@]} ; i++ )) do
	bam=(./1_read_processing/output/'`echo ${f1[$i]}`')
	annot=(./4_enhancer_target_prediction/output/enhancer_target_tss.saf)
	out=(./4_enhancer_target_prediction/output/target_methods_comparison/'`echo ${f1[$i]} | cut -f1 -d _`'_target_tss_cts.txt)
	featureCounts --primary -d 25 -Q 10 -s 0 -F 'SAF' -a $annot -o $out $bam




#!/bin/bash --login

#SBATCH --time=00:30:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=2G
#SBATCH --job-name tss_featureCounts_k27me3
f1=(`ls -1 ./1_read_processing/output/ grep 'K27me3_merged.bam' | grep -v 'bai'`)

for (( i = 0 ; i < ${#f1[@]} ; i++ )) do
        bam=(./1_read_processing/output/'`echo ${f1[$i]}`')
        annot=(./4_enhancer_target_prediction/output/enhancer_target_tss.saf)
        out=(./4_enhancer_target_prediction/output/target_methods_comparison/'`echo ${f1[$i]} | cut -f1 -d _`'_target_tss_cts.txt)
        featureCounts --primary -d 25 -Q 10 -s 0 -F 'SAF' -a $annot -o $out $bam



#!/bin/bash --login

#SBATCH --time=00:30:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=2G
#SBATCH --job-name tss_featureCounts_k4me1

f1=(`ls -1  ./1_read_processing/output/ grep 'K4me1_merged.bam' | grep -v 'bai'`)

for (( i = 0 ; i < ${#f1[@]} ; i++ )) do
        bam=(./1_read_processing/output/'`echo ${f1[$i]}`')
        annot=(./4_enhancer_target_prediction/output/enhancer_target_tss.saf)
        out=(./4_enhancer_target_prediction/output/target_methods_comparison/'`echo ${f1[$i]} | cut -f1 -d _`'_target_tss_cts.txt)
        featureCounts --primary -d 25 -Q 10 -s 0 -F 'SAF' -a $annot -o $out $bam


#!/bin/bash --login

#SBATCH --time=00:30:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=2G
#SBATCH --job-name tss_featureCounts_k4me3

f1=(`ls -1 ./1_read_processing/output/ grep 'K4me3_merged.bam' | grep -v 'bai'`)


for (( i = 0 ; i < ${#f1[@]} ; i++ )) do
        bam=(./1_read_processing/output/'`echo ${f1[$i]}`')
        annot=(./4_enhancer_target_prediction/output/enhancer_target_tss.saf)
        out=(./4_enhancer_target_prediction/output/target_methods_comparison/'`echo ${f1[$i]} | cut -f1 -d _`'_target_tss_cts.txt)
        featureCounts --primary -d 25 -Q 10 -s 0 -F 'SAF' -a $annot -o $out $bam



#!/bin/bash --login

#SBATCH --time=00:30:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=2G
#SBATCH --job-name tss_featureCounts_atac

f1=(`ls -1 ./1_read_processing/output/ grep 'mLb.clN.sorted.bam' | grep -v 'bai'`)
for (( i = 0 ; i < ${#f1[@]} ; i++ )) do
        bam=(./1_read_processing/output/'`echo ${f1[$i]}`')
        annot=(./4_enhancer_target_prediction/output/enhancer_target_tss.saf)
        out=(./4_enhancer_target_prediction/output/target_methods_comparison/'`echo ${f1[$i]} | cut -f1 -d _`'_target_tss_cts.txt)
        featureCounts --primary -d 25 -Q 10 -s 0 -F 'SAF' -a $annot -o $out $bam

