#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=250Gb
#SBATCH --job-name=chromHMM_overlapEnrichment
module load r-rjava/0.9-8-py2-r3.4-wadatwr
unset DISPLAY

chromHMM=(~/ChromHMM)
chrom_sizes=(Homo_sapiens_chrsizes.txt)
indir=(./8_comparative_epigenomics_analyses/output/15state_prediction/)
annot=(~/ChromHMM/COORDS/hg38/)
outdir=(./8_comparative_epigenomics_analyses/output)


java -mx1600M -jar $chromHMM/ChromHMM.jar OverlapEnrichment $in/Bcell_15_segments.bed $annot $out/Bcell_15_feature_enr
java -mx1600M -jar $chromHMM/ChromHMM.jar OverlapEnrichment $in/CD4T_15_segments.bed $annot $out/CD4T_15_feature_enr
java -mx1600M -jar $chromHMM/ChromHMM.jar OverlapEnrichment $in/CD8T_15_segments.bed $annot $out/CD8T_15_feature_enr
java -mx1600M -jar $chromHMM/ChromHMM.jar OverlapEnrichment $in/NK_15_segments.bed $annot $out/NK_15_feature_enr
~
~
