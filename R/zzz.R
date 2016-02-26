.onLoad <- function(libname, pkgname)
{
  if (is.null(getOption("rawk.awk.path")))
  {
    path = rawk_find_awk()
    options("rawk.awk.path" = path)
  }
  invisible(NULL)
}

.onUnload <- function(libpath)
{
  options("rawk.awk.path"=NULL)
  invisible(NULL)
}
