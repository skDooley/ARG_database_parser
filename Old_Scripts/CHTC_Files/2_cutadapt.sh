#!/bin/bash

source ./source_file.sh

# directory for demultiplex output
FASTQ_FOLDER="illumina_reads/$PROJECT/$SET/demultiplexed_$SET"	

# make folder for demultiplxed, trimmed reads to output to
mkdir $GLUSTER/$FASTQ_FOLDER

# create individual folder for each fastq file to demultiplex into
fastq_file=`echo $1 | xargs -n 1 basename | cut -d'.' -f1`
mkdir $GLUSTER/$FASTQ_FOLDER/$fastq_file

# cutadapt demultiplexing command line
./cutadapt-1.8.3/bin/cutadapt -e 0 -g file:$BARCODES -o $GLUSTER/$FASTQ_FOLDER/$fastq_file/{name}.fastq $1

# remove any reads with unknown source
rm -r $GLUSTER/$FASTQ_FOLDER/$fastq_file/unknown.fastq
rm -r $GLUSTER/$FASTQ_FOLDER/$fastq_file/blank.fastq

# create list file with each individual that was extracted from the read file
ls $GLUSTER/$FASTQ_FOLDER/$fastq_file/* > $keys/entries.list
