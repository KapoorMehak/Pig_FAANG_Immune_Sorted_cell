#!/bin/bash --login
#SBATCH --time=00:30:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=2G
#SBATCH --job-name run_ROSE
module load bedtools2/2.27.1-s2mtpsu samtools/1.7-kglvk7q r python/2.7.14-h73plf5 gcc/10.2.0-zuvaafu
f1=(`ls -1 6_SE_identification/ | grep 'input.*chr.bam' | grep -v 'CD8P' | grep -v 'bai'`)
for (( i = 0 ; i < ${#f1[@]} ; i++ )) do
	PATHTO=~/ROSE/
	PYTHONPATH=$PATHTO
	export PYTHONPATH
	export PATH=$PATH:$PATHTO
	enh=(./6_SE_identification echo ${f1[$i]} | cut -f1 -d i`_enh.tabular)
	ip_bam=(./6_SE_identification echo ${f1[$i]} | cut -f1 -d i`K27ac_merged.bam_chr.bam)
	input_bam=(./6_SE_identification `echo ${f1[$i]}`)
	python ~/ROSE/ROSE_main.py -g HG19 -i $enh -r $ip_bam -c $input_bam -o $outdir -s 12500 -t 2500
