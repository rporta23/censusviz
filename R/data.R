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