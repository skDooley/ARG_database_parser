#' Binnit
#' 
#' This function will place genomic markers (data) into bins made by a range of chromsome loci (bin.list) in BED format (easily created with function 'create.genome.intervals()').
#' @param data A set of markers at chromosome in column 1 and loci position in column 2. This is VCF format and a VCF as input is acceptable.
#' @param bin.list A set of chromosome and loci ranges. Input is BED format and can be created easily using the create.genome.intervals() function.
#' @keywords bins
#' @export
#' @examples
#' binnit()



binnit <- function(data, bin.list){
	
x<-matrix(1:dim(bin.list)[1],dim(bin.list)[1],1)

binned <- lapply(x, FUN=function(x){
		data[(which(data[1]==bin.list[x,1] & data[2]>=bin.list[x,2] 	& data[2]<=bin.list[x,3])),]})

y<-c(1:length(binned))

bins.per.chr<-as.matrix(table(bin.list[,1]))

bins<-matrix(NA,sum(bins.per.chr),2)
bins[,1]<-unlist(sapply(bins.per.chr,FUN=function(x){seq((-0.5),(0.5),length.out=x)}))+bin.list[,1]
bins[,2]<-sapply(y, FUN=function(y){
		length(unlist(binned[[y]][2]))})
		

plot(bins[,1], bins[,2], type="l",ylab="Number of Variants Present", xlab="Chromosome", main=paste("Distribution of",sum(bins[,2]),"SNPs Across Genome in",max(y),"Bins", sep=" "))
	abline(v=seq(.5,(length(unique(bins[,1]))+(0.5)),by=1), h=0)
return(bins)
}

