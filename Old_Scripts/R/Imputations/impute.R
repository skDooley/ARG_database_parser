
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
impute.mark <- function(Xi,X,method,param) {
	miss <- as.vector(which(is.na(Xi)))
	if (is.element(length(miss),c(length(Xi),0))) {
		return(Xi)
	}	
	if (method=="LDA") {
		grouping <- factor(Xi[-miss])
		if (length(levels(grouping)) == 1) {
			Xi[miss] <- as.integer(levels(grouping))
		} else {
			X2 <- scale(X,scale=F,center=T)
			mark.svd <- svd(X2)
			iw <- which(mark.svd$d > 1e-9)
			mark.PCbasis <- X2 %*% mark.svd$v[,iw]
			lda.model <- lda(mark.PCbasis[-miss,1:param],grouping=grouping)
			Xi[miss] <- as.integer(predict(lda.model,newdata=mark.PCbasis[miss,1:param])$class)-1
		}
		return(Xi)
	}
	if (method=="kNN") {
		D <- as.matrix(dist(X))
		for (j in miss) {
			neighbors <- order(D[j,-miss])[1:param]
			Xi[j] <- as.integer(names(which.max(table(Xi[-miss][neighbors]))))
		}
		return(Xi)
	}		
}

fn <- function(i,geno,geno.imp,method,param){impute.mark(Xi=geno[,i],X=geno.imp[,-i],method=method,param=param)}

impute.CV <- function(data,method,param,max.iter=100,max.miss=0.2,min.MAF=0.3,test.frac=0.2,data0=NULL,n.core=1) {
	stopifnot(is.element(method,c("mode","kNN","LDA","RF")))
	geno <- t(data[-c(1,2,3)])
	if (is.null(data0)) {
		geno.imp <- apply(geno,2,impute.mode)
	} else {
		geno.imp <- t(data0[-c(1,2,3)])
	}
	m <- ncol(geno)
	n <- nrow(geno)
	markers <- data[-c(1,2,3)]
	missing <- round(apply(markers,1,function(x){length(which(is.na(x)))/length(data)}),4)
	ix <- which(missing <= max.miss)
	stopifnot(length(ix)>0)
	q <- min(max.iter,length(ix))
	pick <- sample(ix,q)
	masked <- apply(array(pick),MARGIN=1,FUN=function(i,Z){train <- which(!is.na(Z[,i])); mask <- sample(train,round(length(train)*test.frac)); return(as.vector(mask))},Z=geno)
	input <- apply(array(1:q),1,function(i,masked){list(i,masked[[i]])},masked)
	geno2 <- geno
	geno2[,pick] <- matrix(sapply(input,function(y,geno){x <- geno[,y[[1]]]; x[y[[2]]] <- NA; return(x)},geno[,pick]),n,q)
	if ((n.core > 1)&requireNamespace("parallel",quietly=TRUE)) {
	   	it <- split(pick,factor(cut(1:q,n.core,labels=FALSE)))	
		ans <- matrix(unlist(parallel::mclapply(it,FUN=function(ix,geno,geno.imp,method,param){apply(array(ix),1,fn,geno,geno.imp,method,param)},geno2,geno.imp,method,param,mc.cores=n.core)),n,q)
	} else {
		ans <- matrix(apply(array(pick),1,fn,geno2,geno.imp,method,param),n,q)
	}
	return(sapply(input,function(y,geno,ans){class.error(geno[y[[2]],y[[1]]],ans[y[[2]],y[[1]]])},geno[,pick],ans))
	tmp <- sapply(input,function(y,geno,ans){class.error(geno[y[[2]],y[[1]]],ans[y[[2]],y[[1]]])},geno[,pick],ans)
}

impute.optimize <- function(data,method,params,max.iter=100,max.miss=0.2,min.MAF=0.3,test.frac=0.2,data0=NULL,n.core=1) {
	stopifnot(is.element(method,c("mode","kNN","LDA","RF")))
	stopifnot(inherits(data,what="GBSdata")) 

	q <- length(params)
	result <- data.frame(params=params,n.mark=rep(NA,q),mean.error=rep(NA,q),SE.error=rep(NA,q))
	
	for (i in 1:q) {
		tmp <- impute.CV(data,method,param=params[i],max.iter,max.miss,data0,n.core)
		result$n.mark[i] <- length(tmp)
		result$mean.error[i] <- mean(tmp)
		result$SE.error[i] <- sd(tmp)/sqrt(length(tmp))
	}
	return(result)
}

impute <- function(data,method,param=NULL,data0=NULL,n.core=1) {
	stopifnot(is.element(method,c("mode","kNN","LDA","RF")))
	stopifnot(inherits(data,what="GBSdata")) 

	geno <- t(data[-c(1,2,3)])
	m <- ncol(geno)
	n <- nrow(geno)
	if (is.null(data0)) {
		geno.imp <- apply(geno,2,impute.mode)
	} else {
		geno.imp <- t(data0[-c(1,2,3)])
	}
	if (method!="mode") {
		if ((n.core > 1)&requireNamespace("parallel",quietly=TRUE)) {
	   	 	it <- split(1:m,factor(cut(1:m,n.core,labels=FALSE)))	
			ans <- matrix(unlist(parallel::mclapply(it,FUN=function(ix,geno,geno.imp,method,param){apply(array(ix),1,fn,geno,geno.imp,method,param)},geno,geno.imp,method,param,mc.cores=n.core)),n,m)
		} else {
			ans <- matrix(apply(array(1:m),1,fn,geno,geno.imp,method,param),n,m)
		}
	}
	rownames(ans) <- rownames(geno)
	colnames(ans) <- colnames(geno)
	data@genotypes <- t(ans)
	return(data)
}

