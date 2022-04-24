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
#' add_people(base_map(), 2000, create_dots(filter_data_wide(get_data_wide(), "New York", "Madison")))
#' }
add_people <- function(lmap, year_id, people_data) {
  if(class(lmap)[[1]] != "leaflet") stop("invalid input, 'lmap' argument must have class leaflet")
  if(!is.numeric(year_id)) stop("invalid input, 'year_id' argument must have class numeric")
  if(!is.data.frame(people_data)) stop("invalid input, 'people_data' argument must have class data.frame")
  if(length(year_id) > 1) stop("invalid input, 'year_id' argument must have length 1")
  
  data <- people_data %>%  
    dplyr::filter(year == last_census_year(year_id))
  
  if (nrow(data) > 0) { # puts dots on map if they exist
    
    # create popups
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
    
    pal <- colorPeople() # generate color palette
    
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
        values = unique(censusviz::census_var_map$race_label),
        title = "Race"
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
#' add_tracts(base_map(), 1960, filter_data_wide(get_data_wide(), "New York", "Madison"))
#' }
add_tracts <- function(lmap, year_id, tract_data) {
  if(class(lmap)[[1]] != "leaflet") stop("invalid input, 'lmap' argument must have class leaflet")
  if(!is.numeric(year_id)) stop("invalid input, 'year_id' argument must have class numeric")
  if(!is.data.frame(tract_data)) stop("invalid input, 'tract_data' argument must have class data.frame")
  if(length(year_id) > 1) stop("invalid input, 'year_id' argument must have length 1")
  
  # add tracts for the most recent Census year only
  bg <- tract_data %>% 
    dplyr::filter(year == last_census_year(year_id))
  
  if (nrow(bg) > 0) { # put tracts on map if they exist
    
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