#!/bin/bash
the_path=$(dirname "${0}")
length=$(($#-2))
Input=${@:1:$length}
Taxo=${@:(-2):1}
Output=${@:$#}


#rm $Output

cat $Input > $Output.tmp

python $the_path/Working_Files/useEntrez.py $Output.tmp $Taxo $Output

rm $Output.tmp
