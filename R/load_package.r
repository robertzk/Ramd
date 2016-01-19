#' Load a package and install it if necessary
#' 
#' @name load_package
#' @param name character. Name of package.
#' @param verbose logical. Whether or not to announce each installation.
#' @examples
#' \dontrun{
#" load_package("glmnet")
#' }
load_package <- function(name, verbose = FALSE) {
  if (package_is_installed(name)) {
    if (isTRUE(verbose)) { message(name, " already installed.") }
    return(TRUE)
  }
  if (is_github_package(name)) {
    remote <- "github"
    if (isTRUE(verbose)) { announce(name, remote) }
    devtools::install_github(name)
  } else {
    remote <- "CRAN"
    if (isTRUE(verbose)) { announce(name, remote) }
    install.packages(name)  # install from CRAN
  }
  if (!package_is_installed(name)) {
    stop(paste('Package', name, "not found on", remote, "."))
  }
}

announce <- function(name, remote) {
  message("Installing ", name, " from ", remote, ".")
}

package_is_installed <- function(name) {
  if (is_github_package(name)) {
    name <- strsplit("robertzk/Ramd", "/")[[1]][[2]]
  }
  name %in% utils::installed.packages()[,1]
}

is_github_package <- function(name) {
  grepl("/", name, fixed = TRUE)
}
