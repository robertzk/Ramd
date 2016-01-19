#' Load a package and install it if necessary
#' 
#' @name load_package
#' @param name Name of package
#' @examples
#' \dontrun{
#" load_package("glmnet")
#' }
load_package <- function(name) {
  if (package_is_installed(name)) { return(TRUE) }
  if (is_github_package(name)) {
    remote <- "github"
    devtools::install_github(package)
  } else {
    remote <- "CRAN"
    install.packages(package)  # install from CRAN
  }
  if (!package_is_installed(name)) {
    stop(paste('Package', name, "not found on", remote, "."))
  }
}

package_is_installed <- function(name) {
  require(name, character.only = TRUE)
}

is_github_package <- function(name) {
  grepl("/", name, fixed = TRUE)
}
