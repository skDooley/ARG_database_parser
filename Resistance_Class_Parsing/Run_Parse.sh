#!/bin/bash
the_path=$(dirname "${0}")
length=$(($#-1))
Input=${@:1:$length}
Output=${@:$#}

 


if [ ! -d $Output/Card ]; then
	mkdir -p $Output/Int
	mkdir $Output/Card
	mkdir $Output/Megares
fi

while read class; do
	mkdir $Output/Megares/$class
done < $the_path/Working_Files/Classes.list

for file in $Input; do
	python $the_path/Working_Files/Parse.py $file $the_path $Output
done

rm -r $Output/Card

wc -l $Output/*.blast | cut -f1 -d '.' | sed "s|$Output/||g" | sed '/total/d' > $Output/$Entry.Counts.list
wc -l $Output/Int/*.blast | cut -f1 -d '.' | sed "s|$Output/Int/||g" | tail -n 1 | sed "s|total|Int|" >> $Output/$Entry.Counts.list
wc -l $Output/Int/*.blast | cut -f1 -d '.' | sed "s|$Output/Int/||g" | sed '/total/d' > $Output/$Entry.Int_Count.list


# awk '{print $1, $NF}' FS=/ S1_S3_L003.Counts.list | awk '{print $1 "\t" $3}'