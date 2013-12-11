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
    value <- source(path)$value
    set_src_cache(list(value = value, mtime = mtime), path)
  }
  invisible(value)
}
