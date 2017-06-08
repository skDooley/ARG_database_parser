#!/bin/bash

source ./source_file.sh

# removes vcfs of size 0
find $OUTDIR/$SET/VCFs -size 0 -print0 | xargs -0 rm

# creates a list file of the VCFs
ls -v $OUTDIR/$SET/VCFs/*.vcf > $keys/VCF.list

# concatenates the vcf files into one
$catvariants -R $REF.fasta -V $keys/VCF.list -out $OUTDIR/$SET/$SET.vcf -assumeSorted

# create vcfs containing only SNPs and only indels
$GATK -T SelectVariants -R $REF.fasta -V $OUTDIR/$SET/$SET.vcf -selectType SNP -o $OUTDIR/$SET/$SET.raw_snps.vcf
$GATK -T SelectVariants -R $REF.fasta -V $OUTDIR/$SET/$SET.vcf -selectType INDEL -o $OUTDIR/$SET/$SET.raw_indels.vcf
