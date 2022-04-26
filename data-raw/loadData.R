#' Functions are to pre-load data for some cities so they can be easily visualized


library(censusviz)

data_wide <- get_data_wide()

#' Function to pre-load the population of Boston Massachusetts
boston_sample <- data_wide %>%
  filter_data_wide("Massachusetts", "Suffolk") %>%
  create_dots()


#' Function to pre-load the population of Manhattan, New York
manhattan_sample <- data_wide %>%
  filter_data_wide("New York", "Manhattan") %>%
  create_dots()


#' Function to pre-load the population of Chicago Illinois
chicago_sample <- data_wide %>%
  filter_data_wide("Illinois", "Cook") %>%
  create_dots()


#' Function to pre-load the population of Austin, Texas
austin_sample <- data_wide %>%
  filter_data_wide("Texas", "Austin") %>%
  create_dots()


#' Function to pre-load the population of San Francisco, California
sanfrancisco_sample <- data_wide %>%
  filter_data_wide("California", "San Francisco") %>%
  create_dots()


#' Function to pre-load the population of Seattle, Washington
seattle_sample <- data_wide %>%
  filter_data_wide("Washington", "King") %>%
  create_dots()


#' Function to create the data_wide for Madison, New York
madison_data_wide <- data_wide %>% 
  filter_data_wide("New York", "Madison")
  