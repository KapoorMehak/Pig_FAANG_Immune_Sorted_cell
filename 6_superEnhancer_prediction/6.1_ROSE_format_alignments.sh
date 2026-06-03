#!/bin/bash --login
#SBATCH --time=04:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=50G
#SBATCH --job-name 'ROSE_format_alignments'
#SBATCH --array=1-36


module load samtools/1.7-kglvk7q

i=$(($SLURM_ARRAY_TASK_ID - 1))

in=(`ls ./1_read_processing/output/ | grep -v 'K4' | grep -v 'K27me3' | grep -v 'bai' | grep -v 'CTCF' | grep 'merged.bam'`)
indir=(./1_read_processing/output)
names=(./1_read_processing/output/ | grep -v 'K4' | grep -v 'K27me3' | grep -v 'bai' | grep -v 'CTCF' | grep 'merged.bam' | perl -p -e 's{.+/(.+?).bam}{$1}'`)
outdir=(./6_superEnhancer_prediction)

samtools view -h $indir/${in[$i]} | sed -e '/^@SQ/s/SN\:/SN\:chr/' -e '/^[^@]/s/\t/\tchr/2'| awk -F ' ' '$7=($7=="=" || $7=="*"?$7:sprintf("chr%s",$7))' | tr " " "\t" | samtools view -bS > $outdir/${names[$i]}_chr.bam

samtools index $outdir/${names[$i]}_chr.bam
