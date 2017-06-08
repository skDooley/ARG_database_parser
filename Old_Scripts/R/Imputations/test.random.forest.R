
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

marker.impute.rf <- function(data, ploidy, n.cores=1){
	
	geno <- t(data)
	MAF <- apply(geno, 2, function(i){
		AFs <- mean(i, na.rm=TRUE)/ploidy
		AF <- round(min(AFs,1-AFs),3)
		return(AF)
		})

	geno <- geno[,which(MAF >= min.MAF)]
	m <- ncol(geno);	n <- nrow(geno)
	markers <- data
	missing <- round(apply(markers,1,function(x){length(which(is.na(x)))/n}),4)
	
	geno <- geno[,which(missing <= max.miss)]
	geno.imp <- apply(geno,2,impute.mode)
	m <- ncol(geno.imp);	n <- nrow(geno.imp)
	if (n.cores > 1){tm <- split(1:m,factor(cut(1:m,n.cores,labels=FALSE)))}
	
	if ((n.cores > 1)&requireNamespace("parallel",quietly=TRUE)) {
		rf.error <- as.matrix(unlist(parallel::mclapply(tm,FUN=function(tmi){

		apply(array(tmi), 1, function(i){
				
			imp <- geno.imp[,i]
			pick <- prodNA(as.data.frame(imp), 0.4)
			test <- which(is.na(pick))
			train <- which(!is.na(pick))
			ans <- randomForest(x=geno.imp[train, -i], y=as.factor(geno.imp[train, i]), xtest=geno.imp[test, -i], ntree=300)
			
			print(paste(round((i/length(array(tmi))*100)),"markers analyzed on this core", sep=" "))
			class.error(geno.imp[test,i], ans$test$predicted)
		
		})}, mc.cores=n.cores)))
				
		} else {

		rf.error <- apply(array(1:m), 1, function(i){
				
			imp <- geno.imp[,i]
			pick <- prodNA(as.data.frame(imp), 0.4)
			test <- which(is.na(pick))
			train <- which(!is.na(pick))
			ans <- randomForest(x=geno.imp[train, -i], y=as.factor(geno.imp[train, i]), xtest=geno.imp[test, -i], ntree=300)
			error <- class.error(geno.imp[test,i], ans$test$predicted)
		
			percent1 <- round(((i-1)/m)*100); percent2 <- round((i/m)*100); if (percent2 > percent1){print(paste(percent2,"% of markers analyzed", sep=""))}
		
			class.error(geno.imp[test,i], ans$test$predicted)
		
	})
	}
return(mean(rf.error))
}	