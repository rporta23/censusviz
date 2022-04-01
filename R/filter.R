#' Generate data frame with demographic information for 1950-2020 for specified region
#' @export
get_data_long <- function(path, state, county) {
  load(here::here(path, "tracts_long_all.rda"))
  tracts_long_all |>  
    filter(STATE == state, str_detect(COUNTY, county))
}

#' Generate data frame used to map demographics
#' @export
get_data_wide <- function(state, county) {
  load(here::here("tracts_demo_joined.rda"))
  tract_new <- tracts_demo_joined$tract |>  
    map(~filter(.x, STATE == state, str_detect(COUNTY, county))
    )
  tibble(year = tracts_demo_joined$year, tract_data = tract_new) |> 
    mutate(n = map_int(tract_data, nrow)) |> 
    filter(n > 0) |> 
    select(-n)
}