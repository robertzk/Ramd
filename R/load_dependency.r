#' Load a bunch of dependencies by filename
#'
#' @param dep Name of dependency, e.g., relative filename (without .r)
#' \dontrun{
#'   helper <- load_dependency('path/to/helper')
#' }
cache <- list()
load_dependency <- function(dep) {
  path <- base::normalizePath(paste(current_directory(), "/", dep, '.r', sep = ''))
  fileinfo <- file.info(path)
  mtime <- fileinfo$mtime

  value <- NULL
  if (path %in% names(cache) && mtime == cache[[path]]$mtime)
    value <- cache[[path]]$value
  else {
    print('setting cache') # TODO: Check if file updated
    value <- source(path)$value
    cache[[path]] <<- list(value = value, mtime = mtime)
  }
  invisible(value)
}
