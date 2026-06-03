#!/bin/bash --login

#SBATCH --time=00:30:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=2G
#SBATCH --job-name common_atac_peak_featureCounts
module load bedtools2/2.27.1-s2mtpsu
f1=(CD21nB CD21pB CD4T CD8T CD8CD4T SWC6gdT NK Myeloid Neut)

for (( i = 0 ; i < ${#f1[@]} ; i++ )) do
	SE=(./6_SE_identification/output/consensus_enhancers/'`echo ${f1[$i]}`'_SuperEnhancers.bed)
	TE=(./6_SE_identification/output/consensus_enhancers/'`echo ${f1[$i]}`'_TypicalEnhancers.bed)
	csSE=(./6_SE_identification/output/consensus_enhancers/'`echo ${f1[$i]}`'_specific_SEs.bed
	targets=(./3_chromatin_state_prediction/3.3_enhancer_target_prediction/output/enh_target_predictions.bed)
	bedtools intersect -wa -wb -a $SE -b $targets > ./6_SE_identification/output/'`echo ${f1[$i]}`'_SE_targets.bed
	bedtools intersect -wa -wb -a $TE -b $targets > ./6_SE_identification/output/'`echo ${f1[$i]}`'_TE_targets.bed
	edtools intersect -wa -wb -a $csSE -b $targets > ./6_SE_identification/output/'`echo ${f1[$i]}`'_csSE_targets.bed
