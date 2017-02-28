#!/bin/bash
the_path=$(dirname "${0}")
length=$(($#-1))
Input=${@:1:$length}
Output=${@:$#}

if [ ! -d $Output/blast_Files/Card ]; then
	mkdir -p $Output/blast_Files/Int
	mkdir $Output/blast_Files/Card
fi


for file in $Input; do
	python $the_path/Working_Files/Parse.py $file $the_path $Output/blast_Files
done

rm -r $Output/blast_Files/Card

wc -l $Output/blast_Files/*.blast | cut -f1 -d '.' | sed 's|Output/blast_Files/||g' | sed '/total/d' > $Output/Counts.list


