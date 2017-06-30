#!/bin/bah

the_path=$(dirname "${0}")
length=$(($#-1))
Input=${@:1:$length}
Output=${@:$#}


cat $Input > $the_path/tmp_file.txt

python $the_path/Working_Files/Unique_Orgs.py $the_path/tmp_file.txt $Output

rm $the_path/tmp_file.txt
