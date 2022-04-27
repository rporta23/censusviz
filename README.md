
<!-- README.md is generated from README.Rmd. Please edit that file -->

# censusviz

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/censusviz)](https://CRAN.R-project.org/package=censusviz)
<!-- badges: end -->

<right>

<img src="inst/hex-censusviz.png" height="139" />

</right>

The [`censusviz`](https://github.com/rporta23/censusviz) package allows
users to explore and visualize historical racial demographic census data
for any region in the United States using leaflet maps integrated into a
shiny app. This will help facilitate with the process of using
historical census data for analyzing and visualizing.

This package was inspired by the `nepm` package. The nepm package was
initially created as part of a
[DSC-WAV](https://dsc-wav.github.io/www/projects.html) project in fall
2021 funded by the [NSF](https://www.nsf.gov/) with the goal of creating
an [interactive map](https://shiny.smith.edu:3838/bbaumer/nepm/) to
visualize the demographics over time of Springfield, MA in partnership
with [New England Public Media](https://www.nepm.org/).

## Installation

`censusviz` is hosted on GitHub and can be installed by running the
following function:

``` r
remotes::install_github("rporta23/censusviz")
```

``` r
library(censusviz)
```

## Example 1

Visualize spatial distribution of racial demographics for any census
year between 1950-2020 using `add_people()`. Dataframes with locations
of dots to plot on the map for Boston, MA, Manhattan, NY, and San
Francisco, CA, are included in the package. However, you can get the
data for any county in the U.S. using the functions provided in
`censusviz`. See the vignette for more details on how to create this
type of map for any region in the U.S.

``` r
# create map for Boston, MA in 1960
base_map() %>%
  add_people(1960, boston_sample)
```

<img src="inst/boston1.png" height="300" />

``` r
# create map for Boston, MA in 2000
base_map() %>%
  add_people(2000, boston_sample)
```

<img src="inst/boston2.png" height="300" />

## Example 2

Create a line graph to show changes in demographics over time for Boston
(Suffolk County), MA.

``` r
data_long <- get_data_long() %>%
  filter_data_long("Massachusetts", "Suffolk")

data_long_sum <- data_long %>%
  group_by(year, race_label) %>%
  summarize(total = sum(n))
#> `summarise()` has grouped output by 'year'. You can override using the `.groups`
#> argument.

ggplot(data_long_sum, aes(x = year, y = total, color = race_label)) +
  geom_line() +
  labs(
    title = "Change in Racial Demographics over time in Suffolk County, MA",
    x = "Year",
    y = "Number of People",
    color = "Race"
  )
```

<img src="man/figures/README-unnamed-chunk-5-1.png" width="100%" />

## Contributors

-   [Irene Foster](https://github.com/i-m-foster)
-   [Catherine Park](https://github.com/CJParkNW)
-   [Rose Porta](https://github.com/rporta23)
