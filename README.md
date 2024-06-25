# Project Title: GBD-GWAS

# Project Plan:


## B. Adding the Impact Factor to the GWAS Catalog
Impact factors were searched using Clarivate and/or journal websites.

### Update: In the GWAS file, there are 915 unique journal names. Among these journals, 28 unique have no impact factors (i.e., the impact factors were not found in either Clarivate or the journal website, or the journal is discontinued).
** for discussion **: In total, there will be 199 rows in the attention dataset with NA values. In R, for calculation purposes, those rows were given a value of zero. Could this have an impact when we multiply by impact factors*n

Due to the large size of the file, it is added to the notebook named "gwas_catalog_v1.0.2.1-studies_r2024-06-07.csv" and can be accessed by clicking on this link:
https://uob-my.sharepoint.com/:o:/r/personal/ih23257_bristol_ac_uk/Documents/Notebooks/GBD%20Terms%20mapping?d=wf240cee12e054a798cf8e8f4d69a8985&csf=1&web=1&e=OfNvfr


## C. Developing an 'Attention Score' for Each Ontology Term in the GWAS Catalog
Attention Score: Number of studies for that EFO term.
Weighted Attention Score: Sum(1 / n EFO per study) – accounts for studies publishing a large number of GWASs without focusing on a specific phenotype.
Weighted Attention Score Impact Factor: Sum(1 / n EFO per study * impact factor) – if a study is published in a higher impact journal, it indicates its quality and the degree to which it is valued.
GWAS Hits: Number of GWAS hits for that EFO term – this could be a proxy for the attention received by the study.


## A. Mapping GBD Health Outcomes and Risk Factors to Ontologies in OLS. 
A copy of the file is attached here as well, named "GBD.csv".

** For discussion **: For entries with NA values, broader EFO terms have been used instead. If no identifier is found, placeholders were used instead.
120 terms were added due to the variation between ICH and EFO terms. These terms may pose some challenges. For example, they were not included in the final findings, Gini coefficient, and visual plots as they do not have an exact match (no DALY) and the majority have n=0. If they are added, it will make the Gini coefficient even higher, (originally the GBD terms are 365 and here it is 485). 

## D. Merging the GWAS Attention Scores with the GBD Disease Burden Results
Aim to match as comprehensively as possible.
If multiple EFO terms match one GBD trait, sum the attention score across those EFO terms (as long as they are from independent publications).
If there are no matches for a GBD trait, the attention score = 0.

### Update: GBD terms are mapped with GWAS, the results are shown below:



|   | matching process           | terms no |
|---|--------------------------- | -----    |
| 1 | matched by identifiers GBD |   148    |
| 2 | matched partially GBD *    |   24     |
| 3 | unmatched GBD              |   308    |
| 3 | other**                    |   5      |

** for discussion **: 

** The list of terms matched partially is attached here named "matched partially". 

** The missed terms from matching process are: 
Those terms were missed during the matching process, I could not tracked them. 
Self-harm and interpersonal violence	
Other pneumoconiosis	
Cirrhosis due to other causes	
Other leukemia	
Poisoning by other means


## Note: the following issues were addressed by partially matching 
Hodgkin lymphoma is listed in the unmatch GBD terms, but in GWAS file, there is a study with more specific type of the disease "nodular sclerosis Hodgkin lymphoma". Similarly, for the traits that mapped with different identifiers that is not used when we mapped the GBD tools ontologies. 

proposed sugesstion: 
We employed a partial matching approach to handle unmatched GDB terms. This is achieved using the str_detect function, which checks if a pattern (in this case, the unmatched GDB term) is present within a string of traits in the GWAS file by identifying substrings. Utilizing this function, we mapped an additional 26 GDB terms that were not mapped when using the "mapping identifiers" method. Some examples of these mapped terms are listed below:

due to General Vs specified disease/treats

| No  | unmatched GBD       |     traits in GWAS           |
| --- | ------------------- | ---------------------------- |
| 1   | acute hepatitis a   | acute hepatitis a infection  |
| 2   | falls               | icd10 r296 repeated falls    |


or, due to the same disease but different identifiers were used (In GWAS vs GBD)

| No  | unmatched GBD            |   traits in GWAS   | GBD identifiers    | GWAS identifiers |
| --- | ------------------------ | ------------------ | -------------------| ---------------- |
| 1   | esophageal cancer        | esophageal cancer  | doid5041           | efo0002916       |
| 2   | testicular cancer        | testicular cancer  | mondo0005447       | efo0005088       |


The final file, named combined_dataset, includes terms matched by identifiers (GBD), partially matched (GBD), and unmatched (GBD). This file contains 480 terms; it was supposed to have 485, but 5 terms were missed. The file is attached here as well.




## E. Assessing the Relationship Between GWAS Attention and Global Need
For example, using an inequality measure such as Gini coefficients (example code below).

library(DescTools)
gwas_attention = score for each EFO term
gbd_daly = impact of each EFO term on disease burden
Gini(x = gwas_attention, weights = gbd_daly, conf.level = 0.95)

Finally, the combined_dataset was mapped to the GBD 'Global Need'. I used the file that was used at the start of the mapping process, named IHME-GBD_2019_DATA-0912b8a7-1.csv. This file is also attached here.

The file was filtered by; metric_name: "Number" & measure_name: "DALYs (Disability-Adjusted Life Years). Then, it was mapped via GBD term 
** for discussion **: 
When I mapped the final combined_dataset to Global Need, 134 terms were not mapped. We can break them down as follows:
* 120 terms were expected, as they did not have an exact match from the beginning.
* 5 terms were expected, as they were not included in the combined_dataset.
* 4 terms were missed again during the mapping/matching process.

A list of those 134 are attached here as well. 

