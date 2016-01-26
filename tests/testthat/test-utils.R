context("utils")

describe("ensure_devtools_installed", {
  test_that("it works when devtools is installed", {
    with_mock(`Ramd:::package_is_installed` = function(...) TRUE,
      expect_true(ensure_devtools_installed())
    )
  })
  test_that("it errors when devtools isn't installed", {
    with_mock(`Ramd:::package_is_installed` = function(...) FALSE,
      expect_error(ensure_devtools_installed())
    )
  })
})
