sed = function(x, query, ...)
{
  #query = "s/foo/bar/g"
  #x = "foobar"

  qs = strsplit(query, split = "")[[1]]
  sep =  qs[2]

  patterns = stri_split_fixed(query, pattern = sep)[[1]][2:3]

  if(qs[1] == "s" && tail(qs,1) == "g")
  {
    result = stri_replace_all_regex(x,
                                    pattern = patterns[1],
                                    replacement = patterns[2],
                                    ...)
    return(result)
  }

  if(qs[1] == "s" && tail(qs,1) != "g")
  {
    result = stri_replace_first_regex(x,
                                pattern = patterns[1],
                                replacement = patterns[2],
                                ...)
    return(result)
  }

  stop("Cannot parse query!")
}
