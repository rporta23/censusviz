
<!-- README.md is generated from README.Rmd. Please edit that file -->

# censusviz <img src="inst/hex-censusviz.png" align="right" height="139">

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/censusviz)](https://CRAN.R-project.org/package=censusviz)
<!-- badges: end -->

The [`censusviz`](https://github.com/rporta23/censusviz) package
provides an interface for exploring and visualizing historical racial
demographic census data (1950-2020) sourced from
[IPUMS](https://data2.nhgis.org/main) for any region in the United
States (by county). The package provides functionality for visualizing
the data on leaflet maps as well as for accessing the data in an
accessible, tidy format such that the user can then create their own
visualizations.

Since the data is very large, it is hosted on GitHub and is not
contained in the package itself. The package includes a few smaller
samples of the data as examples. The raw data can be accessed
[here](https://drive.google.com/drive/folders/1teqLHG8fnrZA-ts0u2qFcQ84Q6hgi6EI?usp=sharing).
See the vignette for more details.

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
#remotes::install_github("rporta23/censusviz")
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
(Suffolk County), MA. The sample of data to create this graph for Boston
is included in the package. See the vignette for details on how to
create this type of graph for any region.

``` r
head(boston_data_long)
#> # A tibble: 6 × 11
#>   GISJOIN   STATE COUNTY variable     n num_people pct_people  year census_label
#>   <chr>     <chr> <chr>  <chr>    <dbl>      <dbl>      <dbl> <dbl> <chr>       
#> 1 G2500250… Mass… Suffo… DFB001    3550       3831    0.927    1980 White       
#> 2 G2500250… Mass… Suffo… DFB002     188       3831    0.0491   1980 Black       
#> 3 G2500250… Mass… Suffo… DFB003       8       3831    0.00209  1980 American In…
#> 4 G2500250… Mass… Suffo… DFB004       0       3831    0        1980 American In…
#> 5 G2500250… Mass… Suffo… DFB005       0       3831    0        1980 American In…
#> 6 G2500250… Mass… Suffo… DFB006      10       3831    0.00261  1980 Asian and P…
#> # … with 2 more variables: race_label <chr>, is_hispanic <lgl>
```

``` r
# group by year and race_label and summarize to create dataframe for line graph
data_long_sum <- boston_data_long %>%
  group_by(year, race_label) %>%
  summarize(total = sum(n))
#> `summarise()` has grouped output by 'year'. You can override using the `.groups`
#> argument.

# create line graph to show change over time in demographics
ggplot(data_long_sum, aes(x = year, y = total, color = race_label)) +
  geom_line() +
  labs(
    title = "Change in Racial Demographics over time in Suffolk County, MA",
    x = "Year",
    y = "Number of People",
    color = "Race"
  )
```

<img src="man/figures/README-unnamed-chunk-6-1.png" width="100%" />

## Contributors

-   [Irene Foster](https://github.com/i-m-foster)
-   [Catherine Park](https://github.com/CJParkNW)
-   [Rose Porta](https://github.com/rporta23)
