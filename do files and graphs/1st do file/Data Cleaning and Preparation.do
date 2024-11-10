cd "/Users/allakhverdiagakishiev/Desktop/hw/coding/assignment/do files/1st do file" 
* Sets the working directory to the folder where the .do file is located




pwd // Displays the current working directory
cd ../../.. // Changes the working directory to the root folder (three levels up)
pwd // Displays the new current working directory after changing the directory
dir // Lists the contents of the current directory
import delimited "assignment/osfstorage-archive/cs_bisnode_panel.csv"
* Imports the CSV file cs_bisnode_panel.csv into Stata
browse // Opens the dataset in browse mode 


keep comp_id  curr_assets ceo_count region_m founded_date exit_date 
* Keeps only the variables comp_id, curr_assets, ceo_count, region_m, founded_date, exit_date and drops all other variables
browse // Opens the dataset again in browse mode after filtering the variables
rename curr_assets assets 
rename ceo_count numb_CEOs
rename region_m region 
rename founded_date founded
rename exit_date exit 
* Rename some variables


	foreach var of varlist _all {
		if "`var'" != "comp_id" {
			rename `var' comp_`var'
		}
	}
* Loops through all variables in the dataset and renames each variable  by prefixing them with comp_ (except comp_id, beacause it has comp_ prefix)
	
ds comp_exit, not // Lists all variables except comp_exit
local varlist = r(varlist) // Stores the list of variables (excluding comp_exit) into a local macro varlist
foreach var of local varlist { 
	display "For `var'" 
	capture confirm string variable `var'
	if !_rc {
       drop if missing(`var') | `var' == "NA"
	}
		else{
			drop if missing(`var') 
			  }
}
* Loops through each variable (except comp_exit), checks if it's a string, and drops observations with missing values or "NA" for strings, or just missing values for non-strings }



gen comp_asset = real(comp_assets) // Creates a new variable comp_asset by converting the string variable comp_assets to a numeric variable
drop comp_assets // Drops the original comp_assets variable after conversion
rename comp_asset comp_assets //Renames the newly created numeric variable comp_asset back to comp_assets

gen comp_numb_CEO = real(comp_numb_CEOs) // Creates a new variable comp_numb_CEO by converting the string variable comp_numb_CEOs to a numeric variable
drop comp_numb_CEOs // Drops the original comp_numb_CEOs variable after conversion
rename comp_numb_CEO comp_numb_CEOs // Renames the newly created numeric variable comp_numb_CEO back to comp_numb_CEOs

	
	

	
save "/Users/allakhverdiagakishiev/Desktop/hw/coding/assignment/finale/CodingSTATA.dta"
* Saves the cleaned and modified dataset as CodingSTATA.dta at the specified location
	