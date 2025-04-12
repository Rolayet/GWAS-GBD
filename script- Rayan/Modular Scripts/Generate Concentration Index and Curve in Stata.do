#######################################################
### Generate the concentration index and curve using the conindex package in Stata ###
#######################################################



### Obtaining the index and the curve for all regions (combined):

conindex total_attention_score, rankvar(daly) limits(0)
conindex total_attention_score, rankvar(daly) limits(0) graph



### obtaining plot for overall  

twoway (scatter total_attention_score daly) 
       (line total_attention_score daly, sort), 
       title("Combined Data") ytitle("Total Attention Score") xtitle("DALY")



##### obtaining index for African Union

local location_name "African Union"

 preserve

 keep if location_name == "`location_name'"

 conindex total_attention_score, rankvar(daly) limits(0)

 local ci = r(CI)
local se = r(CIse)

 local lower_bound = `ci' - 1.96 * `se'
local upper_bound = `ci' + 1.96 * `se'

 display "Location: `location_name'"
display "Concentration Index: " `ci'
display "Standard Error: " `se'
display "95% CI: [" `lower_bound' ", " `upper_bound' "]"

 restore

display "Completed processing for location: `location_name'"



##### obtaining index and its 95%CI for African Union

local location "African Union"

preserve
 
keep if location_name == "`location'"
 
count
display "Number of observations for `location': " r(N)
if r(N) == 0 {
    display "No data for `location'"
    restore
    continue
}

 
list in 1/5

 
display "Running conindex for `location'"
conindex total_attention_score, rankvar(daly) limits(0)

if _rc != 0 {
    display "conindex command failed for `location'"
    restore
    continue
}

 
local ci = r(CI)
local se = r(CIse)

 
display "conindex output for `location'"
display "CI: `ci'"
display "SE: `se'"

if "`ci'" == "" {
    display "No results for `location'"
    restore
    continue
}

display "Location: `location'"
display "Concentration Index: `ci'"
display "Standard Error: `se'"

 
restore



##### obtaining all locations 

levelsof location_name, local(locations)
local i = 0

foreach loc of local locations {
    local ++i
    if `i' > 5 {
        break
    }
    
    display "Processing location `i': `loc'"
    
    capture {
        preserve
        keep if location_name == `"`loc'"'
        
        count
        display "Number of observations for `loc': " r(N)
        if r(N) == 0 {
            display "No data for `loc'"
            restore
            continue
        }
        
        display "First 5 observations for `loc'"
        list in 1/5

        display "Running conindex for `loc'"
        conindex total_attention_score, rankvar(daly) limits(0)

        if _rc != 0 {
            display "conindex command failed for `loc'"
            restore
            continue
        }

        local ci = r(CI)
        local se = r(CIse)
        display "conindex output for location `i': `loc'"
        display "CI: `ci'"
        display "SE: `se'"

        if "`ci'" == "" {
            display "No results for `loc'"
            restore
            continue
        }

        display "Location: `loc'"
        display "Concentration Index: `ci'"
        display "Standard Error: `se'"

        restore
    }
}

display "Completed processing first five locations"


##### obtaining all locations indexes 

local i = 0
foreach loc of local locations {
    local ++i
    if `i' > 5 {
        break
    }
    
     display "Processing location `i': `loc'"
    
     capture {
        preserve
        keep if location_name == `"`loc'"'
        
         count
        display "Number of observations for `loc': " r(N)
        if r(N) == 0 {
            display "No data for location: `loc'"
            restore
            continue
        }
        
         display "First 5 observations for location: `loc'"
        list in 1/5

         display "Running conindex for location: `loc'"
        noi conindex total_attention_score, rankvar(daly) limits(0)

         capture local ci = r(CI)
        display "conindex output for location `i': `loc'"
        display "CI: `ci'"

         if _rc != 0 {
            display "conindex command failed for location: `loc'"
            restore
            continue
        }

         if "`ci'" == "" {
            display "No results for location: `loc'"
            restore
            continue
        }

         display "Location: `loc'"
        display "Concentration Index: `ci'"

        restore
    }
}

display "Completed processing first five locations"


##### obtaining all locations graph 

local i = 0
foreach loc of local locations {
    local ++i
    if `i' > 5 {
        break
    }
    
    display "Processing location `i': `loc'"
    
    capture {
        preserve
        keep if location_name == `"`loc'"'
        
        count
        display "Number of observations for `loc': " r(N)
        if r(N) == 0 {
            display "No data for location: `loc'"
            restore
            continue
        }
        
        display "First 5 observations for location: `loc'"
        list in 1/5

        display "Running conindex for location: `loc'"
        conindex total_attention_score, rankvar(daly) limits(0) graph

        if _rc != 0 {
            display "conindex command failed for location: `loc'"
            restore
            continue
        }

        local ci = r(CI)
        display "conindex output for location `i': `loc'"
        display "CI: `ci'"

        if "`ci'" == "" {
            display "No results for location: `loc'"
            restore
            continue
        }

        display "Location: `loc'"
        display "Concentration Index: `ci'"

        restore
    }
}

display "Completed processing first five locations"


###### Obtain and save the curve in an editable format


local desktop_path = "/Users/Desktop"

 levelsof location_name, local(locations)
local i = 0

foreach loc of local locations {
    local ++i
    if `i' > 5 {
        break
    }
    
    display "Processing location `i': `loc'"
    
    capture {
        preserve
        keep if location_name == `"`loc'"'
        
        count
        display "Number of observations for `loc': " r(N)
        if r(N) == 0 {
            display "No data for location: `loc'"
            restore
            continue
        }
        
        display "First 5 observations for location: `loc'"
        list in 1/5

        display "Running conindex for location: `loc'"
        conindex total_attention_score, rankvar(daly) limits(0) graph

        if _rc != 0 {
            display "conindex command failed for location: `loc'"
            restore
            continue
        }

        local ci = r(CI)
        display "conindex output for location `i': `loc'"
        display "CI: `ci'"

        if "`ci'" == "" {
            display "No results for location: `loc'"
            restore
            continue
        }

        display "Location: `loc'"
        display "Concentration Index: `ci'"

         local sanitized_loc = subinstr("`loc'", " ", "_", .)
        local graph_filename = "`desktop_path'/conindex_`sanitized_loc'.gph"

         graph save "`graph_filename'", replace

        restore
    }
}

display "Completed processing first five locations"


