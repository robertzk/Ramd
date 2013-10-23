load_package <- function(name) {
  if (!require(name, character.only = TRUE)) {
    install.packages(name, dep = TRUE)
    if (!require(name, character.only = TRUE))
      stop(paste('Package', name, 'not found'))
  }
}
