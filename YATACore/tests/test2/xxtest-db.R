context("Test Database")

test_that("Database correct", {
   db = MARIADB$new()

   expect_true(!is.null(db))
   sf = system.file("extdata", "default.ini", package=packageName())
   cfg = configr::read.config(sf)
   # Check connection
   db$connect(cfg$test)
   expect_equal(db$connects(), 1)

   # Check multiple connections
   db$connect(cfg$test)
   expect_equal(db$connects(), 2)

   # Check disconnect
   db$disconnect()
   expect_equal(db$connects(), 1)

   # Check No connection
   cnx = db$disconnect()
   expect_null(cnx)

})
