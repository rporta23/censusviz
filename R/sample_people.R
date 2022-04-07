globalVariables(
  c("variable", "tract_data", "people")
)

#' Helper function to create_dots
sample_people <- function(data, var_id, num_people = 1000) {
  x <- data[[var_id]]
  cat(paste("\nSampling variable:", var_id))
  data |> 
    sf::st_sample(size = round(x / num_people), exact = TRUE, by_polygon = TRUE) |> 
    sf::st_as_sf() |> 
    dplyr::mutate(variable = var_id)
}

#' Helper function to create_dots
sample_people_many <- function(data, num_people = 1000) {
  vars <- censusviz::census_var_map |> 
    dplyr::filter(!is.na(race_label)) |> 
    dplyr::pull(variable)
  vars_sample <- dplyr::intersect(names(data), vars)
  purrr::map_dfr(vars_sample, sample_people, data = data, num_people = num_people)
}

#' Generate dataframe with locations of dots representing people on map
#' @export
create_dots <- function(data, num_people = 100) {
  # resolve non-spherical coordinates error
  sf::sf_use_s2(FALSE)
  data |> 
    dplyr::mutate(
      people = purrr::map(tract_data, sample_people_many, num_people = num_people)
    ) |> 
    dplyr::select(year, people) |> 
    tidyr::unnest(cols = people) |> 
    dplyr::left_join(censusviz::census_var_map, by = c("year", "variable")) |> 
    sf::st_as_sf()
}
