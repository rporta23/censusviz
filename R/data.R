#' Variables from the US Census
#' @docType data
#' @description A dataset containing information used to map variable names from IPUMS to grouped and abbreviated variable names to display on map
#' @format a tibble with 90 rows and 5 columns
#' \describe{
#'   \item{year}{census year}
#'   \item{variable}{original (IPUMS) variable name}
#'   \item{census_label}{census label corresponding to variable name}
#'   \item{race_label}{race label manually assigned to variable for the purpose of displaying on the map}
#'   \item{is_hispanic}{logical telling whether or not individuals in the labeled group are Hispanic}
#' }
"census_var_map"

#' US Census data for Boston, MA (Suffolk County)
#' @docType data
#' @description A pre-loaded dataset for the population of Boston, MA
#' @format A tibble with 58861 rows and 6 columns
#' \describe{
#'   \item{year}{Census year}
#'   \item{variable}{Original (IPUMS) variable name that categorizes race}
#'   \item{x}{A latitude longitude point}
#'   \item{census_label}{Census label corresponding to variable name}
#'   \item{race_label}{Race label manually assigned to variable for the purpose of displaying on the map}
#'   \item{is_hispanic}{Logical telling whether or not individuals in the labeled group are Hispanic}
#' }
#' @source IPUMS: data can be accessed at <https://www.ipums.org/>
"boston_sample"

#' US Census data for Manhattan, NY (Manhattan County)
#' @docType data
#' @description A pre-loaded dataset for the population of Manhattan, NY
#' @format A tibble with 128297 rows and 6 columns
#' \describe{
#'   \item{year}{Census year}
#'   \item{variable}{Original (IPUMS) variable name that categorizes race}
#'   \item{x}{A latitude longitude point}
#'   \item{census_label}{Census label corresponding to variable name}
#'   \item{race_label}{Race label manually assigned to variable for the purpose of displaying on the map}
#'   \item{is_hispanic}{Logical telling whether or not individuals in the labeled group are Hispanic}
#' }
#' @source IPUMS: data can be accessed at <https://www.ipums.org/>
"manhattan_sample"

#' US Census data for San Francisco, CA (San Francisco County)
#' @docType data
#' @description A pre-loaded dataset for the population of San Francisco, CA
#' @format A tibble with 60125 rows and 6 columns
#' \describe{
#'   \item{year}{Census year}
#'   \item{variable}{Original (IPUMS) variable name that categorizes race}
#'   \item{x}{A latitude longitude point}
#'   \item{census_label}{Census label corresponding to variable name}
#'   \item{race_label}{Race label manually assigned to variable for the purpose of displaying on the map}
#'   \item{is_hispanic}{Logical telling whether or not individuals in the labeled group are Hispanic}
#' }
#' @source IPUMS: data can be accessed at <https://www.ipums.org/>
"sanfrancisco_sample"

#' US Census data for Madison, NY (Madison County) in wide format
#' @docType data
#' @description A dataset for the population of Madison, NY
#' @format A tibble with 7 rows and 2 columns
#' \describe{
#'   \item{year}{Census year}
#'   \item{tract_data}{An sf list with the data needed to plot the data on the map}
#' }
#' @source IPUMS: data can be accessed at <https://www.ipums.org/>
"madison_data_wide"

#' US Census data for Boston, MA (Suffolk County) in long format
#' @docType data
#' @description A dataset for the population of Boston, MA in long format
#' @format A tibble with 16319 rows and 11 columns
#' \describe{
#'   \item{GISJOIN}{The census tract}
#'   \item{STATE}{The state the county is located in}
#'   \item{COUNTY}{The County}
#'   \item{variable}{Original (IPUMS) variable name that categorizes race}
#'   \item{n}{The number of people of in the race category in that tract that year}
#'   \item{num_people}{The total number of people in that tract for that year}
#'   \item{pct_people}{The percent that the race category is in that tract that year}
#'   \item{year}{Census year}
#'   \item{x}{A latitude longitude point}
#'   \item{census_label}{Census label corresponding to variable name}
#'   \item{race_label}{Race label manually assigned to variable for the purpose of displaying on the map}
#'   \item{is_hispanic}{Logical telling whether or not individuals in the labeled group are Hispanic}
#' }
#' @source IPUMS: data can be accessed at <https://www.ipums.org/>
"boston_data_long"
