#' Load a bunch of dependencies by filename
#'
#' @param dep Name of dependency, e.g., relative filename (without .r)
#' \dontrun{
#'   helper <- load_dependency('path/to/helper')
#' }
.src_cache <- cache()
set_src_cache <- function(value, key = NULL) .src_cache$set(value, key)
get_src_cache <- function(key = NULL) .src_cache$get(key)
get_src_cache_names() <- function() .src_cache$getNames()

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
    set_src_cache(list(value = value, mtime = mtime), path)
  }
  invisible(value)
}
