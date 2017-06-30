combine_reads-clusters.py uses two inputs, teh first with format:

	READ_ID	PROTEIN_ID	NUCLEOTIDE_ID

the second with format:

	cluster_name1	associated read protein 
	or nucleotide IDs
	cluster_name2	associate IDs 

This will output a file "Reads_w_Clusters" that has format:

	READ_ID	PROTEIN_ID	NUCLEOTIDE_ID	CLUSTER_ID

for each read.


This file can then be run through the unix command

sort -ufk2,2 Reads_w_Clusters.list

which will eliminated any genes represented more than once, based on protein_ID


The Reads_w_Clusters file can then be run throught the Run_Entrez.sh script, be sure that the database in the useEntrez.py file is set to "protein", this might be changed to be an argument input later if more people than I use this.



The heatmap.R file will take the Reads_w_Clusters, and any results from the Run_Entrez script as inputs. It also takes the phylogenic tree input from Adina's scripts. 
I just copy and pasted the code for that part so I do not know if it is a universally accepted format for all trees or not..
