import csv
import sys
from itertools import islice

var_vcf = "\n".join(sys.argv[1:])

with open(var_vcf) as f:
    reader = csv.reader(f, delimiter='\t', skipinitialspace=True)
    first_row = next(islice(reader, 40, None))   
    num_cols = len(first_row)

print num_cols

