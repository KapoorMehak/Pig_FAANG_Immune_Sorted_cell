#!/bin/bash --login
#SBATCH --time=01:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=50G
#SBATCH --job-name csEnh_bySample_states
#SBATCH --array=1-9

module load bedtools

i=$(($SLURM_ARRAY_TASK_ID - 1))

in=(CD21nB CD21pB CD4T CD8T CD8CD4T SWC6gdT NK Myeloid Neut)

indir=(./5.1_identify_cell_specific_REs/output)
outdir=(./5.4_enhancer_switching_analysis/output/csEnh_bySample_states)

cat $indir/state_specific_beds/${in[$i]}_consensus_**state.bed | sort -k1,1 -k2,2n | bedtools intersect -wao -a $indir/cell_specific_states/CD21nB_unique_state6.bed -b stdin > $outdir/merged_CD21nB_enhA1_${in[$i]}.bed

cat $indir/state_specific_beds/${in[$i]}_consensus_**state.bed | sort -k1,1 -k2,2n | bedtools intersect -wao -a $indir/cell_specific_states/CD21pB_unique_state6.bed -b stdin > $outdir/merged_CD21pB_enhA1_${in[$i]}.bed

cat $indir/state_specific_beds/${in[$i]}_consensus_**state.bed | sort -k1,1 -k2,2n | bedtools intersect -wao -a $indir/cell_specific_states/CD4T_unique_state6.bed -b stdin > $outdir/merged_CD4T_enhA1_${in[$i]}.bed

cat $indir/state_specific_beds/${in[$i]}_consensus_**state.bed | sort -k1,1 -k2,2n | bedtools intersect -wao -a $indir/cell_specific_states/CD8T_unique_state6.bed -b stdin > $outdir/merged_CD8T_enhA1_${in[$i]}.bed

cat $indir/state_specific_beds/${in[$i]}_consensus_**state.bed | sort -k1,1 -k2,2n | bedtools intersect -wao -a $indir/cell_specific_states/CD8CD4T_unique_state6.bed -b stdin > $outdir/merged_CD8CD4T_enhA1_${in[$i]}.bed

cat $indir/state_specific_beds/${in[$i]}_consensus_**state.bed | sort -k1,1 -k2,2n | bedtools intersect -wao -a $indir/cell_specific_states/SWC6gdT_unique_state6.bed -b stdin > $outdir/merged_SWC6gdT_enhA1_${in[$i]}.bed

cat $indir/state_specific_beds/${in[$i]}_consensus_**state.bed | sort -k1,1 -k2,2n | bedtools intersect -wao -a $indir/cell_specific_states/NK_unique_state6.bed -b stdin > $outdir/merged_NK_enhA1_${in[$i]}.bed

cat $indir/state_specific_beds/${in[$i]}_consensus_**state.bed | sort -k1,1 -k2,2n | bedtools intersect -wao -a $indir/cell_specific_states/Myeloid_unique_state6.bed -b stdin > $outdir/merged_Myeloid_enhA1_${in[$i]}.bed

cat $indir/state_specific_beds/${in[$i]}_consensus_**state.bed | sort -k1,1 -k2,2n | bedtools intersect -wao -a $indir/cell_specific_states/Neut_unique_state6.bed -b stdin > $outdir/merged_Neut_enhA1_${in[$i]}.bed
