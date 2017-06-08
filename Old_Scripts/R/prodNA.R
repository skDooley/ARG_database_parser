prodNA <- function(x,n.test) {
	ix <- which(!is.na(x))
	mask <- sample(ix,n.test)
	x[mask] <- NA
	return(x)
}