globalVariables(
  c("STATE", "COUNTY", "tracts_long_all", "tracts_demo_joined", "tract_data", "n")
)

#' Read in and load tracts_long_all
#' @export
get_data_long <- function() {
  githubURL <- "https://github.com/CJParkNW/cenviz_data/raw/main/tracts_long_all.rda"
  load(url(githubURL))
  invisible(tracts_long_all)
}

#' Read in and load tracts_demo_joined
#' @export
get_data_wide <- function() {
  options(timeout = 400)
  githubURL1 <- "https://github.com/rporta23/censusviz-data/raw/main/tracts_demo_joined1.rda"
  githubURL2 <- "https://github.com/CJParkNW/cenviz_data/raw/main/tracts_demo_joined2.rda"
  load(url(githubURL1))
  load(url(githubURL2))
  invisible(rbind(tracts_demo_joined1, tracts_demo_joined2))
}

#' Generate data frame with demographic information for 1950-2020 for specified region
#' @export
#' @param path A character string specifying the path where data is located
#' @param state A character string specifying the name of the desired state
#' @param county A character string specifying the name of the desired county
filter_data_long <- function(data, state, county) {
  data %>%
    dplyr::filter(STATE == state, stringr::str_detect(COUNTY, county))
}

#' Generate data frame used to map demographics
#' @rdname get_data_long
#' @export
filter_data_wide <- function(data, state, county) {
  tract_new <- data$tract %>%
    purrr::map(~ dplyr::filter(.x, STATE == state, stringr::str_detect(COUNTY, county)))
  tibble::tibble(year = data$year, tract_data = tract_new) %>%
    dplyr::mutate(n = purrr::map_int(tract_data, nrow)) %>%
    dplyr::filter(n > 0) %>%
    dplyr::select(-n)
}
