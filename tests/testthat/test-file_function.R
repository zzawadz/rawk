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

test_that("Caching",
{
  set.seed(123)

  tmpFile = tempfile()
  cat("5\n", file = tmpFile)

  file_fnc = function(x)
  {
    n = as.numeric(readLines(x))
    rnorm(n)
  }

  fnc = file_modification_time_cache(file_fnc)
  expect_equal(fnc(tmpFile, .CACHE_VERBOSE = FALSE), fnc(.CACHE_VERBOSE = TRUE, tmpFile))
})


