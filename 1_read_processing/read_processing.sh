#1.1 trim reads
module load trimgalore/0.4.5-py2-n7kavxd
r1=(./*_R1_001.fastq.gz)
r2=(./*_R2_001.fastq.gz)
out=(./1_read_processing/1.1_trim_reads/output/)
trim_galore --gzip --output_dir $out --paired $r1 $r2


#1.2 align reads

module load bwa/0.7.17-zhcbtza samtools/1.9-k6deoga
module load bwa/0.7.17-zhcbtza
module load samtools/1.9-k6deoga
genome=(./pig.genome/Sus_scrofa.Sscrofa11.1.dna.toplevel.fa)

bwa index $genome
index=(./pig.genome/Sus_scrofa.Sscrofa11.1.dna.toplevel.fa)
fq1=(./1_read_processing/1.1_trim_reads/output/*_R1_001_val_1.fq.gz)
fq2=(./1_read_processing/1.1_trim_reads/output/*_R2_001_val_2.fq.gz)
outdir=(./1_read_processing/1.2_align_reads/output)
bwa mem -t 8 $index $fq1 $fq2 | samtools view -bS > $outdir/*_out.bam
bam=($outdir/*_out.bam)
stat_out=($outdir/mapping_stats/*_mapping_stats.txt)
samtools flagstat $bam > $stat_out
samtools view -h -F 1804 -q 30 $bam | grep -v XA:Z | grep -v SA:Z | samtools view -S -b - > $outdir/*_filtered.bam
rm $bam

#1.3 sort filter alignments
module load picard/2.17.0-ft5qztz samtools/1.9-k6deoga
in=(./1_read_processing/1.2_align_reads/output/*_filtered.bam)
out_sort=(./1_read_processing/1.3_sort_filter_alignments/output/*_filtered_sorted.bam)
dup_metrics=(./1_read_processing/1.3_sort_filter_alignments/output/dedup_stats/*_filtered_out.dup_metrics)
out_dedup=(./1_read_processing/1.3_sort_filter_alignments/output/*_filtered_dedup.bam)
picard SortSam INPUT=$in OUTPUT=$out SORT_ORDER=coordinate | picard MarkDuplicates OUTPUT=$out_dedup METRICS_FILE=$dup_out REMOVE_DUPLICATES=false ASSUME_SORTED=true | samtools view -b -q 15 > $filtered_out
picard MarkDuplicates INPUT=$out_sort OUTPUT=$out_dedup METRICS_FILE=$dup_out REMOVE_DUPLICATES=false ASSUME_SORTED=true
rm $sorted_in
#merge alignments
indir=(./1_read_processing/1.3_sort_filter_alignments/output/)
out=(./1_read_processing/1.3_sort_filter_alignments/output/*_merged.bam)
samtools merge $out $indir/*_**dedup.bam
samtools index $out


#1.4 peak calling
module load samtools/1.9-k6deoga py-macs2/2.1.1.20160309-py2-wgwiexf
ip=(./1_read_processing/1.3_sort_filter_alignments/output/**merged.bam)
input=(./1_read_processing/1.3_sort_filter_alignments/output/*input**merged.bam)
outdir=(./1_read_processing/1.4_peak_calling/output)
exp="celltype"
macs2 callpeak --outdir $outdir -g 2.45E09 -q 0.01 -c $input -t $ip -f BAMPE -n $exp



