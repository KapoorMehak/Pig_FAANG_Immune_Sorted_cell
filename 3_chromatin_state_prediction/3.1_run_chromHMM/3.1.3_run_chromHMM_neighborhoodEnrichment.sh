#!/bin/bash --login
#SBATCH --time=06:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=25Gb
#SBATCH --job-name=chromHMM_overlapEnrichment


module load r-rjava/0.9-8-py2-r3.4-wadatwr
unset DISPLAY

chromHMM=(~/ChromHMM)
chrom_sizes=(./Ss11_chrom_sizes.txt)
in=(./3_chromatin_state_prediction/3.1_run_chromHMM/output/threshold1E7)
annot=(./RNAseq/gene_expr_quantiles)
out=(./3_chromatin_state_prediction/3.1_run_chromHMM/output/threshold1E7)

java -mx1600M -jar $chromHMM/ChromHMM.jar NeighborhoodEnrichment $in/CD21nB_6798_16_segments.bed $annot/TSS_CD21nB_exprQ4.bed $out/CD21nB_6798_16_neighborEnr_tss_exprQ4
java -mx1600M -jar $chromHMM/ChromHMM.jar NeighborhoodEnrichment $in/CD21nB_6798_16_segments.bed $annot/TSS_CD21nB_exprQ2.bed $out/CD21nB_6798_16_neighborEnr_tss_exprQ2
java -mx1600M -jar $chromHMM/ChromHMM.jar NeighborhoodEnrichment $in/CD21nB_6798_16_segments.bed $annot/TSS_CD21nB_repr.bed $out/CD21nB_6798_16_neighborEnr_tss_repr

java -mx1600M -jar $chromHMM/ChromHMM.jar NeighborhoodEnrichment $in/CD21nB_6800_16_segments.bed $annot/TSS_CD21nB_exprQ4.bed $out/CD21nB_6800_16_neighborEnr_tss_exprQ4
java -mx1600M -jar $chromHMM/ChromHMM.jar NeighborhoodEnrichment $in/CD21nB_6800_16_segments.bed $annot/TSS_CD21nB_exprQ2.bed $out/CD21nB_6800_16_neighborEnr_tss_exprQ2
java -mx1600M -jar $chromHMM/ChromHMM.jar NeighborhoodEnrichment $in/CD21nB_6800_16_segments.bed $annot/TSS_CD21nB_repr.bed $out/CD21nB_6800_16_neighborEnr_tss_repr

java -mx1600M -jar $chromHMM/ChromHMM.jar NeighborhoodEnrichment $in/CD21pB_6798_16_segments.bed $annot/TSS_CD21pB_exprQ4.bed $out/CD21pB_6798_16_neighborEnr_tss_exprQ4
java -mx1600M -jar $chromHMM/ChromHMM.jar NeighborhoodEnrichment $in/CD21pB_6798_16_segments.bed $annot/TSS_CD21pB_exprQ2.bed $out/CD21pB_6798_16_neighborEnr_tss_exprQ2
java -mx1600M -jar $chromHMM/ChromHMM.jar NeighborhoodEnrichment $in/CD21pB_6798_16_segments.bed $annot/TSS_CD21pB_repr.bed $out/CD21pB_6798_16_neighborEnr_tss_repr

java -mx1600M -jar $chromHMM/ChromHMM.jar NeighborhoodEnrichment $in/CD21pB_6800_16_segments.bed $annot/TSS_CD21pB_exprQ4.bed $out/CD21pB_6800_16_neighborEnr_tss_exprQ4
java -mx1600M -jar $chromHMM/ChromHMM.jar NeighborhoodEnrichment $in/CD21pB_6800_16_segments.bed $annot/TSS_CD21pB_exprQ2.bed $out/CD21pB_6800_16_neighborEnr_tss_exprQ2
java -mx1600M -jar $chromHMM/ChromHMM.jar NeighborhoodEnrichment $in/CD21pB_6800_16_segments.bed $annot/TSS_CD21pB_repr.bed $out/CD21pB_6800_16_neighborEnr_tss_repr

java -mx1600M -jar $chromHMM/ChromHMM.jar NeighborhoodEnrichment $in/CD4T_6798_16_segments.bed $annot/TSS_CD4T_exprQ4.bed $out/CD4T_6798_16_neighborEnr_tss_exprQ4
java -mx1600M -jar $chromHMM/ChromHMM.jar NeighborhoodEnrichment $in/CD4T_6798_16_segments.bed $annot/TSS_CD4T_exprQ2.bed $out/CD4T_6798_16_neighborEnr_tss_exprQ2
java -mx1600M -jar $chromHMM/ChromHMM.jar NeighborhoodEnrichment $in/CD4T_6798_16_segments.bed $annot/TSS_CD4T_repr.bed $out/CD4T_6798_16_neighborEnr_tss_repr

