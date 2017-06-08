
snp.array <- read.csv("~/Dropbox/SchuylerPotato/GBS_Analysis/nfpt_with_map.csv",as.is=T,check.names=F)
data <- snp.array[-c(1,2,3)]
library('randomForest')
library('missForest')
class.error <- function(truth,test) {
	return(length(which(test!=truth))/length(truth))
}
impute.mode <- function(x) {
	ix <- which(is.na(x))
	if (length(ix)>0) {
		x[ix] <- as.integer(names(which.max(table(x))))
	}
	return(x)
}

opt.k <- function(data,max.k=200,max.miss=0.2,test.frac=0.2,n.cores=1){
	
	geno <- t(data)
	
	m <- ncol(geno);	n <- nrow(geno)
	markers <- data
	missing <- round(apply(markers,1,function(x){length(which(is.na(x)))/n}),4)

	geno <- geno[,which(missing <= max.miss)]
	geno.imp <- apply(geno,2,impute.mode)
	m <- ncol(geno.imp);	n <- nrow(geno.imp)
	if (n.cores > 1){tm <- split(1:m,factor(cut(1:m,n.cores,labels=FALSE)))}
	
	knn.error <- apply(array(1:max.k),1,function(i){
		param=i
		D <- as.matrix(dist(geno.imp))
		
		if ((n.cores > 1)&requireNamespace("parallel",quietly=TRUE)) {
		impute.test <- as.matrix(unlist(parallel::mclapply(tm,FUN=function(tmi){
			apply(array(tmi),1,function(j){		
				Xii <- geno.imp[,j]
				Xi <- as.matrix(prodNA(as.data.frame(Xii),test.frac))
				miss <- as.vector(which(is.na(Xi)))
				Xi[miss] <- apply(array(1:length(miss)), 1, function(h){
					neighbors <- order(D[h,-miss])[1:param]
					as.integer(names(which.max(table(Xi[-miss][neighbors]))))
					})
				class.error(Xii[miss], Xi[miss])
			})}, mc.cores=n.cores)))
		
		} else {	
					
		impute.test <- apply(array(1:m),1,function(j){
			Xii <- geno.imp[,j]
			Xi <- as.matrix(prodNA(as.data.frame(Xii),test.frac))
			miss <- as.vector(which(is.na(Xi)))
			Xi[miss] <- apply(array(1:length(miss)), 1, function(h){
				neighbors <- order(D[h,-miss])[1:param]
				as.integer(names(which.max(table(Xi[-miss][neighbors]))))
				})
			class.error(Xii[miss], Xi[miss])
			})	
		}
		percent1 <- round(((i-1)/max.k)*100); percent2 <- round((i/max.k)*100); if (percent2 > percent1){print(paste(percent2,"% of k values analyzed", sep=""))}
		mean(impute.test)	
		})
	 plot(knn.error, type="l")
	 return(knn.error)
}

opt.k(data=data, max.k=3000, max.miss=0.1, test.frac=0.3, n.cores=12)