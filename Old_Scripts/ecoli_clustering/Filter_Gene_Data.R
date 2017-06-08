source("https://bioconductor.org/biocLite.R")
#biocLite("DESeq2")
library("DESeq2")
library('MASS')

Rockhopper_raw <- read.csv("~/Dropbox/ecoli_clustering/Rockhopper_raw.csv", header=TRUE, row.names=1)
## Metadata
Rockhopper_meta <- read.csv("~/Dropbox/ecoli_clustering/Rockhopper_meta.csv", header=TRUE, row.names=1)
d <- unlist(strsplit(colnames(Rockhopper_raw), "_"))
dim(d) <- c(4, 48)
d <- t(d)
colData <- data.frame(row.names = colnames(Rockhopper_raw), strain = d[,1], plasmid = d[, 2], time = d[, 3])

design = ~ strain + plasmid + time + strain:plasmid + strain:time + plasmid:time + strain:plasmid:time
dds <- DESeqDataSetFromMatrix(countData = Rockhopper_raw, colData = colData, design = design)
dds$strain <- factor(dds$strain,levels=unique(colData[,1]))
dds$plasmid <- factor(dds$plasmid,levels=unique(colData[,2]))
dds$time <- factor(dds$time,levels=unique(colData[,3]))

(mcols(dds) <- DataFrame(mcols(dds), Rockhopper_meta))

dds_full <- DESeq(dds, test="Wald")
DESeq2_norm <- counts(dds_full, normalized=TRUE)

resNames <- resultsNames(dds_full)[6]
temp <- results(dds_full, name = resNames, alpha = 0.05)

gene_list <- row.names(subset(temp, padj<0.05))
#dds_full[row.names(dds_full) %in% gene_list,]
gene_list <- subset(temp, abs(temp$log2FoldChange)>=2)

counts<-read.csv("~/Dropbox/ecoli_clustering/DESeq2_normalized_RNASeq.csv", fill=TRUE)
mergedcounts<-read.csv("~/Dropbox/ecoli_clustering/DESeq2_normalized_RNASeq_merged.csv", fill=TRUE)
deltacounts<-read.csv("~/Dropbox/ecoli_clustering/DESeq2_normalized_RNASeq_deltas.csv", fill=TRUE)
deltacont<-read.csv("~/Dropbox/ecoli_clustering/DESeq2_normalized_RNASeq_difffromcontrol.csv", fill=TRUE)
genes <- read.csv("~/Dropbox/ecoli_clustering/genelist1.txt", fill=TRUE)
a <- deltacont[which(mergedcounts$X %in% gene_list),]


#parcoord(a[,1:3], col=rainbow(length(a[,1])), var.label=TRUE)
#parcoord(a[,4:6], col=rainbow(length(a[,1])), var.label=TRUE)
#parcoord(a[,7:9], col=rainbow(length(a[,1])), var.label=TRUE)

a <- deltacont[apply(abs(as.matrix(deltacont[,8:16])), 1, function(r) any(r >= 20)), 8:16]




clusters <- hclust(dist(a))
plot(clusters)

kcluster <- kmeans(a, 4)
kcluster$cluster <- as.factor(kcluster$cluster)
kcluster

mergedcounts[kcluster$cluster==1,]
matplot(c(1:12), mergedcounts[kcluster$cluster==1,])

optCluster(a[,4:15], 2:10, clMethods = c("hierarchical", "kmeans"), countData = "FALSE", distance = "Spearman")

clvalid

