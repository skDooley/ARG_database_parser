# BioPython Entrez #

The Entrez function is used to pull queries from the NCBI database.


## Input File(s)
Input file(s) should be in the form  

`<read>	Rif|AP010904.1|gene3156|Rifampin|Rifampin-resistant_beta-subunit_of_RNA_polymerase_RpoB|RPOB_megares	...
`

or 

`
Rif|AP010904.1|gene3156|Rifampin|Rifampin-resistant_beta-subunit_of_RNA_polymerase_RpoB|RPOB_megares
`

or just the accession IDs. 

`
AP010904.1
`

## Run_Entrez.sh

To run from the terminal, use the command.  
`
	sh Entrez_Query_NCBI/Run_Entrez.sh <input_file(s)> <taxonomic_level> <output.file>
`

The python scripts used in the pipeline requires both [NumPy][NP] and [BioPython][BP] to run. If you do not have either of these I would recommend looking to [Anaconda][ANA], which includes these and many other useful python packages.
[BP]:http://biopython.org/wiki/Download
[NP]:https://www.scipy.org/scipylib/download.html
[ANA]:https://www.continuum.io/downloads

### TAXONOMIC LEVELS
the following are levels accepted by the script:

		phylum
		class
		order
		family
		genus
		species
		strain	| returns species and strain
		all 	| returns everything above
		source	| returns host isolation_source country date

## Output

The output is a file identical to the input file(s) but with the requested information appended as a column (or columns) to the front of the file. (I may change this later to append to the end, so that the output can then be run through again to get a different taxonomy)


## Troubleshooting

if it seems that the pipeline is not working, or is returning 'not found', more often than expected you can troubleshoot it with individual accession numbers. Inside `Entrez_Query_NCBI/Working_Files/` there is a file `test_function.py`. This file can be opened and run in a python instance. It's a minimal file that runs the exact same function as the pipeline. You only need to edit the two objects `ind=` and `Taxo=`, and then run the script.

**Warning:** I would not recommend trying to change anything in `Entrez_Function.py` or `useEntrez.py` unless you are comfortable with the python language and can figure out my scripting style! If the function is not working, or you want an output not listed, feel free to e-mail me <sdsmith@iastate.edu> and I can try to fix the function to accomodate your data.






