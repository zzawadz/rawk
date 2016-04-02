#' Create function for operating on disk files with caching
#'
#' Create function which cache result based on file. If file will be changed, function will also be recalculated, otherwise cached value will be returned
#'
#' @param fnc function that operates on file (first argument must be path to file).
#'
#' @return Return new function with caching functionality
#'
#' @export
#' @importFrom digest digest
#' @examples
#' # ADD EXAMPLES HERE
#'
file_modification_time_cache = function(fnc)
{
  fnc = force(fnc)
  fncName = force(as.character(match.call()$fnc))

  cache = .cache_function

  body = as.list(cache)[[2]]

  paramsList = c(head(as.list(fnc), -1))
  cache = as.function(c(paramsList, .CACHE_VERBOSE = TRUE, body))
  cache

}

.cache_function = function(...)
{
  allParams = as.list(match.call())[-1]

  .CACHE_VERBOSE = tail(allParams,1)[[1]]
  allParams = head(allParams, -1)

  cacheDir = file.path(getwd(), ".cache", fncName)

  if(!dir.exists(cacheDir))
  {
    dir.create(cacheDir, recursive = TRUE)
  }

  modTime = file.mtime(file)
  allParamsToHash = allParams
  allParamsToHash[["MODTIME"]] = modTime

  hash = digest(allParamsToHash)

  cacheFile = file.path(cacheDir, hash)

  if(file.exists(cacheFile))
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
