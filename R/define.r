#' Load a bunch of dependencies by filename
#' 
#' This is useful for reducing pollution in the global namespace,
#' and not loading multiple files twice unnecessarily.
#'
#' @param dependencies list of dependencies
#' @param fn function whose argument cardinality matches that of dependencies
#' @export
#' @examples
#' \dontrun{
#' helper_fn <- define('some/dir/helper_fn')
#' define(c('some/dir/helper_fn', 'some/other_dir/library_fn'), function(helper_fn, library_fn) { ... }
#' helper_fns <<- define('some/dir/helper_fn1', 'some/otherdir/helper_fn2')
#' helper_fns[[1]]('do something'); helper_fns[[2]]('do something else')
#' }
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
