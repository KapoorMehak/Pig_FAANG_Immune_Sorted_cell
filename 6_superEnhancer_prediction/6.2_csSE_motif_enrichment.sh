#!/bin/bash --login

#SBATCH --time=00:30:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=10G
#SBATCH --job-name csSE_motif_enrichment
module load gcc/7.3.0-xegsmw4 homer/4.9.1-py3-5hllvma
f1=(CD21nB CD21pB CD4T CD8T CD8CD4T SWC6gdT NK Myeloid Neut)

for (( i = 0 ; i < ${#f1[@]} ; i++ )) do
	test=(./6_superEnhancer_prediction/output/'`echo ${f1[$i]}`'_csSE_enhancers.fa)
	background=(./5_cell_specific_RE_identification/5.3_csRE_motif_enrichment_analysis/output/'`echo ${f1[$i]}`'_enhState_ctrl.fa)
	out=(/5_cell_specific_RE_identification/5.3_csRE_motif_enrichment_analysis/output/'`echo ${f1[$i]}`'_csSE_all.html)
	motifs=(/opt/rit/spack-app/linux-rhel7-skylake_avx512/gcc-7.3.0/homer-4.9.1-5hllvma4xfky3aa73elae5pplcq4tvlo/lib/homer//data/knownTFs/vertebrates/all.motifs)
	homer2 known -i $test -b $background -m $motifs > $out

