#' Load a bunch of packages
#' 
#' @param ... List of packages
#' @export
#' @examples
#' \dontrun{
#' packages('glmnet', 'caret')
#' packages('glmnet caret')  # Can just separate with a space
#' packages(list('glmnet', 'caret'), c('e1071', 'parallel multicore'), 'stringr')  # can nest space and vectorization
#' }
packages <- function(...) {
  split_packages <- function(string) strsplit(string, '[^a-zA-Z.$0-9_]+')[[1]]
  pkgs <- unlist(lapply(unlist(list(...)), split_packages))
  suppressPackageStartupMessages(sapply(pkgs, load_package))
  TRUE
}
