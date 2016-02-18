rawk_find_awk = function()
{
  Sys.which("gawk.exe")
}

rawk = function(code = '{print $1}')
{
  call = paste(sprintf(" -e '%s'", code), " %s")

  function(file, stdout = "", ...)
  {
    fileName = tools::file_path_as_absolute(file)
    args = sprintf(call, fileName)
    system2(rawk_find_awk(), args = args, stdout = stdout, ...)
  }
}

rawk_first_column = rawk()


#a = system(path, intern = TRUE)
#a
#tmp = tools::file_path_as_absolute("tmp")
#file = "R/rawk.R"
#
#system(sprintf(call, fileName), intern = TRUE)
#rawk_first_column("DESCRIPTION")



