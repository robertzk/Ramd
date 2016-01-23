# Version 0.3.1

  * `packages` now brings the package into memory using `require`, which was the pre-0.3 functionality.

# Version 0.3

  * `packages` will now install from GitHub when the package name contains a '/'.
  * `packages` will now take `verbose = TRUE` to announce the installations.
  * Add test coverage for `packages` and `load_package`.
  * Deprecate space separation for `packages` (instead, must pass multiple arguments).

# Version 0.2.1

 * The `define` function takes an `envir` argument that can be used
   to specify what parent environment to use when sourcing dependencies
   (under the hood, this is done with `base::source`).
