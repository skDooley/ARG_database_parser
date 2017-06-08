MAF.calc <- function(x, ploidy=4){
	AFs <- mean(x, na.rm=TRUE)/ploidy
	AF <- round(min(AFs,1-AFs),3)
	return(AF)
}