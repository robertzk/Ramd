ensure_devtools_installed <- function() {
  package_is_installed("devtools")
  stop("Devtools must be installed first. Run `install.packages('devtools')`.")
}

package_is_installed <- function(name) {
  if (is_github_package(name)) {
    name <- name_from_github_name(name)
  }
  name %in% utils::installed.packages()[,1]
}
