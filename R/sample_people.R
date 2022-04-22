globalVariables(
  c("variable", "tract_data", "people")
)

#' Helper function to create_dots
#' @param data An sf object containing the geospatial data defining the census tract boundaries joined with racial demographic data for one specific year (one element of the tract_data column of the dataframe returned by get_data_wide function)
#' @param var_id A character string specifying the name of the variable for which to sample
#' @param num_people number of individuals that each dot represents
sample_people <- function(data, var_id, num_people = 1000) {
   x <- data[[var_id]]
   is_na <- is.na(x)
   x <- x %>%
     stats::na.omit() %>%
     as.numeric()
  cat(paste("\nSampling variable:", var_id))
  data  %>%
    dplyr::filter(is_na == FALSE) %>%
    sf::st_sample(size = round(x / num_people), exact = TRUE, by_polygon = TRUE) %>% 
    sf::st_as_sf() %>% 
    dplyr::mutate(variable = var_id)
}

#' Helper function to create_dots
#' @param data An sf object containing the geospatial data defining the census tract boundaries joined with racial demographic data for one specific year (one element of the tract_data column of the dataframe returned by get_data_wide function)
#' @param num_people number of individuals that each dot represents
sample_people_many <- function(data, num_people = 1000) {
  vars <- censusviz::census_var_map %>% 
    dplyr::filter(!is.na(race_label)) %>% 
    dplyr::pull(variable)
  vars_sample <- dplyr::intersect(names(data), vars)
  purrr::map_dfr(vars_sample, sample_people, data = data, num_people = num_people)
}

#' Generate dataframe with locations of dots representing people on map
#' @param data A dataframe containing shapefiles to plot census tract boundaries for each year, output of filter_data_wide function
#' @param num_people number of individuals that each dot represents
#' @export
#' @examples
#' \dontrun{
#' create_dots(filter_data_wide(get_data_wide(), "New York", "Madison"))
#' }
create_dots <- function(data, num_people = 100) {
  if(!is.data.frame(data)) stop("invalid input, 'data' argument must have class data.frame")
  if(!is.numeric(num_people)) {
    message("'num_people' argument must have class numeric, setting num_people to default value of 100")
    num_people <- 100
  }
  message("This may take a few minutes to several hours, depending on the size of the county and the value of the 'num_people' argument...")
  num_people <- round(num_people)
  
  # resolve non-spherical coordinates error
  sf::sf_use_s2(FALSE)
  
  suppressMessages(
    data %>% 
      dplyr::mutate(
        people = purrr::map(tract_data, sample_people_many, num_people = num_people)
      ) %>% 
      dplyr::select(year, people) %>% 
      tidyr::unnest(cols = people) %>% 
      dplyr::left_join(censusviz::census_var_map, by = c("year", "variable")) %>% 
      sf::st_as_sf()
  )
}
