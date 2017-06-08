
require("reshape")
require("ggplot2")
require("VennDiagram")
require("stringr")

# Read in all files from Directory, and merge them into one dataframe
setwd("~/SS/")
count_list <- list.files(pattern="Counts", recursive=TRUE)

if (exists("rg_counts")){
	rm(rg_counts)}
for (file in count_list){
	set_name <- sapply(file, FUN=function(x){
	a<-str_split(x,"\\.")
	a<-str_split(a[[1]][1],"\\/")
	return(a[[1]][1])
	})  
# if the merged dataset does exist, append to it
  if (exists("rg_counts")){
    temp_dataset <-read.table(file, header=FALSE, col.names=c(set_name, "Gene"))
    rg_counts<-merge(rg_counts, temp_dataset, by="Gene", all=T)
    rm(temp_dataset)}
# if the merged dataset doesn't exist, create it
  if (!exists("rg_counts")){
    rg_counts <- read.table(file, header=FALSE, col.names=c(set_name, "Gene"))}
  rg_counts[is.na(rg_counts)] <- 0
}
rownames(rg_counts) <- rg_counts$Gene; rg_counts <- rg_counts[-8, -1]
rg_props <- apply(rg_counts, 2, FUN=function(x){
	x/sum(x)
})

write.table(rg_counts, file="tabled_counts_uniq.csv", row.names=TRUE, col.names=TRUE)

meltoplot <- meltoplot[which(meltoplot$X1=="MLS" | meltoplot$X1=="Tetracyclines" | meltoplot$X1=="betalactams" | meltoplot$X1=="Elfamycins" | meltoplot$X1=="Trimethoprim"),]



cyl_table <- table(mtcars$cyl)
cyl_levels <- names(cyl_table)[order(cyl_table)]
mtcars$cyl2 <- factor(mtcars$cyl, levels = cyl_levels)
# Just to be clear, the above line is no different than:
# mtcars$cyl2 <- factor(mtcars$cyl, levels = c("6","4","8"))
# You can manually set the levels in whatever order you please. 
ggplot(mtcars, aes(cyl2)) + geom_bar()



#Png("~/Dropbox/MS_Project/Gene_Classes.png", width=22)
ggplot(meltoplot, aes(x=X1, y=value, fill=X2)) + 
	geom_bar(stat="identity", position="dodge") + 
	xlab("Phyla") + 
	ylab("Proportion of Reads from Phyla") + 
	theme_bw() + 
	theme(text = element_text(size=26),
        axis.text.x = element_text(angle=25, hjust=1)) +
	scale_fill_manual(values=c("red","goldenrod1"))
#dev.off()





Png("~/Dropbox/MS_Project/Gene_venn.png")
draw.pairwise.venn(sum(y1,y3), sum(y2,y3), sum(y3), fill=c(colors()[135],"goldenrod1"), scaled=TRUE)
dev.off()

Png("~/Dropbox/MS_Project/Gene_counts.png", width=22)
ggplot(meltoplot, aes(x=X, y=value, fill=variable)) + 
	geom_bar(stat="identity", position="dodge") + 
	xlab("Resistance Gene Class") + 
	ylab("Number of Genes") + 
	theme_bw() + 
	theme(text = element_text(size=16),
        axis.text.x = element_text(angle=35, hjust=1)) +
	scale_fill_manual(values=c("red","green","goldenrod1"))
dev.off()


tabl <- read.table("~/Dropbox/MS_Project/Lane_Analysis.csv", header=T, fill=T, sep=",", nrows=20)[]

x <- tabl[1]
y1 <- (tabl[2]+tabl[3]+tabl[4]) / (sum(tabl[2],tabl[3],tabl[4], na.rm=T))
y2 <- (tabl[5]+tabl[6]+tabl[7]) / (sum(tabl[5],tabl[6],tabl[7], na.rm=T))
y3 <- (tabl[8]+tabl[9]+tabl[10]) / (sum(tabl[8],tabl[9],tabl[10], na.rm=T))
y4 <- (tabl[11]+tabl[12]+tabl[13]) / (sum(tabl[11],tabl[12],tabl[13], na.rm=T))


toplot <- data.frame(x=x, y1=y3, y2=y4, y3=y1, y4=y2)

meltoplot <- melt(toplot, id="X")
Png("~/Dropbox/MS_Project/Read_counts.png", width=22)
ggplot(meltoplot, aes(x=X, y=value, fill=variable)) + 
	geom_bar(stat="identity", position="dodge") + 
	xlab("Resistance Gene Class") + 
	ylab("Proportion of Sequence Reads") + 
	theme_bw() + 
	theme(text = element_text(size=20),
        axis.text.x = element_text(angle=35, hjust=1)) +
	scale_fill_manual(values=c("red","firebrick","goldenrod","goldenrod1"))