java -mx1600M -jar $chromHMM/ChromHMM.jar NeighborhoodEnrichment $in/CD4T_6800_16_segments.bed $annot/TSS_CD4T_exprQ4.bed $out/CD4T_6800_16_neighborEnr_tss_exprQ4
java -mx1600M -jar $chromHMM/ChromHMM.jar NeighborhoodEnrichment $in/CD4T_6800_16_segments.bed $annot/TSS_CD4T_exprQ2.bed $out/CD4T_6800_16_neighborEnr_tss_exprQ2
java -mx1600M -jar $chromHMM/ChromHMM.jar NeighborhoodEnrichment $in/CD4T_6800_16_segments.bed $annot/TSS_CD4T_repr.bed $out/CD4T_6800_16_neighborEnr_tss_repr

java -mx1600M -jar $chromHMM/ChromHMM.jar NeighborhoodEnrichment $in/CD8T_6798_16_segments.bed $annot/TSS_CD8T_exprQ4.bed $out/CD8T_6798_16_neighborEnr_tss_exprQ4
java -mx1600M -jar $chromHMM/ChromHMM.jar NeighborhoodEnrichment $in/CD8T_6798_16_segments.bed $annot/TSS_CD8T_exprQ2.bed $out/CD8T_6798_16_neighborEnr_tss_exprQ2
java -mx1600M -jar $chromHMM/ChromHMM.jar NeighborhoodEnrichment $in/CD8T_6798_16_segments.bed $annot/TSS_CD8T_repr.bed $out/CD8T_6798_16_neighborEnr_tss_repr

java -mx1600M -jar $chromHMM/ChromHMM.jar NeighborhoodEnrichment $in/CD8T_6800_16_segments.bed $annot/TSS_CD8T_exprQ4.bed $out/CD8T_6800_16_neighborEnr_tss_exprQ4
java -mx1600M -jar $chromHMM/ChromHMM.jar NeighborhoodEnrichment $in/CD8T_6800_16_segments.bed $annot/TSS_CD8T_exprQ2.bed $out/CD8T_6800_16_neighborEnr_tss_exprQ2
java -mx1600M -jar $chromHMM/ChromHMM.jar NeighborhoodEnrichment $in/CD8T_6800_16_segments.bed $annot/TSS_CD8T_repr.bed $out/CD8T_6800_16_neighborEnr_tss_repr

java -mx1600M -jar $chromHMM/ChromHMM.jar NeighborhoodEnrichment $in/CD8CD4T_6798_16_segments.bed $annot/TSS_CD8CD4T_exprQ4.bed $out/CD8CD4T_6798_16_neighborEnr_tss_exprQ4
java -mx1600M -jar $chromHMM/ChromHMM.jar NeighborhoodEnrichment $in/CD8CD4T_6798_16_segments.bed $annot/TSS_CD8CD4T_exprQ2.bed $out/CD8CD4T_6798_16_neighborEnr_tss_exprQ2
java -mx1600M -jar $chromHMM/ChromHMM.jar NeighborhoodEnrichment $in/CD8CD4T_6798_16_segments.bed $annot/TSS_CD8CD4T_repr.bed $out/CD8CD4T_6798_16_neighborEnr_tss_repr

java -mx1600M -jar $chromHMM/ChromHMM.jar NeighborhoodEnrichment $in/CD8CD4T_6800_16_segments.bed $annot/TSS_CD8CD4T_exprQ4.bed $out/CD8CD4T_6800_16_neighborEnr_tss_exprQ4
java -mx1600M -jar $chromHMM/ChromHMM.jar NeighborhoodEnrichment $in/CD8CD4T_6800_16_segments.bed $annot/TSS_CD8CD4T_exprQ2.bed $out/CD8CD4T_6800_16_neighborEnr_tss_exprQ2
java -mx1600M -jar $chromHMM/ChromHMM.jar NeighborhoodEnrichment $in/CD8CD4T_6800_16_segments.bed $annot/TSS_CD8CD4T_repr.bed $out/CD8CD4T_6800_16_neighborEnr_tss_repr

java -mx1600M -jar $chromHMM/ChromHMM.jar NeighborhoodEnrichment $in/SWC6gdT_6798_16_segments.bed $annot/TSS_SWC6gdT_exprQ4.bed $out/SWC6gdT_6798_16_neighborEnr_tss_exprQ4
java -mx1600M -jar $chromHMM/ChromHMM.jar NeighborhoodEnrichment $in/SWC6gdT_6798_16_segments.bed $annot/TSS_SWC6gdT_exprQ2.bed $out/SWC6gdT_6798_16_neighborEnr_tss_exprQ2
java -mx1600M -jar $chromHMM/ChromHMM.jar NeighborhoodEnrichment $in/SWC6gdT_6798_16_segments.bed $annot/TSS_SWC6gdT_repr.bed $out/SWC6gdT_6798_16_neighborEnr_tss_repr

