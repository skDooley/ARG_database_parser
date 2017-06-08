##### Instructions for RNA-Seq data #####

### Install DESeq2 ###
source("https://bioconductor.org/biocLite.R")
#biocLite("DESeq2")
library("DESeq2")

### Load data ###
## Raw read counts
Rockhopper_raw <- read.csv("~/Dropbox/ecoli_clustering/Rockhopper_raw.csv", header=TRUE, row.names=1)
## Metadata
Rockhopper_meta <- read.csv("~/Dropbox/ecoli_clustering/Rockhopper_meta.csv", header=TRUE, row.names=1)

### Prepare DESeq2 input ###

## Create colData
## Extract treatments from column names, split on "_"
d <- unlist(strsplit(colnames(Rockhopper_raw), "_"))

## Reshape object
dim(d) <- c(4, 48)

## Transpose
d <- t(d)

colData <- data.frame(row.names = colnames(Rockhopper_raw), strain = d[,1], plasmid = d[, 2], time = d[, 3])

colData
#                     strain plasmid time
# ML115_Empty_6hr_1  ML115   Empty  6hr
# ML115_Empty_6hr_2  ML115   Empty  6hr
# ML115_Empty_6hr_3  ML115   Empty  6hr
# ...

## Create a model for the data, including interaction effects
design = ~ strain + plasmid + time + strain:plasmid + strain:time + plasmid:time + strain:plasmid:time

## Build dds object
dds <- DESeqDataSetFromMatrix(countData = Rockhopper_raw, colData = colData, design = design)

dds
# class: DESeqDataSet
# dim: 4321 48
# metadata(1): version
# assays(1): counts
# rownames(4321): b0001 b0002 ... pJMY_bla pJMY_lacI
# rowData names(0):
# colnames(48): MLC115_Empty_6hr_1 MLC115_Empty_6hr_2 ... LAR1_TE_24hr_3 LAR1_TE_24hr_4
# colData names(3): strain plasmid time

## Specify reference levels
## Default is alphabetical, see time factor:
levels(dds$time)
# [1] "12hr" "24hr" "6hr"

## Follow order in data files
dds$strain <- factor(dds$strain,levels=unique(colData[,1]))
dds$plasmid <- factor(dds$plasmid,levels=unique(colData[,2]))
dds$time <- factor(dds$time,levels=unique(colData[,3]))

## Now, 6hr is the reference level:
levels(dds$time)
# [1] "6hr"  "12hr" "24hr"

## Add metadata to dds object
(mcols(dds) <- DataFrame(mcols(dds), Rockhopper_meta))
# DataFrame with 4321 rows and 2 columns
#                        Name                                               Product
#                    <factor>                                              <factor>
# b0001                  thrL                             thr operon leader peptide
# b0002                  thrA Bifunctional aspartokinase/homoserine dehydrogenase 1
# ...

### Run DESeq ###
dds_full <- DESeq(dds)
# estimating size factors
# estimating dispersions
# gene-wise dispersion estimates
# mean-dispersion relationship
# final dispersion estimates
# fitting model and testing

## Save DESeq2 normalized expression to CSV
DESeq2_norm <- counts(dds_full, normalized=TRUE)
write.csv(as.data.frame(DESeq2_norm), file="DESeq2_norm.csv", collapse=""))


### Testing for significance ###
# See section 3.3: Interactions

## Add a "group" factor which is a combinations of original factors
dds_group <- dds
dds_group$group <- factor(sub("_[0-9]$","",rownames(colData)))
## Relevel
dds_group$group <- factor(dds_group$group, levels=unique(dds_group$group))
## Reset design
design(dds_group) <- ~ group
## Rerun DESeq2 using only 'group' as the model
dds_group <- DESeq(dds_group)
resultsNames(dds_group)
#  [1] "Intercept"              "groupMLC115_Empty_6hr"  "groupMLC115_Empty_12hr" "groupMLC115_Empty_24hr"
#  [5] "groupMLC115_TE_6hr"     "groupMLC115_TE_12hr"    "groupMLC115_TE_24hr"    "groupLAR1_Empty_6hr"
#  [9] "groupLAR1_Empty_12hr"   "groupLAR1_Empty_24hr"   "groupLAR1_TE_6hr"       "groupLAR1_TE_12hr"
# [13] "groupLAR1_TE_24hr"


## Compare with...
resultsNames(dds_full)
# [1] "Intercept"                     "strain_LAR1_vs_MLC115"         "plasmid_TE_vs_Empty"
# [4] "time_12hr_vs_6hr"              "time_24hr_vs_6hr"              "strainLAR1.plasmidTE"
# [7] "strainLAR1.time12hr"           "strainLAR1.time24hr"           "plasmidTE.time12hr"
# [10] "plasmidTE.time24hr"            "strainLAR1.plasmidTE.time12hr" "strainLAR1.plasmidTE.time24hr"