# Project Title: GBD-GWAS

# Project Plan:

## 1. GBD terms: 

## A. GBD terms splitting
In the latest GBD study, there are 377 diseases and injuries. These GBD terms were split into "GBD First_part" and "GBD Second_part". The reason for splitting the GBD terms is that some GBD terms include other terms within them (descendants). Thus, those terms were separated to pull the descendants from the ontology tree using the library(ontologyIndex). Then those terms will be matched with GWAS as we did in part one. 

## B. GBD terms mapping
All GBD terms were mapped to EFO manually. For entries with no specific EFO terms, broader EFO terms have been used instead. If no broader terms were found, placeholders were used, as those terms will also be matched with GWAS using the str_detect function via traits.

## C. Sources 
Both "First_part_GBD.xlsx" and "Second_part_GBD.xlsx" are uploaded here.

## 2. GWAS Catalog: 

## A. Adding the Impact Factor to the GWAS Catalog
Impact factors were searched using Clarivate and/or journal websites. There are some journals that do not have impact factors, for these sources, CiteScore was used. If neither impact factor nor CiteScore was available, a value of zero was given i.e., journals are discontinued, or where studies were published in news or conferences.


## B. Developing an 'Attention Score' for Each Ontology Term in the GWAS Catalog
Attention Score: Number of studies for that EFO term.
Weighted Attention Score: Sum(1 / n EFO per study) – accounts for studies publishing a large number of GWASs without focusing on a specific phenotype.
Weighted Attention Score Impact Factor: Sum(1 / n EFO per study * impact factor) – if a study is published in a higher impact journal, it indicates its quality and the degree to which it is valued.
GWAS Hits: Number of GWAS hits for that EFO term – this could be a proxy for the attention received by the study.

## C. Sources 
Due to the large size of the file, it was added to the notebook named "gwas_catalog_v1.0.2.1-studies_r2024-06-07.csv" and can be accessed by clicking on this link: https://uob-my.sharepoint.com/:o:/r/personal/ih23257_bristol_ac_uk/Documents/Notebooks/GBD%20Terms%20mapping?d=wf240cee12e054a798cf8e8f4d69a8985&csf=1&web=1&e=OfNvfr

## 3. Merging the GWAS Attention Scores with the GBD Disease Burden Results

## A. Matching process
The matching process was done via EFO terms of the GBD or its descendants with GWAS EFO. For GBD terms that did not have a direct EFO match, the str_detect function was used to find matches. Any matching from both methods: if multiple EFO terms match one GBD trait, sum the attention score across those EFO terms (as long as they are from independent publications). If there are no matches for a GBD trait in both methods, the attention score is set to 0.

###  Matching results

|   | matching process           | terms no |
|---|--------------------------- | -----    |
| 1 | matched by identifiers GBD |   140    |
| 2 | matched partially GBD      |   29     |
| 3 | unmatched GBD              |   208    |


## 4. Assessing the Relationship Between GWAS Attention and Global Need

## A. Obtaning concentration curve (Lorenz curve) and computes the curve
### two methods were used to investigate the disparites; 1-Numerical Integration and 2-Discrete Sum Calculation 




