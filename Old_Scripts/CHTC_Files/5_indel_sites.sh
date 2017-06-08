#!/bin/bash

source ./source_file.sh

entry=`echo $1 | xargs -n 1 basename | cut -d'.' -f1`

if [ -e $OUTDIR/$SET/realignments_targets ] ;
	then : ;
	else mkdir $OUTDIR/$SET/realignments_targets ;
fi


if [ -e $OUTDIR/$SET/realigned_reads ] ;
	then : ;
	else mkdir $OUTDIR/$SET/realigned_reads ;
fi

# GATK creates lists of possible indel locations by comparing the alignments to the reference
$GATKvar -T RealignerTargetCreator -R $REF.fasta -I $1 -o $OUTDIR/$SET/realignments_targets/$entry.list -L $keys/regions.list

# GATK attempts to realign the reads to accomodate the indels and creates new bam files
$GATKvar -T IndelRealigner -R $REF.fasta -I $1 -targetIntervals $OUTDIR/$SET/realignments_targets/$entry.list -o $OUTDIR/$SET/realigned_reads/$entry.bam

ls $OUTDIR/$SET/realigned_reads/*.bam > $keys/realigned_bams.list

