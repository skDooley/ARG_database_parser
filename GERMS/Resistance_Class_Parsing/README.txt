
### For Parsing File ###

This script is setup to subdivide files based on database entries of ARMs located in the folder of Working_Files
	To edit this list, the Make_Keys.sh file needs to be executed using "sh Make_Keys.sh"
		This file uses the list in AR_DB_Classes to create the file Classes.list in the same directory.
			to edit what categories are subdivided into, AR_DB_Classes needs to be edited, in the same format, and then Make_Keys.sh needs to be run.

To run the parsing script, Run_Parse.sh must be run as
	sh Run_Parse.sh <input file(s)> <desired output name>
	example:
		sh Run_Parse.sh SS/*_input_files.blast SS_output
	
	any number of files can be inputted, easiest to input to a directory and use * to indicate all files present
	the output name should be a directory name the desired directory does not need to exist, it will be created if it does not exist.
		the script will create files for each of the antibiotic resistance gene class and put each line of the input into each of those files they belong to.
			additionally it will also create directories for each of the databases used and create files and subdirectories for those based on genes or ARG class (this might be less useful but is a linear Big-O step so I didn't bother to remove it).
	
The input files should be in the format below, with tab or space delimiters for each column:
	<anything>	Rif|AP010904.1|gene3156|Rifampin|Rifampin-resistant_beta-subunit_of_RNA_polymerase_RpoB|RPOB_megares	...


### AR_Class ###

This script will take a file with as list of the information in the second column from above. It can either be the same file as above or one with that information in the first column.
It will return a file that has the exact same thing as the input, but with a new column at the beginning that has the AR Class.

sh Run_AR_Class.sh <input file(s)> <desired output name>



### Uniq ###

The Run_Uniq.sh script takes the same commands as the Run_Parse.sh script. 
This file will identify the unique reads present and output a file with each unique read identifier and a count for how many of those reads were found.
