#' Return the most recent Census year
#' @param x A year
last_census_year <- function(x) {
  years <- censusviz::census_var_map$year %>% unique()
  if (x < min(years)) {
    return(0)
  } else {
    return(max(years[years <= x]))
  }
}

#' Color palette to be shared across maps
#' @param palette Name of color palette passed to
#' \code{\link[grDevices]{hcl.colors}}
colorPeople <- function(palette = "Zissou 1") {
  # set race categories
  categories <- unique(censusviz::census_var_map$race_label)
  # set color palette
  leaflet::colorFactor(
    grDevices::hcl.colors(n = length(categories), palette = palette),
    categories
  )
}