dev.off()


S1 <- read.table("~/Dropbox/MS_Project/Organism_Analysis/S1_Orgs.out", header=F, fill=T, sep="\t")
S2 <- read.table("~/Dropbox/MS_Project/Organism_Analysis/S2_Orgs.out", header=F, fill=T, sep="\t")
S <- read.table("~/Dropbox/MS_Project/Organism_Analysis/S_Orgs.out", header=F, fill=T, sep="\t")
M1 <- read.table("~/Dropbox/MS_Project/Organism_Analysis/M1_Orgs.out", header=F, fill=T, sep="\t")
M2 <- read.table("~/Dropbox/MS_Project/Organism_Analysis/M2_Orgs.out", header=F, fill=T, sep="\t")
M <- read.table("~/Dropbox/MS_Project/Organism_Analysis/M_Orgs.out", header=F, fill=T, sep="\t")
Orgs <- read.table("~/Dropbox/MS_Project/Organism_Analysis/Orgs.list", header=F, fill=T)


dat <- merge(Orgs, M, all.x=T)
dat2 <- merge(Orgs, S, all.x=T)
x <- Orgs
y1 <- dat[,2]/sum(dat[,2], na.rm=T)
y2 <- dat2[,2]/sum(dat2[,2], na.rm=T)
toplot <- data.frame(x=x, y1=y1, y2=y2)
colnames(toplot) <- c("X","Manure","Soil")
meltoplot <- melt(toplot, id="X")
meltoplot[is.na(meltoplot)] <- 0
#meltoplot <- meltoplot[meltoplot$value>0.005,]

Png("~/Dropbox/MS_Project/Organisms.png", width=22)
ggplot(meltoplot, aes(x=X, y=value, fill=variable)) + 
	geom_bar(stat="identity", position="dodge") + 
	xlab("Phyla") + 
	ylab("Proportion of Reads from Phyla") + 
	theme_bw() + 
	theme(text = element_text(size=26),
        axis.text.x = element_text(angle=25, hjust=1)) +
	scale_fill_manual(values=c("red","goldenrod1"))
dev.off()




path = "~/Dropbox/MS_Project/Assembly_Analysis/blast_Files/"
file.names <- dir(path, pattern =".blast")
setwd(path)
assembly<-matrix(NA,length(file.names),length(colSums(Filter(is.numeric,read.table(file.names[1],header=FALSE)))))
for(i in 1:length(file.names)){
  file <- read.table(file.names[i],header=FALSE)
  assembly[i,] <- as.numeric(colSums(Filter(is.numeric,file)))
}
dat <- as.data.frame(cbind(sapply(strsplit(file.names, "\\."),"[[",1),assembly))
colnames(dat) <- c("X",colnames(tabl)[8:13],colnames(tabl)[2:7])


x <- dat[1]
y1 <- (as.numeric(unlist(dat[2]))+as.numeric(unlist(dat[3]))+as.numeric(unlist(dat[4]))) / (sum(as.numeric(unlist(dat[2])),as.numeric(unlist(dat[3])),as.numeric(unlist(dat[4])), na.rm=T))
y2 <- (as.numeric(unlist(dat[5]))+as.numeric(unlist(dat[6]))+as.numeric(unlist(dat[7]))) / (sum(as.numeric(unlist(dat[5])),as.numeric(unlist(dat[6])),as.numeric(unlist(dat[7])), na.rm=T))
y3 <- (as.numeric(unlist(dat[8]))+as.numeric(unlist(dat[9]))+as.numeric(unlist(dat[10]))) / (sum(as.numeric(unlist(dat[8])),as.numeric(unlist(dat[9])),as.numeric(unlist(dat[10])), na.rm=T))
y4 <- (as.numeric(unlist(dat[11]))+as.numeric(unlist(dat[12]))+as.numeric(unlist(dat[13]))) / (sum(as.numeric(unlist(dat[11])),as.numeric(unlist(dat[12])),as.numeric(unlist(dat[13])), na.rm=T))


toplot <- data.frame(x=x, y1=y1, y2=y2, y3=y3, y4=y4)

meltoplot <- melt(toplot, id="X")
Png("~/Dropbox/MS_Project/Assembly_counts.png", width=22)
ggplot(meltoplot, aes(x=X, y=value, fill=variable)) + 
	geom_bar(stat="identity", position="dodge") + 
	xlab("Resistance Gene Class") + 
	ylab("Proportion of Sequence Reads") + 
	theme_bw() + 
	theme(text = element_text(size=20),
        axis.text.x = element_text(angle=35, hjust=1)) +
	scale_fill_manual(values=c("red","firebrick","goldenrod","goldenrod1"))
dev.off()

