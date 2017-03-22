import sys
import numpy as np
from Bio import Entrez

Entrez.email = "sdsmith@iastate.edu"

# File = '/Users/schuyler/Dropbox/Testing_Scripts/Reads_w_Clusters.list.uniq'
# Taxo = 'phylum'

File = sys.argv[1]
Output = open(sys.argv[3], 'a+')
Taxo = sys.argv[2]

def pullOrganism(ID, Level):
    
    if Level.lower()[0] == "p":
        Level = 1
    elif Level.lower()[0] == "c":
        Level = 2
    elif Level.lower()[0] == "o":
        Level = 3
    elif Level.lower()[0] == "f":
        Level = 4
    elif Level.lower()[0] == "g":
        Level = 5
    elif Level.lower()[0] == "s":
        Level = 6
    
    retdata = Entrez.efetch(db="protein", id=ID, rettype='gb', retmode='text').read().split("\n")
    flag1 = False
    flag2 = False
    for line in retdata:
        if flag1 == True:
            if "unclassified phages" in line:
                return "unclassified phages"
            if flag2 == True:
                return line.strip().split("; ")[int(Level)].strip(';')
            if len(line.strip().split("; ")) == 5 and Level == 4:
                return line.strip().split("; ")[int(Level)].strip(';')
            elif Level == 4:
                flag2 = True
                Level += -4
                continue
            return line.strip().split("; ")[int(Level)].strip(';')
        if "ORGANISM" in line.split()[0]:
            if "uncultured" in line:
                return "uncultured bacterium"
            if "Plasmid" in line:
                return "Plasmid"
            if Level == 6 or Level == 5:
                return line.split(" ")[Level-1]
            flag1 = True


# Generate an array of the unique PubMed codes for the genes 
# This cuts down on the number of querries sent to NCBI by not sending duplicate requests
l_id = []
for line in open(File):
    dat = line.split('\t')[1]
    if "|" in dat:
        dat2 = dat.split('|')[1]
        dat3 = dat2.split('.')[0]
        l_id.append(str(dat3))
    else:
        l_id.append(str(dat))

codes = np.unique(l_id)

# Generate a list of the corresponding organism names
org_list = []    
for ind in codes:
    try:
    	org = pullOrganism(ind, Taxo)
    except:
    	org = "NOT_FOUND-" + ind
    org_list.append(org)
  
# Replace codes in l_id for each read with corresponding organism name
for i in range(len(codes)):
	l_id = [w.replace(codes[i], org_list[i]) for w in l_id]

# Writes array to file
for item in l_id:
    Output.write("%s\n" % item)




