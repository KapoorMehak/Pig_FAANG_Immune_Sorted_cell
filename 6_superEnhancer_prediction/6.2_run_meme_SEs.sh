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
	meme $fasta -dna -oc $out -nostatus -time 14400 -mod zoops -nmotifs 5 -minw 6 -maxw 12 -objfun classic -revcomp -markov_order 0
	tomtom -no-ssc -oc $out/tomtom3 -mi 5 -verbosity 1 -min-overlap 5 -dist pearson -evalue -thresh 10.0 -time 300 $out/meme.txt ./motif_databases/JASPAR/JASPAR2022_CORE_vertebrates_non-redundant_v2.meme ./motif_databases/MOUSE/uniprobe_mouse.meme ./motif_databases/EUKARYOTE/jolma2013.meme
