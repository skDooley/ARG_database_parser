#!/bin/bash
the_path=$(dirname "${0}")
length=$(($#-1))
Input=${@:1:$length}
Output=${@:$#}

 
if [ ! -d $Output/Card ]; then
	mkdir -p $Output/Int
	mkdir $Output/Card
	mkdir -p $Output/Megares
fi

while read class; do
	if [ ! -d $Output/Megares/$class ]; then
		mkdir $Output/Megares/$class
	fi
done < $the_path/Working_Files/Classes.list

for file in $Input; do
	python $the_path/Working_Files/Parse.py $file $the_path $Output
done

# rm -r $Output/Card


# awk '{print $1, $NF}' FS=/ S1_S3_L003.Counts.list | awk '{print $1 "\t" $3}'