context("Buy Operation simple")

initDB()

oper     = YATAFactory$getObject(YATACodes$object$operation)
cameras  = YATAFactory$getObject(YATACodes$object$cameras)
position = YATAFactory$getObject(YATACodes$object$position)

test_that("Environment correct", {
   oper$xfer(from="EXT"
            ,to="CASH"
            ,amount=2000
            ,currency="EUR")
   oper$xfer(from="CASH"
            ,to="TEST"
            ,amount=2000
            ,currency="EUR")
   cam1 = position$getCameraPosition("TEST")
   expect_equal(cam1[1,"available"],  2000)
   expect_equal(cam1[1,"balance"],    2000)

})

test_that("Open 10 BTC", {
   idOper <<- oper$buy(camera  = "TEST"
                       ,base    = "EUR"
                       ,counter = "BTC"
                       ,amount  = 10
                       ,price   = 100
   )
   expect_true(idOper > 0, label = "Buying BTC")
   expect_equal(nrow(oper$getOperations()), 1, label="Unica operacion activa")

   lstOper = oper$getOperation(idOper)
   expect_equal(lstOper$status, YATACodes$status$pending, label="Estado es pendiente")
   expect_equal(lstOper$active, YATACodes$flag$active,    label="Operacion activa")

   expect_equal(nrow(cameras$getCameras()),  1)
   expect_equal(length(position$getCameras()), 2)
   cam1 = position$getCameraPosition("CASH")
   expect_equal(cam1[1,"available"],  0)
   expect_equal(cam1[1,"balance"],    0)
   cam1 = position$getCameraPosition("TEST")
   expect_equal(cam1[1,"available"],  1000)
   expect_equal(cam1[1,"balance"],    2000)

   flows = YATAFactory$getTable(YATACodes$tables$Flows, force=TRUE)
   expect_equal(flows$rows(),    3)

})

test_that("Accept Operation default", {
   oper$select(idOper)
   oper$accept()

   lstOper = oper$getOperation(idOper)
   expect_equal(lstOper$status, YATACodes$status$accepted, label="Estado es aceptada")
   expect_equal(lstOper$active, YATACodes$flag$active,     label="Operacion activa")

   cam1 = position$getCameraPosition("TEST")
   expect_equal(cam1[1,"available"],  1000)
   expect_equal(cam1[1,"balance"],    1000)

   flows = YATAFactory$getTable(YATACodes$tables$Flows, force=TRUE)
   expect_equal(flows$rows(),    4)
})

test_that("Execute Operation default", {
   oper$select(idOper)
   oper$execute()

   lstOper = oper$getOperation(idOper)
   expect_equal(lstOper$status, YATACodes$status$executed, label="Estado es aceptada")
   expect_equal(lstOper$active, YATACodes$flag$inactive,   label="Operacion acabada")

   cam1 = position$getCameraPosition("TEST")
   expect_equal(cam1[cam1$currency == "EUR","balance"], 1000)
   expect_equal(cam1[cam1$currency == "BTC","balance"],   10)

   flows = YATAFactory$getTable(YATACodes$tables$Flows, force=TRUE)
   expect_equal(flows$rows(),    5)
})
