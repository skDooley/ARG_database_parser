#!/bin/bash

source ./source_file.sh

if [ -e $OUTDIR/$SET/VCFs ] ;
	then : ;
else mkdir $OUTDIR/$SET/VCFs ;
fi

ls $OUTDIR/$SET/GVCFs/*.gvcf > $keys/gvcf.list

$GATKvar -T GenotypeGVCFs -R $REF.fasta -V $keys/gvcf.list -o $OUTDIR/$SET/VCFs/$1.vcf -ploidy $ploidy -stand_call_conf 30 -stand_emit_conf 30 -L $1

