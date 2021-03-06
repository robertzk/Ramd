#' Load a bunch of dependencies by filename
#'
#' @name load_dependency
#' @param dep character. Name of dependency, e.g., relative filename (without .r)
#' @param envir environment. The parent environment for the \code{base::source} call.
#' @examples
#' \dontrun{
#'   helper <- load_dependency('path/to/helper')
#' }
load_dependency <- function(dep, envir) {
  path <- suppressWarnings(base::normalizePath(file.path(current_directory(), dep)))
  if (!file.exists(path)) {
    new_path <- paste(path, '.r', sep = '')
    if (!file.exists(new_path)) new_path <- paste(path, '.R', sep = '')
    path <- new_path
  }
  if (!file.exists(path))
    stop(paste("Unable to load dependency '", dep, "'", sep = ''))
  fileinfo <- file.info(path)
  mtime <- fileinfo$mtime

  value <- NULL
  
  if (FALSE && path %in% get_src_cache_names() &&
      mtime == (cache_hit = get_src_cache(path))$mtime) {
    value <- cache_hit$value
  } else {
    # We fetch "source" from the global environment to allow other packages
    # to inject around sourcing files and be compatible with Ramd.
    value <- base::source(path, local = new.env(parent = envir))$value
    set_src_cache(list(value = value, mtime = mtime), path)
  }
  invisible(value)
}
