test_that("census_var_map has correct dimensions", {

  # Data frame is expected to have 105 rows and 5 columns
  expect_equal(nrow(censusviz::census_var_map), 105)
  expect_equal(ncol(censusviz::census_var_map), 5)
})
