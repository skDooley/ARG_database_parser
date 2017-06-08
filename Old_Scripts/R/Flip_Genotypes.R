#' flip.genotypes
#'
#' This functiion will compare genotype data from two datasets of identical lines and markers and evaluate the orientation of the genotype call (ie 0,1,2,3,4 for autotetraploids) regardless of which is the reference and alternate allele used for each genotype call.
#' @param x This is an input from the orient.markers() function. x<-as.matrix(1:dim(keep)[1]).
#' @param keep Genotype dataset that will NOT be 'oriented', will retain genotypes as is.
#' @param alter Genotype dataset that WILL be 'oriented', will change genotypes to match (keep) dataset by tring both orientations and then selecting the one with the higher corroboration.
#' @param min Minimum percent of lines represented across both datasets (keep and alter) to be kept in the output of the function, markers that do not meet the minimum will be filled with 'NA'.
#' @keywords flip
#' @export
#' @examples
#' flip.genotypes()




flip.genotypes <- function(x, keep, alter, min){

a<-keep[,x]
alter[,x][(is.na(a))]<-NA

b<-alter[,x]
a.eq.b<-as.integer(a==b)

c<-alter[,x]*(-1)
	c[is.element(c,0)]<-4
	c[is.element(c,(-1))]<-3
	c[is.element(c,(-2))]<-2
	c[is.element(c,(-3))]<-1
	c[is.element(c,(-4))]<-0
a.eq.c<-as.integer(a==c)

total<-sum(as.integer(a.eq.b==0 | a.eq.b==1), na.rm=TRUE)

if((sum(a.eq.b, na.rm=TRUE)/total) >= (sum(a.eq.c, na.rm=TRUE)/total)) {
	d<-b
}

else {
	d<-c	
}

if((sum(as.integer(a==d), na.rm=TRUE)/total) <= (min)){
	d[is.element(d,c(0,1,2,3,4))]<-NA
}
return(d)
}