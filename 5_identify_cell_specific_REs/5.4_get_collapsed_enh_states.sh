#!/bin/bash --login
#SBATCH --time=01:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=50G
#SBATCH --job-name get_collapsed_sample_enh_state
#SBATCH --array=1-18

module load bedtools

i=$(($SLURM_ARRAY_TASK_ID - 1))

in=(CD21nB_6798 CD21nB_6800 CD21pB_6798 CD21pB_6800 CD4T_6798 CD4T_6800 CD8T_6798 CD8T_6800 CD8CD4T_6798 CD8CD4T_6800 SWC6gdT_6798 SWC6gdT_6800 NK_6798 NK_6800 Myeloid_6798 Myeloid_6800 Neut_6798 Neut_6800)

indir=(./5.1_identify_cell_specific_REs/output/state_specific_beds)
outdir=(./5.4_enhancer_switching_analysis/output/by_enhancer_states)

cat $indir/${in[$i]}_state**.bed | sort -k1,1 -k2,2n | bedtools intersect -wao -a $indir/merged_EnhA1.bed -b stdin | bedtools merge -i stdin -c 7 -o collapse > $outdir/merged_collapsed_EnhA1_${in[$i]}.bed

cat $indir/${in[$i]}_state**.bed | sort -k1,1 -k2,2n | bedtools intersect -wao -a $indir/merged_EnhA2.bed -b stdin | bedtools merge -i stdin -c 7 -o collapse > $outdir/merged_collapsed_EnhA2_${in[$i]}.bed

cat $indir/${in[$i]}_state**.bed | sort -k1,1 -k2,2n | bedtools intersect -wao -a $indir/merged_EnhCTCF.bed -b stdin | bedtools merge -i stdin -c 7 -o collapse > $outdir/merged_collapsed_EnhCTCF_${in[$i]}.bed
