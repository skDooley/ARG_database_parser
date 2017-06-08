source("https://bioconductor.org/biocLite.R")
#biocLite("DESeq2")
library("DESeq2")

## Raw read counts
Rockhopper_raw <- read.csv("~/Dropbox/ecoli_clusting/Rockhopper_raw.csv", header=TRUE, row.names=1)
## Metadata
Rockhopper_meta <- read.csv("~/Dropbox/ecoli_clusting/Rockhopper_meta.csv", header=TRUE, row.names=1)

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
dds_full <- DESeq(dds)
DESeq2_norm <- counts(dds_full, normalized=TRUE)

dds_group <- dds
dds_group$group <- factor(sub("_[0-9]$","",rownames(colData)))
dds_group$group <- factor(dds_group$group, levels=unique(dds_group$group))
design(dds_group) <- ~ group


