def unique(seq):
    seen = set()
    seen_add = seen.add
    return [x for x in seq if not (x in seen or seen_add(x))]

def pullOrganism(ID, Level):
    from Bio import Entrez
    retdata = Entrez.efetch(db="nucleotide", id=ID, rettype='gb', retmode='text').read().split("\n")    
    if Level.lower()[0] == "p":
        Level = 1
    elif Level.lower()[0] == "c":
        Level = 2
    elif Level.lower()[0] == "o":
        Level = 3
    elif Level.lower()[0] == "f":
        Level = 4
    elif Level.lower() == "genus":
        Level = 5
    elif Level.lower()[0:2] == "sp":
        Level = 6
    elif Level.lower() == "strain":
        Level = 7
    elif Level.lower()[0] == "a":
        Level = 8
    elif Level.lower()[0:4] == "gene":
        Level = 9

    flag1 = False
    flag2 = False
    Tax = []
    for line in retdata:
        if Level == 7:
            if "ORGANISM" in line:
                a = ' '.join(line.split()[1:])
            if "strain=" in line:
                b = line.split('=')[1].replace('"', '')
                if b in a:
                    return a
                else:
                    return a + " " + b
            if "ORIGIN" in line:
                return a
            if "ORIGIN" in line:
                return "NA"
            else:
                continue
        if Level == 9:
            if "gene=" in line:
                return line.split('=')[1].replace('"', '')
            else:
                continue
        if Level == 8:
            if flag1 == True and "REFERENCE" not in line.split():
                Tax.append(' '.join(line.split()))
                if '.' in line:
                    Tax.append(a)
                    Tax = ' '.join(map(str, Tax)).replace(';', '').replace('.', '')
                    Tax = unique(Tax.split())
                    a = ' '.join(map(str, Tax)).replace(';', '').replace('.', '')
                    Level = 7 
                    flag1 = False
                else:
                    continue
            if "ORGANISM" in line.split()[0]:
                a = ' '.join(line.split()[1:])
                flag1 = True
                continue   

        if flag1 == True:
            if "unclassified phages" in line:
                return "unclassified_phages"
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
                return "uncultured_bacterium"
            if "Plasmid" in line:
                return "Plasmid"
            if "human gut metagenome" in line:
                return "human_gut_metagenome"
            if Level == 6 or Level == 5:
                return line.split(" ")[Level-1]
            flag1 = True


