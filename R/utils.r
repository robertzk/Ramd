ensure_devtools_installed <- function() {
  if (!package_is_installed("devtools")) {
    stop("Devtools must be installed first. Run `install.packages('devtools')`.")
  }
  TRUE
}

package_is_installed <- function(name) {
  get_package_name_from_ref(name) %in% utils::installed.packages()[,1]
}
