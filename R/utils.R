#' Return the most recent Census year
#' @export
#' @param x A year
#' @examples 
#' last_census_year(1920)
#' last_census_year(1960)
#' last_census_year(1975)
#' last_census_year(1980)
#' last_census_year(1985)
last_census_year <- function(x) {
  years <- censusviz::census_var_map$year |> unique()
  if (x < min(years)) {
    return(0)
  } else {
    return(max(years[years <= x]))
  }
}

#' Color palette to be shared across maps
#' @rdname last_census_year
#' @export
#' @param palette Name of color palette passed to 
#' \code{\link[grDevices]{hcl.colors}}
#' @examples 
#' pal <- colorPeople()
#' pal("White")
#' pal("Black")
#' pal("Other")
colorPeople <- function(palette = "Zissou 1") {
  # set race categories
  categories <- unique(censusviz::census_var_map$race_label)
  # set color palette
  leaflet::colorFactor(
    grDevices::hcl.colors(n = length(categories), palette = palette), 
    categories
  )
}