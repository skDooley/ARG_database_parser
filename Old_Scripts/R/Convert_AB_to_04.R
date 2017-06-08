convert <- function(x){
	y <- unlist(strsplit(x, ""))
	if(is.na(x)|y[1]=="N"){
		return(NA)
	}else{	
	y[which(y == "A")] <- 0
	y[which(y == "B")] <- 1
	return(sum(as.integer(y)))
	}
}

