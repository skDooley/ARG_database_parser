sort -ufk2 MS_Analysis/soil/reads/* > soil.uniq.blastout
sort -ufk2 MS_Analysis/manure/read/* > manure.uniq.blastout

sort -ufk2,2 *.uniq.blastout > total.uniq.blastout

awk 'NR==FNR{c[$2]++;next};c[$2] == 0' soil.uniq.blastout manure.uniq.blastout > manure_genes.list
awk 'NR==FNR{c[$2]++;next};c[$2] == 0' manure.uniq.blastout soil.uniq.blastout > soil_genes.list


