# Version 0.3

  * `packages` will now install from GitHub when the package name contains a '/'.
  * `packages` will now take `verbose = TRUE` to announce the installations.

# Version 0.2.1

 * The `define` function takes an `envir` argument that can be used
   to specify what parent environment to use when sourcing dependencies
   (under the hood, this is done with `base::source`).
