#!/bin/bash

fasta=~/Datasets/Genome/PGSC_DM_v4.03.fasta
output=~/Datasets/Genome/potato_reference_positions.txt

#puts all bps on one line
cat $fasta | sed '/>/d' | tr -d '\n' > $output


#puts one bp per line
cat $fasta | sed '/>/d' | sed -e 's/\(.\)/\1\'$'\n/g' > $output.2
