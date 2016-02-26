rawk_find_awk = function()
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

  return(path)
}

rawk_get_awk_path = function()
{
  rawkPath = getOption("rawk.awk.path")

  if(is.null(rawkPath) || is.na(rawkPath))
  {
    stop("Cannot find awk. Please use rawk_set_awk_path.")
  }

  return(rawkPath)
}

rawk_set_awk_path = function(path)
{
  options("rawk.awk.path" = path)
  return(invisible())
}


