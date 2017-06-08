#!/bin/bash

source ./source_file.sh

if [ -e $OUTDIR/$SET/realignments_targets/ ] ;
	then rm -r $OUTDIR/$SET/realignments_targets/ ;
fi

if [ -e $OUTDIR/$SET/GVCFs ] ;
	then : ;
else mkdir $OUTDIR/$SET/GVCFs ;
fi

entry=`echo $1 | xargs -n 1 basename | cut -d'.' -f1`

# command line for calling haplotypes and creating a VCF for each entry
$GATKvar -T HaplotypeCaller -R $REF.fasta -I $1 -o $OUTDIR/$SET/GVCFs/$entry.gvcf -ploidy $ploidy -stand_call_conf 30 -stand_emit_conf 30 --genotyping_mode DISCOVERY --output_mode EMIT_ALL_SITES -maxNumHaplotypesInPopulation 360 --minDanglingBranchLength 1 -drf DuplicateRead -ERC GVCF -variant_index_type LINEAR -variant_index_parameter 128000

rm $OUTDIR/$SET/GVCFs/*.idx
