source("https://bioconductor.org/biocLite.R")
#biocLite("DESeq2")
library("DESeq2")
library('MASS')
library('optCluster')
library ('vegan')
library ('cluster')
library("RColorBrewer")
library("gplots")
library('MBCluster.Seq')
library("vegan")
library("ape")
library("rgl")
library("pheatmap")

genes <- read.csv("~/Dropbox/ecoli_clustering/genelist1.txt", fill=TRUE, header=FALSE)

Rockhopper_raw <- read.csv("~/Dropbox/ecoli_clustering/Rockhopper_raw.csv", header=TRUE, row.names=1)
## Metadata
a <- Rockhopper_raw
Rockhopper_raw <- data.frame(MLC115_Empty_6hr=apply(a[,1:4],1,median), MLC115_Empty_12hr=apply(a[,5:8],1,median), MLC115_Empty_24hr=apply(a[,9:12],1,median), MLC115_TE_6hr=apply(a[,13:16],1,median), MLC115_TE_12hr=apply(a[,17:20],1,median), MLC115_TE_24hr=apply(a[,21:24],1,median), LAR1_Empty_6hr=apply(a[,25:28],1,median), LAR1_Empty_12hr=apply(a[,29:32],1,median), LAR1_Empty_24hr=apply(a[,33:36],1,median), LAR1_TE_6hr=apply(a[,37:40],1,median), LAR1_TE_12hr=apply(a[,41:44],1,median), LAR1_TE_24hr=apply(a[,45:48],1,median)) 
Rockhopper_meta <- read.csv("~/Dropbox/ecoli_clustering/Rockhopper_meta.csv", header=TRUE, row.names=1)
d <- unlist(strsplit(colnames(Rockhopper_raw), "_"))
dim(d) <- c(3, 12)
d <- t(d)
colData <- data.frame(row.names = colnames(Rockhopper_raw), strain = d[,1], plasmid = d[, 2], time = d[, 3])

design = ~ strain + plasmid + time + strain:plasmid + strain:time + plasmid:time + strain:plasmid:time
dds <- DESeqDataSetFromMatrix(countData = round(Rockhopper_raw), colData = colData, design = design)
dds$strain <- factor(dds$strain,levels=unique(colData[,1]))
dds$plasmid <- factor(dds$plasmid,levels=unique(colData[,2]))
dds$time <- factor(dds$time,levels=unique(colData[,3]))

dds_full <- DESeq(dds, test="Wald")
dds <- dds_full[row.names(dds_full) %in% genes[,1]]

dds_filtered <- dds[-grep("^pJMY|b0345", rownames(dds)),]
dds <- dds_filtered

vst=varianceStabilizingTransformation(dds)  
vsd=assay(vst)
pheatmap(cor(vsd))

mbcdata <- RNASeq.Data(counts(dds), Normalizer = sizeFactors(dds), Treatment = rep(1:12), GeneID = row.names(dds))
colnames(mbcdata$Count) <- colnames(dds)

mbcdata <- mbcdata$Count

abs_log <- function(x){
  x[x==0] <- 1
  si <- sign(x)
  si * log2(si*x)
}
dds <- data.frame(A=abs_log(mbcdata[,2]-mbcdata[,1]), B=abs_log(mbcdata[,4]-mbcdata[,3]), C=abs_log(mbcdata[,6]-mbcdata[,5]), D=abs_log(mbcdata[,8]-mbcdata[,7]), E=abs_log(mbcdata[,10]-mbcdata[,9]), G=abs_log(mbcdata[,12]-mbcdata[,11]))

dis = dist(dds)^2
res = kmeans(dds, 12)
sil = silhouette (res$cluster, dis)
plot(sil)

dds.pcoa=pcoa(vegdist(vsd,method="manhattan"))
scores=dds.pcoa$vectors
plot(scores[,1], scores[,2])




#dds = DESeq(dds) # takes quite some time


(mcols(dds) <- DataFrame(mcols(dds), Rockhopper_meta))


strain=as.character(colData(dds)$strain)
plasmid=as.character(colData(dds)$plasmid)
time=as.character(colData(dds)$time)
oneByTwo=paste(strain,plasmid,sep=".")
conditions=data.frame(cbind(strain,plasmid,oneByTwo))
dds.pcoa=pcoa(vegdist(vsd,method="manhattan"))
scores=dds.pcoa$vectors

plot(scores[,1], scores[,2])
ordispider(scores,factor2,label=T)
ordiellipse(scores,factor2)


mbcdata <- RNASeq.Data(counts(dds_erin), Normalizer = sizeFactors(dds_erin), Treatment = rep(1:12,4), GeneID = row.names(dds_erin))







counts<-read.csv("~/Dropbox/ecoli_clustering/DESeq2_normalized_RNASeq.csv", fill=TRUE)
mergedcounts<-read.csv("~/Dropbox/ecoli_clustering/DESeq2_normalized_RNASeq_merged.csv", fill=TRUE)
deltacounts<-read.csv("~/Dropbox/ecoli_clustering/DESeq2_normalized_RNASeq_deltas.csv", fill=TRUE)
deltacont<-read.csv("~/Dropbox/ecoli_clustering/DESeq2_normalized_RNASeq_difffromcontrol.csv", fill=TRUE)[,-1]


log2counts <- mergedcounts

log2counts[,5:16] <- log2(log2counts[,5:16]/rep(mean(),4))


a <- log2counts
a <- a[which(genes[,1] %in% a$X),][,-1]
b <- a[,4:15]


parcoord(a[,4:6], col=rainbow(length(a[,1])), var.label=TRUE)
parcoord(a[,7:9], col=rainbow(length(a[,1])), var.label=TRUE)
parcoord(a[,10:12], col=rainbow(length(a[,1])), var.label=TRUE)
parcoord(a[,13:15], col=rainbow(length(a[,1])), var.label=TRUE)

?
### Heirarchical
clusters <- hclust(dist(b))
plot(clusters)

### Kmeans
mbcdata <- RNASeq.Data(counts(dds), Normalizer = sizeFactors(dds), Treatment = rep(1:12), GeneID = row.names(dds))
dis = dist(b)^2
res = kmeans(mbcdata$logFC,15)
sil = silhouette (res$cluster, dis)
plot(sil)

newCountDataSet(b, colData)
cdsFullBlind = estimateDispersions(dds_erin, method = "blind" )
vsdFull = varianceStabilizingTransformation( cdsFullBlind )
select = order(rowMeans(counts(cdsFull)), decreasing=TRUE)[1:30]
hmcol = colorRampPalette(brewer.pal(9, "GnBu"))(100)
heatmap.2(exprs(vsdFull)[select,], col = hmcol, trace="none", margin=c(10, 6))



boxplot(t(counts(dds_erin["b0009",], normalized=FALSE))~rep(1:12, each = 4))
boxplot(t(counts(dds_erin["b0009",], normalized=FALSE))~rep(1:12, each = 4))
boxplot(t(counts(dds_erin["b0009",], normalized=TRUE))~rep(1:12, each = 4))
plot(mbcdata$logFC[mbcdata$GeneID=="b0009"])


mbcdata$GeneID[res$cluster==1]
matplot(t(mbcdata$logFC[res$cluster==1,]), pch=16, type='l')
