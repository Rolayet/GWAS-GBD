# Project Title: GBD-GWAS

# Project Plan:

This study integrates metadata from the GWAS Catalog and the Global Burden of Disease (GBD) studies to evaluate the role of genome-wide association studies (GWAS) in addressing global health outcomes. Combining data from these two sources—specifically, "traits" in GWAS and "health conditions" in the GBD study—is a complex process due to differences in disease mapping between them. Hence, we employed multiple methods to align the two datasets, we first used Experimental Factor Ontology (EFO) terms to match manually mapped EFO terms from the GBD with the corresponding traits in the GWAS Catalog. For cases where no direct match was found, we applied a string-based matching function to identify similarities between GWAS traits and GBD health conditions. This helped maximize coverage of GBD conditions and address misalignments between diseases and their mapped EFO terms. Also, we conducted manual curation of GWAS traits to identify any remaining semantic relationships with GBD health conditions, ensuring a more comprehensive alignment between the two datasets.


## 1. GBD terms: 

## A. GBD terms 
In the latest GBD study, there are 377 diseases and injuries, grouped into several categories and levels. Initially, we excluded all causes in the injury category, as well as causes at levels 0, 1, and 2 from other categories, to provide specific insights into genetic conditions that are more likely to be investigated through GWAS. The remaining GBD terms were then split into two groups: "GBD First_part" and "GBD Second_part, as some GBD terms include other terms within them (i.e., descendants). Therefore, these terms were separated in order to extract their descendants from the ontology tree using the ontologyIndex library. These extracted terms will then be matched with GWAS data.

## B. GBD terms mapping
All GBD terms were mapped to EFO manually. For entries with no specific EFO terms, broader EFO terms have been used instead. If no broader terms were found, placeholders were used, as those terms will also be matched with GWAS using the str_detect function via traits.


## C. Sources 
The GBD health conditions are obtained from the Global Burden of Disease data available at https://www.healthdata.org/research-analysis/gbd. Two files have been uploaded to the data folder: "First_part_GBD.xlsx" (without descendants) and "Second_part_GBD.xlsx" (with descendants). The descendant information is obtained from the efo-obo.txt file, which was sourced from https://www.ebi.ac.uk/efo/. This file could not be uploaded here due to its large size.




## 2. GWAS Catalog: 
To measure the attention given to GBD health conditions by GWAS, we developed attention scores using several approaches, as outlined below:

## A. Developing an 'Attention Score' for each health condtiosn in the GWAS Catalog
1-Attention Score: Number of studies for that EFO term.

2-Weighted Attention Score: Sum(1 / n EFO per study). Accounting for studies publishing a large number of GWAS without focusing on a specific phenotype.

3-GWAS Hits: Number of GWAS hits for that EFO term. This could be a proxy for the attention received by the study.

4-Weighted Attention Score Impact Factor: Sum(1 / n EFO per study * impact factor). It indicates its quality and the degree to which it is valued.

5-Total number of cases from intinal and Replication samcples, ncase = Initial_Sample_Cases + Replication_Sample_Cases

These approaches allow us to obtain accurate findings that are not biased toward any single method. All the approaches are based on data from the GWAS Catalog, except for the journal impact factor associated with GWAS attention, which was manually obtained from Clarivate's Journal Citation Reports (JCR).

## B. Incorporating the Impact Factor to the GWAS Catalog
Impact factors were searched using Clarivate. There are some journals that do not have impact factors, for these journals, CiteScore was used. If neither impact factor nor CiteScore was available, a value of zero was given i.e., journals are discontinued, or where studies were published in news or conferences.


## C. Manual Curation of traits in the GWAS Catalog
Limiting the matching process to traits explicitly listed in the GWAS Catalog could underestimate GWAS attention. Therefore, we manually curated the traits in GWAS to align with GBD conditions, allowing us to capture diseases that might have been missed due to semantic differences. The manually curated mapping of GWAS traits to GBD conditions has been uploaded to the data folder.


## D. Sources 
The GWAS Catalog was obtained from https://www.ebi.ac.uk/gwas/, and the journal impact factors were sourced from Clarivate's Journal Citation Reports (JCR) at https://mjl.clarivate.com/home.




## 3. Merging the GWAS Attention Scores with the GBD Disease Burden Results

## A. Matching process
The matching process was done via EFO terms of the GBD or its descendants with GWAS EFO. For GBD terms that did not have a direct EFO match, the str_detect function was used to find matches. Any matching from both methods: if multiple EFO terms match one GBD trait, sum the attention score across those EFO terms (as long as they are from independent publications). If there are no matches for a GBD trait in both methods, the attention score is set to 0.

###  Matching results

|   | matching process              | terms no |
|---|------------------------------ | -----    |
| 1 | matched by identifiers GBD    |   140    |
| 2 | partially (pattern matching)  |   41     |
| 3 | unmatched GBD                 |   195    |


## 4. Assessing the Relationship Between GWAS Attention and Global Need

## A. Developing concentration curve and index 
The Conindex package in Stat is used to develop the concentration curve and index to investigate the disparities:


## B. Sources 
In the latest GBD study is uploaded here named IHME-GBD_2021_DATA-120ebfcd-1.csv
Finally, the script for all the analysis is uploaded here as well.







