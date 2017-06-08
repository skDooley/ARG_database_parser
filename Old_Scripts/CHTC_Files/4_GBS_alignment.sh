#!/bin/bash

source ./source_file.sh

O="$OUTDIR/$SET/individuals/$2"

# make directory for each entry then move the fastq file into the folder
mkdir $O
mv $1$2.fastq $O

#$trim SE -threads $t $O/$2.fastq $O/$2.trim.fastq CROP:64

# align reads to reference genome
$bwa mem -t $t -M $REF.fasta $O/$2.fastq | $samtools addreplacerg -r ID:$SET -r SM:$2 -r LB:$2 -r PL:illumina -r PU:none - | $samtools view -bS -q 1 -F 314 - | $samtools sort - -o $O/$2.bam

# indexes the alignemnt file for GATK
$picard BuildBamIndex I=$O/$2.bam

ls $OUTDIR/$SET/individuals/*/*.bam > $keys/bamfile.list

$samtools cat $OUTDIR/$SET/individuals/*/*.bam | $bedtools bamtobed -i - | $bedtools merge -d 100000 -i - | sed 's/	/':'/' | sed 's/	/-/' > $keys/regions.list

$bedtools makewindows -g $REF.fasta.fai -w 2000000 | sed 's/	/:/' | sed 's/	/-/' | sed 's/:0/:1/' > $keys/intervals.list 
