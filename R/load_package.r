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
  if (is.list(name)) {
    metadata <- name[-1]  # For tracking things like subdir
    name <- name[[1]]
  } else {
    metadata <- NULL
  }
  if (package_is_installed(name)) {
    if (isTRUE(verbose)) { message(name, " already installed.") }
    return(TRUE)
  }
  if (is_version_mismatch(name)) {
    if (isTRUE(verbose)) {
      message("Removing prior insallation of ", name_from_github_name(name))
    }
    utils::remove.packages(name)
  }
  if (is_github_package(name)) {
    ensure_devtools_installed()
    remote <- "GitHub"
    if (isTRUE(verbose)) { announce(name, remote) }
    if (!is.null(metadata)) {
      do.call(devtools::install_github, c(name, metadata))
    } else {
      devtools::install_github(name)
    }
  } else {
    remote <- "CRAN"
    if (isTRUE(verbose)) { announce(name, remote) }
    utils::install.packages(name)  # install from CRAN
  }
  if (!package_is_installed(name)) {
    stop(paste("Package", name, "not found on", remote, "."))
  }
  TRUE
}


announce <- function(name, remote) {
  message("Installing ", name, " from ", remote, ".")
}


name_from_github_name <- function(name) {
  strsplit(strsplit(name, "/")[[1]][[2]], "@")[[1]][[1]]
}


is_github_package <- function(name) {
  # Checks for github repos, e.g., robertzk/Ramd
  grepl("/", name, fixed = TRUE)
}


is_version_mismatch <- function(name) {
  is_versionable <- function(name) {
    grepl("@", name, fixed = TRUE) &&
    grepl(".", name, fixed = TRUE)
  }
  get_version_from_ref <- function(name) {
    # extract 0.3 from robertzk/Ramd@v0.3
    name <- strsplit(name, "@")[[1]][[2]]
    if (grepl("v", name, fixed = TRUE)) {
      name <- strsplit(name, "v")[[1]][[2]]
    }
    name
  }

  is_version_mismatch <- function(name) {
    packageVersion(name) != package_version(get_version_from_ref(name))
  }

  # Checks for specified refs or package names, e.g. robertzk/Ramd@v0.3
  is_github_package(name) && is_versionable(name) && is_version_mismatch(name)
}
