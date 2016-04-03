

#' Find awk installation.
#'
#' This function is used for finding awk inplementation in the system.
#'
#' @return
#'
#' Returns path to awk.
#'
#' On Windows tries to use Sys.which("awk"), or Rtools gawk.
#'
#' If it is unable to find rawk, returns NA.
#' @export
#' @examples
#'
#' rawk_find_awk()
#'
rawk_find_awk = function()
{
  if(Sys.info()["sysname"] == "Linux")
  {
    path = Sys.which("awk")
    if(path == "")
    {
        warning("rawk is unable to find awk! Please use rawk_set_awk_path.")
        return(NA)
    }

  } else
  {
    path = Sys.which("gawk.exe")

    if(path == "")
    {
      path = "C:\\Rtools\\bin\\gawk.exe"
      if(!file.exists(path))
      {
        warning("rawk is unable to find awk! Please use rawk_set_awk_path.")
        return(NA)
      }
    }
  }

  return(path)
}

#' Return path to awk
#'
#' Return path to awk.
#'
#' @return
#'
#' Returns path to awk. If it cannot find any awk, throws an error.
#'
#' @export
#' @examples
#'
#' rawk_get_awk_path()
#'
rawk_get_awk_path = function()
{
  rawkPath = getOption("rawk.awk.path")

  if(is.null(rawkPath) || is.na(rawkPath))
  {
    stop("Cannot find awk. Please use rawk_set_awk_path.")
  }

  return(rawkPath)
}


#' Set path to awk
#'
#' Set path to awk for rawk calls.
#'
#' @param path system path to awk implementations.
#' @param test if true, use simple test to determine if \code{path} is valid awk implementation.
#'
#' @return Returns invisible \code{path}.
#'
#' @export
#' @examples
#'
#' rawk_set_awk_path(rawk_get_awk_path(), test = TRUE)
#'
rawk_set_awk_path = function(path, test = FALSE)
{
  options("rawk.awk.path" = path)


  if(test)
  {
    filePath = file.path(path.package("rawk"), "DESCRIPTION")

    test_fnc = rawk('{print $0; exit;}')

    if(test_fnc(filePath, stdout = TRUE) != "Package: rawk")
    {
      stop(sprintf("There is no awk in %s", path))
    }
  }

  return(invisible(path))
}


