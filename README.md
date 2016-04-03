---
title: "README"
author: "Zygmunt Zawadzki"
date: "2 kwietnia 2016"
output: html_document
---



rawk
===================



# Caching results:


```r
library(rawk)
set.seed(123)

file_function = function(file)
{
  n = as.numeric(readLines(file))
  rnorm(n)
}


tmpFile = tempfile()
cat("5\n", file = tmpFile)

file_function(tmpFile)
```

```
## [1] -0.56047565 -0.23017749  1.55870831  0.07050839  0.12928774
```

```r
## Not match
all(file_function(tmpFile) == file_function(tmpFile))
```

```
## [1] FALSE
```

```r
# Cache function usage:
cache_function = file_modification_time_cache(file_function)
cache_function(tmpFile)
```

```
## [1]  1.7869131  0.4978505 -1.9666172  0.7013559 -0.4727914
```

```r
# fnc result is read from cached file, so in every 
# cache_function call random data will be the same
all.equal(cache_function(tmpFile, .CACHE_VERBOSE = FALSE),
          cache_function(tmpFile, .CACHE_VERBOSE = FALSE))
```

```
## [1] TRUE
```

```r
# file changed:
x = cache_function(tmpFile, .CACHE_VERBOSE = FALSE)
cat("5\n", file = tmpFile)
all.equal(x,
          cache_function(tmpFile, .CACHE_VERBOSE = FALSE))
```

```
## [1] "Mean relative difference: 1.123148"
```
