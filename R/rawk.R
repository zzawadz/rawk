
#' Create awk function.
#'
#'
#'
#' @param code awk code
#'
#' @export
#'
#' @return Retrun function which executes awk code on a file.
#'
#' Returned function arguments:
#'
#' \code{file} path to file
#'
#' \code{stdout} standard output. By default result is printed into console. See \link{system2} for futher description.
#'
#' \code{...} Other arguments passed to \link{system2}.
#'
#' @examples
#'
#' file = tempfile()
#' cat('1\n2\n', file = file)
#'
#' rawk()(file)
#'
#' # Capture output
#' awk = rawk('{print $0}')
#' awk(file, stdout = TRUE)
#'
rawk = function(code = '{print $1}')
{
  callCode = paste(sprintf(" -e '%s'", code), " %s")

  function(file, stdout = "", ...)
  {
    fileName = tools::file_path_as_absolute(file)
    args = sprintf(callCode, fileName)
    system2(rawk_get_awk_path(), args = args, stdout = stdout, ...)
  }
}


rawk_pkg = function(script, pkgName)
{
  path = file.path(find.package("rawk"), "awk", script)

  callCode = paste(sprintf(" -f '%s'", path), " %s")

  function(file, stdout = "", ...)
  {
    fileName = tools::file_path_as_absolute(file)
    args = sprintf(callCode, fileName)
    system2(rawk_get_awk_path(), args = args, stdout = stdout, ...)
  }
}

rawk_first_column = rawk()
rawk_pkg_test = rawk_pkg("awkTest.awk", "rawk")


