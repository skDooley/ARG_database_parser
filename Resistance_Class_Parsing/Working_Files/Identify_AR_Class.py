import sys
import os
import multiprocessing as mp

if mp.cpu_count <= 2:
    cores = 1
else:
    cores = 1 + mp.cpu_count()//2

# Input = sys.argv[1]
# working_files_path = sys.argv[2]
# Output = sys.argv[3]

Input = "/Users/schuyler/SS/test/input.txt"
working_files_path = "/Users/schuyler/Dropbox/Scripts/Resistance_Class_Parsing"
Output = "/Users/schuyler/SS/test/out"
out = open('%s/All.list'  %(Output), 'a+')

def ARG_ID(line):

    line = line.rstrip().strip('\"')
    try:
        dat = line.split()[1]
    except:
        dat = line.split()[0]
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
    return(gene + '\t' + line + '\n')

pool = mp.Pool(processes=cores)
results = pool.map(ARG_ID, open(Input))

for line in results:
        out.write(line)


