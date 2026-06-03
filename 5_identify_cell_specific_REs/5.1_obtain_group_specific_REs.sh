#!/bin/bash --login

#SBATCH --time=00:30:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=2G
#SBATCH --job-name grup_specific_RE_identification_'`echo ${f1[$i]}


module load gcc/7.3.0-xegsmw4 bedtools2/2.27.1-opcm3ia
indir=(./5.1_identify_cell_specific_REs/output/state_specific_beds)
outdir=(./5.1_identify_cell_specific_REs/output/cell_specific_states

f1=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15)

for (( i = 0 ; i < ${#f1[@]} ; i++ )) do
        CD21nB=($indir/CD21nB_consensus_'`echo ${f1[$i]}`'_state.bed)
        CD21pB=($indir/CD21pB_consensus_'`echo ${f1[$i]}`'_state.bed)
        CD4T=($indir/CD4T_consensus_'`echo ${f1[$i]}`'_state.bed)
        CD8T=($indir/CD8T_consensus_'`echo ${f1[$i]}`'_state.bed)
        CD8CD4T=($indir/CD8CD4T_consensus_'`echo ${f1[$i]}`'_state.bed)
        SWC6gdT=($indir/SWC6gdT_consensus_'`echo ${f1[$i]}`'_state.bed)
        NK=($indir/NK_consensus_'`echo ${f1[$i]}`'_state.bed)
        My=($indir/Myeloid_consensus_'`echo ${f1[$i]}`'_state.bed)
        Neut=($indir/Neut_consensus_'`echo ${f1[$i]}`'_state.bed)
	bedtools intersect -a $My -b $Neut > $indir/Mycell_consensus_'`echo ${f1[$i]}`'_state.bed
	bedtools intersect -a $CD21nB -b $CD21pB > $indir/Bcell_consensus_'`echo ${f1[$i]}`'_state.bed
	sort -k1,1 -k2,2n $CD4T > $indir/CD4T_consensus_'`echo ${f1[$i]}`'_state_sorted.bed
	sort -k1,1 -k2,2n $CD8T > $indir/CD8T_consensus_'`echo ${f1[$i]}`'_state_sorted.bed
	sort -k1,1 -k2,2n $CD8CD4T > $indir/CD8CD4T_consensus_'`echo ${f1[$i]}`'_state_sorted.bed
	sort -k1,1 -k2,2n $SWC6gdT > $indir/SWC6gdT_consensus_'`echo ${f1[$i]}`'_state_sorted.bed
	CD4T=($indir/CD4T_consensus_'`echo ${f1[$i]}`'_state_sorted.bed)
	CD8T=($indir/CD8T_consensus_'`echo ${f1[$i]}`'_state_sorted.bed)
	CD8CD4T=($indir/CD8CD4T_consensus_'`echo ${f1[$i]}`'_state_sorted.bed)
	SWC6gdT=($indir/SWC6gdT_consensus_'`echo ${f1[$i]}`'_state_sorted.bed)
	bedtools multiinter -i $CD4T $CD8T $CD8CD4T $SWC6gdT > $indir/Tcell_consensus_'`echo ${f1[$i]}`'_state.bed
	Mycell=($indir/Mycell_consensus_'`echo ${f1[$i]}`'_state.bed)
	Bcell=($indir/Bcell_consensus_'`echo ${f1[$i]}`'_state.bed)
	Tcell=($indir/Tcell_consensus_'`echo ${f1[$i]}`'_state.bed)
	bedtools intersect -v -a $Mycell -b $CD21nB $CD21pB $CD4T $CD8T $CD8CD4T $SWC6gdT $NK > $outdir/Mycell_unique_state'`echo ${f1[$i]}`'.bed
	bedtools intersect -v -a $Bcell -b $CD4T $CD8T $CD8CD4T $SWC6gdT $NK $My $Neut > $outdir/Bcell_unique_state'`echo ${f1[$i]}`'.bed
	bedtools intersect -v -a $Tcell -b $CD21nB $CD21pB $NK $My $Neut > $outdir/Tcell_unique_state'`echo ${f1[$i]}`'.bed
