#!/bin/bash

source ./source_file.sh

# directory for demultiplex output
FASTQ_FOLDER="illumina_reads/$PROJECT/$SET/demultiplexed_$SET"

entry=`echo $1 | xargs -n 1 basename | cut -d'.' -f1`

# make directory for alignment files
mkdir $OUTDIR/$SET

# concatenate all files from same entries
cat $GLUSTER/$FASTQ_FOLDER/*/$entry.fastq > $OUTDIR/$SET/$entry.fastq

# create list file with new fastq files for each entry
ls $OUTDIR/$SET/*.fastq > $keys/fastq.list

# format list to optimize for CONDOR queue system
cat $keys/fastq.list | sed -E 's|'$SET'/|'$SET'/,|g' | sed -E 's|.fastq||g' > $keys/fastqs.list
rm $keys/fastq.list

#find $OUTDIR/$SET -name "*.fastq" -size -50M > ommited.list

if [ -e $OUTDIR/$SET/individuals ] ;
	then : ;
	else mkdir $OUTDIR/$SET/individuals ;
fi