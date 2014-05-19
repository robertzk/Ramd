#' Load a bunch of dependencies by filename
#'
#' @param dep Name of dependency, e.g., relative filename (without .r)
#' \dontrun{
#'   helper <- load_dependency('path/to/helper')
#' }
load_dependency <- function(dep) {
  path <- suppressWarnings(base::normalizePath(
           paste(current_directory(), "/", dep, sep = '')))
  if (!file.exists(path)) path <- paste(path, '.r', sep = '')
  if (!file.exists(path))
    stop(paste("Unable to load dependency '", dep, "'", sep = ''))
  fileinfo <- file.info(path)
  mtime <- fileinfo$mtime

  value <- NULL
  
  if (path %in% get_src_cache_names() &&
      mtime == (cache_hit = get_src_cache(path))$mtime)
    value <- cache_hit$value
  else {
    # We fetch "source" from the global environment to allow other packages
    # to inject around sourcing files and be compatible with Ramd.
    value <- get('source', globalenv())(path)$value
    set_src_cache(list(value = value, mtime = mtime), path)
  }
  invisible(value)
}
