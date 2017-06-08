
output <- "~/Sim/remove_depth_"

m<-50


for( f in 1:m){
	n <- f
	a <- matrix(,n,1)
for( i in 1:n){
	a[i,1] <- i
	write.table(a, file=paste(output, n, sep=""), row.names=F, col.names=F, quote=F)
	}
}