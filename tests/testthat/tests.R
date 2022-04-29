skip(
  test_that("create_dots() produces a data frame with the correct dimensions.", {
    expect_equal(nrow(create_dots(madison_data_wide)), 4567)
    expect_equal(nrow(create_dots(madison_data_wide, 150)), 3028)
  })
)

test_that("filter_data_long() produces a data frame that filters the data to have the proper dimensions for that county.", {
  expect_equal(nrow(filter_data_long(get_data_long(), "Massachusetts", "Hampshire")), 2558)
  expect_warning(filter_data_long(get_data_long(), "New York", "Madoae"), "The data frame being returned has 0 rows. This may have occurred because of incorrect spelling of state or county arguments.")
})

skip(
  test_that("filter_data_wide() produces a data frame that filters the data to have the proper dimensions for that county.", {
    check_data <- (filter_data_wide(get_data_wide(), "New York", "Madison"))$tract_data[[1]]
    expect_equal(nrow(check_data), 16)
  })
)

test_that("add_people() outputs warning when not within year range.", {
  expect_warning(add_people(base_map(), 1900, boston_sample), "year_id is not within the range of the available data.")
})
