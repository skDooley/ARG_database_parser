import re
import urllib
import numpy as np
from bs4 import BeautifulSoup

url = "http://msb.embopress.org/content/6/1/378.short"
html = urllib.urlopen(url).read()
soup = BeautifulSoup(html, "html.parser")

for script in soup(["script", "style"]):
    script.extract()
text = soup.get_text()
lines = (line.strip() for line in text.splitlines())
chunks = (phrase.strip() for line in lines for phrase in line.split("  "))
text = '\n'.join(chunk for chunk in chunks if chunk)

genes = []
matches = re.findall(r'\b[a-z]{3}[A-Z]\b', text)
for match in matches:
	genes.append(match)

print np.unique(genes)





