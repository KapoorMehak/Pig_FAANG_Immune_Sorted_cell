#!/bin/bash --login
#SBATCH --time=02:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=25Gb
#SBATCH --job-name=chromHMM_overlapEnrichment

module load r-rjava/0.9-8-py2-r3.4-wadatwr
unset DISPLAY

chromHMM=(~/ChromHMM)
chrom_sizes=(./Ss11_chrom_sizes.txt)
in=(./3_chromatin_state_prediction/3.1_run_chromHMM/output/threshold1E8/15_state)
annot=(~/ChromHMM/COORDS/Ss11/)
out=(./3_chromatin_state_prediction/3.1_run_chromHMM/output/threshold1E8/15_state)


java -mx1600M -jar $chromHMM/ChromHMM.jar OverlapEnrichment $in/CD21nB_6798_15_segments.bed $annot $out/CD21nB_6798_15_feature_enr
#java -mx1600M -jar $chromHMM/ChromHMM.jar OverlapEnrichment $in/CD21nB_6800_16_segments.bed $annot/CD21nB/ $out/CD21nB_6800_16_tss_expr
#java -mx1600M -jar $chromHMM/ChromHMM.jar OverlapEnrichment $in/CD21pB_6798_16_segments.bed $annot/CD21pB/ $out/CD21pB_6798_16_tss_expr
#java -mx1600M -jar $chromHMM/ChromHMM.jar OverlapEnrichment $in/CD21pB_6800_16_segments.bed $annot/CD21pB/ $out/CD21pB_6800_16_tss_expr
#java -mx1600M -jar $chromHMM/ChromHMM.jar OverlapEnrichment $in/CD4T_6798_16_segments.bed $annot/CD4T/ $out/CD4T_6798_16_tss_expr
#java -mx1600M -jar $chromHMM/ChromHMM.jar OverlapEnrichment $in/CD4T_6800_16_segments.bed $annot/CD4T/ $out/CD4T_6800_16_tss_expr
#java -mx1600M -jar $chromHMM/ChromHMM.jar OverlapEnrichment $in/CD8T_6798_16_segments.bed $annot/CD8T/ $out/CD8T_6798_16_tss_expr
#java -mx1600M -jar $chromHMM/ChromHMM.jar OverlapEnrichment $in/CD8T_6800_16_segments.bed $annot/CD8T/ $out/CD8T_6800_16_tss_expr
#java -mx1600M -jar $chromHMM/ChromHMM.jar OverlapEnrichment $in/CD8CD4T_6798_16_segments.bed $annot/CD8CD4T/ $out/CD8CD4T_6798_16_tss_expr
#java -mx1600M -jar $chromHMM/ChromHMM.jar OverlapEnrichment $in/CD8CD4T_6800_16_segments.bed $annot/CD8CD4T/ $out/CD8CD4T_6800_16_tss_expr
#java -mx1600M -jar $chromHMM/ChromHMM.jar OverlapEnrichment $in/SWC6gdT_6798_16_segments.bed $annot/SWC6gdT/ $out/SWC6gdT_6798_16_tss_expr
#java -mx1600M -jar $chromHMM/ChromHMM.jar OverlapEnrichment $in/SWC6gdT_6800_16_segments.bed $annot/SWC6gdT/ $out/SWC6gdT_6800_16_tss_expr
#java -mx1600M -jar $chromHMM/ChromHMM.jar OverlapEnrichment $in/Myeloid_6798_16_segments.bed $annot/Myeloid/ $out/Myeloid_6798_16_tss_expr
#java -mx1600M -jar $chromHMM/ChromHMM.jar OverlapEnrichment $in/Myeloid_6800_16_segments.bed $annot/Myeloid/ $out/Myeloid_6800_16_tss_expr
#java -mx1600M -jar $chromHMM/ChromHMM.jar OverlapEnrichment $in/Neut_6798_16_segments.bed $annot/Neut/ $out/Neut_6798_16_tss_expr
#java -mx1600M -jar $chromHMM/ChromHMM.jar OverlapEnrichment $in/Neut_6800_16_segments.bed $annot/Neut/ $out/Neut_6800_16_tss_expr
#java -mx1600M -jar $chromHMM/ChromHMM.jar OverlapEnrichment $in/NK_6798_16_segments.bed $annot/NK/ $out/NK_6798_16_tss_expr
#java -mx1600M -jar $chromHMM/ChromHMM.jar OverlapEnrichment $in/NK_6800_16_segments.bed $annot/NK/ $out/NK_6800_16_tss_expr
