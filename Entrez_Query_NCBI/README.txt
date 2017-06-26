### BioPython Entrez ###

The Entrez function is used to pull queries from the NCBI database.

Input file(s) should be in the form 
	<anything>	Rif|AP010904.1|gene3156|Rifampin|Rifampin-resistant_beta-subunit_of_RNA_polymerase_RpoB|RPOB_megares	...

The second column of information is used to query ncbi

To run from the terminal, use the command
	sh Run_Entrez.sh 	sh Run_Parse.sh <input file> <taxonomic level> <desired output name>


TAXONOMIC LEVELS
	the following are levels accepted by the script:
		phylum
		class
		order
		family
		genus
		species
		strain
		all

The output is a file with just the requested taxonomies in the same order as the input list.