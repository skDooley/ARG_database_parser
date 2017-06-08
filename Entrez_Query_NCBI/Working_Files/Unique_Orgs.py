import sys
import numpy as np
File = 'uniq_orgs.in'
Output = open('uniq_orgs.out', 'w')

#Creates a list of the organism names from useEntrez output
org_list = []
for line in open(File):
	dat = line.split('\n')[0]
	dat = dat.split(' ')[0]
	org_list.append(dat)	

#Counts and uniques the organism names - puts into a table
x = np.array(org_list)
codes, counts = np.unique(x, return_counts=True)
table = np.asarray((codes, counts)).T

#Writes table to file
for item in table:
	out = ("\t".join(item))
 	Output.write(str("%s\n") % out)

