globalVariables(
  c("year", "tract", "race_label", "is_hispanic", ".")
)

#' Plot census tract boundaries and demographic data on a leaflet map
#' @export
# Creates base layers used by all maps
base_map <- function() {
  leaflet::leaflet() %>% 
    leaflet::addTiles()
}

#' @rdname base_map
#' @export
#' @importFrom dplyr %>%
#' @param people_data A dataframe containing locations to place dots representing people, output of create_dots function
#' @examples 
#' \dontrun{
#' add_people(base_map(), 1915)
#' add_people(base_map(), 1960)
#' add_people(base_map(), 1975)
#' # should see same color mapping
#' add_people(base_map(), 2011)
#' # shouldn't see both sets of points
#' add_people(add_people(base_map(), 1975), 2011)
#' }
add_people <- function(lmap, year_id, people_data) {
  
  # hard-coded maximum points to remove!!
  max_layerId = paste0("people_", 1:2000)
  lmap <- lmap %>% 
    leaflet::removeShape(layerId = max_layerId) %>% 
    leaflet::removeControl(layerId = "people")
  
  data <- people_data %>%  
    dplyr::filter(year == last_census_year(year_id))
  
  if (nrow(data) > 0) { # puts dots on map if they exist
    data <- data %>% 
      dplyr::mutate(
        popup =
          paste(
            "This dot represents <strong>100 people</strong>
          whose race was identified as <strong>",
            race_label,
            "</strong> in the",
            year,
            "Census. These people were",
            ifelse(is_hispanic, "", "<strong>not</strong>"),
            "identified as Hispanic."
          ),
        layerId = paste0("people_", 1:nrow(.))
      )
    
    pal <- colorPeople()
    
    out <- lmap %>% 
      # adds dots representing spatial distribution of racial demographics
      # each demographic group is a different color, and each dot represents 100 people 
      # note that the location of the dots are randomized within each census tract,
      # so they do not represent precise locations of individuals, but they do capture the broader trends
      # in the spatial distribution of demographic groups
      leaflet::addCircles(
        data = data,
        layerId = ~layerId,
        col = ~pal(race_label),
        weight = 3,
        fillOpacity = 0.3,
        popup = ~popup
      ) %>% 
      leaflet::addLegend(
        data = data,
        layerId = "people",
        position = "topleft",
        pal = pal,
        values = unique(census_var_map$race_label),
        title = "Categories"
      )
  } else { # case where year < min year
    out <- lmap
  }
  out
}

#' @rdname base_map
#' @export
#' @param lmap A \code{\link[leaflet]{leaflet}} map object
#' @param year_id A four-digit year
#' @param tract_data A dataframe containing shapefiles to plot census tract boundaries for each year, output of get_data_wide function
#' @examples
#' \dontrun{
#' add_tracts(base_map(), 1960)
#' add_tracts(base_map(), 1975)
#' add_tracts(add_tracts(base_map(), 1960), 2010)
#' }
add_tracts <- function(lmap, year_id, tract_data) {
  # year_id <- convert_year(year_id)
  # maximum number of tracts in any year
  max_num_tracts <- max(purrr::map_int(tract_data$tract_data, nrow))
  # remove any existing tracts
  lmap <- lmap %>%
    leaflet::removeShape(layerId = paste0("tract_", 1:max_num_tracts))
  
  bg <- tract_data %>% 
    dplyr::filter(year == last_census_year(year_id))
  
  if (nrow(bg) > 0) { # add tracts for this Census year only
    
    tract_shp <- bg %>% 
      dplyr::pull(tract_data) %>% 
      purrr::pluck(1)
    ids <- paste0("tract_", 1:nrow(tract_shp))
    
    lmap <- lmap %>%
      leaflet::addPolygons(
        data = tract_shp, 
        layerId = ids,
        fillColor = "white",
        color = "grey",
        weight = 1,
        fillOpacity = 0.3
      )
  }
  lmap
}