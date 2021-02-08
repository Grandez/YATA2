context("Transfer to cash")

# Ingresar  1000 a control
# Ingresar  2000 a control
# Recuperar 3000
initDB()
oper     = YATAFactory$getObject(YATACodes$object$operation)
cameras  = YATAFactory$getObject(YATACodes$object$cameras)
position = YATAFactory$getObject(YATACodes$object$position)

test_that("Transfer External 1000", {
   oper$add( type = YATACodes$oper$xfer
            ,from="EXT"
            ,to="CASH"
            ,amount=1000
            ,currency="EUR")

   expect_equal(nrow(cameras$getCameras()),  1)
   expect_equal(length(position$getCameras()), 1)

   opers = oper$getOperationsExt()
   oper$select(opers[1,"id"],full=TRUE)

   expect_equal(nrow(opers),  1)
   expect_equal(oper$current$amount, 1000)
   expect_equal(nrow(oper$getFlows()),  1)

})

test_that("Transfer External 2000", {
   oper$xfer(from="EXT"
            ,to="CASH"
            ,amount=2000
            ,currency="EUR")

   expect_equal(nrow(cameras$getCameras()),  1)
   expect_equal(length(position$getCameras()), 1)

   opers = oper$getOperationsExt()
   expect_equal(nrow(opers),  2)
   df = position$getCameraPosition("CASH")
   expect_equal(df[1,"balance"],  3000)
})

test_that("Transfer Return all", {
   oper$xfer(from="CASH"
            ,to="EXT"
            ,amount=3000
            ,currency="EUR")

   expect_equal(nrow(cameras$getCameras()),  1)
   expect_equal(length(position$getCameras()), 1)

   opers = oper$getOperationsExt()
   expect_equal(nrow(opers),  3)
   df = position$getCameraPosition("CASH")
   expect_equal(df[1,"balance"],  0)
})
