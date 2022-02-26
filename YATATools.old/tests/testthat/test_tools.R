context("Tools")
library(YATATools)

test_that("ID is numeric", {
    expect_true(is.numeric(getID()))
})
#> Test passed 🥳

test_that("ID is unique", {
    id1 = getID()
    expect_true(getID() > id1)
})
#> Test passed 🥳

test_that("HashMap is correct", {
  hmap = HashMap$new()
  expect_true("JGG.HASHMAP" %in% class(hmap))
})
#> Test passed 🥳

test_that("HashMap with integer keys", {
  hmap = HashMap$new()
  hmap$put(1,11)
  hmap$put(2,22)

  expect_equal(hmap$length(), 2)
  expect_equal(hmap$get(2),  22)
})
#> Test passed 🥳

test_that("HashMap with string keys", {
  hmap = HashMap$new()
  hmap$put("A",11)
  hmap$put("B",22)

  expect_equal(hmap$length(), 2)
  expect_equal(hmap$get("B"), 22)
})
#> Test passed 🥳

test_that("HashMap with string values", {
  hmap = HashMap$new()
  hmap$put("A","11")
  hmap$put("B","22")

  expect_equal(hmap$length(), 2)
  expect_equal(hmap$get("B"), "22")
})
#> Test passed 🥳
