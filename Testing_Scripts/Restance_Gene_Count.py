import pandas as pd
import numpy as np

File = "/Users/schuyler/Box Sync/for-schuyler/for-schuyler/blast-output-files/M1_S1_L001_pe1.fa.blastnout.best"

gene_list = []
gl = pd.read_table(File, header=None)


for line in gl[1]:
	dat = line.split('|')[-1]
	gene_list.append(dat)	

x = np.array(gene_list)

unique, counts = np.unique(x, return_counts=True)

print np.asarray((unique, counts)).T