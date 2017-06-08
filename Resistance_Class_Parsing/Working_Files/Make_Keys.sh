#!/bin/bash

the_path=$(dirname "${0}")

mkdir $the_path/Keys

while read f; do
	echo $f | awk '{print $2}' | tr ',' '\n' > $the_path/Keys/`echo $f | awk '{print $1}'`.list
done < $the_path/AR_DB_Classes

cat $the_path/AR_DB_Classes | awk '{print $1}' > $the_path/Classes.list
