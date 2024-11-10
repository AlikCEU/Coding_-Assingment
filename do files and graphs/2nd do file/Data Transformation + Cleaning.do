cd "/Users/allakhverdiagakishiev/Desktop/hw/coding/assignment/do files/2nd do file"
* Sets the working directory to the folder where the 2nd .do file is located


use "/Users/allakhverdiagakishiev/Desktop/hw/coding/assignment/finale/CodingSTATA.dta"
* Loads the dataset "CodingSTATA.dta" that was created and saved in the first .do file


describe // Displays a summary of the dataset, showing variable names and types
list comp_exit  if comp_exit == "NA" // Lists all observations where "comp_exit" is equal to "NA"
list if missing(comp_exit) // Lists all observations where "comp_exit" has missing values
list if comp_exit == "" // Lists all observations where "comp_exit" is an empty string
drop if comp_exit != "NA" 
* Drops all rows where "comp_exit" is not "NA" (let's say our boss told us to keep only those companies that still exists)
drop comp_exit	// Drops the "comp_exit" variable as it's no longer needed

*  Our boss also asked for companies founded after May 2000
gen year_founded =real(substr(comp_founded, 1, 4)) // We first extract the year from the "comp_founded" variable and convert it to a numeric value
gen month_founded =real(substr(comp_founded,6,2)) // Similarly, we extract the month from the "comp_founded" variable to check for companies founded after May 2000
drop if (year_founded < 2000)|(year_founded == 2000 & month_founded <= 05) // Now we apply the boss's rule: drop companies founded before 2000 or those founded in 2000 before May
drop year_founded month_founded // After extracting and filtering the founding year and month, we no longer need the "year_founded" and "month_founded" variables, so we drop them


* Now, our boss told us to focus on companies in the "Central" or "East" regions. So we drop any companies outside these two regions
drop if comp_region != "Central" & comp_region != "East" 

// The boss wants the financial data (assets) to be cleaner
replace comp_assets = round(comp_assets) // We round the "comp_assets" values to avoid decimals for easier analysis
summarize comp_assets // Let's check the summary statistics of "comp_assets" to see how the data looks after rounding
drop if comp_assets < r(mean) // The boss wants to focus on companies with significant assets, so we drop companies whose assets are below the mean value

* Now our boss say that observation with same id are the ones which belong to the same corparation, so he tell us to sort information by companies (corpations)
gen date_founded = date(comp_founded, "YMD") // Now, we need the exact founding date for more detailed analysis, so we convert "comp_founded" to a proper date variable
format date_founded %td //// We format the "date_founded" variable to ensure it appears as a readable date in Stata
drop comp_founded // We drop the original "comp_founded" variable now that we have the properly formatted "date_founded" variable
bysort comp_id (date_founded): gen tag = _n // To group the data by company, we sort by "comp_id" and "date_founded", creating a "tag" that represents the order of events within each company
bysort comp_id (date_founded): egen total_assets = total(comp_assets) // We now calculate the total assets for each company by summing up the "comp_assets" within each "comp_id" group
bysort comp_id (date_founded): egen total_CEO = total(comp_numb_CEOs) // Similarly, we calculate the total number of CEOs for each company by summing up the "comp_numb_CEOs" within each "comp_id" group
bysort comp_id: egen Central_facilities = total(comp_region == "Central") // We count how many facilities each company has in the "Central" region by checking the "comp_region" variable
bysort comp_id: egen Eastern_facilities = total(comp_region == "East") // We count how many facilities each company has in the "East" region
drop if tag !=1 
* We keep only the first observation for each company, as the other observations are duplicates due to the fact the all the necessary information is already involved in other variables
drop tag comp_assets comp_numb_CEOs // We drop the "tag", "comp_assets", and "comp_numb_CEOs" variables, which were only needed for the calculations above
gen total_facilities = Central_facilities + Eastern_facilities // Now we create the total number of facilities for each company by adding up the facilities in both the "Central" and "East" regions

* We could have used "reshape" here but since we are just summing values, it's simpler to do it this way

save "/Users/allakhverdiagakishiev/Desktop/hw/coding/assignment/finale/CodingSTATA2.dta"
* We save the cleaned and modified dataset as "CodingSTATA2.dta" for further analysis
