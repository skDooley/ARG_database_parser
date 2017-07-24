# Resistance Class Parsing

This pipeline was written to split BLAST outputs: 

```
<read_name>	Rif|AP010904.1|gene3156|Rifampin|Rifampin-resistant_beta-subunit_of_RNA_polymerase_RpoB|RPOB_megares	...
```
into corresponding resistance class (in this case above, Rifampin).

## Run_Parse.sh
This is the main script for this pipeline. 
The pipeline is executed with command line:

```
sh Resistance_Class_Parsing/Run_Parse.sh <directory_to/*_input_files.blast> <directory_to/_output>
```

Any number of input files may be given, as long as the desired ouput directory is given last.

### Input File
The pipeline was designed to handle BLAST outputs in the format shown above, however it will also accept an input file that has only the information in the second column.

```
Rif|AP010904.1|gene3156|Rifampin|Rifampin-resistant_beta-subunit_of_RNA_polymerase_RpoB|RPOB_megares
```

### Output
The given output path and directory will be created if it does not exist.
(**Warning:** this means that if you put a long path for the output and make a mistake in a subdirectory name, it WILL create a bunch of new directories without giving an error, so double-check your paths!)

Within the output, the script will create a file for each antibiotic resistance gene class present in the input, and write each read to its corresponding class file.

Additionally, it will also create directories for each of the databases used (MegaRes, Card, Int) and create files and subdirectories for those based on genes or ARG-class (this may or may not be useful, but is easy enough to ignore).

## Run_ AR_Class.sh

This script will take a file with the same input as the pipeline above.
It will return a file that has the exact same thing as the input, but with a new column at the beginning that has the AR Class.

```sh Resistance_Class_Parsing/Run_AR_Class.sh <input_file(s)> <desired_output_file_name>```

## Run_Uniq.sh

This script takes the same commands.

```
sh Resistance_Class_Parsing/Run_Uniq.sh <directory_to/*_input_files.blast> <directory_to/_output>
```

But will identify the unique reads present and output a file with each unique gene identifier and a count for how many of those genes were found.

## Changing the ARG-Class Content
You may find that some reads are not sorted into any class, or a class that you expected it to be in. In some cases, it's subjective to conclude that a gene belongs more to one class than another. This can be altered.

The file in `Resistance_Class_Parsing/Working_Files/AR_DB_Classes` contains the ARG-classes and their corresponding gene codes. If this is altered you will then want to run the file `Resistance_Class_Parsing/Working_Files/Make_Keys.sh` probably within that directory as

```
sh Make_Keys.sh
```

and this will create a new version of the key that the parser uses.