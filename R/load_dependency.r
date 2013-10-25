#' Load a bunch of dependencies by filename
#'
#' @param dep Name of dependency, e.g., relative filename (without .r)
#' \dontrun{
#'   helper <- load_dependency('path/to/helper')
#' }
load_dependency <- function(dep) {
  path <- base::normalizePath(paste(current_directory(), "/", dep, '.r', sep = ''))
  fileinfo <- file.info(path)
  mtime <- fileinfo$mtime

  value <- NULL
  
  if (path %in% get_src_cache_names() &&
      mtime == (cache_hit = get_src_cache(path))$mtime)
    value <- cache_hit$value
  else {
    print('setting cache') # TODO: Check if file updated
    value <- source(path)$value
    set_src_cache(list(value = value, mtime = mtime), path)
  }
  invisible(value)
}
