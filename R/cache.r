#' Simple caching mechanism
#' http://r.789695.n4.nabble.com/what-is-the-preferred-method-to-create-a-package-local-variable-tp923040p923052.html
cache <- function() {
  .cache <- list()

  list(
    get = function(key = NULL) {
      if (is.null(key)) .cache
      else .cache[[key]]
    },
    getNames = function() names(.cache),
    set = function(value, key = NULL) {
      if (is.null(key)) .cache <<- value
      else .cache[[key]] <<- value
    }
  )
}

