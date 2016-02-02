# Version 0.3.8
  
  * Ensure that the pacakge is brought into memory using `require` even if the package is already installed.

# Version 0.3.7

  * Make sure a package exists before checking it for version mismatches.

# Version 0.3.6

  * Fix more ref-related package name problems. :(

# Version 0.3.5

  * Fix the way the package is removed during a version mismatch, given the correct name. :(

# Version 0.3.4

  * Fix the way the package version is being passed into version mismatch testing. :(

# Versoin 0.3.3
  
  * Fix problem where version mismatch removal was not actually taking place. :(

# Version 0.3.2

  * Fix very bad problem where all package installations resulted in errors. :(

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
