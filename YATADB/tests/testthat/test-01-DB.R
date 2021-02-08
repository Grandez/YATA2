context("Test Database Factory")

test_that("Factory correct", {
   fact = YATADBFactory$new()

   expect_true(!is.null(fact))
   expect_true("YATA.DB.FACTORY" %in% class(fact))
   # sf = system.file("extdata", "default.ini", package=packageName())
   # cfg = configr::read.config(sf)
   # # Check connection
   # db$connect(cfg$test)
   # expect_equal(db$connects(), 1)
   #
   # # Check multiple connections
   # db$connect(cfg$test)
   # expect_equal(db$connects(), 2)
   #
   # # Check disconnect
   # db$disconnect()
   # expect_equal(db$connects(), 1)
   #
   # # Check No connection
   # cnx = db$disconnect()
   # expect_null(cnx)

})

test_that("Base Database", {
   DBfact = YATADBFactory$new()
   dbb = DBfact$getDB(cfg$base)

   expect_true("YATA.DB" %in% class(dbb))
   expect_equal(dbb$name, "Base")
})

test_that("Test Database", {
   DBfact = YATADBFactory$new()
   dbt = DBfact$getDB()

   expect_null(dbt)

   dbt = DBfact$getDB(cfg$test)
   expect_equal(dbt$name, "Test")

   dbt2 = DBfact$getDB()
   expect_equal(dbt$name, "Test")

})
