context("Changing Parameters Object")


test_that("Change Database", {
   YATAFactory$changeDB("Simulacion")

   expect_equal (YATAFactory$getDB()$name, "Simulacion")
})

