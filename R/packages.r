packages <- function(...) {
  split_packages <- function(string) strsplit(string, '[^a-zA-Z.$0-9_]+')[[1]]
  pkgs <- unlist(lapply(unlist(list(...)), split_packages))
  sapply(pkgs, load_package)
  TRUE
}
