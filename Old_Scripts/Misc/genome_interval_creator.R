########################################################
###		input file must be in format:		############
###		chromosome_name	bp_size				############
########################################################
chrs<-read.table(file="~/Datasets/Genome/Potato_Chr_Sizes.list")
########################################################

########################################################
###		size of intervals to split chromosomes into 	 ###
########	   CHANGE ONLY THIS PARAMETER		############
########################################################

int.size<-.4e+06


########################################################

intervals<-matrix(NA,sum(round((chrs[1:dim(chrs)[1], 2]/int.size)+.5)),1)
n<-1
for(i in 1:length(chrs[,1])){
	m<-0
	for(j in n:(n+(round((chrs[i,2]/int.size)+.5)-2))){
		options("scipen"=100, "digits"=4)
	intervals[j]<-paste(chrs[i,1], ":",1+m, "-", m+int.size, sep="")
	m<-m+int.size
}
	n<-n+round((chrs[i,2]/int.size)+.5)
	intervals[n-1]<-paste(chrs[i,1], ":",1+m, "-", chrs[i,2], sep="")
}	
########################################################
write(intervals, file="~/Dropbox/SchuylerPotato/Code_Scripts/CHTC_GBS_files/genome_intervals.list")