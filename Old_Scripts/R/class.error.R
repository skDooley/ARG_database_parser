
class.error <- function(truth,test) {
	return(length(which(test!=truth))/length(truth))
}
