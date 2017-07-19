import sys
from Bio import Entrez
from Entrez_Function import pullOrganism
from Entrez_Function import unique
Entrez.email = "sdsmith@iastate.edu"




ind = "CP019443"
Taxo = "source"



try:
   	org = pullOrganism(ind, Taxo)
except:
    org = "NOT_FOUND-" + ind

print org