java -mx1600M -jar $chromHMM/ChromHMM.jar NeighborhoodEnrichment $in/SWC6gdT_6800_16_segments.bed $annot/TSS_SWC6gdT_exprQ4.bed $out/SWC6gdT_6800_16_neighborEnr_tss_exprQ4
java -mx1600M -jar $chromHMM/ChromHMM.jar NeighborhoodEnrichment $in/SWC6gdT_6800_16_segments.bed $annot/TSS_SWC6gdT_exprQ2.bed $out/SWC6gdT_6800_16_neighborEnr_tss_exprQ2
java -mx1600M -jar $chromHMM/ChromHMM.jar NeighborhoodEnrichment $in/SWC6gdT_6800_16_segments.bed $annot/TSS_SWC6gdT_repr.bed $out/SWC6gdT_6800_16_neighborEnr_tss_repr

java -mx1600M -jar $chromHMM/ChromHMM.jar NeighborhoodEnrichment $in/Myeloid_6798_16_segments.bed $annot/TSS_Myeloid_exprQ4.bed $out/Myeloid_6798_16_neighborEnr_tss_exprQ4
java -mx1600M -jar $chromHMM/ChromHMM.jar NeighborhoodEnrichment $in/Myeloid_6798_16_segments.bed $annot/TSS_Myeloid_exprQ2.bed $out/Myeloid_6798_16_neighborEnr_tss_exprQ2
java -mx1600M -jar $chromHMM/ChromHMM.jar NeighborhoodEnrichment $in/Myeloid_6798_16_segments.bed $annot/TSS_Myeloid_repr.bed $out/Myeloid_6798_16_neighborEnr_tss_repr

java -mx1600M -jar $chromHMM/ChromHMM.jar NeighborhoodEnrichment $in/Myeloid_6800_16_segments.bed $annot/TSS_Myeloid_exprQ4.bed $out/Myeloid_6800_16_neighborEnr_tss_exprQ4
java -mx1600M -jar $chromHMM/ChromHMM.jar NeighborhoodEnrichment $in/Myeloid_6800_16_segments.bed $annot/TSS_Myeloid_exprQ2.bed $out/Myeloid_6800_16_neighborEnr_tss_exprQ2
java -mx1600M -jar $chromHMM/ChromHMM.jar NeighborhoodEnrichment $in/Myeloid_6800_16_segments.bed $annot/TSS_Myeloid_repr.bed $out/Myeloid_6800_16_neighborEnr_tss_repr

java -mx1600M -jar $chromHMM/ChromHMM.jar NeighborhoodEnrichment $in/Neut_6798_16_segments.bed $annot/TSS_Neut_exprQ4.bed $out/Neut_6798_16_neighborEnr_tss_exprQ4
java -mx1600M -jar $chromHMM/ChromHMM.jar NeighborhoodEnrichment $in/Neut_6798_16_segments.bed $annot/TSS_Neut_exprQ2.bed $out/Neut_6798_16_neighborEnr_tss_exprQ2
java -mx1600M -jar $chromHMM/ChromHMM.jar NeighborhoodEnrichment $in/Neut_6798_16_segments.bed $annot/TSS_Neut_repr.bed $out/Neut_6798_16_neighborEnr_tss_repr

java -mx1600M -jar $chromHMM/ChromHMM.jar NeighborhoodEnrichment $in/Neut_6800_16_segments.bed $annot/TSS_Neut_exprQ4.bed $out/Neut_6800_16_neighborEnr_tss_exprQ4
java -mx1600M -jar $chromHMM/ChromHMM.jar NeighborhoodEnrichment $in/Neut_6800_16_segments.bed $annot/TSS_Neut_exprQ2.bed $out/Neut_6800_16_neighborEnr_tss_exprQ2
java -mx1600M -jar $chromHMM/ChromHMM.jar NeighborhoodEnrichment $in/Neut_6800_16_segments.bed $annot/TSS_Neut_repr.bed $out/Neut_6800_16_neighborEnr_tss_repr

java -mx1600M -jar $chromHMM/ChromHMM.jar NeighborhoodEnrichment $in/NK_6798_16_segments.bed $annot/TSS_NK_exprQ4.bed $out/NK_6798_16_neighborEnr_tss_exprQ4
java -mx1600M -jar $chromHMM/ChromHMM.jar NeighborhoodEnrichment $in/NK_6798_16_segments.bed $annot/TSS_NK_exprQ2.bed $out/NK_6798_16_neighborEnr_tss_exprQ2
java -mx1600M -jar $chromHMM/ChromHMM.jar NeighborhoodEnrichment $in/NK_6798_16_segments.bed $annot/TSS_NK_repr.bed $out/NK_6798_16_neighborEnr_tss_repr

java -mx1600M -jar $chromHMM/ChromHMM.jar NeighborhoodEnrichment $in/NK_6800_16_segments.bed $annot/TSS_NK_exprQ4.bed $out/NK_6800_16_neighborEnr_tss_exprQ4
java -mx1600M -jar $chromHMM/ChromHMM.jar NeighborhoodEnrichment $in/NK_6800_16_segments.bed $annot/TSS_NK_exprQ2.bed $out/NK_6800_16_neighborEnr_tss_exprQ2
java -mx1600M -jar $chromHMM/ChromHMM.jar NeighborhoodEnrichment $in/NK_6800_16_segments.bed $annot/TSS_NK_repr.bed $out/NK_6800_16_neighborEnr_tss_repr
