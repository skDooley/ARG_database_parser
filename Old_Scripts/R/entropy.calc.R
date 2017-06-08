entropy.calc <- function(i, ploidy=4){
	  tab <- table(i)
	  N <- sum(tab)
	  p <- tab/N
	  S <- sum(-log(p,base=ploidy+1)*p)
	  return(S)
	}