#' These functions are to pre-load data for some cities so they can be easily visualized

# how do i access functions in other files? should this stuff be in data-raw.R or smthin?
# source("sample_people.R")

#' Function to pre-load the population of Boston Massachusetts

bostonSample <- create_dots(filter_data_wide(get_data_wide(), "Massachusetts", "Suffolk"), num_people = 100)

#' Function to pre-load the population of Manhattan, New York

manhattanSample <- create_dots(filter_data_wide(get_data_wide(), "New York", "Manhattan"), num_people = 100)

#' Function to pre-load the population of Chicago Illinois

chicagoSample <- create_dots(filter_data_wide(get_data_wide(), "Illinois", "Cook"), num_people = 100)

#' Function to pre-load the population of Austin, Texas

austinSample <- create_dots(filter_data_wide(get_data_wide(), "Texas", "Austin"), num_people = 100)

#' Function to pre-load the population of San Francisco, California

sanfranciscoSample <- create_dots(filter_data_wide(get_data_wide(), "California", "San Francisco"), num_people = 100)

#' Function to pre-load the population of Seattle, Washington

seattleSample <- create_dots(filter_data_wide(get_data_wide(), "Washington", "King"), num_people = 100)

