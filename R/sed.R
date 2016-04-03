

#' Simple sed imitation.
#'
#' This function tries to imitate sed (stream editor), especially \code{s/foo/bar/g} syntax.
#'
#' @param x character vector
#' @param query sed query.
#' @param ... other parameters passed to stringi functions.
#'
#' @return Character vector.
#'
#' @export
#' @importFrom stringi stri_split_fixed stri_replace_first_regex stri_replace_first_regex
#' @examples
#'
#' query = "s/foo/bar/g"
#' x = "foobar"
#' sed(x, query)
#'
sed = function(x, query, ...)
{
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
