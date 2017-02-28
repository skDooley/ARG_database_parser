#!/bin/bash
the_path=$(dirname "${0}")
length=$(($#-2))
Input=${@:1:$length}
Output=${@:$#}
Taxo=${@:(-2):1}

#rm $Output

cat $Input > $Output.tmp

python $the_path/Working_files/useEntrez.py $Output.tmp $Taxo $Output

rm $Output.tmp
