#' Load a bunch of packages
#' 
#' @param ... List of packages
#' @param verbose logical. Whether or not to announce installations and
#' package startup messages.
#' @examples
#' \dontrun{
#' packages("glmnet")           # Can install from CRAN
#' packages("robertzk/Ramd")    # Can install from GitHub
#' packages("glmnet", "caret")  # can load multiple packages in one call
#' packages("robertzk/Ramd", "hadley/dplyr", "peterhurford/batchman")  # Can load multiple
#' packages("robertzk/Ramd", "glmnet")  # Can install from both CRAN and GitHub
#' packages("robertzk/Ramd@@v0.3")      # Can load from versions
#' packages("robertzk/Ramd@@0.3")
#' packages("robertzk/Ramd@@fbe1aa0e36df289b27881d077635352e6debdbc1")  # Can load from refs
#' packages(list("FeiYeYe/xgboost", subdir = "R-package"))              # Can load from subdirectories
#' }
#' @export
packages <- function(..., verbose = FALSE) {
  pkgs <- unique(list(...))
  if (isTRUE(verbose)) { vapply(pkgs, load_package, verbose = TRUE, logical(1)) }
  else { suppressPackageStartupMessages(vapply(pkgs, load_package, logical(1))) }
  TRUE
}
