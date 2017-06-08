import sys
import pandas as pd
import numpy as np

File = sys.argv[1]
Output = open(sys.argv[2], 'a+')

dat = pd.read_table(File, header=None)

x = np.array(dat[1])

unique, counts = np.unique(x, return_counts=True)

Key = []

for i in range(len(unique)):
	Key.append(str(str(unique[i]) + " " + str(counts[i])))

Key = pd.DataFrame(Key)
Key = Key[0].str.split(' ', 1, expand=True)
Key[1] = Key[1].astype(int)
Key = pd.DataFrame(Key).sort_values([1], ascending=False)


for i in range(len(Key)):
	Output.write(str(Key.iloc[i,1]) + "\t" + str(Key.iloc[i,0]) +"\n")

# #Looks at unique gene list
# for line in open(File):
#     gene = line.split('\t')[1]
#     if gene in Key:
#         # open(sys.argv[2], 'a+').write(line)
#         print gene

