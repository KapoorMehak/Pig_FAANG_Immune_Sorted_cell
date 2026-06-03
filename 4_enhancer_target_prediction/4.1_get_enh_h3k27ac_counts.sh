#!/bin/bash --login

#SBATCH --time=00:30:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=2G
#SBATCH --job-name enh_featureCounts_cells
module load subread/1.6.0-ak6vxhs
f1=(`ls -1 ./1_read_processing//output/ | grep 'K27ac_merged.bam' | grep -v 'bai'`)

for (( i = 0 ; i < ${#f1[@]} ; i++ )) do
	bam=(./1_read_processing/output/'`echo ${f1[$i]}`')
	annot=(./4__enhancer_target_prediction/enhancers.saf)
	out=(./4__enhancer_target_prediction/output/'`echo ${f1[$i]} | cut -f1 -d _`'_enh_cts.txt)
	featureCounts --primary -d 25 -Q 10 -s 0 -F 'SAF' -a $annot -o $out $bam



#!/bin/bash --login

#SBATCH --time=00:30:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=2G
#SBATCH --job-name enh_featureCounts_tissues

f1=(`ls -1 /raw_data/porcine_tissue_data/H3K27ac_ChIPseq`)

for (( i = 0 ; i < ${#f1[@]} ; i++ )) do
	bam=(./raw_data/porcine_tissue_data/H3K27ac_ChIPseq/'`echo ${f1[$i]}`')
	annot=(./4__enhancer_target_prediction/enhancers.saf)
        out=(./4__enhancer_target_prediction/output/'`echo ${f1[$i]} | cut -f1 -d _`'_enh_cts.txt)
        featureCounts --primary -d 25 -Q 10 -s 0 -F 'SAF' -a $annot -o $out $bam
