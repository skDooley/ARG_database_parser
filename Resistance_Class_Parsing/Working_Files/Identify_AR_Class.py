import sys
import os
Input = sys.argv[1]
working_files_path = sys.argv[2]
Output = sys.argv[3]

out = open('%s/All.list'  %(Output), 'a+')

for line in open(Input):
    line = line.rstrip().strip('\"')
    try:
        dat = line.split('\t')[1]
    except:
        dat = line.split('\t')[0]
    dat2 = dat.split('|')[-1]
    dat3 = dat2.split('_')[-1]

    if dat3.lower() == "int":
        gene = dat2.split('_int')[0]
        gene = gene.replace("/","_")

    elif dat3.lower() == "card":
        gene = dat2.split('_')[0][:3]
        if gene.lower() in open('%s/Working_Files/AR_DB_Classes' % (working_files_path)).read().lower():
            for AB_class in open('%s/Working_Files/Classes.list' %working_files_path):
                AB_C = AB_class.split('\n')[0]
                if gene.lower() in open('%s/Working_Files/Keys/%s.list' %(working_files_path, AB_C)).read().lower():
                    gene = AB_C
        else:
            gene = "uncategorized"

    elif dat3.lower() == "megares":
        gene = dat.split('|')[-3]

    out.write(gene + '\t' + line + '\n')

