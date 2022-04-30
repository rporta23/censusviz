globalVariables(
  c("STATE", "COUNTY", "tracts_long_all", "tracts_demo_joined1", "tracts_demo_joined2", "tract_data", "n", "tract_long")
)

#' Read in and filter demographic and census tract boundaries data from the U.S. census
#' @export
get_data_long <- function() {
  githubURL <- "https://github.com/CJParkNW/cenviz_data/raw/main/tracts_long_all.rda"
  load(url(githubURL))
  invisible(tracts_long_all)
}

#' @rdname get_data_long
#' @export
get_data_wide <- function() {
  message("This will take roughly 3-5 minutes...")
  options(timeout = 400)
  githubURL1 <- "https://github.com/rporta23/censusviz-data/raw/main/tracts_demo_joined1.rda"
  githubURL2 <- "https://github.com/CJParkNW/cenviz_data/raw/main/tracts_demo_joined2.rda"
  load(url(githubURL1))
  load(url(githubURL2))
  data_wide <- rbind(tracts_demo_joined1, tracts_demo_joined2) %>%
    dplyr::select(-tract_long)
  invisible(data_wide)
}

#' @rdname get_data_long
#' @export
#' @param data A dataframe returned by get_data_long for filter_data_long or get_data_wide for filter_data_wide
#' @param state A character string specifying the name of the desired state
#' @param county A character string specifying the name of the desired county
#' @examples
#' filter_data_long(get_data_long(), "New York", "Madison")
#' filter_data_long(get_data_long(), "Massachusetts", "Hampshire")
filter_data_long <- function(data, state, county) {
  if (!is.data.frame(data)) stop("invalid input, 'data' argument must have class data.frame")
  if (!is.character(state)) stop("invalid input, 'state' argument must have class character")
  if (!is.character(county)) stop("invalid input, 'county' argument must have class character")
  if (length(state) > 1) stop("invalid input, 'state' argument must be a single character string")
  if (length(county) > 1) stop("invalid input, 'county' argument must be a single character string")

  data_check <- data %>%
    dplyr::filter(STATE == state, stringr::str_detect(COUNTY, county))

  if (nrow(data_check) == 0) warning("The data frame being returned has 0 rows. This may have occurred because of incorrect spelling of state or county arguments.")
  data_check
}

#' @rdname get_data_long
#' @export
#' @examples
#' \dontrun{
#' filter_data_wide(get_data_wide(), "New York", "Madison")
#' filter_data_wide(get_data_wide(), "Massachusetts", "Hampshire")
#' }
filter_data_wide <- function(data, state, county) {
  if (!is.data.frame(data)) stop("invalid input, 'data' argument must have class data.frame")
  if (!is.character(state)) stop("invalid input, 'state' argument must have class character")
  if (!is.character(county)) stop("invalid input, 'county' argument must have class character")
  if (length(state) > 1) stop("invalid input, 'state' argument must be a single character string")
  if (length(county) > 1) stop("invalid input, 'county' argument must be a single character string")

  tract_new <- data$tract %>%
    purrr::map(~ dplyr::filter(.x, STATE == state, stringr::str_detect(COUNTY, county)))
  data_check <- tibble::tibble(year = data$year, tract_data = tract_new) %>%
    dplyr::mutate(n = purrr::map_int(tract_data, nrow)) %>%
    dplyr::filter(n > 0) %>%
    dplyr::select(-n)

  if (nrow(data_check) == 0) warning("The data frame being returned has 0 rows. This may have occurred because of incorrect spelling of state or county arguments.")
  data_check
}
