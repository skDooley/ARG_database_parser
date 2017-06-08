import sys
import pandas as pd

# File = pd.read_table(sys.argv[1], header=None)
# key = open(sys.argv[2], 'a+')

File = pd.read_table("/Users/schuyler/SS/Soil_reads.temp", header=None)
key = pd.read_table("/Users/schuyler/SS/soil_genes.list", header=None)


for i in range(len(File[1])):
	if File.iloc[i,1] in list(key[1]):
		print File[:][1]
	else:
		continue

print File
