rawk_find_awk = function()
{
  path = "C:/Rtools/bin/gawk.exe"
}

rawk = function(code = '{print $1}')
{
  call = paste(rawk_find_awk(),sprintf(" -e '%s'", code), " %s")
  return(call)
}



#a = system(path, intern = TRUE)
#a
#tmp = tools::file_path_as_absolute("tmp")
#file = "R/rawk.R"
#fileName = tools::file_path_as_absolute(file)
#system(sprintf(call, fileName), intern = TRUE)




