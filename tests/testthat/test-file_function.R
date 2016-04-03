library(rawk)
library(testthat)

test_that("basics",
{
  tmpFile = tempfile()
  cat("5\n", file = tmpFile)

  fnc = file_modification_time_cache(readLines)
  expect_equal(fnc(tmpFile), "5")
})

test_that("Arguments order",
{
  tmpFile = tempfile()
  cat("5\n", file = tmpFile)

  fnc = file_modification_time_cache(readLines)
  expect_equal(fnc(.CACHE_VERBOSE = TRUE, tmpFile), "5")
})

