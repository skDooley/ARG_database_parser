#' Create Genome Intervals
#'
#' This functiion takes a number or series of numbers (chromosome.sizes) in BED format and creates equal (intervals) of (size) megabases or (size) proportions. The chromosome.sizes can be created easily by using samtools faidx command.
#' @param chromosome.intervals Chromosome number in first column and corresponding size in second (BED format), can easily be created using samtools faidx command.
#' @param intervals Should each chromosome be split into intervals or proportions? Defaults to intervals.
#' @param size How many megabases for each interval or number of equal proportions to break chromosome into. Defaults to 10.
#' @keywords genome intervals
#' @export
#' @examples
#' creat.genome.intervals()

create.genome.intervals<-function(chromosome.sizes, intervals=TRUE, size=10){

if(!is.numeric(size)) stop("size should be numeric")
if(size>=max(chromosome.sizes)*1000000) stop("size should be smaller than the largest chromosome")


if(intervals){
	
	size<-size*1000000
	
times<-as.matrix(round((chromosome.sizes[,2]/size)))
intervals<-matrix(NA,sum(times),3)

n<-0
for(i in 1:dim(chromosome.sizes)[1]){
	temp<-as.matrix(seq(1,chromosome.sizes[i,2],chromosome.sizes[i,2]/times[i]))
	
	for(j in 1:times[i]){
	n<-n+1
		intervals[n,1]<-chromosome.sizes[i,1]
		intervals[n,2]<-temp[j]
		intervals[n,3]<-temp[j+1]-1
}
	intervals[n,3]<-chromosome.sizes[i,2]
}
} 

else {

intervals<-matrix(NA,(dim(chromosome.sizes)[1])*(size),3)
n<-0
for(i in 1:dim(chromosome.sizes)[1]){
	temp<-as.matrix(seq(1,chromosome.sizes[i,2],chromosome.sizes[i,2]/size))
	
	for(j in 1:size){
	n<-n+1
		intervals[n,1]<-chromosome.sizes[i,1]
		intervals[n,2]<-temp[j]
		intervals[n,3]<-temp[j+1]-1
}
	intervals[n,3]<-chromosome.sizes[i,2]
}
}

return(intervals)
}