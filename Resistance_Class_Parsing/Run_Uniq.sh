#!/bin/bah

length=$(($#-1))
Input=${@:1:$length}
Output=${@:$#}
Key='soil_genes.list'

for file in $Input; do
	python Working_Files/Identify_Unique_Genes.py $file $Key $Output
done

