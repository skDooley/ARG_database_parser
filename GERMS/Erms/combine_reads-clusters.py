import sys

# File1 = open('Moorman-primers/schuyler/map2.uniq.tsv', 'r')
File1 = open('/Users/schuyler/Box Sync/Moorman-primers (Adina Howe)/schuyler/map2.tsv', 'r')
File2 = open('/Users/schuyler/Box Sync/Moorman-primers (Adina Howe)/schuyler/cluster-map1.tsv', 'r')
Output = open('/Users/schuyler/Box Sync/Moorman-primers (Adina Howe)/schuyler/Reads_w_Clusters.list', 'a+')

reads = []
for line in File1:
	reads.append(line.split())
clusters = []
for cluster in File2:
	clusters.append(cluster.strip().split())

output = []
newline = ''
for cluster in clusters:
	for read in reads:
		for code in read:
			if any(code in info for info in cluster):
				# open('%s.list' % cluster[0], 'a+').write('%s\t%s\n' % (('\t'.join(read)), cluster[0])
				open('/Users/schuyler/Box Sync/Moorman-primers (Adina Howe)/schuyler/Reads_w_Clusters.list', 'a+').write('%s%s\t%s' % (newline, ('\t'.join(read)), cluster[0]))
				newline = '\n'

