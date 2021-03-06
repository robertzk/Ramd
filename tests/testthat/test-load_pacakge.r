context("load_package")
library(testthatsomemore)

check_for_refs <- function(name) {
  if (grepl("@", name, fixed = TRUE) || grepl("/", name, fixed = TRUE)) {
    stop("You attempted to test ", name, " which has a bad ref.")
  }
}

describe("package already installed", {
  describe("within load_package", {
    with_mock(
      `Ramd:::package_is_installed` = function(name) { check_for_refs(name); TRUE },
      `devtools::install_github` = function(...) { stop("No installing!") },
      `require` = function(name, ...) { check_for_refs(name); called <<- TRUE },
      `utils::install.packages` = function(...) { stop("No installing!") }, {
        test_that("it will not install if already installed", {
          expect_true(load_package("glmnet"))
        })
        test_that("it messages if it is already installed and verbose is TRUE", {
          expect_message(load_package("glmnet", verbose = TRUE), "already installed")
        })
        test_that("it does not message if it is already installed and verbose is FALSE", {
          expect_silent(load_package("glmnet", verbose = FALSE))
        })
        test_that("the pacakge is loaded into memory", {
          called <<- FALSE
          expect_false(called)
          expect_true(load_package("glmnet"))
          expect_true(called)
        })
      })
  })
  describe("package_is_installed helper", {
    with_mock(`utils::installed.packages` = function() { data.frame(name = "glmnet") }, {
      test_that("it works", {
        expect_true(package_is_installed("glmnet"))
        expect_false(package_is_installed("Ramd"))
      })
    })
  })
})

describe("version mismatching", {
  describe("within load_package", {
    with_mock(
      `Ramd:::is_version_mismatch` = function(name) { TRUE },
      `devtools::install_github` = function(...) { "No installing!" },
      `utils::install.packages` = function(...) { "No installing!" },
      `utils::packageVersion` = function(name) { check_for_refs(name); package_version("1.1") },
      `utils::remove.packages` = function(name) { check_for_refs(name); called <<- TRUE }, {
        test_that("it removes the package if it is not already installed", {
          with_mock(`Ramd:::package_is_installed` = function(...) { FALSE }, {
            called <<- FALSE
            expect_false(called)
            expect_error(load_package("robertzk/Ramd@v1.2"))
            expect_true(called)
          })
        })
        test_that("it removes the package even if it is already installed", {
          with_mock(
            `Ramd:::package_is_installed` = function(name) { check_for_refs(name); TRUE }, {
            called <<- FALSE
            expect_false(called)
            expect_true(load_package("robertzk/Ramd@v1.2"))
            expect_true(called)
          })
        })
      })
    })
    test_that("it does not remove the package if there is not a version mismatch", {
      with_mock(
        `Ramd:::is_version_mismatch` = function(name) { FALSE },
        `Ramd:::package_is_installed` = function(name) { check_for_refs(name); FALSE },
        `devtools::install_github` = function(...) { "No installing!" },
        `utils::install.packages` = function(...) { "No installing!" },
        `utils::remove.packages` = function(name) { check_for_refs(name); called <<- TRUE }, {
          called <<- FALSE
          expect_false(called)
          expect_error(load_package("glmnet"))
          expect_false(called)
        })
      })
    })

  describe("is_version_mismatch helper function", {
    with_mock(
      `utils::packageVersion` = function(name) { check_for_refs(name); package_version("1.1") },
      `Ramd:::package_is_installed` = function(name) { check_for_refs(name); TRUE }, {
        test_that("it works on lower versions", {
          expect_true(is_version_mismatch("robertzk/Ramd@v1.0"))
          expect_true(is_version_mismatch("robertzk/Ramd@1.0"))
          expect_true(is_version_mismatch("robertzk/Ramd@0.9"))
        })
        test_that("it works on higher versions", {
          expect_true(is_version_mismatch("robertzk/Ramd@v1.2"))
          expect_true(is_version_mismatch("robertzk/Ramd@v1.1.3"))
        })
        test_that("it matches on exact versions", {
          expect_false(is_version_mismatch("robertzk/Ramd@v1.1"))
          expect_false(is_version_mismatch("robertzk/Ramd@1.1"))
        })
        test_that("no mismatch if no version is supplied", {
          expect_false(is_version_mismatch("robertzk/Ramd"))
          expect_false(is_version_mismatch("Ramd"))
        })
        test_that("no mismatches for refs or branches", {
          expect_false(is_version_mismatch("robertzk/Ramd@1.1-thebranch"))
          expect_false(is_version_mismatch("robertzk/Ramd@vrefefrefref"))
        })
        test_that("it works if the author's name has a v", {
          expect_true(is_version_mismatch("ihaveavinmyname/Ramd@1.2"))
          expect_true(is_version_mismatch("ihaveavinmyname/Ramd@v1.2"))
          expect_true(is_version_mismatch("ihaveavinmyname/Ramd@v1.1.3"))
          expect_true(is_version_mismatch("ihaveavinmyname/Ramd@v1.0"))
          expect_false(is_version_mismatch("ihaveavinmyname/Ramd@v1.1"))
          expect_true(is_version_mismatch("ihaveavinmyname/andavinmypackage@v1.0"))
          expect_false(is_version_mismatch("ihaveavinmyname/andavinmypackage@v1.1"))
          expect_true(is_version_mismatch("ihaveavinmyname/andavinmypackage@v1.2"))
          expect_false(is_version_mismatch("ihaveavinmyname/Ramd"))
        })
      }
    )
  })

