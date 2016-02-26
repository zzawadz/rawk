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

#a = system(path, intern = TRUE)
#a
#tmp = tools::file_path_as_absolute("tmp")
#file = "R/rawk.R"
#
#system(sprintf(call, fileName), intern = TRUE)
#rawk_first_column("DESCRIPTION")



