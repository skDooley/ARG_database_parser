#!/bin/bash

mkdir Keys

while read f; do
	echo $f | awk '{print $2}' | tr ',' '\n' > Keys/`echo $f | awk '{print $1}'`.list
done < AR_DB_Classes

cat AR_DB_Classes | awk '{print $1}' > Classes.list
