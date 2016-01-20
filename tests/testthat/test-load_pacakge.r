context("load_package")
library(testthatsomemore)

describe("package already installed", {
  describe("within load_package", {
    with_mock(
      `package_is_installed` = function(...) TRUE,
      `devtools::install_github` = function(...) { stop("No installing!") },
      `install.packages` = function(...) { stop("No installing!") }, {
        test_that("it will not install if already installed", {
          expect_true(load_package("glmnet"))
        })
        test_that("it messages if it is already installed and verbose is TRUE", {
          expect_message(load_package("glmnet", verbose = TRUE), "already installed")
        })
        test_that("it does not message if it is already installed and verbose is FALSE", {
          expect_silent(load_package("glmnet", verbose = FALSE))
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
    test_that("it removes the package if there is a version mismatch", {
      with_mock(
        `is_version_mismatch` = function(name) { TRUE },
        `devtools::install_github` = function(...) { "No installing!" },
        `install.packages` = function(...) { "No installing!" },
        `remove.packages` = function(name) { called <<- TRUE }, {
          called <<- FALSE
          expect_false(called)
          expect_error(load_package("glmnet"))  # because glmnet is not actually installed
          expect_true(called)
        })
      })
    })
    test_that("it does not remove the package if there is not a version mismatch", {
      with_mock(
        `is_version_mismatch` = function(name) { FALSE },
        `devtools::install_github` = function(...) { "No installing!" },
        `install.packages` = function(...) { "No installing!" },
        `remove.packages` = function(name) { called <<- TRUE }, {
          called <<- FALSE
          expect_false(called)
          expect_error(load_package("glmnet"))  # because glmnet is not actually installed
          expect_false(called)
        })
      })
    })

  describe("is_version_mismatch helper function", {
    with_mock(
      `packageVersion` = function(name) { package_version("1.1") }, {
        expect_true(is_version_mismatch("robertzk/Ramd@v1.0"))
        expect_true(is_version_mismatch("robertzk/Ramd@v1.2"))
        expect_true(is_version_mismatch("robertzk/Ramd@v1.1.3"))
        expect_true(is_version_mismatch("robertzk/Ramd@1.0"))
        expect_false(is_version_mismatch("robertzk/Ramd@v1.1"))
        expect_false(is_version_mismatch("robertzk/Ramd@1.1"))
        expect_false(is_version_mismatch("robertzk/Ramd"))
        expect_false(is_version_mismatch("Ramd"))
      }
    )
  })

describe("it can install from CRAN", {
  with_mock(
    `devtools::install_github` = function(...) { stop("Wrong installer!") },
    `stop` = function(...) { TRUE }, #Avoid crashing since we aren't really installing
    `install.packages` = function(...) { "correct installer!" }, {
    test_that("it installs", {
      expect_true(load_package("glmnet"))
    })
    test_that("it messages if verbose is TRUE", {
      expect_message(load_package("glmnet", verbose = TRUE), "Installing")
    })
    test_that("it messages the remote correctly", {
      expect_message(load_package("glmnet", verbose = TRUE), "CRAN")
    })
    test_that("it does not message if verbose is FALSE", {
      expect_silent(load_package("glmnet", verbose = FALSE))
    })
  })
  with_mock(
    `devtools::install_github` = function(...) { stop("Wrong installer!") },
    `install.packages` = function(...) { "correct installer!" },
    `package_is_installed` = function(...) { FALSE }, {
      test_that("if package isn't on CRAN, that's an error", {
        expect_error(load_package("bozo"), "not found")
      })
    })
  })

describe("it can install from GitHub", {
  describe("within load_package", {
    with_mock(
      `devtools::install_github` = function(...) { "Correct installer!" },
      `package_is_installed` = function(...) { FALSE },
      `stop` = function(...) { TRUE }, #Avoid crashing since we aren't really installing
      `install.packages` = function(...) { stop("Wrong installer!") }, {
        test_that("it installs", {
          expect_true(load_package("robertzk/Ramd"))
        })
        test_that("it messages the remote correctly", {
          expect_message(load_package("robertzk/Ramd", verbose = TRUE), "GitHub")
        })
      })
      with_mock(
        `devtools::install_github` = function(...) { "Correct installer" },
        `install.packages` = function(...) { stop("Wrong installer!") },
        `package_is_installed` = function(...) { FALSE }, {
        test_that("if package isn't on CRAN, that's an error", {
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
  test_that("name_from_github_name helper function", {
    expect_equal("dplyr", name_from_github_name("hadley/dplyr"))
    expect_equal("Ramd", name_from_github_name("robertzk/Ramd"))
    expect_equal("R6", name_from_github_name("wch/R6@v1.1"))
    expect_equal("batchman", name_from_github_name("peterhurford/batchman@1.1"))
    expect_equal("ggplot2", name_from_github_name("hadley/ggplot2@ref123abc"))
  })
})