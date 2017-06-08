#!/bin/bash


# name of sample set
SET="C5CUJACXX_5"
# name of project that sample set is in
PROJECT="NFPT"
# file with illumina raw data reads
illumina="C5CUJACXX_5.fastq"	
# ploidy
ploidy="4"
# number of cpu threads
t="2"


# shortcuts for programs
cutadapt="./cutadapt-1.8.3/bin/cutadapt"
bwa="bwa-0.7.12/bwa"
samtools="samtools-1.3/bin/samtools"
bedtools="bedtools2/bin/bedtools"
trim="java -jar trimmomatic-0.33/trimmomatic-0.33.jar"
picard="java -Xmx6g -jar picard-tools-1.138/picard.jar"
gatk="GenomeAnalysisTK-3.5/GenomeAnalysisTK.jar"
GATK="java -jar $gatk"
GATKvar="java -Xmx4g -jar $gatk"
catvariants="java -cp $gatk org.broadinstitute.gatk.tools.CatVariants"
filter='vcflib/bin/vcffilter -f "AC > 1"'

# commands to unzip program folders for Condor
if [ -e bwa.tar.gz ] ;
then tar -xzvf bwa.tar.gz ;
fi
if [ -e samtools.tar.gz ] ;
then tar -xzvf samtools.tar.gz ;
fi
if [ -e picard.tar.gz ] ;
then tar -xzvf picard.tar.gz ;
fi
if [ -e trimmomatic.tar.gz ] ;
then tar -xzvf trimmomatic.tar.gz ;
fi
if [ -e GATK.tar.gz ] ;
then tar -xzvf GATK.tar.gz ;
fi
if [ -e cutadapt.tar.gz ] ;
then tar -xzvf cutadapt.tar.gz ;
fi
if [ -e vcflib.tar.gz ] ;
then tar -xzvf vcflib.tar.gz ;
fi
if [ -e bedtools.tar.gz ] ;
then tar -xzvf bedtools.tar.gz ;
fi

# output directory name
GLUSTER="/mnt/gluster/sdsmith5"
OUTDIR="/mnt/gluster/sdsmith5/alignments"
# REF is the location/file for the reference genome
REF="/mnt/gluster/sdsmith5/Genome/PGSC_DM_v4.03"
# location for queue input files
keys="/mnt/gluster/sdsmith5/keys"
# file for barcodes for demultiplexing data
BARCODES="$GLUSTER/illumina_reads/$PROJECT/$SET/barcodes.fasta"