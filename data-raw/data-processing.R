## Source code to produce large rda files

library(tidyverse)

safe_unzip <- function(zip) {
  dir <- fs::path_dir(zip)
  unzip_dir <- fs::path_ext_remove(zip)
  if (!fs::dir_exists(unzip_dir)) {
    unzip(zip, exdir = unzip_dir)
  }
}

############################################ Demographics

demographics <- tibble(
  csv = fs::dir_ls(
    here::here("data-large", "demographics"),
    regexp = "_[0-9]{4}_tract\\.csv$",
    recurse = TRUE
  ),
  file = stringr::str_extract(csv, "_[0-9]{4}_tract\\.csv"),
  year = parse_number(stringr::str_sub(file, 1, 5))
)

fix_tracts <- function(x) {
  out <- as.numeric(x)
  out <- if_else(out < 8000, out + 8000, out)
  if_else(out < 10000, out * 100, out)
}

fix_vars <- function(data) {
  data %>%
    mutate(across(where(is.character) & starts_with("H7Z"), parse_integer))
}

# got rid of first row of 2010 data-- double header
# head -n 1 nhgis0004_ds172_2010_tract.csv > part1.csv
# wc -l nhgis0004_ds172_2010_tract.csv
# 74004
# tail -n 74002 nhgis0004_ds172_2010_tract.csv > part2.csv
# cat part1.csv part2.csv > new.csv

x <- demographics %>%
  pull(csv) %>%
  purrr::map(read_csv) %>%
  map(fix_vars) %>%
  map(mutate, tract = fix_tracts(TRACTA))

demographics$tract_wide <- x


census_var_map <- here::here("data-raw", "ipums_var_map.csv") %>%
  read_csv()

tract_demographics_long <- function(data) {
  vars <- census_var_map %>%
    filter(!is.na(race_label)) %>%
    pull(variable)

  data %>%
    select(GISJOIN, any_of(vars), STATE, COUNTY) %>%
    tidyr::pivot_longer(cols = -c(GISJOIN, STATE, COUNTY), names_to = "variable", values_to = "n") %>%
    filter(!is.na(n)) %>%
    mutate(n = as.numeric(n)) %>%
    group_by(GISJOIN) %>%
    mutate(
      num_people = sum(n),
      pct_people = n / num_people
    ) %>%
    left_join(census_var_map, by = "variable") %>%
    tidyr::nest()
}

demographics <- demographics %>%
  mutate(tract_long = map(tract_wide, tract_demographics_long))

save(demographics, file = "demo_all.rda")

############################################ Tracts

shp_zips <- fs::dir_ls(here::here("data-large", "tracts"), regexp = "tract.+zip$")

shp_zips %>%
  purrr::walk(safe_unzip)

tracts <- tibble(
  shp = fs::dir_ls(here::here("data-large"), regexp = "tract_[0-9]{4}\\.shp$", recurse = TRUE),
  year = parse_number(fs::path_file(shp))
)

gis <- tracts %>%
  pull(shp) %>%
  purrr::map(sf::st_read) %>%
  purrr::map(sf::st_transform, 4326)

tracts$tract_gis <- gis

save(tracts, file = "tracts_all.rda")

############################################ Join

x <- tracts %>%
  inner_join(demographics, by = "year")

tracts_demo_joined <- x %>%
  mutate(
    combined = map2(tract_gis, tract_wide, inner_join, by = "GISJOIN")
  ) %>%
  select(year, tract = combined, tract_long)

save(tracts_demo_joined, file = "tracts_demo_joined.rda")

tracts_long_all <- tracts_demo_joined %>%
  select(tract_long) %>%
  unnest(cols = tract_long) %>%
  unnest(cols = data)
save(tracts_long_all, file = "tracts_long_all.rda")
