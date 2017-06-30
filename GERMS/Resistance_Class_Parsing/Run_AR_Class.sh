#!/bin/bash
the_path=$(dirname "${0}")
length=$(($#-1))
Input=${@:1:$length}
Output=${@:$#}

 


if [ ! -d $Output ]; then
	mkdir -p $Output
fi

for file in $Input; do
	python $the_path/Working_Files/Identify_AR_Class.py $file $the_path $Output
done



