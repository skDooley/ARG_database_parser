from Bio import Entrez
Entrez.email = "sdsmith@iastate.edu"

def pullOrganism(ID, Level):
    
    if Level.lower() == "phylum":
        Level = 1
    elif Level.lower() == "class":
        Level = 2
    elif Level.lower() == "order":
        Level = 3
    elif Level.lower() == "family":
        Level = 4
    elif Level.lower() == "genus":
        Level = 5
    elif Level.lower() == "species":
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

print pullOrganism("CBR26934", "Class")