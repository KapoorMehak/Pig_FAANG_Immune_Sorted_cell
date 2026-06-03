#!/bin/bash --login

#SBATCH --time=00:30:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=2G
#SBATCH --job-name get_fastas
module load bedtools2/2.27.1-s2mtpsu
fasta_in=(Sus_scrofa.Sscrofa11.1.dna.toplevel.fa)
f1=(CD21nB CD21pB CD4T CD8T CD8CD4T SWC6gdT NK Myeloid Neut Bcell Tcell Mycell)

for (( i = 0 ; i < ${#f1[@]} ; i++ )) do
	test_bed6=(./5.1_identify_cell_specific_REs/output/cell_specific_states/'`echo ${f1[$i]}`'_unique_state6.bed)
	test_out6=(./5.3_csRE_motif_enrichment_analysis/output/'`echo ${f1[$i]}`'_state6_test.fa)
	bedtools getfasta -fi $fasta_in -fo $test_out6 -bed $test_bed6

	test_bed12=(./5.1_identify_cell_specific_REs/output/cell_specific_states/'`echo ${f1[$i]}`'_unique_state6.bed)
        test_out12=(./5.3_csRE_motif_enrichment_analysis/output/'`echo ${f1[$i]}`'_state12_test.fa)
        bedtools getfasta -fi $fasta_in -fo $test_out12 -bed $test_bed12

	test_bed5=(./5.1_identify_cell_specific_REs/output/cell_specific_states/'`echo ${f1[$i]}`'_unique_state6.bed)
        test_out5=(./5.3_csRE_motif_enrichment_analysis/output/'`echo ${f1[$i]}`'_state5_test.fa)
        bedtools getfasta -fi $fasta_in -fo $test_out5 -bed $test_bed5

	test_bed8=(./5.1_identify_cell_specific_REs/output/cell_specific_states/'`echo ${f1[$i]}`'_unique_state6.bed)
        test_out8=(./5.3_csRE_motif_enrichment_analysis/output/'`echo ${f1[$i]}`'_state8_test.fa)
        bedtools getfasta -fi $fasta_in -fo $test_out8 -bed $test_bed8

	ctrl_bed6=(./5.1_identify_cell_specific_REs/output/state_specific_beds/'`echo ${f1[$i]}`'_consensus_6_state.bed)
	ctrl_out6=(./5.3_csRE_motif_enrichment_analysis/output/'`echo ${f1[$i]}`'_state6_ctrl.fa)
	bedtools getfasta -fi $fasta_in -fo $ctrl_out6 -bed $ctrl_bed6

	ctrl_bed12=(./5.1_identify_cell_specific_REs/output/state_specific_beds/'`echo ${f1[$i]}`'_consensus_12_state.bed)
        ctrl_out12=(./5.3_csRE_motif_enrichment_analysis/output/'`echo ${f1[$i]}`'_state12_ctrl.fa)
	bedtools getfasta -fi $fasta_in -fo $ctrl_out12 -bed $ctrl_bed12

	ctrl_bed5=(./5.1_identify_cell_specific_REs/output/state_specific_beds/'`echo ${f1[$i]}`'_consensus_5_state.bed)
        ctrl_out5=(./5.3_csRE_motif_enrichment_analysis/output/'`echo ${f1[$i]}`'_state5_ctrl.fa)
	bedtools getfasta -fi $fasta_in -fo $ctrl_out5 -bed $ctrl_bed5

	ctrl_bed8=(./5.1_identify_cell_specific_REs/output/state_specific_beds/'`echo ${f1[$i]}`'_consensus_8_state.bed)
        ctrl_out8=(./5.3_csRE_motif_enrichment_analysis/output/'`echo ${f1[$i]}`'_state8_ctrl.fa)
	bedtools getfasta -fi $fasta_in -fo $ctrl_out8 -bed $ctrl_bed8

	test_outE=(./5.3_csRE_motif_enrichment_analysis/output/'`echo ${f1[$i]}`'_enhState_test.fa)
	ctrl_outE=(./5.3_csRE_motif_enrichment_analysis/output/'`echo ${f1[$i]}`'_enhState_ctrl.fa)

	cat $test_out6 $test_out12 > $test_outE
	cat $ctrl_out6 $ctrl_out12 > $ctrl_outE




