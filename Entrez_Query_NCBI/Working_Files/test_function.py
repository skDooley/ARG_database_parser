import sys
from Bio import Entrez
from Entrez_Function import pullOrganism
from Entrez_Function import unique
Entrez.email = "sdsmith@iastate.edu"










ind = "KY471311"
Taxo = "strain"





try:
   	org = pullOrganism(ind, Taxo)
except:
    org = "NOT_FOUND-" + ind

print org
