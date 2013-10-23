define <- function(dependencies, fn = NULL, ...) {
  if (inherits(dependencies, 'function')) return(fn())

  cd <- current_directory() 
  if (!is.null(fn) && !inherits(fn, 'function')) {
    dependencies <- unlist(c(list(dependencies, fn), list(...)))
    fn = NULL
  }
  arguments <- lapply(dependencies, function(dep) {
    source(paste(cd, "/", dep, '.r', sep = ''))$value
  })
  return(
    if (is.null(fn)) {
      if (length(arguments) == 1) arguments[[1]]
      else arguments
    } else do.call(fn, arguments)
  )
}
