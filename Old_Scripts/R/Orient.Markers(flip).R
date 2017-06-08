#' orient.markers
#'
#' This functiion will apply the flip.genotypes() function which will compare genotype data from two datasets of identical lines and markers and evaluate the orientation of the genotype call (ie 0,1,2,3,4 for autotetraploids) regardless of which is the reference and alternate allele used for each genotype call.
#' @param keep Genotype dataset that will NOT be 'oriented', will retain genotypes as is.
#' @param alter Genotype dataset that WILL be 'oriented', will change genotypes to match (keep) dataset by tring both orientations and then selecting the one with the higher corroboration.
#' @param min Minimum percent of lines represented across both datasets (keep and alter) to be kept in the output of the function, markers that do not meet the minimum will be filled with 'NA'.
#' @keywords orient markers
#' @export
#' @examples
#' orient.markers()



orient.markers <- function(keep, alter, min=0.3){

x<-array(1:dim(keep)[2])

y<-apply(x,1,FUN=flip.genotypes, keep=as.matrix(keep), alter=as.matrix(alter), min=as.numeric(min))

return(y)
}
