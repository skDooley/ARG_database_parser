sort -ufk2,2 Soil/* > soil.uniq.blastout
sort -ufk2,2 Manure/* > manure.uniq.blastout

sort -ufk2,2 *.uniq.blastout > total.uniq.blastout

awk 'NR==FNR{c[$2]++;next};c[$2] == 0' soil.uniq.blastout manure.uniq.blastout > manure_genes.list
awk 'NR==FNR{c[$2]++;next};c[$2] == 0' manure.uniq.blastout soil.uniq.blastout > soil_genes.list


while read f; do grep $f Soil/* ; done < <(awk {'print $2'} soil_genes.list) > Soil_reads.fa
while read f; do grep $f Manure/* ; done < <(awk {'print $2'} manure_genes.list) > Manure_reads.fa
