context('define')
library(testthatsomemore)

test_that('it can include a simple file', {
  within_file_structure(list(one.R = 'Ramd::define("two", function(two) { two + 1 })',
                             two.R = '1 + 1'), {
    expect_identical(source(file.path(tempdir, 'one.R'))$value, 3)
  })
})

test_that("it can include a file in a parent directory", {
  within_file_structure(list(one = list(one.R = 'Ramd::define("../two", function(two) { two + 1 })'),
                             two.R = '1 + 1'), {
    expect_identical(source(file.path(tempdir, 'one', 'one.R'))$value, 3)
  })
})

test_that("it can include a file in a subdirectory", {
  within_file_structure(list(one.R = 'Ramd::define("two/two", function(two) { two + 1 })',
                             two = list(two.R = '1 + 1')), {
    expect_identical(source(file.path(tempdir, 'one.R'))$value, 3)
  })
})

test_that("it can use the local parameter", {
  within_file_structure(list(one.R = 'one <- 1; Ramd::define("two", local = TRUE, function(one) { one + 1 })',
                             two.R = 'one'), {
    expect_identical(source(file.path(tempdir, 'one.R'))$value, 2)
  })
})

# TODO: (RK) Check global namespace pollution

