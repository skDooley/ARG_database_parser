#!/bin/bash

source ./source_file.sh

#mkdir $GLUSTER/illumina_reads/$PROJECT
#mkdir $GLUSTER/illumina_reads/$PROJECT/$SET
#mv $GLUSTER/illumina_reads/$illumina.gz $GLUSTER/illumina_reads/$PROJECT/$SET
#mv $GLUSTER/illumina_reads/barcodes.fasta $GLUSTER/illumina_reads/$PROJECT/$SET

# unzip compressed illumina reads
#gunzip $IN_FASTQ.gz


# original illumina reads file
IN_FASTQ="/mnt/gluster/sdsmith5/illumina_reads/$PROJECT/$SET/$illumina"
# prefix for 10m read files from original
OUT_FASTQ="/mnt/gluster/sdsmith5/illumina_reads/$PROJECT/$SET/sm_$SET"



# splits illumina read files into smaller files of 10,000,000 reads each ~ 2.4gb
split -l 4000000 $IN_FASTQ $OUT_FASTQ

# create list of new, smaller fastq files then adds the .fastq extension for cutadapt to recognize it
list=`ls $OUT_FASTQ*`
for file in $list; do mv $file $file.fastq; done

# create list file with directory locations of each new file
ls $OUT_FASTQ* > $keys/reads.list
 	