Project Title: The gap between the research we do and the research the world needs: a focus on genome-wide association studies 

Poject plan: 
A- Mapping health outcomes and risk factors in the GBD to ontologies in OLS.
a copy of the file are attached here as well "GDB.csv"
Update: those with NA, a broader EFO terms have been used alternativly.   

B- Adding the impact factor to the GWAS catalog
by searching in the clarivate and/or journal websie. In GWAS file, there are 915 unique journal names, among those jounrals 27 has no impact factos 
ie., the impact factors not found neather in the clarivate or the journal websie or the journal is decounted. 
due to the sample size, the file can be finds via 
: https://uob-my.sharepoint.com/:o:/r/personal/ih23257_bristol_ac_uk/Documents/Notebooks/GBD%20Terms%20mapping?d=wf240cee12e054a798cf8e8f4d69a8985&csf=1&web=1&e=aLJSjg


C-Developing an ‘Attention score’ for each ontology term in the GWAS catalog e.g.
Attention score = number of studies for that EFO term
Weighted attention score = sum(1 / n EFO per study) – sometimes studies publish huge numbers of GWASs and are not specifically addressing any particular phenotype
Weighted attention score impact factor = sum(1 / n EFO per study * impact factor) – If a study is published in a higher impact journal it’s an indication of its quality and the degree to which it is valued
GWAS hits = number of GWAS hits for that EFO term – this could be a proxy for the attention received by the study


D-Merging the GWAS attention scores with the GBD disease burden results
We’ll want to match as comprehensively as possible
If multiple EFO terms match one GBD trait then we would sum the attention score across those EFO terms (as long as they are independent publications)
If there are no matches for a GBD trait then the attention score = 0


D-Assessing the relationship between GWAS attention and global need, for example using an inequality measure such as Gini coefficients (example code below)





