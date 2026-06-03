#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=250Gb
#SBATCH --job-name=chromHMM_neighborhoodEnrichment
module load r-rjava/0.9-8-py2-r3.4-wadatwr
unset DISPLAY

chromHMM=(~/ChromHMM)
chrom_sizes=(Homo_sapiens_chrsizes.txt)
indir=(./8_comparative_epigenomics_analyses/output/15state_prediction/)
annot=(~/ChromHMM/COORDS/hg38/)
outdir=(./8_comparative_epigenomics_analyses/output)


java -mx1600M -jar $chromHMM/ChromHMM.jar NeighborhoodEnrichment $in/Bcell_15_segments_chr.bed $annot/RefSeqTSS.hg38.bed $out/Bcell_15_neighborhood_enr
java -mx1600M -jar $chromHMM/ChromHMM.jar NeighborhoodEnrichment $in/CD4T_15_segments_chr.bed $annot/RefSeqTSS.hg38.bed $out/CD4T_15_neighborhood_enr
java -mx1600M -jar $chromHMM/ChromHMM.jar NeighborhoodEnrichment $in/CD8T_15_segments_chr.bed $annot/RefSeqTSS.hg38.bed $out/CD8T_15_neighborhood_enr
java -mx1600M -jar $chromHMM/ChromHMM.jar NeighborhoodEnrichment $in/NK_15_segments_chr.bed $annot/RefSeqTSS.hg38.bed $out/NK_15_neighborhood_enr
