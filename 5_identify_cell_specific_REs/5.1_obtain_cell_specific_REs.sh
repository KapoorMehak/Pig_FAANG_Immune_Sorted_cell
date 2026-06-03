#!/bin/bash --login

#SBATCH --time=00:30:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=2G
#SBATCH --job-name csRE_identification_'`echo ${f1[$i]}


module load gcc/7.3.0-xegsmw4 bedtools2/2.27.1-opcm3ia
indir=(./5.1_identify_cell_specific_REs/output/state_specific_beds)
outdir=(./5.1_identify_cell_specific_REs/output/cell_specific_states

f1=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15)

for (( i = 0 ; i < ${#f1[@]} ; i++ )) do
	bedtools intersect -a $indir/CD21nB_6798_state'`echo ${f1[$i]}`'.bed -b $indir/CD21nB_6800_state'`echo ${f1[$i]}`'.bed | sort -k1,1 -k2,2n > $indir/CD21nB_consensus_'`echo ${f1[$i]}`'_state.bed
	bedtools intersect -a $indir/CD21pB_6798_state'`echo ${f1[$i]}`'.bed -b $indir/CD21pB_6800_state'`echo ${f1[$i]}`'.bed | sort -k1,1 -k2,2n > $indir/CD21pB_consensus_'`echo ${f1[$i]}`'_state.bed
	bedtools intersect -a $indir/CD8CD4T_6798_state'`echo ${f1[$i]}`'.bed -b $indir/CD8CD4T_6800_state'`echo ${f1[$i]}`'.bed | sort -k1,1 -k2,2n > $indir/CD8CD4T_consensus_'`echo ${f1[$i]}`'_state.bed
	bedtools intersect -a $indir/CD4T_6798_state'`echo ${f1[$i]}`'.bed -b $indir/CD4T_6800_state'`echo ${f1[$i]}`'.bed | sort -k1,1 -k2,2n > $indir/CD4T_consensus_'`echo ${f1[$i]}`'_state.bed
	bedtools intersect -a $indir/CD8T_6798_state'`echo ${f1[$i]}`'.bed -b $indir/CD8T_6800_state'`echo ${f1[$i]}`'.bed | sort -k1,1 -k2,2n > $indir/CD8T_consensus_'`echo ${f1[$i]}`'_state.bed
	bedtools intersect -a $indir/SWC6gdT_6798_state'`echo ${f1[$i]}`'.bed -b $indir/SWC6gdT_6800_state'`echo ${f1[$i]}`'.bed | sort -k1,1 -k2,2n > $indir/SWC6gdT_consensus_'`echo ${f1[$i]}`'_state.bed
	bedtools intersect -a $indir/Myeloid_6798_state'`echo ${f1[$i]}`'.bed -b $indir/Myeloid_6800_state'`echo ${f1[$i]}`'.bed | sort -k1,1 -k2,2n > $indir/Myeloid_consensus_'`echo ${f1[$i]}`'_state.bed
	bedtools intersect -a $indir/Neut_6798_state'`echo ${f1[$i]}`'.bed -b $indir/Neut_6800_state'`echo ${f1[$i]}`'.bed | sort -k1,1 -k2,2n > $indir/Neut_consensus_'`echo ${f1[$i]}`'_state.bed
	bedtools intersect -a $indir/NK_6798_state'`echo ${f1[$i]}`'.bed -b $indir/NK_6800_state'`echo ${f1[$i]}`'.bed | sort -k1,1 -k2,2n > $indir/NK_consensus_'`echo ${f1[$i]}`'_state.bed

	CD21nB=($indir/CD21nB_consensus_'`echo ${f1[$i]}`'_state.bed)
	CD21pB=($indir/CD21pB_consensus_'`echo ${f1[$i]}`'_state.bed)
	CD4T=($indir/CD4T_consensus_'`echo ${f1[$i]}`'_state.bed)
	CD8T=($indir/CD8T_consensus_'`echo ${f1[$i]}`'_state.bed)
	CD8CD4T=($indir/CD8CD4T_consensus_'`echo ${f1[$i]}`'_state.bed)
	SWC6gdT=($indir/SWC6gdT_consensus_'`echo ${f1[$i]}`'_state.bed)
	NK=($indir/NK_consensus_'`echo ${f1[$i]}`'_state.bed)
	My=($indir/Myeloid_consensus_'`echo ${f1[$i]}`'_state.bed)
	Neut=($indir/Neut_consensus_'`echo ${f1[$i]}`'_state.bed)

	bedtools intersect -v -a $CD21nB -b $CD21pB $CD4T $CD8T $CD8CD4T $SWC6gdT $NK $My $Neut > $outdir/CD21nB_unique_state'`echo ${f1[$i]}`'.bed
	bedtools intersect -v -a $CD21pB -b $CD21nB $CD4T $CD8T $CD8CD4T $SWC6gdT $NK $My $Neut > $outdir/CD21pB_unique_state'`echo ${f1[$i]}`'.bed
	bedtools intersect -v -a $CD4T -b $CD21nB $CD21pB $CD8T $CD8CD4T $SWC6gdT $NK $My $Neut > $outdir/CD4T_unique_state'`echo ${f1[$i]}`'.bed
	bedtools intersect -v -a $CD8T -b $CD21nB $CD21pB $CD4T $CD8CD4T $SWC6gdT $NK $My $Neut > $outdir/CD8T_unique_state'`echo ${f1[$i]}`'.bed
	bedtools intersect -v -a $CD8CD4T -b $CD21nB $CD21pB $CD4T $CD8T $SWC6gdT $NK $My $Neut > $outdir/CD8CD4T_unique_state'`echo ${f1[$i]}`'.bed
	bedtools intersect -v -a $SWC6gdT -b $CD21nB $CD21pB $CD4T $CD8T $CD8CD4T $NK $My $Neut > $outdir/SWC6gdT_unique_state'`echo ${f1[$i]}`'.bed
	bedtools intersect -v -a $NK -b $CD21nB $CD21pB $CD4T $CD8T $CD8CD4T $SWC6gdT $My $Neut > $outdir/NK_unique_state'`echo ${f1[$i]}`'.bed
	bedtools intersect -v -a $My -b $CD21nB $CD21pB $CD4T $CD8T $CD8CD4T $SWC6gdT $NK $Neut > $outdir/Myeloid_unique_state'`echo ${f1[$i]}`'.bed
	bedtools intersect -v -a $Neut -b $CD21nB $CD21pB $CD4T $CD8T $CD8CD4T $SWC6gdT $NK $My > $outdir/Neut_unique_state'`echo ${f1[$i]}`'.bed
