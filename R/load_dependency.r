#' Load a bunch of dependencies by filename
#'
#' @param dep Name of dependency, e.g., relative filename (without .r)
#' \dontrun{
#'   helper <- load_dependency('path/to/helper')
#' }
load_dependency <- function(dep) {
  path <- base::normalizePath(paste(cd, "/", dep, '.r', sep = ''))
  invisible(source(path)$value)
}
