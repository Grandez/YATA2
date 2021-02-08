context("Database Base")

test_that("Base Database", {
   DBfact = YATADBFactory$new()
   dbb = DBfact$getDB(cfg$base)

   expect_true("YATA.DB" %in% class(dbb))
   expect_equal(dbb$name, "Base")
})

