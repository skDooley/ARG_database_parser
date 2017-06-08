percent.missing <- function(x){
	pm <- length(which(is.na(x)))/length(x)
	return(pm)
	}