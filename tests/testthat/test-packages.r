context("packages")
library(testthatsomemore)

with_mock(
  `Ramd:::load_package` = function(package) { install_count <<- install_count + 1; TRUE }, {
    test_that("it can install from CRAN", {
      install_count <<- 0
      expect_equal(0, install_count)
      expect_true(packages("glmnet"))
      expect_equal(1, install_count)
    })

    test_that("it can install from GitHub", {
      install_count <<- 0
      expect_equal(0, install_count)
      expect_true(packages("robertzk/Ramd"))
      expect_equal(1, install_count)
    })

    test_that("it can install twice from CRAN", {
      install_count <<- 0
      expect_equal(0, install_count)
      expect_true(packages("glmnet", "dplyr"))
      expect_equal(2, install_count)
    })

    test_that("it can install twice from GitHub", {
      install_count <<- 0
      expect_equal(0, install_count)
      expect_true(packages("robertzk/Ramd", "hadley/dplyr"))
      expect_equal(2, install_count)
    })

    test_that("it can install twice from a mix of both remotes", {
      install_count <<- 0
      expect_equal(0, install_count)
      expect_true(packages("robertzk/Ramd", "dplyr"))
      expect_equal(2, install_count)
    })

    test_that("it can install three times", {
      install_count <<- 0
      expect_equal(0, install_count)
      expect_true(packages("robertzk/Ramd", "dplyr", "glmnet"))
      expect_equal(3, install_count)
    })

    test_that("it can install on a package version", {
      install_count <<- 0
      expect_equal(0, install_count)
      expect_true(packages("robertzk/Ramd@v0.3", "dplyr@1.0", "glmnet@abc123"))
      expect_equal(3, install_count)
    })

    test_that("it can install a subdir", {
      install_count <<- 0
      expect_equal(0, install_count)
      expect_true(packages(list("FeiYeYe/xgboost", subdir = "R-package")))
      expect_equal(1, install_count)
    })

    test_that("it can install a subdir and something else", {
      install_count <<- 0
      expect_equal(0, install_count)
      expect_true(packages(list("FeiYeYe/xgboost", subdir = "R-package"), "glmnet"))
      expect_equal(2, install_count)
    })

    test_that("it installs uniquely", {
      install_count <<- 0
      expect_equal(0, install_count)
      expect_true(packages("glmnet", "glmnet", "dplyr", "dplyr"))
      expect_equal(2, install_count)
    })
  })
