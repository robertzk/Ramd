#' Load a package and install it if necessary
#' 
#' @name load_package
#' @param name character. Name of package.
#' @param verbose logical. Whether or not to announce each installation.
#' @examples
#' \dontrun{
#' load_package("glmnet")
#' load_package("robertzk/Ramd")
#' load_package("robertzk/Ramd@@v0.3")   # Can load from versions
#' load_package("robertzk/Ramd@@0.3")
#' load_package("robertzk/Ramd@@fbe1aa0e36df289b27881d077635352e6debdbc1")  # Can load from refs
#' load_package(list("FeiYeYe/xgboost", subdir = "R-package"))  # Can load from subdirectories
#' }
load_package <- function(name, verbose = FALSE) {
  metadata <- name[-1]  # For tracking things like subdir
  name <- name[[1]]

  handle_version_mismatches(name, verbose)

  if (package_is_installed(name)) {
    if (isTRUE(verbose)) { message(name, " already installed.") }
    return(TRUE)
  }

  if (is_github_package(name)) {
    remote <- "GitHub"
    install_from_github(name, metadata, remote, verbose)
  } else {
    remote <- "CRAN"
    install_from_cran(name, remote, verbose)
  }

  if (!package_is_installed(name)) {
    stop(paste("Package", name, "not found on", remote, "."))
  }
  require(name, character.only = TRUE)
}

handle_version_mismatches <- function(name, verbose) {
  if (is_version_mismatch(name)) {
    if (isTRUE(verbose)) {
      message("Removing prior installation of ", name_from_github_name(name))
    }
    utils::remove.packages(get_package_name_from_ref(name))
  }
}

install_from_github <- function(name, metadata, remote, verbose) {
  ensure_devtools_installed()
  if (isTRUE(verbose)) { announce(name, remote) }
  if (length(metadata) > 0) {
    do.call(devtools::install_github, c(list(name), metadata))
  } else {
    devtools::install_github(name)
  }
}

install_from_cran <- function(name, remote, verbose) {
  if (isTRUE(verbose)) { announce(name, remote) }
  utils::install.packages(name)  # install from CRAN
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


get_package_name_from_ref <- function(name) {
  # extract Ramd from robertzk/Ramd@v0.3
  strsplit(strsplit(name, "@")[[1]][[1]], "/")[[1]][[2]]
}


is_version_mismatch <- function(name) {
  is_versionable <- function(name) {
    grepl("@", name, fixed = TRUE) &&
    grepl("^[v0-9.]*$", get_version_from_ref(name))
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
    utils::packageVersion(get_package_name_from_ref(name)) !=
      package_version(get_version_from_ref(name))
  }

  # Checks for specified refs or package names, e.g. robertzk/Ramd@v0.3
  is_github_package(name) && is_versionable(name) && is_version_mismatch(name)
}
