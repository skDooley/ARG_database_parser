import sys
from Bio import Entrez
import numpy as np
from Entrez_Function import pullOrganism
from Entrez_Function import unique
Entrez.email = "sdsmith@iastate.edu"

# File = '/Users/schuyler/SS/Manure_uniq/Tetracyclines.blast'
# Output = open('/Users/schuyler/SS/Test.out', 'w+')
# Taxo = 'phyla'


File = sys.argv[1]
Output = open(sys.argv[3], 'a+')
Taxo = sys.argv[2]

# Generate an array of the unique PubMed uniqIDs for the genes 
# This cuts down on the number of querries sent to NCBI by not sending duplicate requests
l_id = []
for line in open(File):
    try:
        dat = line.split()[1]
    except:
        dat = line.split()[0]
    if "unknown_id" in dat:
    	dat = "unknown_id"
    if "|" in dat:
    	if len(dat.split('|')) > 7 and "@" not in dat and "|gb|" not in dat:
    		if "Ecoli" in dat:
    			dat2 = dat.split('|')[3]
    		else:
	    		dat2 = dat.split('|')[2]
    	else:
    		dat2 = dat.split('|')[1]
        dat3 = dat2.split('.')[0]
        if "NC_" in dat3:
        	dat4 = str(dat3.split('_')[-2] + "_" + dat3.split('_')[-1])
        else:
		    dat4 = dat3.split('_')[-1]
        l_id.append(str(dat4))
    else:
        l_id.append(str(dat))


uniqIDs = np.unique(l_id)

# Generate a list of the corresponding organism names
org_list = []    
for ind in uniqIDs:
    try:
    	org = pullOrganism(ind, Taxo)
    except:
    	org = "NOT_FOUND-" + ind
    org_list.append(org)
  
# Replace uniqIDs in l_id for each read with corresponding organism name
for i in range(len(uniqIDs)):
	l_id = [w.replace(str(uniqIDs[i]), str(org_list[i])) for w in l_id]

# Writes array to file
for each in l_id:
    Output.write("%s\n" % each)
    # print ("%s\n" % each)




