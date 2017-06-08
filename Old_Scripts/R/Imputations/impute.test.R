
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

test.imputation <- function(data,method,max.k=200,ploidy=2,max.miss=0.2,min.MAF=0.3,test.frac=0.2,n.cores=1){
	geno <- t(data)
	markers <- t(geno)
	missing <- round(apply(markers,1,function(x){length(which(is.na(x)))/nrow(geno)}),4)
	geno <- geno[,which(missing <= max.miss)]
	
	MAF0 <- apply(geno, 2, function(i){
		AFs <- mean(i, na.rm=TRUE)/ploidy
		AF <- round(min(AFs,1-AFs),3)
		return(AF)
		})
	entropy <- apply(geno,2,function(i){
	  tab <- table(i)
	  N <- sum(tab)
	  p <- tab/N
	  S <- sum(-log(p,base=ploidy+1)*p)
	  return(S)
	})
	geno <- geno[,which(MAF0 >= min.MAF)]
	S <- entropy[which(MAF0 >= min.MAF)]
	MAF <- MAF0[which(MAF0 >= min.MAF)]
	geno.imp <- apply(geno,2,impute.mode)
	m <- ncol(geno);	n <- nrow(geno)
	if (n.cores > 1){tm <- split(1:m,factor(cut(1:m,n.cores,labels=FALSE)))}
	
########### kNN ############	
	
	if (method=="kNN") {
	q <- min(max.k, n)
	D <- as.matrix(dist(geno))
	knn.error <- apply(array(seq(from=1, to=q, by=5)),1,function(i){
		param=i
		
		if ((n.cores > 1)&requireNamespace("parallel",quietly=TRUE)) {
		impute.test <- as.matrix(unlist(parallel::mclapply(tm,FUN=function(tmi){
			apply(array(tmi),1,function(j){		
			  Xiii <- geno[,j]
				isntna <- which(!is.na(Xiii))
				Xii <- geno.imp[isntna]
				Xi <- as.matrix(prodNA(as.data.frame(Xii),test.frac))
				miss <- as.vector(which(is.na(Xi)))
				Xi[miss] <- apply(array(1:length(miss)), 1, function(h){
					neighbors <- order(D[h,-miss])[1:param]
					as.integer(names(which.max(table(Xi[-miss][neighbors]))))
					})
				return(class.error(Xii[miss], Xi[miss]))
			})}, mc.cores=n.cores)))
		
		} else {	
					
		impute.test <- apply(array(1:m),1,function(j){
		  Xiii <- geno[,j]
		  isntna <- which(!is.na(Xiii))
		  Xii <- geno.imp[isntna]
		  Xi <- as.matrix(prodNA(as.data.frame(Xii),test.frac))
		  miss <- as.vector(which(is.na(Xi)))
		  Xi[miss] <- apply(array(1:length(miss)), 1, function(h){
		    neighbors <- order(D[h,-miss])[1:param]
		    as.integer(names(which.max(table(Xi[-miss][neighbors]))))
		  })
		  return(class.error(Xii[miss], Xi[miss]))
			})	
		}
		percent1 <- round(((i-1)/q)*100); percent2 <- round((i/q)*100); if (percent2 > percent1){print(paste(percent1,"% of k values analyzed", sep=""))}
		return(c(mean(impute.test), (sd(impute.test)/sqrt(q))))
		})
		
	results <- data.frame("k"=seq(from=1, to=q, by=5), "Error"=knn.error[1,], "SE"=knn.error[2,])
	
	return(results)
	}


########### RF #############


	if (method=="RF") {
	if ((n.cores > 1)&requireNamespace("parallel",quietly=TRUE)) {
		rf.error <- as.matrix(unlist(parallel::mclapply(tm,FUN=function(tmi){

		apply(array(tmi), 1, function(i){
				
		  ngen <- geno[,i]
		  sel <- ngen[which(!is.na(ngen))]
		  imp <- geno.imp[sel]
		  pick <- prodNA(as.data.frame(imp), test.frac)
		  test <- which(is.na(pick))
		  train <- which(!is.na(pick))
		  ans <- randomForest(x=geno.imp[train, -i], y=as.factor(geno.imp[train, i]), xtest=geno.imp[test, -i], ntree=300)
		  
		  percent1 <- round((as.numeric(which(tmi==i))/length(tmi))*100)
		  percent2 <- round(((as.numeric(which(tmi==i))-1)/length(tmi))*100)
		  if (percent1 > percent2) {
		    print(paste(percent2,"% of markers analyzed for this core", sep=""))}
		  return(class.error(geno.imp[test,i], ans$test$predicted))
		
		})}, mc.cores=n.cores)))
				
		} else {

		rf.error <- apply(array(1:m), 1, function(i){
				
		  ngen <- geno[,i]
		  sel <- ngen[which(!is.na(ngen))]
		  imp <- geno.imp[sel]
		  pick <- prodNA(as.data.frame(imp), test.frac)
		  test <- which(is.na(pick))
		  train <- which(!is.na(pick))
		  ans <- randomForest(x=geno.imp[train, -i], y=as.factor(geno.imp[train, i]), xtest=geno.imp[test, -i], ntree=300)
		  
			error <- class.error(geno.imp[test,i], ans$test$predicted)
		
			percent1 <- round(((i-1)/m)*100); percent2 <- round((i/m)*100); if (percent2 > percent1){print(paste(percent1,"% of markers analyzed", sep=""))}
		
			return(class.error(geno.imp[test,i], ans$test$predicted))
		
	})
	}
		return(data.frame("Error"=rf.error, "MAF"=MAF, "S"=S))	
		
	}
	
########### HMM #############	
	
}