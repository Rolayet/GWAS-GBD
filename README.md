Project Title: The Gap Between the Research We Do and the Research the World Needs: A Focus on Genome-Wide Association Studies

Project Plan:

A. Mapping GBD Health Outcomes and Risk Factors to Ontologies in OLS. 
A copy of the file is attached here as well, named "GDB.csv".
Update: For those entries with NA values, broader EFO terms have been used alternatively.



B. Adding the Impact Factor to the GWAS Catalog
Update:
Impact factors were searched using Clarivate and/or journal websites.
In the GWAS file, there are 915 unique journal names. Among these journals, 27 have no impact factors (i.e., the impact factors were not found in either Clarivate or the journal website, or the journal is discontinued).

Due to the large size of the file, it is added to the notebook and can be accessed by clicking on this link:
https://uob-my.sharepoint.com/:o:/r/personal/ih23257_bristol_ac_uk/Documents/Notebooks/GBD%20Terms%20mapping?d=wf240cee12e054a798cf8e8f4d69a8985&csf=1&web=1&e=OfNvfr


C. Developing an 'Attention Score' for Each Ontology Term in the GWAS Catalog
Attention Score: Number of studies for that EFO term.
Weighted Attention Score: Sum(1 / n EFO per study) – accounts for studies publishing a large number of GWASs without focusing on a specific phenotype.
Weighted Attention Score Impact Factor: Sum(1 / n EFO per study * impact factor) – if a study is published in a higher impact journal, it indicates its quality and the degree to which it is valued.
GWAS Hits: Number of GWAS hits for that EFO term – this could be a proxy for the attention received by the study.


D. Merging the GWAS Attention Scores with the GBD Disease Burden Results
Aim to match as comprehensively as possible.
If multiple EFO terms match one GBD trait, sum the attention score across those EFO terms (as long as they are from independent publications).
If there are no matches for a GBD trait, the attention score = 0.

Update: GBD terms are mapped with GWAS, resulting in a total of 183 matched EFOs.
Scripts and matched terms files are uploaded here as well.



Next step: 
E. Assessing the Relationship Between GWAS Attention and Global Need
For example, using an inequality measure such as Gini coefficients (example code below).

library(DescTools)
gwas_attention = score for each EFO term
gbd_daly = impact of each EFO term on disease burden
Gini(x = gwas_attention, weights = gbd_daly, conf.level = 0.95)