describe("it can install from CRAN", {
  with_mock(
    `devtools::install_github` = function(...) { stop("Wrong installer!") },
    `stop` = function(...) { TRUE }, #Avoid crashing since we aren't really installing
    `require` = function(name, ...) { check_for_refs(name); called <<- TRUE },
    `utils::install.packages` = function(...) { "correct installer!" }, {
    test_that("it installs", {
      expect_true(load_package("glmnet"))
    })
    test_that("the pacakge is loaded into memory", {
      called <<- FALSE
      expect_false(called)
      expect_true(load_package("glmnet"))
      expect_true(called)
    })
    test_that("it messages if verbose is TRUE", {
      with_mock(
        `Ramd:::package_is_installed` = function(name) { check_for_refs(name); FALSE },
        expect_message(load_package("glmnet", verbose = TRUE), "Installing")
      )
    })
    test_that("it messages the remote correctly", {
      with_mock(
        `Ramd:::package_is_installed` = function(name) { check_for_refs(name); FALSE },
        expect_message(load_package("glmnet", verbose = TRUE), "CRAN")
      )
    })
    test_that("it does not message if verbose is FALSE", {
      expect_silent(load_package("glmnet", verbose = FALSE))
    })
  })
  with_mock(
    `devtools::install_github` = function(...) { stop("Wrong installer!") },
    `utils::install.packages` = function(...) { "correct installer!" },
    `Ramd:::ensure_devtools_installed` = function(...) { TRUE },
    `Ramd:::package_is_installed` = function(name) { check_for_refs(name); FALSE }, {
      test_that("if package isn't on CRAN, that's an error", {
        expect_error(load_package("bozo"), "not found")
      })
    })
  })

describe("it can install from GitHub", {
  describe("within load_package", {
    with_mock(
      `devtools::install_github` = function(...) { "Correct installer!" },
      `Ramd:::package_is_installed` = function(name) { check_for_refs(name); FALSE },
      `stop` = function(...) { TRUE }, #Avoid crashing since we aren't really installing
      `require` = function(name, ...) { check_for_refs(name); TRUE },
      `utils::install.packages` = function(...) { stop("Wrong installer!") }, {
        test_that("it installs", {
          expect_true(load_package("robertzk/Ramd"))
        })
        test_that("it messages the remote correctly", {
          expect_message(load_package("robertzk/Ramd", verbose = TRUE), "GitHub")
        })
    })
    with_mock(
      `devtools::install_github` = function(...) { captured_args <<- list(...) },
      `Ramd:::package_is_installed` = function(name) { check_for_refs(name); FALSE },
      `Ramd:::ensure_devtools_installed` = function(...) { TRUE },
      `utils::install.packages` = function(...) { stop("Wrong installer!") }, {
        test_that("it installs from a subdir", {
          expect_error(load_package(list("FeiYeYe/xgboost", subdir = "R-package")))
          expect_equal(captured_args[[1]], "FeiYeYe/xgboost")
          expect_equal(captured_args$subdir, "R-package")
        })
    })
    with_mock(
      `devtools::install_github` = function(...) { "Correct installer" },
      `Ramd:::ensure_devtools_installed` = function(...) { TRUE },
      `utils::install.packages` = function(...) { stop("Wrong installer!") },
      `Ramd:::package_is_installed` = function(name) { check_for_refs(name); FALSE }, {
      test_that("if package isn't on GitHub, that's an error", {
        expect_error(load_package("bozo/bozo"), "not found")
      })
    })
  })
  describe("is_github_package helper function", {
    expect_true(is_github_package("hadley/dplyr"))
    expect_true(is_github_package("robertzk/Ramd"))
    expect_true(is_github_package("wch/R6@v1.1"))
    expect_true(is_github_package("peterhurford/batchman@1.1"))
    expect_true(is_github_package("hadley/ggplot2@ref123abc"))
    expect_false(is_github_package("glmnet"))
    expect_false(is_github_package("dplyr"))
  })
  test_that("get_package_name_from_ref helper function", {
    expect_equal("dplyr", get_package_name_from_ref("hadley/dplyr"))
    expect_equal("Ramd", get_package_name_from_ref("robertzk/Ramd"))
    expect_equal("R6", get_package_name_from_ref("wch/R6@v1.1"))
    expect_equal("batchman", get_package_name_from_ref("peterhurford/batchman@1.1"))
    expect_equal("ggplot2", get_package_name_from_ref("hadley/ggplot2@ref123abc"))
  })
})
