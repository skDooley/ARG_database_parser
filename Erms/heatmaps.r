Png <- function(..., width=8, height=8, res=300){
  png(..., width=width*res, height=height*res, res=res)
}
#library('ggplot2')
#library('reshape')
#library('gplots')
#library('stringr')

## Read in result from Entrez for each taxonomical level and the reads from the reads-clusters script
reads <- read.table("~/Dropbox/Testing_Scripts/Reads_w_Clusters.tsv", header=F)
phylum <- read.table("~/Dropbox/Testing_Scripts/Phylum_Clusters.list", header=F, fill=T, sep="	")
class <- read.table("~/Dropbox/Testing_Scripts/Class_Clusters.list", header=F, fill=T,sep="	")
order <- read.table("~/Dropbox/Testing_Scripts/Order_Clusters.list", header=F, fill=T,sep="	")
family <- read.table("~/Dropbox/Testing_Scripts/Family_Clusters.list", header=F, fill=T,sep="	")
genus <- read.table("~/Dropbox/Testing_Scripts/Genus_Clusters.list", header=F, fill=T,sep="	")
species <- read.table("~/Dropbox/Testing_Scripts/Species_Clusters.list", header=F, fill=T,sep="	")


## set all the data into one data fram to pull from in further analysis
y1 <- reads[,4]
set <- data.frame("Cluster"=y1, "Phylum"=phylum[,1], "Class"=class[,1], "Order"=order[,1], "Family"=family[,1], "Genus"=genus[,1], "Species"=species[,1])
#set <- set[c(-which(set$Phylum=="uncultured bacterium"),-which(set$Phylum=="unclassified phages."),-which(set$Phylum=="metagenomes")),]
set <- set[order(as.integer(str_split_fixed(set$Cluster, "_", 2)[,2])),]

## tables the data based on Phylum and removes uninformative classes
set0<-as.matrix(as.data.frame.matrix(table(set$Cluster, set$Phylum)))
set0 <- set0[,-c(6,11,12)]

## puts into numerical order (not actually relevant any longer because of matching to tree order below)
set0 <- set0[order(as.integer(str_split_fixed(rownames(set0), "_", 2)[,2])),]

## removes clusters that have no entries (again, not actually relevant becasuse of matching with tree below)
set0 <- set0[-which(rowSums(set0)==0),]

## calculates distributions for each cluster, values are not evenly distributed across all clusters, so this normalizes the data to make a better visual
set1<-sweep(set0, 1, rowSums(set0), '/')


## tree info
library(phytools)
tree <- read.newick(file="~/Box Sync/Moorman-primers/tree-making/tree")
tree <- collapse.singles(tree)
library(ape)
tree <- read.tree("~/Box Sync/Moorman-primers/tree-making/tree")
tree_rooted <- root(tree, outgroup="Cluster4", resolve.root=TRUE)
is.rooted(tree_rooted)
plot(tree_rooted)
rep_tree <- tree_rooted
rep_tree$edge.length[which(rep_tree$edge.length == 0)] <- 0.00001
rep_tree_um <- chronopl(rep_tree,
                        lambda = 0.1,
                        tol = 0)
rep_tree_d <- as.dendrogram(as.hclust.phylo(rep_tree_um))
clade_order <- order.dendrogram(rep_tree_d)
clade_name <- labels(rep_tree_d)
clade_position <- data.frame(clade_name, clade_order)
clade_position <- clade_position[order(clade_position$clade_order),]
abund <- read.delim(sep='\t', file="~/Box Sync/Moorman-primers/tree-making/all-summary.txt", header=TRUE, row.names=1, check.names=TRUE)
new_order <- match(clade_position$clade_name, row.names(abund)    )
new_order[is.na(new_order)] <- 0
combined_ordered_matrix <- abund[new_order,]
combined_ordered_matrix2 <- as.matrix(sapply(combined_ordered_matrix, as.numeric))
rownames(combined_ordered_matrix2) <- rownames(combined_ordered_matrix)
library(colorRamps)
color <- colorRampPalette(c('red','yellow','green'))(10)
library(gplots)


## merging organism data with tree and retaining order of the clusters in the tree
rownames(set1) <- str_replace_all(rownames(set1), "[[:punct:]]", "")
set2 <- merge(data.frame(Names=rownames(combined_ordered_matrix2)), set1, by.x="Names", by.y=0, all.x=TRUE)
rownames(set2) <- set2$Names
set2 <- set2[,-1]
set2[is.na(set2)] <- 0
set3 <- merge(combined_ordered_matrix2[,0], set2, by=0, sort=F)
rownames(set3) <- set3$Row.names
set3 <- set3[,-1]

## Heatmap!
set3[set3==0]<-NA
#Png("~/Dropbox/Organism_FirmiOrders_Heatmap.png")
heatmap.2(as.matrix(set3), 
	dendrogram='row',
	Rowv=rep_tree_d, 
	sepcolor='white', 
	sepwidth=c(0.01,0.01),
	Colv = F, 
	colsep=seq(1,10,1), 
	rowsep=seq(1,134,1),
	trace='none', 
	col=color, 
	cexCol = 0.7,   
	cexRow = 0.7,
	main = "Distribution of Orders\nwithin Firmicutes\nby Cluster",
	na.col="darkgrey",
	srtCol=35)
#dev.off()


## Does the same thing but subsets a phylum by given level, should only need to change 2 variables

## Change Phylum=="" to be whichever group of interest
firmset <- set[which(as.data.frame(set)$Phylum=="Firmicutes"),]
## change second firmset$ to be whichever level of interest, is firmset$Order or firmset$Family
firmset0<-as.matrix(as.data.frame.matrix(table(firmset$Cluster, firmset$Order)))
firmset0 <- firmset0[-which(rowSums(firmset0)<1),]
firmset0 <- firmset0[,-which(colSums(firmset0)<1)]
firmset1<-sweep(firmset0, 1, rowSums(firmset0), '/')
firmset1 <- firmset1[,c(-6,-7)]

## sets to match tree
rownames(firmset1) <- str_replace_all(rownames(firmset1), "[[:punct:]]", "")
firmset2 <- merge(data.frame(Names=rownames(combined_ordered_matrix2)), firmset1, by.x="Names", by.y=0, all.x=TRUE)
rownames(firmset2) <- firmset2$Names
firmset2 <- firmset2[,-1]
firmset2[is.na(firmset2)] <- 0
firmset3 <- merge(combined_ordered_matrix2[,0], firmset2, by=0, sort=F)
rownames(firmset3) <- firmset3$Row.names
firmset3 <- firmset3[,-1]

## Heatmap!
firmset3[firmset3==0]<-NA
Png("~/Dropbox/Organism_FirmiOrders_Heatmap.png")
heatmap.2(as.matrix(firmset3), 
	dendrogram='row',
	Rowv=rep_tree_d, 
	sepcolor='white', 
	sepwidth=c(0.01,0.01),
	Colv = F, 
	colsep=seq(1,10,1), 
	rowsep=seq(1,134,1),
	trace='none', 
	col=color, 
	cexCol = 0.7,   
	cexRow = 0.7,
	main = "Distribution of Orders\nwithin Firmicutes\nby Cluster",
	na.col="darkgrey",
	srtCol=35)
dev.off()











