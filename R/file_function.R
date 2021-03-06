#' Create function for operating on disk files with caching
#'
#' Create function which cache result based on file. If file will be changed, function will also be recalculated, otherwise cached value will be returned.
#'
#' @param fnc function that operates on file (first argument must be path to the file).
#'
#' @return Return new function with caching functionality
#'
#' @export
#' @importFrom digest digest
#' @examples
#'
#' fnc <- function(file) {
#'    n <- as.numeric(readLines(file, warn = FALSE))
#'    rnorm(n)
#' }
#'
#' file <- tempfile()
#' cat(5, file = file)
#' all.equal(fnc(file), fnc(file))
#'
#' fcached <- file_modification_time_cache(fnc)
#'
#' all.equal(fcached(file), fcached(file))
#'
#' x <- fcached(file)
#'
#' cat(5, file = file)
#' y <- fcached(file)
#' all.equal(x, y)
#'
#' fnc2 <- function(file, k = 2) {
#'    n <- as.numeric(readLines(file, warn = FALSE))
#'    rnorm(n * k)
#' }
#'
#' fcached2 <- file_modification_time_cache(fnc2)
#' all.equal(fcached2(file,1), fcached2(file,1))
#' all.equal(fcached2(file,1), fcached2(file,2))
#'
file_modification_time_cache = function(fnc)
{
  fnc = force(fnc)
  fncName = force(as.character(match.call()$fnc))

  cache = .cache_function

  body = as.list(cache)[[2]]

  cacheDir = file.path(getwd(), ".cache", fncName)

  paramsList = c(head(as.list(fnc), -1))
  cache = as.function(c(paramsList, .CACHE_VERBOSE = TRUE, .FORCE_RECALC = FALSE, body))
  class(cache) <- c("FileCacheFunction", class(cache))
  cache
}

.cache_function = function(...)
{
  allParams = as.list(match.call())[-1]


  if(any(names(allParams) == ".CACHE_VERBOSE"))
  {
    idx = which(names(allParams) == ".CACHE_VERBOSE")
    .CACHE_VERBOSE = allParams[[idx]]
    allParams = allParams[-idx]

  } else
  {
    .CACHE_VERBOSE = TRUE
  }

  if(any(names(allParams) == ".FORCE_RECALC"))
  {
    idx = which(names(allParams) == ".FORCE_RECALC")
    .FORCE_RECALC = allParams[[idx]]
    allParams = allParams[-idx]

  } else
  {
    .FORCE_RECALC = FALSE
  }

  if(!dir.exists(cacheDir)) {
    dir.create(cacheDir, recursive = TRUE)
  }


  file = eval(allParams[[1]], parent.frame())
  allParams = lapply(allParams, eval, parent.frame())

  modTime = file.mtime(file)
  allParamsToHash = allParams
  allParamsToHash[["MODTIME"]] = modTime

  hash = digest(allParamsToHash)

  cacheFile = file.path(cacheDir, hash)

  if(file.exists(cacheFile) && !.FORCE_RECALC)
  {
    if(.CACHE_VERBOSE)
    {
      message(sprintf("Loaded %s, last access time: %s, hash: %s", file, modTime, hash))
    }
    return(readRDS(cacheFile))
  }

  value = do.call(fnc, allParams)
  saveRDS(value, cacheFile)

  if(.CACHE_VERBOSE)
  {
    message(sprintf("Saved %s, last access time: %s, hash: %s", file, modTime, hash))
  }

  return(value)
}


#' @S3method print FileCacheFunction
print.FileCacheFunction <- function(x, ...) {

  cat("Function with a cache based on the file modification time\n")
  cat("\nCache directory: ", environment(x)$cacheDir)
  cat("\nTo force recalculation please use .FORCE_RECALC = TRUE")
  cat("\n\nOriginal function:\n")
  print(environment(x)$fnc)
}
