## code to prepare census_var_map dataset goes here
census_var_map <- readr::read_csv("data-raw/ipums_var_map.csv")

usethis::use_data(census_var_map, overwrite = TRUE)
