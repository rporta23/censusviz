globalVariables(
  c("STATE", "COUNTY", "tracts_long_all", "tracts_demo_joined", "tract_data", "n")
)
#' Generate data frame with demographic information for 1950-2020 for specified region
#' @export
#' @param path character string speciying the path where data is located
#' @param state character string specifying the name of the desired state
#' @param county character string specifying the name of the desired county
get_data_long <- function(path, state, county) {
  load(here::here(path, "tracts_long_all.rda"))
  tracts_long_all |>
    dplyr::filter(STATE == state, stringr::str_detect(COUNTY, county))
}

#' Generate data frame used to map demographics
#' @rdname get_data_long
#' @export
get_data_wide <- function(path, state, county) {
  load(here::here(path, "tracts_demo_joined.rda"))
  tract_new <- tracts_demo_joined$tract |>
    purrr::map(~ dplyr::filter(.x, STATE == state, stringr::str_detect(COUNTY, county)))
  tibble::tibble(year = tracts_demo_joined$year, tract_data = tract_new) |>
    dplyr::mutate(n = purrr::map_int(tract_data, nrow)) |>
    dplyr::filter(n > 0) |>
    dplyr::select(-n)
}
