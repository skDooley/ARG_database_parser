import sys
File = sys.argv[1]
Key = sys.argv[2]

#Looks at unique gene list to
for line in open(File):
    gene = line.split('\t')[1]
    if gene in open(Key).read():
        open(sys.argv[3], 'a+').write(line)

