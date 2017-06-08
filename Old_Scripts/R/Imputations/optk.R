kNN.opt <- function(data,max.iters=20,max.markers=100,max.miss=0.2,min.MAF=0.3,test.frac=0.2,n.core=1) {
	a<-replicate(max.iters, opt.k(data=data,max.markers=max.markers,max.miss=max.miss,min.MAF=min.MAF,test.frac=test.frac,n.core=n.core))
	x<-data.frame("k"=as.numeric(names(table(a[1,]))[which.max(table(a[1,]))]), "Error"=round(as.numeric(names(table(a[2,]))[which.max(table(a[2,]))]), digits=3), "Percent"=round(as.numeric(table(a[1,])[which.max(table(a[1,]))]/reps), digits=2))
	return(x)
}




fn <- function(i,geno,geno.imp,method,param){impute.mark(Xi=geno[,i],X=geno.imp[,-i],method=method,param=param)}


opt.k <- function(data,max.markers=100,max.miss=0.2,min.MAF=0.3,test.frac=0.2,n.core=1) {
	method="kNN"
	geno <- t(data)
	m <- ncol(geno);	n <- nrow(geno)
	geno.imp <- apply(geno,2,impute.mode)
	markers <- data
	
	missing <- round(apply(markers,1,function(x){length(which(is.na(x)))/n}),4)
	ix <- which(missing <= max.miss); stopifnot(length(ix)>0)
	q <- min(max.markers,length(ix))
	pick <- sample(ix,q)
	
	
	masked <- apply(array(pick),MARGIN=1,FUN=function(i,Z){
		train <- which(!is.na(Z[,i]))
		mask <- sample(train,round(length(train)*test.frac)) 
		return(as.vector(mask))},Z=geno)
	input <- apply(array(1:q),1,function(i,masked){list(i,masked[[i]])},masked)
	geno2 <- geno
	geno2[,pick] <- matrix(sapply(input,function(y,geno){
		x <- geno[,y[[1]]]
		x[y[[2]]] <- NA
		return(x)},geno[,pick]),n,q)
		
		
	ans1<-data.frame("k"=1:(q), "Error"=1:(q), "STDE"=1:(q))
	
		
	if ((n.core > 1)&requireNamespace("parallel",quietly=TRUE)) { 
	   	it <- split(pick,factor(cut(1:q,n.core,labels=FALSE)))	
	   	for ( k in 1:(q) ){
		param=k
		ans <- matrix(unlist(parallel::mclapply(it,FUN=function(ix,geno,geno.imp,method,param){apply(array(ix),1,fn,geno,geno.imp,method,param)},geno2,geno.imp,method,param,mc.cores=n.core)),n,q)
			tmp <- sapply(input,function(y,geno,ans){class.error(geno[y[[2]],y[[1]]],ans[y[[2]],y[[1]]])},geno[,pick],ans)
		ans1$k[k]<-k
		ans1$Error[k]<-mean(tmp)
		ans1$STDE[k]<-sd(tmp)/sqrt(q)
		}
	} 
	else {
		for ( k in 1:(q) ){
		param=k
		ans <- matrix(apply(array(pick),1,fn,geno2,geno.imp,method,param),n,q)
			tmp <- sapply(input,function(y,geno,ans){class.error(geno[y[[2]],y[[1]]],ans[y[[2]],y[[1]]])},geno[,pick],ans)
		ans1$k[k]<-k
		ans1$Error[k]<-mean(tmp)
		ans1$STDE[k]<-sd(tmp)/sqrt(q)
		}
	}
	return(c(ans1))
}



## HMM







