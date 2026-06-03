#!/bin/bash --login
#SBATCH --time=00:30:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=25Gb
#SBATCH --job-name=chromHMM_overlapEnrichment

module load r-rjava/0.9-8-py2-r3.4-wadatwr
unset DISPLAY

chromHMM=(~/ChromHMM)
chrom_sizes=(./Ss11_chrom_sizes.txt)
in=(./3_chromatin_state_prediction/3.1_run_chromHMM/output/15_state)
annot=(./constrained_elements.sus_scrofa.bed)
out=(./3_chromatin_state_prediction/3.1_run_chromHMM/output/15_state)


#java -mx1600M -jar $chromHMM/ChromHMM.jar OverlapEnrichment $in/CD21nB_6798_15_segments.bed $annot $out/CD21nB_6798_15_conserved_elements
#java -mx1600M -jar $chromHMM/ChromHMM.jar OverlapEnrichment $in/CD21nB_6800_15_segments.bed $annot $out/CD21nB_6800_15_conserved_elements
#java -mx1600M -jar $chromHMM/ChromHMM.jar OverlapEnrichment $in/CD21pB_6798_15_segments.bed $annot $out/CD21pB_6798_15_conserved_elements
#java -mx1600M -jar $chromHMM/ChromHMM.jar OverlapEnrichment $in/CD21pB_6800_15_segments.bed $annot $out/CD21pB_6800_15_conserved_elements
#java -mx1600M -jar $chromHMM/ChromHMM.jar OverlapEnrichment $in/CD4T_6798_15_segments.bed $annot $out/CD4T_6798_15_conserved_elements
#java -mx1600M -jar $chromHMM/ChromHMM.jar OverlapEnrichment $in/CD4T_6800_15_segments.bed $annot $out/CD4T_6800_15_conserved_elements
#java -mx1600M -jar $chromHMM/ChromHMM.jar OverlapEnrichment $in/CD8T_6798_15_segments.bed $annot $out/CD8T_6798_15_conserved_elements
#java -mx1600M -jar $chromHMM/ChromHMM.jar OverlapEnrichment $in/CD8T_6800_15_segments.bed $annot $out/CD8T_6800_15_conserved_elements
#java -mx1600M -jar $chromHMM/ChromHMM.jar OverlapEnrichment $in/CD8CD4T_6798_15_segments.bed $annot $out/CD8CD4T_6798_15_conserved_elements
#java -mx1600M -jar $chromHMM/ChromHMM.jar OverlapEnrichment $in/CD8CD4T_6800_15_segments.bed $annot $out/CD8CD4T_6800_15_conserved_elements
#java -mx1600M -jar $chromHMM/ChromHMM.jar OverlapEnrichment $in/SWC6gdT_6798_15_segments.bed $annot $out/SWC6gdT_6798_15_conserved_elements
#java -mx1600M -jar $chromHMM/ChromHMM.jar OverlapEnrichment $in/SWC6gdT_6800_15_segments.bed $annot $out/SWC6gdT_6800_15_conserved_elements
#java -mx1600M -jar $chromHMM/ChromHMM.jar OverlapEnrichment $in/Myeloid_6798_15_segments.bed $annot $out/Myeloid_6798_15_conserved_elements
java -mx1600M -jar $chromHMM/ChromHMM.jar OverlapEnrichment $in/Myeloid_6800_15_segments.bed $annot $out/Myeloid_6800_15_conserved_elements
java -mx1600M -jar $chromHMM/ChromHMM.jar OverlapEnrichment $in/Neut_6798_15_segments.bed $annot $out/Neut_6798_15_conserved_elements
java -mx1600M -jar $chromHMM/ChromHMM.jar OverlapEnrichment $in/Neut_6800_15_segments.bed $annot $out/Neut_6800_15_conserved_elements
java -mx1600M -jar $chromHMM/ChromHMM.jar OverlapEnrichment $in/NK_6798_15_segments.bed $annot $out/NK_6798_15_conserved_elements
java -mx1600M -jar $chromHMM/ChromHMM.jar OverlapEnrichment $in/NK_6800_15_segments.bed $annot $out/NK_6800_15_conserved_elements
