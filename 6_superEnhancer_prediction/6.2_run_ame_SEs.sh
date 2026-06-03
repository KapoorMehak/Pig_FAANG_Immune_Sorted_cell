#!/bin/bash --login

#SBATCH --time=00:30:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=2G
#SBATCH --job-name SE_meme
module load meme/5.3.0-py3-openmpi3-o74k6we
f1=(`ls -1 ./6_SE_identification/output/consensus_enhancers/ | grep '.fa'`)
for (( i = 0 ; i < ${#f1[@]} ; i++ )) do
        fasta=(./6_SE_identification/output/consensus_enhancers/'`echo ${f1[$i]}`'
        out=(./6_SE_identification/output/'`echo ${f1[$i]} | cut -f1 -d.`'meme)
	jaspar=(./motif_databases/JASPAR/JASPAR2022_CORE_vertebrates_non-redundant_v2.meme)
	mouse=(./motif_databases/MOUSE/uniprobe_mouse.meme)
	jolma=(./motif_databases/EUKARYOTE/jolma2013.meme)
	ame --verbose 1 --oc $out --scoring avg --method fisher --hit-lo-fraction 0.25 --evalue-report-threshold 10.0 --control --shuffle-- --kmer 2 $fasta $mouse $jaspar $jolma
