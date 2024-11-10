cd "/Users/allakhverdiagakishiev/Desktop/hw/coding/assignment/do files/3rd do file"
* Sets the working directory to the folder where the 3rd .do file is located

use "/Users/allakhverdiagakishiev/Desktop/hw/coding/assignment/finale/CodingSTATA2.dta"
* Loads the dataset "CodingSTATA2.dta" that was created and saved in the second .do file


summarize // Displays summary statistics (like mean, standard deviation, etc.) for all variables in the dataset
summarize total_assets total_CEO, detail  // Displays detailed summary statistics for the "total_assets" and "total_CEO" variables, including percentiles, variance, etc.


tabstat total_assets total_CEO total_facilities, statistics(mean sd) columns(statistics) //Generates a table of summary statistics (mean and standard deviation) for "total_assets", "total_CEO", and "total_facilities" variables


tabulate comp_region // Then,lets say, our boss wanted to know how many companies are in each (out of 2) region, so I created a frequency table for the "comp_region" variable to check the distribution
list comp_id  total_assets if comp_region == "Central"
list comp_id  total_assets if comp_region == "East"

* The boss also wanted to analyze companies based on the number of CEOs, so I created a new binary variable, "ceo_bin", to categorize companies
gen ceo_bin = .
replace ceo_bin = 1 if total_CEO < 5 // Assigns the value 1 to "ceo_bin" if the number of CEOs ("total_CEO") is less than 5
replace ceo_bin = 2 if total_CEO >= 5 & total_CEO < 15 // Assigns the value 2 to "ceo_bin" if the number of CEOs is between 5 and 15
replace ceo_bin = 3 if total_CEO >= 15 // Assigns the value 3 to "ceo_bin" if the number of CEOs is 15 or more
* I defined value labels for the "ceo_bin" variable so that it would be more meaningful when the boss looks at the output
label define ceo_bin_lbl 1 "Less than 5" 2 "5 to 15" 3 "More than 15" 
* Than I applied the value labels to the "ceo_bin" variable so that the categories would be displayed as "Less than 5", "5 to 15", and "More than 15"
label values ceo_bin ceo_bin_lbl
tabstat total_assets, by(ceo_bin) stats(mean, max, min) //Analyze the "total_assets" for each CEO category
tabstat total_assets, stats(mean, max, min) // The boss also wanted a general summary of "total_assets" without grouping by any variable

* Now we are asked to visualize some data
gen assets_thousands = total_assets/ 1000 // To make total_assets more "readable" we will count them in thousands
drop total_assets // Drops the original "total_assets" variable after creating the "assets_thousands" variable
graph bar (mean) assets_thousands, over(ceo_bin, label(labsize(vsmall))) //Creates a bar graph of the mean "assets_thousands", grouped by "ceo_bin" with small labels on the bars
* Our boss said that this bat graph is not representitive so we need to make it more spesific(without bins so that we can see spesific assets means for spesific number of CEO)
graph bar (mean) assets_thousands, over(total_facilities, label(labsize(vsmall))) ///
    title("Mean Total Assets by Total Facilities") ///
    ytitle("Mean Total Assets in thousands ($)") ///
    bar(1, color(green)) ///
    blabel(bar, size(medium) color(white)) ///
    graphregion(color(white)) ///
    plotregion(margin(10 10 0 10)) ///
    ylabel(, angle(0) grid) //Here we Created a bar graph of the mean "assets_thousands" grouped by "total_facilities" with various styling options like color, labels, title, and gridlines
	graph export "/Users/allakhverdiagakishiev/Desktop/hw/coding/assignment/do files/graphs/Total_Assets_by_Total_Facilities.png" // than we saved it as a PNG image file
	
	
//The boss wanted to see a line graph of the average assets based on the number of central facilities
preserve //*Before making further changes to the dataset, I preserved the current state so I could restore it late(because i will use colapse command)
collapse (mean) assets_thousands, by(Central_facilities) //The boss then asked me to look at the average assets by the number of central facilities, so I collapsed the data by "Central_facilities" to calculate the mean
twoway (line assets_thousands Central_facilities if Central_facilities != 0, ///
        lcolor(blue) lwidth(medium) lpattern(solid) mcolor(black) msize(medium)), ///
    title("Average Assets by Central Facilities") ///
	ytitle("Average Assets (thousands)") ///
    legend(off) // Here we sketch this function using "twoway" command  and addind some customization
		graph export "/Users/allakhverdiagakishiev/Desktop/hw/coding/assignment/do files/graphs/Average_Assets_by_Central_Facilities.png" // than we saved it as a PNG image file
restore

*Than boss asked to do the same for eastern facilities
preserve
collapse (mean) assets_thousands, by(Eastern_facilities)
twoway (line assets_thousands Eastern_facilities if Eastern_facilities != 0, ///
        lcolor(blue) lwidth(medium) lpattern(solid) mcolor(black) msize(medium)), ///
    title("Average Assets by Eastern Facilities") ///
	ytitle("Average Assets (thousands)") ///
    legend(off) 
	graph export "/Users/allakhverdiagakishiev/Desktop/hw/coding/assignment/do files/graphs/Average_Assets_by_Eastern_Facilities.png"
restore    

save "/Users/allakhverdiagakishiev/Desktop/hw/coding/assignment/finale/CodingSTATA3.dta"
* Finally, I saved the dataset with all the transformations as "CodingSTATA3.dta" for further analysis or reporting
