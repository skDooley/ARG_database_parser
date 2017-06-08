#!/bin/bah

length=$(($#-1))
Input=${@:1:$length}
Output=${@:$#}
the_path=$(dirname "${0}")


cat $Input > temp.txt


python $the_path/Working_Files/Identify_Unique_Genes.py temp.txt $Output


rm temp.txt
