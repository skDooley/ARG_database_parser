import sys

# File1 = open('Moorman-primers/schuyler/map2.uniq.tsv', 'r')
File1 = open('Moorman-primers/schuyler/map2.uniq.tsv', 'r')
File2 = open('Moorman-primers/schuyler/cluster-map1.tsv', 'r')


reads = []
for line in File1:
	reads.append(line.split())
clusters = []
for cluster in File2:
	clusters.append(cluster.strip().split())

output = []
for cluster in clusters:
	for read in reads:
		for code in read:
			if any(code in info for info in cluster):

				# open('%s.list' % cluster[0], 'a+').write('%s\t%s\n' % (('\t'.join(read)), cluster[0])
				open('Reads_w_Clusters.list', 'a+').write('%s\t%s\n' % (('\t'.join(read)), cluster[0]))



