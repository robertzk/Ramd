#' Load a bunch of packages
#' 
#' @param ... List of packages
#' @param verbose logical. Whether or not to announce installations and
#' package startup messages.
#' @export
#' @examples
#' \dontrun{
#' packages("glmnet", "caret")
#' packages("glmnet caret")  # Can just separate with a space
#' packages(list("glmnet", "caret"), c("e1071", "parallel multicore"), "stringr")  # can nest space and vectorization
#' packages("robertzk/Ramd")  # Can install from GitHub
#' packages("robertzk/Ramd", "hadley/dplyr", "peterhurford/batchman")
#' packages("robertzk/Ramd", "glmnet")  # Can install from both CRAN and GitHub
#' }
#' @return TRUE
packages <- function(..., verbose = FALSE) {
  split_packages <- function(string) strsplit(string, '[^a-zA-Z.$0-9_/@]+')[[1]]
  pkgs <- unlist(lapply(unlist(list(...)), split_packages))
  if (isTRUE(verbose)) { sapply(pkgs, load_package, verbose = TRUE) }
  else { suppressPackageStartupMessages(sapply(pkgs, load_package)) }
  TRUE
}
