# pre-load data for some cities so they can be easily visualized

library(censusviz)
library(dplyr)

data_wide <- get_data_wide()

# pre-load the population of Boston Massachusetts
boston_sample <- data_wide %>%
  filter_data_wide("Massachusetts", "Suffolk") %>%
  create_dots()

usethis::use_data(boston_sample, overwrite = TRUE)

# pre-load the population of Manhattan, New York
manhattan_sample <- data_wide %>%
  filter_data_wide("New York", "New York") %>%
  create_dots()

usethis::use_data(manhattan_sample, overwrite = TRUE)

# pre-load the population of San Francisco, California
sanfrancisco_sample <- data_wide %>%
  filter_data_wide("California", "San Francisco") %>%
  create_dots()

usethis::use_data(sanfrancisco_sample, overwrite = TRUE)

# create the data_wide for Madison, New York
madison_data_wide <- data_wide %>%
  filter_data_wide("New York", "Madison")

usethis::use_data(madison_data_wide, overwrite = TRUE)

# example for data_long-- Suffolk County, MA
boston_data_long <- get_data_long() %>%
  filter_data_long("Massachusetts", "Suffolk")

usethis::use_data(boston_data_long, overwrite = TRUE)

