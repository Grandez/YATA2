context("Transfer internal")

initDB()
oper     = YATAFactory$getObject(YATACodes$object$operation)
cameras  = YATAFactory$getObject(YATACodes$object$cameras)
position = YATAFactory$getObject(YATACodes$object$position)

test_that("Transfer External 2000", {
   # Ingresar 1000 a Control
   oper$xfer(from="EXT"
            ,to="CASH"
            ,amount=2000
            ,currency="EUR")

   expect_equal(nrow(cameras$getCameras()),  1)
   expect_equal(length(position$getCameras()), 1)

   opers = oper$getOperationsExt()
   oper$select(opers[1,"id"],full=TRUE)

   expect_equal(nrow(opers),  1)
   expect_equal(oper$current$amount, 2000)
   expect_equal(nrow(oper$getFlows()),  1)

})

test_that("Transfer Test 1000", {
   # Transferir 1000 a TEST
   # Crea la posicion
   oper$xfer(from="CASH"
            ,to="TEST"
            ,amount=1000
            ,currency="EUR")

   expect_equal(nrow(cameras$getCameras()),  1)
   expect_equal(length(position$getCameras()), 2)
   cam1 = position$getCameraPosition("CASH")
   expect_equal(cam1[1,"available"],  1000)
   expect_equal(cam1[1,"balance"],    1000)
   cam1 = position$getCameraPosition("TEST")
   expect_equal(cam1[1,"available"],  1000)
   expect_equal(cam1[1,"balance"],    1000)

   flows = YATAFactory$getTable(YATACodes$tables$Flows, force=TRUE)
   expect_equal(flows$rows(),    3)
})

